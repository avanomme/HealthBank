// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/data_display/survey_chart_switcher.dart
/// Chart type switcher used on researcher data and participant results pages.
///
/// Wraps [AppBarChart], [AppPieChart], and [AppLineChart] with a toggle so
/// the user can pick the preferred visualization per question.  Also provides
/// a data table view as an accessible alternative (WCAG 1.1.1 A).
/// The default type is chosen by the caller based on the question's response type.
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_line_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/micro/app_icon.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

enum SurveyChartType { bar, pie, line, table }

/// Chart-type switcher widget for survey data visualisation.
///
/// Lets the user toggle between bar, pie, line, and table views of a
/// question's response distribution via a compact icon toolbar.
class SurveyChartSwitcher extends StatefulWidget {
  const SurveyChartSwitcher({
    super.key,
    required this.data,
    required this.title,
    required this.defaultType,
    this.height = 280,
    this.colors,
    this.enabledTypes,
  });

  /// Data to plot: option label → count.
  final Map<String, double> data;

  /// Chart title (passed through to the inner chart widget).
  final String title;

  /// Which chart type to show initially.
  final SurveyChartType defaultType;

  /// Height of the chart area.
  final double height;

  /// Optional color overrides for pie/line chart segments.
  final List<Color>? colors;

  /// Which chart types to show in the toggle. Defaults to bar/pie/line + table.
  /// `table` is always included as an accessible alternative.
  final Set<SurveyChartType>? enabledTypes;

  @override
  State<SurveyChartSwitcher> createState() => _SurveyChartSwitcherState();
}

class _SurveyChartSwitcherState extends State<SurveyChartSwitcher> {
  late SurveyChartType _type;

  @override
  void initState() {
    super.initState();
    _type = widget.defaultType;
  }

  /// All enabled types — always includes `table` as an accessible fallback.
  Set<SurveyChartType> get _enabled {
    final base = widget.enabledTypes ??
        {SurveyChartType.bar, SurveyChartType.pie, SurveyChartType.line};
    return {...base, SurveyChartType.table};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle row — icon buttons flush right
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_enabled.contains(SurveyChartType.bar))
              _TypeButton(
                icon: Icons.bar_chart_rounded,
                tooltip: context.l10n.tooltipBarChart,
                selected: _type == SurveyChartType.bar,
                onTap: () => setState(() => _type = SurveyChartType.bar),
              ),
            if (_enabled.contains(SurveyChartType.line)) ...[
              const SizedBox(width: 4),
              _TypeButton(
                icon: Icons.show_chart_rounded,
                tooltip: context.l10n.tooltipLineChart,
                selected: _type == SurveyChartType.line,
                onTap: () => setState(() => _type = SurveyChartType.line),
              ),
            ],
            if (_enabled.contains(SurveyChartType.pie)) ...[
              const SizedBox(width: 4),
              _TypeButton(
                icon: Icons.pie_chart_outline_rounded,
                tooltip: context.l10n.tooltipPieChart,
                selected: _type == SurveyChartType.pie,
                onTap: () => setState(() => _type = SurveyChartType.pie),
              ),
            ],
            // Table view — always shown as accessible alternative (WCAG 1.1.1)
            const SizedBox(width: 4),
            _TypeButton(
              icon: Icons.table_rows_outlined,
              tooltip: context.l10n.tooltipTableView,
              selected: _type == SurveyChartType.table,
              onTap: () => setState(() => _type = SurveyChartType.table),
            ),
          ],
        ),
        const SizedBox(height: 8),
        switch (_type) {
          SurveyChartType.bar => AppBarChart(
            title: widget.title,
            data: widget.data,
            height: widget.height,
          ),
          SurveyChartType.pie => AppPieChart(
            title: widget.title,
            data: widget.data,
            colors: widget.colors,
            height: widget.height,
          ),
          SurveyChartType.line => AppLineChart(
            title: widget.title,
            series: [LineSeries(label: widget.title, data: widget.data)],
            height: widget.height,
          ),
          SurveyChartType.table => _DataTableView(
            title: widget.title,
            data: widget.data,
          ),
        },
      ],
    );
  }
}

/// Accessible data table view — shown when the user selects the table toggle.
/// Provides a text alternative for screen reader users (WCAG 1.1.1 A).
class _DataTableView extends StatelessWidget {
  const _DataTableView({required this.title, required this.data});

  final String title;
  final Map<String, double> data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = data.values.fold(0.0, (a, b) => a + b);
    final rows = data.entries.toList();

    return Semantics(
      label: l10n.chartTableLabel(title),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          headingTextStyle: AppTheme.body.copyWith(
            fontWeight: FontWeight.w600,
            color: context.appColors.textPrimary,
          ),
          dataTextStyle:
              AppTheme.body.copyWith(color: context.appColors.textPrimary),
          columns: [
            DataColumn(label: Text(l10n.chartTableOption)),
            DataColumn(
              label: Text(l10n.chartTableCount),
              numeric: true,
            ),
            DataColumn(
              label: Text(l10n.chartTablePercent),
              numeric: true,
            ),
          ],
          rows: rows.map((e) {
            final pct = total > 0 ? (e.value / total * 100) : 0.0;
            return DataRow(cells: [
              DataCell(Text(e.key)),
              DataCell(Text(e.value.toInt().toString())),
              DataCell(Text('${pct.toStringAsFixed(1)}%')),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
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
      child: IconButton(
        onPressed: onTap,
        tooltip: tooltip,
        style: ButtonStyle(
          animationDuration: const Duration(milliseconds: 150),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(6)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          backgroundColor: WidgetStatePropertyAll(
            selected
                ? AppTheme.primary.withValues(alpha: 0.12)
                : Colors.transparent,
          ),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: selected
                  ? AppTheme.primary.withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
          ),
        ),
        icon: AppIcon(
          icon,
          size: 20,
          color: selected ? AppTheme.primary : context.appColors.textMuted,
        ),
      ),
    );
  }
}
