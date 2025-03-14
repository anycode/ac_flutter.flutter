import 'package:flutter/material.dart';

// Another variant of showing snackbars (see scaffold_ext for other).
// This allows writing context.showInfo(...) instead of
// Scaffold.of(context).showSnackBar(...)
// The the snackbar lives only in this context so it will disappear
// on screen change.
// For better UX use ScaffoldExt.showInfo(...) which requires few more
// configuration but the snack bars will keep on screen on navigation.

enum _SnackBarType { info, warning, error, notImplemented, notification }

extension BuildContextExt on BuildContext {
  static const _snackBarColors = <_SnackBarType, List<Color>>{
    _SnackBarType.info: <Color>[Colors.green, Colors.white],
    _SnackBarType.warning: <Color>[Colors.orange, Colors.white],
    _SnackBarType.error: <Color>[Colors.red, Colors.white],
    _SnackBarType.notImplemented: <Color>[Colors.amber, Colors.black],
    _SnackBarType.notification: <Color>[Colors.blue, Colors.white],
  };

  void _showCustomSnackBar({required _SnackBarType variant, String? title, required String message, Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      backgroundColor: _snackBarColors[variant]![0],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Text(
              title,
              style: TextStyle(color: _snackBarColors[variant]![1], fontWeight: FontWeight.bold),
            ),
          Text(
            message,
            style: TextStyle(color: _snackBarColors[variant]![1]),
          ),
        ],
      ),
    ));
  }

  /// Shows an info snackbar.
  ///
  /// [message] is the text to display.
  /// [duration] is the duration the snackbar will be visible.
  void showInfo(String message, {Duration? duration}) {
    debugPrint('Info: $message');
    return _showCustomSnackBar(
      variant: _SnackBarType.info,
      message: message,
      duration: duration ?? Duration(seconds: 3),
    );
  }

  /// Shows an error snackbar.
  ///
  /// [message] is the text to display.
  /// [duration] is the duration the snackbar will be visible.
  void showError(String message, {Duration? duration}) {
    debugPrint('Error: $message');
    return _showCustomSnackBar(
      variant: _SnackBarType.error,
      message: message,
      duration: duration ?? Duration(seconds: 3),
    );
  }

  /// Shows a warning snackbar.
  ///
  /// [message] is the text to display.
  /// [duration] is the duration the snackbar will be visible.
  void showWarning(String message, {Duration? duration}) {
    debugPrint('Warning: $message');
    return _showCustomSnackBar(
      variant: _SnackBarType.error,
      message: message,
      duration: duration ?? Duration(seconds: 3),
    );
  }

  /// Shows a notification snackbar.
  ///
  /// [title] is the title of the notification.
  /// [message] is the text to display.
  /// [onTap] is the callback to be executed when the notification is tapped.
  void showNotification(String title, String message, Function() onTap) {
    debugPrint('Notification: $message');
    return _showCustomSnackBar(
      variant: _SnackBarType.notification,
      message: message,
      title: title,
      duration: Duration(seconds: 10),
    );
  }

  /// Shows a "not implemented yet" snackbar.
  ///
  /// [duration] is the duration the snackbar will be visible.

  void showNotImplementedYet({Duration? duration}) async {
    return _showCustomSnackBar(
      variant: _SnackBarType.notImplemented,
      message: 'Not implemented yet',
      duration: duration ?? Duration(seconds: 3),
    );
  }
}

// void setupDialogUi() {
//   var dialogService = getIt<DialogService>();

//   dialogService.registerCustomDialogBuilder(
//       variant: _SnackBarType.INFO,
//       builder: (context, dialogRequest) => Dialog(
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(
//                     dialogRequest.title,
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     dialogRequest.description,
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   GestureDetector(
//                     onTap: () => dialogService.completeDialog(DialogResponse()),
//                     child: Container(
//                       child: dialogRequest.showIconInMainButton ? Icon(Icons.check_circle) : Text(dialogRequest.mainButtonTitle),
//                       alignment: Alignment.center,
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.redAccent,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ));
// }
