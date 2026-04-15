// Created with the Assistance of ChatGPT

/// AppBadge
///
/// Description:
/// - A small, theme-aware "pill" label used to display short status/role/category text.
/// - `AppBadge` is a **micro-widget** designed to be reused across the app (e.g., user roles, account status, tags, labels, environment flags).
///
/// Features:
/// - Theme-aware: uses AppTheme colors and the active TextTheme for typography.
/// - Variants: semantic styling via `variant` (primary/success/caution/error/info/etc.).
/// - Sizing: defaults to medium; override with `size`.
/// - Optional icon slots: supports leading/trailing widgets (icons, SVGs, etc.).
/// - Content-hugging: the badge only takes as much horizontal space as its content.
///
/// Usage Example:
/// ```
/// const AppBadge(
///   label: 'Admin',
///   variant: AppBadgeVariant.primary,
///   leading: Icon(Icons.security),
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

enum AppBadgeVariant {
  neutral,
  primary,
  secondary,
  success,
  caution,
  error,
  info,
}

enum AppBadgeSize {
  small,
  medium,
  large,
}

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    this.size = AppBadgeSize.medium,
    this.leading,
    this.trailing,
  });

  final String label;
  final AppBadgeVariant variant;

  /// Optional size override.
  final AppBadgeSize size;

  /// Optional icons/widgets.
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final styles = _stylesFor(context, variant);

    final padding = switch (size) {
      AppBadgeSize.small => const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      AppBadgeSize.medium => const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      AppBadgeSize.large => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    };

    final textStyle = switch (size) {
      AppBadgeSize.small => (textTheme.bodySmall ?? AppTheme.captions).copyWith(fontWeight: FontWeight.w400),
      AppBadgeSize.medium => (textTheme.bodyMedium ?? AppTheme.captions).copyWith(fontWeight: FontWeight.w400),
      AppBadgeSize.large => (textTheme.bodyLarge ?? AppTheme.body).copyWith(fontWeight: FontWeight.w400),
    }.copyWith(color: styles.foreground);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: styles.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: styles.border),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              IconTheme(data: IconThemeData(size: 16, color: styles.foreground), child: leading!),
              const SizedBox(width: 6),
            ],
            Text(label, style: textStyle),
            if (trailing != null) ...[
              const SizedBox(width: 6),
              IconTheme(data: IconThemeData(size: 16, color: styles.foreground), child: trailing!),
            ],
          ],
        ),
      ),
    );
  }

  _BadgeColors _stylesFor(BuildContext context, AppBadgeVariant v) {
    final colors = context.appColors;
    return switch (v) {
      AppBadgeVariant.neutral => _BadgeColors(
          background: colors.surface,
          border: colors.surface,
          foreground: colors.textPrimary,
        ),
      AppBadgeVariant.primary => const _BadgeColors(
          background: AppTheme.primary,
          border: AppTheme.primary,
          foreground: AppTheme.textContrast,
        ),
      AppBadgeVariant.secondary => const _BadgeColors(
          background: AppTheme.secondary,
          border: AppTheme.secondary,
          foreground: AppTheme.textContrast,
        ),
      AppBadgeVariant.success => const _BadgeColors(
          background: AppTheme.success,
          border: AppTheme.success,
          foreground: AppTheme.textContrast,
        ),
      AppBadgeVariant.caution => _BadgeColors(
          background: AppTheme.caution,
          border: AppTheme.caution,
          foreground: colors.textPrimary,
        ),
      AppBadgeVariant.error => const _BadgeColors(
          background: AppTheme.error,
          border: AppTheme.error,
          foreground: AppTheme.textContrast,
        ),
      AppBadgeVariant.info => const _BadgeColors(
          background: AppTheme.info,
          border: AppTheme.info,
          foreground: AppTheme.textContrast,
        ),
    };
  }
}

class _BadgeColors {
  const _BadgeColors({
    required this.background,
    required this.border,
    required this.foreground,
  });

  final Color background;
  final Color border;
  final Color foreground;
}
