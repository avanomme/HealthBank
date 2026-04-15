// Created with the Assistance of Claude Code
// frontend/lib/src/core/utils/download_helper_web.dart
//
// Web implementation: creates a Blob URL from the byte array, attaches a
// hidden <a download="…"> element, clicks it, then revokes the object URL.
// The browser handles the save-file dialog and download progress natively.

import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Triggers a browser file-save dialog for [bytes] named [filename].
///
/// Returns an empty string — the browser owns the download UX from here.
Future<String> saveDownload(String filename, List<int> bytes) async {
  final uint8 = Uint8List.fromList(bytes);
  final blob = web.Blob(
    [uint8.toJS].toJS,
    web.BlobPropertyBag(type: 'application/octet-stream'),
  );
  final url = web.URL.createObjectURL(blob);

  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = filename;
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);

  return '';
}
