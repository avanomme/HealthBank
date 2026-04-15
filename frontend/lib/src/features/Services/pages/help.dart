import 'package:frontend/src/features/participant/widgets/participant_header.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_header.dart';
import 'package:frontend/src/features/hcp_clients/widgets/hcp_header.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/widgets/basics/app_accordion.dart';
import 'package:go_router/go_router.dart';

class HelpPage extends ConsumerWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final role = ref.watch(authProvider.select((s) => s.user?.role));

    PreferredSizeWidget header;
    switch (role) {
      case 'participant':
        header = ParticipantHeader(currentRoute: '/help');
        break;
      case 'researcher':
        header = ResearcherHeader(currentRoute: '/help');
        break;
      case 'hcp':
        header = HcpHeader(currentRoute: '/help');
        break;
      case 'admin':
        header = const Header(navItems: [], currentRoute: '/help');
        break;
      default:
        header = Header(
          navItems: [
            NavItem(label: l10n.navHome, route: '/'),
            NavItem(label: l10n.commonPrivacyPolicy, route: '/privacy-policy'),
            NavItem(label: l10n.footerTermsOfUse, route: '/terms-of-service'),
          ],
          currentRoute: '/help',
          onNavItemTap: (route) => context.go(route),
        );
    }

    final faqTitles = [l10n.helpFaq1Title, l10n.helpFaq2Title, l10n.helpFaq3Title];
    final faqBodies = [l10n.helpFaq1Body, l10n.helpFaq2Body, l10n.helpFaq3Body];

    // Accordion sections using AppAccordion
    final accordionSections = List.generate(
      3,
      (i) => AppAccordion(
        title: faqTitles[i],
        body: faqBodies[i],
        initiallyExpanded: ref.watch(_accordionStateProvider)[i],
        iconColor: AppTheme.secondary,
        onChanged: (expanded) =>
            ref.read(_accordionStateProvider.notifier).toggle(i),
      ),
    );

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
              l10n.footerHowToUse,
              style: AppTheme.heading2.copyWith(color: AppTheme.primary),
            ),
          ),
          const SizedBox(height: 24),
          ...accordionSections,
          const SizedBox(height: 24),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}

// State provider for managing expansion state
final _accordionStateProvider =
    StateNotifierProvider<_AccordionStateNotifier, List<bool>>((ref) {
      return _AccordionStateNotifier();
    });

class _AccordionStateNotifier extends StateNotifier<List<bool>> {
  _AccordionStateNotifier() : super([false, false, false]);

  void toggle(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) !state[i] else state[i],
    ];
  }
}
