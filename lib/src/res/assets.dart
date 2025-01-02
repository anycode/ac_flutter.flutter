part of 'resources.dart';

/// [ResAssets] is deprecated since 0.2.0 and will be removed in next version.
@Deprecated('Use [AcResAssets] instead. [ResAssets] is deprecated will be removed in next version.')
abstract base class ResAssets {
  static ResourceCreator<ResAssets>? creator;

  @mustCallSuper
  final Locale locale;

  ResAssets(this.locale);

}
