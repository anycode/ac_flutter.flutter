import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AcThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, ThemeMode mode) builder;

  const AcThemeBuilder({super.key, required this.builder});

  @override
  _AcThemeBuilderState createState() => _AcThemeBuilderState();

  static _AcThemeBuilderState of(BuildContext context, {bool rootBuilder = false}) {
    final themeBuilder = rootBuilder
        ? context.findRootAncestorStateOfType<_AcThemeBuilderState>()
        : context.findAncestorStateOfType<_AcThemeBuilderState>();

    assert(() {
      if (themeBuilder == null) {
        throw FlutterError(
          'ThemeBuilder operation requested with a context that does not include a ThemeBuilder.\n'
              'The context used to get a ThemeBuilder must contain such widget.',
        );
      }
      return true;
    }());
    return themeBuilder!;
  }


}

class _AcThemeBuilderState extends State<AcThemeBuilder> {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    _themeModeStream.add(mode);
  }
  final _themeModeStream = BehaviorSubject<ThemeMode>()..add(ThemeMode.system);
  //BehaviorSubject<ThemeMode> get themeModeStream => _themeModeStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeMode>(
      stream: _themeModeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.builder(context, snapshot.data!);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
