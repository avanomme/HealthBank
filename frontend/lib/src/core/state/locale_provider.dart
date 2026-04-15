// Created with the Assistance of Claude Code
// frontend/lib/src/core/state/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocalePrefsKey = 'app_locale_code';

/// Provider for managing the app's current locale.
///
/// This provider allows changing the app's language at runtime.
/// The locale is persisted and restored on app restart.
///
/// Usage:
/// ```dart
/// // Read current locale
/// final locale = ref.watch(localeProvider);
///
/// // Change locale
/// ref.read(localeProvider.notifier).setLocale(const Locale('es'));
/// ```
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref);
});

/// Notifier for managing locale state changes.
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(Ref _) : super(const Locale('en')) {
    _restoreLocale(); // load saved locale after construction
  }

  Future<void> _restoreLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_kLocalePrefsKey);

      if (code == null || code.isEmpty) return;

      final restored = SupportedLocales.all.firstWhere(
        (l) => l.languageCode == code,
        orElse: () => SupportedLocales.english,
      );

      // Only update if different (avoids redundant rebuilds)
      if (restored.languageCode != state.languageCode) {
        state = restored;
      }
    } catch (_) {
      // If storage fails, keep default 'en'
    }
  }

  /// Set the app's locale.
  ///
  /// This will trigger a rebuild of all widgets that depend on localization.
  Future<void> setLocale(Locale locale) async {
    state = locale;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLocalePrefsKey, locale.languageCode);
    } catch (_) {
      // Ignore persistence errors (still updates in-memory locale)
    }
  }

  /// Reset to the default locale (English).
  Future<void> resetToDefault() async {
    await setLocale(const Locale('en'));
  }
}

/// Supported locales for the app.
///
/// Add new locales here when translations are available.
class SupportedLocales {
  SupportedLocales._();

  static const Locale english = Locale('en');
  static const Locale french = Locale('fr');
  static const Locale spanish = Locale('es');

  static const List<Locale> all = [
    english,
    french,
    spanish,
  ];

  /// Get the display name for a locale.
  static String getDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  /// Get the short code for a locale (e.g., "EN", "ES").
  static String getShortCode(Locale locale) {
    return locale.languageCode.toUpperCase();
  }
}