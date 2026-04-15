// Created with the Assistance of Claude Code
// frontend/lib/features/surveys/widgets/question_types/single_choice_widget.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Widget for single-choice questions.
///
/// Displays radio buttons for selecting one option from a list.
class SingleChoiceWidget extends StatelessWidget {
  const SingleChoiceWidget({
    super.key,
    required this.questionText,
    required this.options,
    required this.onChanged,
    this.value,
    this.isRequired = false,
  });

  /// The question text to display
  final String questionText;

  /// List of available options
  final List<String> options;

  /// Callback when the value changes
  final ValueChanged<String?> onChanged;

  /// Currently selected option
  final String? value;

  /// Whether this question is required
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                questionText,
                style: AppTheme.body,
              ),
            ),
            if (isRequired)
              Text(
                '*',
                style: AppTheme.body.copyWith(color: AppTheme.error),
              ),
          ],
        ),
        const SizedBox(height: 8),
        RadioGroup<String>(
          groupValue: value,
          onChanged: onChanged,
          child: Column(
            children: options
                .map((option) => RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      toggleable: true,
                      activeColor: AppTheme.primary,
                      contentPadding: EdgeInsets.zero,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
