// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/features/auth/pages/two_factor_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/features/auth/auth.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
// ignore: unused_import
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// 2FA verification page shown after a successful password login when 2FA is enabled.
///
/// The user enters their TOTP code to complete authentication. On success the
/// session cookie is set and the user is redirected to [returnTo] or their dashboard.
class TwoFactorPage extends ConsumerStatefulWidget {
  final String? returnTo;
  const TwoFactorPage({super.key, this.returnTo});

  @override
  ConsumerState<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends ConsumerState<TwoFactorPage> {
  // KEEP: TextEditingController needs dispose — stays local
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  /// Resolve sentinel error keys to localized strings.
  String? _resolveError(String? errorKey) {
    if (errorKey == null) return null;
    if (errorKey == twoFactorErrorEnrollFailed) {
      return context.l10n.auth2faErrorEnrollFailed;
    }
    if (errorKey == twoFactorErrorVerifyFailed) {
      return context.l10n.auth2faErrorVerifyFailed;
    }
    if (errorKey == twoFactorErrorCodeRequired) {
      return context.l10n.auth2faEnterCodeFromAuthenticator;
    }
    // Already a real string (e.g. from authProvider).
    return errorKey;
  }

  bool get _canConfirm {
    final authState = ref.read(authProvider);
    final tfState = ref.read(twoFactorProvider);
    final isMfaChallenge =
        authState.mfaRequired &&
        (authState.mfaChallengeToken?.isNotEmpty ?? false);

    final codeOk = _codeController.text.trim().length == 6;
    if (tfState.isBusy || !codeOk) return false;

    return isMfaChallenge ? true : (tfState.provisioningUri != null);
  }

  Future<void> _enroll2fa() async {
    _codeController.clear();
    await ref.read(twoFactorProvider.notifier).enroll();
  }

  Future<void> _confirm2fa() async {
    final code = _codeController.text.trim();
    final message = await ref.read(twoFactorProvider.notifier).confirm(code);

    if (!mounted || message == null) return;

    AppToast.showSuccess(context, message: message);
  }

  Future<void> _verifyLoginMfa() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      ref.read(twoFactorProvider.notifier).setError(twoFactorErrorCodeRequired);
      return;
    }

    ref.read(twoFactorProvider.notifier).startVerify();

    final role = await ref.read(authProvider.notifier).verifyMfa(code);

    if (!mounted) return;

    if (role == null) {
      final authError = ref.read(authProvider).error;
      ref
          .read(twoFactorProvider.notifier)
          .finishVerify(
            error: authError ?? context.l10n.auth2faErrorVerifyFailed,
          );
      return;
    }

    ref.read(twoFactorProvider.notifier).finishVerify();

    // same post-login routing as LoginPage
    final st = ref.read(authProvider);

    if (st.mustChangePassword) {
      context.go('/change-password');
      return;
    }
    if (st.needsProfileCompletion) {
      context.go(AppRoutes.completeProfile);
      return;
    }
    if (!st.hasSignedConsent) {
      context.go(AppRoutes.consent);
      return;
    }

    context.go(getDashboardRouteForRole(role) ?? AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: const Header(navItems: []),
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      scrollable: false,
      showFooter: false,
      child: Column(
        children: [Expanded(child: Center(child: _buildCard(context)))],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final cardPadding = isMobile ? 24.0 : 40.0;

    final authState = ref.watch(authProvider);
    final tfState = ref.watch(twoFactorProvider);

    final isMfaChallenge =
        authState.mfaRequired &&
        (authState.mfaChallengeToken?.isNotEmpty ?? false);
    final isLoggedIn = authState.isAuthenticated;

    // Merge errors: prefer authState.error in challenge mode, then local.
    final displayError = _resolveError(authState.error ?? tfState.error);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        constraints: const BoxConstraints(maxWidth: 620),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text(
                context.l10n.auth2faTitle,
                style: AppTheme.heading2.copyWith(color: AppTheme.primary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),

            if (isMfaChallenge) ...[
              Text(
                context.l10n.auth2faEnterCodeToFinishSignin,
                style: AppTheme.body.copyWith(
                  color: context.appColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ] else if (isLoggedIn) ...[
              Text(
                context.l10n.auth2faEnrollAndRetrieveProvisioningUri,
                style: AppTheme.body.copyWith(
                  color: context.appColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Text(
                context.l10n.auth2faPleaseLoginFirstToEnroll,
                style: AppTheme.body.copyWith(
                  color: context.appColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 24),

            if (tfState.isBusy) ...[
              const AppLoadingIndicator(),
              const SizedBox(height: 16),
            ],

            // Prefer showing provider error in challenge mode
            if (displayError != null) ...[
              Text(
                displayError,
                style: AppTheme.body.copyWith(color: AppTheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],

            // ---- Enrollment UI (logged in only)
            if (!isMfaChallenge && isLoggedIn) ...[
              if (tfState.provisioningUri != null) ...[
                ProvisioningQrCard(provisioningUri: tfState.provisioningUri!),
                const SizedBox(height: 16),
              ],

              // Enroll button row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: AppFilledButton(
                      label: context.l10n.auth2faEnrollApi,
                      onPressed:
                          (tfState.isBusy ||
                              (tfState.provisioningUri?.isNotEmpty ?? false))
                          ? null
                          : _enroll2fa,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // ---- Code entry UI (both modes, but only "confirm" enabled after enrollment)
            if (isMfaChallenge ||
                (tfState.provisioningUri != null && isLoggedIn)) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.l10n.auth2faEnterCodeFromAuthenticator,
                  style: AppTheme.body.copyWith(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _codeController,
                enabled: !tfState.isBusy,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                maxLength: 6,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: context.l10n.auth2faCodeHint,
                  filled: true,
                  fillColor: context.appColors.divider.withValues(alpha: 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: context.appColors.divider),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                // KEEP: local setState to re-evaluate _canConfirm from controller text
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) {
                  if (!_canConfirm) return;
                  if (isMfaChallenge) {
                    _verifyLoginMfa();
                  } else {
                    _confirm2fa();
                  }
                },
              ),
              const SizedBox(height: 8),
              AppFilledButton(
                label: isMfaChallenge
                    ? context.l10n.auth2faVerify
                    : context.l10n.auth2faConfirm2fa,
                onPressed: _canConfirm
                    ? (isMfaChallenge ? _verifyLoginMfa : _confirm2fa)
                    : null,
              ),
              if (tfState.confirmMessage != null && !isMfaChallenge) ...[
                const SizedBox(height: 12),
                Text(
                  tfState.confirmMessage!,
                  style: AppTheme.body.copyWith(color: AppTheme.primary),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 12),
            ],

            // ---- Bottom actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 160,
                  child: AppOutlinedButton(
                    label: context.l10n.commonBack,
                    onPressed: tfState.isBusy
                        ? null
                        : () {
                            if (isMfaChallenge) {
                              ref
                                  .read(authProvider.notifier)
                                  .clearMfaChallenge();
                            }
                            final backRoute = widget.returnTo ?? '/login';
                            context.go(backRoute);
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
