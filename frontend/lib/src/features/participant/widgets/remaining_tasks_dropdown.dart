// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/remaining_tasks_dropdown.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Dropdown showing remaining tasks count
///
/// Matches the Figma design: "Remaining tasks for today: X" with dropdown arrow
class RemainingTasksDropdown extends StatelessWidget {
  const RemainingTasksDropdown({
    super.key,
    required this.remainingCount,
    this.onTap,
  });

  /// Number of remaining tasks
  final int remainingCount;

  /// Callback when dropdown is tapped
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: context.appColors.divider,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Remaining tasks for today: $remainingCount',
              style: AppTheme.captions.copyWith(
                color: context.appColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_drop_down,
              color: context.appColors.textPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
