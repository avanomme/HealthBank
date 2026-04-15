// Created with the Assistance of Codex
/// AppTextInput
///
/// Description:
/// - A theme-aware single-line text form field with label, required handling,
///   and animated validation feedback.
/// - `AppTextInput` is a **form widget** designed for reusable text capture.
///
/// Features:
/// - Supports either `controller` or `initialValue` input sources.
/// - Optional required validation via `isRequired` (enabled by default).
/// - Optional custom validation via `validator`.
/// - Emits `onChanged` and `onSubmitted` callbacks.
/// - Displays animated inline error text using shared form helpers.
///
/// Usage Example:
/// ```dart
/// AppTextInput(
///   label: 'Full Name',
///   hintText: 'Enter your full name',
///   onChanged: (value) => debugPrint('Name: $value'),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';

class AppTextInput extends StatefulWidget {
  const AppTextInput({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.enabled = true,
    this.isRequired = true,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofillHints,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.keyboardType,
    this.maxLength,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final bool enabled;
  final bool isRequired;
  final AppStringValidator? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final AutovalidateMode autovalidateMode;
  final TextInputType? keyboardType;
  final int? maxLength;

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
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
  void didUpdateWidget(covariant AppTextInput oldWidget) {
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
        final inputDecoration =
            appInputDecoration(
              context,
              hintText: widget.hintText,
              enabled: widget.enabled,
            ).copyWith(
              errorText: state.errorText == null ? null : ' ',
              errorStyle: const TextStyle(height: 0, fontSize: 0),
            );

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
                textInputAction: widget.textInputAction,
                autofillHints: widget.autofillHints,
                keyboardType: widget.keyboardType ?? TextInputType.text,
                maxLength: widget.maxLength,
                style: metrics.bodyStyle,
                decoration: inputDecoration,
                onChanged: (value) {
                  state.didChange(value);
                  widget.onChanged?.call(value);
                },
                onSubmitted: widget.onSubmitted,
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
