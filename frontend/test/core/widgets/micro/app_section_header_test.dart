// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_badge.dart';
import 'package:frontend/src/core/widgets/micro/app_section_header.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppSectionHeader', () {
    testWidgets('renders the title text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppSectionHeader(title: 'Overview'),
      ));

      expect(find.text('Overview'), findsOneWidget);
    });

    testWidgets('renders a trailing widget when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppSectionHeader(
          title: 'Results',
          trailing: AppBadge(label: '3'),
        ),
      ));

      expect(find.text('3'), findsOneWidget);
      expect(find.byType(AppBadge), findsOneWidget);
    });

    testWidgets('applies top and bottom spacing through padding',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppSectionHeader(
          title: 'Overview',
          topSpacing: 10,
          bottomSpacing: 6,
        ),
      ));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, const EdgeInsets.only(top: 10, bottom: 6));
    });

    testWidgets('passes color and fontWeight to AppText', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppSectionHeader(
          title: 'Overview',
          color: AppTheme.error,
          fontWeight: FontWeight.w700,
        ),
      ));

      final appText = tester.widget<AppText>(find.byType(AppText));
      expect(appText.color, AppTheme.error);
      expect(appText.fontWeight, FontWeight.w700);
    });

    testWidgets('passes the requested variant to AppText', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppSectionHeader(
          title: 'Overview',
          variant: AppTextVariant.headlineSmall,
        ),
      ));

      final appText = tester.widget<AppText>(find.byType(AppText));
      expect(appText.variant, AppTextVariant.headlineSmall);
    });
  });
}
