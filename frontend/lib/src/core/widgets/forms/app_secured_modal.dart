// Created with the Assistance of Codex
/// AppSecuredModal
///
/// Description:
/// - A warning-styled confirmation modal for critical actions that requires
///   password verification before confirmation can proceed.
/// - `AppSecuredModal` is a **form widget** designed for guarded destructive
///   or sensitive flows.
///
/// Features:
/// - Uses `AppPasswordInput` for required password capture.
/// - Validates locally, then calls async `verifyPassword`.
/// - Supports async success/failure hooks after verification.
/// - Shows animated verification-failure feedback inline.
/// - Disables actions while verification is in progress.
///
/// Usage Example:
/// ```dart
/// AppSecuredModal(
///   title: 'Delete Record',
///   body: 'This action cannot be undone.',
///   verifyPassword: (password) async => password == currentPassword,
///   onBack: () => setState(() => showModal = false),
///   onVerificationSuccess: (_) async => deleteRecord(),
/// );
/// ```
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_overlay.dart';
import 'package:frontend/src/core/widgets/buttons/app_filled_button.dart';
import 'package:frontend/src/core/widgets/buttons/app_text_button.dart';
import 'package:frontend/src/core/widgets/forms/app_password_input.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';

class AppSecuredModal extends StatefulWidget {
  const AppSecuredModal({
    super.key,
    required this.title,
    required this.body,
    required this.verifyPassword,
    required this.onBack,
    this.onVerificationSuccess,
    this.onVerificationFailure,
    this.passwordLabel = 'Password',
    this.confirmLabel = 'Confirm',
    this.backLabel = 'Back',
    this.invalidPasswordMessage,
  });

  final String title;
  final String body;
  final Future<bool> Function(String password) verifyPassword;
  final VoidCallback onBack;
  final Future<void> Function(String password)? onVerificationSuccess;
  final Future<void> Function(String password)? onVerificationFailure;
  final String passwordLabel;
  final String confirmLabel;
  final String backLabel;
  final String? invalidPasswordMessage;

  @override
  State<AppSecuredModal> createState() => _AppSecuredModalState();
}

class _AppSecuredModalState extends State<AppSecuredModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  bool _verifying = false;
  bool _attemptedSubmit = false;
  String? _verificationError;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    if (_verifying) return;

    setState(() {
      _attemptedSubmit = true;
      _verificationError = null;
    });

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // Resolve localised message before any async gap so context is still valid.
    final errorMessage =
        widget.invalidPasswordMessage ?? context.l10n.formSecuredPasswordVerificationFailed;
    final password = _passwordController.text;
    setState(() => _verifying = true);

    try {
      final verified = await widget.verifyPassword(password);
      if (!mounted) return;

      if (verified) {
        await widget.onVerificationSuccess?.call(password);
      } else {
        setState(() => _verificationError = errorMessage);
        await widget.onVerificationFailure?.call(password);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _verificationError = errorMessage);
      await widget.onVerificationFailure?.call(password);
    } finally {
      if (mounted) {
        setState(() => _verifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final metrics = appFormMetrics(context);
    final horizontalMargin = Breakpoints.responsiveHorizontalMargin(width);
    final maxWidth = math.min(
      560.0,
      math.min(Breakpoints.maxContent, width - horizontalMargin * 2),
    );
    final headingStyle =
        (AppTheme.textThemeForBreakpoint(
                  breakpointForWidth(width),
                ).displaySmall ??
                AppTheme.heading3)
            .copyWith(color: AppTheme.error);

    return AppOverlay(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(horizontalMargin),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: math.max(0, maxWidth)),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(metrics.spacing * 0.6),
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(metrics.spacing),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(widget.title, style: headingStyle),
                          ),
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppTheme.error,
                            size: metrics.spacing,
                          ),
                        ],
                      ),
                      SizedBox(height: metrics.spacing * 0.5),
                      Text(
                        widget.body,
                        style: metrics.bodyStyle.copyWith(
                          color: context.appColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: metrics.spacing * 0.7),
                      AppPasswordInput(
                        label: widget.passwordLabel,
                        controller: _passwordController,
                        enabled: !_verifying,
                        autovalidateMode: _attemptedSubmit
                            ? AutovalidateMode.always
                            : AutovalidateMode.onUserInteraction,
                        onChanged: (_) {
                          if (_verificationError != null) {
                            setState(() => _verificationError = null);
                          }
                        },
                      ),
                      appAnimatedMessage(
                        context,
                        message: _verificationError,
                        color: AppTheme.error,
                      ),
                      SizedBox(height: metrics.spacing * 0.7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppTextButton(
                            label: widget.backLabel,
                            onPressed: _verifying ? null : widget.onBack,
                          ),
                          SizedBox(width: metrics.spacing * 0.35),
                          AppFilledButton(
                            label: _verifying
                                ? 'Verifying...'
                                : widget.confirmLabel,
                            backgroundColor: AppTheme.error,
                            onPressed: _verifying ? null : _onConfirm,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
