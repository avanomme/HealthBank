// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_card.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppCard', () {
    testWidgets('renders its child content', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCard(child: Text('Card content')),
      ));

      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('applies padding, width, and radius overrides',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCard(
          width: 220,
          radius: 12,
          padding: EdgeInsets.all(20),
          child: Text('Card content'),
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;

      expect(tester.getSize(find.byType(Container)).width, 220);
      expect(container.padding, const EdgeInsets.all(20));
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('uses custom background and border colors', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCard(
          backgroundColor: AppTheme.info,
          borderColor: AppTheme.error,
          child: Text('Card content'),
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;

      expect(decoration.color, AppTheme.info);
      expect((decoration.border as Border).top.color, AppTheme.error);
    });

    testWidgets('wraps content in InkWell when onTap is provided',
        (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppCard(
          onTap: () => taps++,
          child: const Text('Card content'),
        ),
      ));

      expect(find.byType(InkWell), findsOneWidget);

      await tester.tap(find.text('Card content'));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('does not create InkWell when onTap is omitted',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppCard(child: Text('Card content')),
      ));

      expect(find.byType(InkWell), findsNothing);
    });
  });
}
