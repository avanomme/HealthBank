// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/pages/participant_health_tracking_page.dart
/// Participant health-tracking page.
///
/// View switching via SegmentedButton (Log Today / History) — no swipe tabs.
///
/// Log Today layout:
///   • Sticky header row: [← Back]  [Save]  [Next →]
///   • Two-column body: category sidebar (jump-nav) + full question scroll
///   • All categories flow in one continuous list; sidebar jumps to sections
library;

import '../../../features/researcher/pages/csv_download_stub.dart'
    if (dart.library.js_interop) '../../../features/researcher/pages/csv_download_web.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/tracking_controls_bar.dart';
import 'package:frontend/src/core/widgets/feedback/app_info_banner.dart';
import 'package:frontend/src/core/widgets/feedback/app_loading_indicator.dart';
import 'package:frontend/src/features/participant/state/health_tracking_providers.dart';
import 'package:frontend/src/features/participant/widgets/health_metric_entry_card.dart';
import 'package:frontend/src/features/participant/widgets/health_tracking_chart.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:intl/intl.dart';

enum _HtView { logToday, history }

/// Page where participants log daily health metrics or review their history.
///
/// Switches between a "Log Today" entry view and a chart-based history view
/// via a SegmentedButton. Entry state is managed by [trackingDraftProvider].
class ParticipantHealthTrackingPage extends ConsumerStatefulWidget {
  const ParticipantHealthTrackingPage({super.key});

  @override
  ConsumerState<ParticipantHealthTrackingPage> createState() =>
      _ParticipantHealthTrackingPageState();
}

class _ParticipantHealthTrackingPageState
    extends ConsumerState<ParticipantHealthTrackingPage> {
  _HtView _view = _HtView.logToday;
  bool _isSaving = false;

  Future<void> _saveEntries(
    BuildContext context,
    List<TrackingCategory> categories,
    bool isBaseline,
  ) async {
    final draft = ref.read(trackingDraftProvider.notifier);
    final values = draft.values;
    if (values.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final now = DateTime.now();
      final entries = values.entries
          .map((e) => TrackingEntrySubmit(
                metricId: e.key,
                value: e.value,
                entryDate: now,
              ))
          .toList();

      await ref.read(healthTrackingApiProvider).submitEntries(
            BatchEntrySubmit(entries: entries, isBaseline: isBaseline),
          );

      ref.invalidate(trackingEntriesProvider);
      ref.invalidate(trackingBaselineProvider);
      ref.invalidate(healthCheckInStatusProvider);
      for (final id in values.keys) {
        ref.invalidate(trackingHistoryProvider(id));
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Semantics(
            liveRegion: true,
            child: Text(context.l10n.healthTrackingSaveSuccess),
          ),
          backgroundColor: AppTheme.success,
        ));
      }
    } catch (e) {
      if (context.mounted) {
        final detail = e is DioException
            ? (e.response?.data is Map
                ? (e.response!.data['detail']?.toString() ??
                    e.response!.statusMessage ??
                    e.message ??
                    '')
                : (e.response?.statusMessage ?? e.message ?? ''))
            : e.toString();
        final msg = detail.isEmpty
            ? context.l10n.healthTrackingSaveError
            : '${context.l10n.healthTrackingSaveError} ($detail)';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Semantics(
            liveRegion: true,
            child: Text(msg),
          ),
          backgroundColor: AppTheme.error,
        ));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ParticipantScaffold(
      currentRoute: '/participant/health-tracking',
      scrollable: false,
      showFooter: false,
      maxWidth: 1100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ────────────────────────────────────────────────
          Semantics(
            header: true,
            child: Text(
              l10n.healthTrackingTitle,
              style: AppTheme.heading3
                  .copyWith(color: context.appColors.textPrimary),
            ),
          ),
          const SizedBox(height: 16),

          // ── View switcher (SegmentedButton, not tabs) ─────────────
          Semantics(
            label: l10n.healthTrackingViewModeLabel,
            child: SegmentedButton<_HtView>(
              segments: [
                ButtonSegment(
                  value: _HtView.logToday,
                  label: Text(l10n.healthTrackingLogToday),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                ),
                ButtonSegment(
                  value: _HtView.history,
                  label: Text(l10n.healthTrackingHistory),
                  icon: const Icon(Icons.history, size: 16),
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

          // ── Content ───────────────────────────────────────────────
          Expanded(
            child: _view == _HtView.logToday
                ? _LogTodayView(
                    isSaving: _isSaving,
                    onSave: _saveEntries,
                  )
                : const _HistoryView(),
          ),
        ],
      ),
    );
  }
}

// ── Log Today view ────────────────────────────────────────────────────────────

class _LogTodayView extends ConsumerStatefulWidget {
  const _LogTodayView({required this.isSaving, required this.onSave});

  final bool isSaving;
  final Future<void> Function(
    BuildContext context,
    List<TrackingCategory> categories,
    bool isBaseline,
  ) onSave;

  @override
  ConsumerState<_LogTodayView> createState() => _LogTodayViewState();
}

class _LogTodayViewState extends ConsumerState<_LogTodayView> {
  final ScrollController _scrollController = ScrollController();

  /// Index within _visibleCats (categories that actually have metrics today).
  int _activeVisibleIndex = 0;

  /// GlobalKey per visible-category index for scroll-to-section.
  final Map<int, GlobalKey> _sectionKeys = {};

  static String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-'
        '${n.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _goToVisible(int visibleIndex, List<TrackingCategory> visibleCats) {
    final clamped = visibleIndex.clamp(0, visibleCats.length - 1);
    setState(() => _activeVisibleIndex = clamped);
    final key = _sectionKeys[clamped];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categoriesAsync = ref.watch(trackingMetricsByCategoryProvider);
    final baselineAsync = ref.watch(trackingBaselineProvider);
    final draftValues = ref.watch(trackingDraftProvider).values;

    final todayStr = _todayStr();
    final todayEntriesMap = ref
        .watch(trackingEntriesProvider((startDate: todayStr, endDate: todayStr)))
        .maybeWhen(
          data: (entries) => {for (final e in entries) e.metricId: e.value},
          orElse: () => <int, String>{},
        );

    final today = DateTime.now();
    final showWeekly = today.weekday == DateTime.sunday;
    final showMonthly = today.day == 1;

    return categoriesAsync.when(
      loading: () =>
          const Center(child: AppLoadingIndicator(centered: false)),
      error: (e, _) => Center(
        child: Text(l10n.healthTrackingMetricsError,
            style:
                AppTheme.body.copyWith(color: context.appColors.textMuted)),
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return Center(
            child: Text(l10n.healthTrackingNoMetrics,
                style: AppTheme.body
                    .copyWith(color: context.appColors.textMuted)),
          );
        }

        final isBaseline = baselineAsync.when(
          data: (b) => b.isEmpty,
          loading: () => false,
          error: (_, __) => false,
        );

        // Build list of visible categories (those with metrics due today).
        final visibleCats = <TrackingCategory>[];
        final metricsPerVisible = <List<TrackingMetric>>[];

        for (final cat in categories) {
          final active = cat.metrics
              .where((m) => m.isActive)
              .toList()
            ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

          final metrics = <TrackingMetric>[
            ...active.where(
                (m) => m.frequency == 'daily' || m.frequency == 'any'),
            if (showWeekly)
              ...active.where((m) => m.frequency == 'weekly'),
            if (showMonthly)
              ...active.where((m) => m.frequency == 'monthly'),
          ];

          if (metrics.isEmpty) continue;
          visibleCats.add(cat);
          metricsPerVisible.add(metrics);
        }

        // Ensure one GlobalKey per visible category index.
        for (int vi = 0; vi < visibleCats.length; vi++) {
          _sectionKeys.putIfAbsent(vi, () => GlobalKey());
        }

        final clampedActive =
            _activeVisibleIndex.clamp(0, visibleCats.length - 1);

        // Build the complete widget list for the non-lazy ListView.
        int questionNumber = 0;
        final questionWidgets = <Widget>[];

        for (int vi = 0; vi < visibleCats.length; vi++) {
          final cat = visibleCats[vi];
          final metrics = metricsPerVisible[vi];

          // Section header anchored with GlobalKey.
          questionWidgets.add(
            Container(
              key: _sectionKeys[vi],
              child: _CategorySectionHeader(
                label: cat.displayName,
                isActive: vi == clampedActive,
              ),
            ),
          );

          for (final metric in metrics) {
            final qn = questionNumber;
            questionWidgets.add(HealthMetricEntryCard(
              key: ValueKey(metric.metricId),
              metric: metric,
              questionNumber: qn + 1,
              cardIndex: qn,
              initialValue: draftValues[metric.metricId] ??
                  todayEntriesMap[metric.metricId],
              onChanged: (v) =>
                  ref.read(trackingDraftProvider.notifier).set(metric.metricId, v),
            ));
            questionNumber++;
          }
        }

        return Column(
          children: [
            // ── Sticky header: baseline banner + Back / Save / Next ──
            Material(
              color: context.appColors.surface,
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isBaseline)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AppInfoBanner(
                          icon: Icons.info_outline,
                          color: AppTheme.info,
                          message: l10n.healthTrackingBaselineBanner,
                        ),
                      ),
                    Row(
                      children: [
                        // ── Category dropdown (jump-nav) ──────────────
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: clampedActive,
                            isDense: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: context.appColors.divider),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: context.appColors.divider),
                              ),
                            ),
                            items: [
                              for (int vi = 0;
                                  vi < visibleCats.length;
                                  vi++)
                                DropdownMenuItem(
                                  value: vi,
                                  child: Text(
                                    visibleCats[vi].displayName,
                                    style: AppTheme.body.copyWith(
                                      color: vi == clampedActive
                                          ? AppTheme.primary
                                          : context.appColors.textPrimary,
                                      fontWeight: vi == clampedActive
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                            ],
                            onChanged: (i) {
                              if (i != null) _goToVisible(i, visibleCats);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        // ── Save (saves partial or full progress) ──────
                        FilledButton.icon(
                          onPressed: widget.isSaving
                              ? null
                              : () => widget.onSave(
                                  context, categories, isBaseline),
                          icon: widget.isSaving
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : const Icon(Icons.save_outlined, size: 18),
                          label: Text(l10n.healthTrackingSave),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            textStyle: AppTheme.captions,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Question scroll ───────────────────────────────────────
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(questionWidgets),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Category section header in main scroll ────────────────────────────────────

class _CategorySectionHeader extends StatelessWidget {
  const _CategorySectionHeader({
    required this.label,
    this.isActive = false,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.primary
                  : context.appColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTheme.heading5.copyWith(
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── History view ──────────────────────────────────────────────────────────────

class _HistoryView extends ConsumerStatefulWidget {
  const _HistoryView();

  @override
  ConsumerState<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<_HistoryView> {
  TrackingHistoryMode _mode = TrackingHistoryMode.all;
  TrackingResultView _resultsView = TrackingResultView.table;
  DateTime _startDate = DateTime(2020, 1, 1);
  DateTime _endDate = DateTime.now();
  int? _selectedCategoryIndex;
  int? _selectedMetricId;
  TrackingDisplayGranularity _granularity = TrackingDisplayGranularity.daily;
  bool _showComparison = false;
  bool _exporting = false;

  static final _apiDateFmt = DateFormat('yyyy-MM-dd');

  String _apiDate(DateTime d) => _apiDateFmt.format(d);

  Future<void> _handleExport(BuildContext context) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final api = ref.read(healthTrackingApiProvider);
      final csv = await api.exportParticipantCsv(
        startDate: _apiDate(_startDate),
        endDate: _apiDate(_endDate),
      );
      downloadCsvFile(csv, 'my_health_tracking_export.csv');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.l10n.healthTrackingExportError(e.toString())),
          backgroundColor: AppTheme.error,
        ));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categoriesAsync = ref.watch(trackingMetricsByCategoryProvider);

    return categoriesAsync.when(
      loading: () =>
          const Center(child: AppLoadingIndicator(centered: false)),
      error: (e, _) => Center(
        child: Text(l10n.healthTrackingMetricsError,
            style:
                AppTheme.body.copyWith(color: context.appColors.textMuted)),
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return Center(
            child: Text(l10n.healthTrackingNoMetrics,
                style: AppTheme.body
                    .copyWith(color: context.appColors.textMuted)),
          );
        }

        // Build a flat lookup: metricId → (metricName, categoryName)
        final metricLookup = <int, ({String metricName, String categoryName})>{};
        for (final cat in categories) {
          for (final m in cat.metrics) {
            metricLookup[m.metricId] =
                (metricName: m.displayName, categoryName: cat.displayName);
          }
        }

        final answeredCategories = categories
            .where((cat) => cat.metrics.any((m) => m.isActive))
            .toList();

        final clampedCat = (_selectedCategoryIndex ?? 0)
            .clamp(0, answeredCategories.isEmpty ? 0 : answeredCategories.length - 1);
        final selectedCat =
            answeredCategories.isEmpty ? null : answeredCategories[clampedCat];
        final catMetrics = selectedCat == null
            ? <TrackingMetric>[]
            : selectedCat.metrics
                .where((m) => m.isActive)
                .toList()
              ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

        final validMetricId =
            catMetrics.any((m) => m.metricId == _selectedMetricId)
                ? _selectedMetricId
                : null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // ── Compact date range row ──────────────────────────────
          Row(
            children: [
              _CompactDateChip(
                label: l10n.healthTrackingHistoryDateFrom,
                value: _startDate,
                firstDate: DateTime(2010),
                lastDate: _endDate,
                onChanged: (d) => setState(() => _startDate = d),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('—',
                    style: AppTheme.captions
                        .copyWith(color: context.appColors.textMuted)),
              ),
              _CompactDateChip(
                label: l10n.healthTrackingHistoryDateTo,
                value: _endDate,
                firstDate: _startDate,
                lastDate: DateTime.now(),
                onChanged: (d) => setState(() => _endDate = d),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Mode + Granularity + View toggle (always visible) ───
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

          // ── Compare (chart only) + Export (always) ──────────────
          Row(
            children: [
              if (_resultsView == TrackingResultView.chart)
                Semantics(
                  label: l10n.healthTrackingCompareToAggregate,
                  child: FilterChip(
                    label: Text(l10n.healthTrackingCompareToAggregate,
                        style: AppTheme.captions),
                    selected: _showComparison,
                    onSelected: (v) =>
                        setState(() => _showComparison = v),
                    avatar: const Icon(Icons.group_outlined, size: 16),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 0),
                  ),
                ),
              const Spacer(),
              Tooltip(
                message: l10n.healthTrackingExportOwnData,
                child: TextButton.icon(
                  onPressed:
                      _exporting ? null : () => _handleExport(context),
                  icon: Icon(Icons.download_outlined,
                      size: 14,
                      color: _exporting ? null : AppTheme.primary),
                  label: Text(
                    _exporting
                        ? l10n.healthTrackingExporting
                        : l10n.healthTrackingExportOwnData,
                    style:
                        AppTheme.captions.copyWith(color: AppTheme.primary),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Conditional filter dropdowns ─────────────────────────
          if (_mode == TrackingHistoryMode.byCategory) ...[
            if (answeredCategories.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.healthTrackingHistoryNoEntries,
                  style: AppTheme.body
                      .copyWith(color: context.appColors.textMuted),
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
                  for (int i = 0; i < answeredCategories.length; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text(answeredCategories[i].displayName),
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

          // By Metric: Category + Metric dropdowns in the same row
          if (_mode == TrackingHistoryMode.byMetric &&
              answeredCategories.isNotEmpty) ...[
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
                      for (int i = 0; i < answeredCategories.length; i++)
                        DropdownMenuItem(
                          value: i,
                          child: Text(answeredCategories[i].displayName),
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
                        .map((m) => DropdownMenuItem(
                              value: m.metricId,
                              child: Text(m.unit != null
                                  ? '${m.displayName} (${m.unit})'
                                  : m.displayName),
                            ))
                        .toList(),
                    onChanged: (id) =>
                        setState(() => _selectedMetricId = id),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // ── Results ────────────────────────────────────────────
          if (_mode == TrackingHistoryMode.all)
            _resultsView == TrackingResultView.table
                ? _EntriesTable(
                    filter: (
                      startDate: _apiDate(_startDate),
                      endDate: _apiDate(_endDate),
                      metricId: null,
                      categoryKey: null,
                    ),
                    showCategory: true,
                    metricLookup: metricLookup,
                  )
                : _MetricChartsSection(
                    categories: categories,
                    granularity: _granularity,
                    showComparison: _showComparison,
                    startDate: _apiDate(_startDate),
                    endDate: _apiDate(_endDate),
                  )
          else if (_mode == TrackingHistoryMode.byCategory)
            if (selectedCat == null)
              Center(
                child: Text(l10n.healthTrackingHistoryNoEntries,
                    style: AppTheme.body
                        .copyWith(color: context.appColors.textMuted)),
              )
            else
              _resultsView == TrackingResultView.table
                  ? _EntriesTable(
                      filter: (
                        startDate: _apiDate(_startDate),
                        endDate: _apiDate(_endDate),
                        metricId: null,
                        categoryKey: selectedCat.categoryKey,
                      ),
                      showCategory: false,
                      metricLookup: metricLookup,
                    )
                  : _MetricChartsSection(
                      categories: [selectedCat],
                      granularity: _granularity,
                      showComparison: _showComparison,
                      startDate: _apiDate(_startDate),
                      endDate: _apiDate(_endDate),
                    )
          else if (_mode == TrackingHistoryMode.byMetric)
            if (validMetricId == null)
              Center(
                child: Text(l10n.healthTrackingSelectMetric,
                    style: AppTheme.body
                        .copyWith(color: context.appColors.textMuted)),
              )
            else
              _resultsView == TrackingResultView.chart
                  ? Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color:
                              Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      clipBehavior: Clip.none,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: HealthTrackingChart(
                          metricId: validMetricId,
                          metricName: catMetrics
                              .firstWhere(
                                  (m) => m.metricId == validMetricId)
                              .displayName,
                          metricType: catMetrics
                              .firstWhere(
                                  (m) => m.metricId == validMetricId)
                              .metricType,
                          unit: catMetrics
                              .firstWhere(
                                  (m) => m.metricId == validMetricId)
                              .unit,
                          granularity: _granularity,
                          showComparison: _showComparison,
                          startDate: _apiDate(_startDate),
                          endDate: _apiDate(_endDate),
                        ),
                      ),
                    )
                  : _RecentEntries(metricId: validMetricId),
        ],
        ),
        );
      },
    );
  }
}

// ── Compact date chip button ──────────────────────────────────────────────────

class _CompactDateChip extends StatelessWidget {
  const _CompactDateChip({
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
                  colorScheme: theme.colorScheme
                      .copyWith(primary: AppTheme.primary),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
          if (picked != null) onChanged(picked);
        },
        icon: const Icon(Icons.calendar_today_outlined, size: 14),
        label: Text('$label: ${fmt.format(value)}',
            style: AppTheme.captions),
        style: OutlinedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          side: BorderSide(color: context.appColors.divider),
          foregroundColor: context.appColors.textPrimary,
        ),
      ),
    );
  }
}

// ── Entries table (all / byCategory modes) ────────────────────────────────────

class _EntriesTable extends ConsumerWidget {
  const _EntriesTable({
    required this.filter,
    required this.showCategory,
    required this.metricLookup,
  });

  final ({
    String? startDate,
    String? endDate,
    int? metricId,
    String? categoryKey,
  }) filter;
  final bool showCategory;
  final Map<int, ({String metricName, String categoryName})> metricLookup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entriesAsync = ref.watch(trackingEntriesFilteredProvider(filter));
    final fmt = DateFormat('MMM d, yyyy');

    return entriesAsync.when(
      loading: () => const AppLoadingIndicator(centered: false),
      error: (_, __) => Center(
        child: Text(l10n.healthTrackingMetricsError,
            style:
                AppTheme.body.copyWith(color: context.appColors.textMuted)),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(l10n.healthTrackingHistoryNoEntries,
                  style: AppTheme.body
                      .copyWith(color: context.appColors.textMuted)),
            ),
          );
        }

        // Sort descending by date, cap at 100 rows.
        final sorted = [...entries]
          ..sort((a, b) => b.entryDate.compareTo(a.entryDate));
        final truncated = sorted.length > 100;
        final rows = sorted.length > 100 ? sorted.sublist(0, 100) : sorted;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (truncated)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  context.l10n.healthTrackingHistoryTruncated,
                  style: AppTheme.captions
                      .copyWith(color: context.appColors.textMuted),
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
                    label: Text(l10n.commonDate,
                        style: AppTheme.captions.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.appColors.textPrimary)),
                  ),
                  if (showCategory)
                    DataColumn(
                      label: Text(l10n.healthTrackingCategory,
                          style: AppTheme.captions.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.appColors.textPrimary)),
                    ),
                  DataColumn(
                    label: Text(l10n.healthTrackingMetric,
                        style: AppTheme.captions.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.appColors.textPrimary)),
                  ),
                  DataColumn(
                    label: Text(l10n.healthTrackingValueColumn,
                        style: AppTheme.captions.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.appColors.textPrimary)),
                  ),
                ],
                rows: [
                  for (final entry in rows)
                    DataRow(cells: [
                      DataCell(Text(fmt.format(entry.entryDate),
                          style: AppTheme.captions.copyWith(
                              color: context.appColors.textMuted))),
                      if (showCategory)
                        DataCell(Text(
                          metricLookup[entry.metricId]?.categoryName ?? '—',
                          style: AppTheme.body.copyWith(
                              color: context.appColors.textPrimary),
                        )),
                      DataCell(Text(
                        metricLookup[entry.metricId]?.metricName ?? '—',
                        style: AppTheme.body
                            .copyWith(color: context.appColors.textPrimary),
                      )),
                      DataCell(Text(entry.value,
                          style: AppTheme.body.copyWith(
                              color: context.appColors.textPrimary))),
                    ]),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Metric charts section ─────────────────────────────────────────────────────
// Charts scale, number, and yesno metrics (single_choice / text can't be
// charted meaningfully). yesno values are mapped yes→1 / no→0 in the chart.

class _MetricChartsSection extends StatelessWidget {
  const _MetricChartsSection({
    required this.categories,
    this.granularity = TrackingDisplayGranularity.daily,
    this.showComparison = false,
    this.startDate,
    this.endDate,
  });

  final List<TrackingCategory> categories;
  final TrackingDisplayGranularity granularity;
  final bool showComparison;
  final String? startDate;
  final String? endDate;

  @override
  Widget build(BuildContext context) {
    // Collect all chartable active metrics, capped at 12 to avoid overload.
    final metrics = <TrackingMetric>[];
    for (final cat in categories) {
      metrics.addAll(cat.metrics.where(
        (m) => m.isActive &&
            (m.metricType == 'scale' ||
             m.metricType == 'number' ||
             m.metricType == 'yesno'),
      ));
    }
    if (metrics.isEmpty) return const SizedBox.shrink();
    final capped = metrics.length > 12 ? metrics.sublist(0, 12) : metrics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.healthTrackingCharts,
          style: AppTheme.heading5
              .copyWith(color: context.appColors.textPrimary),
        ),
        const SizedBox(height: 12),
        for (final metric in capped) ...[
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            clipBehavior: Clip.none,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: HealthTrackingChart(
                key: ValueKey('${metric.metricId}-$granularity-$showComparison'),
                metricId: metric.metricId,
                metricName: metric.displayName,
                metricType: metric.metricType,
                unit: metric.unit,
                granularity: granularity,
                showComparison: showComparison,
                startDate: startDate,
                endDate: endDate,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

// ── Recent entries ────────────────────────────────────────────────────────────

class _RecentEntries extends ConsumerWidget {
  const _RecentEntries({required this.metricId});

  final int metricId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final historyAsync = ref.watch(trackingHistoryProvider(metricId));
    final fmt = DateFormat('MMM d, yyyy');

    return historyAsync.when(
      loading: () => const AppLoadingIndicator(centered: false),
      error: (_, __) => const SizedBox.shrink(),
      data: (entries) {
        if (entries.isEmpty) return const SizedBox.shrink();
        final recent =
            entries.length > 10 ? entries.sublist(0, 10) : entries;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.healthTrackingRecentEntries,
                style: AppTheme.heading5
                    .copyWith(color: context.appColors.textPrimary)),
            const SizedBox(height: 8),
            for (final entry in recent)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(fmt.format(entry.entryDate),
                        style: AppTheme.captions
                            .copyWith(color: context.appColors.textMuted)),
                    const SizedBox(width: 16),
                    Text(entry.value,
                        style: AppTheme.body.copyWith(
                            color: context.appColors.textPrimary)),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
