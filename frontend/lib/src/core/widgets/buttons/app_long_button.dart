// Created with the Assistance of ChatGPT

/// AppLongButton
///
/// Description:
/// - A full-width filled button that expands to its parent container.
/// - `AppLongButton` is a reusable button widget for prominent actions.
///
/// Features:
/// - Composes AppFilledButton for consistent styling.
/// - Expands to the full available width without hard-coded sizing.
/// - Standard Flutter `onPressed` handling.
///
/// Usage Example:
/// ```dart
/// AppLongButton(
///   label: 'Continue',
///   onPressed: () {},
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/widgets/buttons/app_filled_button.dart';

class AppLongButton extends StatelessWidget {
  const AppLongButton({
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
    return SizedBox(
      width: double.infinity,
      child: AppFilledButton(
        label: label,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        textColor: textColor,
        padding: padding,
        textStyle: textStyle,
      ),
    );
  }
}
