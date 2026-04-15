// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/micro/app_icon_badge.dart

/// AppIconBadge
///
/// An icon displayed inside a colored background container at low alpha.
/// Replaces the repeated pattern of Container(color.withValues(alpha: 0.1))
/// wrapping an Icon found throughout the codebase.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    super.key,
    required this.icon,
    this.color = AppTheme.primary,
    this.size = 48,
    this.iconSize,
    this.radius = 8,
    this.alpha = 0.1,
    this.child,
  });

  /// Icon to display.
  final IconData icon;

  /// Theme color for both background (at [alpha]) and icon.
  final Color color;

  /// Container size (width and height). Defaults to 48.
  final double size;

  /// Icon size. Defaults to size * 0.5.
  final double? iconSize;

  /// Corner radius. Defaults to 8.
  final double radius;

  /// Background alpha. Defaults to 0.1.
  final double alpha;

  /// Optional child to display instead of the icon (e.g. centered text).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: child ??
            Icon(
              icon,
              color: color,
              size: iconSize ?? size * 0.5,
            ),
      ),
    );
  }
}
