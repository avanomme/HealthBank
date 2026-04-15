// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/feedback/app_confirm_dialog.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppConfirmDialog', () {
    testWidgets('renders title, content, and action labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppConfirmDialog(
          title: 'Delete item',
          content: 'This action cannot be undone.',
          confirmLabel: 'Delete',
          cancelLabel: 'Keep',
        ),
      ));

      expect(find.text('Delete item'), findsOneWidget);
      expect(find.text('This action cannot be undone.'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Keep'), findsOneWidget);
    });

    testWidgets('invokes onConfirm when confirm button is tapped',
        (tester) async {
      var confirmed = 0;

      await tester.pumpWidget(buildTestWidget(
        AppConfirmDialog(
          title: 'Delete item',
          content: 'This action cannot be undone.',
          confirmLabel: 'Delete',
          onConfirm: () => confirmed++,
        ),
      ));

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(confirmed, 1);
    });

    testWidgets('show returns true when confirmed', (tester) async {
      late Future<bool> result;

      await tester.pumpWidget(buildTestWidget(
        Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                result = AppConfirmDialog.show(
                  context,
                  title: 'Delete item',
                  content: 'This action cannot be undone.',
                  confirmLabel: 'Delete',
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(await result, isTrue);
    });

    testWidgets('show returns false when cancelled', (tester) async {
      late Future<bool> result;

      await tester.pumpWidget(buildTestWidget(
        Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                result = AppConfirmDialog.show(
                  context,
                  title: 'Delete item',
                  content: 'This action cannot be undone.',
                  confirmLabel: 'Delete',
                  cancelLabel: 'Cancel',
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(await result, isFalse);
    });

    testWidgets('uses the error color for dangerous confirmations',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppConfirmDialog(
          title: 'Delete item',
          content: 'This action cannot be undone.',
          confirmLabel: 'Delete',
          isDangerous: true,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(
        button.style!.backgroundColor!.resolve(<WidgetState>{}),
        AppTheme.error,
      );
    });

    testWidgets('uses Cancel as the default cancel label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppConfirmDialog(
          title: 'Delete item',
          content: 'This action cannot be undone.',
          confirmLabel: 'Delete',
        ),
      ));

      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('prefers explicit confirmColor over dangerous defaults',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppConfirmDialog(
          title: 'Delete item',
          content: 'This action cannot be undone.',
          confirmLabel: 'Delete',
          confirmColor: AppTheme.success,
          isDangerous: true,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(
        button.style!.backgroundColor!.resolve(<WidgetState>{}),
        AppTheme.success,
      );
    });

    testWidgets('does not auto-dismiss when a custom onConfirm is supplied',
        (tester) async {
      var confirmed = 0;

      await tester.pumpWidget(buildTestWidget(
        AppConfirmDialog(
          title: 'Delete item',
          content: 'This action cannot be undone.',
          confirmLabel: 'Delete',
          onConfirm: () => confirmed++,
        ),
      ));

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(confirmed, 1);
      expect(find.text('Delete item'), findsOneWidget);
    });
  });
}
