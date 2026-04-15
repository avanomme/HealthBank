// Created with the Assistance of ChatGPT

/// AppStatusDot
///
/// Description:
/// - A notification indicator that overlays a dot on an icon.
/// - `AppStatusDot` is a **micro-widget** designed to be reused across the app.
///
/// Features:
/// - Theme-aware: indicator color defaults to AppTheme semantic colors.
/// - Responsive sizing: adapts to breakpoints when indicator size is not provided.
/// - Simple on/off indicator: shows a dot when notifications are present.
///
/// Usage Example:
/// ```
/// AppStatusDot(
///   icon: const AppIcon(Icons.mail),
///   hasNotification: true,
/// );
/// ```
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppStatusDot extends StatelessWidget {
  const AppStatusDot({
    super.key,
    required this.icon,
    this.hasNotification = false,
    this.indicatorColor,
    this.indicatorSize,
  });

  /// Base icon that the indicator overlays.
  final Widget icon;

  /// Whether to show the indicator dot.
  final bool hasNotification;

  /// Optional indicator color override.
  final Color? indicatorColor;

  /// Optional indicator size override.
  final double? indicatorSize;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final theme = Theme.of(context);

    final resolvedSize = indicatorSize ?? _sizeForBreakpoint(bp);
    final resolvedColor = indicatorColor ?? AppTheme.caution;

    if (!hasNotification) {
      return icon;
    }

    final borderColor = theme.scaffoldBackgroundColor;
    final borderWidth = math.max(1.0, resolvedSize * 0.2);
    final offset = resolvedSize * 0.25;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        icon,
        Positioned(
          top: -offset,
          right: -offset,
          child: _NotificationDot(
            color: resolvedColor,
            size: resolvedSize,
            borderColor: borderColor,
            borderWidth: borderWidth,
          ),
        ),
      ],
    );
  }

  double _sizeForBreakpoint(Breakpoint bp) {
    return switch (bp) {
      Breakpoint.compact => 8,
      Breakpoint.medium => 10,
      Breakpoint.expanded => 12,
    };
  }
}

class _NotificationDot extends StatelessWidget {
  const _NotificationDot({
    required this.color,
    required this.size,
    required this.borderColor,
    required this.borderWidth,
  });

  final Color color;
  final double size;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
      ),
    );
  }
}
