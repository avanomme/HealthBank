// Created with the Assistance of Codex
/// AppCreatePasswordInput
///
/// Description:
/// - A theme-aware password-creation form field with live password-rule
///   guidance and visibility toggle.
/// - `AppCreatePasswordInput` is a **form widget** designed for reusable
///   account password creation.
///
/// Features:
/// - Supports either `controller` or `initialValue` input sources.
/// - Always enforces required-field validation.
/// - Requires all password rules to pass before validation succeeds.
/// - Password Check visibility behavior:
///   - Rules 1, 5, 6, and 7 are always shown.
///   - Rules 2, 3, and 4 are shown only when violated.
/// - Displays animated inline error text using shared form helpers.
///
/// Password Check Rules:
/// 1. Minimum 8 characters.
/// 2. Maximum 32 characters.
/// 3. Must not contain email-like fragments (for example, local@domain.com).
/// 4. Use ASCII letters, digits, and common symbols only.
/// 5. At least one lowercase letter.
/// 6. At least one uppercase letter.
/// 7. At least one number or symbol.
///
/// Rule Label Locations In Code:
/// - Rule checks are labeled in `_rules(String value)`.
/// - Rule display rows are labeled in `build(...)` near each `_ruleRow(...)`.
///
/// Usage Example:
/// ```dart
/// AppCreatePasswordInput(
///   onChanged: (value) => debugPrint('Password length: ${value.length}'),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppCreatePasswordInput extends StatefulWidget {
  const AppCreatePasswordInput({
    super.key,
    this.label = 'Create Password',
    this.controller,
    this.initialValue,
    this.hintText,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final bool enabled;
  final AppStringValidator? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppCreatePasswordInput> createState() => _AppCreatePasswordInputState();
}

class _AppCreatePasswordInputState extends State<AppCreatePasswordInput> {
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();
  TextEditingController? _internalController;
  bool _obscureText = true;

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue ?? '',
      );
    }
    _controller.addListener(_syncFieldValue);
  }

  @override
  void didUpdateWidget(covariant AppCreatePasswordInput oldWidget) {
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

    if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_syncFieldValue);
    _internalController?.dispose();
    super.dispose();
  }

  void _syncFieldValue() {
    _fieldKey.currentState?.didChange(_controller.text);
    if (mounted) {
      setState(() {});
    }
  }

  ({
    bool minLength,
    bool maxLength,
    bool notEmailLike,
    bool asciiOnly,
    bool hasLowercase,
    bool hasUppercase,
    bool hasNumberOrSymbol,
  })
  _rules(String value) {
    final trimmed = value.trim();
    return (
      // Rule 1: Minimum 8 characters.
      minLength: trimmed.length >= 8,
      // Rule 2: Maximum 32 characters.
      maxLength: trimmed.length <= 32,
      // Rule 3: Must not contain email-like fragments.
      notEmailLike: !_emailLikeFragmentPattern.hasMatch(trimmed),
      // Rule 4: Use ASCII letters, digits, and common symbols only.
      asciiOnly: _asciiPasswordPattern.hasMatch(trimmed),
      // Rule 5: At least one lowercase letter.
      hasLowercase: _lowercasePattern.hasMatch(trimmed),
      // Rule 6: At least one uppercase letter.
      hasUppercase: _uppercasePattern.hasMatch(trimmed),
      // Rule 7: At least one number or symbol.
      hasNumberOrSymbol: _numberOrSymbolPattern.hasMatch(trimmed),
    );
  }

  String? _validate(String value) {
    final requiredError = appRequiredValidation(
      value,
      isRequired: true,
      label: widget.label,
    );
    if (requiredError != null) return requiredError;

    final rules = _rules(value);
    final allPass =
        rules.minLength &&
        rules.maxLength &&
        rules.notEmailLike &&
        rules.asciiOnly &&
        rules.hasLowercase &&
        rules.hasUppercase &&
        rules.hasNumberOrSymbol;
    if (!allPass) {
      return context.l10n.formPasswordRulesError;
    }

    return widget.validator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = appFormMetrics(context);
    final rules = _rules(_controller.text);

    return FormField<String>(
      key: _fieldKey,
      initialValue: _controller.text,
      enabled: widget.enabled,
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
                enabled: widget.enabled,
              ),
            ),
            SizedBox(height: metrics.spacing * 0.3),
            appFieldSemantics(
              label: widget.label,
              enabled: widget.enabled,
              isRequired: true,
              textField: true,
              value: _controller.text.isEmpty ? null : 'Entered',
              hintText: widget.hintText,
              helperText: context.l10n.formPasswordRulesHelper,
              errorText: state.errorText,
              child: TextField(
                controller: _controller,
                focusNode: widget.focusNode,
                enabled: widget.enabled,
                obscureText: _obscureText,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                style: metrics.bodyStyle,
                decoration:
                    appInputDecoration(
                      context,
                      hintText: widget.hintText,
                      enabled: widget.enabled,
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
                        onPressed: widget.enabled
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
            // Rule 1: Minimum 8 characters.
            _ruleRow(
              context,
              passes: rules.minLength,
              text: context.l10n.formPasswordRuleMin8,
            ),
            // Rule 2: Maximum 32 characters (shown only when violated).
            if (!rules.maxLength)
              _ruleRow(context, passes: false, text: context.l10n.formPasswordRuleMax32),
            // Rule 3: Must not contain email-like fragments (shown only when
            // violated).
            if (!rules.notEmailLike)
              _ruleRow(
                context,
                passes: false,
                text: context.l10n.formPasswordRuleNoEmail,
              ),
            // Rule 4: Use ASCII letters, digits, and common symbols only
            // (shown only when violated).
            if (!rules.asciiOnly)
              _ruleRow(
                context,
                passes: false,
                text: context.l10n.formPasswordRuleAscii,
              ),
            // Rule 5: At least one lowercase letter.
            _ruleRow(
              context,
              passes: rules.hasLowercase,
              text: context.l10n.formPasswordRuleLowercase,
            ),
            // Rule 6: At least one uppercase letter.
            _ruleRow(
              context,
              passes: rules.hasUppercase,
              text: context.l10n.formPasswordRuleUppercase,
            ),
            // Rule 7: At least one number or symbol.
            _ruleRow(
              context,
              passes: rules.hasNumberOrSymbol,
              text: context.l10n.formPasswordRuleNumberOrSymbol,
            ),
          ],
        );
      },
    );
  }

  Widget _ruleRow(
    BuildContext context, {
    required bool passes,
    required String text,
  }) {
    final metrics = appFormMetrics(context);
    final color = passes ? AppTheme.success : AppTheme.error;

    return Padding(
      padding: EdgeInsets.only(top: metrics.spacing * 0.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            passes ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 18,
            color: color,
          ),
          SizedBox(width: metrics.spacing * 0.25),
          Expanded(
            child: Text(
              text,
              style: metrics.captionStyle.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

final RegExp _emailLikeFragmentPattern = RegExp(
  r'[A-Za-z0-9._%+\-]*@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}',
  caseSensitive: false,
);
final RegExp _asciiPasswordPattern = RegExp(r'^[\x21-\x7E]*$');
final RegExp _lowercasePattern = RegExp(r'[a-z]');
final RegExp _uppercasePattern = RegExp(r'[A-Z]');
final RegExp _numberOrSymbolPattern = RegExp(r'[0-9]|[^A-Za-z0-9]');
