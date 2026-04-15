// Created with the Assistance of Codex
/// AppEmailInput
///
/// Description:
/// - A theme-aware email form field with built-in email pattern validation.
/// - `AppEmailInput` is a **form widget** designed for reusable email capture.
///
/// Features:
/// - Supports either `controller` or `initialValue` input sources.
/// - Optional required validation via `isRequired` (enabled by default).
/// - Enforces email format when a non-empty value is provided.
/// - Optional custom validation via `validator`.
/// - Displays animated inline error text using shared form helpers.
///
/// Usage Example:
/// ```dart
/// AppEmailInput(
///   label: 'Email',
///   hintText: 'you@example.com',
///   onChanged: (value) => debugPrint('Email: $value'),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppEmailInput extends StatefulWidget {
  const AppEmailInput({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.enabled = true,
    this.isRequired = true,
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
  final bool isRequired;
  final AppStringValidator? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppEmailInput> createState() => _AppEmailInputState();
}

class _AppEmailInputState extends State<AppEmailInput> {
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();
  TextEditingController? _internalController;

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
  void didUpdateWidget(covariant AppEmailInput oldWidget) {
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
      isRequired: widget.isRequired,
      label: widget.label,
    );
    if (requiredError != null) return requiredError;
    if (value.trim().isNotEmpty && !_emailPattern.hasMatch(value.trim())) {
      return context.l10n.formEmailValidationError;
    }
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
              isRequired: widget.isRequired,
              textField: true,
              value: _controller.text.isEmpty ? null : _controller.text,
              hintText: widget.hintText,
              errorText: state.errorText,
              child: TextField(
                controller: _controller,
                focusNode: widget.focusNode,
                enabled: widget.enabled,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                style: metrics.bodyStyle,
                decoration:
                    appInputDecoration(
                      context,
                      hintText: widget.hintText,
                      enabled: widget.enabled,
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

final RegExp _emailPattern = RegExp(
  r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
);
