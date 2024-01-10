/*
 * MIT License
 *
 * Copyright (c) 2023 FORM08.COM s.r.o.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Project: Form08
 * Module: ac_flutter
 * File: debug_service.dart
 *
 */

import 'dart:io';

import 'package:ac_dart/ac_dart.dart';
import 'package:logger/logger.dart';
import 'package:media_storage/media_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DebugService {
  static const defaultPath = '{pkg}/files/logs';

  /// Logger created in the default constructor used for logging generic app events
  late DebugLogger appLogger;

  /// Logger created in the default constructor used for logging API events
  late DebugLogger apiLogger;

  /// Logger created in the default constructor used for logging performance
  late DebugLogger performanceLogger;

  /// Logger created in the default constructor used for logging errors
  late DebugLogger errorLogger;

  /// List of names of loggers to be created in [named] constructor
  final List<String> names;

  /// Name of root media directory used for storing logs. Should be one of
  /// [MediaStorage] directories, default is [MediaStorage.DIRECTORY_DOWNLOADS]
  final String root;

  /// Path under the root directory used for storing logs. Should contain {pkg}
  /// place holder which is replaces with the package name. Default is '{pkg}/files/logs'
  final String path;

  /// Minimum log level
  Level? level;

  /// Map of created loggers, the keys are loggers names passed in the [named]
  /// constructor
  final loggers = <String, DebugLogger>{};

  /// Constructor used for creating named loggers
  DebugService.named({
    String? root,
    this.level,
    this.path = defaultPath,
    required this.names,
  }) : root = root ?? MediaStorage.DIRECTORY_DOWNLOADS {
    _init();
  }

  /// Constructor creating default loggers
  DebugService({
    String? root,
    this.level,
    this.path = defaultPath,
  })  : root = root ?? MediaStorage.DIRECTORY_DOWNLOADS,
        names = ['app', 'api', 'performance', 'error'] {
    _init().then((_) {
      appLogger = loggers['app']!;
      apiLogger = loggers['api']!;
      performanceLogger = loggers['performance']!;
      errorLogger = loggers['error']!;
    });
  }

  Future<bool> _init() async {
    String dir;
    if (path.contains('{pkg}')) {
      var pkg = await PackageInfo.fromPlatform();
      dir = path.replaceAll('{pkg}', pkg.packageName);
    } else {
      dir = path;
    }

    final rootDir = await MediaStorage.getExternalStoragePublicDirectory(root);
    if (await MediaStorage.getRequestStoragePermission()) {
      try {
        await MediaStorage.CreateDir(rootDir, dir);
      } catch (e) {
        print('$e');
        return false;
      }
      for(final name in names) {
        final file = File('$rootDir/$dir/$name.log');
        loggers[name] = DebugLogger(
          name: name,
          level: level,
          output: MultiFileOutput(file: file),
        );
      }
      return true;
    } else {
      return false;
    }
  }
}
