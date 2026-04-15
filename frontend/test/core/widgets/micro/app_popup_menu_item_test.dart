// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_popup_menu_item.dart';

import '../../../test_helpers.dart';

void main() {
  group('appPopupMenuItem', () {
    testWidgets('renders icon and label in a popup menu', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PopupMenuButton<String>(
          itemBuilder: (context) => [
            appPopupMenuItem<String>(
              value: 'edit',
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
      ));

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('returns the selected value when tapped', (tester) async {
      String? selected;

      await tester.pumpWidget(buildTestWidget(
        PopupMenuButton<String>(
          onSelected: (value) => selected = value,
          itemBuilder: (context) => [
            appPopupMenuItem<String>(
              value: 'edit',
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
      ));

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit').last);
      await tester.pumpAndSettle();

      expect(selected, 'edit');
    });

    testWidgets('applies a custom icon color when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PopupMenuButton<String>(
          itemBuilder: (context) => [
            appPopupMenuItem<String>(
              value: 'archive',
              icon: Icons.archive,
              label: 'Archive',
              color: AppTheme.info,
            ),
          ],
        ),
      ));

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.archive));
      expect(icon.color, AppTheme.info);
    });

    testWidgets('uses the destructive helper error color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PopupMenuButton<String>(
          itemBuilder: (context) => [
            appPopupMenuItemDestructive<String>(
              value: 'delete',
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
      ));

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.delete));
      expect(icon.color, AppTheme.error);
      final text = tester.widget<Text>(find.text('Delete'));
      expect(text.style?.color, AppTheme.error);
    });

    test('returns a PopupMenuItem with the requested value', () {
      final item = appPopupMenuItem<String>(
        value: 'edit',
        icon: Icons.edit,
        label: 'Edit',
      );

      expect(item.value, 'edit');
    });

    testWidgets('applies custom icon size and text color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PopupMenuButton<String>(
          itemBuilder: (context) => [
            appPopupMenuItem<String>(
              value: 'share',
              icon: Icons.share,
              label: 'Share',
              color: AppTheme.success,
              iconSize: 28,
            ),
          ],
        ),
      ));

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.share));
      final text = tester.widget<Text>(find.text('Share'));
      expect(icon.size, 28);
      expect(icon.color, AppTheme.success);
      expect(text.style?.color, AppTheme.success);
    });

    testWidgets('uses default text styling when no custom color is provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PopupMenuButton<String>(
          itemBuilder: (context) => [
            appPopupMenuItem<String>(
              value: 'view',
              icon: Icons.visibility,
              label: 'View',
            ),
          ],
        ),
      ));

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.visibility));
      final text = tester.widget<Text>(find.text('View'));
      expect(icon.color, isNull);
      expect(text.style, isNull);
    });

    testWidgets('works with non-string generic values', (tester) async {
      int? selected;

      await tester.pumpWidget(buildTestWidget(
        PopupMenuButton<int>(
          onSelected: (value) => selected = value,
          itemBuilder: (context) => [
            appPopupMenuItem<int>(
              value: 42,
              icon: Icons.pin,
              label: 'Pin',
            ),
          ],
        ),
      ));

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pin').last);
      await tester.pumpAndSettle();

      expect(selected, 42);
    });

    testWidgets('destructive helper keeps the default icon size',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        PopupMenuButton<String>(
          itemBuilder: (context) => [
            appPopupMenuItemDestructive<String>(
              value: 'delete',
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
      ));

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.delete));
      expect(icon.size, 20);
    });
  });
}
