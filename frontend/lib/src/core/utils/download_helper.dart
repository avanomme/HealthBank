// Created with the Assistance of Claude Code
// frontend/lib/src/core/utils/download_helper.dart
//
// Conditional export — resolved at compile time:
//   Web  → download_helper_web.dart  (package:web blob + anchor click)
//   IO   → download_helper_io.dart   (path_provider + dart:io File)
//
// Both files expose:
//   Future<String> saveDownload(String filename, List<int> bytes)
//
// Returns: saved file path on IO, empty string on web (browser handles it).

export 'download_helper_io.dart'
    if (dart.library.js_interop) 'download_helper_web.dart';
