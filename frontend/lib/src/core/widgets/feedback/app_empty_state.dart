// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/feedback/app_empty_state.dart
/// Reusable empty/error state widget with icon, title, subtitle, and action.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

/// Empty-state/error placeholder with a large icon, title, optional subtitle, and action button.
///
/// Use the [AppEmptyState.error] named constructor for a red-icon error variant.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconSize = 64,
    this.iconColor,
    this.centered = true,
  });

  /// Error variant with red icon.
  const AppEmptyState.error({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.iconSize = 64,
    this.centered = true,
  })  : icon = Icons.error_outline,
        iconColor = AppTheme.error;

  /// Icon displayed above the title.
  final IconData icon;

  /// Title text.
  final String title;

  /// Optional subtitle/description.
  final String? subtitle;

  /// Optional action widget (e.g. a retry button).
  final Widget? action;

  /// Size of the icon. Defaults to 64.
  final double iconSize;

  /// Icon color override. Defaults to [context.appColors.textMuted].
  final Color? iconColor;

  /// Whether to wrap in [Center] for vertical centering. Defaults to true.
  /// Set to false when inside a scrollable list where top alignment is wanted.
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final inner = Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: iconColor ?? context.appColors.textMuted,
              ),
              const SizedBox(height: 16),
              AppText(
                title,
                variant: AppTextVariant.headlineSmall,
                color: context.appColors.textPrimary,
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                AppText(
                  subtitle!,
                  variant: AppTextVariant.bodyMedium,
                  color: context.appColors.textMuted,
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: 24),
                action!,
              ],
            ],
          ),
        );

        final scrollableInner = SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: centered && constraints.hasBoundedHeight
                  ? constraints.maxHeight
                  : 0,
            ),
            child: centered
                ? Center(child: inner)
                : Align(alignment: Alignment.topCenter, child: inner),
          ),
        );

        return scrollableInner;
      },
    );
  }
}
