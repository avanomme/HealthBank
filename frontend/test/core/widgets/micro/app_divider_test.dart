// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_divider.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppDivider', () {
    testWidgets('renders with a default line', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDivider(),
      ));

      expect(find.byType(AppDivider), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('uses the provided thickness and spacing', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDivider(
          thickness: 3,
          spacing: 18,
        ),
      ));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

      expect(sizedBox.height, 18);
      expect(tester.getSize(find.byType(Container)).height, 3);
    });

    testWidgets('applies custom color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDivider(color: AppTheme.error),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, AppTheme.error);
    });

    testWidgets('applies left and right indentation', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDivider(
          indent: 12,
          endIndent: 20,
        ),
      ));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, const EdgeInsets.only(left: 12, right: 20));
    });

    testWidgets('keeps spacing at least as large as thickness', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppDivider(
          thickness: 10,
          spacing: 4,
        ),
      ));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 10);
    });
  });
}
