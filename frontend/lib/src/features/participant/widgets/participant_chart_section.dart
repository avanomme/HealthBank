// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/participant_chart_section.dart
/// Chart widgets for participant personal data view.
///
/// Renders the appropriate chart type based on question response_type:
/// - number/scale → AppBarChart (histogram)
/// - yesno → AppPieChart (yes/no distribution)
/// - single_choice/multi_choice → AppPieChart (option distribution)
/// - openended → no chart (text only)
///
/// Aggregate data is suppressed (hidden) when fewer than K=5 respondents
/// exist, ensuring k-anonymity.  The participant only ever sees their own
/// response value alongside anonymous aggregate statistics.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';
import 'package:frontend/src/core/widgets/data_display/survey_chart_switcher.dart';
import 'package:frontend/src/core/widgets/widgets.dart';

/// Renders a chart for a single question based on its response type and
/// aggregate data.  Shows the participant's own value alongside the
/// aggregate when available.
class ParticipantQuestionChart extends StatelessWidget {
  const ParticipantQuestionChart({super.key, required this.question});

  final ChartQuestionData question;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // No chart for open-ended text responses
    if (question.responseType == 'openended') {
      return const SizedBox.shrink();
    }

    // Suppressed: fewer than K=5 respondents
    if (question.suppressed) {
      return _SuppressedCard(l10n: l10n);
    }

    // No aggregate data available
    if (question.aggregate == null) {
      return _NoDataCard(l10n: l10n);
    }

    return switch (question.responseType) {
      'number' || 'scale' => _NumericChart(question: question, l10n: l10n),
      'yesno' => _YesNoChart(question: question, l10n: l10n),
      'single_choice' || 'multi_choice' => _ChoiceChart(
          question: question,
          l10n: l10n,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

/// Card shown when aggregate data is suppressed for privacy (K-anonymity).
class _SuppressedCard extends StatelessWidget {
  const _SuppressedCard({required this.l10n});
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AppInfoBanner(
        icon: Icons.shield_outlined,
        message: l10n.participantChartSuppressed,
        color: AppTheme.caution,
      ),
    );
  }
}

/// Card shown when no aggregate data is available.
class _NoDataCard extends StatelessWidget {
  const _NoDataCard({required this.l10n});
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.appColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ExcludeSemantics(child: Icon(Icons.bar_chart, color: context.appColors.textMuted, size: 20)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.participantChartNoData,
                style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bar chart for numeric/scale responses showing histogram + participant value.
class _NumericChart extends StatelessWidget {
  const _NumericChart({required this.question, required this.l10n});
  final ChartQuestionData question;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    final agg = question.aggregate ?? {};
    final histogram = agg['histogram'] as List<dynamic>?;

    // Build stat cards for mean/median
    final mean = agg['mean'];
    final median = agg['median'];

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat row: participant value, mean, median
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (question.responseValue != null)
                SizedBox(
                  width: 150,
                  child: AppStatCard(
                    label: l10n.participantChartYourValue,
                    value: question.responseValue!,
                    icon: Icons.person,
                    color: AppTheme.primary,
                  ),
                ),
              if (mean != null)
                SizedBox(
                  width: 150,
                  child: AppStatCard(
                    label: l10n.participantChartMean,
                    value: (mean as num).toStringAsFixed(1),
                    icon: Icons.trending_flat,
                    color: AppTheme.info,
                  ),
                ),
              if (median != null)
                SizedBox(
                  width: 150,
                  child: AppStatCard(
                    label: l10n.participantChartMedian,
                    value: (median as num).toStringAsFixed(1),
                    icon: Icons.vertical_align_center,
                    color: AppTheme.secondary,
                  ),
                ),
            ],
          ),
          // Histogram bar chart
          if (histogram != null && histogram.isNotEmpty) ...[
            const SizedBox(height: 12),
            SurveyChartSwitcher(
              title: l10n.participantChartDistribution,
              defaultType: SurveyChartType.bar,
              data: {
                for (final bucket in histogram)
                  (bucket['label'] as String? ?? ''):
                      (bucket['count'] as num?)?.toDouble() ?? 0,
              },
              height: 220,
            ),
          ],
        ],
      ),
    );
  }
}

/// Pie chart for yes/no responses.
class _YesNoChart extends StatelessWidget {
  const _YesNoChart({required this.question, required this.l10n});
  final ChartQuestionData question;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    final agg = question.aggregate ?? {};
    final yesCount = (agg['yes_count'] as num?)?.toDouble() ?? 0;
    final noCount = (agg['no_count'] as num?)?.toDouble() ?? 0;

    final data = <String, double>{};
    if (yesCount > 0) data[l10n.participantChartYes] = yesCount;
    if (noCount > 0) data[l10n.participantChartNo] = noCount;

    if (data.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.responseValue != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppYourAnswerRow(
                label: l10n.participantChartYourAnswer,
                value: question.responseValue!,
              ),
            ),
          SurveyChartSwitcher(
            title: l10n.participantChartDistribution,
            defaultType: SurveyChartType.pie,
            data: data,
            colors: const [AppTheme.success, AppTheme.error],
            height: 220,
          ),
        ],
      ),
    );
  }
}

/// Pie chart for single/multi-choice responses.
class _ChoiceChart extends StatelessWidget {
  const _ChoiceChart({required this.question, required this.l10n});
  final ChartQuestionData question;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    final agg = question.aggregate ?? {};
    final options = agg['options'] as List<dynamic>?;

    if (options == null || options.isEmpty) return const SizedBox.shrink();

    final data = <String, double>{
      for (final opt in options)
        (opt['option'] as String? ?? ''):
            (opt['count'] as num?)?.toDouble() ?? 0,
    };

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.responseValue != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppYourAnswerRow(
                label: l10n.participantChartYourAnswer,
                value: question.responseValue!,
              ),
            ),
          SurveyChartSwitcher(
            title: l10n.participantChartDistribution,
            defaultType: SurveyChartType.pie,
            data: data,
            height: 260,
          ),
        ],
      ),
    );
  }
}
