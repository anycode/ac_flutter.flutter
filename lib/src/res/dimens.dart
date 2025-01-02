part of 'resources.dart';

/// [ResDimens] is deprecated since 0.2.0 and will be removed in next version.
@Deprecated('Use [AcResDimens] instead. [ResDimens] is deprecated will be removed in next version.')
abstract base class ResDimens {
  static ResourceCreator<ResDimens>? creator;

  @mustCallSuper
  final Locale locale;

  ResDimens(this.locale);

}
