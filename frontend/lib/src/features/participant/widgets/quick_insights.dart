import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_outlined_button.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/features/participant/participant.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
import 'package:intl/intl.dart';

/// Dashboard card showing the participant's latest survey results at a glance.
///
/// Loads survey data and assignment state from Riverpod providers and
/// provides a shortcut button to view the full results page.
class ParticipantQuickInsightsCard extends ConsumerWidget {
  const ParticipantQuickInsightsCard({
    super.key,
    required this.basePadding,
    required this.onViewResults,
  });

  final double basePadding;
  final void Function(int surveyId) onViewResults;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surveyDataAsync = ref.watch(participantSurveyDataProvider);
    final assignmentsAsync = ref.watch(participantAssignmentsProvider);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(basePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              l10n.participantQuickInsightsTitle,
              variant: AppTextVariant.bodyMedium,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
            SizedBox(height: basePadding * 0.5),
            surveyDataAsync.when(
              loading: () => AppText(
                l10n.commonLoading,
                variant: AppTextVariant.bodySmall,
                color: context.appColors.textMuted,
              ),
              error: (_, __) => AppText(
                l10n.errorGeneric,
                variant: AppTextVariant.bodySmall,
                color: AppTheme.error,
              ),
              data: (surveys) {
                final completedSurveys = surveys
                    .where((s) => s.assignmentStatus == 'completed')
                    .toList()
                  ..sort((a, b) {
                    final aDate = a.completedAt ??
                        DateTime.fromMillisecondsSinceEpoch(0);
                    final bDate = b.completedAt ??
                        DateTime.fromMillisecondsSinceEpoch(0);
                    return bDate.compareTo(aDate);
                  });

                final mostRecent =
                    completedSurveys.isNotEmpty ? completedSurveys.first : null;

                return assignmentsAsync.when(
                  loading: () => AppText(
                    l10n.commonLoading,
                    variant: AppTextVariant.bodySmall,
                    color: context.appColors.textMuted,
                  ),
                  error: (_, __) => AppText(
                    l10n.errorGeneric,
                    variant: AppTextVariant.bodySmall,
                    color: AppTheme.error,
                  ),
                  data: (assignments) {
                    final pendingCount = assignments
                        .where((a) => a.status != 'completed')
                        .length;

                    final isCaughtUp =
                        assignments.isNotEmpty && pendingCount == 0;

                    if (mostRecent != null) {
                      final completedText = mostRecent.completedAt != null
                          ? DateFormat.yMMMd(l10n.localeName)
                              .format(mostRecent.completedAt!)
                          : null;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: AppTheme.success,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      l10n
                                          .participantQuickInsightsMostRecentTitle,
                                      variant: AppTextVariant.bodySmall,
                                      fontWeight: FontWeight.w600,
                                      color: context.appColors.textPrimary,
                                    ),
                                    const SizedBox(height: 4),
                                    AppText(
                                      mostRecent.title,
                                      variant: AppTextVariant.bodyMedium,
                                      color: context.appColors.textPrimary,
                                    ),
                                    if (completedText != null) ...[
                                      const SizedBox(height: 4),
                                      AppText(
                                        l10n
                                            .participantQuickInsightsCompletedOn(
                                          completedText,
                                        ),
                                        variant: AppTextVariant.bodySmall,
                                        color: context.appColors.textMuted,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: basePadding * 0.8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              AppOutlinedButton(
                                label:
                                    l10n.participantQuickInsightsViewInResults,
                                onPressed: () =>
                                    onViewResults(mostRecent.surveyId),
                              ),
                              if (isCaughtUp)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.success
                                        .withValues(alpha: 0.08),
                                    borderRadius:
                                        BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    l10n
                                        .participantQuickInsightsCaughtUpBadge,
                                    style: AppTheme.captions.copyWith(
                                      color: AppTheme.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    }

                    if (isCaughtUp) {
                      return Row(
                        children: [
                          const Icon(
                            Icons.task_alt,
                            color: AppTheme.success,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AppText(
                              l10n.participantQuickInsightsCaughtUpMessage,
                              variant: AppTextVariant.bodySmall,
                              color: context.appColors.textPrimary,
                            ),
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppTheme.info,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppText(
                            l10n.participantQuickInsightsNoCompletedYet,
                            variant: AppTextVariant.bodySmall,
                            color: context.appColors.textPrimary,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}