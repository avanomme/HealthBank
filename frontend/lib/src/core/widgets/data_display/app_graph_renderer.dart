// Created with the Assistance of Codex
/// AppGraphRenderer
///
/// Description:
/// - A card container for rendering graphs or diagram placeholders.
/// - `AppGraphRenderer` is a reusable data-display widget for dashboard visuals.
///
/// Features:
/// - Theme-aware card styling with responsive padding.
/// - Optional child content, otherwise renders a placeholder panel.
/// - Configurable height and placeholder text.
///
/// Usage Example:
/// ```dart
/// const AppGraphRenderer(
///   title: 'Weekly Summary',
///   placeholderText: 'Graph placeholder',
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

class AppGraphRenderer extends StatelessWidget {
  const AppGraphRenderer({
    super.key,
    required this.title,
    this.child,
    this.placeholderText,
    this.height,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.placeholderColor,
  });

  /// Title displayed above the graph area.
  final String title;

  /// Optional graph/chart widget to render.
  final Widget? child;

  /// Placeholder text shown when [child] is null.
  final String? placeholderText;

  /// Optional height override for the graph area.
  final double? height;

  /// Optional padding override for the card.
  final EdgeInsets? padding;

  /// Optional background color override for the card.
  final Color? backgroundColor;

  /// Optional border color override for the card.
  final Color? borderColor;

  /// Optional background color override for the placeholder panel.
  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final basePadding = Breakpoints.responsivePadding(width);
    final resolvedPadding =
        padding ?? EdgeInsets.all(basePadding * 0.65);
    final radius = BorderRadius.circular(basePadding * 0.25);
    final resolvedHeight = height ?? basePadding * 6.5;
    final resolvedPlaceholderColor =
        placeholderColor ?? AppTheme.placeholder.withValues(alpha: 0.35);

    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        borderRadius: radius,
        border: Border.all(color: borderColor ?? colors.divider),
        boxShadow: colors.cardShadow,
      ),
      child: Padding(
        padding: resolvedPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              variant: AppTextVariant.bodyLarge,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
            SizedBox(height: basePadding * 0.5),
            if (child != null)
              // Real chart: use SizedBox to provide bounded height for
              // children that use FractionallySizedBox or similar.
              SizedBox(
                height: resolvedHeight,
                child: child,
              )
            else
              // Placeholder: fixed height so the card doesn't collapse
              Container(
                height: resolvedHeight,
                decoration: BoxDecoration(
                  color: resolvedPlaceholderColor,
                  borderRadius: radius,
                ),
                child: Center(
                  child: AppText(
                    placeholderText ?? '',
                    variant: AppTextVariant.bodySmall,
                    color: colors.textMuted,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
