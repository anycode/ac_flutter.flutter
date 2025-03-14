import 'package:flutter/material.dart';

// Another variant of showing snackbars (see build_context_ext for other).
// This version requires navigator global key named 'navigationKey' and
// top most Scaffold in MaterialApp. Inner widgets of this Scaffold can have
// their own scaffolds to display title bars, bottom bars, floating action
// buttons, etc.
// This way the snackbars are displayed in the top most Scaffold and will
// be displayed across screen changes (on navigation).
// Example of main.dart
//   final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
//   ...
//   MaterialApp(
//     ...
//     navigatorKey: navigationKey,
//     builder: (context, child) => Scaffold(child: child),
//     ...
//   )

enum _SnackBarType { info, warning, error, notImplemented, notification }

extension ScaffoldExt on Scaffold {

  static GlobalKey<NavigatorState>? navigationKey;
  static void setNavigationKey(GlobalKey<NavigatorState> key) {
    navigationKey = key;
  }

  static const _snackBarColors = <_SnackBarType, List<Color>>{
    _SnackBarType.info: <Color>[Colors.green, Colors.white],
    _SnackBarType.warning: <Color>[Colors.orange, Colors.white],
    _SnackBarType.error: <Color>[Colors.red, Colors.white],
    _SnackBarType.notImplemented: <Color>[Colors.amber, Colors.black],
    _SnackBarType.notification: <Color>[Colors.blue, Colors.white],
  };

  static void _showCustomSnackBar({required _SnackBarType variant, String? title, required String message, Duration? duration}) {
    if(navigationKey == null) {
      debugPrint('Navigation key not set for snackbar. Call `ScaffoldExt.setNavigationKey(key)` first.');
      return;
    }
    if (navigationKey!.currentContext != null) {
      ScaffoldMessenger.of(navigationKey!.currentContext!).showSnackBar(
        SnackBar(
          backgroundColor: _snackBarColors[variant]![0],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) Text(title, style: TextStyle(color: _snackBarColors[variant]![1], fontWeight: FontWeight.bold)),
              Text(message, style: TextStyle(color: _snackBarColors[variant]![1])),
            ],
          ),
        ),
      );
    }
  }

  /// Shows info message in snackbar.
  ///
  /// [message] - message to display.
  /// [duration] - duration of snackbar.
  static void showInfo(String message, {Duration? duration}) {
    debugPrint('Info: $message');
    return _showCustomSnackBar(
      variant: _SnackBarType.info,
      message: message,
      duration: duration ?? Duration(seconds: 3),
    );
  }

  /// Shows error message in snackbar.
  ///
  /// [message] - message to display.
  static void showError(String message, {Duration? duration}) {
    debugPrint('Error: $message');
    return _showCustomSnackBar(
      variant: _SnackBarType.error,
      message: message,
      duration: duration ?? Duration(seconds: 3),
    );
  }

  /// Shows warning message in snackbar.
  ///
  /// [message] - message to display.
  static void showWarning(String message, {Duration? duration}) {
    debugPrint('Warning: $message');
    return _showCustomSnackBar(
      variant: _SnackBarType.error,
      message: message,
      duration: duration ?? Duration(seconds: 3),
    );
  }

  /// Shows notification message in snackbar.
  ///
  /// [title] - title of notification.
  /// [message] - message to display.
  static void showNotification(String title, String message, Function() onTap) {
    debugPrint('Notification: $message');
    return _showCustomSnackBar(
      variant: _SnackBarType.notification,
      message: message,
      title: title,
      duration: Duration(seconds: 10),
    );
  }

  /// Shows 'Not implemented yet' message in snackbar.
  ///
  /// [duration] - duration of snackbar.
  static void showNotImplementedYet({Duration? duration}) async {
    return _showCustomSnackBar(
      variant: _SnackBarType.notImplemented,
      message: 'Not implemented yet',
      duration: duration ?? Duration(seconds: 3),
    );
  }
}
