// Created with the Assistance of Claude Code
// frontend/lib/src/features/hcp_clients/pages/hcp_reports_page.dart
/// HCP Reports page — two tabs: Surveys and Health Tracking.
///
/// Surveys tab: select patient → select survey → view responses.
/// Health Tracking tab: select patient → pick metrics + date range →
///   view per-metric charts in "Patient Only" or "Comparison" mode.
library;

import '../../../features/researcher/pages/csv_download_stub.dart'
    if (dart.library.js_interop) '../../../features/researcher/pages/csv_download_web.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_line_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/data_display/tracking_controls_bar.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/features/hcp_clients/state/hcp_providers.dart';
import '../widgets/hcp_scaffold.dart';
import 'package:intl/intl.dart';

class HcpReportsPage extends ConsumerStatefulWidget {
  const HcpReportsPage({super.key});

  @override
  ConsumerState<HcpReportsPage> createState() => _HcpReportsPageState();
}

class _HcpReportsPageState extends ConsumerState<HcpReportsPage> {
  // ── Shared patient selection ───────────────────────────────────────────────
  int? _selectedPatientId;
  String? _selectedPatientName;

  // ── Main tab ───────────────────────────────────────────────────────────────
  _ReportsTab _tab = _ReportsTab.surveys;

  // ── Surveys tab state ──────────────────────────────────────────────────────
  int? _selectedSurveyId;
  String? _selectedSurveyTitle;

  // ── Patient selector (shared across both tabs) ────────────────────────────

  Widget _buildPatientDropdown(
    AppLocalizations l10n,
    List<Map<String, dynamic>> patients,
  ) {
    return DropdownButtonFormField<int>(
      initialValue: _selectedPatientId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.hcpReportsSelectPatient,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.person_outline),
      ),
      items: patients.map((p) {
        final id = (p['patient_id'] as num).toInt();
        final name = p['patient_name'] as String? ?? 'Patient #$id';
        return DropdownMenuItem<int>(value: id, child: Text(name));
      }).toList(),
      onChanged: (value) {
        final selected = patients.firstWhere(
          (p) => (p['patient_id'] as num).toInt() == value,
          orElse: () => {},
        );
        setState(() {
          _selectedPatientId = value;
          _selectedPatientName =
              selected['patient_name'] as String? ?? 'Patient #$value';
          // Reset surveys tab
          _selectedSurveyId = null;
          _selectedSurveyTitle = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final patientsAsync = ref.watch(hcpPatientsProvider);

    return HcpScaffold(
      currentRoute: '/hcp/reports',
      scrollable: false,
      showFooter: false,
      maxWidth: 1100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: AppText(
                l10n.hcpReportsTitle,
                variant: AppTextVariant.headlineMedium,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Patient picker
            patientsAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (_, __) => AppText(
                l10n.hcpReportsError,
                variant: AppTextVariant.bodyMedium,
                color: AppTheme.error,
              ),
              data: (patients) {
                if (patients.isEmpty) {
                  return AppText(
                    l10n.hcpReportsNoPatients,
                    variant: AppTextVariant.bodyMedium,
                    color: context.appColors.textMuted,
                  );
                }
                return _buildPatientDropdown(l10n, patients);
              },
            ),
            const SizedBox(height: 16),
            // Tab switcher (SegmentedButton style matching participant health tracking)
            Semantics(
              label: l10n.hcpReportsTabSurveys,
              child: AppOverflowSafeArea(
                child: SegmentedButton<_ReportsTab>(
                  segments: [
                    ButtonSegment(
                      value: _ReportsTab.surveys,
                      label: Text(l10n.hcpReportsTabSurveys),
                      icon: const Icon(Icons.assignment_outlined, size: 16),
                    ),
                    ButtonSegment(
                      value: _ReportsTab.healthTracking,
                      label: Text(l10n.hcpReportsTabHealthTracking),
                      icon: const Icon(Icons.monitor_heart_outlined, size: 16),
                    ),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (s) => setState(() => _tab = s.first),
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(AppTheme.captions),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tab content
            Expanded(
              child: _tab == _ReportsTab.surveys
                  ? _SurveysTab(
                      patientId: _selectedPatientId,
                      patientName: _selectedPatientName,
                      selectedSurveyId: _selectedSurveyId,
                      selectedSurveyTitle: _selectedSurveyTitle,
                      onSurveySelected: (id, title) => setState(() {
                        _selectedSurveyId = id;
                        _selectedSurveyTitle = title;
                      }),
                    )
                  : patientsAsync.maybeWhen(
                      data: (patients) =>
                          _HealthTrackingTab(patients: patients),
                      orElse: () => const _HealthTrackingTab(patients: []),
                    ),
            ),
          ],
      ),
    );
  }
}

// ── Enums ─────────────────────────────────────────────────────────────────────

enum _ReportsTab { surveys, healthTracking }

enum TrackingResultViewMode { patient, comparison }

enum _SurveyView { table, chart }

enum _ChartType { line, bar, pie }

// Health tracking tab enums replaced by shared TrackingHistoryMode,
// TrackingResultView, and TrackingDisplayGranularity from tracking_controls_bar.dart

// =============================================================================
// Surveys tab
// =============================================================================

class _SurveysTab extends ConsumerStatefulWidget {
  const _SurveysTab({
    required this.patientId,
    required this.patientName,
    required this.selectedSurveyId,
    required this.selectedSurveyTitle,
    required this.onSurveySelected,
  });

  final int? patientId;
  final String? patientName;
  final int? selectedSurveyId;
  final String? selectedSurveyTitle;
  final void Function(int id, String title) onSurveySelected;

  @override
  ConsumerState<_SurveysTab> createState() => _SurveysTabState();
}

class _SurveysTabState extends ConsumerState<_SurveysTab> {
  _SurveyView _view = _SurveyView.table;
  TrackingResultViewMode _chartMode = TrackingResultViewMode.patient;

  @override
  void didUpdateWidget(_SurveysTab old) {
    super.didUpdateWidget(old);
    // Reset view when survey changes
    if (old.selectedSurveyId != widget.selectedSurveyId) {
      _view = _SurveyView.table;
      _chartMode = TrackingResultViewMode.patient;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (widget.patientId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: AppText(
            l10n.hcpReportsNoSelection,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textMuted,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SurveyPicker(
            patientId: widget.patientId!,
            selectedSurveyId: widget.selectedSurveyId,
            onSurveySelected: widget.onSurveySelected,
          ),
          if (widget.selectedSurveyId != null) ...[
            const SizedBox(height: 16),
            // View mode toggle: Responses | Charts
            Semantics(
              label: l10n.hcpSurveyViewModeLabel,
              child: SegmentedButton<_SurveyView>(
                segments: [
                  ButtonSegment(
                    value: _SurveyView.table,
                    label: Text(l10n.hcpSurveyViewTable),
                    icon: const Icon(Icons.table_rows_outlined, size: 16),
                  ),
                  ButtonSegment(
                    value: _SurveyView.chart,
                    label: Text(l10n.hcpSurveyViewChart),
                    icon: const Icon(Icons.bar_chart_outlined, size: 16),
                  ),
                ],
                selected: {_view},
                onSelectionChanged: (s) => setState(() => _view = s.first),
                style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(AppTheme.captions),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ResponsesSection(
              patientId: widget.patientId!,
              surveyId: widget.selectedSurveyId!,
              surveyTitle: widget.selectedSurveyTitle,
              view: _view,
              chartMode: _chartMode,
              onChartMode: (m) => setState(() => _chartMode = m),
            ),
          ],
        ],
      ),
    );
  }
}

class _SurveyPicker extends ConsumerWidget {
  const _SurveyPicker({
    required this.patientId,
    required this.selectedSurveyId,
    required this.onSurveySelected,
  });

  final int patientId;
  final int? selectedSurveyId;
  final void Function(int id, String title) onSurveySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surveysAsync = ref.watch(hcpPatientSurveysProvider(patientId));

    return surveysAsync.when(
      loading: () => const AppLoadingIndicator(),
      error: (_, __) => AppText(
        l10n.hcpReportsError,
        variant: AppTextVariant.bodyMedium,
        color: AppTheme.error,
      ),
      data: (surveys) {
        if (surveys.isEmpty) {
          return AppText(
            l10n.hcpReportsNoSurveys,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textMuted,
          );
        }
        return DropdownButtonFormField<int>(
          initialValue: selectedSurveyId,
          decoration: InputDecoration(
            labelText: l10n.hcpReportsSelectSurvey,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.assignment_outlined),
          ),
          items: surveys.map((s) {
            final id = (s['survey_id'] as num).toInt();
            final title =
                s['title'] as String? ??
                s['survey_title'] as String? ??
                'Survey #$id';
            return DropdownMenuItem<int>(value: id, child: Text(title));
          }).toList(),
          onChanged: (value) {
            if (value == null) return;
            final s = surveys.firstWhere(
              (s) => (s['survey_id'] as num).toInt() == value,
              orElse: () => {},
            );
            final title =
                s['title'] as String? ??
                s['survey_title'] as String? ??
                'Survey #$value';
            onSurveySelected(value, title);
          },
        );
      },
    );
  }
}

class _ResponsesSection extends ConsumerWidget {
  const _ResponsesSection({
    required this.patientId,
    required this.surveyId,
    required this.surveyTitle,
    required this.view,
    required this.chartMode,
    required this.onChartMode,
  });

  final int patientId;
  final int surveyId;
  final String? surveyTitle;
  final _SurveyView view;
  final TrackingResultViewMode chartMode;
  final void Function(TrackingResultViewMode) onChartMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final params = (patientId: patientId, surveyId: surveyId);
    final responsesAsync = ref.watch(hcpPatientResponsesProvider(params));

    return responsesAsync.when(
      loading: () => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLoadingIndicator(centered: false),
            const SizedBox(height: 12),
            AppText(
              l10n.hcpReportsLoading,
              variant: AppTextVariant.bodyMedium,
              color: context.appColors.textMuted,
            ),
          ],
        ),
      ),
      error: (_, __) => AppText(
        l10n.hcpReportsError,
        variant: AppTextVariant.bodyMedium,
        color: AppTheme.error,
      ),
      data: (responses) {
        if (responses.isEmpty) {
          return AppText(
            l10n.hcpPatientNoSurveys,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textMuted,
          );
        }

        if (view == _SurveyView.chart) {
          return _SurveyChartSection(
            patientId: patientId,
            surveyId: surveyId,
            surveyTitle: surveyTitle,
            responses: responses,
            chartMode: chartMode,
            onChartMode: onChartMode,
          );
        }

        // Table view
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (surveyTitle != null)
              AppText(
                surveyTitle!,
                variant: AppTextVariant.bodyLarge,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            const SizedBox(height: 12),
            ...responses.map((r) => _ResponseRow(response: r)),
          ],
        );
      },
    );
  }
}

class _ResponseRow extends StatelessWidget {
  const _ResponseRow({required this.response});

  final Map<String, dynamic> response;

  @override
  Widget build(BuildContext context) {
    final question = response['question_content'] as String? ?? '';
    final type = response['response_type'] as String? ?? '';
    final value = response['response_value'] as String? ?? '—';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.appColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.appColors.textMuted.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: AppTheme.body.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _typeColor(context, type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    type,
                    style: AppTheme.captions.copyWith(
                      fontSize: 11,
                      color: _typeColor(context, type),
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
                  value == '—'
                      ? Icons.remove_circle_outline
                      : Icons.check_circle_outline,
                  size: 16,
                  color: value == '—'
                      ? context.appColors.textMuted
                      : AppTheme.success,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    style: AppTheme.body.copyWith(
                      color: value == '—'
                          ? context.appColors.textMuted
                          : context.appColors.textPrimary,
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

// =============================================================================
// Survey chart section
// =============================================================================

/// Shows a per-question bar comparison for numeric/scale questions in a survey.
class _SurveyChartSection extends ConsumerWidget {
  const _SurveyChartSection({
    required this.patientId,
    required this.surveyId,
    required this.surveyTitle,
    required this.responses,
    required this.chartMode,
    required this.onChartMode,
  });

  final int patientId;
  final int surveyId;
  final String? surveyTitle;
  final List<Map<String, dynamic>> responses;
  final TrackingResultViewMode chartMode;
  final void Function(TrackingResultViewMode) onChartMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    // Filter to numeric/scale questions with parseable values
    final numericResponses = responses.where((r) {
      final type = r['response_type'] as String? ?? '';
      final val = r['response_value'] as String? ?? '';
      return (type == 'number' || type == 'scale') &&
          double.tryParse(val) != null;
    }).toList();

    if (numericResponses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: AppText(
          l10n.hcpSurveyChartNoNumeric,
          variant: AppTextVariant.bodyMedium,
          color: context.appColors.textMuted,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (surveyTitle != null)
          AppText(
            l10n.hcpSurveyChartTitle(surveyTitle!),
            variant: AppTextVariant.bodyLarge,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
        const SizedBox(height: 12),

        // Comparison mode toggle
        Semantics(
          label: l10n.hcpSurveyChartComparisonModeLabel,
          child: SegmentedButton<TrackingResultViewMode>(
            segments: [
              ButtonSegment(
                value: TrackingResultViewMode.patient,
                label: Text(l10n.hcpSurveyChartPatientOnly),
                icon: const Icon(Icons.person_outline, size: 16),
              ),
              ButtonSegment(
                value: TrackingResultViewMode.comparison,
                label: Text(l10n.hcpSurveyChartComparison),
                icon: const Icon(Icons.group_outlined, size: 16),
              ),
            ],
            selected: {chartMode},
            onSelectionChanged: (s) => onChartMode(s.first),
            style: ButtonStyle(
              textStyle: WidgetStatePropertyAll(AppTheme.captions),
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (chartMode == TrackingResultViewMode.comparison)
          _SurveyComparisonBars(
            patientId: patientId,
            surveyId: surveyId,
            numericResponses: numericResponses,
          )
        else
          _SurveyPatientBars(numericResponses: numericResponses),
      ],
    );
  }
}

/// Patient-only bar view — one bar per numeric/scale question.
class _SurveyPatientBars extends StatelessWidget {
  const _SurveyPatientBars({required this.numericResponses});

  final List<Map<String, dynamic>> numericResponses;

  @override
  Widget build(BuildContext context) {
    // Determine max for relative bar scaling
    final values = numericResponses
        .map((r) => double.parse(r['response_value'] as String))
        .toList();
    final maxVal = values.isEmpty
        ? 10.0
        : values.reduce((a, b) => a > b ? a : b).clamp(1.0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < numericResponses.length; i++) ...[
          _QuestionBarRow(
            question: numericResponses[i]['question_content'] as String? ?? '',
            value: values[i],
            maxVal: maxVal,
            color: AppTheme.primary,
          ),
          if (i < numericResponses.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

/// Comparison bar view — patient value vs population average per question.
class _SurveyComparisonBars extends ConsumerWidget {
  const _SurveyComparisonBars({
    required this.patientId,
    required this.surveyId,
    required this.numericResponses,
  });

  final int patientId;
  final int surveyId;
  final List<Map<String, dynamic>> numericResponses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final aggParams = (patientId: patientId, surveyId: surveyId);
    final aggAsync = ref.watch(hcpSurveyQuestionAggregateProvider(aggParams));

    // Build patient lookup by question_id
    final patientByQid = <int, double>{};
    for (final r in numericResponses) {
      final qid = r['question_id'];
      if (qid != null) {
        patientByQid[(qid as num).toInt()] = double.parse(
          r['response_value'] as String,
        );
      }
    }

    // Determine baseline max for fallback (used in patient-only fallback)
    final patientValues = patientByQid.values.toList();

    return aggAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (_, __) => _SurveyPatientBars(numericResponses: numericResponses),
      data: (aggRows) {
        // Build agg lookup by question_id
        final aggByQid = <int, double>{};
        for (final row in aggRows) {
          final qid = row['question_id'];
          final avg = row['avg_value'];
          if (qid != null && avg != null) {
            aggByQid[(qid as num).toInt()] = (avg as num).toDouble();
          }
        }

        // Compute max including aggregate values
        final allValues = [...patientValues, ...aggByQid.values];
        final combinedMax = allValues.isEmpty
            ? 10.0
            : allValues
                  .reduce((a, b) => a > b ? a : b)
                  .clamp(1.0, double.infinity);

        final hasAgg = aggByQid.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasAgg) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.hcpSurveyChartAggUnavailable,
                  style: AppTheme.captions.copyWith(
                    color: context.appColors.textMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            // Legend
            Row(
              children: [
                const _LegendDot(color: AppTheme.primary),
                const SizedBox(width: 4),
                Text(l10n.hcpSurveyChartPatient, style: AppTheme.captions),
                if (hasAgg) ...[
                  const SizedBox(width: 16),
                  const _LegendDot(color: AppTheme.secondary),
                  const SizedBox(width: 4),
                  Text(l10n.hcpSurveyChartAggregate, style: AppTheme.captions),
                ],
              ],
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < numericResponses.length; i++) ...[
              _buildQuestionPair(
                context,
                l10n,
                numericResponses[i],
                patientByQid,
                aggByQid,
                combinedMax,
              ),
              if (i < numericResponses.length - 1) const SizedBox(height: 14),
            ],
          ],
        );
      },
    );
  }

  Widget _buildQuestionPair(
    BuildContext context,
    AppLocalizations l10n,
    Map<String, dynamic> response,
    Map<int, double> patientByQid,
    Map<int, double> aggByQid,
    double maxVal,
  ) {
    final question = response['question_content'] as String? ?? '';
    final qid = response['question_id'];
    final qidInt = qid != null ? (qid as num).toInt() : null;
    final patientVal = qidInt != null
        ? patientByQid[qidInt]
        : double.tryParse(response['response_value'] as String? ?? '');
    final aggVal = qidInt != null ? aggByQid[qidInt] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.captions.copyWith(
            fontWeight: FontWeight.w600,
            color: context.appColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        if (patientVal != null)
          _QuestionBarRow(
            question: l10n.hcpSurveyChartPatient,
            value: patientVal,
            maxVal: maxVal,
            color: AppTheme.primary,
            showLabel: true,
          ),
        if (aggVal != null) ...[
          const SizedBox(height: 4),
          _QuestionBarRow(
            question: l10n.hcpSurveyChartAggregate,
            value: aggVal,
            maxVal: maxVal,
            color: AppTheme.secondary,
            showLabel: true,
          ),
        ],
      ],
    );
  }
}

/// A single horizontal bar row showing a label, bar, and value.
class _QuestionBarRow extends StatelessWidget {
  const _QuestionBarRow({
    required this.question,
    required this.value,
    required this.maxVal,
    required this.color,
    this.showLabel = false,
  });

  final String question;
  final double value;
  final double maxVal;
  final Color color;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final fraction = (value / maxVal).clamp(0.0, 1.0);
    final valStr = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);

    return Semantics(
      label: '$question: $valStr',
      child: ExcludeSemantics(
        child: Row(
          children: [
            if (showLabel)
              SizedBox(
                width: 90,
                child: Text(
                  question,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.captions.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              )
            else
              Expanded(
                child: Text(
                  question,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.captions.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ),
            if (showLabel) ...[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 10,
                    backgroundColor: color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 32,
                child: Text(
                  valStr,
                  textAlign: TextAlign.end,
                  style: AppTheme.captions.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 10,
                    backgroundColor: color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 32,
                child: Text(
                  valStr,
                  textAlign: TextAlign.end,
                  style: AppTheme.captions.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// =============================================================================
// Health Tracking tab
// =============================================================================

class _HealthTrackingTab extends ConsumerStatefulWidget {
  const _HealthTrackingTab({required this.patients});

  final List<Map<String, dynamic>> patients;

  @override
  ConsumerState<_HealthTrackingTab> createState() => _HealthTrackingTabState();
}

class _HealthTrackingTabState extends ConsumerState<_HealthTrackingTab> {
  // ── Patient multi-select ──────────────────────────────────────────────────
  Set<int> _selectedPatientIds = {}; // empty = all

  // ── Controls ───────────────────────────────────────────────────────────────
  DateTime _startDate = DateTime(2020, 1, 1);
  DateTime _endDate = DateTime.now();
  TrackingHistoryMode _mode = TrackingHistoryMode.all;
  TrackingResultView _resultsView = TrackingResultView.chart;
  TrackingDisplayGranularity _granularity = TrackingDisplayGranularity.daily;
  bool _showComparison = false;
  int? _selectedCategoryIndex;
  int? _selectedMetricId;
  bool _exporting = false;

  static final _apiDateFmt = DateFormat('yyyy-MM-dd');
  String _apiDate(DateTime d) => _apiDateFmt.format(d);

  /// Effective patient list based on selection.
  List<Map<String, dynamic>> get _effectivePatients {
    if (_selectedPatientIds.isEmpty) return widget.patients;
    return widget.patients
        .where(
          (p) => _selectedPatientIds.contains((p['patient_id'] as num).toInt()),
        )
        .toList();
  }

  Future<void> _handleExport(BuildContext context) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final api = ref.read(hcpPatientsApiProvider);
      final pids = _effectivePatients
          .map((p) => (p['patient_id'] as num).toInt())
          .toList();
      for (final pid in pids) {
        final csv = await api.exportPatientHealthEntries(
          pid,
          startDate: _apiDate(_startDate),
          endDate: _apiDate(_endDate),
        );
        downloadCsvFile(csv, 'patient_${pid}_health_tracking.csv');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.healthTrackingExportError(e.toString())),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (widget.patients.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: AppText(
            l10n.hcpReportsNoPatients,
            variant: AppTextVariant.bodyMedium,
            color: context.appColors.textMuted,
          ),
        ),
      );
    }

    // Use first effective patient id to load metric schema
    final effectivePids = _effectivePatients
        .map((p) => (p['patient_id'] as num).toInt())
        .toList();
    final firstPid = effectivePids.isEmpty ? null : effectivePids.first;

    if (firstPid == null) {
      return const Center(child: AppLoadingIndicator());
    }

    final metricsAsync = ref.watch(hcpPatientHealthMetricsProvider(firstPid));

    return metricsAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (_, __) => Center(
        child: AppText(
          l10n.hcpHtLoadError,
          variant: AppTextVariant.bodyMedium,
          color: AppTheme.error,
        ),
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return Center(
            child: AppText(
              l10n.hcpHtNoMetrics,
              variant: AppTextVariant.bodyMedium,
              color: context.appColors.textMuted,
            ),
          );
        }

        // Build metric lookup
        final metricLookup =
            <int, ({String metricName, String categoryName})>{};
        for (final cat in categories) {
          for (final m in cat.metrics) {
            metricLookup[m.metricId] = (
              metricName: m.displayName,
              categoryName: cat.displayName,
            );
          }
        }

        final activeCategories = categories
            .where((cat) => cat.metrics.any((m) => m.isActive))
            .toList();

        final clampedCat = (_selectedCategoryIndex ?? 0).clamp(
          0,
          activeCategories.isEmpty ? 0 : activeCategories.length - 1,
        );
        final selectedCat = activeCategories.isEmpty
            ? null
            : activeCategories[clampedCat];
        final catMetrics =
            selectedCat == null
                  ? <TrackingMetric>[]
                  : selectedCat.metrics.where((m) => m.isActive).toList()
              ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        final validMetricId =
            catMetrics.any((m) => m.metricId == _selectedMetricId)
            ? _selectedMetricId
            : null;

        // Build effective patients list with id+name for chart cards
        final patientList = _effectivePatients.map((p) {
          final id = (p['patient_id'] as num).toInt();
          final name = p['patient_name'] as String? ?? 'Patient #$id';
          return (id: id, name: name);
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Patient multi-select ────────────────────────────────
              _HcpPatientMultiSelect(
                patients: widget.patients,
                selectedIds: _selectedPatientIds,
                onChanged: (ids) => setState(() => _selectedPatientIds = ids),
              ),
              const SizedBox(height: 12),

              // ── Date chips ──────────────────────────────────────────
              Row(
                children: [
                  _HcpDateChip(
                    label: l10n.healthTrackingHistoryDateFrom,
                    value: _startDate,
                    firstDate: DateTime(2010),
                    lastDate: _endDate,
                    onChanged: (d) => setState(() => _startDate = d),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '—',
                      style: AppTheme.captions.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                  ),
                  _HcpDateChip(
                    label: l10n.healthTrackingHistoryDateTo,
                    value: _endDate,
                    firstDate: _startDate,
                    lastDate: DateTime.now(),
                    onChanged: (d) => setState(() => _endDate = d),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Mode + Granularity + View toggle ────────────────────
              TrackingControlsBar(
                mode: _mode,
                onModeChanged: (m) => setState(() {
                  _mode = m;
                  _selectedMetricId = null;
                }),
                granularity: _granularity,
                onGranularityChanged: (g) => setState(() => _granularity = g),
                resultsView: _resultsView,
                onResultsViewChanged: (v) => setState(() => _resultsView = v),
              ),
              const SizedBox(height: 8),

              // ── Compare + Export row ────────────────────────────────
              Row(
                children: [
                  if (_resultsView == TrackingResultView.chart)
                    Semantics(
                      label: l10n.healthTrackingCompareToAggregate,
                      child: FilterChip(
                        label: Text(
                          l10n.healthTrackingCompareToAggregate,
                          style: AppTheme.captions,
                        ),
                        selected: _showComparison,
                        onSelected: (v) => setState(() => _showComparison = v),
                        avatar: const Icon(Icons.group_outlined, size: 16),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 0,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Tooltip(
                    message: l10n.hcpHtExportCsv,
                    child: TextButton.icon(
                      onPressed: _exporting
                          ? null
                          : () => _handleExport(context),
                      icon: Icon(
                        Icons.download_outlined,
                        size: 14,
                        color: _exporting ? null : AppTheme.primary,
                      ),
                      label: Text(
                        _exporting
                            ? l10n.healthTrackingExporting
                            : l10n.hcpHtExportCsv,
                        style: AppTheme.captions.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ── Conditional filter dropdowns ────────────────────────
              if (_mode == TrackingHistoryMode.byCategory) ...[
                if (activeCategories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      l10n.healthTrackingHistoryNoEntries,
                      style: AppTheme.body.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                  )
                else ...[
                  DropdownButtonFormField<int>(
                    initialValue: clampedCat,
                    decoration: InputDecoration(
                      labelText: l10n.healthTrackingCategory,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      for (int i = 0; i < activeCategories.length; i++)
                        DropdownMenuItem(
                          value: i,
                          child: Text(activeCategories[i].displayName),
                        ),
                    ],
                    onChanged: (i) {
                      if (i != null) {
                        setState(() {
                          _selectedCategoryIndex = i;
                          _selectedMetricId = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ],

              if (_mode == TrackingHistoryMode.byMetric &&
                  activeCategories.isNotEmpty) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: clampedCat,
                        decoration: InputDecoration(
                          labelText: l10n.healthTrackingCategory,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: [
                          for (int i = 0; i < activeCategories.length; i++)
                            DropdownMenuItem(
                              value: i,
                              child: Text(activeCategories[i].displayName),
                            ),
                        ],
                        onChanged: (i) {
                          if (i != null) {
                            setState(() {
                              _selectedCategoryIndex = i;
                              _selectedMetricId = null;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        key: ValueKey('metric-$clampedCat'),
                        initialValue: validMetricId,
                        decoration: InputDecoration(
                          labelText: l10n.healthTrackingMetric,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: catMetrics
                            .map(
                              (m) => DropdownMenuItem(
                                value: m.metricId,
                                child: Text(
                                  m.unit != null
                                      ? '${m.displayName} (${m.unit})'
                                      : m.displayName,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (id) =>
                            setState(() => _selectedMetricId = id),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // ── Results ─────────────────────────────────────────────
              if (_mode == TrackingHistoryMode.all)
                _resultsView == TrackingResultView.table
                    ? _HcpEntriesTable(
                        patients: patientList,
                        startDate: _apiDate(_startDate),
                        endDate: _apiDate(_endDate),
                        metricId: null,
                        categoryKey: null,
                        showCategory: true,
                        showPatient: patientList.length > 1,
                        metricLookup: metricLookup,
                      )
                    : _HcpMetricChartsSection(
                        patients: patientList,
                        categories: categories,
                        granularity: _granularity,
                        showComparison: _showComparison,
                        startDate: _apiDate(_startDate),
                        endDate: _apiDate(_endDate),
                      )
              else if (_mode == TrackingHistoryMode.byCategory)
                if (selectedCat == null)
                  Center(
                    child: Text(
                      l10n.healthTrackingHistoryNoEntries,
                      style: AppTheme.body.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                  )
                else
                  _resultsView == TrackingResultView.table
                      ? _HcpEntriesTable(
                          patients: patientList,
                          startDate: _apiDate(_startDate),
                          endDate: _apiDate(_endDate),
                          metricId: null,
                          categoryKey: selectedCat.categoryKey,
                          showCategory: false,
                          showPatient: patientList.length > 1,
                          metricLookup: metricLookup,
                        )
                      : _HcpMetricChartsSection(
                          patients: patientList,
                          categories: [selectedCat],
                          granularity: _granularity,
                          showComparison: _showComparison,
                          startDate: _apiDate(_startDate),
                          endDate: _apiDate(_endDate),
                        )
              else if (_mode == TrackingHistoryMode.byMetric)
                if (validMetricId == null)
                  Center(
                    child: Text(
                      l10n.healthTrackingSelectMetric,
                      style: AppTheme.body.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                  )
                else
                  _resultsView == TrackingResultView.chart
                      ? _MetricChartCard(
                          patients: patientList,
                          metric: catMetrics.firstWhere(
                            (m) => m.metricId == validMetricId,
                          ),
                          startDate: _apiDate(_startDate),
                          endDate: _apiDate(_endDate),
                          showComparison: _showComparison,
                          granularity: _granularity,
                          colorIndex: 0,
                        )
                      : _HcpEntriesTable(
                          patients: patientList,
                          startDate: _apiDate(_startDate),
                          endDate: _apiDate(_endDate),
                          metricId: validMetricId,
                          categoryKey: null,
                          showCategory: false,
                          showPatient: patientList.length > 1,
                          metricLookup: metricLookup,
                        ),
            ],
          ),
        );
      },
    );
  }
}

// ── Patient multi-select ──────────────────────────────────────────────────────

class _HcpPatientMultiSelect extends StatelessWidget {
  const _HcpPatientMultiSelect({
    required this.patients,
    required this.selectedIds,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> patients;
  final Set<int> selectedIds;
  final void Function(Set<int>) onChanged;

  @override
  Widget build(BuildContext context) {
    final allSelected = selectedIds.isEmpty;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        FilterChip(
          label: Text(context.l10n.hcpAllPatients),
          selected: allSelected,
          onSelected: (_) => onChanged({}),
          avatar: const Icon(Icons.group_outlined, size: 16),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        ),
        for (final p in patients) ...[
          Builder(
            builder: (context) {
              final id = (p['patient_id'] as num).toInt();
              final name = p['patient_name'] as String? ?? 'Patient #$id';
              final isSelected = selectedIds.contains(id);
              return FilterChip(
                label: Text(name),
                selected: isSelected,
                onSelected: (checked) {
                  final next = Set<int>.from(selectedIds);
                  if (checked) {
                    next.add(id);
                    // If all individually selected, treat as "all"
                    if (next.length == patients.length) {
                      onChanged({});
                      return;
                    }
                  } else {
                    next.remove(id);
                  }
                  onChanged(next);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              );
            },
          ),
        ],
      ],
    );
  }
}

// ── Compact date chip button ──────────────────────────────────────────────────

class _HcpDateChip extends StatelessWidget {
  const _HcpDateChip({
    required this.label,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
  });

  final String label;
  final DateTime value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, yyyy');
    final clamped = value.isBefore(firstDate)
        ? firstDate
        : value.isAfter(lastDate)
        ? lastDate
        : value;
    return Tooltip(
      message: label,
      child: OutlinedButton.icon(
        onPressed: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: clamped,
            firstDate: firstDate,
            lastDate: lastDate,
            builder: (context, child) {
              final theme = Theme.of(context);
              return Theme(
                data: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                    primary: AppTheme.primary,
                  ),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
          if (picked != null) onChanged(picked);
        },
        icon: const Icon(Icons.calendar_today_outlined, size: 14),
        label: Text('$label: ${fmt.format(value)}', style: AppTheme.captions),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          side: BorderSide(color: context.appColors.divider),
          foregroundColor: context.appColors.textPrimary,
        ),
      ),
    );
  }
}

// ── HCP entries table (multi-patient) ─────────────────────────────────────────

class _HcpEntriesTable extends ConsumerWidget {
  const _HcpEntriesTable({
    required this.patients,
    required this.startDate,
    required this.endDate,
    required this.metricId,
    required this.categoryKey,
    required this.showCategory,
    required this.showPatient,
    required this.metricLookup,
  });

  final List<({int id, String name})> patients;
  final String startDate;
  final String endDate;
  final int? metricId;
  final String? categoryKey;
  final bool showCategory;
  final bool showPatient;
  final Map<int, ({String metricName, String categoryName})> metricLookup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final fmt = DateFormat('MMM d, yyyy');

    // Collect all entry futures
    final allAsyncEntries = [
      for (final p in patients)
        ref.watch(
          hcpPatientHealthEntriesProvider((
            patientId: p.id,
            startDate: startDate,
            endDate: endDate,
            metricId: metricId,
          )),
        ),
    ];

    final isLoading = allAsyncEntries.any((a) => a.isLoading);
    final hasError = allAsyncEntries.any((a) => a.hasError);

    if (isLoading) return const AppLoadingIndicator(centered: false);
    if (hasError) {
      return Text(
        l10n.healthTrackingMetricsError,
        style: AppTheme.body.copyWith(color: AppTheme.error),
      );
    }

    // Merge entries from all patients, tagging with patient name
    final merged = <({TrackingEntry entry, String patientName})>[];
    for (int i = 0; i < patients.length; i++) {
      final entries = allAsyncEntries[i].value ?? [];
      for (final e in entries) {
        // Apply categoryKey filter client-side when needed
        if (categoryKey != null &&
            metricLookup[e.metricId]?.categoryName != categoryKey) {
          continue;
        }
        merged.add((entry: e, patientName: patients[i].name));
      }
    }

    merged.sort((a, b) => b.entry.entryDate.compareTo(a.entry.entryDate));
    final truncated = merged.length > 100;
    final rows = truncated ? merged.sublist(0, 100) : merged;

    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            l10n.healthTrackingHistoryNoEntries,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (truncated)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l10n.healthTrackingHistoryTruncated,
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 36,
            dataRowMinHeight: 32,
            dataRowMaxHeight: 40,
            columns: [
              DataColumn(
                label: Text(
                  l10n.commonDate,
                  style: AppTheme.captions.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ),
              if (showCategory)
                DataColumn(
                  label: Text(
                    l10n.healthTrackingCategory,
                    style: AppTheme.captions.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ),
              DataColumn(
                label: Text(
                  l10n.healthTrackingMetric,
                  style: AppTheme.captions.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  l10n.healthTrackingValueColumn,
                  style: AppTheme.captions.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ),
              if (showPatient)
                DataColumn(
                  label: Text(
                    l10n.hcpHtPatientSeries,
                    style: AppTheme.captions.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ),
            ],
            rows: [
              for (final row in rows)
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        fmt.format(row.entry.entryDate),
                        style: AppTheme.captions.copyWith(
                          color: context.appColors.textMuted,
                        ),
                      ),
                    ),
                    if (showCategory)
                      DataCell(
                        Text(
                          metricLookup[row.entry.metricId]?.categoryName ?? '—',
                          style: AppTheme.body.copyWith(
                            color: context.appColors.textPrimary,
                          ),
                        ),
                      ),
                    DataCell(
                      Text(
                        metricLookup[row.entry.metricId]?.metricName ?? '—',
                        style: AppTheme.body.copyWith(
                          color: context.appColors.textPrimary,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        row.entry.value,
                        style: AppTheme.body.copyWith(
                          color: context.appColors.textPrimary,
                        ),
                      ),
                    ),
                    if (showPatient)
                      DataCell(
                        Text(
                          row.patientName,
                          style: AppTheme.captions.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── HCP metric charts section ─────────────────────────────────────────────────

class _HcpMetricChartsSection extends StatelessWidget {
  const _HcpMetricChartsSection({
    required this.patients,
    required this.categories,
    required this.granularity,
    required this.showComparison,
    required this.startDate,
    required this.endDate,
  });

  final List<({int id, String name})> patients;
  final List<TrackingCategory> categories;
  final TrackingDisplayGranularity granularity;
  final bool showComparison;
  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    final chartableMetrics = <TrackingMetric>[];
    for (final cat in categories) {
      for (final m in cat.metrics) {
        if (m.isActive &&
            (m.metricType == 'number' ||
                m.metricType == 'scale' ||
                m.metricType == 'yesno')) {
          chartableMetrics.add(m);
        }
      }
    }

    if (chartableMetrics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < chartableMetrics.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _MetricChartCard(
              patients: patients,
              metric: chartableMetrics[i],
              startDate: startDate,
              endDate: endDate,
              showComparison: showComparison,
              granularity: granularity,
              colorIndex: i,
            ),
          ),
      ],
    );
  }
}

// ── Per-metric chart card ─────────────────────────────────────────────────────

class _MetricChartCard extends ConsumerStatefulWidget {
  const _MetricChartCard({
    required this.patients,
    required this.metric,
    required this.startDate,
    required this.endDate,
    required this.showComparison,
    required this.granularity,
    required this.colorIndex,
  });

  /// List of patients to fetch entries for (multi-patient support).
  final List<({int id, String name})> patients;
  final TrackingMetric metric;
  final String? startDate;
  final String? endDate;
  final bool showComparison;
  final TrackingDisplayGranularity granularity;
  final int colorIndex;

  @override
  ConsumerState<_MetricChartCard> createState() => _MetricChartCardState();
}

class _MetricChartCardState extends ConsumerState<_MetricChartCard> {
  late _ChartType _chartType;

  @override
  void initState() {
    super.initState();
    _chartType = _defaultChartType(
      widget.metric.metricType,
      widget.metric.frequency,
    );
  }

  /// Pick the most appropriate chart type for this metric.
  static _ChartType _defaultChartType(String metricType, String frequency) {
    return switch (metricType) {
      'yesno' => _ChartType.pie, // proportion of yes/no over the period
      'single_choice' => _ChartType.pie, // distribution of choices
      'scale' => _ChartType.line, // continuous trend
      _ =>
        frequency ==
                'daily' // number: daily → line, weekly/monthly → bar
            ? _ChartType.line
            : _ChartType.bar,
    };
  }

  // ── ISO week helper ─────────────────────────────────────────────────────────
  static int _isoWeek(DateTime d) {
    final dayOfYear = d.difference(DateTime(d.year, 1, 1)).inDays + 1;
    return ((dayOfYear - d.weekday + 10) / 7).floor();
  }

  /// Average numeric entry values, grouped by granularity.
  Map<String, double> _avgByGranularity(List<TrackingEntry> entries) {
    final totals = <String, double>{};
    final counts = <String, int>{};
    for (final e in entries) {
      final v = double.tryParse(e.value);
      if (v == null) continue;
      final String key;
      switch (widget.granularity) {
        case TrackingDisplayGranularity.weekly:
          key =
              '${e.entryDate.year}-W${_isoWeek(e.entryDate).toString().padLeft(2, '0')}';
        case TrackingDisplayGranularity.monthly:
          key = DateFormat('yyyy-MM').format(e.entryDate);
        case TrackingDisplayGranularity.daily:
          key = DateFormat('MM/dd/yy').format(e.entryDate);
      }
      totals[key] = (totals[key] ?? 0) + v;
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return {for (final k in totals.keys) k: totals[k]! / counts[k]!};
  }

  /// Aggregate AggregateDataPoint values per granularity.
  Map<String, double> _aggByGranularity(List<AggregateDataPoint> points) {
    if (widget.granularity == TrackingDisplayGranularity.daily) {
      return {
        for (final p in points)
          DateFormat('MM/dd/yy').format(p.entryDate): p.avgValue,
      };
    }
    final groups = <String, List<double>>{};
    for (final p in points) {
      final String key;
      switch (widget.granularity) {
        case TrackingDisplayGranularity.weekly:
          key =
              '${p.entryDate.year}-W${_isoWeek(p.entryDate).toString().padLeft(2, '0')}';
        case TrackingDisplayGranularity.monthly:
          key = DateFormat('yyyy-MM').format(p.entryDate);
        case TrackingDisplayGranularity.daily:
          key = DateFormat('yyyy-MM-dd').format(p.entryDate);
      }
      groups.putIfAbsent(key, () => []).add(p.avgValue);
    }
    return {
      for (final e in groups.entries)
        e.key: e.value.reduce((a, b) => a + b) / e.value.length,
    };
  }

  /// For pie charts: count occurrences of each distinct value.
  /// yesno → {'Yes': n, 'No': m}; others → {'value': count, ...}
  static Map<String, double> _valueDistribution(
    List<TrackingEntry> entries,
    bool isYesNo,
  ) {
    final counts = <String, double>{};
    for (final e in entries) {
      final v = double.tryParse(e.value);
      if (v == null) continue;
      final key = isYesNo
          ? (v >= 0.5 ? 'Yes' : 'No')
          : (v == v.roundToDouble()
                ? v.toInt().toString()
                : v.toStringAsFixed(1));
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cardColor = AppLineChart
        .defaultColors[widget.colorIndex % AppLineChart.defaultColors.length];

    // Watch entries for all patients
    final allEntryAsyncList = [
      for (final p in widget.patients)
        ref.watch(
          hcpPatientHealthEntriesProvider((
            patientId: p.id,
            startDate: widget.startDate,
            endDate: widget.endDate,
            metricId: widget.metric.metricId,
          )),
        ),
    ];

    final isLoading = allEntryAsyncList.any((a) => a.isLoading);
    final hasError = allEntryAsyncList.any((a) => a.hasError);

    return Card(
      elevation: 0,
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cardColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.metric.displayName,
                        style: AppTheme.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.appColors.textPrimary,
                        ),
                      ),
                      if (widget.metric.unit != null)
                        Text(
                          widget.metric.unit!,
                          style: AppTheme.captions.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                // ── Chart type picker ──────────────────────────────
                Semantics(
                  label: l10n.hcpHtChartTypeLabel,
                  child: Row(
                    children: [
                      _ChartTypeButton(
                        icon: Icons.show_chart,
                        tooltip: l10n.hcpHtChartTypeLine,
                        selected: _chartType == _ChartType.line,
                        onTap: () =>
                            setState(() => _chartType = _ChartType.line),
                      ),
                      _ChartTypeButton(
                        icon: Icons.bar_chart,
                        tooltip: l10n.hcpHtChartTypeBar,
                        selected: _chartType == _ChartType.bar,
                        onTap: () =>
                            setState(() => _chartType = _ChartType.bar),
                      ),
                      _ChartTypeButton(
                        icon: Icons.pie_chart_outline,
                        tooltip: l10n.hcpHtChartTypePie,
                        selected: _chartType == _ChartType.pie,
                        onTap: () =>
                            setState(() => _chartType = _ChartType.pie),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Chart body ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? const Center(child: AppLoadingIndicator())
                : hasError
                ? Text(
                    l10n.hcpHtLoadError,
                    style: AppTheme.body.copyWith(color: AppTheme.error),
                  )
                : _buildChartBody(context, l10n, cardColor, allEntryAsyncList),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBody(
    BuildContext context,
    AppLocalizations l10n,
    Color cardColor,
    List<AsyncValue<List<TrackingEntry>>> allEntryAsyncList,
  ) {
    final allEntriesByPatient = [
      for (int i = 0; i < widget.patients.length; i++)
        allEntryAsyncList[i].value ?? <TrackingEntry>[],
    ];

    // For pie charts, combine all patients
    if (_chartType == _ChartType.pie) {
      final combined = allEntriesByPatient.expand((e) => e).toList();
      if (combined.isEmpty) {
        return Text(
          l10n.hcpHtNoEntriesForMetric,
          style: AppTheme.body.copyWith(color: context.appColors.textMuted),
        );
      }
      final pieData = _valueDistribution(
        combined,
        widget.metric.metricType == 'yesno',
      );
      return AppPieChart(title: '', data: pieData);
    }

    // For bar charts: show first patient only
    if (_chartType == _ChartType.bar) {
      final entries = allEntriesByPatient.isEmpty
          ? <TrackingEntry>[]
          : allEntriesByPatient.first;
      if (entries.isEmpty) {
        return Text(
          l10n.hcpHtNoEntriesForMetric,
          style: AppTheme.body.copyWith(color: context.appColors.textMuted),
        );
      }
      final data = _avgByGranularity(entries);
      return _HorizScrollChart(
        dataPointCount: data.length,
        child: AppBarChart(title: '', data: data, barColor: cardColor),
      );
    }

    // Line chart: one series per patient
    final seriesList = <LineSeries>[];
    for (int i = 0; i < widget.patients.length; i++) {
      final entries = allEntriesByPatient[i];
      if (entries.isEmpty) continue;
      final data = _avgByGranularity(entries);
      if (data.isEmpty) continue;
      final color =
          AppLineChart.defaultColors[i % AppLineChart.defaultColors.length];
      seriesList.add(
        LineSeries(label: widget.patients[i].name, data: data, color: color),
      );
    }

    if (seriesList.isEmpty) {
      return Text(
        l10n.hcpHtNoEntriesForMetric,
        style: AppTheme.body.copyWith(color: context.appColors.textMuted),
      );
    }

    // Comparison: add aggregate line when 1 patient selected, or "Population Avg" for multiple
    if (widget.showComparison) {
      final firstPid = widget.patients.first.id;
      return _MultiPatientComparisonChart(
        firstPatientId: firstPid,
        metric: widget.metric,
        seriesList: seriesList,
        startDate: widget.startDate,
        endDate: widget.endDate,
        aggByGranularity: _aggByGranularity,
        isMultiPatient: widget.patients.length > 1,
      );
    }

    final allDateCount = seriesList.expand((s) => s.data.keys).toSet().length;
    return _HorizScrollChart(
      dataPointCount: allDateCount,
      child: AppLineChart(title: '', series: seriesList),
    );
  }
}

/// Small icon button for switching chart type.
class _ChartTypeButton extends StatelessWidget {
  const _ChartTypeButton({
    required this.icon,
    required this.tooltip,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 18,
            color: selected
                ? AppTheme.primary
                : context.appColors.textMuted.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

// ── Multi-patient comparison chart ────────────────────────────────────────────

/// Loads the aggregate and adds it as a "Population Avg" dotted line.
class _MultiPatientComparisonChart extends ConsumerWidget {
  const _MultiPatientComparisonChart({
    required this.firstPatientId,
    required this.metric,
    required this.seriesList,
    required this.startDate,
    required this.endDate,
    required this.aggByGranularity,
    required this.isMultiPatient,
  });

  final int firstPatientId;
  final TrackingMetric metric;
  final List<LineSeries> seriesList;
  final String? startDate;
  final String? endDate;
  final Map<String, double> Function(List<AggregateDataPoint>) aggByGranularity;
  final bool isMultiPatient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final aggParams = (
      patientId: firstPatientId,
      metricId: metric.metricId,
      startDate: startDate,
      endDate: endDate,
    );
    final aggAsync = ref.watch(hcpHealthAggregateProvider(aggParams));

    return aggAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (_, __) {
        final dateCount = seriesList.expand((s) => s.data.keys).toSet().length;
        return _HorizScrollChart(
          dataPointCount: dateCount,
          child: AppLineChart(title: '', series: seriesList),
        );
      },
      data: (aggPoints) {
        final aggData = aggByGranularity(aggPoints);
        final allSeries = [
          ...seriesList,
          if (aggData.isNotEmpty)
            LineSeries(
              label: l10n.hcpHtAggregateSeries,
              data: aggData,
              color: AppTheme.secondary,
              dotted: true,
            ),
        ];
        final dateCount = allSeries.expand((s) => s.data.keys).toSet().length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HorizScrollChart(
              dataPointCount: dateCount,
              child: AppLineChart(title: '', series: allSeries),
            ),
            if (aggData.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.hcpHtAggregateUnavailable,
                  style: AppTheme.captions.copyWith(
                    color: context.appColors.textMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ── Horizontal-scroll wrapper for dense charts ─────────────────────────────────
//
// Uses a proper StatefulWidget so the ScrollController is not created inside
// build() (which would leak). Each data point gets [minPointWidth] px so
// x-axis labels have room. When the required width fits the available space the
// chart renders normally without any scroll affordance.

class _HorizScrollChart extends StatefulWidget {
  const _HorizScrollChart({required this.child, required this.dataPointCount});

  final Widget child;
  final int dataPointCount;

  // Pixels allocated per data point; tuned so ISO date labels (≈65 px) fit.
  static const double _kMinPointWidth = 72.0;

  @override
  State<_HorizScrollChart> createState() => _HorizScrollChartState();
}

class _HorizScrollChartState extends State<_HorizScrollChart> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final requiredWidth =
            widget.dataPointCount * _HorizScrollChart._kMinPointWidth;
        if (requiredWidth <= constraints.maxWidth) {
          return widget.child;
        }
        return Scrollbar(
          controller: _controller,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: SizedBox(
                width: requiredWidth,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
