// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/pages/participant_tasks_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/data_display/app_card_task.dart';
import 'package:frontend/src/core/widgets/data_display/app_progress_bar.dart';
import 'package:frontend/src/core/widgets/micro/app_icon.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/config/go_router.dart' show AppRoutes;
import 'package:frontend/src/features/messaging/state/messaging_providers.dart'
    show conversationsProvider;

/// Participant Tasks page
///
/// Features:
/// - Alerts section: profile incomplete, consent required, HCP link requests
/// - Pending surveys list with due date urgency colouring
/// - Progress summary with completion bar and "View Results" CTA
class ParticipantTasksPage extends ConsumerStatefulWidget {
  const ParticipantTasksPage({super.key});

  @override
  ConsumerState<ParticipantTasksPage> createState() =>
      _ParticipantTasksPageState();
}

class _ParticipantTasksPageState extends ConsumerState<ParticipantTasksPage> {
  // Track loading/error state per link ID for HCP respond buttons.
  final Map<int, bool> _respondingToLink = {};
  final Map<int, String?> _linkError = {};
  // Track loading state for consent revoke/restore per link ID.
  final Map<int, bool> _consentUpdating = {};

  Future<void> _refresh() async {
    ref.invalidate(participantAssignmentsProvider);
    ref.invalidate(hcpLinksProvider);
    ref.invalidate(participantConsentStatusProvider);
  }

  Future<void> _respondToHcpLink(
      HcpLink link, String action, AppLocalizations l10n) async {
    setState(() {
      _respondingToLink[link.linkId] = true;
      _linkError[link.linkId] = null;
    });
    try {
      final api = ref.read(hcpLinkApiProvider);
      await api.respondToLink(link.linkId, {'action': action});
      if (mounted) {
        final msg = action == 'accept'
            ? l10n.todoHcpLinkAccepted
            : l10n.todoHcpLinkDeclined;
        AppToast.showSuccess(context, message: msg);
        ref.invalidate(hcpLinksProvider);
        // Refresh conversations so the new HCP conversation appears immediately
        if (action == 'accept') ref.invalidate(conversationsProvider);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _linkError[link.linkId] = l10n.todoHcpLinkError;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _respondingToLink[link.linkId] = false;
        });
      }
    }
  }

  Future<void> _revokeConsent(HcpLink link, AppLocalizations l10n) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: l10n.consentRevokeConfirmTitle,
      content: l10n.consentRevokeConfirmBody(link.hcpName ?? 'HCP'),
      confirmLabel: l10n.consentRevokeHcpAccess,
      cancelLabel: l10n.commonCancel,
      isDangerous: true,
    );
    if (!confirmed || !mounted) return;

    setState(() => _consentUpdating[link.linkId] = true);
    try {
      final api = ref.read(hcpLinkApiProvider);
      await api.revokeConsent(link.linkId);
      if (mounted) {
        ref.invalidate(hcpLinksProvider);
        AppToast.showSuccess(context, message: l10n.consentRevokeSuccess);
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: l10n.consentRevokeError);
      }
    } finally {
      if (mounted) setState(() => _consentUpdating[link.linkId] = false);
    }
  }

  Future<void> _restoreConsent(HcpLink link, AppLocalizations l10n) async {
    setState(() => _consentUpdating[link.linkId] = true);
    try {
      final api = ref.read(hcpLinkApiProvider);
      await api.restoreConsent(link.linkId);
      if (mounted) {
        ref.invalidate(hcpLinksProvider);
        AppToast.showSuccess(context, message: l10n.consentRestoreSuccess);
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: l10n.consentRevokeError);
      }
    } finally {
      if (mounted) setState(() => _consentUpdating[link.linkId] = false);
    }
  }

  String _formatDueText(DateTime? dueDate, AppLocalizations l10n) {
    if (dueDate == null) return l10n.participantPlaceholder;
    final now = DateTime.now();
    final dateOnly = DateUtils.dateOnly(dueDate);
    final today = DateUtils.dateOnly(now);
    final locale = l10n.localeName;
    if (dateOnly == today) {
      final timeText = DateFormat.jm(locale).format(dueDate);
      return l10n.participantDueTodayAt(timeText);
    }
    final dateText = DateFormat.yMMMd(locale).format(dueDate);
    return l10n.participantDueOn(dateText);
  }

  Color _dueTextColor(DateTime? dueDate) {
    if (dueDate == null) return context.appColors.textMuted;
    final now = DateTime.now();
    final diff = dueDate.difference(now);
    if (diff.isNegative) return AppTheme.error;
    if (diff.inDays <= 3) return AppTheme.caution;
    return context.appColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ParticipantScaffold(
      currentRoute: '/participant/tasks',
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                l10n.todoPageTitle,
                variant: AppTextVariant.headlineMedium,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 16),
              _buildAlerts(context, l10n),
              const SizedBox(height: 24),
              _buildHcpConnections(context, l10n),
              const SizedBox(height: 24),
              _buildPendingSurveys(context, l10n),
              const SizedBox(height: 24),
              _buildProgressSummary(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlerts(BuildContext context, AppLocalizations l10n) {
    final profileComplete = ref.watch(participantProfileCompleteProvider);
    final consentAsync = ref.watch(participantConsentStatusProvider);
    final linksAsync = ref.watch(hcpLinksProvider);

    final alerts = <Widget>[];

    // Profile incomplete alert
    if (!profileComplete) {
      alerts.add(Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppAnnouncement(
          message: l10n.todoProfileIncomplete,
          icon: const AppIcon(Icons.person_outline),
          backgroundColor: AppTheme.caution,
          textColor: AppTheme.textContrast,
          onTap: () => context.go(AppRoutes.completeProfile),
        ),
      ));
    }

    // Consent required alert
    consentAsync.whenData((isCurrent) {
      if (!isCurrent) {
        alerts.add(Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppAnnouncement(
            message: l10n.todoConsentRequired,
            icon: const AppIcon(Icons.assignment_outlined),
            backgroundColor: AppTheme.error,
            textColor: AppTheme.textContrast,
            onTap: () => context.go(AppRoutes.consent),
          ),
        ));
      }
    });

    // HCP link requests
    linksAsync.whenData((links) {
      final pending = links
          .where((l) => l.status == 'pending' && l.requestedBy == 'hcp')
          .toList();
      for (final link in pending) {
        final isResponding = _respondingToLink[link.linkId] == true;
        final errMsg = _linkError[link.linkId];
        alerts.add(Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildHcpLinkRequestCard(
              context, l10n, link, isResponding, errMsg),
        ));
      }
    });

    if (alerts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          l10n.todoAlertsTitle,
          variant: AppTextVariant.bodyLarge,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 8),
        ...alerts,
      ],
    );
  }

  Widget _buildHcpLinkRequestCard(
    BuildContext context,
    AppLocalizations l10n,
    HcpLink link,
    bool isResponding,
    String? errorMsg,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.todoHcpLinkRequest(link.hcpName ?? l10n.hcpUnknown),
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textPrimary,
          ),
          if (errorMsg != null) ...[
            const SizedBox(height: 8),
            AppText(
              errorMsg,
              variant: AppTextVariant.bodySmall,
              color: AppTheme.error,
            ),
          ],
          const SizedBox(height: 12),
          if (isResponding)
            const AppLoadingIndicator()
          else
            Row(
              children: [
                Expanded(
                  child: AppFilledButton(
                    label: l10n.todoHcpAccept,
                    onPressed: () =>
                        _respondToHcpLink(link, 'accept', l10n),
                    backgroundColor: AppTheme.success,
                    textColor: AppTheme.textContrast,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppOutlinedButton(
                    label: l10n.todoHcpDecline,
                    onPressed: () =>
                        _respondToHcpLink(link, 'reject', l10n),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Displays active HCP connections with revoke/restore consent buttons.
  Widget _buildHcpConnections(BuildContext context, AppLocalizations l10n) {
    final linksAsync = ref.watch(hcpLinksProvider);

    return linksAsync.maybeWhen(
      data: (links) {
        final activeLinks =
            links.where((l) => l.status == 'active').toList();
        if (activeLinks.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              l10n.participantLinkedHcps,
              variant: AppTextVariant.bodyLarge,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 8),
            ...activeLinks.map((link) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildHcpConnectionCard(context, l10n, link),
                )),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildHcpConnectionCard(
    BuildContext context,
    AppLocalizations l10n,
    HcpLink link,
  ) {
    final isUpdating = _consentUpdating[link.linkId] == true;
    final isRevoked = link.consentRevoked;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRevoked
              ? AppTheme.error.withValues(alpha: 0.4)
              : context.appColors.divider,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isRevoked ? Icons.person_off_outlined : Icons.person_outline,
            color: isRevoked ? AppTheme.error : AppTheme.primary,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  link.hcpName ?? 'HCP #${link.hcpId}',
                  variant: AppTextVariant.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.textPrimary,
                ),
                if (isRevoked)
                  AppText(
                    l10n.hcpPatientConsentRevoked,
                    variant: AppTextVariant.bodySmall,
                    color: AppTheme.error,
                  ),
              ],
            ),
          ),
          if (isUpdating)
            const AppLoadingIndicator.inline(size: 24)
          else if (isRevoked)
            AppOutlinedButton(
              label: l10n.consentRestoreHcpAccess,
              onPressed: () => _restoreConsent(link, l10n),
            )
          else
            AppOutlinedButton(
              label: l10n.consentRevokeHcpAccess,
              onPressed: () => _revokeConsent(link, l10n),
            ),
        ],
      ),
    );
  }

  Widget _buildPendingSurveys(BuildContext context, AppLocalizations l10n) {
    final assignmentsAsync = ref.watch(participantAssignmentsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          l10n.todoPendingSurveysTitle,
          variant: AppTextVariant.bodyLarge,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 12),
        assignmentsAsync.when(
          loading: () => AppText(
            l10n.commonLoading,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textMuted,
          ),
          error: (_, __) => AppText(
            l10n.errorGeneric,
            variant: AppTextVariant.bodyMedium,
            color: AppTheme.error,
          ),
          data: (assignments) {
            final pending = assignments
                .where((a) => a.status == 'pending')
                .toList(growable: false);
            final sorted = [...pending];
            sorted.sort((a, b) {
              final aDate = a.dueDate ?? DateTime(3000);
              final bDate = b.dueDate ?? DateTime(3000);
              return aDate.compareTo(bDate);
            });

            if (sorted.isEmpty) {
              return AppText(
                l10n.todoNoTasks,
                variant: AppTextVariant.bodyMedium,
                color: context.appColors.textMuted,
              );
            }

            return Column(
              children: sorted.map((task) {
                final dueColor = _dueTextColor(task.dueDate);
                final dueText = _formatDueText(task.dueDate, l10n);
                final now = DateTime.now();
                final isOverdue =
                    task.dueDate != null && task.dueDate!.isBefore(now);
                final dueLabel = isOverdue
                    ? '${l10n.todoOverdueLabel} — $dueText'
                    : dueText;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCardTask(
                    title: task.surveyTitle ?? l10n.participantPlaceholder,
                    dueText: dueLabel,
                    actionLabel: l10n.todoStartSurvey,
                    actionColor: dueColor == AppTheme.error
                        ? AppTheme.error
                        : AppTheme.secondary,
                    actionTextColor: AppTheme.textContrast,
                    onAction: () => context.go(
                      AppRoutes.participantSurveyPath(task.surveyId),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressSummary(BuildContext context, AppLocalizations l10n) {
    final assignmentsAsync = ref.watch(participantAssignmentsProvider);

    return assignmentsAsync.maybeWhen(
      data: (assignments) {
        final total = assignments.length;
        final completed =
            assignments.where((a) => a.status == 'completed').length;
        final progress = total > 0 ? completed / total : 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              l10n.todoCompletedSummaryTitle,
              variant: AppTextVariant.bodyLarge,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 8),
            AppProgressBar(
              progress: progress,
              semanticLabel: l10n.participantTaskProgress,
            ),
            const SizedBox(height: 8),
            AppText(
              l10n.participantTasksCompleted(completed, total),
              variant: AppTextVariant.bodySmall,
              color: context.appColors.textPrimary,
            ),
            const SizedBox(height: 16),
            AppLongButton(
              label: l10n.todoViewResults,
              onPressed: () => context.go('/participant/results'),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
