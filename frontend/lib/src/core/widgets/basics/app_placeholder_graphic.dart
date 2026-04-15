// Created with the Assistance of ChatGPT
// Copyright-free palceholder image by Pexels

/// AppPlaceholderGraphic
///
/// Description:
/// - A theme-aware placeholder graphic for empty or unavailable content.
/// - `AppPlaceholderGraphic` is a **basic widget** designed to be reused across the app.
///
/// Features:
/// - Uses a shared placeholder image asset for consistent visuals.
/// - Scales responsively using the provided aspect ratio.
/// - Optional asset path, fit, and border radius overrides.
///
/// Usage Example:
/// ```dart
/// const AppPlaceholderGraphic();
/// ```
library;


import 'package:flutter/material.dart';

import 'app_image.dart';

class AppPlaceholderGraphic extends StatelessWidget {
  const AppPlaceholderGraphic({
    super.key,
    this.assetPath = 'assets/placeholder_image.jpg',
    this.fit = BoxFit.cover,
    this.aspectRatio = 4 / 3,
    this.borderRadius,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  });

  /// Placeholder asset path.
  final String assetPath;

  /// How the placeholder image should be inscribed into the space allocated.
  final BoxFit fit;

  /// Optional aspect ratio to control the graphic's size.
  final double aspectRatio;

  /// Optional border radius for clipping.
  final BorderRadius? borderRadius;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;

  /// Whether to exclude this graphic from semantics.
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    return AppImage(
      image: AssetImage(assetPath),
      aspectRatio: aspectRatio,
      fit: fit,
      borderRadius: borderRadius,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
    );
  }
}
