// Created with the Assistance of Claude Code and Codex
// frontend/lib/features/auth/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

/// Login form widget with email and password fields
///
/// Matches the Figma design with:
/// - Email text field
/// - Password text field
/// - Forgot Password link
/// - Log In button
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    this.onSubmit,
    this.onForgotPassword,
    this.isLoading = false,
  });

  /// Callback when form is submitted with email and password
  final void Function(String email, String password)? onSubmit;

  /// Callback when forgot password is tapped
  final VoidCallback? onForgotPassword;

  /// Whether the form is in loading state
  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildFormFields(context),
          const SizedBox(height: 24),
          _buildFormActions(context),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields(BuildContext context) {
    return [
      // Email field — labelText provides programmatic label association (WCAG 1.3.1 / 3.3.2)
      TextFormField(
        key: const ValueKey('auth_email'),
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.username, AutofillHints.email],
        enabled: !widget.isLoading,
        decoration: InputDecoration(
          labelText: context.l10n.commonEmail,
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
            return context.l10n.authEmailRequired;
          }
          // ---------------------------------------------------------------
          // DEV LOGIN SHORTCUT — Remove this block for production.
          // Allows any user to log in with just a username (no @).
          // Backend appends @hb.com automatically.
          // ---------------------------------------------------------------
          // Skip @ check entirely — backend handles email expansion
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Password field — labelText provides programmatic label association (WCAG 1.3.1 / 3.3.2)
      TextFormField(
        key: const ValueKey('auth_password'),
        controller: _passwordController,
        obscureText: _obscurePassword,
        autofillHints: const [AutofillHints.password],
        enabled: !widget.isLoading,
        decoration: InputDecoration(
          labelText: context.l10n.commonPassword,
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
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: context.appColors.textMuted,
            ),
            tooltip: context.l10n.tooltipTogglePasswordVisibility,
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return context.l10n.authPasswordRequired;
          }
          return null;
        },
        onFieldSubmitted: (_) => _handleSubmit(),
      ),
    ];
  }

  Widget _buildFormActions(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 12,
      children: [
        AppTextButton(
          key: const ValueKey('auth_forgot_password'),
          label: context.l10n.authLoginForgotPassword,
          onPressed: widget.isLoading ? null : widget.onForgotPassword,
        ),
        AppFilledButton(
          key: const ValueKey('auth_login_button'),
          label: widget.isLoading
              ? context.l10n.authLoggingIn
              : context.l10n.authLoginButton,
          onPressed: widget.isLoading ? null : _handleSubmit,
          backgroundColor: AppTheme.primary,
          textColor: AppTheme.textContrast,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ],
    );
  }
}
