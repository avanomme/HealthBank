// Created with the Assistance of Codex

/// AppCardTask
///
/// Description:
/// - A task card with title, due text, optional repeat text, and a single action.
/// - `AppCardTask` is a reusable data-display widget for actionable task rows.
///
/// Features:
/// - Theme-aware styling via AppTheme.
/// - Responsive layout that stacks on compact screens.
/// - Uses AppFilledButton for consistent action styling.
///
/// Usage Example:
/// ```dart
/// AppCardTask(
///   title: 'Daily Check-In',
///   dueText: 'Due today at 2:30 PM',
///   repeatText: 'Repeats every 3 days',
///   actionLabel: 'Do Task',
///   onAction: () {},
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_filled_button.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

class AppCardTask extends StatelessWidget {
  const AppCardTask({
    super.key,
    required this.title,
    required this.dueText,
    required this.actionLabel,
    this.repeatText,
    this.onAction,
    this.actionColor,
    this.actionTextColor,
    this.padding,
  });

  /// Task title displayed at the top.
  final String title;

  /// Due date/time text (e.g., "Due today at 2:30 PM").
  final String dueText;

  /// Optional repeat text (e.g., "Repeats every 3 days").
  final String? repeatText;

  /// Label for the action button.
  final String actionLabel;

  /// Callback invoked when the action button is pressed.
  final VoidCallback? onAction;

  /// Optional action button background color override.
  final Color? actionColor;

  /// Optional action button text color override.
  final Color? actionTextColor;

  /// Optional padding override for the card content.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final basePadding = Breakpoints.responsivePadding(width);
    final resolvedPadding =
        padding ?? EdgeInsets.all(basePadding * 0.65);
    final radius = BorderRadius.circular(basePadding * 0.25);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = Breakpoints.isMobile(constraints.maxWidth);
        final gap = basePadding * 0.6;

        final colors = context.appColors;
        final textColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              variant: AppTextVariant.bodyLarge,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
            SizedBox(height: basePadding * 0.2),
            AppText(
              dueText,
              variant: AppTextVariant.bodySmall,
              color: colors.textMuted,
            ),
            if (repeatText != null) ...[
              SizedBox(height: basePadding * 0.15),
              AppText(
                repeatText!,
                variant: AppTextVariant.bodySmall,
                color: colors.textMuted,
              ),
            ],
          ],
        );

        final actionButton = AppFilledButton(
          label: actionLabel,
          onPressed: onAction,
          backgroundColor: actionColor,
          textColor: actionTextColor,
        );

        return Container(
          padding: resolvedPadding,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: radius,
            border: Border.all(color: colors.divider),
          ),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    textColumn,
                    SizedBox(height: gap),
                    actionButton,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: textColumn),
                    SizedBox(width: gap),
                    actionButton,
                  ],
                ),
        );
      },
    );
  }
}
