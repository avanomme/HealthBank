// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppStatCard', () {
    testWidgets('renders label and value text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppStatCard(
          label: 'Respondents',
          value: '42',
        ),
      ));

      expect(find.text('Respondents'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppStatCard(
          label: 'Count',
          value: '10',
          icon: Icons.people,
        ),
      ));

      expect(find.byIcon(Icons.people), findsOneWidget);
    });

    testWidgets('renders optional subtitle when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppStatCard(
          label: 'Rate',
          value: '80%',
          subtitle: 'out of 100',
        ),
      ));

      expect(find.text('out of 100'), findsOneWidget);
    });

    testWidgets('does not render subtitle when omitted', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppStatCard(
          label: 'Rate',
          value: '80%',
        ),
      ));

      expect(find.text('out of 100'), findsNothing);
    });

    testWidgets('uses the provided accent color for border and icon',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppStatCard(
          label: 'Rate',
          value: '80%',
          icon: Icons.people,
          color: AppTheme.error,
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      final icon = tester.widget<Icon>(find.byIcon(Icons.people));

      expect((decoration.border as Border).top.color, AppTheme.error);
      expect(icon.color, AppTheme.error);
    });
  });
}
