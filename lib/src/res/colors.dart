part of 'resources.dart';

/// [ResColors] is deprecated since 0.2.0 and will be removed in next version.
@Deprecated('Use [AcResColors] instead. [ResColors] is deprecated will be removed in next version.')
abstract base class ResColors {
  static ResourceCreator<ResColors>? creator;

  @mustCallSuper
  final Locale locale;

  ResColors(this.locale);

}
