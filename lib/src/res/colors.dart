part of 'resources.dart';

abstract base class ResColors {
  static ResourceCreator<ResColors>? creator;

  @mustCallSuper
  final Locale locale;

  ResColors(this.locale);

}
