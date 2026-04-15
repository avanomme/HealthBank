// Created with the Assistance of Codex
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppBarChart', () {
    testWidgets('renders title and bar chart with sample data', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppBarChart(title: 'Responses', data: {'A': 10, 'B': 20}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Responses'), findsOneWidget);
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('shows a no-data placeholder for empty data', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const AppBarChart(title: 'Responses', data: {})),
      );
      await tester.pumpAndSettle();

      expect(find.text('No data available'), findsOneWidget);
      expect(find.byType(BarChart), findsNothing);
    });

    testWidgets('renders numeric value labels when showValues is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppBarChart(
            title: 'Responses',
            data: {'A': 10, 'B': 20},
            showValues: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('10'), findsNWidgets(2));
      expect(find.text('20'), findsNWidgets(2));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('hides numeric value labels when showValues is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppBarChart(
            title: 'Responses',
            data: {'A': 10, 'B': 20},
            showValues: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('10'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('uses the provided bar color in the chart data', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppBarChart(
            title: 'Responses',
            data: {'A': 10},
            barColor: AppTheme.error,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chart = tester.widget<BarChart>(find.byType(BarChart));
      final data = chart.data;
      expect(data.barGroups.first.barRods.first.color, AppTheme.error);
    });

    testWidgets('respects the provided overall height', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppBarChart(title: 'Responses', data: {'A': 10}, height: 420),
        ),
      );
      await tester.pumpAndSettle();

      final box = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(box.height, 420);
    });

    testWidgets('uses a minimum chart maxY when all values are zero', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppBarChart(title: 'Responses', data: {'A': 0, 'B': 0}),
        ),
      );
      await tester.pumpAndSettle();

      final chart = tester.widget<BarChart>(find.byType(BarChart));
      expect(chart.data.maxY, 1.0);
    });

    testWidgets(
      'shows decimal values and truncated long labels in axis titles',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const AppBarChart(
              title: 'Responses',
              data: {'VeryLongResponseLabelForChip': 1.5},
              showValues: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('1.5'), findsNWidgets(2));
        expect(
          find.textContaining('VeryLongResponseLabelForChip'),
          findsOneWidget,
        );
      },
    );

    testWidgets('scales maxY to 115 percent of the highest value', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppBarChart(title: 'Responses', data: {'A': 10, 'B': 20}),
        ),
      );
      await tester.pumpAndSettle();

      final chart = tester.widget<BarChart>(find.byType(BarChart));
      expect(chart.data.maxY, 23);
    });

    testWidgets('uses fixed rod width and rounded top corners', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const AppBarChart(title: 'Responses', data: {'A': 10})),
      );
      await tester.pumpAndSettle();

      final rod = tester
          .widget<BarChart>(find.byType(BarChart))
          .data
          .barGroups
          .first
          .barRods
          .first;
      expect(rod.width, 22);
      expect(
        rod.borderRadius,
        const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      );
    });

    testWidgets('exposes a semantic summary for assistive technology', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppBarChart(title: 'Responses', data: {'A': 10, 'B': 20}),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Responses' &&
              widget.properties.value == '2 bars. Highest B at 20. Total 30.',
        ),
        findsOneWidget,
      );
    });
  });
}
