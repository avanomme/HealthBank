// Created with the Assistance of Codex
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/basics/app_image.dart';

import '../../../test_helpers.dart';

final _transparentPixel = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);

void main() {
  group('AppImage', () {
    ImageProvider provider() => MemoryImage(_transparentPixel);

    testWidgets('renders an Image with the provided source', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppImage(image: provider()),
      ));

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<MemoryImage>());
    });

    testWidgets('forwards fit, alignment, semantics, and explicit size',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppImage(
          image: provider(),
          fit: BoxFit.contain,
          alignment: Alignment.topLeft,
          width: 80,
          height: 40,
          semanticLabel: 'Preview',
          excludeFromSemantics: true,
        ),
      ));

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.contain);
      expect(image.alignment, Alignment.topLeft);
      expect(image.width, 80);
      expect(image.height, 40);
      expect(image.semanticLabel, 'Preview');
      expect(image.excludeFromSemantics, isTrue);
    });

    testWidgets('wraps image in AspectRatio when aspectRatio is provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        SizedBox(
          width: 120,
          child: AppImage(
            image: provider(),
            aspectRatio: 2,
          ),
        ),
      ));

      final ratio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(ratio.aspectRatio, 2);
    });

    testWidgets('does not wrap in AspectRatio when width and height are both set',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppImage(
          image: provider(),
          aspectRatio: 2,
          width: 80,
          height: 40,
        ),
      ));

      expect(find.byType(AspectRatio), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('wraps image in ClipRRect when borderRadius is provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        AppImage(
          image: provider(),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
      ));

      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, const BorderRadius.all(Radius.circular(12)));
    });
  });
}
