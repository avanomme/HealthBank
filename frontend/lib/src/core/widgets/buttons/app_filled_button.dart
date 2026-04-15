// Created with the Assistance of ChatGPT

/// AppFilledButton
///
/// Description:
/// - A theme-aware filled button with a background and label.
/// - `AppFilledButton` is a reusable button widget for primary actions.
///
/// Features:
/// - Uses AppTheme colors for enabled/disabled states.
/// - Responsive padding based on global breakpoints.
/// - Standard Flutter `onPressed` handling.
///
/// Usage Example:
/// ```dart
/// AppFilledButton(
///   label: 'Save changes',
///   onPressed: () {},
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.textStyle,
  });

  /// Button label text.
  final String label;

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional text color override.
  final Color? textColor;

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

    final baseStyle = textTheme.bodyMedium ?? AppTheme.body;
    final resolvedStyle = (textStyle ?? baseStyle).copyWith(
      color: textColor ?? AppTheme.textContrast,
      fontWeight: textStyle?.fontWeight ?? FontWeight.w600,
    );

    final resolvedBackground = backgroundColor ?? AppTheme.primary;
    const disabledBackground = AppTheme.muted;
    const disabledForeground = AppTheme.textContrast;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: resolvedPadding,
        minimumSize: const Size(0, 44),
        backgroundColor: resolvedBackground,
        foregroundColor: resolvedStyle.color,
        disabledBackgroundColor: disabledBackground,
        disabledForegroundColor: disabledForeground,
        textStyle: resolvedStyle,
      ),
      child: Text(label),
    );
  }
}
