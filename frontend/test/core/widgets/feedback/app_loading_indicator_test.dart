// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/feedback/app_loading_indicator.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppLoadingIndicator', () {
    testWidgets('renders a centered spinner by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppLoadingIndicator(),
      ));

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('uses the provided size, stroke width, and color',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppLoadingIndicator(
          size: 48,
          strokeWidth: 6,
          color: AppTheme.error,
        ),
      ));

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(tester.getSize(find.byType(SizedBox)), const Size(48, 48));
      expect(indicator.strokeWidth, 6);
      expect(indicator.color, AppTheme.error);
    });

    testWidgets('inline constructor omits the Center wrapper', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppLoadingIndicator.inline(),
      ));

      expect(find.byType(Center), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('inline constructor uses compact defaults', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppLoadingIndicator.inline(),
      ));

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(tester.getSize(find.byType(SizedBox)), const Size(16, 16));
      expect(indicator.strokeWidth, 2);
    });

    testWidgets('falls back to the primary theme color when omitted',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppLoadingIndicator(),
      ));

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, AppTheme.primary);
    });
  });
}
