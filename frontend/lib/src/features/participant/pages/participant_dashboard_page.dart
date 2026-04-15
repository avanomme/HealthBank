// Created with the Assistance of Claude Code and ChatGPT
// frontend/lib/src/features/participant/pages/participant_dashboard_page.dart
//import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/api/models/assignment.dart';
//import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
//import 'package:frontend/src/core/widgets/basics/app_dropdown_menu.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/data_display/app_card_task.dart';
//import 'package:frontend/src/core/widgets/data_display/app_graph_renderer.dart';
import 'package:frontend/src/core/widgets/data_display/app_progress_bar.dart';
//import 'package:frontend/src/core/widgets/data_display/survey_chart_switcher.dart';
import 'package:frontend/src/core/widgets/feedback/app_announcement.dart';
import 'package:frontend/src/core/widgets/micro/app_icon.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/features/participant/state/health_tracking_providers.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
//import 'package:frontend/src/features/participant/state/participant_providers.dart';
import 'package:frontend/src/features/participant/widgets/widgets.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';

/// Participant dashboard page.
///
/// Purpose:
/// - Provide participants a personalized overview of tasks and updates.
/// - Highlight progress, remaining tasks, and next actions.
///
/// Major UI sections:
/// - Header/navigation via ParticipantScaffold.
/// - Welcome greeting and announcement banner.
/// - Graph/diagram cards (analytics placeholders).
/// - Task progress bar and remaining tasks dropdown.
/// - Task cards with action button and CTA.
///
/// Data sources and API dependencies:
/// - Implemented:
///   - AssignmentApi (GET /assignments/me) for task list, counts, due dates, and status.
///   - AuthApi (GET /sessions/me) for current user session info (name, id).
///   - UserApi (GET /users/{id}) for name fallback if session info is incomplete.
///   - SurveyApi (optional) for enriching task cards with survey details.
/// - Missing:
///   - Notifications/messages count endpoint.
///   - Participant dashboard summary endpoint (overall metrics/highlights).
///   - Participant results/analytics endpoint (dashboard graphs).
class ParticipantDashboardPage extends ConsumerStatefulWidget {
  const ParticipantDashboardPage({super.key});

  @override
  ConsumerState<ParticipantDashboardPage> createState() =>
      _ParticipantDashboardPageState();
}

class _ParticipantDashboardPageState
    extends ConsumerState<ParticipantDashboardPage> {
  void _handleNotificationTap() {
    context.go(AppRoutes.messagesInbox);
  }

  void _handleDoTask(MyAssignment assignment) {
    context.go(AppRoutes.participantSurveyPath(assignment.surveyId));
  }

  void _handleViewAllTasks() {
    context.go('/participant/tasks');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profileAsync = ref.watch(participantProfileProvider);
    final assignmentsAsync = ref.watch(participantAssignmentsProvider);
    final notificationCount = ref.watch(participantNotificationCountProvider);
    final checkInAsync = ref.watch(healthCheckInStatusProvider);

    return ParticipantScaffold(
      currentRoute: '/participant/dashboard',
      hasNotifications: notificationCount > 0,
      onNotificationsTap: _handleNotificationTap,
      userName: profileAsync.maybeWhen(
        data: (profile) => profile.displayName,
        orElse: () => null,
      ),
      child: _buildContent(
        context,
        l10n,
        profileAsync: profileAsync,
        assignmentsAsync: assignmentsAsync,
        notificationCount: notificationCount,
        checkInAsync: checkInAsync,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n, {
    required AsyncValue<ParticipantProfile> profileAsync,
    required AsyncValue<List<MyAssignment>> assignmentsAsync,
    required int notificationCount,
    required AsyncValue<HealthCheckInStatus> checkInAsync,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final basePadding = Breakpoints.responsivePadding(screenWidth);
    final sectionGap = basePadding * 1.2;
    final tightGap = basePadding * 0.6;
    final contentMaxWidth = math.min(screenWidth, Breakpoints.maxContent * 0.6);

    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: contentMaxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcome(profileAsync, l10n),
              SizedBox(height: tightGap),
              _buildNotificationBanner(notificationCount, l10n),
              if (notificationCount > 0) SizedBox(height: sectionGap),
              //AppText(
              //  l10n.participantDashboardDescription,
              //  variant: AppTextVariant.bodyMedium,
              //  color: AppTheme.primary,
              //),
              SizedBox(height: tightGap),
              _buildQuickInsights(l10n, basePadding),
              SizedBox(height: sectionGap),
              assignmentsAsync.when(
                data: (assignments) => _buildTasksSection(
                  l10n,
                  assignments,
                  basePadding,
                  checkInAsync.valueOrNull,
                ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome(
    AsyncValue<ParticipantProfile> profileAsync,
    AppLocalizations l10n,
  ) {
    return profileAsync.when(
      data: (profile) {
        final name = profile.firstName ?? profile.displayName;
        return AppText(
          l10n.participantWelcomeMessage(name),
          variant: AppTextVariant.headlineMedium,
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        );
      },
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
    );
  }

  Widget _buildNotificationBanner(int count, AppLocalizations l10n) {
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    return AppAnnouncement(
      message: l10n.participantNewMessages(count),
      icon: const AppIcon(Icons.mail_outline),
      onTap: _handleNotificationTap,
      backgroundColor: AppTheme.caution,
      textColor: AppTheme.textContrast,
    );
  }

  Widget _buildQuickInsights(AppLocalizations l10n, double basePadding) {
    return ParticipantQuickInsightsCard(
      basePadding: basePadding,
      onViewResults: (surveyId) {
        context.go('/participant/results?surveyId=$surveyId');
      },
    );
  }

  Widget _buildTodayTasksSummary(
    AppLocalizations l10n,
    List<MyAssignment> overdueTasks,
    List<MyAssignment> remainingToday,
    double basePadding, {
    bool checkInPending = false,
  }) {
    if (overdueTasks.isNotEmpty) {
      final sortedOverdue = [...overdueTasks]
        ..sort((a, b) {
          final aDate = a.dueDate ?? DateTime(3000);
          final bDate = b.dueDate ?? DateTime(3000);
          return aDate.compareTo(bDate);
        });

      final nextOverdue = sortedOverdue.first;
      final count = sortedOverdue.length;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(basePadding * 0.9),
        decoration: BoxDecoration(
          color: AppTheme.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.error.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ExcludeSemantics(child: Icon(Icons.warning_amber_rounded, color: AppTheme.error)),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    l10n.participantOverdueTasksSummary(count),
                    variant: AppTextVariant.bodyMedium,
                    color: AppTheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AppText(
              nextOverdue.surveyTitle ?? l10n.participantUnknownSurvey,
              variant: AppTextVariant.bodyMedium,
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 4),
            AppText(
              _formatDueText(nextOverdue.dueDate, l10n),
              variant: AppTextVariant.bodySmall,
              color: context.appColors.textMuted,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppFilledButton(
                    label: l10n.participantDoTask,
                    onPressed: () => _handleDoTask(nextOverdue),
                    backgroundColor: AppTheme.secondary,
                    textColor: AppTheme.textContrast,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppOutlinedButton(
                    label: l10n.participantViewAllTasks,
                    onPressed: _handleViewAllTasks,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Only show "caught up" banner when there are no pending assignments
    // AND no pending daily health check-in (the check-in IS a task).
    if (remainingToday.isEmpty && !checkInPending) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(basePadding * 0.9),
        decoration: BoxDecoration(
          color: AppTheme.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.success.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            const ExcludeSemantics(child: Icon(Icons.event_available, color: AppTheme.success)),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                l10n.participantNoTasksDueToday,
                variant: AppTextVariant.bodyMedium,
                color: context.appColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // No survey tasks today but check-in is pending — check-in card below
    // handles its own display, so the summary just collapses.
    if (remainingToday.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedToday = [...remainingToday]
      ..sort((a, b) {
        final aDate = a.dueDate ?? DateTime(3000);
        final bDate = b.dueDate ?? DateTime(3000);
        return aDate.compareTo(bDate);
      });

    final nextTask = sortedToday.first;
    final count = sortedToday.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(basePadding * 0.9),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ExcludeSemantics(child: Icon(Icons.schedule, color: AppTheme.primary)),
              const SizedBox(width: 10),
              Expanded(
                child: AppText(
                  l10n.participantRemainingTasksForToday(count),
                  variant: AppTextVariant.bodyMedium,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppText(
            nextTask.surveyTitle ?? l10n.participantUnknownSurvey,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 4),
          AppText(
            _formatDueText(nextTask.dueDate, l10n),
            variant: AppTextVariant.bodySmall,
            color: context.appColors.textMuted,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppFilledButton(
                  label: l10n.participantDoTask,
                  onPressed: () => _handleDoTask(nextTask),
                  backgroundColor: AppTheme.secondary,
                  textColor: AppTheme.textContrast,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppOutlinedButton(
                  label: l10n.participantViewAllTasks,
                  onPressed: _handleViewAllTasks,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection(
    AppLocalizations l10n,
    List<MyAssignment> assignments,
    double basePadding,
    HealthCheckInStatus? checkIn,
  ) {
  final now = DateTime.now();
  final today = DateUtils.dateOnly(now);
  final weekAgo = today.subtract(const Duration(days: 7));

  final pendingTasks = assignments
      .where((task) => task.status != 'completed')
      .toList(growable: false);

  final completedThisWeek = assignments
      .where((task) =>
          task.status == 'completed' &&
          task.completedAt != null &&
          !DateUtils.dateOnly(task.completedAt!).isBefore(weekAgo))
      .toList(growable: false);

  final overdueTasks = pendingTasks
      .where((task) =>
          task.dueDate != null &&
          DateUtils.dateOnly(task.dueDate!).isBefore(today))
      .toList(growable: false);

  final remainingToday = pendingTasks
      .where((task) =>
          task.dueDate != null &&
          DateUtils.dateOnly(task.dueDate!) == today)
      .toList(growable: false);

  // Health check-in counts as 1 extra task when there are due metrics
  final hasCheckIn = checkIn != null && checkIn.hasAnyDue;
  final checkInPending = hasCheckIn && !checkIn.isComplete;
  final checkInDoneToday = hasCheckIn && checkIn.isComplete;

  final activeTaskCount = pendingTasks.length + (checkInPending ? 1 : 0);
  final completedThisWeekCount = completedThisWeek.length + (checkInDoneToday ? 1 : 0);
  final progressTotal = activeTaskCount + completedThisWeekCount;
  final progressCompleted = completedThisWeekCount;
  final progress = progressTotal > 0 ? progressCompleted / progressTotal : 0.0;

    final sortedTasks = [...pendingTasks];
    sortedTasks.sort((a, b) {
      final aDate = a.dueDate ?? DateTime(3000);
      final bDate = b.dueDate ?? DateTime(3000);
      return aDate.compareTo(bDate);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          l10n.participantYourTaskProgress,
          variant: AppTextVariant.bodyMedium,
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: basePadding * 0.4),
        AppProgressBar(
          progress: progress,
          semanticLabel: l10n.participantTaskProgress,
        ),
        SizedBox(height: basePadding * 0.4),
        AppText(
          l10n.participantTasksCompletedThisWeekSummary(progressCompleted, progressTotal),
          variant: AppTextVariant.bodySmall,
          color: context.appColors.textPrimary,
        ),
        SizedBox(height: basePadding),
        _buildTodayTasksSummary(
          l10n,
          overdueTasks,
          remainingToday,
          basePadding,
          checkInPending: checkInPending,
        ),
        SizedBox(height: basePadding * 0.7),
        // Health check-in card — shown at the top of the pending list when incomplete
        if (checkInPending) ...[
          Padding(
            padding: EdgeInsets.only(bottom: basePadding * 0.6),
            child: _buildCheckInCard(l10n, checkIn, basePadding),
          ),
        ],
        ...sortedTasks.map(
          (task) => Padding(
            padding: EdgeInsets.only(bottom: basePadding * 0.6),
            child: AppCardTask(
              title: task.surveyTitle ?? l10n.participantUnknownSurvey,
              dueText: _formatDueText(task.dueDate, l10n),
              repeatText: _formatRepeatText(task),
              actionLabel: l10n.participantDoTask,
              actionColor: AppTheme.secondary,
              actionTextColor: AppTheme.textContrast,
              onAction: () => _handleDoTask(task),
            ),
          ),
        ),
        _buildCompletedThisWeekSection(l10n, completedThisWeek, checkInDoneToday ? checkIn : null, basePadding),
        SizedBox(height: basePadding * 0.2),
        AppLongButton(
          label: l10n.participantViewAllTasks,
          onPressed: _handleViewAllTasks,
        ),
      ],
    );
  }

  Widget _buildCheckInCard(
    AppLocalizations l10n,
    HealthCheckInStatus checkIn,
    double basePadding,
  ) {
    final subtitle = checkIn.totalDue > 0
        ? l10n.healthCheckInTaskProgress(checkIn.completedCount, checkIn.totalDue)
        : l10n.healthCheckInTaskDueText;
    return AppCardTask(
      title: l10n.healthCheckInTaskTitle,
      dueText: subtitle,
      repeatText: l10n.healthCheckInTaskRepeat,
      actionLabel: l10n.healthCheckInTaskAction,
      actionColor: AppTheme.primary,
      actionTextColor: AppTheme.textContrast,
      onAction: () => context.go(AppRoutes.participantHealthTracking),
    );
  }

  Widget _buildCompletedThisWeekSection(
    AppLocalizations l10n,
    List<MyAssignment> completedThisWeek,
    HealthCheckInStatus? completedCheckIn,
    double basePadding,
  ) {
    final hasCheckInDone = completedCheckIn != null && completedCheckIn.isComplete;
    if (completedThisWeek.isEmpty && !hasCheckInDone) return const SizedBox.shrink();

    Widget completedRow({required String title, required String subtitle}) {
      return Padding(
        padding: EdgeInsets.only(bottom: basePadding * 0.4),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(basePadding * 0.75),
          decoration: BoxDecoration(
            color: AppTheme.success.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.success.withValues(alpha: 0.20)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: AppTheme.success, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title,
                      variant: AppTextVariant.bodyMedium,
                      color: AppTheme.adaptiveTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      subtitle,
                      variant: AppTextVariant.bodySmall,
                      color: AppTheme.adaptiveTextMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: basePadding * 0.7),
        AppText(
          l10n.participantCompletedThisWeek,
          variant: AppTextVariant.bodyMedium,
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: basePadding * 0.4),
        // Health check-in completed entry
        if (hasCheckInDone)
          completedRow(
            title: l10n.healthCheckInTaskTitle,
            subtitle: l10n.healthCheckInTaskCompletedToday,
          ),
        // Survey assignments completed this week
        ...completedThisWeek.map(
          (task) => completedRow(
            title: task.surveyTitle ?? l10n.participantUnknownSurvey,
            subtitle: task.completedAt != null
                ? l10n.participantCompletedOn(
                    DateFormat.yMMMd(l10n.localeName).format(task.completedAt!),
                  )
                : '',
          ),
        ),
      ],
    );
  }

  String _formatDueText(DateTime? dueDate, AppLocalizations l10n) {
    if (dueDate == null) {
      return l10n.participantNoDueDate;
    }

    final now = DateTime.now();
    final dateOnly = DateUtils.dateOnly(dueDate);
    final today = DateUtils.dateOnly(now);
    final locale = l10n.localeName;

    if (dateOnly.isBefore(today)) {
      final dateText = DateFormat.yMMMd(locale).format(dueDate);
      return l10n.participantOverdueSince(dateText);
    }

    if (dateOnly == today) {
      final timeText = DateFormat.jm(locale).format(dueDate);
      return l10n.participantDueTodayAt(timeText);
    }

    final dateText = DateFormat.yMMMd(locale).format(dueDate);
    return l10n.participantDueOn(dateText);
  }

  String? _formatRepeatText(MyAssignment _) {
    return null;
  }
}