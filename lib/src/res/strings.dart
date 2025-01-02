part of 'resources.dart';

/// [ResStrings] is deprecated since 0.2.0 and will be removed in next version.
@Deprecated('Use [AcResStrings] instead. [ResStrings] is deprecated will be removed in next version.')
abstract base class ResStrings {
  static ResourceCreator<ResStrings>? creator;

  @mustCallSuper
  final Locale locale;

  ResStrings(this.locale);

}
