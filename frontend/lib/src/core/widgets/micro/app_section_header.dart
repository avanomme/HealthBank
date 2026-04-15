// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/micro/app_section_header.dart
/// Reusable section header for consistent section titles across pages.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

/// A titled section separator with optional trailing widget.
///
/// Renders a labelled divider with configurable spacing above and below,
/// used to break pages into named sections with WCAG heading semantics.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.variant = AppTextVariant.bodyLarge,
    this.color,
    this.fontWeight = FontWeight.w600,
    this.topSpacing = 24,
    this.bottomSpacing = 12,
    this.trailing,
    this.isHeading = true,
  });

  /// Section title text.
  final String title;

  /// Text variant. Defaults to [AppTextVariant.bodyLarge].
  final AppTextVariant variant;

  /// Text color. Defaults to [AppTheme.primary].
  final Color? color;

  /// Font weight. Defaults to w600.
  final FontWeight fontWeight;

  /// Spacing above the header.
  final double topSpacing;

  /// Spacing below the header.
  final double bottomSpacing;

  /// Optional trailing widget (e.g. a count badge or action button).
  final Widget? trailing;

  /// Whether to announce this text as a heading to screen readers.
  /// Defaults to true — set false for decorative section dividers that are
  /// not true headings in the document outline.
  final bool isHeading;

  @override
  Widget build(BuildContext context) {
    final text = AppText(
      title,
      variant: variant,
      color: color ?? AppTheme.primary,
      fontWeight: fontWeight,
    );

    final content = trailing != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [text, trailing!],
          )
        : text;

    return Padding(
      padding: EdgeInsets.only(top: topSpacing, bottom: bottomSpacing),
      child: isHeading
          ? Semantics(header: true, child: content)
          : content,
    );
  }
}
