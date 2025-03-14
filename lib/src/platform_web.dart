import 'dart:js_interop';

import 'package:web/web.dart';

import 'package:webview_flutter/webview_flutter.dart';

void loadHtmlAsset(WebViewController controller, String assetKey) {
  controller.loadRequest(Uri.base.replace(path: '/assets/$assetKey'));
}

Future<String?> getLogPath(String root, String path) async => null;

File file(String path) => File(JSArray(), path);
