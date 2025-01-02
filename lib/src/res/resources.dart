import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'assets.dart';
part 'colors.dart';
part 'dimens.dart';
part 'locales.dart';
part 'strings.dart';
part 'styles.dart';

typedef ResourceCreator<T> = T Function(Locale locale);

/// [Resources] is deprecated since 0.2.0 and will be removed in next version.
@Deprecated('Use [AcResources] instead. [Resources] is deprecated will be removed in next version.')
abstract class Resources<STR extends ResStrings, COL extends ResColors, DIM extends ResDimens, AST extends ResAssets, STY extends ResStyles,
                        LOC extends ResLocales> {
  static Future<bool> Function(String localeName)? initializeMessages;
  static ResourceCreator<Resources>? creator;

  static init<RES extends Resources>({
    required Future<bool> Function(String localeName) initializeMessages,
    required ResourceCreator<RES> creator,
  }) {
    Resources.initializeMessages = initializeMessages;
    Resources.creator = creator;
  }

  Locale _locale;
  abstract STR strings;
  abstract COL colors;
  abstract DIM dimens;
  abstract AST assets;
  abstract STY styles;
  abstract LOC locales;

  Resources(Locale locale) : _locale = locale;

  Locale get locale => _locale;
  set locale(Locale locale) {
    debugPrint('It\'s not advised to change `locale` directly in Resources. Use `AppLocalization.of(context).locale` instead, '
        'which will reinit Resources with the new locale.');
    _locale = locale;
  }

  static RES? maybeOf<RES extends Resources>(BuildContext context) => Localizations.of<RES>(context, RES);

  static RES of<RES extends Resources>(BuildContext context) {
    final res = Localizations.of<RES>(context, RES);
    if (res == null) {
      throw FlutterError('Resources requested with a context that does not contain a Resources localizations.\n'
          'The context used must be that of a widget that is a descendant of a MaterialApp with a ResLocalizationDelegate '
          'or its descendant used in MaterialApp `localizationsDelegates` list.');
    }
    return res;
  }

  static ResLocalizationsDelegate get delegate => const ResLocalizationsDelegate<Resources>();

  static Future<RES> load<RES extends Resources>(Locale locale) {
    assert(Resources.initializeMessages != null && Resources.creator != null,
        'Messages initialization must be assigned by calling `Resources.init(...)`');
    final name = locale.countryCode?.isEmpty ?? true ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    Intl.defaultLocale = locale.toString();

    return Resources.initializeMessages!(localeName).then((_) {
      return Resources.creator!(locale) as RES;
    });
  }
}

base class XResources<STR extends ResStrings, COL extends ResColors, DIM extends ResDimens, AST extends ResAssets, STY extends ResStyles> {
  static Future<bool> Function(String localeName)? initializeMessages;

  final STR strings;
  final COL colors;
  final DIM dimens;
  final AST assets;
  final STY styles;

  static init<STR extends ResStrings, COL extends ResColors, DIM extends ResDimens, AST extends ResAssets, STY extends ResStyles>({
    required Future<bool> Function(String localeName) initializeMessages,
    required ResourceCreator<STR> stringsCreator,
    required ResourceCreator<COL> colorsCreator,
    required ResourceCreator<DIM> dimensCreator,
    required ResourceCreator<AST> assetsCreator,
    required ResourceCreator<STY> stylesCreator,
  }) {
    Resources.initializeMessages = initializeMessages;
    ResStrings.creator = stringsCreator;
    ResColors.creator = colorsCreator;
    ResDimens.creator = dimensCreator;
    ResAssets.creator = assetsCreator;
    ResStyles.creator = stylesCreator;
  }

  Locale locale;

  XResources(this.locale)
      : assert(
            ResStrings.creator != null &&
                ResColors.creator != null &&
                ResDimens.creator != null &&
                ResAssets.creator != null &&
                ResStyles.creator != null,
            'Resource creators must be assigned by calling `Resources.init(...)`'),
        strings = ResStrings.creator!(locale) as STR,
        colors = ResColors.creator!(locale) as COL,
        dimens = ResDimens.creator!(locale) as DIM,
        assets = ResAssets.creator!(locale) as AST,
        styles = ResStyles.creator!(locale) as STY;

  static XResources of<STR extends ResStrings, COL extends ResColors, DIM extends ResDimens, AST extends ResAssets, STY extends ResStyles>(
      BuildContext context) {
    return Localizations.of<XResources<STR, COL, DIM, AST, STY>>(context, XResources)!;
  }

  static ResLocalizationsDelegate get delegate => const ResLocalizationsDelegate();

  static Future<XResources> load(Locale locale) {
    assert(Resources.initializeMessages != null, 'Messages initialization must be assigned by calling `Resources.init(...)`');
    final name = locale.countryCode?.isEmpty ?? true ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    Intl.defaultLocale = locale.toString();

    return XResources.initializeMessages!(localeName).then((_) {
      return XResources(locale);
    });
  }
}

class ResLocalizationsDelegate<RES extends Resources> extends LocalizationsDelegate<RES> {
  const ResLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ResLocales.locales.contains(locale);

  @override
  Future<RES> load(Locale locale) => Resources.load<RES>(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<RES> old) => false;

}
