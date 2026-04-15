// Created with the Assistance of Codex
import 'package:web/web.dart' as web;

void writePageLanguageTag(String languageTag) {
  web.document.documentElement?.setAttribute('lang', languageTag);
}
