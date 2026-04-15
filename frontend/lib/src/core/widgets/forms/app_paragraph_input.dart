// Created with the Assistance of Codex
/// AppParagraphInput
///
/// Description:
/// - A theme-aware multi-line text form field for paragraph-style content.
/// - `AppParagraphInput` is a **form widget** designed for reusable long-form
///   text capture.
///
/// Features:
/// - Supports either `controller` or `initialValue` input sources.
/// - Configurable sizing with `minLines`, `maxLines`, and `fixedHeight`.
/// - Optional required validation via `isRequired` (enabled by default).
/// - Optional custom validation via `validator`.
/// - Displays animated inline error text using shared form helpers.
///
/// Usage Example:
/// ```dart
/// AppParagraphInput(
///   label: 'Notes',
///   hintText: 'Add additional details',
///   minLines: 4,
///   maxLines: 10,
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';

class AppParagraphInput extends StatefulWidget {
  const AppParagraphInput({
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
    this.minLines = 3,
    this.maxLines = 8,
    this.fixedHeight,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : assert(minLines > 0),
       assert(maxLines >= minLines);

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final bool enabled;
  final bool isRequired;
  final AppStringValidator? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final double? fixedHeight;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppParagraphInput> createState() => _AppParagraphInputState();
}

class _AppParagraphInputState extends State<AppParagraphInput> {
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
  void didUpdateWidget(covariant AppParagraphInput oldWidget) {
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
    final expands = widget.fixedHeight != null;

    return FormField<String>(
      key: _fieldKey,
      initialValue: _controller.text,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      validator: (value) => _validate(value ?? _controller.text),
      builder: (state) {
        final field = TextField(
          controller: _controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          style: metrics.bodyStyle,
          minLines: expands ? null : widget.minLines,
          maxLines: expands ? null : widget.maxLines,
          expands: expands,
          decoration:
              appInputDecoration(
                context,
                hintText: widget.hintText,
                enabled: widget.enabled,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: metrics.spacing * 0.7,
                  vertical: metrics.spacing * 0.65,
                ),
              ).copyWith(
                errorText: state.errorText == null ? null : ' ',
                errorStyle: const TextStyle(height: 0, fontSize: 0),
              ),
          onChanged: (value) {
            state.didChange(value);
            widget.onChanged?.call(value);
          },
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appInputLabel(
              context,
              label: widget.label,
              enabled: widget.enabled,
            ),
            SizedBox(height: metrics.spacing * 0.3),
            if (widget.fixedHeight != null)
              SizedBox(height: widget.fixedHeight, child: field)
            else
              field,
            appAnimatedMessage(
              context,
              message: state.errorText,
              color: AppTheme.error,
            ),
          ],
        );
      },
    );
  }
}


