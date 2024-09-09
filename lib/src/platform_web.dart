import 'dart:html';

import 'package:webview_flutter/webview_flutter.dart';

void loadHtmlAsset(WebViewController controller, String assetKey) {
  controller.loadRequest(Uri.base.replace(path: '/assets/$assetKey'));
}

Future<String?> getLogPath(String root, String path) async {
  return null;
}

File file(String path) {
  return File([], path);
}
