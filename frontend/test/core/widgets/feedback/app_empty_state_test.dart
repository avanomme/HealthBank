// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/feedback/app_empty_state.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppEmptyState', () {
    testWidgets('renders icon and title', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppEmptyState(
          icon: Icons.inbox_outlined,
          title: 'No items',
        ),
      ));

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppEmptyState(
          icon: Icons.inbox_outlined,
          title: 'No items',
          subtitle: 'Try changing your filters.',
        ),
      ));

      expect(find.text('Try changing your filters.'), findsOneWidget);
    });

    testWidgets('renders action widget when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppEmptyState(
          icon: Icons.inbox_outlined,
          title: 'No items',
          action: Text('Retry'),
        ),
      ));

      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('error constructor uses the error icon and color',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppEmptyState.error(title: 'Failed to load'),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(icon.color, AppTheme.error);
    });

    testWidgets('uses the provided icon size override', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppEmptyState(
          icon: Icons.inbox_outlined,
          title: 'No items',
          iconSize: 80,
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.inbox_outlined));
      expect(icon.size, 80);
    });
  });
}
