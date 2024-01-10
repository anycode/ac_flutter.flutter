import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/resources.dart';

class AppLocalization extends StatefulWidget {
  final Widget? child;
  final Function(BuildContext context, Locale? locale, Widget? child)? builder;

  const AppLocalization({this.child, this.builder, super.key})
      : assert(builder != null || child != null);

  @override
  AppLocalizationState createState() => AppLocalizationState();

  static AppLocalizationState? of(BuildContext context) => context.findRootAncestorStateOfType<AppLocalizationState>();
}

class AppLocalizationState extends State<AppLocalization> {
  // Reinit resources on locale change
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
    // init Resource with saved/default locale
    SharedPreferences.getInstance().then((prefs) {
      final lc = prefs.getString('lang');
      final locale = ResLocales.byLangCode(lc);
      _loadResources(locale);
    });
  }

  void _loadResources(Locale locale) {
    /// load resources manually to have it available in build(). It's not
    /// possible to call [Resources res = Resources.of(context);] in build()
    /// as it returns null in this widget. It works in other widgets in
    /// the subtree.
    Resources.delegate.load(locale).then((_) => setState(() => _locale = locale));
  }

  @override
  Widget build(BuildContext context) => widget.builder?.call(context, _locale, widget.child) ?? widget.child;
}
