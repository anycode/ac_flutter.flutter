import 'dart:async';

import 'package:ac_flutter/ac_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AcResourcesWidgetBuilder<RES extends AcResources> = Widget Function(BuildContext context, RES resources, Widget? child);

final class AcLocalization {
  /// Returns the [AcResourcesBuilderState] for the given [context].
  /// Used to get instance of [AcResourcesBuilder] for easily setting of locale
  static AcResourcesBuilderState? maybeOf(BuildContext context) => context.findRootAncestorStateOfType<AcResourcesBuilderState>();

  /// Returns the [AcResourcesBuilderState] for the given [context].
  /// Used to get instance of [AcResourcesBuilder] for easily setting of locale
  static AcResourcesBuilderState of(BuildContext context) {
    final state = context.findRootAncestorStateOfType<AcResourcesBuilderState>();
    if (state == null) {
      throw FlutterError(
        'AcLocalization operation requested with a context that does not include a AcResourcesBuilder.\n'
        'The context used must be that of a widget that is a descendant of a AcResourcesBuilder widget.',
      );
    }
    return state;
  }
}

class AcResourcesBuilder<RES extends AcResources> extends StatefulWidget {
  /// [child] is used as optional static widget passed to [builder]
  final Widget? child;

  /// [builder] is called when resources are available
  final AcResourcesWidgetBuilder<RES> builder;

  /// [loadingBuilder] is called when waiting for data, if not specified
  /// empty [Container] is used
  final WidgetBuilder? loadingBuilder;

  /// Default locale used if no locale is saved in shared preferences
  final Locale? defaultLocale;

  const AcResourcesBuilder({required this.builder, this.loadingBuilder, this.child, this.defaultLocale, super.key});

  @override
  AcResourcesBuilderState createState() => AcResourcesBuilderState<RES>();
}

class AcResourcesBuilderState<RES extends AcResources> extends State<AcResourcesBuilder<RES>> {
  // Reinit resources on locale change
  late final StreamController<RES> _resources;

  Locale? _locale;
  Locale? get locale => _locale;
  set locale(Locale? locale) {
    if (locale == _locale) return;
    SharedPreferences.getInstance().then((prefs) {
      if (_locale != null) {
        prefs.setString('lang', locale!.languageCode);
        _loadResources(locale);
      } else {
        prefs.remove('lang');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _resources = StreamController<RES>();
    // init Resource with saved/default locale
    SharedPreferences.getInstance().then((prefs) {
      final lc = prefs.getString('lang');
      _loadResources(lc != null ? AcResLocales.byLangCode(lc) : widget.defaultLocale ?? AcResLocales.defaultLocale);
    });
  }

  @override
  void deactivate() {
    _resources.close();
    super.deactivate();
  }

  void _loadResources(Locale locale) {
    /// load resources manually to have it available in build(). It's not
    /// possible to call [Resources res = Resources.of(context);] in build()
    /// as it returns null in this widget. It works in other widgets in
    /// the subtree.
    AcResources.delegate.load(locale).then((res) {
      _resources.add(res as RES);
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AcLoadingBuilder<RES>(
      stream: _resources.stream,
      builder: (context, res) => widget.builder(context, res, widget.child),
      loadingBuilder: widget.loadingBuilder,
    );
  }
}
