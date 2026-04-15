// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_filled_button.dart';
import 'package:frontend/src/core/widgets/buttons/app_long_button.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppLongButton', () {
    testWidgets('renders through AppFilledButton with its label',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppLongButton(label: 'Continue'),
      ));

      expect(find.widgetWithText(ElevatedButton, 'Continue'), findsOneWidget);
    });

    testWidgets('expands to the full width of its parent', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 280,
            child: AppLongButton(label: 'Continue'),
          ),
        ),
      ));

      expect(tester.getSize(find.byType(ElevatedButton)).width, 280);
    });

    testWidgets('fires callback when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppLongButton(
          label: 'Continue',
          onPressed: () => taps++,
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('is disabled when callback is omitted', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppLongButton(label: 'Continue'),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('passes visual overrides to the underlying button',
        (tester) async {
      const padding = EdgeInsets.all(18);

      await tester.pumpWidget(buildTestWidget(
        const AppLongButton(
          label: 'Continue',
          backgroundColor: AppTheme.success,
          textColor: AppTheme.white,
          padding: padding,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style!;

      expect(style.backgroundColor!.resolve(<WidgetState>{}), AppTheme.success);
      expect(style.foregroundColor!.resolve(<WidgetState>{}), AppTheme.white);
      expect(style.padding!.resolve(<WidgetState>{}), padding);
    });

    testWidgets('composes AppFilledButton internally', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppLongButton(label: 'Continue'),
      ));

      expect(find.byType(AppFilledButton), findsOneWidget);
    });

    testWidgets('forwards textStyle to the underlying button', (tester) async {
      const textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

      await tester.pumpWidget(buildTestWidget(
        const AppLongButton(
          label: 'Continue',
          textStyle: textStyle,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final resolvedStyle = button.style!.textStyle!.resolve(<WidgetState>{});

      expect(resolvedStyle?.fontSize, 18);
      expect(resolvedStyle?.fontWeight, FontWeight.w400);
    });

    testWidgets('forwards constructor props to AppFilledButton',
        (tester) async {
      const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);

      await tester.pumpWidget(buildTestWidget(
        AppLongButton(
          label: 'Continue',
          onPressed: () {},
          backgroundColor: AppTheme.error,
          textColor: AppTheme.white,
          padding: padding,
        ),
      ));

      final button =
          tester.widget<AppFilledButton>(find.byType(AppFilledButton));

      expect(button.label, 'Continue');
      expect(button.onPressed, isNotNull);
      expect(button.backgroundColor, AppTheme.error);
      expect(button.textColor, AppTheme.white);
      expect(button.padding, padding);
    });
  });
}
