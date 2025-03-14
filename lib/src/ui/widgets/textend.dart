import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart';

/// Extended Text class to allow shortcut styling with
/// Textend.h1(...), ..., Textend.h6(...),
/// Textext.subtitle1(...), Textext.subtitle2(...),
/// Textext.body1(...), Textext.body2(...),
/// Textext.caption(...)

enum _Style { h1, h2, h3, h4, h5, h6, st1, st2, bd1, bd2, cap }

class Textend extends StatelessWidget {
  const Textend(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    @Deprecated('Use textScaler instead.') this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  })  : styleDef = null,
        super();

  const Textend.h1(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.h1,
        style = null,
        super();

  const Textend.h2(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.h2,
        style = null,
        super();

  const Textend.h3(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.h3,
        style = null,
        super();

  const Textend.h4(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.h4,
        style = null,
        super();

  const Textend.h5(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.h5,
        style = null,
        super();

  const Textend.h6(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.h6,
        style = null,
        super();

  const Textend.subtitle1(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.st1,
        style = null,
        super();

  const Textend.subtitle2(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.st2,
        style = null,
        super();

  const Textend.body1(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.bd1,
        style = null,
        super();

  const Textend.body2(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.bd2,
        style = null,
        super();

  const Textend.caption(this.data,
      {super.key,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaler,
      @Deprecated('Use textScaler instead.') this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : styleDef = _Style.cap,
        style = null,
        super();

  final _Style? styleDef;
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final ui.TextHeightBehavior? textHeightBehavior;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    TextStyle? style;
    switch (styleDef) {
      case _Style.h1:
        style = textTheme.displayLarge;
        break;
      case _Style.h2:
        style = textTheme.displayMedium;
        break;
      case _Style.h3:
        style = textTheme.displaySmall;
        break;
      case _Style.h4:
        style = textTheme.headlineMedium;
        break;
      case _Style.h5:
        style = textTheme.headlineSmall;
        break;
      case _Style.h6:
        style = textTheme.titleLarge;
        break;
      case _Style.st1:
        style = textTheme.titleMedium;
        break;
      case _Style.st2:
        style = textTheme.titleSmall;
        break;
      case _Style.bd1:
        style = textTheme.bodyLarge;
        break;
      case _Style.bd2:
        style = textTheme.bodyMedium;
        break;
      case _Style.cap:
        style = textTheme.bodySmall;
        break;
      default:
        style = this.style;
        break;
    }
    return Text(
      data,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler ?? TextScaler.linear(textScaleFactor ?? 1.0),
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
