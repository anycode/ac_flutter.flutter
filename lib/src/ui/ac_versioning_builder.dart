import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version_banner/version_banner.dart';

import 'widgets/ac_loading_builder.dart';
import 'widgets/ac_widget_builder.dart';

/// Callback builder which is called when current app version is lower than
/// minimal (required) version
typedef OutdatedAppWidgetBuilder = Widget Function(BuildContext context, int appVersion, int minVersion);

class AcVersioningBuilder extends StatefulWidget {
  /// Builder called when app version meets minimal version
  final AcWidgetBuilder? builder;

  /// If [builder] is not specified, [child] must be specified and
  /// is displayed when app version meets minimal version.
  /// If [builder] is specified, [child] is optional and eventually
  /// passed to the builder.
  final Widget? child;

  /// [outdatedAppBuilder] is called when app is outdated
  final OutdatedAppWidgetBuilder outdatedAppBuilder;

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

  const AcVersioningBuilder({
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
  AcVersioningBuilderState createState() => AcVersioningBuilderState();
}

class AcVersioningBuilderState extends State<AcVersioningBuilder> with WidgetsBindingObserver {
  late StreamController<int> _versions;
  late StreamController<int> _minVersion;

  @override
  void initState() {
    _versions = StreamController<int>();
    _minVersion = StreamController<int>();
    _minVersion.addStream(widget.minVersionStream);
    WidgetsBinding.instance.addObserver(this);
    _getVersion();
    super.initState();
  }

  @override
  void dispose() {
    _versions.close();
    _minVersion.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AcLoadingBuilder<int>(
        stream: _minVersion.stream,
        errorBuilder: (context, error) => widget.errorBuilder?.call(context) ?? ErrorWidget.withDetails(message: 'Error reading minVersionStream'),
        emptyBuilder: (context) => widget.loadingBuilder?.call(context) ?? Container(),
        builder: (context, minVersion) {
          return AcLoadingBuilder<int>(
            stream: _versions.stream,
            errorBuilder: (context, error) => widget.errorBuilder?.call(context) ?? ErrorWidget.withDetails(message: 'Error reading appVersionStream'),
            emptyBuilder: (context) => widget.loadingBuilder?.call(context) ?? Container(),
            builder: (context, currentVersion) {
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
