// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class FooterLink {
  final String label;
  final String? route;
  final VoidCallback? onTap;

  const FooterLink({
    required this.label,
    this.route,
    this.onTap,
  });
}

class FooterSection {
  final String title;
  final List<FooterLink> links;

  const FooterSection({
    required this.title,
    required this.links,
  });
}

class Footer extends ConsumerWidget {
  const Footer({
    super.key,
    this.sections = const [],
    this.onLinkTap,
  });

  final List<FooterSection> sections;
  final void Function(String route)? onLinkTap;

  /// Get default help section with localized strings
  static FooterSection getDefaultHelpSection(AppLocalizations l10n) {
    return FooterSection(
      title: l10n.footerHelpAndServices,
      links: [
        FooterLink(label: l10n.footerHowToUse, route: '/help'),
        FooterLink(label: l10n.commonContactUs, route: '/contact'),
      ],
    );
  }

  /// Get default legal section with localized strings
  static FooterSection getDefaultLegalSection(AppLocalizations l10n) {
    return FooterSection(
      title: l10n.footerLegal,
      links: [
        FooterLink(label: l10n.commonPrivacyPolicy, route: '/privacy-policy'),
        FooterLink(label: l10n.footerTermsOfUse, route: '/terms-of-service'),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final displaySections = sections.isEmpty
        ? [getDefaultHelpSection(context.l10n), getDefaultLegalSection(context.l10n)]
        : sections;

    // Extend the footer background into the bottom safe area (home indicator
    // on iPhone, gesture bar on Android) so no white gap appears below it.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      width: double.infinity,
      color: colors.primary,
      padding: EdgeInsets.fromLTRB(48, 32, 48, 32 + bottomInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo (brand name - not translated)
          Text(
            'HealthBank',
            style: AppTheme.logo.copyWith(
              color: colors.onPrimary,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 24),

          // Divider
          Container(
            height: 1,
            color: colors.onPrimary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 24),

          // Sections
          _buildSections(displaySections, textTheme, colors),
        ],
      ),
    );
  }

  Widget _buildSections(
    List<FooterSection> sections,
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    return Wrap(
      spacing: 64,
      runSpacing: 24,
      children: sections.map((s) => _buildSection(s, textTheme, colors)).toList(),
    );
  }

  Widget _buildSection(
    FooterSection section,
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: textTheme.bodyLarge?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ...section.links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                if (link.onTap != null) {
                  link.onTap!();
                } else if (link.route != null) {
                  onLinkTap?.call(link.route!);
                }
              },
              child: Text(
                link.label,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}