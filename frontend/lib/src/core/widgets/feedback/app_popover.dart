// Created with the Assistance of ChatGPT

/// AppPopover
///
/// Description:
/// - Material-style popover for inline, context-anchored feedback.
/// - `AppPopover` is intended to be placed near the UI element it describes.
///
/// Features:
/// - Material surface with elevation and rounded corners.
/// - Built-in arrow/caret for popover affordance.
/// - Optional leading icon with required text content.
/// - Theme-aware colors and typography via AppTheme.
/// - Responsive padding based on global breakpoints.
///
/// Usage Example:
/// ```dart
/// AppPopover(
///   message: 'Please enter a valid email address.',
///   icon: const Icon(Icons.info_outline),
/// );
/// ```
library;


import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppPopover extends StatelessWidget {
  const AppPopover({
    super.key,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
    this.arrowOnTop = true,
    this.arrowSize = 8,
    this.arrowOffset,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  });

  /// Popover message content.
  final String message;

  /// Optional leading icon.
  final Widget? icon;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional text color override.
  final Color? textColor;

  /// Optional border color override.
  final Color? borderColor;

  /// Optional padding override.
  final EdgeInsets? padding;

  /// Optional border radius override.
  final BorderRadius? borderRadius;

  /// Whether the arrow appears on top of the popover surface.
  final bool arrowOnTop;

  /// Optional arrow size override.
  final double arrowSize;

  /// Optional arrow horizontal offset from center.
  final double? arrowOffset;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;

  /// Whether to exclude this popover from semantics.
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);

    final basePadding = Breakpoints.responsivePadding(width);
    final resolvedPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: basePadding * 0.7,
          vertical: basePadding * 0.5,
        );

    final resolvedBackground = backgroundColor ?? context.appColors.surfaceSubtle;
    final resolvedTextColor = textColor ?? context.appColors.textPrimary;
    final resolvedBorder = borderColor ?? AppTheme.muted;
    final borderWidth = math.max(1.0, basePadding * 0.08);
    final radius = borderRadius ?? BorderRadius.circular(basePadding * 0.5);

    final resolvedTextStyle = (textTheme.bodySmall ?? AppTheme.captions).copyWith(
      color: resolvedTextColor,
    );

    final iconSize = (resolvedTextStyle.fontSize ?? 14) * 1.2;
    final gap = basePadding * 0.35;

    Widget content = Padding(
      padding: resolvedPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            IconTheme(
              data: IconThemeData(color: resolvedTextColor, size: iconSize),
              child: icon!,
            ),
          if (icon != null) SizedBox(width: gap),
          Flexible(
            child: Text(
              message,
              style: resolvedTextStyle,
            ),
          ),
        ],
      ),
    );

    content = Material(
      color: resolvedBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: radius),
      child: content,
    );

    if (resolvedBorder.a > 0 && borderWidth > 0) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: resolvedBorder, width: borderWidth),
        ),
        child: content,
      );
    }

    content = _PopoverWithArrow(
      color: resolvedBackground,
      arrowOnTop: arrowOnTop,
      size: arrowSize,
      offset: arrowOffset,
      child: content,
    );

    if (excludeFromSemantics) return ExcludeSemantics(child: content);

    return Semantics(
      label: semanticLabel,
      child: content,
    );
  }
}

class _PopoverWithArrow extends StatelessWidget {
  const _PopoverWithArrow({
    required this.child,
    required this.color,
    required this.arrowOnTop,
    required this.size,
    required this.offset,
  });

  final Widget child;
  final Color color;
  final bool arrowOnTop;
  final double size;
  final double? offset;

  @override
  Widget build(BuildContext context) {
    final arrow = CustomPaint(
      size: Size(size * 2, size),
      painter: _TrianglePainter(
        color: color,
        isUp: arrowOnTop,
      ),
    );

    final align = Alignment(
      (offset ?? 0) / 100,
      0,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (arrowOnTop) Align(alignment: align, child: arrow),
        child,
        if (!arrowOnTop) Align(alignment: align, child: arrow),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter({required this.color, required this.isUp});

  final Color color;
  final bool isUp;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (isUp) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isUp != isUp;
  }
}
