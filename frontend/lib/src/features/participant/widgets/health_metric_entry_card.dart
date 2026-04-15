// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/health_metric_entry_card.dart
/// Entry card for a single health metric.
///
/// Clean survey-style layout: question number + label on a subtly tinted
/// background, input below. Background cycles through 4 subtle tints so
/// adjacent questions are visually distinct.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/app_dropdown_input.dart';
import 'package:frontend/src/core/widgets/forms/app_text_input.dart';

// Background tint offsets: each step blends a little primary into the surface
// colour so cards cycle visually while staying fully theme-aware.
const List<double> _kTintAlphas = [0.0, 0.03, 0.06];

/// Input card for a single [TrackingMetric], rendering the appropriate field
/// type (text, number, dropdown, or scale) based on [TrackingMetric.metricType].
class HealthMetricEntryCard extends StatefulWidget {
  const HealthMetricEntryCard({
    super.key,
    required this.metric,
    required this.initialValue,
    required this.onChanged,
    this.questionNumber,
    this.cardIndex = 0,
  });

  final TrackingMetric metric;
  final String? initialValue;
  final void Function(String value) onChanged;

  /// 1-based question number shown in the card header.
  final int? questionNumber;

  /// Index used to select a background tint (cycles through 4).
  final int cardIndex;

  @override
  State<HealthMetricEntryCard> createState() => _HealthMetricEntryCardState();
}

class _HealthMetricEntryCardState extends State<HealthMetricEntryCard> {
  late String _currentValue;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue ?? '';
    _textController = TextEditingController(text: _currentValue);
  }

  @override
  void didUpdateWidget(covariant HealthMetricEntryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _currentValue) {
      _currentValue = widget.initialValue ?? '';
      _textController.text = _currentValue;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _emit(String value) {
    setState(() => _currentValue = value);
    widget.onChanged(value);
  }

  Color _bgColor(BuildContext context) {
    final alpha = _kTintAlphas[widget.cardIndex % _kTintAlphas.length];
    final base = context.appColors.surface;
    return Color.alphaBlend(
      AppTheme.primary.withValues(alpha: alpha),
      base,
    );
  }

  @override
  Widget build(BuildContext context) {
    final metric = widget.metric;
    final answered = _currentValue.isNotEmpty;
    final bg = _bgColor(context);

    return Semantics(
      label: answered
          ? '${metric.displayName}: $_currentValue'
          : metric.displayName,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: answered
                    ? AppTheme.primary.withValues(alpha: 0.30)
                    : context.appColors.divider.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Question header ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question number chip
                      if (widget.questionNumber != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 1),
                          child: Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: answered
                                  ? AppTheme.primary
                                  : context.appColors.divider,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${widget.questionNumber}',
                              style: AppTheme.captions.copyWith(
                                color: answered
                                    ? AppTheme.white
                                    : context.appColors.textMuted,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      // Label + unit + check
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    metric.displayName,
                                    style: AppTheme.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context.appColors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (metric.unit != null &&
                                    metric.unit!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      metric.unit!,
                                      style: AppTheme.captions.copyWith(
                                        color: context.appColors.textMuted,
                                      ),
                                    ),
                                  ),
                                if (answered)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: ExcludeSemantics(
                                      child: Icon(
                                        Icons.check_circle_rounded,
                                        size: 16,
                                        color: AppTheme.primary
                                            .withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (metric.description != null &&
                                metric.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  metric.description!,
                                  style: AppTheme.captions.copyWith(
                                    color: context.appColors.textMuted,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Input ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: _buildInput(context, metric),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context, TrackingMetric metric) {
    return switch (metric.metricType) {
      'scale' => _ScaleInput(
          metric: metric,
          currentValue: _currentValue,
          onChanged: _emit,
        ),
      'number' => _NumberInput(
          metric: metric,
          controller: _textController,
          onChanged: _emit,
        ),
      'yesno' => _YesNoInput(
          currentValue: _currentValue,
          onChanged: _emit,
        ),
      'single_choice' => _SingleChoiceInput(
          metric: metric,
          currentValue: _currentValue,
          onChanged: _emit,
        ),
      _ => _TextInput(
          controller: _textController,
          onChanged: _emit,
        ),
    };
  }
}

// ── Scale: styled Slider ───────────────────────────────────────────────────────

class _ScaleInput extends StatefulWidget {
  const _ScaleInput({
    required this.metric,
    required this.currentValue,
    required this.onChanged,
  });

  final TrackingMetric metric;
  final String currentValue;
  final void Function(String) onChanged;

  @override
  State<_ScaleInput> createState() => _ScaleInputState();
}

class _ScaleInputState extends State<_ScaleInput> {
  late double _value;
  bool _touched = false;

  double get _min => (widget.metric.scaleMin ?? 0).toDouble();
  double get _max => (widget.metric.scaleMax ?? 10).toDouble();

  @override
  void initState() {
    super.initState();
    final parsed = double.tryParse(widget.currentValue);
    _value = parsed != null ? parsed.clamp(_min, _max) : _min;
    _touched = parsed != null;
  }

  @override
  void didUpdateWidget(covariant _ScaleInput old) {
    super.didUpdateWidget(old);
    if (old.currentValue != widget.currentValue) {
      final parsed = double.tryParse(widget.currentValue);
      _value = parsed != null ? parsed.clamp(_min, _max) : _min;
      _touched = parsed != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final intVal = _value.round();

    return Column(
      children: [
        Row(
          children: [
            Text(
              _min.toInt().toString(),
              style: AppTheme.captions
                  .copyWith(color: context.appColors.textMuted),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  activeTrackColor:
                      _touched ? AppTheme.primary : context.appColors.divider,
                  inactiveTrackColor: context.appColors.divider,
                  thumbColor: _touched
                      ? AppTheme.primary
                      : context.appColors.textMuted,
                  overlayColor: AppTheme.primary.withValues(alpha: 0.12),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Semantics(
                  slider: true,
                  label: widget.metric.displayName,
                  value: intVal.toString(),
                  child: Slider(
                    value: _value,
                    min: _min,
                    max: _max,
                    divisions: (_max - _min).round(),
                    onChanged: (v) {
                      setState(() {
                        _value = v;
                        _touched = true;
                      });
                      widget.onChanged(v.round().toString());
                    },
                  ),
                ),
              ),
            ),
            Text(
              _max.toInt().toString(),
              style: AppTheme.captions
                  .copyWith(color: context.appColors.textMuted),
            ),
          ],
        ),
        if (_touched)
          Text(
            intVal.toString(),
            style: AppTheme.body.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

// ── Yes / No ──────────────────────────────────────────────────────────────────

class _YesNoInput extends StatelessWidget {
  const _YesNoInput({
    required this.currentValue,
    required this.onChanged,
  });

  final String currentValue;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        _StyledChip(
          label: context.l10n.commonYes,
          selected: currentValue == 'yes',
          selectedColor: AppTheme.success,
          onSelected: (_) => onChanged('yes'),
        ),
        _StyledChip(
          label: context.l10n.commonNo,
          selected: currentValue == 'no',
          selectedColor: AppTheme.error,
          onSelected: (_) => onChanged('no'),
        ),
      ],
    );
  }
}

class _StyledChip extends StatelessWidget {
  const _StyledChip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final void Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: selectedColor.withValues(alpha: 0.15),
        backgroundColor: context.appColors.surfaceSubtle,
        side: BorderSide(
          color: selected ? selectedColor : context.appColors.divider,
          width: selected ? 1.5 : 1,
        ),
        checkmarkColor: selectedColor,
        showCheckmark: false,
        labelStyle: AppTheme.body.copyWith(
          color:
              selected ? selectedColor : context.appColors.textMuted,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// ── Single choice: AppDropdownInput ───────────────────────────────────────────

class _SingleChoiceInput extends StatelessWidget {
  const _SingleChoiceInput({
    required this.metric,
    required this.currentValue,
    required this.onChanged,
  });

  final TrackingMetric metric;
  final String currentValue;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final options = metric.choiceOptions ?? [];
    final selectedValue = currentValue.isNotEmpty ? currentValue : null;

    return AppDropdownInput<String>(
      label: metric.displayName,
      value: selectedValue,
      isRequired: false,
      options: options
          .map((opt) => AppDropdownInputOption<String>(
                label: opt,
                value: opt,
              ))
          .toList(),
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }
}

// ── Number: AppTextInput ──────────────────────────────────────────────────────

class _NumberInput extends StatelessWidget {
  const _NumberInput({
    required this.metric,
    required this.controller,
    required this.onChanged,
  });

  final TrackingMetric metric;
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextInput(
      label: metric.unit != null && metric.unit!.isNotEmpty
          ? '${metric.displayName} (${metric.unit})'
          : metric.displayName,
      controller: controller,
      hintText: metric.unit ?? '',
      isRequired: false,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      maxLength: 20,
      onChanged: onChanged,
    );
  }
}

// ── Text: AppTextInput (multi-line) ───────────────────────────────────────────

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextInput(
      label: context.l10n.healthTrackingEnterText,
      controller: controller,
      isRequired: false,
      maxLength: 500,
      onChanged: onChanged,
    );
  }
}
