import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A scaffold widget that adapts to Cupertino style on iOS and macOS.
///
/// This scaffold provides a consistent structure for your app's screens,
/// handling the app bar, drawer, bottom navigation bar, and body content.
/// It automatically switches to a Cupertino style on iOS and macOS platforms
/// when the `adaptive` constructor is used.
class AcScaffold extends StatelessWidget {

  /// Optional title which is displayed as `Text(title)` with [TextStyle.titleLarge]
  /// If other style or other title needs to be shown, use [appBarTitle] widget instead
  final String? title;

  /// Optional subtitle which is displayed as `Text(subtitle)` with [TextStyle.titleSmall]
  /// If other style or other title needs to be shown, use [appBarTitle] widget instead
  final String? subtitle;

  /// Widget that can show own AppBar title.
  final Widget? appBarTitle;

  /// Widget to be shown as AppBar leading (icon, ...).
  final Widget? appBarLeading;

  /// Flag whether the AppBar leading icon shall be automatically implied.
  final bool appBarAutomaticallyImplyLeading;

  /// List of widgets to be shown as AppBar actions.
  final List<Widget>? appBarActions;

  /// Optional widget to be shown as AppBar bottom.
  final PreferredSizeWidget? appBarBottom;

  /// Optional color of the scaffold's background.
  final Color? backgroundColor;

  /// The main content of the scaffold.
  final Widget body;

  /// Flag whether the AppBar shall be shown.
  final bool showAppBar;

  /// Flag whether the content (app bar and body) shall be shown as a Sliver.
  final bool sliver;

  /// Optional drawer widget (eg. for navigation).
  final Widget? drawer;

  /// Optional end drawer widget (eg. for context menu, filter, ...).
  final Widget? endDrawer;

  /// Optional widget to be shown as bottom sheet.
  final Widget? bottomSheet;

  /// Optional widget to be shown as bottom navigation bar.
  final Widget? bottomNavigationBar;

  final bool adaptive;

  /// Constructor for the scaffold using Material 3 design
  const AcScaffold({
    super.key,
    this.title,
    this.subtitle,
    this.appBarTitle,
    this.appBarLeading,
    this.appBarAutomaticallyImplyLeading = true,
    this.appBarBottom,
    this.appBarActions,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.showAppBar = true,
    this.sliver = false,
    this.backgroundColor,
    this.bottomSheet,
    this.bottomNavigationBar,
  })  : adaptive = false,
        assert(title != null || appBarTitle != null);

  /// Constructor for the scaffold using adaptive design
  const AcScaffold.adaptive({
    super.key,
    this.title,
    this.subtitle,
    this.appBarTitle,
    this.appBarLeading,
    this.appBarAutomaticallyImplyLeading = true,
    this.appBarBottom,
    this.appBarActions,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.showAppBar = true,
    this.sliver = false,
    this.backgroundColor,
    this.bottomSheet,
    this.bottomNavigationBar,
  })  : adaptive = true,
        assert(title != null || appBarTitle != null);

  @override
  Widget build(BuildContext context) {
    final cupertino = adaptive && (Platform.isIOS || Platform.isMacOS);
    final theme = Theme.of(context);
    final textTheme = TextTheme.of(context);
    final content = appBarTitle ?? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subtitle != null) Text(subtitle!.toUpperCase(), style: textTheme.titleSmall),
        Text(title!, style: textTheme.titleLarge),
      ],
    );
    final actions = [
      if (appBarActions != null) ...appBarActions!,
      SizedBox(width: theme.appBarTheme.titleSpacing),
    ];
    if (cupertino) {
      return CupertinoPageScaffold(
        //drawer: drawer,
        //endDrawer: endDrawer,
        navigationBar: (sliver || !showAppBar)
            ? null
            : CupertinoNavigationBar(
                leading: appBarLeading,
                automaticallyImplyLeading: appBarAutomaticallyImplyLeading,
                middle: content,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                ),
              ),
        child: sliver
            ? CustomScrollView(
                slivers: [
                  if (showAppBar)
                    CupertinoSliverNavigationBar(
                      leading: appBarLeading,
                      automaticallyImplyLeading: appBarAutomaticallyImplyLeading,
                      bottom: appBarBottom,
                      middle: content,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions,
                      ),
                    ),
                  body,
                ],
              )
            : body,
      );
    } else {
      return Scaffold(
        appBar: (sliver || !showAppBar)
            ? null
            : AppBar(
                title: content,
                actions: actions,
                leading: appBarLeading,
                automaticallyImplyLeading: appBarAutomaticallyImplyLeading,
                bottom: appBarBottom,
                titleSpacing: 10,
                //systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              ),
        body: sliver
            ? CustomScrollView(
                slivers: [
                  if (showAppBar)
                    SliverAppBar(
                      floating: true,
                      expandedHeight: 100,
                      title: content,
                      actions: actions,
                      leading: appBarLeading,
                      automaticallyImplyLeading: appBarAutomaticallyImplyLeading,
                      bottom: appBarBottom,
                      titleSpacing: 10,
                      //systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
                    ),
                  body,
                ],
              )
            : body,
        drawer: drawer,
        endDrawer: endDrawer,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
      );
    }
  }
}
