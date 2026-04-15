// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/buttons/app_outlined_button.dart

/// AppOutlinedButton
///
/// Description:
/// - A theme-aware outlined button with optional icon.
/// - Replaces the repeated `OutlinedButton.icon(icon: Icon(Icons.refresh),
///   label: Text('Retry'))` pattern found across 5+ pages.
///
/// Features:
/// - Uses AppTheme colors for enabled/disabled states.
/// - Responsive padding based on global breakpoints.
/// - Optional leading icon slot.
/// - Standard Flutter `onPressed` handling.
///
/// Usage Example:
/// ```dart
/// AppOutlinedButton(
///   label: 'Retry',
///   icon: Icons.refresh,
///   onPressed: () {},
/// )
/// AppOutlinedButton(
///   label: 'Cancel',
///   onPressed: () {},
///   foregroundColor: AppTheme.error,
///   borderColor: AppTheme.error,
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.borderColor,
    this.foregroundColor,
    this.padding,
    this.textStyle,
  });

  /// Button label text.
  final String label;

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Border color override (default: AppTheme.primary).
  final Color? borderColor;

  /// Text and icon color override (default: AppTheme.primary).
  final Color? foregroundColor;

  /// Optional padding override.
  final EdgeInsets? padding;

  /// Optional text style override.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);

    final basePadding = Breakpoints.responsivePadding(width);
    final resolvedPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: basePadding * 0.8,
          vertical: basePadding * 0.5,
        );

    final resolvedForeground = foregroundColor ?? AppTheme.primary;
    final resolvedBorder = borderColor ?? resolvedForeground;

    final baseStyle = textTheme.bodyMedium ?? AppTheme.body;
    final resolvedStyle = (textStyle ?? baseStyle).copyWith(
      color: resolvedForeground,
      fontWeight: textStyle?.fontWeight ?? FontWeight.w600,
    );

    final buttonStyle = OutlinedButton.styleFrom(
      padding: resolvedPadding,
      foregroundColor: resolvedForeground,
      textStyle: resolvedStyle,
      side: BorderSide(color: resolvedBorder),
      disabledForegroundColor: AppTheme.muted,
    );

    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: buttonStyle,
        icon: Icon(icon, size: 18),
        label: Text(label),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(label),
    );
  }
}
