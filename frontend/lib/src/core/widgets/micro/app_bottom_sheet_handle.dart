// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/micro/app_bottom_sheet_handle.dart

/// AppBottomSheetHandle
///
/// Description:
/// - The standard drag handle bar at the top of bottom sheets.
/// - A small rounded rectangle in muted color, centered horizontally.
/// - Replaces the repeated `Container(width: 40, height: 4,
///   decoration: BoxDecoration(borderRadius: 2, color: textMuted))` pattern.
///
/// Usage Example:
/// ```dart
/// DraggableScrollableSheet(
///   builder: (context, controller) => Column(
///     children: [
///       const AppBottomSheetHandle(),
///       Expanded(child: ListView(...)),
///     ],
///   ),
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppBottomSheetHandle extends StatelessWidget {
  const AppBottomSheetHandle({
    super.key,
    this.color,
    this.width = 40,
    this.height = 4,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  /// Handle bar color (default: textMuted at 40% opacity).
  final Color? color;

  /// Handle bar width (default: 40).
  final double width;

  /// Handle bar height (default: 4).
  final double height;

  /// Padding around the handle (default: 8px vertical).
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color ?? context.appColors.textMuted.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}
