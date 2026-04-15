// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/feedback/app_info_banner.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppInfoBanner', () {
    testWidgets('renders icon and message', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppInfoBanner(
          icon: Icons.info_outline,
          message: 'Profile information is incomplete.',
        ),
      ));

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.text('Profile information is incomplete.'), findsOneWidget);
    });

    testWidgets('renders a trailing widget when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppInfoBanner(
          icon: Icons.info_outline,
          message: 'Profile information is incomplete.',
          trailing: Text('Close'),
        ),
      ));

      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('shows a border by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppInfoBanner(
          icon: Icons.info_outline,
          message: 'Message',
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('omits the border when showBorder is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppInfoBanner(
          icon: Icons.info_outline,
          message: 'Message',
          showBorder: false,
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('applies the provided radius and padding', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppInfoBanner(
          icon: Icons.info_outline,
          message: 'Message',
          radius: 12,
          padding: EdgeInsets.all(20),
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(container.padding, const EdgeInsets.all(20));
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });
  });
}
