import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version_banner/version_banner.dart';

import 'widgets/widget_builder.dart';

/// Callback builder which is called when current app version is lower than
/// minimal (required) version
typedef OutdatedAppBuilder = Widget Function(BuildContext context, int appVersion, int minVersion);

class AppVersioning extends StatefulWidget {
  /// Builder called when app version meets minimal version
  final AcWidgetBuilder? builder;

  /// If [builder] is not specified, [child] must be specified and
  /// is displayed when app version meets minimal version.
  /// If [builder] is specified, [child] is optional and eventually
  /// passed to the builder.
  final Widget? child;

  /// [outdatedAppBuilder] is called when app is outdated
  final OutdatedAppBuilder outdatedAppBuilder;

  /// [errorBuilder] is called when there is an error, if not specified
  /// default Flutter [ErrorWidget] is used
  final WidgetBuilder? errorBuilder;

  /// [loadingBuilder] is called when waiting for data, if not specified
  /// empty [Container] is used
  final WidgetBuilder? loadingBuilder;

  /// Stream which feeds series of min versions required. Min version can be
  /// fetched by the application from some REST API, Remote Config or other sources.
  final Stream<int> minVersionStream;

  /// Version is displayed in a banner only when the build has one of the extensions
  /// By default ['devel','test']
  final List<String>? showVersionBannerForExtensions;

  const AppVersioning({
    this.builder,
    this.child,
    required this.outdatedAppBuilder,
    required this.minVersionStream,
    this.errorBuilder,
    this.loadingBuilder,
    this.showVersionBannerForExtensions,
    super.key,
  }) : assert(builder != null || child != null, 'builder od child must be specified for AppVersioning');

  @override
  AppVersioningState createState() => AppVersioningState();
}

class AppVersioningState extends State<AppVersioning> with WidgetsBindingObserver {
  late StreamController<int> _versions;

  @override
  void initState() {
    _versions = StreamController<int>();
    WidgetsBinding.instance.addObserver(this);
    _getVersion();
    super.initState();
  }

  @override
  void dispose() {
    _versions.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.minVersionStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return widget.errorBuilder?.call(context) ?? ErrorWidget.withDetails(message: 'Error reading minVersionStream');
          }
          if (!snapshot.hasData) {
            return widget.loadingBuilder?.call(context) ?? Container();
          }
          final minVersion = snapshot.data!;
          return StreamBuilder<int>(
            stream: _versions.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return widget.errorBuilder?.call(context) ?? ErrorWidget.withDetails(message: 'Error reading appVersionStream');
              }
              if (!snapshot.hasData) {
                return widget.loadingBuilder?.call(context) ?? Container();
              }
              final currentVersion = snapshot.data!;
              return VersionBanner(
                packageExtensions: widget.showVersionBannerForExtensions ?? const ['devel', 'test'],
                location: BannerLocation.bottomStart,
                color: Colors.red[900]!,
                textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                child: currentVersion < minVersion
                    ? widget.outdatedAppBuilder(context, currentVersion, minVersion)
                    : widget.builder?.call(context, widget.child) ?? widget.child!,
              );
            },
          );
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('APP_STATE: $state');
    if (state == AppLifecycleState.resumed) {
      await _getVersion();
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user quit our app temporally
    } else if (state == AppLifecycleState.detached) {
      // app suspended
    }
  }

  Future _getVersion() {
    return PackageInfo.fromPlatform().then((pkgInfo) {
      debugPrint('getVersion: ${pkgInfo.buildNumber}');
      _versions.add(int.parse(pkgInfo.buildNumber));
    });
  }
}
