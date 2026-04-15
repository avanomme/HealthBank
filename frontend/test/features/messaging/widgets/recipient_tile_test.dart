import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/messaging/widgets/recipient_tile.dart';

import '../../../test_helpers.dart';

void main() {
  group('RecipientTile', () {
    testWidgets('renders name and icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          RecipientTile(
            name: 'Ada Lovelace',
            icon: Icons.person_outline,
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          RecipientTile(
            name: 'Ada Lovelace',
            icon: Icons.person_outline,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(RecipientTile));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
