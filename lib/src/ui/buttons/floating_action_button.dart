import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AcFloatingActionButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final String? svgAsset;
  final IconData? iconData;
  final EdgeInsetsGeometry? padding;
  final double iconSize;

  const AcFloatingActionButton({
    this.label,
    this.onPressed,
    this.icon,
    this.iconData,
    this.svgAsset,
    super.key,
    this.padding,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ic = icon ??
        (iconData != null
            ? Icon(iconData)
            : svgAsset != null
                ? SvgPicture.asset(
                    svgAsset!,
                    colorFilter: ColorFilter.mode(theme.floatingActionButtonTheme.foregroundColor!, BlendMode.color),
                    height: iconSize,
                  )
                : null);
    if (label == null) {
      return FloatingActionButton(
        onPressed: onPressed,
        child: ic,
      );
    } else {
      return FloatingActionButton.extended(
        icon: ic,
        label: Text(label!),
        onPressed: onPressed,
      );
    }
  }
}
