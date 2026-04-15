// Created with the Assistance of Claude Code
// frontend/lib/src/features/hcp_clients/pages/hcp_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:frontend/src/features/hcp_clients/state/hcp_providers.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart'
    show hcpLinksProvider, participantSessionProvider;
import '../widgets/hcp_scaffold.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Healthcare Professional (HCP) Dashboard page
///
/// Features:
/// - Welcome greeting with HCP's name
/// - Linked patients stat card (active, consented)
/// - Pending requests stat card
/// - Recent patients list (first 3)
/// - Navigation to full patient list and reports
class HcpDashboardPage extends ConsumerWidget {
  const HcpDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sessionAsync = ref.watch(participantSessionProvider);
    final linksAsync = ref.watch(hcpLinksProvider);
    final patientsAsync = ref.watch(hcpPatientsProvider);

    final welcomeName = sessionAsync.maybeWhen(
      data: (session) {
        // Prefer viewing-as user's name when admin is impersonating
        final firstName =
            session.viewingAs?.firstName ?? session.user.firstName;
        if (firstName != null && firstName.trim().isNotEmpty) {
          return firstName.trim();
        }
        return session.viewingAs?.email ?? session.user.email;
      },
      orElse: () => '',
    );

    final pendingCount = linksAsync.maybeWhen(
      data: (links) => links
          .where((l) => l.status == 'pending' && l.requestedBy == 'hcp')
          .length,
      orElse: () => 0,
    );

    final linkedCount = patientsAsync.maybeWhen(
      data: (patients) => patients.length,
      orElse: () => 0,
    );

    return HcpScaffold(
      currentRoute: '/hcp/dashboard',
      scrollable: true,
      showFooter: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (welcomeName.isNotEmpty) ...[
            AppText(
              l10n.hcpDashboardWelcome(welcomeName),
              variant: AppTextVariant.headlineMedium,
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
          ],
          AppText(
            l10n.hcpDashboardTitle,
            variant: AppTextVariant.bodyLarge,
            color: context.appColors.textMuted,
          ),
          const SizedBox(height: 24),
          _buildStatCards(
            l10n,
            patientsAsync,
            linksAsync,
            linkedCount,
            pendingCount,
          ),
          const SizedBox(height: 28),
          _buildRecentPatients(context, l10n, patientsAsync),
          const SizedBox(height: 28),
          _buildNavButtons(context, l10n),
        ],
      ),
    );
  }

  Widget _buildStatCards(
    AppLocalizations l10n,
    AsyncValue<List<Map<String, dynamic>>> patientsAsync,
    AsyncValue<List<dynamic>> linksAsync,
    int linkedCount,
    int pendingCount,
  ) {
    return AppOverflowSafeArea(
      child: Row(
        children: [
          SizedBox(
            width: 240,
            child: AppStatCard(
              label: l10n.hcpDashboardLinkedPatients,
              value: patientsAsync.maybeWhen(
                data: (p) => '$linkedCount',
                orElse: () => '—',
              ),
              icon: Icons.people_outline,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 240,
            child: AppStatCard(
              label: l10n.hcpDashboardPendingRequests,
              value: linksAsync.maybeWhen(
                data: (_) => '$pendingCount',
                orElse: () => '—',
              ),
              icon: Icons.pending_outlined,
              color: AppTheme.caution,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPatients(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<List<Map<String, dynamic>>> patientsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          l10n.hcpLinkMyPatients,
          variant: AppTextVariant.bodyLarge,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 12),
        patientsAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (_, __) => AppText(
            l10n.errorGeneric,
            variant: AppTextVariant.bodyMedium,
            color: AppTheme.error,
          ),
          data: (patients) {
            if (patients.isEmpty) {
              return AppText(
                l10n.hcpDashboardNoActivity,
                variant: AppTextVariant.bodyMedium,
                color: context.appColors.textMuted,
              );
            }
            final recent = patients.take(3).toList();
            return Column(
              children: recent
                  .map((p) => _buildPatientTile(context, p))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavButtons(BuildContext context, AppLocalizations l10n) {
    return AppOverflowSafeArea(
      child: Row(
        children: [
          SizedBox(
            width: 220,
            child: AppOutlinedButton(
              label: l10n.commonViewAll,
              onPressed: () => context.go('/hcp/clients'),
              icon: Icons.people_outline,
              foregroundColor: AppTheme.primary,
              borderColor: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 220,
            child: AppFilledButton(
              label: l10n.navReports,
              onPressed: () => context.go('/hcp/reports'),
              backgroundColor: AppTheme.secondary,
              textColor: AppTheme.textContrast,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientTile(BuildContext context, Map<String, dynamic> patient) {
    final name =
        patient['patient_name'] as String? ??
        'Patient #${patient['patient_id']}';
    final linkedAt = patient['linked_at'] as String?;
    String subtitle = '';
    if (linkedAt != null) {
      try {
        final dt = DateTime.parse(linkedAt);
        subtitle = DateFormat.yMMMd().format(dt);
      } catch (_) {
        subtitle = linkedAt;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Row(
          children: [
            const ExcludeSemantics(
              child: Icon(
                Icons.person_outline,
                color: AppTheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTheme.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: AppTheme.captions.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
