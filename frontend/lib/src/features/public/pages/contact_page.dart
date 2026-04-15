import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/hcp_clients/hcp.dart';
import 'package:frontend/src/features/participant/participant.dart';
import 'package:frontend/src/features/researcher/researcher.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final role = ref.watch(authProvider.select((s) => s.user?.role));

    PreferredSizeWidget header;
    switch (role) {
      case 'participant':
        header = ParticipantHeader(currentRoute: '/contact');
        break;
      case 'researcher':
        header = ResearcherHeader(currentRoute: '/contact');
        break;
      case 'hcp':
        header = HcpHeader(currentRoute: '/contact');
        break;
      case 'admin':
        header = const Header(navItems: [], currentRoute: '/contact');
        break;
      default:
        header = Header(
          navItems: [
            NavItem(label: l10n.navHome, route: '/'),
            NavItem(label: l10n.commonPrivacyPolicy, route: '/privacy-policy'),
            NavItem(label: l10n.footerTermsOfUse, route: '/terms-of-service'),
          ],
          currentRoute: '/contact',
          onNavItemTap: (route) => context.go(route),
        );
    }

    return BaseScaffold(
      header: header,
      alignment: AppPageAlignment.wide,
      showFooter: true,
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.commonContactUs,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.contactSupportIntro,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: context.appColors.textPrimary,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.appColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.appColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.contactSupportEmailLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'support@healthbank.ca',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.contactSupportHoursLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.contactSupportHoursValue,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.appColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.contactSupportNote,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}
