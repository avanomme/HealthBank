// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/feedback/app_toasts.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppToast constructors', () {
    testWidgets('success toast renders default icon and message', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(AppToast.success(message: 'Saved successfully')),
      );

      expect(find.text('Saved successfully'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('custom toast applies background and border colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          AppToast.custom(
            message: 'Custom',
            backgroundColor: AppTheme.info,
            borderColor: AppTheme.error,
            textColor: AppTheme.white,
          ),
        ),
      );

      final box = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(AppToast),
          matching: find.byType(DecoratedBox),
        ),
      );
      final decoration = box.decoration as BoxDecoration;
      final text = tester.widget<Text>(find.text('Custom'));

      expect(decoration.color, AppTheme.info);
      expect((decoration.border as Border).top.color, AppTheme.error);
      expect(text.style?.color, AppTheme.white);
    });

    testWidgets('can hide the close button', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(AppToast.info(message: 'Heads up', showClose: false)),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('close button triggers onClose callback', (tester) async {
      var closed = 0;

      await tester.pumpWidget(
        buildTestWidget(
          AppToast.error(message: 'Failed', onClose: () => closed++),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(closed, 1);
    });

    testWidgets('exposes live-region semantics for the message', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(AppToast.success(message: 'Saved successfully')),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Saved successfully',
        ),
        findsOneWidget,
      );
      expect(find.byTooltip('Dismiss notification'), findsOneWidget);
    });
  });

  group('AppToast overlay helpers', () {
    testWidgets('showSuccess inserts and auto dismisses a toast', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  AppToast.showSuccess(
                    context,
                    message: 'Saved successfully',
                    duration: const Duration(milliseconds: 10),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      expect(find.text('Saved successfully'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(find.text('Saved successfully'), findsNothing);
    });

    testWidgets('showError inserts a toast into the overlay', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  AppToast.showError(
                    context,
                    message: 'Something went wrong',
                    duration: const Duration(seconds: 1),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('caution toast uses the caution icon and readable text color', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(AppToast.caution(message: 'Check your settings')),
      );

      final text = tester.widget<Text>(find.text('Check your settings'));

      expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
      expect(text.style?.color, AppTheme.textPrimary);
    });

    testWidgets('showCustom inserts a custom toast into the overlay', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  AppToast.showCustom(
                    context,
                    message: 'Custom overlay',
                    backgroundColor: AppTheme.info,
                    borderColor: AppTheme.error,
                    icon: const Icon(Icons.info_outline),
                    duration: const Duration(seconds: 1),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.text('Custom overlay'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });
}
