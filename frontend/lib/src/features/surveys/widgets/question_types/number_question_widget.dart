// Created with the Assistance of Claude Code
// frontend/lib/features/surveys/widgets/question_types/number_question_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Widget for numeric input questions.
///
/// Displays a text field that accepts only numeric input with optional
/// min/max validation.
class NumberQuestionWidget extends StatefulWidget {
  const NumberQuestionWidget({
    super.key,
    required this.questionText,
    required this.onChanged,
    this.value,
    this.isRequired = false,
    this.min,
    this.max,
  });

  /// The question text to display
  final String questionText;

  /// Callback when the value changes
  final ValueChanged<int?> onChanged;

  /// Initial value
  final int? value;

  /// Whether this question is required
  final bool isRequired;

  /// Minimum allowed value
  final int? min;

  /// Maximum allowed value
  final int? max;

  @override
  State<NumberQuestionWidget> createState() => _NumberQuestionWidgetState();
}

class _NumberQuestionWidgetState extends State<NumberQuestionWidget> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.isEmpty) {
      setState(() => _errorText = null);
      widget.onChanged(null);
      return;
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      setState(() => _errorText = 'Please enter a valid number');
      return;
    }

    if (widget.min != null && widget.max != null) {
      if (parsed < widget.min! || parsed > widget.max!) {
        setState(() {
          _errorText = 'Value must be between ${widget.min} and ${widget.max}';
        });
        return;
      }
    }

    setState(() => _errorText = null);
    widget.onChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.questionText,
      child: Column(
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
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
          ],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            errorText: _errorText,
            hintText: context.l10n.surveyNumberQuestionHint,
          ),
          onChanged: _onChanged,
        ),
      ],
      ),
    );
  }
}
