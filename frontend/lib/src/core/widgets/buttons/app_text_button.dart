// Created with the Assistance of ChatGPT

/// AppTextButton
///
/// Description:
/// - A theme-aware text button with no background fill.
/// - `AppTextButton` is a reusable button widget for inline actions.
///
/// Features:
/// - Uses global typography and color tokens from AppTheme.
/// - Responsive padding based on global breakpoints.
/// - Standard Flutter `onPressed` handling.
///
/// Usage Example:
/// ```dart
/// AppTextButton(
///   label: 'Learn more',
///   onPressed: () {},
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.textStyle,
    this.textColor,
    this.padding,
  });

  /// Button label text.
  final String label;

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional text style override.
  final TextStyle? textStyle;

  /// Optional text color override.
  final Color? textColor;

  /// Optional padding override.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);

    final basePadding = Breakpoints.responsivePadding(width);
    final resolvedPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: basePadding * 0.6,
          vertical: basePadding * 0.4,
        );

    final baseStyle = textTheme.bodyMedium ?? AppTheme.body;
    final resolvedStyle = (textStyle ?? baseStyle).copyWith(
      color: textColor ?? AppTheme.primary,
      fontWeight: textStyle?.fontWeight ?? FontWeight.w600,
    );

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: resolvedPadding,
        foregroundColor: resolvedStyle.color,
        textStyle: resolvedStyle,
      ),
      child: Text(label),
    );
  }
}
