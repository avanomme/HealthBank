// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/healthbank_logo.dart';

import '../../../test_helpers.dart';

void main() {
  group('HealthBankLogo', () {
    testWidgets('renders the heart icon and brand text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogo(),
      ));

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.text('HealthBank'), findsOneWidget);
    });

    testWidgets('shows the tagline when requested', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogo(showTagline: true),
      ));

      expect(find.text('Your Health, Your Data'), findsOneWidget);
    });

    testWidgets('hides the tagline by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogo(),
      ));

      expect(find.text('Your Health, Your Data'), findsNothing);
    });

    testWidgets('uses the provided color override', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogo(color: AppTheme.error),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.favorite));
      final text = tester.widget<Text>(find.text('HealthBank'));

      expect(icon.color, AppTheme.error);
      expect(text.style?.color, AppTheme.error);
    });

    testWidgets('changes icon size across size variants', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Column(
          children: [
            HealthBankLogo(size: HealthBankLogoSize.small),
            HealthBankLogo(size: HealthBankLogoSize.large),
          ],
        ),
      ));

      final icons = tester.widgetList<Icon>(find.byIcon(Icons.favorite)).toList();
      expect(icons.first.size, 20);
      expect(icons.last.size, 40);
    });
  });

  group('HealthBankLogoHeader', () {
    testWidgets('renders the logo inside a header row', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogoHeader(),
      ));

      expect(find.text('HealthBank'), findsOneWidget);
      expect(find.byType(Spacer), findsOneWidget);
    });

    testWidgets('shows a divider by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogoHeader(),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('omits the divider when requested', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogoHeader(showDivider: false),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNull);
    });

    testWidgets('uses the provided background color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogoHeader(backgroundColor: AppTheme.info),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AppTheme.info);
    });

    testWidgets('forwards the size variant to the logo', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const HealthBankLogoHeader(size: HealthBankLogoSize.large),
      ));

      final logo = tester.widget<HealthBankLogo>(find.byType(HealthBankLogo));
      expect(logo.size, HealthBankLogoSize.large);
    });
  });
}
