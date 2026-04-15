// Created with the Assistance of Claude Code
// frontend/lib/src/features/auth/state/two_factor_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

part 'two_factor_state.freezed.dart';

// ---------------------------------------------------------------------------
// Freezed state
// ---------------------------------------------------------------------------

/// Immutable state for 2FA enrollment and confirmation flow.
@freezed
sealed class TwoFactorState with _$TwoFactorState {
  const factory TwoFactorState({
    @Default(false) bool isBusy,
    String? error,
    String? provisioningUri,
    String? confirmMessage,
  }) = _TwoFactorState;
}

// ---------------------------------------------------------------------------
// StateNotifier
// ---------------------------------------------------------------------------

/// StateNotifier that drives the 2FA enrollment and disable flow.
///
/// Communicates with [TwoFactorAPI] and surfaces busy/error/success state
/// to the settings card via [twoFactorProvider].
class TwoFactorNotifier extends StateNotifier<TwoFactorState> {
  final Ref _ref;

  TwoFactorNotifier(this._ref) : super(const TwoFactorState());

  bool get hasEnrollmentSecret =>
      state.provisioningUri?.isNotEmpty ?? false;

  // -- Mutations used by the page ----------------------------------------

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void clearConfirmMessage() {
    state = state.copyWith(confirmMessage: null);
  }

  /// Start 2FA enrollment (QR code generation).
  Future<void> enroll() async {
    state = state.copyWith(
      isBusy: true,
      error: null,
      provisioningUri: null,
      confirmMessage: null,
    );

    try {
      final client = _ref.read(apiClientProvider);
      final api = TwoFactorAPI(client.dio);
      final res = await api.twoFactorEnroll();

      if (!mounted) return;
      state = state.copyWith(
        isBusy: false,
        provisioningUri: res.provisioningUri,
      );
    } catch (_) {
      if (!mounted) return;
      // Error message is resolved in the page (needs BuildContext for l10n).
      state = state.copyWith(
        isBusy: false,
        error: _kEnrollFailed,
      );
    }
  }

  /// Confirm 2FA enrollment with a TOTP code.
  ///
  /// Returns the success message from the server, or null on failure.
  Future<String?> confirm(String code) async {
    if (code.length != 6) {
      state = state.copyWith(error: _kCodeRequired);
      return null;
    }

    state = state.copyWith(
      isBusy: true,
      error: null,
      confirmMessage: null,
    );

    try {
      final client = _ref.read(apiClientProvider);
      final api = TwoFactorAPI(client.dio);
      final res = await api.twoFactorConfirm(
        TwoFactorConfirmRequest(code: code),
      );

      if (!mounted) return null;
      state = state.copyWith(
        isBusy: false,
        confirmMessage: res.message,
      );
      return res.message;
    } catch (_) {
      if (!mounted) return null;
      state = state.copyWith(
        isBusy: false,
        error: _kVerifyFailed,
      );
      return null;
    }
  }

  /// Prepare state for a login-MFA verification attempt.
  void startVerify() {
    state = state.copyWith(
      isBusy: true,
      error: null,
      confirmMessage: null,
    );
  }

  /// Mark verification finished (success or pre-navigation).
  void finishVerify({String? error}) {
    state = state.copyWith(isBusy: false, error: error);
  }

  /// Reset all local 2FA page state.
  void reset() {
    state = const TwoFactorState();
  }
}

// Sentinel error keys – the page maps these to localized strings.
const _kEnrollFailed = '__enroll_failed__';
const _kVerifyFailed = '__verify_failed__';
const _kCodeRequired = '__code_required__';

// Expose sentinel constants so the page can compare against them.
const twoFactorErrorEnrollFailed = _kEnrollFailed;
const twoFactorErrorVerifyFailed = _kVerifyFailed;
const twoFactorErrorCodeRequired = _kCodeRequired;

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final twoFactorProvider =
    StateNotifierProvider.autoDispose<TwoFactorNotifier, TwoFactorState>(
  (ref) => TwoFactorNotifier(ref),
);
