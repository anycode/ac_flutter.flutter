part of 'resources.dart';

abstract base class ResAssets {
  static ResourceCreator<ResAssets>? creator;

  @mustCallSuper
  final Locale locale;

  ResAssets(this.locale);

}
