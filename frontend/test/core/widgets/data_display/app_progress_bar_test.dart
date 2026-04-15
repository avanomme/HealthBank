// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/data_display/app_progress_bar.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppProgressBar', () {
    testWidgets('renders with the expected progress fraction', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppProgressBar(progress: 0.6),
      ));

      final fraction = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fraction.widthFactor, 0.6);
    });

    testWidgets('clamps progress above one to full width', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppProgressBar(progress: 1.5),
      ));

      final fraction = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fraction.widthFactor, 1);
    });

    testWidgets('clamps progress below zero to zero width', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppProgressBar(progress: -1),
      ));

      final fraction = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fraction.widthFactor, 0);
    });

    testWidgets('exposes semantic label and value', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(buildTestWidget(
          const AppProgressBar(
            progress: 0.4,
            semanticLabel: 'Completion',
          ),
        ));

        final semantics = tester.getSemantics(find.byType(AppProgressBar));
        expect(semantics.label, 'Completion');
        expect(semantics.value, '40%');
        expect(semantics.flagsCollection.isReadOnly, isFalse);
      } finally {
        handle.dispose();
      }
    });

    testWidgets('uses custom colors and height overrides', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppProgressBar(
          progress: 0.5,
          height: 12,
          backgroundColor: AppTheme.gray,
          progressColor: AppTheme.error,
        ),
      ));

      final containers = tester.widgetList<Container>(find.byType(Container)).toList();
      final outerDecoration = containers[0].decoration! as BoxDecoration;
      final innerDecoration = containers[1].decoration! as BoxDecoration;

      expect(tester.getSize(find.byType(Container).first).height, 12);
      expect(outerDecoration.color, AppTheme.gray);
      expect(innerDecoration.color, AppTheme.error);
    });
  });
}
