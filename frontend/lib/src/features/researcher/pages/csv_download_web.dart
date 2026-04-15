// Created with the Assistance of Claude Code
/// Web implementation for CSV download using package:web.
library;

import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

void downloadCsvFile(String csv, String filename) {
  final bytes = utf8.encode(csv);
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = filename;
  anchor.click();
  web.URL.revokeObjectURL(url);
}
