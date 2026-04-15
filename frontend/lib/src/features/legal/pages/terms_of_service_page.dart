import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/participant/widgets/participant_header.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_header.dart';
import 'package:frontend/src/features/hcp_clients/widgets/hcp_header.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

/// Terms of Service Page
class TermsOfServicePage extends ConsumerStatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  ConsumerState<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends ConsumerState<TermsOfServicePage> {
  final section1Key = GlobalKey();
  final section2Key = GlobalKey();
  final section3Key = GlobalKey();
  final section4Key = GlobalKey();
  final section5Key = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final role = ref.watch(authProvider.select((s) => s.user?.role));

    PreferredSizeWidget header;
    switch (role) {
      case 'participant':
        header = ParticipantHeader(currentRoute: '/terms-of-service');
        break;
      case 'researcher':
        header = ResearcherHeader(currentRoute: '/terms-of-service');
        break;
      case 'hcp':
        header = HcpHeader(currentRoute: '/terms-of-service');
        break;
      case 'admin':
        header = const Header(navItems: [], currentRoute: '/terms-of-service');
        break;
      default:
        header = Header(
          navItems: [
            NavItem(label: l10n.navHome, route: '/'),
            NavItem(label: l10n.commonPrivacyPolicy, route: '/privacy-policy'),
            NavItem(label: l10n.footerTermsOfUse, route: '/terms-of-service'),
          ],
          currentRoute: '/terms-of-service',
          onNavItemTap: (route) => context.go(route),
        );
    }

    final sections = [
      (section1Key, l10n.tosSection1Title, l10n.tosSection1Body),
      (section2Key, l10n.tosSection2Title, l10n.tosSection2Body),
      (section3Key, l10n.tosSection3Title, l10n.tosSection3Body),
      (section4Key, l10n.tosSection4Title, l10n.tosSection4Body),
      (section5Key, l10n.tosSection5Title, l10n.tosSection5Body),
    ];

    final toc = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surfaceSubtle,
        border: Border.all(color: context.appColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tosTocTitle,
            style: theme.textTheme.titleMedium?.copyWith(color: AppTheme.primary),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < sections.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            InkWell(
              onTap: () => _scrollToSection(sections[i].$1),
              child: Text(
                sections[i].$2,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.tosTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.primary,
              fontSize: 44,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 32),
        for (int i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: 32),
          Container(
            key: sections[i].$1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    sections[i].$2,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(sections[i].$3, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
        const SizedBox(height: 64),
      ],
    );

    return BaseScaffold(
      header: header,
      alignment: AppPageAlignment.wide,
      showFooter: true,
      scrollable: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isStacked = constraints.maxWidth < 900;
          if (isStacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [toc, const SizedBox(height: 24), content],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: content),
              const SizedBox(width: 32),
              SizedBox(width: 220, child: toc),
            ],
          );
        },
      ),
    );
  }
}
