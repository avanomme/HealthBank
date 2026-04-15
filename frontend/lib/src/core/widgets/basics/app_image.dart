// Created with the Assistance of ChatGPT

/// AppImage
///
/// Description:
/// - A theme-aware image widget that supports responsive sizing.
/// - `AppImage` is a **basic widget** designed to be reused across the app.
///
/// Features:
/// - Accepts any ImageProvider source.
/// - Supports responsive sizing via layout constraints.
/// - Avoids hard-coded dimensions by default.
/// - `aspectRatio` only affects layout when both `width` and `height` are not
///   explicitly provided.
/// - If both `width` and `height` are set, `aspectRatio` is ignored.
/// - Parent constraints may still bound one axis; `AppImage` prioritizes
///   leaving one axis unconstrained so `AspectRatio` can compute the other.
///
/// Usage Example:
/// ```dart
/// AppImage(
///   image: const AssetImage('assets/images/hero.png'),
///   aspectRatio: 16 / 9,
/// );
/// ```
library;


import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.image,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.aspectRatio,
    this.width,
    this.height,
    this.borderRadius,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.errorBuilder,
    this.loadingBuilder,
  });

  /// Image source provider (asset, network, memory, etc.).
  final ImageProvider image;

  /// How the image should be inscribed into the space allocated.
  final BoxFit fit;

  /// Alignment for inscribing the image.
  final Alignment alignment;

  /// Optional aspect ratio to enforce responsive sizing.
  final double? aspectRatio;

  /// Optional width override.
  final double? width;

  /// Optional height override.
  final double? height;

  /// Optional border radius for clipping.
  final BorderRadius? borderRadius;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;

  /// Whether to exclude this image from semantics.
  final bool excludeFromSemantics;

  /// Optional builder to display in case of image loading errors.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Optional builder to show loading progress.
  final ImageLoadingBuilder? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasExplicitWidth = width != null;
        final hasExplicitHeight = height != null;
        double? boxWidth;
        double? boxHeight;

        if (aspectRatio != null) {
          if (hasExplicitWidth && hasExplicitHeight) {
            boxWidth = width;
            boxHeight = height;
          } else {
            boxWidth = hasExplicitWidth ? width : null;
            boxHeight = hasExplicitHeight ? height : null;

            if (boxWidth == null && boxHeight == null) {
              if (constraints.hasBoundedWidth) {
                boxWidth = constraints.maxWidth;
              } else if (constraints.hasBoundedHeight) {
                boxHeight = constraints.maxHeight;
              }
            }
          }
        } else {
          boxWidth = hasExplicitWidth ? width : (constraints.hasBoundedWidth ? constraints.maxWidth : null);
          boxHeight = hasExplicitHeight ? height : (constraints.hasBoundedHeight ? constraints.maxHeight : null);
        }

        Widget imageWidget = Image(
          image: image,
          fit: fit,
          alignment: alignment,
          width: hasExplicitWidth ? width : null,
          height: hasExplicitHeight ? height : null,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          errorBuilder: errorBuilder,
          loadingBuilder: loadingBuilder,
        );

        if (aspectRatio != null && !(hasExplicitWidth && hasExplicitHeight)) {
          imageWidget = AspectRatio(
            aspectRatio: aspectRatio!,
            child: imageWidget,
          );
        }

        if (borderRadius != null) {
          imageWidget = ClipRRect(
            borderRadius: borderRadius!,
            child: imageWidget,
          );
        }

        if (boxWidth != null || boxHeight != null) {
          return SizedBox(
            width: boxWidth,
            height: boxHeight,
            child: imageWidget,
          );
        }

        return imageWidget;
      },
    );
  }
}
