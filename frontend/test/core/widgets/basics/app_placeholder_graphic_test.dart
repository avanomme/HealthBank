// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/basics/app_image.dart';
import 'package:frontend/src/core/widgets/basics/app_placeholder_graphic.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppPlaceholderGraphic', () {
    testWidgets('renders through AppImage', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPlaceholderGraphic(),
      ));

      expect(find.byType(AppImage), findsOneWidget);
    });

    testWidgets('uses the default placeholder asset', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPlaceholderGraphic(),
      ));

      final image = tester.widget<AppImage>(find.byType(AppImage));
      expect(image.image, isA<AssetImage>());
      expect((image.image as AssetImage).assetName, 'assets/placeholder_image.jpg');
    });

    testWidgets('forwards fit and aspect ratio overrides', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPlaceholderGraphic(
          fit: BoxFit.contain,
          aspectRatio: 1.5,
        ),
      ));

      final image = tester.widget<AppImage>(find.byType(AppImage));
      expect(image.fit, BoxFit.contain);
      expect(image.aspectRatio, 1.5);
    });

    testWidgets('forwards border radius override', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPlaceholderGraphic(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ));

      final image = tester.widget<AppImage>(find.byType(AppImage));
      expect(image.borderRadius, const BorderRadius.all(Radius.circular(12)));
    });

    testWidgets('forwards semantics configuration', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppPlaceholderGraphic(
          semanticLabel: 'Placeholder',
          excludeFromSemantics: true,
        ),
      ));

      final image = tester.widget<AppImage>(find.byType(AppImage));
      expect(image.semanticLabel, 'Placeholder');
      expect(image.excludeFromSemantics, isTrue);
    });
  });
}
