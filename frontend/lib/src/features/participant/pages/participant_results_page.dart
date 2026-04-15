// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/pages/participant_results_page.dart
/// Personal data view page — displays the participant's completed surveys
/// with expandable sections showing each question and the participant's answer.
///
/// Groups questions by category when available.
/// When chart mode is enabled, fetches chart-ready data from
/// GET /participants/surveys/{id}/chart-data and renders appropriate
/// visualizations per response type.  Aggregate data is suppressed
/// when fewer than K=5 respondents exist (k-anonymity).
///
/// Uses [ParticipantScaffold] wrapper and [participantSurveyDataProvider].
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/features/participant/state/participant_providers.dart';
import 'package:frontend/src/features/participant/widgets/participant_chart_section.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:go_router/go_router.dart';

/// Maps raw DB category key → localized display name.
String _localizedCategory(BuildContext context, String category) {
  final l10n = context.l10n;
  return switch (category.toLowerCase()) {
    'mental_health' => l10n.questionCategoryMentalHealth,
    'physical_health' => l10n.questionCategoryPhysicalHealth,
    'lifestyle' => l10n.questionCategoryLifestyle,
    'nutrition' => l10n.questionCategoryNutrition,
    'general' => l10n.questionCategoryGeneral,
    'other' => l10n.questionCategoryOther,
    _ => category, // Unknown category — show as-is
  };
}

/// Maps raw DB response_type key → localized display label.
String _localizedType(BuildContext context, String type) {
  final l10n = context.l10n;
  return switch (type.toLowerCase()) {
    'scale' => l10n.questionTypeScale,
    'number' => l10n.questionTypeNumber,
    'single_choice' => l10n.questionTypeSingleChoice,
    'multi_choice' => l10n.questionTypeMultiChoice,
    'yesno' => l10n.questionTypeYesNo,
    'openended' => l10n.questionTypeOpenEnded,
    'text' => l10n.questionTypeText,
    _ => type,
  };
}

class ParticipantResultsPage extends ConsumerWidget {
  const ParticipantResultsPage({
    super.key, 
    this.highlightedSurveyId
  });

  final int? highlightedSurveyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dataAsync = ref.watch(participantSurveyDataProvider);

    return ParticipantScaffold(
      currentRoute: '/participant/results',
      scrollable: true,
      showFooter: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.participantResultsTitle,
              style: AppTheme.heading3.copyWith(color: context.appColors.textPrimary),
            ),
          ),
          const SizedBox(height: 20),
          dataAsync.when(
            data: (surveys) => surveys.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        l10n.participantNoResults,
                        style: AppTheme.body
                            .copyWith(color: context.appColors.textMuted),
                      ),
                    ),
                  )
                : _SurveyList(
                      surveys: surveys,
                      highlightedSurveyId: highlightedSurveyId,
                    ),
            loading: () => Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLoadingIndicator(centered: false),
                    const SizedBox(height: 12),
                    Text(l10n.participantLoadingResults,
                        style: AppTheme.body
                            .copyWith(color: context.appColors.textMuted)),
                  ],
                ),
              ),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ExcludeSemantics(
                      child: Icon(Icons.error_outline, color: AppTheme.error, size: 48),
                    ),
                    const SizedBox(height: 12),
                    Text(l10n.participantResultsError,
                        style: AppTheme.body
                            .copyWith(color: context.appColors.textMuted)),
                    const SizedBox(height: 16),
                    AppOutlinedButton(
                      label: l10n.participantRetry,
                      onPressed: () =>
                          ref.invalidate(participantSurveyDataProvider),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Scrollable list of completed surveys with expandable detail sections.
class _SurveyList extends StatelessWidget {
  const _SurveyList({
    required this.surveys,
    this.highlightedSurveyId,
  });

  final List<ParticipantSurveyWithResponses> surveys;
  final int? highlightedSurveyId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final sortedSurveys = [...surveys]
      ..sort((a, b) {
        final aDate = a.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedSurveys.length,
      itemBuilder: (context, index) {
        final survey = sortedSurveys[index];
        return _SurveyCard(
          survey: survey,
          l10n: l10n,
          initiallyExpanded: survey.surveyId == highlightedSurveyId,
          clearSurveyParamOnCollapse: survey.surveyId == highlightedSurveyId,
        );
      },
    );
  }
}

/// Expandable card for a single completed survey.
class _SurveyCard extends ConsumerStatefulWidget {
  const _SurveyCard({
    required this.survey, 
    required this.l10n,
    this.initiallyExpanded = false,
    this.clearSurveyParamOnCollapse = false,
  });

  final ParticipantSurveyWithResponses survey;
  final dynamic l10n;
  final bool initiallyExpanded;
    final bool clearSurveyParamOnCollapse;

  @override
  ConsumerState<_SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends ConsumerState<_SurveyCard> {
  bool _showCharts = false;
  bool _showComparison = false;

  @override
  Widget build(BuildContext context) {
    final survey = widget.survey;
    final l10n = widget.l10n;
    final completedDate = survey.completedAt;
    final subtitle = completedDate != null
        ? '${l10n.participantSurveyCompleted}: ${completedDate.toLocal().toString().split(' ').first}'
        : l10n.participantQuestionCount(survey.questions.length);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        onExpansionChanged: (expanded) {
          if (!expanded && widget.clearSurveyParamOnCollapse) {
            context.replace('/participant/results');
          }
        },
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        leading: const ExcludeSemantics(
          child: Icon(Icons.assignment_outlined, color: AppTheme.primary, size: 28),
        ),
        title: Text(survey.title,
            style: AppTheme.body
                .copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: AppTheme.captions.copyWith(color: context.appColors.textMuted)),
        children: [
          // Toggle row: Charts | Compare to aggregate
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                // Chart toggle
                Semantics(
                  label: '${l10n.participantChartToggle}: ${_showCharts ? l10n.commonOn : l10n.commonOff}',
                  excludeSemantics: false,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          _showCharts ? Icons.bar_chart : Icons.list,
                          size: 18,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      ExcludeSemantics(
                        child: Text(
                          l10n.participantChartToggle,
                          style: AppTheme.captions.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 28,
                        width: 48,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Switch.adaptive(
                            value: _showCharts,
                            activeTrackColor: AppTheme.primary,
                            onChanged: (value) =>
                                setState(() {
                                  _showCharts = value;
                                  // Charts need aggregate data to be meaningful —
                                  // auto-enable comparison when enabling charts.
                                  if (value) _showComparison = true;
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Comparison toggle
                Semantics(
                  label: '${l10n.participantCompareToggle}: ${_showComparison ? l10n.commonOn : l10n.commonOff}',
                  excludeSemantics: false,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ExcludeSemantics(
                        child: Icon(Icons.compare_arrows, size: 18, color: AppTheme.info),
                      ),
                      const SizedBox(width: 6),
                      ExcludeSemantics(
                        child: Text(
                          l10n.participantCompareToggle,
                          style: AppTheme.captions.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 28,
                        width: 48,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Switch.adaptive(
                            value: _showComparison,
                            activeTrackColor: AppTheme.info,
                            onChanged: (value) =>
                                setState(() {
                                  _showComparison = value;
                                  // Charts need aggregate data — disable them
                                  // if comparison is turned off.
                                  if (!value) _showCharts = false;
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!_showCharts && !_showComparison)
            _buildQuestionsList(context)
          else ...[
            if (_showCharts)
              _ChartView(surveyId: survey.surveyId, l10n: l10n),
            if (_showComparison)
              _ComparisonView(surveyId: survey.surveyId, l10n: l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionsList(BuildContext context) {
    final questions = widget.survey.questions;
    final l10n = widget.l10n;
    if (questions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.participantNoResults,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted)),
      );
    }

    // Group by category
    final grouped = <String, List<ParticipantQuestionResponse>>{};
    for (final q in questions) {
      final cat = q.category ?? '';
      grouped.putIfAbsent(cat, () => []).add(q);
    }

    final entries = grouped.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          if (entries[i].key.isNotEmpty) ...[
            if (i > 0) const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const ExcludeSemantics(child: Icon(Icons.category_outlined,
                      size: 16, color: AppTheme.secondary)),
                  const SizedBox(width: 6),
                  Text(
                    _localizedCategory(context, entries[i].key),
                    style: AppTheme.captions.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          ...entries[i].value.map((q) => _QuestionResponseRow(question: q)),
        ],
      ],
    );
  }
}

/// Chart view that loads chart data from the API for a specific survey.
class _ChartView extends ConsumerWidget {
  const _ChartView({required this.surveyId, required this.l10n});

  final int surveyId;
  final dynamic l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartAsync = ref.watch(participantChartDataProvider(surveyId));

    return chartAsync.when(
      data: (chartData) {
        if (chartData.questions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.participantChartNoData,
                style: AppTheme.body.copyWith(color: context.appColors.textMuted)),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final question in chartData.questions) ...[
              // Question header
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        question.questionContent,
                        style: AppTheme.body.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _typeColor(context, question.responseType)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _localizedType(context, question.responseType),
                        style: AppTheme.captions.copyWith(
                          fontSize: 11,
                          color: _typeColor(context, question.responseType),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Chart widget
              ParticipantQuestionChart(question: question),
              const Divider(height: 24),
            ],
          ],
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLoadingIndicator(centered: false),
              const SizedBox(height: 8),
              Text(l10n.participantChartLoading,
                  style: AppTheme.captions.copyWith(color: context.appColors.textMuted)),
            ],
          ),
        ),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ExcludeSemantics(child: Icon(Icons.error_outline, color: AppTheme.error, size: 32)),
            const SizedBox(height: 8),
            Text(l10n.participantChartError,
                style: AppTheme.body.copyWith(color: context.appColors.textMuted)),
            const SizedBox(height: 8),
            AppOutlinedButton(
              label: l10n.participantRetry,
              onPressed: () =>
                  ref.invalidate(participantChartDataProvider(surveyId)),
            ),
          ],
        ),
      ),
    );
  }

  Color _typeColor(BuildContext context, String type) {
    return switch (type) {
      'number' || 'scale' => AppTheme.primary,
      'yesno' => AppTheme.success,
      'single_choice' || 'multi_choice' => AppTheme.info,
      'openended' => AppTheme.secondary,
      _ => context.appColors.textMuted,
    };
  }
}

/// Comparison view showing participant answers alongside aggregate stats.
class _ComparisonView extends ConsumerWidget {
  const _ComparisonView({required this.surveyId, required this.l10n});

  final int surveyId;
  final dynamic l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareAsync = ref.watch(participantCompareProvider(surveyId));

    return compareAsync.when(
      data: (data) {
        final aggregates = data.aggregates['aggregates'] as List<dynamic>?;
        if (aggregates == null || aggregates.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.participantCompareNoData,
                style: AppTheme.body.copyWith(color: context.appColors.textMuted)),
          );
        }

        // Map participant answers by question ID for quick lookup
        final answerMap = <int, String?>{};
        for (final a in data.participantAnswers) {
          answerMap[a.questionId] = a.responseValue;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final agg in aggregates) ...() {
              final qId = agg['question_id'] as int;
              final content = agg['question_content'] as String? ?? '';
              final type = agg['response_type'] as String? ?? '';
              final suppressed = agg['suppressed'] == true;
              final myAnswer = answerMap[qId];
              final aggData = agg['data'] as Map<String, dynamic>?;

              return [
                _ComparisonRow(
                  questionContent: content,
                  responseType: type,
                  myAnswer: myAnswer,
                  suppressed: suppressed,
                  aggregateData: aggData,
                  l10n: l10n,
                ),
              ];
            }(),
          ],
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLoadingIndicator(centered: false),
              const SizedBox(height: 8),
              Text(l10n.participantCompareLoading,
                  style:
                      AppTheme.captions.copyWith(color: context.appColors.textMuted)),
            ],
          ),
        ),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ExcludeSemantics(child: Icon(Icons.error_outline, color: AppTheme.error, size: 32)),
            const SizedBox(height: 8),
            Text(l10n.participantCompareError,
                style: AppTheme.body.copyWith(color: context.appColors.textMuted)),
            const SizedBox(height: 8),
            AppOutlinedButton(
              label: l10n.participantRetry,
              onPressed: () =>
                  ref.invalidate(participantCompareProvider(surveyId)),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single comparison row: question, participant's answer, and aggregate summary.
class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.questionContent,
    required this.responseType,
    required this.myAnswer,
    required this.suppressed,
    required this.aggregateData,
    required this.l10n,
  });

  final String questionContent;
  final String responseType;
  final String? myAnswer;
  final bool suppressed;
  final Map<String, dynamic>? aggregateData;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.appColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: context.appColors.textMuted.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header with type badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    questionContent,
                    style:
                        AppTheme.body.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        _typeColor(context, responseType).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _localizedType(context, responseType),
                    style: AppTheme.captions.copyWith(
                      fontSize: 11,
                      color: _typeColor(context, responseType),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Participant's answer
            Row(
              children: [
                const ExcludeSemantics(child: Icon(Icons.person, size: 16, color: AppTheme.primary)),
                const SizedBox(width: 6),
                Text(
                  '${l10n.participantChartYourAnswer}: ',
                  style: AppTheme.captions
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Text(
                    myAnswer ?? '—',
                    style: AppTheme.body.copyWith(
                      color: myAnswer != null
                          ? context.appColors.textPrimary
                          : context.appColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Aggregate summary
            if (suppressed)
              Row(
                children: [
                  const ExcludeSemantics(child: Icon(Icons.shield_outlined,
                      size: 16, color: AppTheme.caution)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.participantChartSuppressed,
                      style: AppTheme.captions
                          .copyWith(color: context.appColors.textMuted),
                    ),
                  ),
                ],
              )
            else if (aggregateData != null)
              _buildAggregateSummary(context)
            else
              Row(
                children: [
                  ExcludeSemantics(child: Icon(Icons.bar_chart,
                      size: 16, color: context.appColors.textMuted)),
                  const SizedBox(width: 6),
                  Text(
                    l10n.participantCompareNoData,
                    style: AppTheme.captions
                        .copyWith(color: context.appColors.textMuted),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAggregateSummary(BuildContext context) {
    final data = aggregateData ?? {};

    return switch (responseType) {
      'number' || 'scale' => _numericSummary(context, data),
      'yesno' => _yesNoSummary(data),
      'single_choice' || 'multi_choice' => _choiceSummary(data),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _numericSummary(BuildContext context, Map<String, dynamic> data) {
    final mean = data['mean'];
    final median = data['median'];

    return Row(
      children: [
        const ExcludeSemantics(child: Icon(Icons.people_outline, size: 16, color: AppTheme.info)),
        const SizedBox(width: 6),
        Text(
          '${l10n.participantCompareAggregate}: ',
          style: AppTheme.captions.copyWith(fontWeight: FontWeight.w600),
        ),
        if (mean != null)
          Text(
            '${l10n.participantChartMean}: ${(mean as num).toStringAsFixed(1)}',
            style: AppTheme.captions,
          ),
        if (mean != null && median != null)
          Text('  •  ', style: TextStyle(color: context.appColors.textMuted)),
        if (median != null)
          Text(
            '${l10n.participantChartMedian}: ${(median as num).toStringAsFixed(1)}',
            style: AppTheme.captions,
          ),
      ],
    );
  }

  Widget _yesNoSummary(Map<String, dynamic> data) {
    final yes = (data['yes_count'] as num?)?.toInt() ?? 0;
    final no = (data['no_count'] as num?)?.toInt() ?? 0;
    final total = yes + no;
    final yesPct = total > 0 ? (yes * 100 / total).round() : 0;

    return Row(
      children: [
        const ExcludeSemantics(child: Icon(Icons.people_outline, size: 16, color: AppTheme.info)),
        const SizedBox(width: 6),
        Text(
          '${l10n.participantCompareAggregate}: ',
          style: AppTheme.captions.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          '${l10n.participantChartYes}: $yesPct%  •  ${l10n.participantChartNo}: ${100 - yesPct}%',
          style: AppTheme.captions,
        ),
      ],
    );
  }

  Widget _choiceSummary(Map<String, dynamic> data) {
    final options = data['options'] as List<dynamic>?;
    if (options == null || options.isEmpty) return const SizedBox.shrink();

    // Find the most popular option
    var topOption = '';
    var topCount = 0;
    for (final opt in options) {
      final count = (opt['count'] as num?)?.toInt() ?? 0;
      if (count > topCount) {
        topCount = count;
        topOption = opt['option'] as String? ?? '';
      }
    }

    return Row(
      children: [
        const ExcludeSemantics(child: Icon(Icons.people_outline, size: 16, color: AppTheme.info)),
        const SizedBox(width: 6),
        Text(
          '${l10n.participantCompareAggregate}: ',
          style: AppTheme.captions.copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            '${l10n.participantCompareMostCommon}: $topOption',
            style: AppTheme.captions,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _typeColor(BuildContext context, String type) {
    return switch (type) {
      'number' || 'scale' => AppTheme.primary,
      'yesno' => AppTheme.success,
      'single_choice' || 'multi_choice' => AppTheme.info,
      'openended' => AppTheme.secondary,
      _ => context.appColors.textMuted,
    };
  }
}

/// Displays a single question and the participant's answer.
class _QuestionResponseRow extends StatelessWidget {
  const _QuestionResponseRow({required this.question});

  final ParticipantQuestionResponse question;

  @override
  Widget build(BuildContext context) {
    final hasAnswer =
        question.responseValue != null && question.responseValue!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.appColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: context.appColors.textMuted.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question.questionContent,
                    style: AppTheme.body.copyWith(
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _typeColor(context, question.responseType)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    question.responseType,
                    style: AppTheme.captions.copyWith(
                      fontSize: 11,
                      color: _typeColor(context, question.responseType),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  hasAnswer ? Icons.check_circle_outline : Icons.remove_circle_outline,
                  size: 16,
                  color: hasAnswer ? AppTheme.success : context.appColors.textMuted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    hasAnswer ? question.responseValue! : '—',
                    style: AppTheme.body.copyWith(
                      color: hasAnswer
                          ? context.appColors.textPrimary
                          : context.appColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _typeColor(BuildContext context, String type) {
    return switch (type) {
      'number' || 'scale' => AppTheme.primary,
      'yesno' => AppTheme.success,
      'single_choice' || 'multi_choice' => AppTheme.info,
      'openended' => AppTheme.secondary,
      _ => context.appColors.textMuted,
    };
  }
}
