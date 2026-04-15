// Created with the Assistance of Codex
/// AppConfirmPasswordInput
///
/// Description:
/// - A theme-aware confirm-password form field linked to a create-password
///   source.
/// - `AppConfirmPasswordInput` is a **form widget** designed for reusable
///   password confirmation workflows.
///
/// Features:
/// - Links to a password source via `createPasswordController` or
///   `createPasswordValue`.
/// - Disables itself when no link is provided and shows helper guidance.
/// - Validates required entry (when linked) and exact string match.
/// - Includes one live Password Check row for match status.
/// - Displays animated inline error text using shared form helpers.
///
/// Usage Example:
/// ```dart
/// final createPasswordController = TextEditingController();
///
/// Column(
///   children: [
///     AppCreatePasswordInput(controller: createPasswordController),
///     AppConfirmPasswordInput(
///       createPasswordController: createPasswordController,
///     ),
///   ],
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppConfirmPasswordInput extends StatefulWidget {
  const AppConfirmPasswordInput({
    super.key,
    this.label = 'Confirm Password',
    this.controller,
    this.initialValue,
    this.createPasswordController,
    this.createPasswordValue,
    this.hintText,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final TextEditingController? createPasswordController;
  final String? createPasswordValue;
  final String? hintText;
  final AppStringValidator? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppConfirmPasswordInput> createState() =>
      _AppConfirmPasswordInputState();
}

class _AppConfirmPasswordInputState extends State<AppConfirmPasswordInput> {
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();
  TextEditingController? _internalController;
  bool _obscureText = true;

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  bool get _hasPasswordLink =>
      widget.createPasswordController != null ||
      widget.createPasswordValue != null;

  String get _linkedPassword =>
      widget.createPasswordController?.text ?? widget.createPasswordValue ?? '';

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue ?? '',
      );
    }
    _controller.addListener(_syncFieldValue);
    widget.createPasswordController?.addListener(_onLinkedPasswordChanged);
  }

  @override
  void didUpdateWidget(covariant AppConfirmPasswordInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_syncFieldValue);
      _internalController?.removeListener(_syncFieldValue);

      if (widget.controller == null && _internalController == null) {
        _internalController = TextEditingController(
          text: widget.initialValue ?? '',
        );
      }

      _controller.addListener(_syncFieldValue);
      _syncFieldValue();
    }

    if (oldWidget.createPasswordController != widget.createPasswordController) {
      oldWidget.createPasswordController?.removeListener(
        _onLinkedPasswordChanged,
      );
      widget.createPasswordController?.addListener(_onLinkedPasswordChanged);
      _onLinkedPasswordChanged();
    }

    if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_syncFieldValue);
    widget.createPasswordController?.removeListener(_onLinkedPasswordChanged);
    _internalController?.dispose();
    super.dispose();
  }

  void _syncFieldValue() {
    _fieldKey.currentState?.didChange(_controller.text);
  }

  void _onLinkedPasswordChanged() {
    _fieldKey.currentState?.validate();
    if (mounted) {
      setState(() {});
    }
  }

  String? _validate(String value) {
    if (!_hasPasswordLink) return null;

    final requiredError = appRequiredValidation(
      value,
      isRequired: true,
      label: widget.label,
    );
    if (requiredError != null) return requiredError;
    if (value != _linkedPassword) return context.l10n.formConfirmPasswordMismatch;
    return widget.validator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = appFormMetrics(context);
    final hasMatch =
        _hasPasswordLink &&
        _controller.text.isNotEmpty &&
        _controller.text == _linkedPassword;

    return FormField<String>(
      key: _fieldKey,
      initialValue: _controller.text,
      enabled: _hasPasswordLink,
      autovalidateMode: widget.autovalidateMode,
      validator: (value) => _validate(value ?? _controller.text),
      builder: (state) {
        final hasError = state.errorText != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: appInputLabel(
                context,
                label: widget.label,
                enabled: _hasPasswordLink,
              ),
            ),
            SizedBox(height: metrics.spacing * 0.3),
            appFieldSemantics(
              label: widget.label,
              enabled: _hasPasswordLink,
              isRequired: _hasPasswordLink,
              textField: true,
              value: _controller.text.isEmpty ? null : 'Entered',
              hintText: widget.hintText,
              helperText: _hasPasswordLink
                  ? 'Must exactly match the create password field.'
                  : 'Link a create-password field first to enable confirmation.',
              errorText: state.errorText,
              child: TextField(
                controller: _controller,
                focusNode: widget.focusNode,
                enabled: _hasPasswordLink,
                obscureText: _obscureText,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                style: metrics.bodyStyle,
                decoration:
                    appInputDecoration(
                      context,
                      hintText: widget.hintText,
                      enabled: _hasPasswordLink,
                      suffixIcon: IconButton(
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                                (states) => hasError
                                    ? AppTheme.error
                                    : context.appColors.textMuted,
                              ),
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (states) => hasError
                                ? AppTheme.error.withValues(alpha: 0.12)
                                : null,
                          ),
                        ),
                        tooltip: _obscureText
                            ? context.l10n.commonShowPassword
                            : context.l10n.commonHidePassword,
                        onPressed: _hasPasswordLink
                            ? () => setState(() => _obscureText = !_obscureText)
                            : null,
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ).copyWith(
                      errorText: state.errorText == null ? null : ' ',
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                    ),
                onChanged: (value) {
                  state.didChange(value);
                  setState(() {});
                  widget.onChanged?.call(value);
                },
              ),
            ),
            ExcludeSemantics(
              child: appAnimatedMessage(
                context,
                message: state.errorText,
                color: AppTheme.error,
              ),
            ),
            if (!_hasPasswordLink)
              ExcludeSemantics(
                child: appAnimatedMessage(
                  context,
                  message:
                      'Link a create-password field first to enable confirmation.',
                  color: context.appColors.textMuted,
                ),
              ),
            if (_hasPasswordLink) ...[
              SizedBox(height: metrics.spacing * 0.35),
              ExcludeSemantics(
                child: Text(
                  context.l10n.formPasswordCheckTitle,
                  style: metrics.captionStyle.copyWith(
                    color: context.appColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: metrics.spacing * 0.25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    hasMatch
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    size: 18,
                    color: hasMatch ? AppTheme.success : AppTheme.error,
                  ),
                  SizedBox(width: metrics.spacing * 0.25),
                  Expanded(
                    child: Text(
                      context.l10n.formConfirmPasswordMustMatch,
                      style: metrics.captionStyle.copyWith(
                        color: hasMatch ? AppTheme.success : AppTheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
