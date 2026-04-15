// Created with the Assistance of ChatGPT

/// AppIcon
///
/// Description:
/// - A small, theme-aware icon wrapper for consistent icon rendering.
/// - `AppIcon` is a **micro-widget** designed to be reused across the app.
///
/// Features:
/// - Theme-aware: respects the current icon theme and AppTheme colors.
/// - Responsive sizing: adapts to breakpoints when size is not provided.
///
/// Usage Example:
/// ```
/// const AppIcon(
///   Icons.security,
///   color: AppTheme.primary,
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
  });

  final IconData icon;

  /// Optional size override.
  final double? size;

  /// Optional color override.
  final Color? color;

  /// Optional accessibility label.
  final String? semanticLabel;

  /// Optional text direction.
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final iconTheme = IconTheme.of(context);

    final resolvedSize = size ?? _sizeForBreakpoint(bp) ?? iconTheme.size ?? 20;
    final resolvedColor = color ?? iconTheme.color ?? context.appColors.textPrimary;

    final iconWidget = Icon(
      icon,
      size: resolvedSize,
      color: resolvedColor,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );

    // When no semantic label is provided the icon is purely decorative.
    // Exclude it from the accessibility tree so screen readers skip it.
    if (semanticLabel == null) {
      return ExcludeSemantics(child: iconWidget);
    }
    return iconWidget;
  }

  double? _sizeForBreakpoint(Breakpoint bp) {
    return switch (bp) {
      Breakpoint.compact => 16,
      Breakpoint.medium => 18,
      Breakpoint.expanded => 20,
    };
  }
}
