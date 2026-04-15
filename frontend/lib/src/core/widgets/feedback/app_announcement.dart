// Created with the Assistance of Codex

/// AppAnnouncement
///
/// Description:
/// - Inline banner-style feedback for important announcements.
/// - `AppAnnouncement` can be optionally clickable.
///
/// Features:
/// - Optional leading icon with required text content.
/// - Theme-aware colors and typography via AppTheme.
/// - Responsive padding based on global breakpoints.
///
/// Usage Example:
/// ```dart
/// AppAnnouncement(
///   message: 'System maintenance begins at 9 PM.',
///   onTap: () {},
/// );
/// ```
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppAnnouncement extends StatelessWidget {
  const AppAnnouncement({
    super.key,
    required this.message,
    this.icon,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding,
  });

  /// Announcement message content.
  final String message;

  /// Optional leading icon.
  final Widget? icon;

  /// Optional tap handler.
  final VoidCallback? onTap;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional text color override.
  final Color? textColor;

  /// Optional border color override.
  final Color? borderColor;

  /// Optional padding override.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);

    final basePadding = Breakpoints.responsivePadding(width);
    final resolvedPadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: basePadding * 0.9,
          vertical: basePadding * 0.6,
        );

    final resolvedBackground = backgroundColor ?? AppTheme.info;
    final resolvedTextColor = textColor ?? AppTheme.textContrast;
    final resolvedBorder = borderColor;
    final borderWidth = math.max(1.0, basePadding * 0.08);
    final radius = BorderRadius.circular(basePadding * 0.6);

    final resolvedTextStyle = (textTheme.bodyMedium ?? AppTheme.body).copyWith(
      color: resolvedTextColor,
      fontWeight: FontWeight.w600,
    );

    final iconSize = (resolvedTextStyle.fontSize ?? 16) * 1.2;
    final gap = basePadding * 0.4;

    final content = Padding(
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
          Flexible(child: Text(message, style: resolvedTextStyle)),
        ],
      ),
    );

    final decoration = BoxDecoration(
      color: resolvedBackground,
      borderRadius: radius,
      border: resolvedBorder == null
          ? null
          : Border.all(color: resolvedBorder, width: borderWidth),
    );

    final visual = onTap == null
        ? DecoratedBox(decoration: decoration, child: content)
        : Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: DecoratedBox(decoration: decoration, child: content),
            ),
          );

    return MergeSemantics(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: message,
        button: onTap != null,
        child: visual,
      ),
    );
  }
}
