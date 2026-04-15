// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_outlined_button.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppOutlinedButton', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOutlinedButton(label: 'Retry'),
      ));

      expect(find.widgetWithText(OutlinedButton, 'Retry'), findsOneWidget);
    });

    testWidgets('renders a leading icon when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOutlinedButton(
          label: 'Refresh',
          icon: Icons.refresh,
        ),
      ));

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('fires callback when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppOutlinedButton(
          label: 'Retry',
          onPressed: () => taps++,
        ),
      ));

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('is disabled when callback is omitted', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOutlinedButton(label: 'Retry'),
      ));

      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('applies foreground, border, and padding overrides',
        (tester) async {
      const padding = EdgeInsets.symmetric(horizontal: 30, vertical: 14);

      await tester.pumpWidget(buildTestWidget(
        const AppOutlinedButton(
          label: 'Cancel',
          borderColor: AppTheme.error,
          foregroundColor: AppTheme.error,
          padding: padding,
        ),
      ));

      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final style = button.style!;
      final border = style.side!.resolve(<WidgetState>{});

      expect(style.foregroundColor!.resolve(<WidgetState>{}), AppTheme.error);
      expect(border?.color, AppTheme.error);
      expect(style.padding!.resolve(<WidgetState>{}), padding);
    });

    testWidgets('uses primary colors by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOutlinedButton(label: 'Default'),
      ));

      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final style = button.style!;
      final border = style.side!.resolve(<WidgetState>{});

      expect(
        style.foregroundColor!.resolve(<WidgetState>{}),
        AppTheme.primary,
      );
      expect(border?.color, AppTheme.primary);
    });

    testWidgets('uses size 18 for its optional icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppOutlinedButton(
          label: 'Refresh',
          icon: Icons.refresh,
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.refresh));
      expect(icon.size, 18);
    });

    testWidgets('defaults text weight to semi-bold for custom text styles',
        (tester) async {
      const textStyle = TextStyle(fontSize: 17);

      await tester.pumpWidget(buildTestWidget(
        const AppOutlinedButton(
          label: 'Retry',
          textStyle: textStyle,
        ),
      ));

      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final resolvedStyle = button.style!.textStyle!.resolve(<WidgetState>{});

      expect(resolvedStyle?.fontSize, 17);
      expect(resolvedStyle?.fontWeight, FontWeight.w600);
    });
  });
}
