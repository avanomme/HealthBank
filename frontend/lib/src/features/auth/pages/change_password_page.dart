// Created with the Assistance of Claude Code and Codex
// frontend/lib/features/auth/pages/change_password_page.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/api/api_client.dart';
import 'package:frontend/src/core/api/models/models.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

/// Forced Change Password page
///
/// Shown when a user logs in with a temporary password.
/// The user must change their password before accessing the app.
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
      await authApi.changePassword(
        ChangePasswordRequest(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );

      // Clear the flag in auth state
      ref.read(authProvider.notifier).clearMustChangePassword();

      if (mounted) {
        final authState = ref.read(authProvider);

        // Check if participant needs to complete profile (birthday/gender)
        if (authState.needsProfileCompletion) {
          context.go(AppRoutes.completeProfile);
          return;
        }

        // Check if user needs to sign consent before accessing dashboard
        if (!authState.hasSignedConsent) {
          context.go(AppRoutes.consent);
          return;
        }

        // Navigate to the appropriate dashboard
        final role = authState.user?.role;
        context.go(getDashboardRouteForRole(role) ?? AppRoutes.login);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        if (e is DioException && e.error is ApiException) {
          final apiErr = e.error as ApiException;
          final code = apiErr.statusCode;
          if (code == 401) {
            _error = 'Current password is incorrect';
          } else if (code == 422) {
            _error = apiErr.message;
          } else if (code != null && code >= 500) {
            _error = 'Server error. Please try again later.';
          } else {
            _error = apiErr.message;
          }
        } else if (e.toString().contains('401') ||
            e.toString().contains('incorrect')) {
          _error = 'Current password is incorrect';
        } else {
          _error = 'Failed to change password. Please try again.';
        }
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
            child: _buildFormContent(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(AppLocalizations l10n) {
    final mustChangePassword = ref.watch(authProvider).mustChangePassword;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lock icon
          const ExcludeSemantics(child: Icon(Icons.lock_outline, size: 48, color: AppTheme.primary)),
          const SizedBox(height: 16),

          // Title
          Semantics(
            header: true,
            child: Text(
              l10n.changePasswordTitle,
              style: AppTheme.heading4.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          if (mustChangePassword) ...[
            const SizedBox(height: 8),
            Text(
              l10n.changePasswordSubtitle,
              style: AppTheme.body.copyWith(color: context.appColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 32),

          // Current Password
          TextFormField(
            key: const ValueKey('auth_current_password'),
            controller: _currentPasswordController,
            obscureText: _obscureCurrent,
            autofillHints: const [AutofillHints.password],
            enabled: !_isLoading,
            decoration: _inputDecoration(labelText: l10n.changePasswordCurrent, 
              suffixIcon: IconButton(
                    tooltip: context.l10n.tooltipTogglePasswordVisibility,
                icon: Icon(
                  _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                  color: context.appColors.textMuted,
                ),
                onPressed: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
              ),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? l10n.changePasswordRequired : null,
          ),
          const SizedBox(height: 16),

          // New Password
          TextFormField(
            key: const ValueKey('auth_new_password'),
            controller: _newPasswordController,
            obscureText: _obscureNew,
            autofillHints: const [AutofillHints.newPassword],
            enabled: !_isLoading,
            decoration: _inputDecoration(labelText: l10n.changePasswordNew, 
              suffixIcon: IconButton(
                    tooltip: context.l10n.tooltipTogglePasswordVisibility,
                icon: Icon(
                  _obscureNew ? Icons.visibility_off : Icons.visibility,
                  color: context.appColors.textMuted,
                ),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return l10n.changePasswordRequired;
              }
              if (v.length < 8) {
                return l10n.changePasswordMinLength;
              }
              if (v == _currentPasswordController.text) {
                return l10n.changePasswordSameAsOld;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm New Password
          TextFormField(
            key: const ValueKey('auth_confirm_password'),
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            autofillHints: const [AutofillHints.newPassword],
            enabled: !_isLoading,
            decoration: _inputDecoration(labelText: l10n.changePasswordConfirm, 
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
            validator: (v) {
              if (v == null || v.isEmpty) {
                return l10n.changePasswordRequired;
              }
              if (v != _newPasswordController.text) {
                return l10n.changePasswordMismatch;
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
            label: _isLoading ? 'Loading\u2026' : l10n.changePasswordButton,
            onPressed: _isLoading ? null : _handleSubmit,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({Widget? suffixIcon, String? labelText}) {
    return InputDecoration(
      labelText: labelText,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
    );
  }
}
