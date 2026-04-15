// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/view_all_tasks_button.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

/// View All Tasks button widget
///
/// Matches the Figma design: Full-width primary button
class ViewAllTasksButton extends StatelessWidget {
  const ViewAllTasksButton({
    super.key,
    this.onPressed,
  });

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: AppFilledButton(
        label: context.l10n.participantViewAllTasks,
        onPressed: onPressed,
        backgroundColor: AppTheme.primary,
        textColor: AppTheme.textContrast,
      ),
    );
  }
}
