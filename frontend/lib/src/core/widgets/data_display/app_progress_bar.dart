// Created with the Assistance of Codex
/// AppProgressBar
///
/// Description:
/// - A theme-aware horizontal progress bar for visualizing completion.
/// - `AppProgressBar` is a reusable data-display widget for progress states.
///
/// Features:
/// - Uses AppTheme colors by default with optional overrides.
/// - Responsive sizing based on global breakpoints.
/// - Supports accessibility semantics for screen readers.
///
/// Usage Example:
/// ```dart
/// const AppProgressBar(
///   progress: 0.6,
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.progressColor,
    this.height,
    this.borderRadius,
    this.semanticLabel,
  });

  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional progress fill color override.
  final Color? progressColor;

  /// Optional height override.
  final double? height;

  /// Optional border radius override.
  final BorderRadius? borderRadius;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final basePadding = Breakpoints.responsivePadding(width);
    final resolvedHeight = height ?? basePadding * 0.7;
    final resolvedRadius =
        borderRadius ?? BorderRadius.circular(basePadding * 0.25);
    final clampedProgress = progress.clamp(0.0, 1.0).toDouble();

    return Semantics(
      label: semanticLabel,
      value: '${(clampedProgress * 100).round()}%',
      child: Container(
        height: resolvedHeight,
        decoration: BoxDecoration(
          color: backgroundColor ?? context.appColors.divider,
          borderRadius: resolvedRadius,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: clampedProgress,
            child: Container(
              decoration: BoxDecoration(
                color: progressColor ?? AppTheme.success,
                borderRadius: resolvedRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
