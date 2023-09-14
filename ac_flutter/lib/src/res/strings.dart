part of 'resources.dart';

abstract base class ResStrings {
  static ResourceCreator<ResStrings>? creator;

  @mustCallSuper
  final Locale locale;

  ResStrings(this.locale);

}
