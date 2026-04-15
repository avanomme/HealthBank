// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_user_avatar.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppUserAvatar', () {
    testWidgets('renders the uppercase first initial from the name',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppUserAvatar(name: 'john doe'),
      ));

      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('falls back to a question mark for an empty name',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppUserAvatar(name: ''),
      ));

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('uses the provided radius', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppUserAvatar(
          name: 'Jane',
          radius: 24,
        ),
      ));

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, 24);
    });

    testWidgets('applies custom foreground and background colors',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppUserAvatar(
          name: 'Jane',
          backgroundColor: AppTheme.info,
          foregroundColor: AppTheme.white,
        ),
      ));

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      final text = tester.widget<Text>(find.text('J'));

      expect(avatar.backgroundColor, AppTheme.info);
      expect(text.style?.color, AppTheme.white);
    });

    testWidgets('uses the provided font size override', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppUserAvatar(
          name: 'Jane',
          fontSize: 22,
        ),
      ));

      final text = tester.widget<Text>(find.text('J'));
      expect(text.style?.fontSize, 22);
    });
  });
}
