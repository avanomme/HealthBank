// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/micro/app_user_avatar.dart

/// AppUserAvatar
///
/// Description:
/// - A circular avatar showing a user's initial character on a tinted background.
/// - Replaces the repeated `CircleAvatar(backgroundColor: color.withAlpha(26),
///   child: Text(initial))` pattern found across messaging, admin, and auth pages.
///
/// Features:
/// - Theme-aware: uses AppTheme colors by default.
/// - Configurable radius, colors, and font size.
/// - Automatically extracts the first character from the name.
/// - Handles empty/null names gracefully with a '?' fallback.
///
/// Usage Example:
/// ```dart
/// AppUserAvatar(name: 'John Doe')
/// AppUserAvatar(name: 'Jane', radius: 24, backgroundColor: AppTheme.info)
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppUserAvatar extends StatelessWidget {
  const AppUserAvatar({
    super.key,
    required this.name,
    this.radius = 18,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
  });

  /// The user's display name. The first character is shown as the initial.
  final String name;

  /// Avatar radius (default: 18).
  final double radius;

  /// Background color override. Defaults to AppTheme.primary at 10% opacity.
  final Color? backgroundColor;

  /// Text/initial color override. Defaults to AppTheme.primary.
  final Color? foregroundColor;

  /// Font size for the initial character. Defaults to radius * 0.8.
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final fgColor = foregroundColor ?? AppTheme.primary;
    final bgColor =
        backgroundColor ?? AppTheme.primary.withValues(alpha: 0.1);

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Text(
        initial,
        style: TextStyle(
          color: fgColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? radius * 0.8,
        ),
      ),
    );
  }
}
