import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../extensions/alignment_ext.dart';

class AcActionButton extends MaterialButton {
  final Widget? icon;
  final String? svgAsset;
  final IconData? iconData;
  final String? title;
  final Alignment? iconAlignment;
  final double? iconSize;

  const AcActionButton(
      {required super.onPressed,
      this.title,
      this.icon,
      this.iconData,
      this.svgAsset,
      super.color,
      this.iconAlignment,
      super.textColor,
      this.iconSize,
      super.padding,
      super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.buttonTheme.getTextColor(this);
    final size = iconSize ?? theme.appBarTheme.titleTextStyle?.fontSize;
    final ic = icon ??
        (iconData != null
            ? Icon(
                iconData,
                color: textColor,
                size: size,
              )
            : svgAsset != null
                ? SvgPicture.asset(
                    svgAsset!,
                    colorFilter: ColorFilter.mode(textColor, BlendMode.color),
                    height: size,
                  )
                : null);
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (ic != null && (iconAlignment?.isLeft ?? true)) ic,
            if (ic != null && (iconAlignment?.isLeft ?? true) && title != null) SizedBox(width: padding?.horizontal ?? 8.0),
            if (title != null)
              Text(
                title!,
                style: theme.appBarTheme.titleTextStyle?.apply(color: textColor),
              ),
            if (ic != null && (iconAlignment?.isRight ?? false) && title != null) SizedBox(width: padding?.horizontal ?? 8.0),
            if (ic != null && (iconAlignment?.isRight ?? false)) ic,
          ],
        ),
      ),
    );
  }
}
