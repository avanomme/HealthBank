// Created with the Assistance of ChatGPT

/// AppOverlay
///
/// Description:
/// - A full-screen overlay layer used to block interactions behind it.
/// - `AppOverlay` is a **basic widget** designed to be reused across the app.
///
/// Features:
/// - Non-interactive barrier to prevent background interactions.
/// - Optional child content rendered above the barrier.
/// - Theme-aware default barrier color.
///
/// Usage Example:
/// ```dart
/// const AppOverlay();
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppOverlay extends StatelessWidget {
  const AppOverlay({
    super.key,
    this.child,
    this.barrierColor,
    this.barrierOpacity = 0.45,
  });

  /// Optional child rendered above the overlay barrier.
  final Widget? child;

  /// Optional barrier color override (use AppTheme colors).
  final Color? barrierColor;

  /// Opacity applied to the barrier color.
  final double barrierOpacity;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = (barrierColor ?? AppTheme.black).withValues(alpha: barrierOpacity);

    return SizedBox.expand(
      child: Stack(
        children: [
          ModalBarrier(
            color: resolvedColor,
            dismissible: false,
          ),
          // WCAG 2.4.3: Wrap modal content in a FocusTraversalGroup so that
          // Tab traversal cycles within the overlay and cannot reach background
          // elements while the overlay is displayed.
          if (child != null)
            FocusTraversalGroup(
              child: FocusScope(
                autofocus: true,
                child: child!,
              ),
            ),
        ],
      ),
    );
  }
}
