part of 'resources.dart';

/// [ResStyles] is deprecated since 0.2.0 and will be removed in next version.
@Deprecated('Use [AcResStyles] instead. [ResStyles] is deprecated will be removed in next version.')
abstract base class ResStyles<COL extends ResColors, DIM extends ResDimens> {
  static ResourceCreator<ResStyles>? creator;

  final Locale locale;
  abstract final DIM dimens;
  abstract final COL colors;

  ResStyles(this.locale);

}
