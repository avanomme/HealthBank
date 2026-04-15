// Created with the Assistance of Codex
/// AppDropdownInput
///
/// Description:
/// - A theme-aware dropdown form field with label and form-aligned validation.
/// - `AppDropdownInput` is a **form widget** designed for reusable option
///   selection.
///
/// Features:
/// - Accepts typed `options`, external `value`, and `onChanged` updates.
/// - Includes a default null option labeled `Select one`.
/// - Optional required validation via `isRequired` (enabled by default).
/// - Optional custom validation via `validator`.
/// - Displays animated inline error text using shared form helpers.
///
/// Usage Example:
/// ```dart
/// AppDropdownInput<String>(
///   label: 'Role',
///   value: selectedRole,
///   options: const [
///     AppDropdownInputOption(label: 'Doctor', value: 'doctor'),
///     AppDropdownInputOption(label: 'Nurse', value: 'nurse'),
///   ],
///   onChanged: (value) => setState(() => selectedRole = value),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';

class AppDropdownInput<T> extends StatefulWidget {
  const AppDropdownInput({
    super.key,
    required this.label,
    required this.options,
    this.value,
    this.onChanged,
    this.hintText,
    this.enabled = true,
    this.isRequired = true,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final List<AppDropdownInputOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final bool enabled;
  final bool isRequired;
  final AppValueValidator<T>? validator;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppDropdownInput<T>> createState() => _AppDropdownInputState<T>();
}

class _AppDropdownInputState<T> extends State<AppDropdownInput<T>> {
  final GlobalKey<FormFieldState<T>> _fieldKey = GlobalKey<FormFieldState<T>>();
  static const String _defaultOptionLabel = 'Select one';

  @override
  void didUpdateWidget(covariant AppDropdownInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _fieldKey.currentState?.didChange(widget.value);
    }
  }

  String? _validate(T? value) {
    if (widget.isRequired && value == null) {
      return '${widget.label} is required.';
    }
    return widget.validator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = appFormMetrics(context);

    return FormField<T>(
      key: _fieldKey,
      initialValue: widget.value,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      validator: _validate,
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
              isNativeInput: false,
              button: true,
              value: widget.options
                  .cast<AppDropdownInputOption<T>?>()
                  .firstWhere(
                    (option) => option?.value == state.value,
                    orElse: () => null,
                  )
                  ?.label,
              hintText: widget.hintText ?? _defaultOptionLabel,
              errorText: state.errorText,
              child: InputDecorator(
                isEmpty: state.value == null,
                decoration:
                    appInputDecoration(
                      context,
                      hintText: null,
                      enabled: widget.enabled,
                    ).copyWith(
                      errorText: state.errorText == null ? null : ' ',
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                    ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: state.value,
                    isDense: true,
                    isExpanded: true,
                    hint: widget.hintText == null
                        ? null
                        : Text(
                            widget.hintText!,
                            style: metrics.bodyStyle.copyWith(
                              color: context.appColors.textMuted,
                            ),
                          ),
                    icon: const Icon(Icons.expand_more),
                    style: metrics.bodyStyle,
                    items: <DropdownMenuItem<T>>[
                      DropdownMenuItem<T>(
                        value: null,
                        enabled: true,
                        child: Text(
                          _defaultOptionLabel,
                          overflow: TextOverflow.ellipsis,
                          style: metrics.bodyStyle.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                      ),
                      ...widget.options.map(
                        (option) => DropdownMenuItem<T>(
                          value: option.value,
                          enabled: option.enabled,
                          child: Text(
                            option.label,
                            overflow: TextOverflow.ellipsis,
                            style: metrics.bodyStyle.copyWith(
                              color: option.enabled
                                  ? context.appColors.textPrimary
                                  : context.appColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ],
                    onChanged: widget.enabled
                        ? (value) {
                            state.didChange(value);
                            widget.onChanged?.call(value);
                          }
                        : null,
                  ),
                ),
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

/// Option model for [AppDropdownInput].
class AppDropdownInputOption<T> {
  const AppDropdownInputOption({
    required this.label,
    required this.value,
    this.enabled = true,
  });

  final String label;
  final T value;
  final bool enabled;
}
