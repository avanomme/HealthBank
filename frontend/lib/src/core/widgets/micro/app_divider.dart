// Created with the Assistance of ChatGPT

/// AppDivider
///
/// Description:
/// - A theme-aware visual separator with configurable spacing and thickness.
/// - `AppDivider` is a **micro-widget** designed to be reused across the app.
///
/// Features:
/// - Theme-aware: defaults to AppTheme divider colors.
/// - Responsive spacing: adapts to breakpoints when spacing is not provided.
///
/// Usage Example:
/// ```
/// const AppDivider(thickness: 1, spacing: 20);
/// ```
library;


import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.thickness,
    this.spacing,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  });

  /// Thickness of the line.
  final double? thickness;

  /// Total vertical space reserved for the divider.
  final double? spacing;

  /// Optional color override.
  final Color? color;

  /// Horizontal insets.
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final resolvedThickness = thickness ?? 1;
    final resolvedSpacing = math.max(resolvedThickness, spacing ?? _spacingForBreakpoint(bp));
    final resolvedColor = color ?? context.appColors.divider;

    return SizedBox(
      height: resolvedSpacing,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: indent, right: endIndent),
          child: Container(
            height: resolvedThickness,
            color: resolvedColor,
          ),
        ),
      ),
    );
  }

  double _spacingForBreakpoint(Breakpoint bp) {
    return switch (bp) {
      Breakpoint.compact => 12,
      Breakpoint.medium => 16,
      Breakpoint.expanded => 20,
    };
  }
}
