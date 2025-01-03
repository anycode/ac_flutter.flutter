import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../extensions/alignment_ext.dart';

class AcElevatedButton extends MaterialButton {
  final String? title;
  final TextStyle? textStyle;
  final Widget? icon;
  final String? svgAsset;
  final IconData? iconData;
  final Alignment? iconAlignment;
  final double? iconSize;
  @override
  final OutlinedBorder? shape;

  const AcElevatedButton({
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
    final bColor = color ?? textStyle?.backgroundColor ?? theme.buttonTheme.getFillColor(this);
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding?.horizontal ?? 8.0)),
        backgroundColor: bColor,
      ),
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
          children: [
            if (ic != null && (iconAlignment?.isLeft ?? true)) ic,
            if (ic != null && (iconAlignment?.isLeft ?? true) && title != null) SizedBox(width: padding?.horizontal ?? 8.0),
            if (title != null)
              Text(
                title!,
                style: textStyle ?? theme.textTheme.titleMedium?.apply(color: tColor),
              ),
            if (ic != null && (iconAlignment?.isRight ?? false) && title != null) SizedBox(width: padding?.horizontal ?? 8.0),
            if (ic != null && (iconAlignment?.isRight ?? false)) ic,
          ],
        ),
      ),
    );
  }
}
