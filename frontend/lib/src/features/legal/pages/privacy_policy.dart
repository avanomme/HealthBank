import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/widgets.dart';
import 'package:frontend/src/features/auth/auth.dart';
import 'package:frontend/src/features/hcp_clients/hcp.dart';
import 'package:frontend/src/features/participant/participant.dart';
import 'package:frontend/src/features/researcher/researcher.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyPage extends ConsumerStatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  ConsumerState<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends ConsumerState<PrivacyPolicyPage> {
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
    final theme = Theme.of(context);
    final role = ref.watch(authProvider.select((s) => s.user?.role));
    final l10n = context.l10n;

    PreferredSizeWidget header;
    switch (role) {
      case 'participant':
        header = ParticipantHeader(currentRoute: '/privacy-policy');
        break;
      case 'researcher':
        header = ResearcherHeader(currentRoute: '/privacy-policy');
        break;
      case 'hcp':
        header = HcpHeader(currentRoute: '/privacy-policy');
        break;
      case 'admin':
        header = const Header(navItems: [], currentRoute: '/privacy-policy');
        break;
      default:
        header = Header(
          navItems: [
            NavItem(label: l10n.navHome, route: '/'),
            NavItem(label: l10n.commonPrivacyPolicy, route: '/privacy-policy'),
            NavItem(label: l10n.footerTermsOfUse, route: '/terms-of-service'),
          ],
          currentRoute: '/privacy-policy',
          onNavItemTap: (route) => context.go(route),
        );
    }

    return BaseScaffold(
      header: header,
      alignment: AppPageAlignment.wide,
      showFooter: true,
      scrollable: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isStacked = constraints.maxWidth < 900;
          final content = _PrivacyPolicyContent(
            theme: theme,
            l10n: l10n,
            section1Key: section1Key,
            section2Key: section2Key,
            section3Key: section3Key,
            section4Key: section4Key,
            section5Key: section5Key,
          );
          final toc = _PrivacyPolicyToc(
            theme: theme,
            l10n: l10n,
            onSectionTap: [
              () => _scrollToSection(section1Key),
              () => _scrollToSection(section2Key),
              () => _scrollToSection(section3Key),
              () => _scrollToSection(section4Key),
              () => _scrollToSection(section5Key),
            ],
          );

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

class _PrivacyPolicyContent extends StatelessWidget {
  const _PrivacyPolicyContent({
    required this.theme,
    required this.l10n,
    required this.section1Key,
    required this.section2Key,
    required this.section3Key,
    required this.section4Key,
    required this.section5Key,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final GlobalKey section1Key;
  final GlobalKey section2Key;
  final GlobalKey section3Key;
  final GlobalKey section4Key;
  final GlobalKey section5Key;

  Widget _section(GlobalKey key, String title, String body) {
    return Container(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.privacyPolicyTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.primary,
              fontSize: 44,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 32),
        _section(section1Key, l10n.privacyPolicySection1Title, l10n.privacyPolicySection1Body),
        const SizedBox(height: 32),
        _section(section2Key, l10n.privacyPolicySection2Title, l10n.privacyPolicySection2Body),
        const SizedBox(height: 32),
        _section(section3Key, l10n.privacyPolicySection3Title, l10n.privacyPolicySection3Body),
        const SizedBox(height: 32),
        _section(section4Key, l10n.privacyPolicySection4Title, l10n.privacyPolicySection4Body),
        const SizedBox(height: 32),
        _section(section5Key, l10n.privacyPolicySection5Title, l10n.privacyPolicySection5Body),
        const SizedBox(height: 64),
      ],
    );
  }
}

class _PrivacyPolicyToc extends StatelessWidget {
  const _PrivacyPolicyToc({
    required this.theme,
    required this.l10n,
    required this.onSectionTap,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final List<VoidCallback> onSectionTap;

  @override
  Widget build(BuildContext context) {
    final sections = [
      l10n.privacyPolicySection1Title,
      l10n.privacyPolicySection2Title,
      l10n.privacyPolicySection3Title,
      l10n.privacyPolicySection4Title,
      l10n.privacyPolicySection5Title,
    ];

    return Container(
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
            l10n.privacyPolicyTocTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < sections.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            InkWell(
              onTap: onSectionTap[i],
              child: Text(
                sections[i],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
