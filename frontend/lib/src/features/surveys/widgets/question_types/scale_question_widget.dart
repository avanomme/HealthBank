// Created with the Assistance of Claude Code
// frontend/lib/features/surveys/widgets/question_types/scale_question_widget.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Widget for scale/rating questions.
///
/// Displays a slider for selecting a value within a range.
class ScaleQuestionWidget extends StatefulWidget {
  const ScaleQuestionWidget({
    super.key,
    required this.questionText,
    required this.min,
    required this.max,
    required this.onChanged,
    this.value,
    this.isRequired = false,
    this.divisions,
    this.minLabel,
    this.maxLabel,
  });

  /// The question text to display
  final String questionText;

  /// Minimum scale value
  final double min;

  /// Maximum scale value
  final double max;

  /// Callback when the value changes
  final ValueChanged<double> onChanged;

  /// Current value
  final double? value;

  /// Whether this question is required
  final bool isRequired;

  /// Number of discrete divisions
  final int? divisions;

  /// Label for the minimum end
  final String? minLabel;

  /// Label for the maximum end
  final String? maxLabel;

  @override
  State<ScaleQuestionWidget> createState() => _ScaleQuestionWidgetState();
}

class _ScaleQuestionWidgetState extends State<ScaleQuestionWidget> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value ?? widget.min;
  }

  @override
  void didUpdateWidget(ScaleQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != null) {
      _currentValue = widget.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate display value (show as int if divisions exist)
    final displayValue = widget.divisions != null
        ? _currentValue.round().toString()
        : _currentValue.toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.questionText,
                style: AppTheme.body,
              ),
            ),
            if (widget.isRequired)
              Text(
                '*',
                style: AppTheme.body.copyWith(color: AppTheme.error),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Semantics(
            header: true,
            child: Text(
              displayValue,
              style: AppTheme.heading4.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (widget.minLabel != null)
              Expanded(
                child: Text(
                  widget.minLabel!,
                  style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
                ),
              ),
            Expanded(
              flex: 3,
              child: Slider(
                value: _currentValue,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                activeColor: AppTheme.primary,
                onChanged: (value) {
                  setState(() => _currentValue = value);
                  widget.onChanged(value);
                },
              ),
            ),
            if (widget.maxLabel != null)
              Expanded(
                child: Text(
                  widget.maxLabel!,
                  style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
                  textAlign: TextAlign.end,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
