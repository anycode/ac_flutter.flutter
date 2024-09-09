import 'package:webview_flutter/webview_flutter.dart';

import 'platform_stub.dart' if (dart.library.io) 'platform_native.dart' if (dart.library.js) 'platform_web.dart' as platform;
import 'dart:io' if (dart.library.io) 'dart:io' if (dart.library.js) 'dart:html' as io;

void loadHtmlAsset(WebViewController controller, String assetKey) => platform.loadHtmlAsset(controller, assetKey);
Future<String?> getLogPath(String root, String path) => platform.getLogPath(root, path);
io.File file(String path) => platform.file(path);