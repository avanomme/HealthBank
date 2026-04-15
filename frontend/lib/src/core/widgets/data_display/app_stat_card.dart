// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/data_display/app_stat_card.dart
/// Reusable stat card widget displaying an icon, label, and big value.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/basics.dart';

/// A summary stat card showing a large value, a label, an icon, and optional subtitle.
///
/// Used in dashboards to highlight key metrics at a glance.
class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color = AppTheme.primary,
    this.subtitle,
    this.onTap,
  });

  /// Descriptive label above the value (e.g. "Respondents").
  final String label;

  /// Large display value (e.g. "42" or "80%").
  final String value;

  /// Optional icon displayed to the left.
  final IconData? icon;

  /// Accent color for the icon and top border. Defaults to [AppTheme.primary].
  final Color color;

  /// Optional text below the value.
  final String? subtitle;

  /// Optional tap callback — makes the card clickable.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final card = Container(
      constraints: const BoxConstraints(minHeight: 72),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border(top: BorderSide(color: color, width: 3)),
        boxShadow: colors.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            ExcludeSemantics(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTheme.captions.copyWith(
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Semantics(
                  header: true,
                  child: Text(
                    value,
                      style: AppTheme.heading4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle ?? '',
                  style: AppTheme.captions.copyWith(
                    fontSize: 13,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return AppTappable(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}
