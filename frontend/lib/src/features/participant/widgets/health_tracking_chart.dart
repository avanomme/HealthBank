// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/health_tracking_chart.dart
/// Chart widget that visualises a single metric's historical entries.
///
/// Supports three chart kinds selectable by the user:
///   • Line  — best for scale metrics (shows trend over time)
///   • Bar   — best for number metrics (shows magnitude per date)
///   • Pie   — best for yesno metrics (shows yes/no distribution)
///
/// Supports optional granularity grouping (daily/weekly/monthly) and
/// an optional comparison series showing the k-anonymized population average.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_line_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/data_display/tracking_controls_bar.dart';
import 'package:frontend/src/core/widgets/feedback/app_loading_indicator.dart';
import 'package:frontend/src/features/participant/state/health_tracking_providers.dart';
import 'package:intl/intl.dart';

enum _ChartKind { line, bar, pie }

/// Chart widget for a participant's historical metric data.
///
/// Renders a line, bar, or pie chart based on the selected [_ChartKind].
/// Optionally overlays a population-average comparison series.
class HealthTrackingChart extends ConsumerStatefulWidget {
  const HealthTrackingChart({
    super.key,
    required this.metricId,
    required this.metricName,
    this.metricType,
    this.unit,
    this.granularity = TrackingDisplayGranularity.daily,
    this.showComparison = false,
    this.startDate,
    this.endDate,
  });

  final int metricId;
  final String metricName;

  /// MetricType string from the model ('scale', 'number', 'yesno', etc.).
  /// Used to pick the default chart kind.
  final String? metricType;
  final String? unit;

  /// Granularity for chart grouping (daily/weekly/monthly).
  final TrackingDisplayGranularity granularity;

  /// Whether to show population aggregate as a second series.
  final bool showComparison;

  /// Optional date range for filtered history (yyyy-MM-dd). When provided,
  /// `trackingEntriesFilteredProvider` is used instead of `trackingHistoryProvider`.
  final String? startDate;
  final String? endDate;

  @override
  ConsumerState<HealthTrackingChart> createState() =>
      _HealthTrackingChartState();
}

class _HealthTrackingChartState extends ConsumerState<HealthTrackingChart> {
  late _ChartKind _kind;

  @override
  void initState() {
    super.initState();
    _kind = _defaultKind(widget.metricType);
  }

  @override
  void didUpdateWidget(HealthTrackingChart old) {
    super.didUpdateWidget(old);
    if (old.metricType != widget.metricType) {
      _kind = _defaultKind(widget.metricType);
    }
  }

  static _ChartKind _defaultKind(String? type) {
    switch (type) {
      case 'yesno':
        return _ChartKind.pie;
      case 'number':
        return _ChartKind.bar;
      default:
        return _ChartKind.line;
    }
  }

  // ── ISO week helper ─────────────────────────────────────────────────────────
  static int _isoWeek(DateTime d) {
    final dayOfYear = d.difference(DateTime(d.year, 1, 1)).inDays + 1;
    return ((dayOfYear - d.weekday + 10) / 7).floor();
  }

  // ── Granularity aggregation ─────────────────────────────────────────────────
  static double? _parseValue(String raw) {
    final v = raw.trim().toLowerCase();
    if (v == 'yes') return 1.0;
    if (v == 'no') return 0.0;
    return double.tryParse(v);
  }

  Map<String, double> _aggregateEntries(List<TrackingEntry> entries) {
    final sorted = [...entries]
      ..sort((a, b) => a.entryDate.compareTo(b.entryDate));

    if (widget.granularity == TrackingDisplayGranularity.daily) {
      final fmt = DateFormat('MM/dd/yy');
      final result = <String, double>{};
      for (final e in sorted) {
        final v = _parseValue(e.value);
        if (v == null) continue;
        result[fmt.format(e.entryDate)] = v;
      }
      return result;
    }

    final groups = <String, List<double>>{};
    for (final e in sorted) {
      final v = _parseValue(e.value);
      if (v == null) continue;
      final key = widget.granularity == TrackingDisplayGranularity.weekly
          ? '${e.entryDate.year}-W${_isoWeek(e.entryDate).toString().padLeft(2, '0')}'
          : DateFormat('yyyy-MM').format(e.entryDate);
      groups.putIfAbsent(key, () => []).add(v);
    }
    return {
      for (final e in groups.entries)
        e.key: e.value.reduce((a, b) => a + b) / e.value.length,
    };
  }

  Map<String, double> _aggregatePopulation(List<AggregateDataPoint> points) {
    if (widget.granularity == TrackingDisplayGranularity.daily) {
      final fmt = DateFormat('MM/dd/yy');
      return {for (final p in points) fmt.format(p.entryDate): p.avgValue};
    }
    final groups = <String, List<double>>{};
    for (final p in points) {
      final key = widget.granularity == TrackingDisplayGranularity.weekly
          ? '${p.entryDate.year}-W${_isoWeek(p.entryDate).toString().padLeft(2, '0')}'
          : DateFormat('yyyy-MM').format(p.entryDate);
      groups.putIfAbsent(key, () => []).add(p.avgValue);
    }
    return {
      for (final e in groups.entries)
        e.key: e.value.reduce((a, b) => a + b) / e.value.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // ── Pick provider based on date range ─────────────────────────────────────
    final AsyncValue<List<TrackingEntry>> entriesAsync;
    if (widget.startDate != null || widget.endDate != null) {
      entriesAsync = ref.watch(trackingEntriesFilteredProvider((
        startDate: widget.startDate,
        endDate: widget.endDate,
        metricId: widget.metricId,
        categoryKey: null,
      )));
    } else {
      entriesAsync = ref.watch(trackingHistoryProvider(widget.metricId));
    }

    return entriesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: AppLoadingIndicator(centered: false)),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            l10n.healthTrackingChartError,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          ),
        ),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                l10n.healthTrackingNoData,
                style: AppTheme.body
                    .copyWith(color: context.appColors.textMuted),
              ),
            ),
          );
        }

        final isYesNo = _isYesNo(entries);
        final timeData = _aggregateEntries(entries);
        final pieData = _buildPieData(entries, isYesNo);

        final entryLabel = l10n.healthTrackingChartEntries(entries.length);
        final subtitle = isYesNo
            ? '$entryLabel  ·  ${l10n.healthTrackingChartYesNoHint}'
            : '$entryLabel${widget.unit != null ? '  ·  ${widget.unit}' : ''}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Chart type toggle ─────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.metricName,
                    style: AppTheme.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ),
                Semantics(
                  label: l10n.healthTrackingChartTypeLabel,
                  child: SegmentedButton<_ChartKind>(
                    segments: [
                      ButtonSegment(
                        value: _ChartKind.line,
                        icon: Tooltip(
                          message: l10n.healthTrackingChartLine,
                          child: const Icon(Icons.show_chart, size: 16),
                        ),
                      ),
                      ButtonSegment(
                        value: _ChartKind.bar,
                        icon: Tooltip(
                          message: l10n.healthTrackingChartBar,
                          child: const Icon(Icons.bar_chart, size: 16),
                        ),
                      ),
                      ButtonSegment(
                        value: _ChartKind.pie,
                        icon: Tooltip(
                          message: l10n.healthTrackingChartPie,
                          child: const Icon(Icons.pie_chart_outline, size: 16),
                        ),
                      ),
                    ],
                    selected: {_kind},
                    onSelectionChanged: (s) =>
                        setState(() => _kind = s.first),
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      textStyle: WidgetStatePropertyAll(AppTheme.captions),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Chart area ────────────────────────────────────────────
            if (_kind == _ChartKind.pie)
              AppPieChart(
                title: '',
                data: pieData,
                height: 200,
              )
            else if (widget.showComparison && _kind == _ChartKind.line)
              _ComparisonLineChart(
                metricId: widget.metricId,
                metricName: widget.metricName,
                myData: timeData,
                startDate: widget.startDate,
                endDate: widget.endDate,
                granularity: widget.granularity,
                aggregatePopulation: _aggregatePopulation,
              )
            else if (_kind == _ChartKind.bar)
              _HorizScrollChart(
                dataPointCount: timeData.length,
                child: AppBarChart(
                  title: '',
                  data: timeData,
                  height: 200,
                ),
              )
            else
              _HorizScrollChart(
                dataPointCount: timeData.length,
                child: AppLineChart(
                  title: '',
                  series: [
                    LineSeries(label: widget.metricName, data: timeData),
                  ],
                  height: 200,
                ),
              ),

            const SizedBox(height: 6),

            // ── Subtitle ──────────────────────────────────────────────
            Text(
              subtitle,
              style: AppTheme.captions
                  .copyWith(color: context.appColors.textMuted),
            ),
          ],
        );
      },
    );
  }

  // ── Data builders ────────────────────────────────────────────────────────────

  static bool _isYesNo(List<TrackingEntry> entries) =>
      entries.isNotEmpty &&
      entries.every((e) {
        final v = e.value.trim().toLowerCase();
        return v == 'yes' || v == 'no';
      });

  /// Distribution map for pie charts.
  static Map<String, double> _buildPieData(
      List<TrackingEntry> entries, bool isYesNo) {
    if (isYesNo) {
      double yes = 0, no = 0;
      for (final e in entries) {
        if (e.value.trim().toLowerCase() == 'yes') {
          yes++;
        } else {
          no++;
        }
      }
      return {'Yes': yes, 'No': no};
    }
    final counts = <double, int>{};
    for (final entry in entries) {
      final v = double.tryParse(entry.value.trim());
      if (v != null) counts[v] = (counts[v] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return {
      for (final e in sorted)
        (e.key == e.key.roundToDouble()
                ? e.key.toInt().toString()
                : e.key.toStringAsFixed(1)):
            e.value.toDouble(),
    };
  }
}

// ── Comparison line chart (loads aggregate data) ──────────────────────────────

class _ComparisonLineChart extends ConsumerWidget {
  const _ComparisonLineChart({
    required this.metricId,
    required this.metricName,
    required this.myData,
    required this.startDate,
    required this.endDate,
    required this.granularity,
    required this.aggregatePopulation,
  });

  final int metricId;
  final String metricName;
  final Map<String, double> myData;
  final String? startDate;
  final String? endDate;
  final TrackingDisplayGranularity granularity;
  final Map<String, double> Function(List<AggregateDataPoint>) aggregatePopulation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final aggAsync = ref.watch(participantAggregateProvider((
      metricId: metricId,
      startDate: startDate,
      endDate: endDate,
    )));

    return aggAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (_, __) => _HorizScrollChart(
        dataPointCount: myData.length,
        child: AppLineChart(
          title: '',
          series: [LineSeries(label: metricName, data: myData)],
          height: 200,
        ),
      ),
      data: (aggPoints) {
        final aggData = aggregatePopulation(aggPoints);
        final hasSufficientAgg = aggData.isNotEmpty;
        final totalPoints = {...myData.keys, ...aggData.keys}.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HorizScrollChart(
              dataPointCount: totalPoints,
              child: AppLineChart(
                title: '',
                series: [
                  LineSeries(
                    label: l10n.healthTrackingMyDataOnly,
                    data: myData,
                    color: AppTheme.primary,
                  ),
                  if (hasSufficientAgg)
                    LineSeries(
                      label: l10n.hcpHtAggregateSeries,
                      data: aggData,
                      color: AppTheme.secondary,
                      dotted: true,
                    ),
                ],
                height: 200,
              ),
            ),
            if (!hasSufficientAgg)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  l10n.healthTrackingAggregateUnavailable,
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

// ── Horizontal-scroll wrapper ─────────────────────────────────────────────────

class _HorizScrollChart extends StatefulWidget {
  const _HorizScrollChart({
    required this.child,
    required this.dataPointCount,
  });

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
