// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_text_button.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppTextButton', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTextButton(label: 'Learn more'),
      ));

      expect(find.widgetWithText(TextButton, 'Learn more'), findsOneWidget);
    });

    testWidgets('fires callback when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(buildTestWidget(
        AppTextButton(
          label: 'Learn more',
          onPressed: () => taps++,
        ),
      ));

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('is disabled when callback is omitted', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTextButton(label: 'Disabled'),
      ));

      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('applies text color and padding overrides', (tester) async {
      const padding = EdgeInsets.symmetric(horizontal: 10, vertical: 6);

      await tester.pumpWidget(buildTestWidget(
        const AppTextButton(
          label: 'Styled',
          textColor: AppTheme.success,
          padding: padding,
        ),
      ));

      final button = tester.widget<TextButton>(find.byType(TextButton));
      final style = button.style!;

      expect(style.foregroundColor!.resolve(<WidgetState>{}), AppTheme.success);
      expect(style.padding!.resolve(<WidgetState>{}), padding);
    });

    testWidgets('uses a custom text style when provided', (tester) async {
      const style = TextStyle(fontSize: 22, fontWeight: FontWeight.w400);

      await tester.pumpWidget(buildTestWidget(
        const AppTextButton(
          label: 'Styled',
          textStyle: style,
        ),
      ));

      final button = tester.widget<TextButton>(find.byType(TextButton));
      final resolvedStyle = button.style!.textStyle!.resolve(<WidgetState>{});

      expect(resolvedStyle?.fontSize, 22);
      expect(resolvedStyle?.fontWeight, FontWeight.w400);
    });

    testWidgets('uses primary color and semi-bold weight by default',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTextButton(label: 'Default'),
      ));

      final button = tester.widget<TextButton>(find.byType(TextButton));
      final style = button.style!;
      final resolvedStyle = style.textStyle!.resolve(<WidgetState>{});

      expect(style.foregroundColor!.resolve(<WidgetState>{}), AppTheme.primary);
      expect(resolvedStyle?.fontWeight, FontWeight.w600);
    });

    testWidgets('textColor override wins over a custom style color',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppTextButton(
          label: 'Styled',
          textColor: AppTheme.error,
          textStyle: TextStyle(color: AppTheme.success),
        ),
      ));

      final button = tester.widget<TextButton>(find.byType(TextButton));

      expect(
        button.style!.foregroundColor!.resolve(<WidgetState>{}),
        AppTheme.error,
      );
    });

    testWidgets('uses responsive default padding based on available width',
        (tester) async {
      Future<EdgeInsetsGeometry?> pumpForWidth(double width) async {
        await tester.pumpWidget(buildTestWidget(
          MediaQuery(
            data: MediaQueryData(size: Size(width, 800)),
            child: const AppTextButton(label: 'Responsive'),
          ),
        ));

        final button = tester.widget<TextButton>(find.byType(TextButton));
        return button.style!.padding!.resolve(<WidgetState>{});
      }

      final compactPadding = await pumpForWidth(500);
      final expandedPadding = await pumpForWidth(1200);

      expect((compactPadding as EdgeInsets).left, closeTo(9.6, 0.001));
      expect(compactPadding.right, closeTo(9.6, 0.001));
      expect(compactPadding.top, closeTo(6.4, 0.001));
      expect(compactPadding.bottom, closeTo(6.4, 0.001));

      expect((expandedPadding as EdgeInsets).left, closeTo(14.4, 0.001));
      expect(expandedPadding.right, closeTo(14.4, 0.001));
      expect(expandedPadding.top, closeTo(9.6, 0.001));
      expect(expandedPadding.bottom, closeTo(9.6, 0.001));
    });
  });
}
