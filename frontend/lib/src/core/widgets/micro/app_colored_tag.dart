// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/micro/app_colored_tag.dart

/// AppColoredTag
///
/// A small colored label with text on a low-alpha background.
/// Used for status indicators, category tags, and type labels.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppColoredTag extends StatelessWidget {
  const AppColoredTag({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.alpha = 0.1,
    this.radius = 4,
    this.fontSize,
    this.padding,
    this.textAlign,
  });

  /// Tag text.
  final String label;

  /// Theme color for both background (at [alpha]) and text.
  final Color color;

  /// Optional leading icon — use when color alone would be the only differentiator
  /// (WCAG 1.4.1: color must not be the sole means of conveying information).
  final IconData? icon;

  /// Background alpha. Defaults to 0.1.
  final double alpha;

  /// Corner radius. Defaults to 4.
  final double radius;

  /// Optional font size override.
  final double? fontSize;

  /// Optional padding override.
  final EdgeInsets? padding;

  /// Optional text alignment.
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTheme.captions.copyWith(
      color: color,
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
    );

    Widget content = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(icon, size: (fontSize ?? 16) + 2, color: color),
              ),
              const SizedBox(width: 4),
              Text(label, style: textStyle, textAlign: textAlign),
            ],
          )
        : Text(label, style: textStyle, textAlign: textAlign);

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: content,
    );
  }
}
