// Created with the Assistance of Claude Code
// frontend/lib/src/features/hcp_clients/pages/hcp_client_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/features/hcp_clients/state/hcp_providers.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart'
    show hcpLinkApiProvider, hcpLinksProvider;
import '../widgets/hcp_scaffold.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// HCP Client List page
///
/// Features:
/// - List of linked (active) patients with expandable survey rows
/// - Consent-revoked badge for patients who have revoked consent
/// - Pending outgoing requests
/// - Button to request a new patient link by account ID
class HcpClientListPage extends ConsumerStatefulWidget {
  const HcpClientListPage({super.key});

  @override
  ConsumerState<HcpClientListPage> createState() => _HcpClientListPageState();
}

class _HcpClientListPageState extends ConsumerState<HcpClientListPage> {
  final Map<int, bool> _removingLink = {};
  bool _requestLoading = false;
  String? _requestError;

  Future<void> _removeLink(int linkId, AppLocalizations l10n) async {
    setState(() => _removingLink[linkId] = true);
    try {
      final api = ref.read(hcpLinkApiProvider);
      await api.deleteLink(linkId);
      if (mounted) {
        ref.invalidate(hcpLinksProvider);
      }
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, message: l10n.hcpLinkErrorGeneral);
      }
    } finally {
      if (mounted) setState(() => _removingLink[linkId] = false);
    }
  }

  Future<void> _showRequestDialog(AppLocalizations l10n) async {
    final query = await showDialog<String>(
      context: context,
      builder: (ctx) => _RequestLinkDialog(l10n: l10n),
    );
    if (query != null && query.isNotEmpty && mounted) {
      _requestLink(query, l10n);
    }
  }

  Future<void> _requestLink(String query, AppLocalizations l10n) async {
    setState(() {
      _requestLoading = true;
      _requestError = null;
    });
    try {
      final api = ref.read(hcpLinkApiProvider);
      await api.requestLink({'query': query});
      if (mounted) {
        AppToast.showSuccess(context, message: l10n.hcpLinkRequestSent);
        ref.invalidate(hcpLinksProvider);
      }
    } on Exception catch (_) {
      if (mounted) {
        AppToast.showError(context, message: l10n.hcpLinkErrorGeneral);
      }
    } finally {
      if (mounted) setState(() => _requestLoading = false);
    }
  }

  String _formatDate(DateTime dt) => DateFormat.yMMMd().format(dt);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final linksAsync = ref.watch(hcpLinksProvider);

    return HcpScaffold(
      currentRoute: '/hcp/clients',
      scrollable: true,
      showFooter: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppText(
                l10n.hcpLinkPageTitle,
                variant: AppTextVariant.headlineMedium,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
              AppFilledButton(
                label: _requestLoading ? '...' : l10n.hcpLinkRequestPatient,
                onPressed: _requestLoading
                    ? null
                    : () => _showRequestDialog(l10n),
                backgroundColor: AppTheme.secondary,
                textColor: AppTheme.textContrast,
              ),
            ],
          ),
          if (_requestError != null) ...[
            const SizedBox(height: 8),
            AppText(
              _requestError!,
              variant: AppTextVariant.bodySmall,
              color: AppTheme.error,
            ),
          ],
          const SizedBox(height: 24),
          linksAsync.when(
            loading: () => const AppLoadingIndicator(),
            error: (_, __) => AppText(
              l10n.errorGeneric,
              variant: AppTextVariant.bodyMedium,
              color: AppTheme.error,
            ),
            data: (links) => _buildLinkLists(context, l10n, links),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkLists(
    BuildContext context,
    AppLocalizations l10n,
    List<HcpLink> links,
  ) {
    // Active + consented patients
    final activeLinks = links
        .where((l) => l.status == 'active' && !l.consentRevoked)
        .toList();
    // Active links where consent was revoked
    final revokedLinks = links
        .where((l) => l.status == 'active' && l.consentRevoked)
        .toList();
    // Pending HCP-initiated requests
    final pendingLinks = links
        .where((l) => l.status == 'pending' && l.requestedBy == 'hcp')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Active patients section
        AppText(
          l10n.hcpLinkMyPatients,
          variant: AppTextVariant.bodyLarge,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 12),
        if (activeLinks.isEmpty)
          AppText(
            l10n.hcpLinkNoPatients,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textMuted,
          )
        else
          ...activeLinks.map((link) => _buildExpandablePatientCard(l10n, link)),

        if (revokedLinks.isNotEmpty) ...[
          const SizedBox(height: 28),
          AppText(
            l10n.hcpPatientConsentRevoked,
            variant: AppTextVariant.bodyLarge,
            fontWeight: FontWeight.w600,
            color: AppTheme.error,
          ),
          const SizedBox(height: 12),
          ...revokedLinks.map((link) => _buildRevokedPatientCard(l10n, link)),
        ],

        const SizedBox(height: 28),

        // Pending requests section
        AppText(
          l10n.hcpLinkPendingRequests,
          variant: AppTextVariant.bodyLarge,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 12),
        if (pendingLinks.isEmpty)
          AppText(
            l10n.hcpLinkNoPending,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textMuted,
          )
        else
          ...pendingLinks.map((link) => _buildPendingLinkCard(l10n, link)),
      ],
    );
  }

  Widget _buildExpandablePatientCard(AppLocalizations l10n, HcpLink link) {
    final isRemoving = _removingLink[link.linkId] == true;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.appColors.divider),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          leading: const Icon(Icons.person, color: AppTheme.primary, size: 32),
          title: AppText(
            link.patientName ?? 'Patient #${link.patientId}',
            variant: AppTextVariant.bodyLarge,
            fontWeight: FontWeight.w600,
            color: context.appColors.textPrimary,
          ),
          subtitle: AppText(
            l10n.hcpLinkLinkedSince(_formatDate(link.updatedAt)),
            variant: AppTextVariant.bodySmall,
            color: context.appColors.textMuted,
          ),
          trailing: isRemoving
              ? const AppLoadingIndicator.inline(size: 24)
              : AppTextButton(
                  label: l10n.hcpLinkRemove,
                  onPressed: () => _confirmRemove(link, l10n),
                ),
          children: [_PatientSurveyList(patientId: link.patientId, l10n: l10n)],
        ),
      ),
    );
  }

  Widget _buildRevokedPatientCard(AppLocalizations l10n, HcpLink link) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.error.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.person_off_outlined,
              color: AppTheme.error,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    link.patientName ?? 'Patient #${link.patientId}',
                    variant: AppTextVariant.bodyLarge,
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textPrimary,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    l10n.hcpLinkLinkedSince(_formatDate(link.updatedAt)),
                    variant: AppTextVariant.bodySmall,
                    color: context.appColors.textMuted,
                  ),
                ],
              ),
            ),
            AppOverflowSafeArea(
              child: Chip(
                label: Text(l10n.hcpPatientConsentRevoked),
                backgroundColor: AppTheme.error.withValues(alpha: 0.12),
                labelStyle: const TextStyle(
                  color: AppTheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingLinkCard(AppLocalizations l10n, HcpLink link) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.caution),
        ),
        child: Row(
          children: [
            const ExcludeSemantics(
              child: Icon(Icons.schedule, color: AppTheme.caution, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    link.patientName ?? 'Patient #${link.patientId}',
                    variant: AppTextVariant.bodyLarge,
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textPrimary,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    l10n.hcpLinkPendingFrom(_formatDate(link.requestedAt)),
                    variant: AppTextVariant.bodySmall,
                    color: context.appColors.textMuted,
                  ),
                ],
              ),
            ),
            AppOverflowSafeArea(
              child: Chip(
                label: Text(l10n.statusPending),
                backgroundColor: AppTheme.caution.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRemove(HcpLink link, AppLocalizations l10n) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: l10n.hcpLinkRemove,
      content: l10n.hcpLinkRemoveConfirm,
      confirmLabel: l10n.hcpLinkRemove,
      cancelLabel: l10n.commonCancel,
      isDangerous: true,
    );
    if (confirmed && mounted) {
      await _removeLink(link.linkId, l10n);
    }
  }
}

/// Loads and displays a patient's completed surveys inside an expansion tile.
class _PatientSurveyList extends ConsumerWidget {
  const _PatientSurveyList({required this.patientId, required this.l10n});

  final int patientId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveysAsync = ref.watch(hcpPatientSurveysProvider(patientId));

    return surveysAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: AppLoadingIndicator.inline(),
      ),
      error: (_, __) => AppText(
        l10n.errorGeneric,
        variant: AppTextVariant.bodySmall,
        color: AppTheme.error,
      ),
      data: (surveys) {
        if (surveys.isEmpty) {
          return AppText(
            l10n.hcpPatientNoSurveys,
            variant: AppTextVariant.bodySmall,
            color: context.appColors.textMuted,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              l10n.hcpPatientSurveysTitle,
              variant: AppTextVariant.bodySmall,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 8),
            ...surveys.map((survey) => _buildSurveyRow(context, survey)),
          ],
        );
      },
    );
  }

  Widget _buildSurveyRow(BuildContext context, Map<String, dynamic> survey) {
    final title =
        survey['title'] as String? ??
        survey['survey_title'] as String? ??
        'Survey';
    final completedAt = survey['completed_at'] as String?;
    String dateStr = '';
    if (completedAt != null) {
      try {
        final dt = DateTime.parse(completedAt);
        dateStr = DateFormat.yMMMd().format(dt);
      } catch (_) {
        dateStr = completedAt;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.assignment_turned_in_outlined,
            size: 16,
            color: AppTheme.success,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title, style: AppTheme.body.copyWith(fontSize: 13)),
          ),
          if (dateStr.isNotEmpty)
            Text(
              dateStr,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}

/// Dialog that lets the HCP enter a patient email to request a link.
/// Uses a StatefulWidget so the TextEditingController is disposed
/// when the dialog is removed from the tree (after its close animation).
class _RequestLinkDialog extends StatefulWidget {
  const _RequestLinkDialog({required this.l10n});
  final AppLocalizations l10n;

  @override
  State<_RequestLinkDialog> createState() => _RequestLinkDialogState();
}

class _RequestLinkDialogState extends State<_RequestLinkDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return AlertDialog(
      title: Text(l10n.hcpLinkRequestPatient),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: l10n.hcpLinkEnterPatientEmail,
          hintText: l10n.hcpLinkPatientEmailHint,
        ),
        autofocus: true,
      ),
      actions: [
        AppTextButton(
          label: l10n.commonCancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppFilledButton(
          label: l10n.commonConfirm,
          onPressed: () {
            final query = _controller.text.trim();
            if (query.isEmpty) return;
            Navigator.of(context).pop(query);
          },
        ),
      ],
    );
  }
}
