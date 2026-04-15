// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/core/widgets/data_display/app_line_chart.dart
/// Reusable line chart widget wrapping fl_chart's LineChart.
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

/// A single data series for [AppLineChart].
class LineSeries {
  const LineSeries({
    required this.label,
    required this.data,
    this.color,
    this.dotted = false,
  });

  final String label;
  final Map<String, double> data;
  final Color? color;
  final bool dotted;
}

/// A multi-series line chart backed by fl_chart's [LineChart].
///
/// Accepts one or more [LineSeries] and renders them with optional dots,
/// grid lines, and Bézier curves. Displays a placeholder when [series] is empty.
class AppLineChart extends StatelessWidget {
  const AppLineChart({
    super.key,
    required this.title,
    required this.series,
    this.height = 300,
    this.showDots = true,
    this.showGrid = true,
    this.curved = true,
  });

  final String title;
  final List<LineSeries> series;
  final double height;
  final bool showDots;
  final bool showGrid;
  final bool curved;

  static const List<Color> defaultColors = [
    AppTheme.primary,
    AppTheme.success,
    AppTheme.info,
    AppTheme.caution,
    AppTheme.error,
    AppTheme.secondary,
    AppTheme.chartExtra1,
    AppTheme.chartExtra2,
  ];

  /// Approximate pixel width needed per label character at fontSize 11.
  static const _kCharPx = 6.5;
  static const _kLeftReserved = 42.0;

  @override
  Widget build(BuildContext context) {
    if (series.isEmpty || series.every((s) => s.data.isEmpty)) {
      return Semantics(
        container: true,
        image: true,
        label: title,
        value: 'No data available.',
        child: ExcludeSemantics(
          child: SizedBox(
            height: height,
            child: Center(
              child: Text(
                'No data available',
                style: AppTheme.body.copyWith(
                  color: context.appColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final labels = <String>[];
    for (final s in series) {
      for (final key in s.data.keys) {
        if (!labels.contains(key)) labels.add(key);
      }
    }

    double maxVal = 0;
    for (final s in series) {
      for (final v in s.data.values) {
        if (v > maxVal) maxVal = v;
      }
    }

    final summaries = series
        .map((s) {
          if (s.data.isEmpty) return '${s.label} has no points';
          final lastLabel = s.data.keys.last;
          final lastValue = s.data.values.last;
          return '${s.label} ends at $lastLabel with ${_formatValue(lastValue)}';
        })
        .join('. ');

    final lineBars = <LineChartBarData>[];
    for (int si = 0; si < series.length; si++) {
      final s = series[si];
      final color = s.color ?? defaultColors[si % defaultColors.length];
      final spots = <FlSpot>[];
      for (int i = 0; i < labels.length; i++) {
        final val = s.data[labels[i]];
        if (val != null) {
          spots.add(FlSpot(i.toDouble(), val));
        }
      }

      lineBars.add(
        LineChartBarData(
          spots: spots,
          isCurved: curved,
          color: color,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: showDots),
          belowBarData: BarAreaData(
            show: series.length == 1,
            color: color.withValues(alpha: 0.08),
          ),
          dashArray: s.dotted ? [6, 4] : null,
        ),
      );
    }

    final maxY = maxVal > 0 ? maxVal * 1.15 : 1.0;

    // Estimate the longest label's pixel width so we can skip overlapping ones.
    final maxLabelLen = labels.fold<int>(
      0, (best, l) => l.length > best ? l.length : best,
    );
    final estLabelPx = (maxLabelLen * _kCharPx).clamp(30.0, 120.0);

    return Semantics(
      container: true,
      image: true,
      label: title,
      value: '${series.length} series. $summaries.',
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty) ...[
                AppText(
                  title,
                  variant: AppTextVariant.headlineSmall,
                  color: context.appColors.textPrimary,
                ),
                const SizedBox(height: 8),
              ],
              Expanded(
                child: LayoutBuilder(
                  builder: (ctx, constraints) {
                    // How many data-point slots fit without overlap.
                    final plotWidth = (constraints.maxWidth - _kLeftReserved)
                        .clamp(1.0, double.infinity);
                    final pointSpacing = labels.isEmpty
                        ? plotWidth
                        : plotWidth / labels.length;
                    // Skip every Nth label so they don't overlap.
                    final skip = (estLabelPx / pointSpacing).ceil().clamp(1, labels.length);

                    return LineChart(
                      LineChartData(
                        maxY: maxY,
                        minY: 0,
                        lineBarsData: lineBars,
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            fitInsideHorizontally: true,
                            fitInsideVertically: true,
                            tooltipRoundedRadius: 8,
                            tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            tooltipBorder: BorderSide(
                              color: AppTheme.white.withValues(alpha: 0.15),
                            ),
                            getTooltipColor: (_) => const Color(0xFF1A2B45),
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                final si = spot.barIndex;
                                final label = series[si].label;
                                return LineTooltipItem(
                                  '$label: ${_formatValue(spot.y)}',
                                  AppTheme.captions.copyWith(
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= labels.length) {
                                  return const SizedBox.shrink();
                                }
                                // Only render every `skip`-th label to prevent overlap.
                                if (idx % skip != 0) return const SizedBox.shrink();
                                final label = labels[idx];
                                final display = label.length > 10
                                    ? '${label.substring(0, 8)}…'
                                    : label;
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  fitInside: SideTitleFitInsideData.fromTitleMeta(
                                    meta,
                                    enabled: true,
                                    distanceFromEdge: 0,
                                  ),
                                  child: Text(
                                    display,
                                    style: AppTheme.captions.copyWith(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: _kLeftReserved,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  _formatValue(value),
                                  style: AppTheme.captions.copyWith(
                                    fontSize: 11,
                                    color: context.appColors.textMuted,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: showGrid,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) =>
                              FlLine(color: context.appColors.divider, strokeWidth: 1),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (series.length > 1) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    for (int i = 0; i < series.length; i++)
                      _LegendItem(
                        label: series[i].label,
                        color:
                            series[i].color ??
                            defaultColors[i % defaultColors.length],
                        dotted: series[i].dotted,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _formatValue(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.color,
    this.dotted = false,
  });

  final String label;
  final Color color;
  final bool dotted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: dotted ? Colors.transparent : color,
            border: dotted ? Border.all(color: color, width: 1.5) : null,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTheme.captions.copyWith(fontSize: 12)),
      ],
    );
  }
}
