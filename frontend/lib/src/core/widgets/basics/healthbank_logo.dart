// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/healthbank_logo.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// HealthBank Logo Widget
///
/// Displays the HealthBank brand logo with a heart icon and text.
/// Used in survey headers, preview dialogs, and completion screens.
///
/// Sizes:
/// - [HealthBankLogoSize.small]: Compact logo for headers (height ~24)
/// - [HealthBankLogoSize.medium]: Standard logo for dialogs (height ~32)
/// - [HealthBankLogoSize.large]: Large logo for completion screens (height ~48)
enum HealthBankLogoSize { small, medium, large }

class HealthBankLogo extends StatelessWidget {
  const HealthBankLogo({
    super.key,
    this.size = HealthBankLogoSize.medium,
    this.color,
    this.showTagline = false,
  });

  /// Size variant for the logo
  final HealthBankLogoSize size;

  /// Optional color override (defaults to AppTheme.primary)
  final Color? color;

  /// Whether to show the tagline below the logo
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppTheme.primary;

    final double iconSize;
    final double fontSize;
    final double spacing;

    switch (size) {
      case HealthBankLogoSize.small:
        iconSize = 20;
        fontSize = 16;
        spacing = 6;
        break;
      case HealthBankLogoSize.medium:
        iconSize = 28;
        fontSize = 22;
        spacing = 8;
        break;
      case HealthBankLogoSize.large:
        iconSize = 40;
        fontSize = 32;
        spacing = 12;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heart icon representing health
            Icon(
              Icons.favorite,
              size: iconSize,
              color: logoColor,
            ),
            SizedBox(width: spacing),
            // Brand name
            Text(
              'HealthBank',
              style: AppTheme.logo.copyWith(
                fontSize: fontSize,
                color: logoColor,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            'Your Health, Your Data',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: fontSize * 0.4,
              color: logoColor.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

/// A header bar with the HealthBank logo
///
/// Used at the top of survey previews and participant survey views.
/// Has a subtle background color and padding.
class HealthBankLogoHeader extends StatelessWidget {
  const HealthBankLogoHeader({
    super.key,
    this.size = HealthBankLogoSize.small,
    this.backgroundColor,
    this.showDivider = true,
  });

  /// Size of the logo
  final HealthBankLogoSize size;

  /// Background color (defaults to white)
  final Color? backgroundColor;

  /// Whether to show a bottom divider
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.appColors.surface,
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: context.appColors.textMuted.withValues(alpha: 0.2),
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          HealthBankLogo(size: size),
          const Spacer(),
        ],
      ),
    );
  }
}
