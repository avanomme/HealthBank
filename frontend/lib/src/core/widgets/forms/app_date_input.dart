// Created with the Assistance of Codex
/// AppDateInput
///
/// Description:
/// - A theme-aware date form field built around Flutter's date picker flow.
/// - `AppDateInput` is a **form widget** designed for reusable date selection.
///
/// Features:
/// - Accepts external `value` and emits `onChanged` updates.
/// - Supports picker-driven selection with configurable `firstDate`/`lastDate`.
/// - Optional manual typing via `allowManualEntry` (disabled by default).
/// - Manual text is parsed with `DateTime.tryParse`.
/// - Displays localized compact date text for selected values.
/// - Displays animated inline error text using shared form helpers.
///
/// Usage Example:
/// ```dart
/// AppDateInput(
///   label: 'Date of Birth',
///   value: selectedDate,
///   onChanged: (value) => setState(() => selectedDate = value),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppDateInput extends StatefulWidget {
  const AppDateInput({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.hintText,
    this.enabled = true,
    this.isRequired = true,
    this.allowManualEntry = false,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final String? hintText;
  final bool enabled;
  final bool isRequired;
  final bool allowManualEntry;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final AppValueValidator<DateTime>? validator;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppDateInput> createState() => _AppDateInputState();
}

class _AppDateInputState extends State<AppDateInput> {
  final GlobalKey<FormFieldState<DateTime?>> _fieldKey =
      GlobalKey<FormFieldState<DateTime?>>();
  late final TextEditingController _textController;
  bool _didInitializeText = false;

  DateTime get _firstDate => widget.firstDate ?? DateTime(1900);
  DateTime get _lastDate =>
      widget.lastDate ?? DateTime(DateTime.now().year + 100);

  DateTime _clampToRange(DateTime value) {
    if (value.isBefore(_firstDate)) return _firstDate;
    if (value.isAfter(_lastDate)) return _lastDate;
    return value;
  }

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
  void didUpdateWidget(covariant AppDateInput oldWidget) {
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

  void _syncTextFromValue(DateTime? value) {
    _textController.text = value == null ? '' : _formatDate(value);
  }

  String _formatDate(DateTime value) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatCompactDate(value);
  }

  DateTime? _parseManualDate(String input) {
    final value = input.trim();
    if (value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  Future<void> _pickDate(FormFieldState<DateTime?> state) async {
    if (!widget.enabled) return;

    final now = DateTime.now();
    final fallback = now.isBefore(_firstDate)
        ? _firstDate
        : now.isAfter(_lastDate)
        ? _lastDate
        : now;
    final initial = _clampToRange(state.value ?? widget.value ?? fallback);

    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _firstDate,
      lastDate: _lastDate,
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

  String? _validate(DateTime? value) {
    if (widget.allowManualEntry) {
      final raw = _textController.text.trim();
      if (raw.isNotEmpty && value == null) {
        return context.l10n.formDateValidationError;
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

    return FormField<DateTime?>(
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
              hintText: widget.hintText ?? 'Select date',
              helperText: widget.allowManualEntry
                  ? 'Enter a date in YYYY-MM-DD format or open the date picker.'
                  : 'Open the date picker to choose a date.',
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
                      hintText: widget.hintText ?? 'Select date',
                      enabled: widget.enabled,
                      suffixIcon: IconButton(
                        tooltip: context.l10n.tooltipPickDate,
                        onPressed: widget.enabled
                            ? () => _pickDate(state)
                            : null,
                        icon: const Icon(Icons.calendar_today_outlined),
                      ),
                    ).copyWith(
                      errorText: state.errorText == null ? null : ' ',
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                    ),
                onTap: widget.allowManualEntry ? null : () => _pickDate(state),
                onChanged: widget.allowManualEntry
                    ? (raw) {
                        final parsed = _parseManualDate(raw);
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
