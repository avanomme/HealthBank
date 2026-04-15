// Created with the Assistance of Codex
/// AppPasswordInput
///
/// Description:
/// - A theme-aware password form field with obscured text and visibility toggle.
/// - `AppPasswordInput` is a **form widget** designed for reusable password
///   entry.
///
/// Features:
/// - Supports either `controller` or `initialValue` input sources.
/// - Always enforces required-field validation for non-empty password entry.
/// - Includes a trailing eye icon to show/hide password text.
/// - Supports configurable `autofillHints`.
/// - Displays animated inline error text using shared form helpers.
///
/// Usage Example:
/// ```dart
/// AppPasswordInput(
///   label: 'Password',
///   hintText: 'Enter your password',
///   onChanged: (value) => debugPrint('Length: ${value.length}'),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppPasswordInput extends StatefulWidget {
  const AppPasswordInput({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.autofillHints = const [AutofillHints.password],
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
  final Iterable<String> autofillHints;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppPasswordInput> createState() => _AppPasswordInputState();
}

class _AppPasswordInputState extends State<AppPasswordInput> {
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
  void didUpdateWidget(covariant AppPasswordInput oldWidget) {
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
  }

  String? _validate(String value) {
    final requiredError = appRequiredValidation(
      value,
      isRequired: true,
      label: widget.label,
    );
    if (requiredError != null) return requiredError;
    return widget.validator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = appFormMetrics(context);

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
              errorText: state.errorText,
              child: TextField(
                controller: _controller,
                focusNode: widget.focusNode,
                enabled: widget.enabled,
                obscureText: _obscureText,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                autofillHints: widget.autofillHints,
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
          ],
        );
      },
    );
  }
}
