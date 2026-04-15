// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/features/auth/pages/forgot_password_page.dart
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

/// Forgot Password page
///
/// Step 1 of password reset flow:
/// - User enters their email
/// - Backend sends a reset link to that email
/// - Shows success message with "Back to Login" link
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitted = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authApi = ref.read(authApiProvider);
      await authApi.requestPasswordReset(
        PasswordResetEmailRequest(email: _emailController.text.trim()),
      );
      setState(() {
        _isSubmitted = true;
        _isLoading = false;
      });
    } catch (e) {
      // Backend always returns 202, but handle network errors
      setState(() {
        _isLoading = false;
        _error = 'Unable to connect. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final cardPadding = isMobile ? 24.0 : 40.0;

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
            child: _isSubmitted
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
              l10n.authForgotPasswordTitle,
              style: AppTheme.heading4.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            l10n.authForgotPasswordSubtitle,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: l10n.commonEmail,
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
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.authEmailRequired;
              }
              if (!value.contains('@')) {
                return l10n.authEmailRequired;
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
            label: _isLoading ? 'Loading\u2026' : l10n.authForgotPasswordButton,
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
          Icons.mark_email_read_outlined,
          size: 64,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 24),
        Semantics(
          header: true,
          child: Text(
            l10n.authForgotPasswordTitle,
            style: AppTheme.heading4.copyWith(color: AppTheme.primary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.authForgotPasswordSuccess,
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
}
