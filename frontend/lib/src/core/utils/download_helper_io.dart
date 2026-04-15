// Created with the Assistance of Claude Code
// frontend/lib/src/core/utils/download_helper_io.dart
//
// Mobile / Desktop implementation: saves bytes to the most user-accessible
// directory available on the platform.
//   Android → getExternalStorageDirectory() (app-external, accessible via
//             Files app) with fallback to getApplicationDocumentsDirectory()
//   iOS     → getApplicationDocumentsDirectory() (visible in Files app under
//             "On My iPhone > HealthBank")
//   Desktop → getDownloadsDirectory() with fallback to Documents

import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Writes [bytes] to the most accessible directory for this platform.
///
/// Returns the absolute path of the saved file.
Future<String> saveDownload(String filename, List<int> bytes) async {
  final dir = await _resolveDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

Future<Directory> _resolveDirectory() async {
  if (Platform.isAndroid) {
    final ext = await getExternalStorageDirectory();
    if (ext != null) return ext;
    return getApplicationDocumentsDirectory();
  }
  if (Platform.isIOS) {
    return getApplicationDocumentsDirectory();
  }
  // macOS / Windows / Linux
  final dl = await getDownloadsDirectory();
  if (dl != null) return dl;
  return getApplicationDocumentsDirectory();
}
