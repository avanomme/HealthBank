// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/micro/app_your_answer_row.dart

/// AppYourAnswerRow
///
/// Displays a participant's answer with a person icon prefix.
/// Used in chart sections and results pages to show "Your Answer: value".
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppYourAnswerRow extends StatelessWidget {
  const AppYourAnswerRow({
    super.key,
    required this.label,
    required this.value,
    this.color = AppTheme.primary,
  });

  /// Label text (e.g. localized "Your Answer").
  final String label;

  /// The answer value to display.
  final String value;

  /// Color for the icon and text. Defaults to primary.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ExcludeSemantics(child: Icon(Icons.person, size: 16, color: color)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '$label: $value',
            style: AppTheme.captions.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
