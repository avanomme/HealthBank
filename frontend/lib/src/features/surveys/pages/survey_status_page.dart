// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/features/surveys/pages/survey_status_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:go_router/go_router.dart';
import '../state/survey_providers.dart';
import '../widgets/survey_assignment_modal.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Survey status page showing assignment analytics with aggregate-only data.
class SurveyStatusPage extends ConsumerStatefulWidget {
  const SurveyStatusPage({super.key, required this.surveyId});

  final int? surveyId;

  @override
  ConsumerState<SurveyStatusPage> createState() => _SurveyStatusPageState();
}

class _SurveyStatusPageState extends ConsumerState<SurveyStatusPage> {
  int? get _surveyId => widget.surveyId;

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.surveys);
    }
  }

  void _navigateToBuilder({required int surveyId}) {
    context.push('/surveys/$surveyId/edit');
  }

  Future<void> _handleAction(String action, Survey survey) async {
    switch (action) {
      case 'edit':
        _navigateToBuilder(surveyId: survey.surveyId);
        break;
      case 'assign':
        await showSurveyAssignmentModal(
          context,
          surveyId: survey.surveyId,
          surveyTitle: survey.title,
        );
        ref.invalidate(surveyAssignmentsProvider(survey.surveyId));
        break;
      case 'publish':
        await _publishSurvey(survey);
        break;
      case 'close':
        await _closeSurvey(survey);
        break;
      case 'delete':
        await _confirmDelete(survey);
        break;
    }
  }

  Future<void> _publishSurvey(Survey survey) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.surveyPublishTitle,
      content: context.l10n.surveyPublishMessage,
      confirmLabel: context.l10n.surveyPublishButton,
      cancelLabel: context.l10n.commonCancel,
      confirmColor: AppTheme.secondary,
    );

    if (confirmed) {
      try {
        final api = ref.read(surveyApiProvider);
        await api.publishSurvey(survey.surveyId);
        ref.invalidate(surveyByIdProvider(survey.surveyId));
        ref.invalidate(surveysProvider);
        if (mounted) {
          AppToast.showSuccess(
            context,
            message: context.l10n.surveyPublishedSuccess,
          );
        }
      } catch (e) {
        if (mounted) {
          AppToast.showError(
            context,
            message: context.l10n.surveyPublishFailed(e.toString()),
          );
        }
      }
    }
  }

  Future<void> _closeSurvey(Survey survey) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.surveyCloseTitle,
      content: context.l10n.surveyCloseMessage,
      confirmLabel: context.l10n.surveyCloseButton,
      cancelLabel: context.l10n.commonCancel,
    );

    if (confirmed) {
      try {
        final api = ref.read(surveyApiProvider);
        await api.closeSurvey(survey.surveyId);
        ref.invalidate(surveyByIdProvider(survey.surveyId));
        ref.invalidate(surveysProvider);
        if (mounted) {
          AppToast.showSuccess(
            context,
            message: context.l10n.surveyClosedSuccess,
          );
        }
      } catch (e) {
        if (mounted) {
          AppToast.showError(
            context,
            message: context.l10n.surveyCloseFailed(e.toString()),
          );
        }
      }
    }
  }

  Future<void> _confirmDelete(Survey survey) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.surveyDeleteTitle,
      content: context.l10n.surveyDeleteConfirm(survey.title),
      confirmLabel: context.l10n.commonDelete,
      cancelLabel: context.l10n.commonCancel,
      isDangerous: true,
    );

    if (confirmed) {
      try {
        final api = ref.read(surveyApiProvider);
        await api.deleteSurvey(survey.surveyId);
        ref.invalidate(surveysProvider);
        if (mounted) {
          AppToast.showSuccess(
            context,
            message: context.l10n.surveyDeletedSuccess,
          );
          context.go(AppRoutes.surveys);
        }
      } catch (e) {
        if (mounted) {
          AppToast.showError(
            context,
            message: context.l10n.surveyDeleteFailed(e.toString()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final surveyId = _surveyId;
    final l10n = context.l10n;

    if (surveyId == null) {
      return ResearcherScaffold(
        currentRoute: AppRoutes.surveys,
        alignment: AppPageAlignment.regular,
        showFooter: true,
        scrollable: true,
        child: Center(
          child: Text(
            l10n.errorNotFound,
            style: AppTheme.body.copyWith(color: AppTheme.error),
          ),
        ),
      );
    }

    final surveyAsync = ref.watch(surveyByIdProvider(surveyId));
    final assignmentsAsync = ref.watch(surveyAssignmentsProvider(surveyId));

    return ResearcherScaffold(
      currentRoute: AppRoutes.surveys,
      alignment: AppPageAlignment.regular,
      showFooter: true,
      scrollable: true,
      child: surveyAsync.when(
        data: (survey) =>
            _buildContent(survey: survey, assignmentsAsync: assignmentsAsync),
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: AppTheme.body.copyWith(color: AppTheme.error),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required Survey survey,
    required AsyncValue<List<Assignment>> assignmentsAsync,
  }) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextButton(
          label: '← Back',
          onPressed: _handleBack,
        ),
        const SizedBox(height: 8),
        Semantics(
          header: true,
          child: Text(
            l10n.surveyStatusPageTitle,
            style: AppTheme.heading4.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        _buildSurveySummaryCard(survey),
        const SizedBox(height: 12),
        _buildActionButtons(survey),
        const SizedBox(height: 24),
        Text(
          l10n.surveyStatusAssignmentAnalytics,
          style: AppTheme.heading5.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        assignmentsAsync.when(
          data: _buildAssignmentAnalytics,
          loading: () => const AppLoadingIndicator(),
          error: (_, __) => Text(
            l10n.surveyAssignErrorLoad,
            style: AppTheme.body.copyWith(color: AppTheme.error),
          ),
        ),
      ],
    );
  }

  Widget _buildSurveySummaryCard(Survey survey) {
    final l10n = context.l10n;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    survey.title,
                    style: AppTheme.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusBadge(survey.publicationStatus),
              ],
            ),
            if (survey.description != null &&
                survey.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                survey.description!,
                style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildMetaItem(
                  icon: Icons.quiz_outlined,
                  label: l10n.surveyListQuestionCount(
                    survey.questionCount ?? survey.questions?.length ?? 0,
                  ),
                ),
                _buildMetaItem(
                  icon: Icons.calendar_today,
                  label:
                      '${l10n.surveyStatusStartDate}: ${_formatDateOrFallback(survey.startDate)}',
                ),
                _buildMetaItem(
                  icon: Icons.event,
                  label:
                      '${l10n.surveyStatusEndDate}: ${_formatDateOrFallback(survey.endDate)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: context.appColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Survey survey) {
    final l10n = context.l10n;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildActionButton(
          icon: Icons.edit,
          label: l10n.surveyCardEdit,
          onPressed: () => _handleAction('edit', survey),
        ),
        if (survey.publicationStatus == 'published')
          _buildActionButton(
            icon: Icons.assignment_ind,
            label: l10n.surveyCardAssign,
            onPressed: () => _handleAction('assign', survey),
          ),
        _buildActionButton(
          icon: Icons.delete,
          label: l10n.surveyCardDelete,
          backgroundColor: AppTheme.error,
          onPressed: () => _handleAction('delete', survey),
        ),
        if (survey.publicationStatus == 'draft')
          _buildActionButton(
            icon: Icons.publish,
            label: l10n.surveyCardPublish,
            backgroundColor: AppTheme.secondary,
            onPressed: () => _handleAction('publish', survey),
          ),
        if (survey.publicationStatus == 'published')
          _buildActionButton(
            icon: Icons.close,
            label: l10n.surveyCardClose,
            backgroundColor: AppTheme.muted,
            onPressed: () => _handleAction('close', survey),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return AppFilledButton(
      label: label,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppTheme.primary,
      textColor: AppTheme.textContrast,
    );
  }

  Widget _buildAssignmentAnalytics(List<Assignment> assignments) {
    final l10n = context.l10n;
    final assignedTotal = assignments.length;
    final pending = assignments.where((a) => a.status == 'pending').length;
    final completed = assignments.where((a) => a.status == 'completed').length;
    final expired = assignments.where((a) => a.status == 'expired').length;

    final pieData = <String, double>{
      l10n.surveyAssignmentStatusPending: pending.toDouble(),
      l10n.surveyAssignmentStatusCompleted: completed.toDouble(),
      l10n.surveyAssignmentStatusExpired: expired.toDouble(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth < Breakpoints.tablet
                ? constraints.maxWidth
                : (constraints.maxWidth - 12) / 2;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: itemWidth,
                  child: AppStatCard(
                    label: l10n.surveyStatusAssignedTotal,
                    value: '$assignedTotal',
                    icon: Icons.groups_outlined,
                    color: AppTheme.primary,
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppStatCard(
                    label: l10n.surveyAssignmentStatusPending,
                    value: '$pending',
                    icon: Icons.hourglass_empty,
                    color: AppTheme.caution,
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppStatCard(
                    label: l10n.surveyAssignmentStatusCompleted,
                    value: '$completed',
                    icon: Icons.check_circle_outline,
                    color: AppTheme.success,
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: AppStatCard(
                    label: l10n.surveyAssignmentStatusExpired,
                    value: '$expired',
                    icon: Icons.event_busy_outlined,
                    color: AppTheme.error,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AppPieChart(
              title: l10n.surveyStatusChartTitle,
              data: pieData,
              height: 280,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'draft':
        color = context.appColors.textMuted;
        label = context.l10n.surveyStatusDraft;
        break;
      case 'published':
        color = AppTheme.secondary;
        label = context.l10n.surveyStatusPublished;
        break;
      case 'closed':
        color = AppTheme.error;
        label = context.l10n.surveyStatusClosed;
        break;
      default:
        color = context.appColors.textMuted;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTheme.captions.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDateOrFallback(DateTime? value) {
    if (value == null) {
      return context.l10n.surveyStatusNoDate;
    }
    return '${value.month}/${value.day}/${value.year}';
  }
}