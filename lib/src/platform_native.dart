import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:media_storage/media_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

void loadHtmlAsset(WebViewController controller, String assetKey) {
  controller.loadFlutterAsset(assetKey);
}

Future<String?> getLogPath(String root, String path) async {
  final rootDir = await MediaStorage.getExternalStoragePublicDirectory(root);
  if (await MediaStorage.getRequestStoragePermission()) {
    try {
      await MediaStorage.createDirectory(rootDir, path);
      return '$root/$path';
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  } else {
    return null;
  }
}

File file(String path) => File(path);