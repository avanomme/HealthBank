// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/widgets/reset_password_modal.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/app_toasts.dart';
import 'package:frontend/src/core/widgets/feedback/app_announcement.dart';
import 'package:frontend/src/core/widgets/micro/app_user_avatar.dart';
import 'package:frontend/src/features/admin/state/database_providers.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Modal dialog for resetting a user's password
///
/// Features:
/// - Password field with visibility toggle
/// - Generate random password button
/// - Send email notification checkbox
/// - Optional alternate email field
class ResetPasswordModal extends ConsumerStatefulWidget {
  const ResetPasswordModal({
    super.key,
    required this.user,
  });

  /// The user whose password is being reset
  final User user;

  @override
  ConsumerState<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends ConsumerState<ResetPasswordModal> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool _obscurePassword = true;
  bool _sendEmail = false;
  bool _useAlternateEmail = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Pre-populate email with user's current email
    _emailController.text = widget.user.email;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Generate a random 12-character alphanumeric password
  String _generatePassword() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789';
    final random = Random.secure();
    return List.generate(12, (_) => chars[random.nextInt(chars.length)]).join();
  }

  void _onGeneratePassword() {
    final password = _generatePassword();
    _passwordController.text = password;
    setState(() => _obscurePassword = false);
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final adminApi = ref.read(adminApiProvider);
      final password = _passwordController.text;

      // Step 1: Reset the password
      await adminApi.resetPassword(
        widget.user.accountId,
        PasswordResetRequest(newPassword: password),
      );

      // Step 2: Send email if requested
      if (_sendEmail) {
        final emailTo = _useAlternateEmail ? _emailController.text : null;
        await adminApi.sendResetEmail(
          widget.user.accountId,
          SendResetEmailRequest(
            temporaryPassword: password,
            emailOverride: emailTo,
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        AppToast.showSuccess(
          context,
          message: _sendEmail
              ? context.l10n.resetPasswordSuccessEmail
              : context.l10n.resetPasswordSuccessNoEmail,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 500 ? screenWidth * 0.9 : 450.0;

    return AlertDialog(
      title: Row(
        children: [
          const ExcludeSemantics(child: Icon(Icons.lock_reset, color: AppTheme.primary)),
          const SizedBox(width: 12),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                context.l10n.resetPasswordModalTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primary),
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(context),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppAnnouncement(
                    message: _errorMessage!,
                    icon: const Icon(Icons.error_outline, color: AppTheme.error, size: 16),
                    backgroundColor: AppTheme.error.withValues(alpha: 0.1),
                    textColor: AppTheme.error,
                    borderColor: AppTheme.error,
                  ),
                ),
              _buildPasswordField(context),
              const SizedBox(height: 20),
              _buildEmailOptions(),
            ],
          ),
        ),
      ),
      actions: _buildActions(context),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final userName = '${widget.user.firstName} ${widget.user.lastName}';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appColors.divider.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          AppUserAvatar(name: userName),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.user.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.resetPasswordNewPassword,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: context.l10n.resetPasswordHint,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: context.l10n.tooltipTogglePasswordVisibility,
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.resetPasswordRequired;
                  }
                  if (value.length < 8) {
                    return context.l10n.resetPasswordMinLength;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: context.l10n.resetPasswordGenerate,
              child: IconButton(
                onPressed: _isLoading ? null : _onGeneratePassword,
                icon: const Icon(Icons.refresh),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.textContrast,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Tooltip(
              message: context.l10n.resetPasswordCopy,
              child: IconButton(
                onPressed: _isLoading || _passwordController.text.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(
                          ClipboardData(text: _passwordController.text),
                        );
                        AppToast.showSuccess(context, message: context.l10n.resetPasswordCopied);
                      },
                icon: const Icon(Icons.copy),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailOptions() {
    return Column(
      children: [
        CheckboxListTile(
          value: _sendEmail,
          onChanged: _isLoading
              ? null
              : (value) {
                  setState(() => _sendEmail = value ?? false);
                },
          title: Text(context.l10n.resetPasswordSendEmail),
          subtitle: Text(context.l10n.resetPasswordEmailSubtitle),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        if (_sendEmail) ...[
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _useAlternateEmail,
            onChanged: _isLoading
                ? null
                : (value) {
                    setState(() => _useAlternateEmail = value ?? false);
                  },
            title: Text(context.l10n.resetPasswordUseAlternate),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
          if (_useAlternateEmail) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: context.l10n.resetPasswordEmailAddress,
                hintText: context.l10n.resetPasswordEmailHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (_useAlternateEmail) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.resetPasswordEmailRequired;
                  }
                  if (!value.contains('@')) {
                    return context.l10n.resetPasswordEmailInvalid;
                  }
                }
                return null;
              },
            ),
          ],
        ],
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      AppTextButton(
        label: context.l10n.commonCancel,
        onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
      ),
      AppFilledButton(
        label: _isLoading ? context.l10n.resetPasswordResetting : context.l10n.resetPasswordModalTitle,
        onPressed: _isLoading ? null : _onSubmit,
        backgroundColor: AppTheme.primary,
        textColor: AppTheme.textContrast,
      ),
    ];
  }
}

/// Show the reset password modal dialog
///
/// Returns true if password was reset, false if cancelled
Future<bool?> showResetPasswordModal(BuildContext context, User user) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => ResetPasswordModal(user: user),
  );
}
