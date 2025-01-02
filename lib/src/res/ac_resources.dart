import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'ac_assets.dart';
part 'ac_colors.dart';
part 'ac_dimens.dart';
part 'ac_locales.dart';
part 'ac_strings.dart';
part 'ac_styles.dart';

typedef AcResourceCreator<T> = T Function(Locale locale);

abstract class AcResources<STR extends AcResStrings, COL extends AcResColors, DIM extends AcResDimens, AST extends AcResAssets, STY extends AcResStyles,
                        LOC extends AcResLocales> {
  static Future<bool> Function(String localeName)? initializeMessages;
  static AcResourceCreator<AcResources>? creator;

  static init<RES extends AcResources>({
    required Future<bool> Function(String localeName) initializeMessages,
    required AcResourceCreator<RES> creator,
  }) {
    AcResources.initializeMessages = initializeMessages;
    AcResources.creator = creator;
  }

  Locale _locale;
  abstract STR strings;
  abstract COL colors;
  abstract DIM dimens;
  abstract AST assets;
  abstract STY styles;
  abstract LOC locales;

  AcResources(Locale locale) : _locale = locale;

  Locale get locale => _locale;
  set locale(Locale locale) {
    debugPrint('It\'s not advised to change `locale` directly in Resources. Use `AcLocalization.of(context).locale` instead, '
        'which will reinit Resources with the new locale and rebuild the widget tree.');
    _locale = locale;
  }

  static RES? maybeOf<RES extends AcResources>(BuildContext context) => Localizations.of<RES>(context, RES);

  static RES of<RES extends AcResources>(BuildContext context) {
    final res = Localizations.of<RES>(context, RES);
    if (res == null) {
      throw FlutterError('Resources requested with a context that does not contain a Resources localizations.\n'
          'The context used must be that of a widget that is a descendant of a MaterialApp with a ResLocalizationDelegate '
          'or its descendant used in MaterialApp `localizationsDelegates` list.');
    }
    return res;
  }

  static AcResLocalizationsDelegate get delegate => const AcResLocalizationsDelegate<AcResources>();

  static Future<RES> load<RES extends AcResources>(Locale locale) {
    assert(AcResources.initializeMessages != null && AcResources.creator != null,
        'Messages initialization must be assigned by calling `Resources.init(...)`');
    final name = locale.countryCode?.isEmpty ?? true ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    Intl.defaultLocale = locale.toString();

    return AcResources.initializeMessages!(localeName).then((_) {
      return AcResources.creator!(locale) as RES;
    });
  }
}

class AcResLocalizationsDelegate<RES extends AcResources> extends LocalizationsDelegate<RES> {
  const AcResLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AcResLocales.locales.contains(locale);

  @override
  Future<RES> load(Locale locale) => AcResources.load<RES>(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<RES> old) => false;

}
