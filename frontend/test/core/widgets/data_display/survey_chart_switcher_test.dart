// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_line_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/data_display/survey_chart_switcher.dart';
import 'package:frontend/src/core/widgets/micro/app_icon.dart';

import '../../../test_helpers.dart';

void main() {
  group('SurveyChartSwitcher', () {
    testWidgets('renders the default chart type initially', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.bar,
        ),
      ));

      expect(find.byType(AppBarChart), findsOneWidget);
      expect(find.byType(AppPieChart), findsNothing);
      expect(find.byType(AppLineChart), findsNothing);
    });

    testWidgets('switches to pie and line charts when tapped',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.bar,
        ),
      ));

      await tester.tap(find.byTooltip('Pie chart'));
      await tester.pumpAndSettle();
      expect(find.byType(AppPieChart), findsOneWidget);

      await tester.tap(find.byTooltip('Line chart'));
      await tester.pumpAndSettle();
      expect(find.byType(AppLineChart), findsOneWidget);
    });

    testWidgets('respects enabledTypes and hides disabled buttons',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.bar,
          enabledTypes: {SurveyChartType.bar, SurveyChartType.pie},
        ),
      ));

      expect(find.byTooltip('Bar chart'), findsOneWidget);
      expect(find.byTooltip('Pie chart'), findsOneWidget);
      expect(find.byTooltip('Line chart'), findsNothing);
    });

    testWidgets('passes title and data through to rendered chart',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.line,
        ),
      ));

      final chart = tester.widget<AppLineChart>(find.byType(AppLineChart));
      expect(chart.title, 'Responses');
      expect(chart.series.single.data, const {'Yes': 10, 'No': 5});
    });

    testWidgets('passes height to the active chart', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.pie,
          height: 320,
        ),
      ));

      final chart = tester.widget<AppPieChart>(find.byType(AppPieChart));
      expect(chart.height, 320);
    });

    testWidgets('shows all chart buttons when enabledTypes is omitted',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.bar,
        ),
      ));

      expect(find.byTooltip('Bar chart'), findsOneWidget);
      expect(find.byTooltip('Line chart'), findsOneWidget);
      expect(find.byTooltip('Pie chart'), findsOneWidget);
    });

    testWidgets('passes custom colors through to the pie chart',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.pie,
          colors: [Colors.red, Colors.green],
        ),
      ));

      final chart = tester.widget<AppPieChart>(find.byType(AppPieChart));
      expect(chart.colors, [Colors.red, Colors.green]);
    });

    testWidgets('uses the title as the generated line-series label',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.line,
        ),
      ));

      final chart = tester.widget<AppLineChart>(find.byType(AppLineChart));
      expect(chart.series.single.label, 'Responses');
    });

    testWidgets('updates icon selection styling when the active type changes',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.bar,
        ),
      ));

      var icons = tester.widgetList<AppIcon>(find.byType(AppIcon)).toList();
      expect(icons[0].color, isNotNull);

      await tester.tap(find.byTooltip('Pie chart'));
      await tester.pumpAndSettle();

      icons = tester.widgetList<AppIcon>(find.byType(AppIcon)).toList();
      expect(icons[2].color, isNot(icons[1].color));
    });

    testWidgets('preserves the selected type across parent rebuilds',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.bar,
        ),
      ));

      await tester.tap(find.byTooltip('Pie chart'));
      await tester.pumpAndSettle();
      expect(find.byType(AppPieChart), findsOneWidget);

      await tester.pumpWidget(buildTestWidget(
        const SurveyChartSwitcher(
          title: 'Updated Responses',
          data: {'Yes': 10, 'No': 5},
          defaultType: SurveyChartType.bar,
        ),
      ));

      expect(find.byType(AppPieChart), findsOneWidget);
      expect(find.byType(AppBarChart), findsNothing);
    });
  });
}
