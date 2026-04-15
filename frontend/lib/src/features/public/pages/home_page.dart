import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return BaseScaffold(
      showFooter: true,
      scrollable: true,
      header: Header(
        navItems: [
          NavItem(label: l10n.navHome, route: AppRoutes.home),
          NavItem(label: l10n.commonPrivacyPolicy, route: '/privacy-policy'),
          NavItem(label: l10n.footerTermsOfUse, route: '/terms-of-service'),
        ],
        currentRoute: AppRoutes.home,
        onNavItemTap: (route) => context.go(route),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.navHome,
              style: AppTheme.heading2.copyWith(color: AppTheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            // Replace with a real localized string when ready:
            // e.g. l10n.homePlaceholderBody
            l10n.homePagePlaceHolderText, // add/use an existing placeholder key
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 128), // remove when add more content
        ],
      ),
    );
  }
}