// Created with the Assistance of ChatGPT

/// AppRichText
///
/// Description:
/// - A theme-aware rich text widget for inline formatting (links, bold, italics).
/// - `AppRichText` is a **micro-widget** designed to be reused across the app.
///
/// Features:
/// - Theme-aware: uses AppTheme typography as a base style.
/// - Responsive: respects breakpoints via the global text theme.
/// - Child span scaling: scales child font sizes to match the active breakpoint.
///
/// Notes:
/// - Prefer child styles that only override weight/decoration; avoid fixed font sizes
///   unless you intentionally want to lock the size.
///
/// Usage Example:
/// ```
/// AppRichText(
///   text: TextSpan(
///     text: 'Terms ',
///     children: [
///       TextSpan(text: 'of Service', style: TextStyle(fontWeight: FontWeight.w600)),
///     ],
///   ),
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

class AppRichText extends StatelessWidget {
  const AppRichText({
    super.key,
    required this.text,
    this.variant = AppTextVariant.bodyMedium,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  /// Rich text content.
  final TextSpan text;

  /// Base typography variant.
  final AppTextVariant variant;

  /// Text layout options.
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);

    final baseStyle = _styleForVariant(textTheme) ?? AppTheme.body;
    final referenceStyle = textTheme.bodyMedium ?? AppTheme.body;
    final scale = _scaleFor(baseStyle, referenceStyle);
    final scaledText = _scaleSpan(text, scale);
    final mergedStyle = baseStyle.merge(scaledText.style);

    final effectiveText = TextSpan(
      text: scaledText.text,
      children: scaledText.children,
      style: mergedStyle,
      recognizer: scaledText.recognizer,
      mouseCursor: scaledText.mouseCursor,
      onEnter: scaledText.onEnter,
      onExit: scaledText.onExit,
      semanticsLabel: scaledText.semanticsLabel,
      locale: scaledText.locale,
      spellOut: scaledText.spellOut,
    );

    return RichText(
      text: effectiveText,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      softWrap: softWrap ?? true,
      textScaler: MediaQuery.textScalerOf(context),
    );
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

  double _scaleFor(TextStyle baseStyle, TextStyle referenceStyle) {
    final baseSize = baseStyle.fontSize ?? AppTheme.body.fontSize ?? 18;
    final reference = referenceStyle.fontSize ?? AppTheme.body.fontSize ?? 18;
    if (reference <= 0) return 1;
    return baseSize / reference;
  }

  TextSpan _scaleSpan(TextSpan span, double scale) {
    final children = span.children
        ?.whereType<TextSpan>()
        .map((child) => _scaleSpan(child, scale))
        .toList();
    return TextSpan(
      text: span.text,
      children: children,
      style: _scaleStyle(span.style, scale),
      recognizer: span.recognizer,
      mouseCursor: span.mouseCursor,
      onEnter: span.onEnter,
      onExit: span.onExit,
      semanticsLabel: span.semanticsLabel,
      locale: span.locale,
      spellOut: span.spellOut,
    );
  }

  TextStyle? _scaleStyle(TextStyle? style, double scale) {
    if (style == null || style.fontSize == null) return style;
    return style.copyWith(fontSize: style.fontSize! * scale);
  }
}
