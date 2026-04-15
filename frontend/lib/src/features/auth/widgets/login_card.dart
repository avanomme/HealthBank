// Created with the Assistance of Claude Code
// frontend/lib/features/auth/widgets/login_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/features/auth/widgets/login_form.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

/// Login card widget containing the welcome message and login form
///
/// Matches the Figma design with:
/// - Centered card with border
/// - "Welcome to HealthBank." title
/// - "Please log in to continue." subtitle
/// - Login form
/// - Divider
/// - "New Here? Request An Account" button
class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    this.onLogin,
    this.onForgotPassword,
    this.onRequestAccount,
    this.isLoading = false,
    this.showRequestAccount = true,
  });

  /// Callback when login form is submitted
  final void Function(String email, String password)? onLogin;

  /// Callback when forgot password is tapped
  final VoidCallback? onForgotPassword;

  /// Callback when request account button is tapped
  final VoidCallback? onRequestAccount;

  /// Whether the form is in loading state
  final bool isLoading;

  /// When false the divider and "Request Account" button are hidden entirely.
  /// Set to false when the admin has closed self-registration.
  final bool showRequestAccount;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final cardPadding = isMobile ? 24.0 : 40.0;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: context.appColors.divider,
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Welcome title
              Semantics(
                header: true,
                child: Text(
                  context.l10n.authWelcomeTo,
                  style: AppTheme.heading4.copyWith(
                    color: AppTheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                context.l10n.authPleaseLogIn,
                style: AppTheme.body.copyWith(
                  color: context.appColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Login form
              LoginForm(
                onSubmit: onLogin,
                onForgotPassword: onForgotPassword,
                isLoading: isLoading,
              ),
              if (showRequestAccount) ...[
                const SizedBox(height: 32),

                // Divider
                Container(
                  height: 1,
                  color: context.appColors.divider,
                ),
                const SizedBox(height: 32),

                // Request account button
                AppFilledButton(
                  label: context.l10n.authNewHereRequestAccount,
                  onPressed: isLoading ? null : onRequestAccount,
                  backgroundColor: AppTheme.secondary,
                  textColor: AppTheme.textContrast,
                ),
              ],
            ],
          ),
        ),
        ),
      );
  }
}
