// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_bottom_sheet_handle.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppBottomSheetHandle', () {
    testWidgets('renders a centered handle bar', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBottomSheetHandle(),
      ));

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('uses the provided width and height', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBottomSheetHandle(
          width: 60,
          height: 6,
        ),
      ));

      expect(tester.getSize(find.byType(Container)), const Size(60, 6));
    });

    testWidgets('applies the provided color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBottomSheetHandle(color: AppTheme.error),
      ));

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration! as BoxDecoration;
      expect(decoration.color, AppTheme.error);
    });

    testWidgets('applies custom padding', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBottomSheetHandle(
          padding: EdgeInsets.all(10),
        ),
      ));

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byType(Container),
          matching: find.byType(Padding),
        ),
      );
      expect(padding.padding, const EdgeInsets.all(10));
    });

    testWidgets('rounds the handle ends based on height', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppBottomSheetHandle(height: 8),
      ));

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });
  });
}
