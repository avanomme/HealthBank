// Created with the Assistance of Claude Code
// frontend/lib/src/features/researcher/pages/researcher_health_tracking_page.dart
/// Researcher health tracking analytics page.
///
/// Full multi-metric filter panel: pick any mix of metrics across categories,
/// date range, then load per-metric chart cards. Each card has its own chart
/// type toggle. Export respects the current filter selection.
library;

import 'csv_download_stub.dart'
    if (dart.library.js_interop) 'csv_download_web.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_data_table.dart';
import 'package:frontend/src/core/widgets/data_display/app_line_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/data_display/data_table_cell.dart';
import 'package:frontend/src/core/widgets/feedback/app_loading_indicator.dart';
import 'package:frontend/src/core/widgets/forms/app_date_input.dart';
import 'package:frontend/src/features/researcher/state/health_tracking_research_providers.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:intl/intl.dart';

// ── Page wrapper ──────────────────────────────────────────────────────────────

/// Page entry point for the researcher health tracking analytics view.
///
/// Wraps [_HealthTrackingBody] inside the researcher scaffold with compact alignment.
class ResearcherHealthTrackingPage extends ConsumerWidget {
  const ResearcherHealthTrackingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ResearcherScaffold(
      currentRoute: '/researcher/data',
      alignment: AppPageAlignment.compact,
      scrollable: true,
      showFooter: false,
      child: ResearcherHealthTrackingContent(),
    );
  }
}

// ── Main content ──────────────────────────────────────────────────────────────

class ResearcherHealthTrackingContent extends ConsumerStatefulWidget {
  const ResearcherHealthTrackingContent({super.key});

  @override
  ConsumerState<ResearcherHealthTrackingContent> createState() =>
      _ResearcherHealthTrackingContentState();
}

class _ResearcherHealthTrackingContentState
    extends ConsumerState<ResearcherHealthTrackingContent> {
  // ── Filter state ─────────────────────────────────────────────────────────
  Set<int> _selectedMetricIds = {};
  Set<String> _expandedCategories = {};
  bool _filterExpanded = false;
  bool _metricsInitialised = false;

  // ── Date range ────────────────────────────────────────────────────────────
  DateTime? _startDate;
  DateTime? _endDate;
  bool _dateRangeInitialised = false;

  // ── Loaded charts ─────────────────────────────────────────────────────────
  ({String metricIds, String startDate, String endDate})? _loadedParams;

  // ── Granularity ───────────────────────────────────────────────────────────
  _Granularity _granularity = _Granularity.daily;

  bool _exporting = false;

  static final _apiDateFmt = DateFormat('yyyy-MM-dd');
  static final _displayDateFmt = DateFormat('MMM d, yyyy');

  String _fmt(DateTime d) => _apiDateFmt.format(d);
  String _displayDate(DateTime d) => _displayDateFmt.format(d);

  void _maybeInitDateRange(EntryDateRange range) {
    if (_dateRangeInitialised) return;
    _dateRangeInitialised = true;
    final now = DateTime.now();
    setState(() {
      _startDate = range.minDate != null
          ? DateTime.parse(range.minDate!)
          : now.subtract(const Duration(days: 365));
      _endDate = range.maxDate != null ? DateTime.parse(range.maxDate!) : now;
    });
  }

  void _maybeInitMetrics(List<TrackingCategory> categories) {
    if (_metricsInitialised) return;
    _metricsInitialised = true;
    setState(() {
      _selectedMetricIds = {
        for (final cat in categories)
          for (final m in cat.metrics)
            if (m.isActive) m.metricId,
      };
      // All categories start collapsed for a clean initial view.
      _expandedCategories = {};
    });
  }

  // ── Category helpers ──────────────────────────────────────────────────────

  List<TrackingMetric> _activeMetrics(TrackingCategory cat) =>
      cat.metrics.where((m) => m.isActive).toList();

  bool _catAllSelected(TrackingCategory cat) {
    final active = _activeMetrics(cat);
    return active.isNotEmpty &&
        active.every((m) => _selectedMetricIds.contains(m.metricId));
  }

  bool _catNoneSelected(TrackingCategory cat) =>
      !_activeMetrics(cat).any((m) => _selectedMetricIds.contains(m.metricId));

  int _catSelectedCount(TrackingCategory cat) => _activeMetrics(
    cat,
  ).where((m) => _selectedMetricIds.contains(m.metricId)).length;

  void _toggleCategoryCheckbox(TrackingCategory cat) {
    setState(() {
      final ids = _activeMetrics(cat).map((m) => m.metricId);
      if (_catAllSelected(cat)) {
        _selectedMetricIds.removeAll(ids);
      } else {
        _selectedMetricIds.addAll(ids);
      }
    });
  }

  void _toggleMetric(int id) {
    setState(() {
      if (_selectedMetricIds.contains(id)) {
        _selectedMetricIds.remove(id);
      } else {
        _selectedMetricIds.add(id);
      }
    });
  }

  void _selectAll(List<TrackingCategory> categories) {
    setState(() {
      _selectedMetricIds = {
        for (final cat in categories)
          for (final m in cat.metrics)
            if (m.isActive) m.metricId,
      };
    });
  }

  void _clearAll() => setState(() => _selectedMetricIds.clear());

  void _toggleCategoryExpand(String key) {
    setState(() {
      if (_expandedCategories.contains(key)) {
        _expandedCategories.remove(key);
      } else {
        _expandedCategories.add(key);
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final dateRangeAsync = ref.watch(researchEntryDateRangeProvider);
    dateRangeAsync.whenData(_maybeInitDateRange);

    final metricsAsync = ref.watch(researchTrackingMetricsProvider);

    final startDate =
        _startDate ?? DateTime.now().subtract(const Duration(days: 365));
    final endDate = _endDate ?? DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const SizedBox(height: 24),

          // ── Title ─────────────────────────────────────────────────────
          Semantics(
            header: true,
            child: Text(
              l10n.healthTrackingResearchTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.healthTrackingResearchDeepDive,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          ),
          const SizedBox(height: 24),
          Divider(color: context.appColors.divider),
          const SizedBox(height: 20),

          // ── Filter panel + charts ─────────────────────────────────────
          metricsAsync.when(
            loading: () => const AppLoadingIndicator(),
            error: (err, _) => _ErrorText(message: err.toString()),
            data: (categories) {
              _maybeInitMetrics(categories);

              final totalMetrics = categories.fold<int>(
                0,
                (s, c) => s + _activeMetrics(c).length,
              );
              final selectedCount = _selectedMetricIds.length;

              // Flat lookup for chart cards.
              final metricLookup = <int, TrackingMetric>{
                for (final cat in categories)
                  for (final m in cat.metrics) m.metricId: m,
              };

              final sortedIds = _selectedMetricIds.toList()..sort();
              final canLoad = sortedIds.isNotEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Filter card ──────────────────────────────────────
                  _FilterCard(
                    filterExpanded: _filterExpanded,
                    selectedCount: selectedCount,
                    totalMetrics: totalMetrics,
                    startDate: startDate,
                    endDate: endDate,
                    displayDate: _displayDate,
                    onToggleExpand: () =>
                        setState(() => _filterExpanded = !_filterExpanded),
                    filterBody: _filterExpanded
                        ? _buildFilterBody(
                            context,
                            l10n,
                            categories,
                            totalMetrics,
                            startDate,
                            endDate,
                            canLoad,
                            sortedIds,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Load Charts + Granularity + Export buttons ────────
                  Semantics(
                    label: l10n.healthTrackingGranularityLabel,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Tooltip(
                          message: canLoad
                              ? ''
                              : l10n.healthTrackingSelectMetricsHint,
                          child: AppFilledButton(
                            label: l10n.healthTrackingLoadChart,
                            onPressed: canLoad
                                ? () => setState(() {
                                    _loadedParams = (
                                      metricIds: sortedIds.join(','),
                                      startDate: _fmt(startDate),
                                      endDate: _fmt(endDate),
                                    );
                                    _filterExpanded = false;
                                  })
                                : null,
                          ),
                        ),
                        SegmentedButton<_Granularity>(
                          segments: [
                            ButtonSegment(
                              value: _Granularity.daily,
                              label: Text(l10n.healthTrackingGranularityDaily),
                            ),
                            ButtonSegment(
                              value: _Granularity.weekly,
                              label: Text(l10n.healthTrackingGranularityWeekly),
                            ),
                            ButtonSegment(
                              value: _Granularity.monthly,
                              label: Text(
                                l10n.healthTrackingGranularityMonthly,
                              ),
                            ),
                          ],
                          selected: {_granularity},
                          onSelectionChanged: (s) =>
                              setState(() => _granularity = s.first),
                          style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            side: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return const BorderSide(
                                  color: AppTheme.primary,
                                );
                              }
                              return const BorderSide(
                                color: AppTheme.primary,
                                width: 0.5,
                              );
                            }),
                            backgroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return AppTheme.primary.withValues(alpha: 0.15);
                              }
                              return Colors.transparent;
                            }),
                            foregroundColor: WidgetStateProperty.all(
                              AppTheme.primary,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: _selectedMetricIds.isEmpty
                              ? l10n.healthTrackingSelectMetricsHint
                              : '',
                          child: AppFilledButton(
                            label: _exporting
                                ? l10n.healthTrackingExporting
                                : l10n.healthTrackingExportFiltered,
                            backgroundColor: AppTheme.success,
                            textColor: AppTheme.textContrast,
                            onPressed:
                                (_exporting || _selectedMetricIds.isEmpty)
                                ? null
                                : _handleExport,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Per-metric chart cards ────────────────────────────
                  if (_loadedParams != null)
                    _PerMetricCharts(
                      params: _loadedParams!,
                      metricLookup: metricLookup,
                      granularity: _granularity,
                    ),
                ],
              );
            },
          ),

          const SizedBox(height: 40),
        ],
    );
  }

  Widget _buildFilterBody(
    BuildContext context,
    dynamic l10n,
    List<TrackingCategory> categories,
    int totalMetrics,
    DateTime startDate,
    DateTime endDate,
    bool canLoad,
    List<int> sortedIds,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Date range row ──────────────────────────────────────────
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 200,
              child: AppDateInput(
                label: l10n.commonStartDate,
                value: startDate,
                onChanged: (d) {
                  if (d != null) {
                    setState(() {
                      _startDate = d;
                      _loadedParams = null;
                    });
                  }
                },
                isRequired: false,
                lastDate: endDate,
              ),
            ),
            SizedBox(
              width: 200,
              child: AppDateInput(
                label: l10n.commonEndDate,
                value: endDate,
                onChanged: (d) {
                  if (d != null) {
                    setState(() {
                      _endDate = d;
                      _loadedParams = null;
                    });
                  }
                },
                isRequired: false,
                firstDate: startDate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Metrics header ──────────────────────────────────────────
        Row(
          children: [
            Text(
              l10n.healthTrackingSelectMetrics,
              style: AppTheme.body.copyWith(
                fontWeight: FontWeight.w600,
                color: context.appColors.textPrimary,
              ),
            ),
            const Spacer(),
            AppTextButton(
              label: l10n.healthTrackingSelectAllMetrics,
              onPressed: () => _selectAll(categories),
            ),
            const SizedBox(width: 4),
            AppTextButton(
              label: l10n.healthTrackingClearAllMetrics,
              onPressed: _selectedMetricIds.isEmpty ? null : _clearAll,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Divider(color: context.appColors.divider, height: 1),
        const SizedBox(height: 4),

        // ── Category rows ───────────────────────────────────────────
        for (final cat in categories)
          _CategorySection(
            cat: cat,
            activeMetrics: _activeMetrics(cat),
            selectedCount: _catSelectedCount(cat),
            allSelected: _catAllSelected(cat),
            noneSelected: _catNoneSelected(cat),
            isExpanded: _expandedCategories.contains(cat.categoryKey),
            selectedMetricIds: _selectedMetricIds,
            onToggleCheckbox: () => _toggleCategoryCheckbox(cat),
            onToggleExpand: () => _toggleCategoryExpand(cat.categoryKey),
            onToggleMetric: _toggleMetric,
          ),
      ],
    );
  }

  Future<void> _handleExport() async {
    if (_exporting || _selectedMetricIds.isEmpty) return;
    setState(() => _exporting = true);
    final startDate =
        _startDate ?? DateTime.now().subtract(const Duration(days: 365));
    final endDate = _endDate ?? DateTime.now();
    final ids = _selectedMetricIds.isNotEmpty
        ? _selectedMetricIds.join(',')
        : null;

    try {
      final api = ref.read(healthTrackingResearchApiProvider);
      final csv = await api.exportHealthTrackingCsv(
        startDate: _fmt(startDate),
        endDate: _fmt(endDate),
        metricIds: ids,
      );
      downloadCsvFile(csv, 'health_tracking_export.csv');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.healthTrackingExportError(e.toString())),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

// ── Filter card (expand/collapse shell) ───────────────────────────────────────

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.filterExpanded,
    required this.selectedCount,
    required this.totalMetrics,
    required this.startDate,
    required this.endDate,
    required this.displayDate,
    required this.onToggleExpand,
    required this.filterBody,
  });

  final bool filterExpanded;
  final int selectedCount;
  final int totalMetrics;
  final DateTime startDate;
  final DateTime endDate;
  final String Function(DateTime) displayDate;
  final VoidCallback onToggleExpand;
  final Widget? filterBody;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summaryText = totalMetrics == 0
        ? ''
        : l10n.healthTrackingXofYMetrics(selectedCount, totalMetrics);
    final dateText = '${displayDate(startDate)} – ${displayDate(endDate)}';

    return Material(
      color: context.appColors.surfaceSubtle,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────
            Semantics(
              button: true,
              label: filterExpanded
                  ? l10n.healthTrackingHideFilters
                  : l10n.healthTrackingShowFilters,
              child: InkWell(
                onTap: onToggleExpand,
                borderRadius: filterExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(12))
                    : BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        filterExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.healthTrackingFilters,
                        style: AppTheme.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (totalMetrics > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: selectedCount == 0
                                ? AppTheme.error.withValues(alpha: 0.12)
                                : AppTheme.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            summaryText,
                            style: AppTheme.captions.copyWith(
                              color: selectedCount == 0
                                  ? AppTheme.error
                                  : AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '·',
                          style: AppTheme.captions.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            dateText,
                            style: AppTheme.captions.copyWith(
                              color: context.appColors.textMuted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ── Body ───────────────────────────────────────────────
            if (filterBody != null) ...[
              Divider(height: 1, color: context.appColors.divider),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: filterBody!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Category section ──────────────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.cat,
    required this.activeMetrics,
    required this.selectedCount,
    required this.allSelected,
    required this.noneSelected,
    required this.isExpanded,
    required this.selectedMetricIds,
    required this.onToggleCheckbox,
    required this.onToggleExpand,
    required this.onToggleMetric,
  });

  final TrackingCategory cat;
  final List<TrackingMetric> activeMetrics;
  final int selectedCount;
  final bool allSelected;
  final bool noneSelected;
  final bool isExpanded;
  final Set<int> selectedMetricIds;
  final VoidCallback onToggleCheckbox;
  final VoidCallback onToggleExpand;
  final void Function(int) onToggleMetric;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final countLabel = '$selectedCount/${activeMetrics.length}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Category header row ─────────────────────────────────────
        Row(
          children: [
            Semantics(
              label: l10n.healthTrackingSelectCategoryAll,
              child: Checkbox(
                value: allSelected ? true : (noneSelected ? false : null),
                tristate: true,
                onChanged: (_) => onToggleCheckbox(),
                activeColor: AppTheme.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            Expanded(
              child: Text(
                cat.displayName,
                style: AppTheme.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.appColors.textPrimary,
                ),
              ),
            ),
            // Count badge
            Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: noneSelected
                    ? context.appColors.divider
                    : allSelected
                    ? AppTheme.primary.withValues(alpha: 0.12)
                    : AppTheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                countLabel,
                style: AppTheme.captions.copyWith(
                  color: noneSelected
                      ? context.appColors.textMuted
                      : allSelected
                      ? AppTheme.primary
                      : AppTheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Expand/collapse
            Tooltip(
              message: isExpanded
                  ? l10n.healthTrackingCollapseCategory
                  : l10n.healthTrackingExpandCategory,
              child: InkWell(
                onTap: onToggleExpand,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: context.appColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Metric chips (when expanded) ────────────────────────────
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 4),
            child: activeMetrics.isEmpty
                ? Text(
                    '—',
                    style: AppTheme.captions.copyWith(
                      color: context.appColors.textMuted,
                    ),
                  )
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final m in activeMetrics)
                        _MetricChip(
                          metric: m,
                          selected: selectedMetricIds.contains(m.metricId),
                          onToggle: () => onToggleMetric(m.metricId),
                        ),
                    ],
                  ),
          ),

        const SizedBox(height: 2),
      ],
    );
  }
}

// ── Metric chip ───────────────────────────────────────────────────────────────

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.metric,
    required this.selected,
    required this.onToggle,
  });

  final TrackingMetric metric;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final label = metric.unit != null && metric.unit!.isNotEmpty
        ? '${metric.displayName} (${metric.unit})'
        : metric.displayName;

    return FilterChip(
      label: Text(
        label,
        style: AppTheme.captions.copyWith(
          color: selected ? AppTheme.primary : context.appColors.textMuted,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: selected,
      onSelected: (_) => onToggle(),
      selectedColor: AppTheme.primary.withValues(alpha: 0.12),
      backgroundColor: context.appColors.surfaceSubtle,
      checkmarkColor: AppTheme.primary,
      showCheckmark: true,
      side: BorderSide(
        color: selected
            ? AppTheme.primary.withValues(alpha: 0.4)
            : context.appColors.divider,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

// ── Granularity enum ─────────────────────────────────────────────────────────

enum _Granularity { daily, weekly, monthly }

// ── Per-metric chart cards ────────────────────────────────────────────────────

enum _HtChartType { line, bar, pie, table }

class _PerMetricCharts extends ConsumerStatefulWidget {
  const _PerMetricCharts({
    required this.params,
    required this.metricLookup,
    required this.granularity,
  });

  final ({String metricIds, String startDate, String endDate}) params;
  final Map<int, TrackingMetric> metricLookup;
  final _Granularity granularity;

  @override
  ConsumerState<_PerMetricCharts> createState() => _PerMetricChartsState();
}

class _PerMetricChartsState extends ConsumerState<_PerMetricCharts> {
  final Map<int, _HtChartType> _overrides = {};

  static _HtChartType _defaultType(String metricType) => switch (metricType) {
    'yesno' => _HtChartType.pie,
    'single_choice' => _HtChartType.bar,
    'text' => _HtChartType.table,
    _ => _HtChartType.line,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(researchMultiAggregateProvider(widget.params));

    return async.when(
      loading: () => const AppLoadingIndicator(),
      error: (err, _) => _ErrorText(message: err.toString()),
      data: (results) {
        final withData = results.where((r) => r.data.isNotEmpty).toList();

        if (withData.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.healthTrackingResearchNoData,
              style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < withData.length; i++) ...[
              _MetricChartCard(
                result: withData[i],
                metricType:
                    widget.metricLookup[withData[i].metricId]?.metricType ??
                    'number',
                unit: widget.metricLookup[withData[i].metricId]?.unit,
                colorIndex: i,
                granularity: widget.granularity,
                chartType:
                    _overrides[withData[i].metricId] ??
                    _defaultType(
                      widget.metricLookup[withData[i].metricId]?.metricType ??
                          'number',
                    ),
                onChartTypeChanged: (t) =>
                    setState(() => _overrides[withData[i].metricId] = t),
              ),
              const SizedBox(height: 16),
            ],
          ],
        );
      },
    );
  }
}

// ── Individual metric chart card ──────────────────────────────────────────────

class _MetricChartCard extends StatelessWidget {
  const _MetricChartCard({
    required this.result,
    required this.metricType,
    required this.chartType,
    required this.onChartTypeChanged,
    required this.colorIndex,
    required this.granularity,
    this.unit,
  });

  final MultiAggregateResult result;
  final String metricType;
  final String? unit;
  final int colorIndex;
  final _HtChartType chartType;
  final _Granularity granularity;
  final void Function(_HtChartType) onChartTypeChanged;

  @override
  Widget build(BuildContext context) {
    final title = unit != null && unit!.isNotEmpty
        ? '${result.metricName} ($unit)'
        : result.metricName;

    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header — colour cycles through the chart palette ──
          Container(
            color: AppLineChart
                .defaultColors[colorIndex % AppLineChart.defaultColors.length],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.metricName,
                        style: AppTheme.body.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        result.categoryName,
                        style: AppTheme.captions.copyWith(
                          color: AppTheme.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                _ChartTypeToggle(
                  current: chartType,
                  metricType: metricType,
                  onChanged: onChartTypeChanged,
                ),
              ],
            ),
          ),

          // ── Chart body ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildChart(context, title),
          ),
        ],
      ),
    );
  }

  /// Aggregate daily data points into weekly or monthly buckets.
  Map<String, double> _aggregateData(List<AggregateDataPoint> points) {
    if (granularity == _Granularity.daily) {
      final fmt = DateFormat('MM/dd/yy');
      return {for (final p in points) fmt.format(p.entryDate): p.avgValue};
    }

    // Group by week (yyyy-ww) or month (yyyy-MM), then average within bucket.
    final grouped = <String, List<double>>{};
    for (final p in points) {
      final key = granularity == _Granularity.weekly
          ? '${p.entryDate.year}-W${_isoWeek(p.entryDate).toString().padLeft(2, '0')}'
          : DateFormat('yyyy-MM').format(p.entryDate);
      grouped.putIfAbsent(key, () => []).add(p.avgValue);
    }
    return {
      for (final e in grouped.entries)
        e.key: e.value.reduce((a, b) => a + b) / e.value.length,
    };
  }

  /// ISO week number (1–53).
  static int _isoWeek(DateTime d) {
    final thursday = d.add(
      Duration(days: 4 - (d.weekday == 7 ? 0 : d.weekday)),
    );
    final firstThursday = DateTime(thursday.year, 1, 1).add(
      Duration(
        days:
            (4 -
                    (DateTime(thursday.year, 1, 1).weekday == 7
                        ? 0
                        : DateTime(thursday.year, 1, 1).weekday))
                .clamp(-6, 0),
      ),
    );
    return ((thursday.difference(firstThursday).inDays) / 7).floor() + 1;
  }

  Widget _buildChart(BuildContext context, String title) {
    final l10n = context.l10n;
    final points = result.data;
    final cardColor = AppLineChart
        .defaultColors[colorIndex % AppLineChart.defaultColors.length];

    if (chartType == _HtChartType.pie) {
      return _buildPieChart('');
    }
    if (chartType == _HtChartType.table) {
      return _buildTable(context, l10n, points);
    }

    final data = _aggregateData(points);
    final dataPointCount = data.length;

    return switch (chartType) {
      _HtChartType.line => _HorizScrollChart(
        dataPointCount: dataPointCount,
        child: AppLineChart(
          title: '',
          series: [
            LineSeries(label: result.metricName, color: cardColor, data: data),
          ],
          height: 280,
        ),
      ),
      _HtChartType.bar => _HorizScrollChart(
        dataPointCount: dataPointCount,
        child: AppBarChart(
          title: '',
          barColor: cardColor,
          data: data,
          height: 260,
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildPieChart(String title) {
    if (result.data.isEmpty) {
      return AppPieChart(title: title, data: const {});
    }
    final avgYesRate =
        result.data.map((p) => p.avgValue).reduce((a, b) => a + b) /
        result.data.length;
    final yesPct = (avgYesRate * 100).clamp(0.0, 100.0);
    return AppPieChart(
      title: title,
      data: {'Yes': yesPct, 'No': 100 - yesPct},
      height: 260,
    );
  }

  Widget _buildTable(
    BuildContext context,
    dynamic l10n,
    List<AggregateDataPoint> points,
  ) {
    final dateFmt = DateFormat('yyyy-MM-dd');
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: AppDataTable<AggregateDataPoint>(
        headingTextColor: AppTheme.white,
        columns: [
          AppTableColumn<AggregateDataPoint>(
            header: l10n.commonDate,
            sortKey: (p) => p.entryDate.millisecondsSinceEpoch,
            cellBuilder: (p) => DataTableCell.text(dateFmt.format(p.entryDate)),
          ),
          AppTableColumn<AggregateDataPoint>(
            header: l10n.healthTrackingAvgValue,
            sortKey: (p) => p.avgValue,
            cellBuilder: (p) =>
                DataTableCell.text(p.avgValue.toStringAsFixed(2)),
          ),
          AppTableColumn<AggregateDataPoint>(
            header: l10n.healthTrackingParticipants,
            sortKey: (p) => p.participantCount,
            cellBuilder: (p) => DataTableCell.text('${p.participantCount}'),
          ),
        ],
        items: points,
      ),
    );
  }
}

// ── Chart type toggle ─────────────────────────────────────────────────────────

class _ChartTypeToggle extends StatelessWidget {
  const _ChartTypeToggle({
    required this.current,
    required this.metricType,
    required this.onChanged,
  });

  final _HtChartType current;
  final String metricType;
  final void Function(_HtChartType) onChanged;

  bool get _showPie => metricType == 'yesno';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ToggleBtn(
          icon: Icons.show_chart_rounded,
          tooltip: context.l10n.tooltipLineChart,
          selected: current == _HtChartType.line,
          onTap: () => onChanged(_HtChartType.line),
        ),
        const SizedBox(width: 4),
        _ToggleBtn(
          icon: Icons.bar_chart_rounded,
          tooltip: context.l10n.tooltipBarChart,
          selected: current == _HtChartType.bar,
          onTap: () => onChanged(_HtChartType.bar),
        ),
        if (_showPie) ...[
          const SizedBox(width: 4),
          _ToggleBtn(
            icon: Icons.pie_chart_outline_rounded,
            tooltip: context.l10n.tooltipPieChart,
            selected: current == _HtChartType.pie,
            onTap: () => onChanged(_HtChartType.pie),
          ),
        ],
        const SizedBox(width: 4),
        _ToggleBtn(
          icon: Icons.table_rows_outlined,
          tooltip: context.l10n.tooltipTableView,
          selected: current == _HtChartType.table,
          onTap: () => onChanged(_HtChartType.table),
        ),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({
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
    return Semantics(
      button: true,
      selected: selected,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: selected
                  ? AppTheme.white.withValues(alpha: 0.25)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: selected
                    ? AppTheme.white.withValues(alpha: 0.6)
                    : Colors.transparent,
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: selected
                  ? AppTheme.white
                  : AppTheme.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Horizontal-scroll chart wrapper ──────────────────────────────────────────

class _HorizScrollChart extends StatefulWidget {
  const _HorizScrollChart({required this.child, required this.dataPointCount});

  final Widget child;
  final int dataPointCount;

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
        if (requiredWidth <= constraints.maxWidth) return widget.child;
        return Scrollbar(
          controller: _controller,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: requiredWidth, child: widget.child),
          ),
        );
      },
    );
  }
}

// ── Shared ────────────────────────────────────────────────────────────────────

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.commonErrorWithDetail(message),
      style: AppTheme.body.copyWith(color: AppTheme.error),
    );
  }
}
