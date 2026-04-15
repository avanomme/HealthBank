// Created with the Assistance of Claude Code
// frontend/lib/features/surveys/widgets/question_types/openended_question_widget.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Widget for open-ended text questions.
///
/// Displays a multi-line text field for free-form responses.
class OpenEndedQuestionWidget extends StatefulWidget {
  const OpenEndedQuestionWidget({
    super.key,
    required this.questionText,
    required this.onChanged,
    this.value,
    this.isRequired = false,
    this.maxLines = 4,
    this.maxLength,
  });

  /// The question text to display
  final String questionText;

  /// Callback when the value changes
  final ValueChanged<String?> onChanged;

  /// Initial value
  final String? value;

  /// Whether this question is required
  final bool isRequired;

  /// Number of visible lines
  final int maxLines;

  /// Maximum character length
  final int? maxLength;

  @override
  State<OpenEndedQuestionWidget> createState() => _OpenEndedQuestionWidgetState();
}

class _OpenEndedQuestionWidgetState extends State<OpenEndedQuestionWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: context.l10n.surveyOpenEndedHint,
          ),
          onChanged: (value) {
            widget.onChanged(value.isEmpty ? null : value);
          },
        ),
      ],
    );
  }
}
