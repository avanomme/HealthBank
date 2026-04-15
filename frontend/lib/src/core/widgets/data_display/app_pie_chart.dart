// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/core/widgets/data_display/app_pie_chart.dart
/// Reusable pie chart widget wrapping fl_chart's PieChart.
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

/// An interactive pie chart backed by fl_chart's [PieChart].
///
/// Tapping a slice selects it and highlights it. Displays an optional legend
/// below the chart and falls back to a placeholder when [data] is empty.
class AppPieChart extends StatefulWidget {
  const AppPieChart({
    super.key,
    required this.title,
    required this.data,
    this.colors,
    this.height = 250,
    this.showLegend = true,
  });

  final String title;
  final Map<String, double> data;
  final List<Color>? colors;
  final double height;
  final bool showLegend;

  static const List<Color> defaultColors = [
    AppTheme.primary,
    AppTheme.secondary,
    AppTheme.info,
    AppTheme.caution,
    AppTheme.error,
    AppTheme.success,
    AppTheme.chartExtra1,
    AppTheme.chartExtra2,
  ];

  @override
  State<AppPieChart> createState() => _AppPieChartState();
}

class _AppPieChartState extends State<AppPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return _buildNoDataState();
    }

    final entries = widget.data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final total = entries.fold(0.0, (sum, e) => sum + e.value);
    if (total <= 0) {
      return _buildNoDataState();
    }

    final summary = entries
        .map((entry) {
          final percent = total > 0 ? (entry.value / total * 100) : 0.0;
          return '${entry.key} ${percent.toStringAsFixed(1)} percent';
        })
        .join('. ');

    final chartColors = widget.colors ?? AppPieChart.defaultColors;

    return Semantics(
      container: true,
      image: true,
      label: widget.title,
      value: summary,
      child: ExcludeSemantics(
        child: SizedBox(
          height: widget.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title.isNotEmpty) ...[
                AppText(
                  widget.title,
                  variant: AppTextVariant.headlineSmall,
                  color: context.appColors.textPrimary,
                ),
                const SizedBox(height: 8),
              ],
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              if (!mounted) return;
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.touchedSection == null) {
                                  _touchedIndex = -1;
                                } else {
                                  _touchedIndex = response
                                      .touchedSection!
                                      .touchedSectionIndex;
                                }
                              });
                            },
                          ),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: List.generate(entries.length, (i) {
                            final entry = entries[i];
                            final isTouched = i == _touchedIndex;
                            final pct = total > 0
                                ? (entry.value / total * 100)
                                : 0.0;

                            return PieChartSectionData(
                              value: entry.value,
                              color: chartColors[i % chartColors.length],
                              radius: isTouched ? 65 : 55,
                              title: '${pct.toStringAsFixed(1)}%',
                              titleStyle: AppTheme.captions.copyWith(
                                fontSize: isTouched ? 14 : 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textContrast,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    if (widget.showLegend) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(entries.length, (i) {
                            final entry = entries[i];
                            final pct = total > 0
                                ? (entry.value / total * 100)
                                : 0.0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color:
                                          chartColors[i % chartColors.length],
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: AppText(
                                      '${entry.key} (${pct.toStringAsFixed(1)}%)',
                                      variant: AppTextVariant.bodySmall,
                                      color: context.appColors.textPrimary,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Semantics(
      container: true,
      image: true,
      label: widget.title,
      value: 'No data available.',
      child: ExcludeSemantics(
        child: SizedBox(
          height: widget.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                widget.title,
                variant: AppTextVariant.headlineSmall,
                color: context.appColors.textPrimary,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: AppText(
                    'No data available',
                    variant: AppTextVariant.bodyMedium,
                    color: context.appColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
