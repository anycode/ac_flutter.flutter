import 'package:ac_flutter/src/extensions/string_ext.dart';
import 'package:flutter/material.dart';

/// Type of route transition
enum TransitionType { platform, fade, slide, dialog }

/// Callback builder which is called when route is found and should be built.
/// The builder will get build context and [AcRouterState] which holds the
/// route, uri and path parameters
typedef AcRouterWidgetBuilder = Widget Function(
  BuildContext context,
  AcRouterState state,
);

/// Arguments passed to [AcRouter.generateRoute] as [settings.arguments].
/// The arguments can be created manually and passed as [arguments] when calling Navigator.of(context) methods directly
/// The arguments are created internally when calling [AcRouterBuildContextExt.go] or [AcRouterBuildContextExt.push].
/// See [AcRouterBuildContextExt]
class AcRouteArgs {
  final Map<String, dynamic>? pathParameters;
  final Map<String, dynamic>? queryParameters;
  final dynamic arguments;

  AcRouteArgs({this.pathParameters, this.queryParameters, this.arguments});
}

/// Route definition
///
/// [path] is the route path which can be simple eg. `/apartments`,
/// or can contain placeholders, e.g. `/apartments/:id/skibox`. To set the
/// placeholder value use [AcRouterBuildContextExt.go] or [AcRouterBuildContextExt.push]
/// and pass `pathParameters` which is a map of placeholder name to value, eg. `{'id': '1'}`.
///
/// If you don't use [AcRouterBuildContextExt] methods, you must set the placeholders
/// manually in the route path by calling [StringExt.applyRouteArgs] or by other mean.
///
/// [name] is not used by the router, it's only reserved for future use.
///
/// [builder] is the callback which is called when route is found and should be built
///
/// [transitionType] is the type of route transition, defaults to [TransitionType.fade],
/// other options are [TransitionType.slide] and [TransitionType.dialog]
class AcRoute<T> {
  final String path;
  final String name;
  final AcRouterWidgetBuilder builder;
  final TransitionType transitionType;
  final RegExp? _pathRegExp;
  final bool dlgFullScreen;
  final bool dlgOpaque;
  final Color? dlgBarrierColor;
  final bool dlgBarrierDismissible;
  final Type type = T;

  AcRoute._({
    required this.path,
    String? name,
    required this.builder,
    this.transitionType = TransitionType.fade,
    this.dlgFullScreen = false,
    this.dlgOpaque = true,
    this.dlgBarrierColor,
    this.dlgBarrierDismissible = true,
  })  : name = name ?? path,
        _pathRegExp = path.routeRegExp;

  /// Uses default (platform specific) transition, depends on setting of [PageTransitionsTheme]
  /// See https://main-api.flutter.dev/flutter/material/PageTransitionsTheme-class.html
  AcRoute({required String path, String? name, required AcRouterWidgetBuilder builder})
      : this._(path: path, name: name, builder: builder, transitionType: TransitionType.platform);

  /// Use fade transition
  AcRoute.fade({required String path, String? name, required AcRouterWidgetBuilder builder})
      : this._(path: path, name: name, builder: builder, transitionType: TransitionType.fade);

  /// Use left-right slide transition
  AcRoute.slide({required String path, String? name, required AcRouterWidgetBuilder builder})
      : this._(path: path, name: name, builder: builder, transitionType: TransitionType.slide);

  /// Use down-up slide transition for full screen modals
  AcRoute.dialog({
    required String path,
    String? name,
    required AcRouterWidgetBuilder builder,
    bool fullScreen = true,
    bool opaque = true,
    Color? barrierColor,
    bool barrierDismissible = true,
  }) : this._(
          path: path,
          name: name,
          builder: builder,
          transitionType: TransitionType.dialog,
          dlgFullScreen: fullScreen,
          dlgOpaque: opaque,
          dlgBarrierColor: barrierColor,
          dlgBarrierDismissible: barrierDismissible,
        );

  @override
  String toString() => 'Route{name: $name, path: $path, builder: $builder}';
}

/// State of the router passed to [AcRouterWidgetBuilder]. The state contains
/// the route, uri, path parameters after applying route arguments and
/// extra arguments passed to routing methods
class AcRouterState {
  final AcRoute route;
  final Uri uri;
  final Map<String, String> pathParameters;
  final dynamic arguments;

  AcRouterState({required this.route, required this.uri, this.pathParameters = const {}, this.arguments});

  T? getArgumentAs<T>() => arguments as T?;
}

/// Router which uses [AcRoute]s to define routes. It's [generateRoute] method is to be
/// passed to [MaterialApp] constructor's [onGenerateRoute] argument.
/// [routes] is a list of routes ordered from more specific to more generic, if no match
/// is found, the [missing] route is used, is not set, the first route in [routes] is used.
class AcRouter {
  final List<AcRoute> routes;
  final AcRoute missing;

  AcRouter({required this.routes, AcRouterWidgetBuilder? missingBuilder})
      : missing = AcRoute(path: '', builder: missingBuilder ?? routes.first.builder);

  Route<T>? generateRoute<T>(RouteSettings settings) {
    var uri = Uri.parse(settings.name!);
    var pathParameters = const <String, String>{};
    var arguments = settings.arguments;
    if (settings.arguments != null && settings.arguments is AcRouteArgs) {
      final args = settings.arguments as AcRouteArgs;
      arguments = args.arguments;
      if (args.queryParameters?.isNotEmpty == true) {
        uri = uri.replace(queryParameters: args.queryParameters);
      }
    }
    // else {} - no route arguments, use uri as is (from browser location, etc)
    debugPrint('router uri: $uri, path: ${uri.path}');

    // find matching route, first wins, routes should be ordered from more specific to more generic
    final route = routes.firstWhere((r) {
      if (r._pathRegExp == null) {
        // simple path without placeholders
        return r.path == settings.name;
      }
      if (r._pathRegExp!.hasMatch(uri.path)) {
        // path with placeholders matched
        final m = r._pathRegExp!.firstMatch(uri.path);
        if (m != null) {
          // get path parameters from matched regexp
          pathParameters = {for (var k in m.groupNames) k: m.namedGroup(k) ?? ''};
        }
        return true;
      } else {
        return false;
      }
    }, orElse: () => missing);
    debugPrint('router match: $route');
    final routerState = AcRouterState(route: route, uri: uri, pathParameters: pathParameters, arguments: arguments);
    return switch (route.transitionType) {
      TransitionType.platform =>
        MaterialPageRoute<T>(builder: (context) => routerState.route.builder(context, routerState), settings: settings),
      TransitionType.fade => _FadeRoute<T>(routerState, settings: settings),
      TransitionType.slide => _SlideRightRoute<T>(routerState, settings: settings),
      TransitionType.dialog => _DialogRoute<T>(routerState, settings: settings),
    };
  }
}

class _FadeRoute<T> extends PageRouteBuilder<T> {
  final AcRouterState routerState;

  _FadeRoute(this.routerState, {super.settings, super.maintainState})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              routerState.route.builder(context, routerState),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class _SlideRightRoute<T> extends PageRouteBuilder<T> {
  final AcRouterState routerState;

  _SlideRightRoute(this.routerState, {super.settings, super.maintainState})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              routerState.route.builder(context, routerState),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}

class _DialogRoute<T> extends PageRouteBuilder<T> {
  final AcRouterState routerState;

  _DialogRoute(this.routerState, {super.settings, super.maintainState})
      : super(
          fullscreenDialog: routerState.route.dlgFullScreen,
          opaque: routerState.route.dlgOpaque,
          barrierColor: routerState.route.dlgBarrierColor,
          barrierDismissible: routerState.route.dlgBarrierDismissible,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              routerState.route.builder(context, routerState),
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

/// Extension methods for [BuildContext] for easier navigation
/// Simply call context.[go], context.[push] or context.[pop].
///
/// nb.Inspired by GoRouter
// note: more methods to be added as needed
extension AcRouterBuildContextExt on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  /// Go to route with arguments, replaces the whole stack with this route.
  ///
  /// Generic type T is discarded intentionally and not passed to `pushNamedAndRemoveUntil()`
  /// because it makes a mess with the return type from `generateRoute` which is always `dynamic`
  Future<dynamic> go<T>(String route, {Map<String, dynamic>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) =>
      navigator.pushNamedAndRemoveUntil(route.applyRouteArgs(pathParameters), (r) => false,
          arguments: AcRouteArgs(queryParameters: queryParameters, pathParameters: pathParameters, arguments: extra));

  /// Push new route with arguments to the stack.
  ///
  /// Generic type T is discarded intentionally and not passed to `pushNamed()`
  /// because it makes a mess with the return type from `generateRoute` which is always `dynamic`
  Future<dynamic> push<T>(String route, {Map<String, dynamic>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) =>
      navigator.pushNamed(route.applyRouteArgs(pathParameters),
          arguments: AcRouteArgs(queryParameters: queryParameters, pathParameters: pathParameters, arguments: extra));

  /// Replace current route with new route with arguments on the stack
  ///
  /// Generic types T and TO is discarded intentionally and not passed to `pushReplacementNamed()`
  /// because it makes a mess with the return type from `generateRoute` which is always `dynamic`
  Future<dynamic> pushReplacement<T, TO>(String route,
          {Map<String, dynamic>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) =>
      navigator.pushReplacementNamed(route.applyRouteArgs(pathParameters),
          arguments: AcRouteArgs(queryParameters: queryParameters, pathParameters: pathParameters, arguments: extra));

  /// Pop route from the stack
  void pop<T>([T? value]) => navigator.pop<T>(value);
}
