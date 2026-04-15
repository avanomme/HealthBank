// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/core/widgets/data_display/app_bar_chart.dart
/// Reusable bar chart widget wrapping fl_chart's BarChart.
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

/// A labeled bar chart backed by fl_chart's [BarChart].
///
/// Displays a map of string labels to numeric values as vertical bars.
/// Shows a "No data available" placeholder when [data] is empty.
class AppBarChart extends StatelessWidget {
  const AppBarChart({
    super.key,
    required this.title,
    required this.data,
    this.barColor = AppTheme.primary,
    this.height = 300,
    this.showValues = true,
  });

  final String title;
  final Map<String, double> data;
  final Color barColor;
  final double height;
  final bool showValues;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
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

    final labels = data.keys.toList();
    final values = data.values.toList();
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final maxIndex = values.indexOf(maxVal);
    final total = values.fold<double>(0, (sum, value) => sum + value);
    final maxValueText = _formatValue(maxVal);
    final totalText = _formatValue(total);

    return Semantics(
      container: true,
      image: true,
      label: title,
      value:
          '${labels.length} bars. Highest ${labels[maxIndex]} at $maxValueText. Total $totalText.',
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
                  builder: (context, constraints) {
                    const leftReserved = 42.0;
                    final chartWidth = constraints.maxWidth - leftReserved;
                    final barCount = values.length;
                    final perBarWidth = barCount > 0
                        ? (chartWidth / barCount).clamp(30.0, 80.0)
                        : 80.0;
                    final barRodWidth = (perBarWidth * 0.55).clamp(8.0, 22.0);
                    final maxY = maxVal > 0 ? maxVal * 1.15 : 1.0;

                    return BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            fitInsideHorizontally: true,
                            fitInsideVertically: true,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final label = labels[group.x.toInt()];
                              final val = rod.toY;
                              return BarTooltipItem(
                                '$label\n${_formatValue(val)}',
                                AppTheme.captions.copyWith(
                                  color: AppTheme.textContrast,
                                ),
                              );
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
                              reservedSize: 56,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= labels.length) {
                                  return const SizedBox.shrink();
                                }
                                final label = labels[idx];
                                final val = values[idx];
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  fitInside: SideTitleFitInsideData.fromTitleMeta(
                                    meta,
                                    enabled: true,
                                    distanceFromEdge: 0,
                                  ),
                                  child: SizedBox(
                                    width: perBarWidth - 4,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (showValues) ...[
                                          Text(
                                            _formatValue(val),
                                            style: AppTheme.captions.copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: barColor,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 2),
                                        ],
                                        Text(
                                          label,
                                          style: AppTheme.captions.copyWith(
                                            fontSize: 9,
                                            color: context.appColors.textMuted,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: leftReserved,
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
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) =>
                              FlLine(color: context.appColors.chartGrid, strokeWidth: 1),
                        ),
                        barGroups: List.generate(values.length, (i) {
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: values[i],
                                color: barColor,
                                width: barRodWidth,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                            showingTooltipIndicators: const [],
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
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
