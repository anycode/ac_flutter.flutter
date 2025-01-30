import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AcIconButton extends MaterialButton {
  final Widget? icon;
  final String? svgAsset;
  final IconData? iconData;
  final double? size;

  const AcIconButton({
    super.onPressed,
    this.icon,
    this.iconData,
    this.svgAsset,
    super.color,
    this.size,
    super.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tColor = theme.buttonTheme.getTextColor(this);
    final size = this.size ?? theme.textTheme.labelLarge?.fontSize;
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
                : const Icon(Icons.error, color: Colors.red));
    return IconButton(
      color: color ?? Colors.transparent,
      padding: padding ?? EdgeInsets.zero,
      icon: ic,
      onPressed: onPressed,
    );
  }
}
