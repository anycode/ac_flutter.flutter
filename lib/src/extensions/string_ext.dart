import 'dart:ui';

extension StringExt on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';

  /// Parse string as [Color], input can be #AARRGGBB, #RRGGBB, AARRGGBB, RRGGBB
  Color get color {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Applies route arguments to a string which can contain placeholders
  /// specified by `:name` and with optional parts enclosed in square brackets.
  ///
  /// E.g.
  /// ```dart
  /// static const String dashboardRoute = '[/:pid]/dashboard';
  /// final String heroRoute = dashboardRoute.applyRouteArgs({'pid': 'hero'}) // result route is /hero/dashboard
  /// final String baseRoute = dashboardRoute.applyRouteArgs({'pid': null}) // result route is /dashboard
  /// ```
  String applyRouteArgs(Map<String, dynamic>? map) {
    if (map == null) return this;
    return replaceAllMapped(
        RegExp(r'(?:\[([^:]*?))?:(\w+)(?:([^\[\]]*?)\])?'),
        (match) => map.containsKey(match[2]) && map[match[2]] != null ? '${match[1] ?? ''}${map[match[2]].toString()}${match[3] ?? ''}' : '');
  }

  /// Creates regexp from route string with placeholders which can be then used
  /// for matching routes and routing. Resulting regexp contains groups named by
  /// placeholders. If route does not contain placeholders, returns null.
  ///
  /// ```dart
  /// static const String dashboard = '[/:pid]/dashboard';
  /// static final RegExp _dashboard = dashboard.routeRegExp; // match will contain group named 'pid'
  ///
  /// static Route<dynamic>? generateRoute(RouteSettings settings) {
  ///    final uri = Uri.parse(settings.name!);
  ///
  ///    // regex parametrized routes
  ///    // process longer (more specific) routes before shorter ones (more generic)
  ///    if (AppRoutes._dashboard.hasMatch(uri.path)) {
  ///      final m = AppRoutes._dashboard.firstMatch(uri.path);
  ///      _setProjectId(m?.namedGroup('pid'));
  ///      return _FadeRoute(const DashboardScreen(), settings: settings);
  ///    }
  ///    ...
  ///  }
  ///```
  RegExp? get routeRegExp {
    String re = replaceAllMapped(RegExp(r'\[(.*?):(\w+)(.*?)\]'), (match) => '(${match[1] ?? ''}(?<${match[2]}>[^/]+)${match[3] ?? ''})?')
        .replaceAllMapped(RegExp(r':(\w+)'), (match) => '(?<${match[1]}>[^/]+)');
    return re == this ? null : RegExp('^$re\$');
  }
}
