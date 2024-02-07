part of 'resources.dart';

abstract base class ResStyles<COL extends ResColors, DIM extends ResDimens> {
  static ResourceCreator<ResStyles>? creator;

  final Locale locale;
  abstract final DIM dimens;
  abstract final COL colors;

  ResStyles(this.locale);

}
