// Created with the Assistance of Codex
/// AppTimeInput
///
/// Description:
/// - A theme-aware time form field built around Flutter's time picker flow.
/// - `AppTimeInput` is a **form widget** designed for reusable time selection.
///
/// Features:
/// - Accepts external `value` and emits `onChanged` updates.
/// - Supports picker-driven selection via `showTimePicker`.
/// - Optional manual typing via `allowManualEntry` (disabled by default).
/// - Manual text must match 24-hour `HH:MM` values.
/// - Displays localized time text for selected values.
/// - Displays animated inline error text using shared form helpers.
///
/// Usage Example:
/// ```dart
/// AppTimeInput(
///   label: 'Preferred Time',
///   value: selectedTime,
///   onChanged: (value) => setState(() => selectedTime = value),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppTimeInput extends StatefulWidget {
  const AppTimeInput({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.hintText,
    this.enabled = true,
    this.isRequired = true,
    this.allowManualEntry = false,
    this.validator,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?>? onChanged;
  final String? hintText;
  final bool enabled;
  final bool isRequired;
  final bool allowManualEntry;
  final AppValueValidator<TimeOfDay>? validator;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppTimeInput> createState() => _AppTimeInputState();
}

class _AppTimeInputState extends State<AppTimeInput> {
  final GlobalKey<FormFieldState<TimeOfDay?>> _fieldKey =
      GlobalKey<FormFieldState<TimeOfDay?>>();
  late final TextEditingController _textController;
  bool _didInitializeText = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitializeText) {
      _syncTextFromValue(widget.value);
      _didInitializeText = true;
    }
  }

  @override
  void didUpdateWidget(covariant AppTimeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _syncTextFromValue(widget.value);
      _fieldKey.currentState?.didChange(widget.value);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _syncTextFromValue(TimeOfDay? value) {
    _textController.text = value == null ? '' : _formatTime(value);
  }

  String _formatTime(TimeOfDay value) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(value);
  }

  TimeOfDay? _parseManualTime(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return null;
    final parts = raw.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _pickTime(FormFieldState<TimeOfDay?> state) async {
    if (!widget.enabled) return;

    final selected = await showTimePicker(
      context: context,
      initialTime: state.value ?? widget.value ?? TimeOfDay.now(),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppTheme.primary,
              error: AppTheme.error,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (selected == null) return;
    _syncTextFromValue(selected);
    state.didChange(selected);
    widget.onChanged?.call(selected);
  }

  String? _validate(TimeOfDay? value) {
    if (widget.allowManualEntry) {
      final raw = _textController.text.trim();
      if (raw.isNotEmpty && value == null) {
        return context.l10n.formTimeValidationError;
      }
    }

    if (widget.isRequired && value == null) {
      return '${widget.label} is required.';
    }
    return widget.validator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = appFormMetrics(context);

    return FormField<TimeOfDay?>(
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
              textField: true,
              value: _textController.text.isEmpty ? null : _textController.text,
              hintText: widget.hintText ?? 'Select time',
              helperText: widget.allowManualEntry
                  ? 'Enter a time in HH:MM format or open the time picker.'
                  : 'Open the time picker to choose a time.',
              errorText: state.errorText,
              child: TextField(
                controller: _textController,
                focusNode: widget.focusNode,
                enabled: widget.enabled,
                readOnly: !widget.allowManualEntry,
                style: metrics.bodyStyle,
                decoration:
                    appInputDecoration(
                      context,
                      hintText: widget.hintText ?? 'Select time',
                      enabled: widget.enabled,
                      suffixIcon: IconButton(
                        tooltip: context.l10n.tooltipPickTime,
                        onPressed: widget.enabled
                            ? () => _pickTime(state)
                            : null,
                        icon: const Icon(Icons.access_time_outlined),
                      ),
                    ).copyWith(
                      errorText: state.errorText == null ? null : ' ',
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                    ),
                onTap: widget.allowManualEntry ? null : () => _pickTime(state),
                onChanged: widget.allowManualEntry
                    ? (raw) {
                        final parsed = _parseManualTime(raw);
                        state.didChange(parsed);
                        widget.onChanged?.call(parsed);
                      }
                    : null,
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
