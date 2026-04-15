// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/micro/app_rich_text.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppRichText', () {
    TextSpan span() => const TextSpan(
          text: 'Terms ',
          children: [
            TextSpan(
              text: 'of Service',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        );

    testWidgets('renders rich text content', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppRichText(text: span()),
      ));

      final richText = tester.widget<RichText>(find.byType(RichText));
      final root = richText.text as TextSpan;

      expect(root.toPlainText(), 'Terms of Service');
    });

    testWidgets('uses the requested variant as the base style',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppRichText(
          text: span(),
          variant: AppTextVariant.headlineSmall,
        ),
      ));

      final richText = tester.widget<RichText>(find.byType(RichText));
      final root = richText.text as TextSpan;
      expect(root.style?.fontSize, isNotNull);
    });

    testWidgets('preserves child span formatting', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppRichText(text: span()),
      ));

      final richText = tester.widget<RichText>(find.byType(RichText));
      final root = richText.text as TextSpan;
      final child = root.children!.first as TextSpan;

      expect(child.text, 'of Service');
      expect(child.style?.fontWeight, FontWeight.w700);
    });

    testWidgets('forwards alignment and overflow options', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        SizedBox(
          width: 70,
          child: AppRichText(
            text: span(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ));

      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.textAlign, TextAlign.center);
      expect(richText.maxLines, 1);
      expect(richText.overflow, TextOverflow.ellipsis);
      expect(richText.softWrap, isFalse);
    });

    testWidgets('uses the current text scaler from MediaQuery',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppRichText(text: span()),
      ));

      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.textScaler, isNotNull);
    });
  });
}
