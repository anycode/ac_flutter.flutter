part of 'ac_resources.dart';

abstract base class AcResStyles<COL extends AcResColors, DIM extends AcResDimens> {

  final Locale locale;
  abstract final DIM dimens;
  abstract final COL colors;

  AcResStyles(this.locale);

}
