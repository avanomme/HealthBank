// Created with the Assistance of Claude Code
// In-memory session token management for mobile platforms

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-memory session token for mobile platforms.
/// On web, cookies handle auth automatically — this provider stays null.
/// On mobile, the token is extracted from Set-Cookie on login and injected
/// as Authorization: Bearer on every request.
///
/// Cleared on logout and on app restart (memory-only, never persisted to disk).
final mobileSessionTokenProvider = StateProvider<String?>((ref) => null);

/// Extract session_token value from Set-Cookie headers.
/// Returns null if not found or if the cookie is being deleted.
String? extractSessionTokenFromCookies(List<String>? setCookieHeaders) {
  if (setCookieHeaders == null) return null;
  for (final cookie in setCookieHeaders) {
    final trimmed = cookie.trimLeft();
    if (trimmed.startsWith('session_token=')) {
      // Cookie format: "session_token=<value>; Path=/; HttpOnly; ..."
      final value = trimmed.split(';').first.split('=').skip(1).join('=');
      // Empty value or quoted empty means cookie deletion (logout)
      if (value.isNotEmpty && value != '""' && value != "''") {
        return value;
      }
      return null; // Cookie is being cleared
    }
  }
  return null;
}
