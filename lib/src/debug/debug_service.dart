import 'dart:async';
import 'dart:io';

import 'package:ac_dart/ac_dart.dart';
import 'package:ac_flutter/ac_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:media_storage/media_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DebugService {
  static const defaultPath = '{pkg}/files/logs';

  static const _apiLoggerName = 'api';
  static const _performanceLoggerName = 'performance';
  static const _appLoggerName = 'app';
  static const _errorLoggerName = 'error';

  /// Logger created in the default constructor used for logging generic app events.
  /// If loggers are initialized from constructor, this logger may not be initialized yet when used,
  /// so it's better to await [appLoggerAsync] to complete.
  DebugLogger get appLogger => _loggers.containsKey(_appLoggerName)
      ? _loggers[_appLoggerName]!
      : throw StateError('App Logger not initialized yet, either await for `appLoggerAsync` or await for `init()` to complete');

  /// Async logger created in the default constructor used for logging generic app events.
  /// This logger is initialized immediately in the constructor, you need to await for it to complete
  /// when needed. If you need logger without waiting, use [appLogger] instead. It's your responsibility
  /// to make sure the logger is initialized, eg. by awaiting for `init()` to complete.
  Future<DebugLogger> get appLoggerAsync => _loggersCompleters.containsKey(_appLoggerName)
      ? _loggersCompleters[_appLoggerName]!.future
      : throw StateError('App Logger does not exist');

  /// Logger created in the default constructor used for logging generic API events.
  /// If loggers are initialized from constructor, this logger may not be initialized yet when used,
  /// so it's better to await [apiLoggerAsync] to complete.
  DebugLogger get apiLogger => _loggers.containsKey(_apiLoggerName)
      ? _loggers[_apiLoggerName]!
      : throw StateError('API Logger not initialized yet, either await for `apiLoggerAsync` or await for `init()` to complete');

  /// Async logger created in the default constructor used for logging generic API events.
  /// This logger is initialized immediately in the constructor, you need to await for it to complete
  /// when needed. If you need logger without waiting, use [apiLogger] instead. It's your responsibility
  /// to make sure the logger is initialized, eg. by awaiting for `init()` to complete.
  Future<DebugLogger> get apiLoggerAsync => _loggersCompleters.containsKey(_apiLoggerName)
      ? _loggersCompleters[_apiLoggerName]!.future
      : throw StateError('API Logger does not exist');

  /// Logger created in the default constructor used for logging performance.
  /// If loggers are initialized from constructor, this logger may not be initialized yet when used,
  /// so it's better to await [performanceLoggerAsync] to complete.
  DebugLogger get performanceLogger => _loggers.containsKey(_performanceLoggerName)
      ? _loggers[_performanceLoggerName]!
      : throw StateError(
          'Performance Logger not initialized yet, either await for `performanceLoggerAsync` or await for `init()` to complete');

  /// Async logger created in the default constructor used for logging performance.
  /// This logger is initialized immediately in the constructor, you need to await for it to complete
  /// when needed. If you need logger without waiting, use [performanceLogger] instead. It's your responsibility
  /// to make sure the logger is initialized, eg. by awaiting for `init()` to complete.
  Future<DebugLogger> get performanceLoggerAsync => _loggersCompleters.containsKey(_performanceLoggerName)
      ? _loggersCompleters[_performanceLoggerName]!.future
      : throw StateError('Performance Logger does not exist');

  /// Logger created in the default constructor used for logging errors.
  /// If loggers are initialized from constructor, this logger may not be initialized yet when used,
  /// so it's better to await [errorLoggerAsync] to complete.
  DebugLogger get errorLogger => _loggers.containsKey(_errorLoggerName)
      ? _loggers[_errorLoggerName]!
      : throw StateError('Error Logger not initialized yet, either await for `errorLoggerAsync` or await for `init()` to complete');

  /// Async logger created in the default constructor used for logging errors.
  /// This logger is initialized immediately in the constructor, you need to await for it to complete
  /// when needed. If you need logger without waiting, use [performanceLogger] instead. It's your responsibility
  /// to make sure the logger is initialized, eg. by awaiting for `init()` to complete.
  Future<DebugLogger> get errorLoggerAsync => _loggersCompleters.containsKey(_errorLoggerName)
      ? _loggersCompleters[_errorLoggerName]!.future
      : throw StateError('Error Logger does not exist');

  /// Returns a logger created in the named constructor with the given name. If there is no such logger throws an exception.
  /// If loggers are initialized from constructor, this logger may not be initialized yet when used,
  /// so it's better to await [loggerAsync(name)] to complete.
  DebugLogger logger(String name) =>
      _loggers.containsKey(name) ? _loggers[name]! : throw Exception('Logger $name does not exist or is not initialized yet');

  Map<String, DebugLogger> get loggers => _loggers.length == _names.length
      ? _loggers
      : throw StateError('Loggers are not initialized yet, either await for `loggersAsync` or await for `init()` to complete');
  final _loggers = <String, DebugLogger>{};

  /// Async logger created in the named constructor with the given name. If there is no such logger throws an exception.
  /// This logger is initialized immediately in the constructor, you need to await for it to complete
  /// when needed. If you need logger without waiting, call [logger(name)] instead. It's your responsibility
  /// to make sure the logger is initialized, eg. by awaiting for `init()` to complete.
  FutureOr<DebugLogger> loggerAsync(String name) =>
      _loggersCompleters.containsKey(name) ? _loggersCompleters[name]!.future : throw Exception('Logger $name does not exist');

  Map<String, Future<DebugLogger>> get loggersAsync => _loggersCompleters.map((k, v) => MapEntry(k, v.future));
  final _loggersCompleters = <String, Completer<DebugLogger>>{};

  /// List of names of loggers created in [named] constructor
  List<String> get names => _names;
  final List<String> _names;

  /// Name of root media directory used for storing logs. Should be one of
  /// [MediaStorage] directories, default is [MediaStorage.directoryDownloads]
  String get root => _root;
  final String _root;

  /// Path under the root directory used for storing logs. May contain {pkg}
  /// place holder which is replaces with the package name. Default is '{pkg}/files/logs'
  String get path => _path;
  final String _path;

  /// Minimum log level
  Level? get level => _level;
  final Level? _level;

  bool _initialized = false;

  /// Constructor used for creating named loggers. You need to specify at least list of names. Optionally
  /// you can specify [root] directory and [path]. If not specified, default values will be used.
  /// If you want to initialize loggers immediately, set [initialize] to true. The loggers will be initialized
  /// asynchronously so you need to await for them to complete in your code then.
  /// It's better to leave [initialize] as false and call and await [init()] in your code.
  ///
  /// Example
  /// -------
  /// ```dart
  /// DebugService debugService = DebugService.named(
  ///   names: [ 'app', 'debug' ],
  ///   path: 'files/logs', initialize: true,
  /// );
  ///
  /// // next call might throw an exception, logger might not be initialized yet
  /// debug.service.logger('app').log('Hello');
  ///
  /// // await for logger to be initialized
  /// final logger = await debugService.loggerAsync('app');
  /// logger.log('Hello'); // use logger
  ///
  /// // await and use logger
  /// debugService.loggerAsync('debug').then((logger) => logger.log('Hello'));
  /// ````
  DebugService.named({
    required List<String> names,
    String? root,
    String? path,
    Level? level,
    bool initialize = false,
  })  : _root = root ?? MediaStorage.directoryDownloads,
        _level = level,
        _path = path ?? defaultPath,
        _names = names {
    for (var name in _names) {
      _loggersCompleters.putIfAbsent(name, () => Completer<DebugLogger>());
    }
    if (initialize) {
      init();
    }
  }

  /// Constructor creating default loggers ([appLogger], [apiLogger], [performanceLogger] and [errorLogger]).
  /// See [DebugService.named] for more details
  DebugService({
    String? root,
    String? path,
    Level? level,
    bool initialize = false,
  }) : this.named(
          names: [_appLoggerName, _apiLoggerName, _performanceLoggerName, _errorLoggerName],
          root: root,
          path: path,
          level: level,
          initialize: initialize,
        );

  /// Initialize loggers
  ///
  Future<bool> init() async {
    if (_initialized) {
      // already initialized
      return true;
    }
    String dir;
    if (_path.contains('{pkg}')) {
      var pkg = await PackageInfo.fromPlatform();
      dir = _path.replaceAll('{pkg}', pkg.packageName);
    } else {
      dir = _path;
    }

    final rootDir = await MediaStorage.getExternalStoragePublicDirectory(_root);
    if (await MediaStorage.getRequestStoragePermission()) {
      try {
        await MediaStorage.createDirectory(rootDir, dir);
      } catch (e) {
        debugPrint('$e');
        _initialized = true;
        return false;
      }
      for (final name in _names) {
        final file = File('$rootDir/$dir/$name.log');
        _loggers[name] = DebugLogger(
          name: name,
          level: _level,
          output: MultiFileOutput(file: file),
        );
      }
      _initialized = true;
      return true;
    } else {
      _initialized = true;
      return false;
    }
  }
}
