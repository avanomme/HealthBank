// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/task_progress_bar.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Task progress bar widget showing completion status
///
/// Matches the Figma design:
/// - "Your Task Progress:" label
/// - Green progress bar
/// - "X out of Y tasks completed" text
class TaskProgressBar extends StatelessWidget {
  const TaskProgressBar({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
  });

  /// Number of completed tasks
  final int completedTasks;

  /// Total number of tasks
  final int totalTasks;

  @override
  Widget build(BuildContext context) {
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          context.l10n.participantTaskProgressLabel,
          style: AppTheme.body.copyWith(
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 8),

        // Progress bar
        Container(
          height: 24,
          decoration: BoxDecoration(
            color: context.appColors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.success,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Completion text
        Text(
          context.l10n.participantTasksCompletedLabel(completedTasks, totalTasks),
          style: AppTheme.captions.copyWith(
            color: context.appColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
