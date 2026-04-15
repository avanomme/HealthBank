// Created with the Assistance of Claude Code
// frontend/lib/features/surveys/widgets/question_types/yesno_question_widget.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

/// Widget for Yes/No boolean questions.
///
/// Displays two toggle buttons for Yes and No options.
class YesNoQuestionWidget extends StatelessWidget {
  const YesNoQuestionWidget({
    super.key,
    required this.questionText,
    required this.onChanged,
    this.value,
    this.isRequired = false,
  });

  /// The question text to display
  final String questionText;

  /// Callback when the value changes
  final ValueChanged<bool?> onChanged;

  /// Current selected value (true = Yes, false = No, null = none)
  final bool? value;

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
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Semantics(
                label: context.l10n.commonYes,
                child: AppFilledButton(
                  label: context.l10n.commonYes,
                  onPressed: () => onChanged(true),
                  backgroundColor:
                      value == true ? AppTheme.primary : context.appColors.divider,
                  textColor:
                      value == true ? AppTheme.textContrast : context.appColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Semantics(
                label: context.l10n.commonNo,
                child: AppFilledButton(
                  label: context.l10n.commonNo,
                  onPressed: () => onChanged(false),
                  backgroundColor:
                      value == false ? AppTheme.primary : context.appColors.divider,
                  textColor:
                      value == false ? AppTheme.textContrast : context.appColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
