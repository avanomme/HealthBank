// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/features/auth/pages/reset_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/api/models/models.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

/// Reset Password page
///
/// Step 2 of password reset flow:
/// - User arrives via email link with ?token= query parameter
/// - Enters new password + confirmation
/// - Backend validates token and updates password
/// - Shows success message with link to login
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key, this.token});

  final String? token;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final l10n = context.l10n;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authApi = ref.read(authApiProvider);
      await authApi.confirmPasswordReset(
        PasswordResetConfirmRequest(
          token: widget.token ?? '',
          newPassword: _passwordController.text,
        ),
      );
      setState(() {
        _isSuccess = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = l10n.authResetPasswordInvalidLinkMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final cardPadding = isMobile ? 24.0 : 40.0;

    final hasToken = widget.token != null && widget.token!.isNotEmpty;

    return BaseScaffold(
      header: const Header(navItems: []),
      showFooter: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: context.appColors.divider, width: 1),
            ),
            padding: EdgeInsets.all(cardPadding),
            child: !hasToken
                ? _buildInvalidTokenContent(l10n)
                : _isSuccess
                ? _buildSuccessContent(l10n)
                : _buildFormContent(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Semantics(
            header: true,
            child: Text(
              l10n.authResetPasswordTitle,
              style: AppTheme.heading4.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.authResetPasswordSubtitle,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // New password field
          TextFormField(
            key: const ValueKey('auth_reset_password'),
            controller: _passwordController,
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.newPassword],
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: l10n.authResetPasswordNewPassword,
              filled: true,
              fillColor: context.appColors.divider,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: context.appColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: context.appColors.inputBorderFocused, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppTheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppTheme.error, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                    tooltip: context.l10n.tooltipTogglePasswordVisibility,
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: context.appColors.textMuted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.authPasswordRequired;
              }
              if (value.length < 8) {
                return l10n.validationInvalidPassword;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Confirm password field
          TextFormField(
            key: const ValueKey('auth_confirm_password_reset'),
            controller: _confirmController,
            obscureText: _obscureConfirm,
            autofillHints: const [AutofillHints.newPassword],
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: l10n.authResetPasswordConfirmPassword,
              filled: true,
              fillColor: context.appColors.divider,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: context.appColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: context.appColors.inputBorderFocused, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppTheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppTheme.error, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                    tooltip: context.l10n.tooltipTogglePasswordVisibility,
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: context.appColors.textMuted,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.authResetPasswordConfirmRequired;
              }
              if (value != _passwordController.text) {
                return l10n.authRegisterPasswordMismatch;
              }
              return null;
            },
            onFieldSubmitted: (_) => _handleSubmit(),
          ),
          const SizedBox(height: 16),

          // Error message
          if (_error != null) ...[
            Semantics(

              liveRegion: true,

              child: Text(

                          _error!,

                          style: AppTheme.body.copyWith(color: AppTheme.error),

                          textAlign: TextAlign.center,

                        ),

            ),
            const SizedBox(height: 16),
          ],

          // Submit button
          AppFilledButton(
            label: _isLoading ? 'Loading\u2026' : l10n.authResetPasswordButton,
            onPressed: _isLoading ? null : _handleSubmit,
          ),
          const SizedBox(height: 24),

          // Back to login
          AppTextButton(
            label: l10n.authForgotPasswordBackToLogin,
            onPressed: _isLoading ? null : () => context.go('/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 64,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 24),
        Semantics(
          header: true,
          child: Text(
            l10n.authResetPasswordSuccessTitle,
            style: AppTheme.heading4.copyWith(color: AppTheme.primary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.authResetPasswordSuccessMessage,
          style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        AppFilledButton(
          label: l10n.authForgotPasswordBackToLogin,
          onPressed: () => context.go('/login'),
        ),
      ],
    );
  }

  Widget _buildInvalidTokenContent(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ExcludeSemantics(child: Icon(Icons.error_outline, size: 64, color: AppTheme.error)),
        const SizedBox(height: 24),
        Semantics(
          header: true,
          child: Text(
            l10n.authResetPasswordInvalidLinkTitle,
            style: AppTheme.heading4.copyWith(color: AppTheme.primary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.authResetPasswordInvalidLinkMessage,
          style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        AppFilledButton(
          label: l10n.authForgotPasswordButton,
          onPressed: () => context.go('/forgot-password'),
        ),
        const SizedBox(height: 16),
        AppTextButton(
          label: l10n.authForgotPasswordBackToLogin,
          onPressed: () => context.go('/login'),
        ),
      ],
    );
  }
}
