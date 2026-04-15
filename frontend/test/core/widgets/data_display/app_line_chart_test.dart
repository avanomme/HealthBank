// Created with the Assistance of Codex
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_line_chart.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppLineChart', () {
    testWidgets('renders title and line chart with data', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(label: 'Responses', data: {'Jan': 5, 'Feb': 10}),
            ],
          ),
        ),
      );

      expect(find.text('Trend'), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('shows placeholder when there is no data', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const AppLineChart(title: 'Trend', series: [])),
      );

      expect(find.text('No data available'), findsOneWidget);
      expect(find.byType(LineChart), findsNothing);
    });

    testWidgets('renders legend when multiple series are provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(label: 'Responses', data: {'Jan': 5, 'Feb': 10}),
              LineSeries(label: 'Submissions', data: {'Jan': 3, 'Feb': 8}),
            ],
          ),
        ),
      );

      expect(find.text('Responses'), findsOneWidget);
      expect(find.text('Submissions'), findsOneWidget);
    });

    testWidgets('respects chart visual configuration flags', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(label: 'Responses', data: {'Jan': 5, 'Feb': 10}),
            ],
            showDots: false,
            showGrid: false,
            curved: false,
          ),
        ),
      );

      final chart = tester.widget<LineChart>(find.byType(LineChart));
      final data = chart.data;
      expect(data.gridData.show, isFalse);
      expect(data.lineBarsData.first.dotData.show, isFalse);
      expect(data.lineBarsData.first.isCurved, isFalse);
    });

    testWidgets('uses provided line and fallback colors', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(
                label: 'Responses',
                data: {'Jan': 5, 'Feb': 10},
                color: AppTheme.error,
              ),
            ],
          ),
        ),
      );

      final chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData.first.color, AppTheme.error);
    });

    testWidgets('respects the provided overall height', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            height: 360,
            series: [
              LineSeries(label: 'Responses', data: {'Jan': 5, 'Feb': 10}),
            ],
          ),
        ),
      );

      expect(tester.widget<SizedBox>(find.byType(SizedBox).first).height, 360);
    });

    testWidgets('uses the default fallback color for the first series', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(label: 'Responses', data: {'Jan': 5, 'Feb': 10}),
            ],
          ),
        ),
      );

      final chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData.first.color, AppTheme.primary);
    });

    testWidgets('uses a dashed line for dotted series', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(
                label: 'Responses',
                data: {'Jan': 5, 'Feb': 10},
                dotted: true,
              ),
            ],
          ),
        ),
      );

      final chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData.first.dashArray, [6, 4]);
    });

    testWidgets('shows filled area only for a single series', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(label: 'Responses', data: {'Jan': 5, 'Feb': 10}),
            ],
          ),
        ),
      );

      final singleChart = tester.widget<LineChart>(find.byType(LineChart));
      expect(singleChart.data.lineBarsData.first.belowBarData.show, isTrue);

      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(label: 'Responses', data: {'Jan': 5, 'Feb': 10}),
              LineSeries(label: 'Submissions', data: {'Jan': 3, 'Feb': 8}),
            ],
          ),
        ),
      );

      final multiChart = tester.widget<LineChart>(find.byType(LineChart));
      expect(
        multiChart.data.lineBarsData.every(
          (line) => line.belowBarData.show == false,
        ),
        isTrue,
      );
    });

    testWidgets('uses a minimum maxY when all values are zero', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(label: 'Responses', data: {'Jan': 0, 'Feb': 0}),
            ],
          ),
        ),
      );

      final chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.maxY, 1.0);
    });

    testWidgets('exposes a semantic chart summary', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppLineChart(
            title: 'Trend',
            series: [
              LineSeries(label: 'Responses', data: {'Jan': 5, 'Feb': 10}),
            ],
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Trend' &&
              widget.properties.value ==
                  '1 series. Responses ends at Feb with 10.',
        ),
        findsOneWidget,
      );
    });
  });
}
