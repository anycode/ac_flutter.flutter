part of 'resources.dart';

abstract base class ResLocales {
  static const Locale english = Locale('en', 'US');
  static const Locale czech = Locale('cs', 'CZ');
  static const Locale ukrainian = Locale('uk', 'UA'); // uk_UA
  static const Locale russian = Locale('ru', 'RU');

  static const List<Locale> locales = [czech, english, ukrainian, russian];
  static const List<String> languages = ['cs', 'en', 'uk', 'ru'];

  // return locale by lang code or default (czech) if not found
  static Locale byLangCode(String? langCode) => locales.firstWhere((l) => l.languageCode == langCode, orElse: () => czech);
}
