// Created with the Assistance of Codex
import 'package:flutter/widgets.dart';

import 'page_language_sync_stub.dart'
    if (dart.library.js_interop) 'page_language_sync_web.dart';

typedef PageLanguageWriter = void Function(String languageTag);

String pageLanguageTagForLocale(Locale locale) {
  final languageTag = locale.toLanguageTag();
  if (languageTag.isNotEmpty) {
    return languageTag;
  }
  if (locale.languageCode.isNotEmpty) {
    return locale.languageCode;
  }
  return 'en';
}

void syncPageLanguageForLocale(Locale locale, {PageLanguageWriter? writer}) {
  final languageTag = pageLanguageTagForLocale(locale);
  if (writer != null) {
    writer(languageTag);
    return;
  }
  writePageLanguageTag(languageTag);
}
