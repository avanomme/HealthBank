// Created with the Assistance of Codex
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppPieChart', () {
    testWidgets('renders title and pie chart with data', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppPieChart(title: 'Distribution', data: {'Yes': 75, 'No': 25}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Distribution'), findsOneWidget);
      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('shows legend labels when showLegend is true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppPieChart(
            title: 'Distribution',
            data: {'Yes': 75, 'No': 25},
            showLegend: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Yes (75.0%)'), findsOneWidget);
      expect(find.text('No (25.0%)'), findsOneWidget);
    });

    testWidgets('hides legend labels when showLegend is false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppPieChart(
            title: 'Distribution',
            data: {'Yes': 75, 'No': 25},
            showLegend: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Yes (75.0%)'), findsNothing);
      expect(find.text('No (25.0%)'), findsNothing);
    });

    testWidgets('shows a placeholder for empty data or zero total', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppPieChart(title: 'Distribution', data: {'Yes': 0, 'No': 0}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No data available'), findsOneWidget);
      expect(find.byType(PieChart), findsNothing);
    });

    testWidgets('uses the provided segment colors', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppPieChart(
            title: 'Distribution',
            data: {'Yes': 1, 'No': 1},
            colors: [AppTheme.error, AppTheme.success],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chart = tester.widget<PieChart>(find.byType(PieChart));
      final data = chart.data;
      expect(data.sections[0].color, AppTheme.error);
      expect(data.sections[1].color, AppTheme.success);
    });

    testWidgets('shows a placeholder when the data map is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const AppPieChart(title: 'Distribution', data: {})),
      );
      await tester.pumpAndSettle();

      expect(find.text('No data available'), findsOneWidget);
      expect(find.byType(PieChart), findsNothing);
    });

    testWidgets('keeps the title visible in the no data state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const AppPieChart(title: 'Distribution', data: {})),
      );
      await tester.pumpAndSettle();

      expect(find.text('Distribution'), findsOneWidget);
    });

    testWidgets('respects the provided overall height', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppPieChart(
            title: 'Distribution',
            data: {'Yes': 75, 'No': 25},
            height: 320,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.widget<SizedBox>(find.byType(SizedBox).first).height, 320);
    });

    testWidgets('uses default colors when custom colors are omitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppPieChart(title: 'Distribution', data: {'Yes': 1, 'No': 1}),
        ),
      );
      await tester.pumpAndSettle();

      final chart = tester.widget<PieChart>(find.byType(PieChart));
      expect(chart.data.sections[0].color, AppTheme.primary);
      expect(chart.data.sections[1].color, AppTheme.secondary);
    });

    testWidgets('renders 100 percent legend text for a single value', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppPieChart(title: 'Distribution', data: {'Yes': 4}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Yes (100.0%)'), findsOneWidget);
    });

    testWidgets('exposes a semantic summary of slice percentages', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AppPieChart(title: 'Distribution', data: {'Yes': 75, 'No': 25}),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Distribution' &&
              widget.properties.value == 'No 25.0 percent. Yes 75.0 percent',
        ),
        findsOneWidget,
      );
    });
  });
}
