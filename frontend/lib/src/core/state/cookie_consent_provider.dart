import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cookie_consent.dart';

/// Riverpod provider for cookie consent state.
///
/// `true` means the user has accepted cookie usage; `false` means the
/// cookie banner should be displayed. Persisted to local storage so the
/// banner is not shown again after the first acceptance.
final cookieConsentProvider =
    StateNotifierProvider<CookieConsentNotifier, bool>((ref) {
  return CookieConsentNotifier();
});

/// StateNotifier that loads and updates the cookie consent flag.
class CookieConsentNotifier extends StateNotifier<bool> {
  CookieConsentNotifier() : super(false) {
    _load();
  }

  /// Constructor for tests — skips async storage load and starts accepted.
  @visibleForTesting
  CookieConsentNotifier.accepted() : super(true);

  Future<void> _load() async {
    state = await CookieConsentStorage.hasConsent();
  }

  /// Record that the user has accepted cookie usage and persist the choice.
  Future<void> accept() async {
    await CookieConsentStorage.setConsent(true);
    state = true;
  }
}