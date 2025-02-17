import 'package:flutter/material.dart';

Future showAcAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String buttonText,
  Widget? content,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
}) {
  return showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
            title: Text(title),
            content: content ?? Text(message),
            actions: [TextButton(onPressed: () => Navigator.pop(context, true), child: Text(buttonText))],
          ),
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior);
}

Future<bool?> showAcConfirmDialog({
  required BuildContext context,
  required String title,
  String message = '',
  required String confirmText,
  required String cancelText,
  Widget? content,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
}) {
  return showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
            title: Text(title),
            content: content ?? Text(message),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelText)),
              TextButton(onPressed: () => Navigator.pop(context, true), child: Text(confirmText)),
            ],
          ),
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior);
}
