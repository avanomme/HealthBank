// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

/// Task card widget displaying a single task item
///
/// Matches the Figma design:
/// - Task title
/// - Due time/date
/// - Optional repeat info
/// - "Do Task" button
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.dueTime,
    this.repeatInfo,
    this.onDoTask,
  });

  /// Task title
  final String title;

  /// Due time/date text (e.g., "Due today at 2:30pm")
  final String dueTime;

  /// Optional repeat information (e.g., "Repeats every 3 days")
  final String? repeatInfo;

  /// Callback when "Do Task" button is pressed
  final VoidCallback? onDoTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: context.appColors.divider,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dueTime,
                  style: AppTheme.captions.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
                if (repeatInfo != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    repeatInfo!,
                    style: AppTheme.captions.copyWith(
                      color: context.appColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Do Task button
          AppFilledButton(
            label: context.l10n.participantDoTask,
            onPressed: onDoTask,
            backgroundColor: AppTheme.caution,
            textColor: context.appColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ],
      ),
    );
  }
}
