// Created with the Assistance of GitHub Copilot
// frontend/lib/src/features/public/pages/about_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/config/navigation.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:frontend/src/features/hcp_clients/widgets/hcp_scaffold.dart';
import 'package:frontend/src/features/admin/widgets/admin_scaffold.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final role = ref.watch(authProvider.select((s) => s.user?.role));
    final userRole = NavigationConfig.parseRole(role) ?? UserRole.participant;

    final aboutContent = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.aboutPageTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primary,
                    ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.aboutPageBody,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );

    switch (userRole) {
      case UserRole.participant:
        return ParticipantScaffold(
          currentRoute: '/about',
          child: aboutContent,
        );
      case UserRole.researcher:
        return ResearcherScaffold(
          currentRoute: '/about',
          child: aboutContent,
        );
      case UserRole.hcp:
        return HcpScaffold(
          currentRoute: '/about',
          child: aboutContent,
        );
      case UserRole.admin:
        return AdminScaffold(
          currentRoute: '/about',
          child: aboutContent,
        );
    }
  }
}
