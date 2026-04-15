// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/core/widgets/feedback/app_info_banner.dart

/// AppInfoBanner
///
/// A horizontal banner with icon + text, used for alerts, warnings,
/// suppression notices, and informational messages. Supports optional
/// border and close/action button.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Horizontal alert banner with a leading icon and a text message.
///
/// Used for informational, warning, suppression, and error notices.
/// Supports an optional trailing widget (e.g. a close button).
class AppInfoBanner extends StatelessWidget {
  const AppInfoBanner({
    super.key,
    required this.icon,
    required this.message,
    this.color = AppTheme.caution,
    this.backgroundAlpha = 0.08,
    this.borderAlpha = 0.3,
    this.showBorder = true,
    this.radius = 8,
    this.padding = const EdgeInsets.all(12),
    this.textStyle,
    this.trailing,
  });

  /// Leading icon.
  final IconData icon;

  /// Banner message text.
  final String message;

  /// Theme color for icon, background, and border.
  final Color color;

  /// Background alpha. Defaults to 0.08.
  final double backgroundAlpha;

  /// Border alpha. Defaults to 0.3.
  final double borderAlpha;

  /// Whether to show a border. Defaults to true.
  final bool showBorder;

  /// Corner radius. Defaults to 8.
  final double radius;

  /// Inner padding.
  final EdgeInsets padding;

  /// Optional text style override. Defaults to captions with textMuted color.
  final TextStyle? textStyle;

  /// Optional trailing widget (e.g. close button).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: message,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color.withValues(alpha: backgroundAlpha),
            borderRadius: BorderRadius.circular(radius),
            border: showBorder
                ? Border.all(color: color.withValues(alpha: borderAlpha))
                : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style:
                      textStyle ??
                      AppTheme.captions.copyWith(
                        color: context.appColors.textMuted,
                      ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
