part of 'resources.dart';

abstract base class ResDimens {
  static ResourceCreator<ResDimens>? creator;

  @mustCallSuper
  final Locale locale;

  ResDimens(this.locale);

}
