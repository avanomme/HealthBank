// Created with the Assistance of ChatGPT

/// AppText
///
/// Description:
/// - A non-interactive, theme-aware text widget for consistent typography.
/// - `AppText` is a **micro-widget** designed to be reused across the app.
///
/// Features:
/// - Theme-aware: uses AppTheme typography.
/// - Responsive: respects breakpoints via the global text theme.
///
/// Usage Example:
/// ```
/// const AppText(
///   'Welcome back',
///   variant: AppTextVariant.headlineSmall,
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

enum AppTextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineMedium,
  headlineSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
}

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.fontWeight,
    this.fontStyle,
    this.isHeading,
  });

  final String text;
  final AppTextVariant variant;

  /// Optional style overrides.
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  /// Text layout options.
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  /// Whether to announce this text as a heading to screen readers.
  /// When null (default), heading variants (displayLarge through headlineSmall)
  /// are automatically announced as headings; body variants are not.
  final bool? isHeading;

  /// Whether this variant is a heading level by default.
  bool get _isHeadingVariant => switch (variant) {
    AppTextVariant.displayLarge ||
    AppTextVariant.displayMedium ||
    AppTextVariant.displaySmall ||
    AppTextVariant.headlineMedium ||
    AppTextVariant.headlineSmall => true,
    _ => false,
  };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);

    final baseStyle = _styleForVariant(textTheme) ?? AppTheme.body;
    final resolvedStyle = baseStyle.copyWith(
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );

    final widget = Text(
      text,
      style: resolvedStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );

    final shouldMarkHeading = isHeading ?? _isHeadingVariant;
    if (shouldMarkHeading) {
      return Semantics(header: true, child: widget);
    }
    return widget;
  }

  TextStyle? _styleForVariant(TextTheme theme) {
    return switch (variant) {
      AppTextVariant.displayLarge => theme.displayLarge,
      AppTextVariant.displayMedium => theme.displayMedium,
      AppTextVariant.displaySmall => theme.displaySmall,
      AppTextVariant.headlineMedium => theme.headlineMedium,
      AppTextVariant.headlineSmall => theme.headlineSmall,
      AppTextVariant.bodyLarge => theme.bodyLarge,
      AppTextVariant.bodyMedium => theme.bodyMedium,
      AppTextVariant.bodySmall => theme.bodySmall,
    };
  }
}
