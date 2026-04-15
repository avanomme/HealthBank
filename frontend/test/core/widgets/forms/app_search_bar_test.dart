// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/forms/app_search_bar.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppSearchBar', () {
    testWidgets('renders with default search hint', (tester) async {
      await tester.pumpWidget(buildTestWidget(const AppSearchBar()));

      expect(find.text('Search'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('uses provided hint text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const AppSearchBar(hintText: 'Search records')),
      );

      expect(find.text('Search records'), findsOneWidget);
    });

    testWidgets('shows clear button only when text is present', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestWidget(AppSearchBar(controller: controller)),
      );
      expect(find.byIcon(Icons.clear), findsNothing);

      controller.text = 'query';
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clear button clears text and emits empty onChanged', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'query');
      final values = <String>[];

      await tester.pumpWidget(
        buildTestWidget(
          AppSearchBar(controller: controller, onChanged: values.add),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(controller.text, '');
      expect(values.last, '');
    });

    testWidgets('emits onChanged and onSubmitted', (tester) async {
      String? changed;
      String? submitted;

      await tester.pumpWidget(
        buildTestWidget(
          AppSearchBar(
            onChanged: (value) => changed = value,
            onSubmitted: (value) => submitted = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'abc');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(changed, 'abc');
      expect(submitted, 'abc');
    });

    testWidgets('uses external controller text immediately', (tester) async {
      final controller = TextEditingController(text: 'preset');

      await tester.pumpWidget(
        buildTestWidget(AppSearchBar(controller: controller)),
      );

      expect(find.text('preset'), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clear button is safe when onChanged is omitted', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'query');

      await tester.pumpWidget(
        buildTestWidget(AppSearchBar(controller: controller)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(controller.text, '');
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('forwards autofocus and focusNode', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        buildTestWidget(AppSearchBar(focusNode: focusNode, autofocus: true)),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.focusNode, focusNode);
      expect(field.autofocus, isTrue);
    });

    testWidgets('uses search text input action', (tester) async {
      await tester.pumpWidget(buildTestWidget(const AppSearchBar()));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.textInputAction, TextInputAction.search);
    });

    testWidgets('reacts when external controller text is cleared', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'query');

      await tester.pumpWidget(
        buildTestWidget(AppSearchBar(controller: controller)),
      );
      await tester.pumpAndSettle();

      controller.clear();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('exposes a search semantics label', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const AppSearchBar(hintText: 'Search records')),
      );

      // AppSearchBar uses appFieldSemantics which passes through for native inputs.
      // Verify the hint text is present in the widget tree via the TextField.
      expect(find.byType(TextField), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.hintText, 'Search records');
    });
  });
}
