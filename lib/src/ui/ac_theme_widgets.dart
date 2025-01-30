import 'package:flutter/material.dart';

import 'ac_theme_builder.dart';
import 'buttons/buttons.dart';

enum _AcThemeButtonStyle { icon, outlined, elevated, text }

class AcThemeButton extends StatelessWidget {
  final IconData? darkIcon;
  final IconData? lightIcon;
  final IconData? systemIcon;
  final String? darkLabel;
  final String? lightLabel;
  final String? systemLabel;
  final _AcThemeButtonStyle _style;

  const AcThemeButton.icon({
    super.key,
    this.lightIcon = Icons.light_mode,
    this.darkIcon = Icons.dark_mode,
    this.systemIcon,
  })  : darkLabel = null,
        lightLabel = null,
        systemLabel = null,
        _style = _AcThemeButtonStyle.icon;

  const AcThemeButton.outlined({
    super.key,
    required this.lightLabel,
    required this.darkLabel,
    this.systemLabel,
    this.lightIcon = Icons.light_mode,
    this.darkIcon = Icons.dark_mode,
    this.systemIcon,
  }) : _style = _AcThemeButtonStyle.outlined;

  const AcThemeButton.elevated({
    super.key,
    required this.lightLabel,
    required this.darkLabel,
    this.systemLabel,
    this.lightIcon = Icons.light_mode,
    this.darkIcon = Icons.dark_mode,
    this.systemIcon,
  }) : _style = _AcThemeButtonStyle.elevated;

  const AcThemeButton.text({
    super.key,
    required this.lightLabel,
    required this.darkLabel,
    this.systemLabel,
    this.lightIcon = Icons.light_mode,
    this.darkIcon = Icons.dark_mode,
    this.systemIcon,
  }) : _style = _AcThemeButtonStyle.text;

  @override
  Widget build(BuildContext context) {
    final themeBuilder = AcThemeBuilder.of(context);
    return StreamBuilder<ThemeMode>(
      stream: themeBuilder.themeModeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final themeMode = snapshot.data!;
        final IconData? icon;
        final String? label;
        final ThemeMode themeModeSet;
        switch (themeMode) {
          case ThemeMode.system:
            icon = systemIcon ?? lightIcon;
            label = systemLabel ?? lightLabel;
            themeModeSet = ThemeMode.light;
          case ThemeMode.light:
            icon = lightIcon;
            label = lightLabel;
            themeModeSet = ThemeMode.dark;
          case ThemeMode.dark:
            icon = darkIcon;
            label = darkLabel;
            themeModeSet = (systemIcon == null && systemLabel == null) ? ThemeMode.light : ThemeMode.system;
        }
        switch (_style) {
          case _AcThemeButtonStyle.icon:
            return IconButton(
              onPressed: () => AcThemeBuilder.of(context).themeMode = themeModeSet,
              icon: Icon(icon),
            );
          case _AcThemeButtonStyle.outlined:
            return AcOutlinedButton(
              onPressed: () => AcThemeBuilder.of(context).themeMode = themeModeSet,
              icon: Icon(icon),
              title: label,
            );
          case _AcThemeButtonStyle.elevated:
            return AcElevatedButton(
              onPressed: () => AcThemeBuilder.of(context).themeMode = themeModeSet,
              icon: Icon(icon),
              title: label,
            );
          case _AcThemeButtonStyle.text:
            return AcTextButton(
              onPressed: () => AcThemeBuilder.of(context).themeMode = themeModeSet,
              icon: Icon(icon),
              title: label,
            );
        }
      },
    );
  }
}

class AcThemeSwitch extends StatelessWidget {
  final IconData darkIcon;
  final IconData lightIcon;
  final bool darkOn;

  const AcThemeSwitch({
    super.key,
    this.lightIcon = Icons.light_mode,
    this.darkIcon = Icons.dark_mode,
    this.darkOn = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeBuilder = AcThemeBuilder.of(context);
    return StreamBuilder<ThemeMode>(
      stream: themeBuilder.themeModeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final themeMode = snapshot.data!;
        final on = darkOn && themeMode == ThemeMode.dark || !darkOn && themeMode == ThemeMode.light;
        final onIcon = darkOn ? darkIcon : lightIcon;
        final offIcon = darkOn ? lightIcon : darkIcon;
        final onValue = darkOn ? ThemeMode.dark : ThemeMode.light;
        final offValue = darkOn ? ThemeMode.light : ThemeMode.dark;
        return Row(
          children: [
            Icon(offIcon),
            Switch.adaptive(
              value: on,
              onChanged: (v) => AcThemeBuilder.of(context).themeMode = v ? onValue : offValue,
            ),
            Icon(onIcon),
          ],
        );
      },
    );
  }
}

class AcThemeToggle extends StatelessWidget {
  final IconData? darkIcon;
  final IconData? lightIcon;
  final IconData? systemIcon;
  final String? darkLabel;
  final String? lightLabel;
  final String? systemLabel;
  final _AcThemeButtonStyle _style;
  final Axis direction;
  final Color? color;
  final Color? selectedColor;
  final Color? disabledColor;
  final Color? fillColor;
  final Color? focusColor;
  final Color? highlightColor;
  final Color? hoverColor;
  final Color? splashColor;
  final List<FocusNode>? focusNodes;
  final bool renderBorder;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final Color? disabledBorderColor;
  final BorderRadius? borderRadius;
  final double? borderWidth;

  const AcThemeToggle.icon({
    super.key,
    this.lightIcon = Icons.light_mode,
    this.darkIcon = Icons.dark_mode,
    this.systemIcon,
    this.direction = Axis.horizontal,
    this.color,
    this.selectedColor,
    this.disabledColor,
    this.fillColor,
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.splashColor,
    this.focusNodes,
    this.renderBorder = true,
    this.borderColor,
    this.selectedBorderColor,
    this.disabledBorderColor,
    this.borderRadius,
    this.borderWidth,
  })  : darkLabel = null,
        lightLabel = null,
        systemLabel = null,
        _style = _AcThemeButtonStyle.icon;

  const AcThemeToggle.text({
    super.key,
    required this.lightLabel,
    required this.darkLabel,
    this.systemLabel,
    this.direction = Axis.horizontal,
    this.color,
    this.selectedColor,
    this.disabledColor,
    this.fillColor,
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.splashColor,
    this.focusNodes,
    this.renderBorder = true,
    this.borderColor,
    this.selectedBorderColor,
    this.disabledBorderColor,
    this.borderRadius,
    this.borderWidth,
  })  : darkIcon = null,
        lightIcon = null,
        systemIcon = null,
        _style = _AcThemeButtonStyle.text;

  @override
  Widget build(BuildContext context) {
    final themeBuilder = AcThemeBuilder.of(context);
    return StreamBuilder<ThemeMode>(
      stream: themeBuilder.themeModeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final themeMode = snapshot.data!;
        final List<Widget> children;
        final selected = <bool>[
          themeMode == ThemeMode.light,
          themeMode == ThemeMode.dark,
          if (systemIcon != null || systemLabel != null) themeMode == ThemeMode.system
        ];
        //return ToggleButtons(children: children, isSelected: isSelected)
        switch (_style) {
          case _AcThemeButtonStyle.icon:
            children = [
              Icon(lightIcon!),
              Icon(darkIcon!),
              if (systemIcon != null) Icon(systemIcon!),
            ];
            break;
          case _AcThemeButtonStyle.text:
            children = [
              Text(lightLabel!),
              Text(darkLabel!),
              if (systemLabel != null) Text(systemLabel!),
            ];
            break;
          case _AcThemeButtonStyle.outlined:
          case _AcThemeButtonStyle.elevated:
            throw UnimplementedError();
        }
        return ToggleButtons(
          isSelected: selected,
          selectedColor: selectedColor,
          disabledColor: disabledColor,
          fillColor: fillColor,
          focusColor: focusColor,
          highlightColor: highlightColor,
          hoverColor: hoverColor,
          splashColor: splashColor,
          focusNodes: focusNodes,
          renderBorder: renderBorder,
          borderColor: borderColor,
          selectedBorderColor: selectedBorderColor,
          disabledBorderColor: disabledBorderColor,
          borderRadius: borderRadius,
          borderWidth: borderWidth,
          direction: direction,
          onPressed: (idx) => AcThemeBuilder.of(context).themeMode = idx == 0 ? ThemeMode.light : idx == 1 ? ThemeMode.dark : ThemeMode.system,
          children: children,
        );
      },
    );
  }
}
