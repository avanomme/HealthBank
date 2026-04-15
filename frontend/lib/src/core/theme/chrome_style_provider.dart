import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/src/features/auth/state/auth_providers.dart';

import 'theme.dart';

/// Riverpod provider for the app-wide visual appearance (chrome style + theme mode).
///
/// Persists the selected appearance per user account to SharedPreferences so
/// it survives app restarts. Dark mode forces flat chrome style automatically.
final appAppearanceProvider =
    StateNotifierProvider<AppAppearanceNotifier, AppAppearance>((ref) {
  return AppAppearanceNotifier(ref);
});

/// StateNotifier that manages [AppAppearance] (chrome style and theme mode).
///
/// Loads persisted preferences for the current account on construction and
/// exposes methods to update individual appearance properties.
class AppAppearanceNotifier extends StateNotifier<AppAppearance> {
  AppAppearanceNotifier(this._ref)
    : super(const AppAppearance(
        chromeStyle: ChromeStyle.flat,
        themeMode: AppThemeMode.light,
      )) {
    AppTheme.setAppearance(state);
    _loadForCurrentUser();
  }

  final Ref _ref;

  String get _storageKey {
    final accountId = _ref.read(authProvider).user?.accountId;
    return 'app_appearance_${accountId ?? 'guest'}';
  }

  Future<void> _loadForCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      final restored = normalizeAppAppearance(appAppearanceFromStorage(raw));
      state = restored;
      AppTheme.setAppearance(restored);
    } catch (_) {
      AppTheme.setAppearance(state);
    }
  }

  /// Reload appearance settings for the currently authenticated account.
  /// Call this after switching accounts or logging in.
  Future<void> syncForCurrentUser() async {
    await _loadForCurrentUser();
  }

  /// Update both chrome style and theme mode simultaneously, persisting the change.
  Future<void> setAppearance(AppAppearance appearance) async {
    final normalized = normalizeAppAppearance(appearance);
    state = normalized;
    AppTheme.setAppearance(normalized);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, appAppearanceStorageValue(normalized));
    } catch (_) {
      // Keep in-memory appearance if persistence fails.
    }
  }

  /// Update only the chrome style, preserving the current theme mode.
  Future<void> setChromeStyle(ChromeStyle style) async {
    await setAppearance(state.copyWith(chromeStyle: style));
  }

  /// Update only the theme mode, preserving the current chrome style.
  Future<void> setThemeMode(AppThemeMode mode) async {
    await setAppearance(state.copyWith(themeMode: mode));
  }
}

/// Deserialise an [AppAppearance] from its SharedPreferences storage string.
AppAppearance appAppearanceFromStorage(String? raw) {
  if (raw == null || raw.isEmpty) {
    return const AppAppearance(
      chromeStyle: ChromeStyle.flat,
      themeMode: AppThemeMode.light,
    );
  }

  final parts = raw.split('|');
  final style = switch (parts.isNotEmpty ? parts.first : 'classic') {
    'modern' => ChromeStyle.modern,
    'flat' => ChromeStyle.flat,
    _ => ChromeStyle.classic,
  };
  final mode = switch (parts.length > 1 ? parts[1] : 'light') {
    'dark' => AppThemeMode.dark,
    _ => AppThemeMode.light,
  };

  return AppAppearance(chromeStyle: style, themeMode: mode);
}

/// Enforce appearance constraints — dark mode must use flat chrome.
AppAppearance normalizeAppAppearance(AppAppearance appearance) {
  if (appearance.themeMode == AppThemeMode.dark &&
      appearance.chromeStyle != ChromeStyle.flat) {
    return const AppAppearance(
      chromeStyle: ChromeStyle.flat,
      themeMode: AppThemeMode.dark,
    );
  }

  return appearance;
}

/// Serialise an [AppAppearance] to a compact string for SharedPreferences.
String appAppearanceStorageValue(AppAppearance appearance) {
  final style = switch (appearance.chromeStyle) {
    ChromeStyle.classic => 'classic',
    ChromeStyle.modern => 'modern',
    ChromeStyle.flat => 'flat',
  };
  final mode = switch (appearance.themeMode) {
    AppThemeMode.light => 'light',
    AppThemeMode.dark => 'dark',
  };
  return '$style|$mode';
}
