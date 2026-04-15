// frontend/lib/features/auth/state/auth_providers.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;
import 'package:frontend/src/features/auth/state/impersonation_provider.dart'
    show impersonationProvider;
import 'package:frontend/src/core/api/mobile_session.dart'
    show mobileSessionTokenProvider;

/// Provider for the AuthApi service
final authApiProvider = Provider<AuthApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthApi(client.dio);
});

/// Shared fetch of /auth/public-config — polled every 30 s so the maintenance
/// banner updates for already-running sessions without requiring a page refresh.
/// Public so settings save can also invalidate it immediately.
final publicConfigProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  // Schedule a re-fetch in 30 s. If the provider is disposed before then
  // (no watchers), the timer is cancelled automatically.
  final timer = Timer(const Duration(seconds: 30), () => ref.invalidateSelf());
  ref.onDispose(timer.cancel);

  final api = ref.watch(authApiProvider);
  try {
    return await api.getPublicConfig() as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
});

/// Whether self-registration is currently open.
/// Defaults to `true` on error so the button is never hidden due to a network blip.
final registrationOpenProvider = FutureProvider.autoDispose<bool>((ref) async {
  final config = await ref.watch(publicConfigProvider.future);
  return config['registration_open'] as bool? ?? true;
});

/// Whether maintenance mode is currently active.
/// Defaults to `false` on error so the banner is never shown due to a network blip.
final maintenanceModeProvider = FutureProvider.autoDispose<bool>((ref) async {
  final config = await ref.watch(publicConfigProvider.future);
  return config['maintenance_mode'] as bool? ?? false;
});

/// Admin-provided message shown in the maintenance banner (empty string if not set).
final maintenanceMessageProvider =
    FutureProvider.autoDispose<String>((ref) async {
  final config = await ref.watch(publicConfigProvider.future);
  return config['maintenance_message'] as String? ?? '';
});

/// Expected completion time shown in the maintenance banner (empty string if not set).
final maintenanceCompletionProvider =
    FutureProvider.autoDispose<String>((ref) async {
  final config = await ref.watch(publicConfigProvider.future);
  return config['maintenance_completion'] as String? ?? '';
});

/// Current user session state
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final LoginResponse? user;
  final bool mustChangePassword;
  final bool hasSignedConsent;
  final bool needsProfileCompletion;

  /// MFA
  final bool mfaRequired;
  final String? mfaChallengeToken;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.user,
    this.mustChangePassword = false,
    this.hasSignedConsent = true,
    this.needsProfileCompletion = false,
    this.mfaRequired = false,
    this.mfaChallengeToken,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    LoginResponse? user,
    bool? mustChangePassword,
    bool? hasSignedConsent,
    bool? needsProfileCompletion,
    bool? mfaRequired,
    String? mfaChallengeToken,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      hasSignedConsent: hasSignedConsent ?? this.hasSignedConsent,
      needsProfileCompletion: needsProfileCompletion ?? this.needsProfileCompletion,
      mfaRequired: mfaRequired ?? this.mfaRequired,
      mfaChallengeToken: mfaChallengeToken ?? this.mfaChallengeToken,
    );
  }

  AuthState clearError() {
    return AuthState(
      isAuthenticated: isAuthenticated,
      isLoading: isLoading,
      error: null,
      user: user,
      mustChangePassword: mustChangePassword,
      hasSignedConsent: hasSignedConsent,
      needsProfileCompletion: needsProfileCompletion,
      mfaRequired: mfaRequired,
      mfaChallengeToken: mfaChallengeToken,
    );
  }
}

/// Auth state notifier for login/logout operations
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState());

  /// Login with email and password.
  ///
  /// Returns the user's role on full success.
  /// If MFA is required, returns null and sets:
  ///   state.mfaRequired=true + state.mfaChallengeToken
  Future<String?> login(String email, String password) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      mfaRequired: false,
      mfaChallengeToken: null,
    );

    try {
      final api = ref.read(authApiProvider);
      //final json = await api.login(LoginRequest(email: email, password: password));
      final raw = await api.login(LoginRequest(email: email, password: password));
      final Map<String, dynamic> json = (raw as Map).cast<String, dynamic>();

      // MFA challenge response
      final bool mfaRequired = (json['mfa_required'] == true);
      if (mfaRequired) {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
          mfaRequired: true,
          mfaChallengeToken: json['challenge_token'] as String?,
          mustChangePassword: json['must_change_password'] == true,
          needsProfileCompletion: json['needs_profile_completion'] == true,
          // consent state isn't known yet (no session). keep default true or leave as-is.
        );
        return null;
      }

      // Normal login response
      final user = LoginResponse.fromJson(json);

      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        mustChangePassword: user.mustChangePassword,
        hasSignedConsent: user.hasSignedConsent,
        needsProfileCompletion: user.needsProfileCompletion,
        mfaRequired: false,
        mfaChallengeToken: null,
      );

      // Populate impersonation state (role check) and re-fetch all providers.
      await ref.read(impersonationProvider.notifier).fetchSessionInfo();
      ref.read(sessionKeyProvider.notifier).state++;

      return user.role;
    } catch (e) {
      // Check for deactivated account (403 with account_deactivated)
      if (e is DioException && e.error is ApiException) {
        final apiErr = e.error as ApiException;
        if (apiErr.statusCode == 403 &&
            apiErr.message.contains('account_deactivated')) {
          state = state.copyWith(isLoading: false);
          return 'deactivated';
        }
      }
      state = state.copyWith(isLoading: false, error: _parseError(e));
      return null;
    }
  }

  /// Complete MFA step (challenge token + code), then become authenticated.
  /// Returns role for navigation.
  Future<String?> verifyMfa(String code) async {
    final token = state.mfaChallengeToken;
    if (token == null || token.isEmpty) {
      state = state.copyWith(error: 'Missing MFA challenge. Please log in again.');
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(authApiProvider);
      final raw = await api.verify2fa(Verify2FARequest(challengeToken: token, code: code));
      final json = (raw as Map).cast<String, dynamic>();

      final user = LoginResponse.fromJson(json);

      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        mustChangePassword: user.mustChangePassword,
        hasSignedConsent: user.hasSignedConsent,
        needsProfileCompletion: user.needsProfileCompletion,
        mfaRequired: false,
        mfaChallengeToken: null,
      );

      ref.read(sessionKeyProvider.notifier).state++;

      await ref.read(impersonationProvider.notifier).fetchSessionInfo();
      return user.role;
    } catch (e) {
      final msg = _parseMfaError(e);

      // 👇 Keep challenge for normal bad-code attempts (401)
      // Only clear challenge for lockout/expired cases.
      final s = e.toString();
      final shouldClearChallenge =
          s.contains('429') || s.contains('challenge') || s.contains('expired');

      state = state.copyWith(
        isLoading: false,
        error: msg,
        mfaRequired: shouldClearChallenge ? false : true,
        mfaChallengeToken: shouldClearChallenge ? null : state.mfaChallengeToken,
      );

      return null;
    }
  }

  void clearMfaChallenge() {
    state = state.copyWith(mfaRequired: false, mfaChallengeToken: null, error: null);
  }

  Future<void> logout() async {
    try {
      final api = ref.read(authApiProvider);
      await api.logout();
    } catch (e) {
      // Logout API call is best-effort — session cleanup continues regardless
      debugPrint('Logout API call failed: $e');
    }
    // Clear impersonation state so stale role data doesn't bleed into next login.
    ref.read(impersonationProvider.notifier).clear();
    // Clear mobile session token (no-op on web where this is always null)
    ref.read(mobileSessionTokenProvider.notifier).state = null;
    state = const AuthState();
    // Bump session key so all user-specific FutureProviders re-fetch.
    ref.read(sessionKeyProvider.notifier).state++;
  }

  Future<String?> restoreSession() async {
    try {
      final api = ref.read(authApiProvider);
      final sessionInfo = await api.getSessionInfo();

      final user = LoginResponse(
        expiresAt: sessionInfo.sessionExpiresAt,
        accountId: sessionInfo.user.accountId,
        firstName: sessionInfo.user.firstName,
        lastName: sessionInfo.user.lastName,
        email: sessionInfo.user.email,
        role: sessionInfo.user.role,
      );

      state = AuthState(
        isAuthenticated: true,
        user: user,
        hasSignedConsent: sessionInfo.hasSignedConsent,
        needsProfileCompletion: sessionInfo.needsProfileCompletion,
        mustChangePassword: sessionInfo.mustChangePassword,
      );

      ref.read(sessionKeyProvider.notifier).state++;

      await ref.read(impersonationProvider.notifier).fetchSessionInfo();

      return sessionInfo.user.role;
    } catch (_) {
      return null;
    }
  }

  void reset() {
    ref.read(mobileSessionTokenProvider.notifier).state = null;
    state = const AuthState();
  }

  void clearMustChangePassword() => state = state.copyWith(mustChangePassword: false);

  void markConsentSigned() => state = state.copyWith(hasSignedConsent: true);

  void clearNeedsProfileCompletion() => state = state.copyWith(needsProfileCompletion: false);

  void clearError() => state = state.clearError();

  String _parseError(dynamic error) {
    // Extract ApiException from DioException wrapper
    if (error is DioException && error.error is ApiException) {
      final apiErr = error.error as ApiException;
      final code = apiErr.statusCode;
      if (code == 401) return 'Incorrect email or password — please check your credentials and try again.';
      if (code == 422) return apiErr.message;
      if (code == 429) return 'Too many login attempts — please wait a few minutes before trying again.';
      if (code == 403) return apiErr.message;
      if (code != null && code >= 500) {
        return 'A server error occurred — please try again in a moment.';
      }
      return apiErr.message;
    }
    final s = error.toString();
    if (s.contains('401')) return 'Incorrect email or password — please check your credentials and try again.';
    if (s.contains('422')) return s;
    if (s.contains('500')) return 'A server error occurred — please try again in a moment.';
    return 'Login failed — please check your internet connection and try again.';
  }

  String _parseMfaError(dynamic error) {
    final s = error.toString();
    if (s.contains('401')) return 'Invalid authentication code';
    if (s.contains('429')) return 'Too many attempts. Please try again later.';
    if (s.contains('409')) return 'Two-factor is not enabled';
    if (s.contains('500')) return 'Server error. Please try again later.';
    return 'Verification failed. Please try again.';
  }
}

/// Provider for auth state management
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

/// Incremented each time the user logs out.
///
/// All user-specific FutureProviders watch this so they automatically
/// re-fetch when the session changes (preventing stale cross-user data).
final sessionKeyProvider = StateProvider<int>((ref) => 0);

/// Helper to get the dashboard route for a given role.
/// Returns null if the role is unknown — callers should redirect to /login.
String? getDashboardRouteForRole(String? role) {
  switch (role) {
    case 'admin':
      return '/admin';
    case 'researcher':
      return '/researcher/dashboard';
    case 'hcp':
      return '/hcp/dashboard';
    case 'participant':
      return '/participant/dashboard';
    default:
      return null; // Unknown or null role — caller must redirect to /login
  }
}