// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/app_card.dart

/// AppCard
///
/// Description:
/// - A standard card surface: white background, rounded corners, gray border.
/// - Replaces the repeated `Container(decoration: BoxDecoration(color: white,
///   borderRadius: 8, border: gray))` pattern found in 10+ locations.
///
/// Features:
/// - Theme-aware defaults matching the app's design system.
/// - Configurable padding, radius, colors, border, and shadow.
/// - Optional `onTap` for interactive cards (wraps with InkWell).
/// - Content-hugging by default; stretches to parent width.
///
/// Usage Example:
/// ```dart
/// AppCard(
///   child: Text('Card content'),
/// )
/// AppCard(
///   padding: EdgeInsets.all(24),
///   radius: 12,
///   onTap: () => print('tapped'),
///   child: Row(children: [...]),
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 8,
    this.backgroundColor,
    this.borderColor,
    this.shadow,
    this.onTap,
    this.semanticLabel,
    this.width,
  });

  /// Card content.
  final Widget child;

  /// Inner padding (default: 16 all sides).
  final EdgeInsets? padding;

  /// Corner radius (default: 8).
  final double radius;

  /// Background color (default: context.appColors.surface).
  final Color? backgroundColor;

  /// Border color (default: context.appColors.divider).
  final Color? borderColor;

  /// Optional box shadow for elevation.
  final List<BoxShadow>? shadow;

  /// Optional tap handler. When set, the card has an InkWell ripple.
  final VoidCallback? onTap;

  /// Accessible label for screen readers when the card is tappable.
  /// Required for WCAG 2.4.4 when [onTap] is set and the card content
  /// does not already provide a descriptive label.
  final String? semanticLabel;

  /// Optional fixed width. If null, takes parent width.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final decoration = BoxDecoration(
      color: backgroundColor ?? colors.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? colors.divider),
      boxShadow: shadow ?? colors.cardShadow,
    );

    Widget card = Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: decoration,
      child: child,
    );

    if (onTap != null) {
      card = Semantics(
        button: true,
        label: semanticLabel,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: card,
        ),
      );
    }

    return card;
  }
}
