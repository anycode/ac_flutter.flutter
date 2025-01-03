import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../extensions/alignment_ext.dart';

class AcTextButton extends MaterialButton {
  final String? title;
  final TextStyle? textStyle;
  final Widget? icon;
  final String? svgAsset;
  final IconData? iconData;
  final Alignment? iconAlignment;
  final double? iconSize;
  @override
  final OutlinedBorder? shape;

  const AcTextButton({
    super.onPressed,
    this.title,
    this.textStyle,
    this.icon,
    this.iconData,
    this.svgAsset,
    this.iconAlignment,
    this.shape,
    super.textColor,
    super.color,
    this.iconSize,
    super.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tColor = textColor ?? textStyle?.color ?? theme.buttonTheme.getTextColor(this);
    final size = iconSize ?? textStyle?.fontSize ?? theme.textTheme.titleMedium?.fontSize ?? 12.0;
    final ic = icon ??
        (iconData != null
            ? Icon(
                iconData,
                color: tColor,
                size: size,
              )
            : svgAsset != null
                ? SvgPicture.asset(
                    svgAsset!,
                    colorFilter: ColorFilter.mode(tColor, BlendMode.color),
                    height: size,
                  )
                : null);
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (ic != null && (iconAlignment?.isLeft ?? true)) ic,
            if (ic != null && (iconAlignment?.isLeft ?? true) && title != null) SizedBox(width: padding?.horizontal ?? 8.0),
            if (title != null)
              Text(
                title!,
                style: textStyle ?? theme.textTheme.titleMedium?.apply(color: color),
              ),
            if (ic != null && (iconAlignment?.isRight ?? false) && title != null) SizedBox(width: padding?.horizontal ?? 8.0),
            if (ic != null && (iconAlignment?.isRight ?? false)) ic,
            if (ic != null && (iconAlignment?.isRight ?? true) && title != null) SizedBox(width: padding?.horizontal ?? 8.0),
          ],
        ),
      ),
    );
  }
}
