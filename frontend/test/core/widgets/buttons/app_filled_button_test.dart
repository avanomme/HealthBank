// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_filled_button.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppFilledButton', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppFilledButton(label: 'Save changes'),
      ));

      expect(find.widgetWithText(ElevatedButton, 'Save changes'), findsOneWidget);
    });

    testWidgets('fires onPressed when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppFilledButton(
          label: 'Submit',
          onPressed: () => taps++,
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppFilledButton(label: 'Disabled'),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('applies background, text color, and padding overrides',
        (tester) async {
      const padding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);

      await tester.pumpWidget(buildTestWidget(
        const AppFilledButton(
          label: 'Styled',
          backgroundColor: AppTheme.error,
          textColor: AppTheme.white,
          padding: padding,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style!;

      expect(style.backgroundColor!.resolve(<WidgetState>{}), AppTheme.error);
      expect(style.foregroundColor!.resolve(<WidgetState>{}), AppTheme.white);
      expect(style.padding!.resolve(<WidgetState>{}), padding);
    });

    testWidgets('uses custom textStyle weight when provided', (tester) async {
      const textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);

      await tester.pumpWidget(buildTestWidget(
        const AppFilledButton(
          label: 'Custom style',
          textStyle: textStyle,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final resolvedStyle = button.style!.textStyle!.resolve(<WidgetState>{});

      expect(resolvedStyle?.fontSize, 20);
      expect(resolvedStyle?.fontWeight, FontWeight.w400);
    });

    testWidgets('uses theme defaults when overrides are omitted',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppFilledButton(label: 'Default'),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = button.style!;
      final resolvedStyle = style.textStyle!.resolve(<WidgetState>{});

      expect(style.backgroundColor!.resolve(<WidgetState>{}), AppTheme.primary);
      expect(
        style.foregroundColor!.resolve(<WidgetState>{}),
        AppTheme.textContrast,
      );
      expect(resolvedStyle?.fontWeight, FontWeight.w600);
    });

    testWidgets('configures disabled colors for disabled state',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppFilledButton(label: 'Disabled'),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final states = <WidgetState>{WidgetState.disabled};

      expect(button.style!.backgroundColor!.resolve(states), AppTheme.muted);
      expect(
        button.style!.foregroundColor!.resolve(states),
        AppTheme.textContrast,
      );
    });

    testWidgets('uses responsive default padding based on available width',
        (tester) async {
      Future<EdgeInsetsGeometry?> pumpForWidth(double width) async {
        await tester.pumpWidget(buildTestWidget(
          MediaQuery(
            data: MediaQueryData(size: Size(width, 800)),
            child: const AppFilledButton(label: 'Responsive'),
          ),
        ));

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        return button.style!.padding!.resolve(<WidgetState>{});
      }

      final compactPadding = await pumpForWidth(500);
      final expandedPadding = await pumpForWidth(1200);

      expect((compactPadding as EdgeInsets).left, closeTo(12.8, 0.001));
      expect(compactPadding.right, closeTo(12.8, 0.001));
      expect(compactPadding.top, closeTo(8, 0.001));
      expect(compactPadding.bottom, closeTo(8, 0.001));

      expect((expandedPadding as EdgeInsets).left, closeTo(19.2, 0.001));
      expect(expandedPadding.right, closeTo(19.2, 0.001));
      expect(expandedPadding.top, closeTo(12, 0.001));
      expect(expandedPadding.bottom, closeTo(12, 0.001));
    });
  });
}
