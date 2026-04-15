import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show questionsProvider;
import 'package:frontend/src/features/surveys/widgets/question_bank_import_dialog.dart';

import '../../../test_helpers.dart';

Question _question({
  required int id,
  required String content,
  String? title,
  String responseType = 'openended',
}) {
  return Question(
    questionId: id,
    title: title,
    questionContent: content,
    responseType: responseType,
    isRequired: false,
  );
}

Future<Future<List<Question>?>?> _openDialog(
  WidgetTester tester, {
  required List<Override> overrides,
  Set<int> existingQuestionIds = const {},
}) async {
  Future<List<Question>?>? resultFuture;

  await tester.pumpWidget(
    buildTestWidget(
      Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              resultFuture = QuestionBankImportDialog.show(
                context,
                existingQuestionIds: existingQuestionIds,
              );
            },
            child: const Text('Open Import Dialog'),
          );
        },
      ),
      overrides: overrides,
    ),
  );

  await tester.tap(find.text('Open Import Dialog'));
  await tester.pump();

  return resultFuture;
}

void main() {
  group('QuestionBankImportDialog', () {
    testWidgets('shows loading state while questions are loading', (
      tester,
    ) async {
      final completer = Completer<List<Question>>();

      await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) => completer.future),
        ],
      );

      expect(find.byType(QuestionBankImportDialog), findsOneWidget);
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows error state and retry triggers provider invalidation', (
      tester,
    ) async {
      var calls = 0;

      await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) async {
            calls++;
            if (calls == 1) {
              throw Exception('boom');
            }
            return [
              _question(id: 1, title: 'Recovered', content: 'Recovered content'),
            ];
          }),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load questions'), findsOneWidget);
      expect(find.widgetWithText(AppTextButton, 'Retry'), findsOneWidget);

      await tester.tap(find.widgetWithText(AppTextButton, 'Retry'));
      await tester.pumpAndSettle();

      expect(calls, greaterThanOrEqualTo(2));
      expect(find.text('Recovered'), findsOneWidget);
    });

    testWidgets('shows empty state when no questions available', (tester) async {
      await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) async => <Question>[]),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('No questions in bank yet'), findsOneWidget);
    });

    testWidgets('search filters by title and question content', (tester) async {
      await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) async => [
                _question(id: 1, title: 'Mood Tracker', content: 'How is mood?'),
                _question(id: 2, title: 'Sleep', content: 'Hours rested'),
              ]),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Mood Tracker'), findsOneWidget);
      expect(find.text('Sleep'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'mood');
      await tester.pumpAndSettle();
      expect(find.text('Mood Tracker'), findsOneWidget);
      expect(find.text('Sleep'), findsNothing);

      await tester.enterText(find.byType(TextField), 'hours');
      await tester.pumpAndSettle();
      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('Mood Tracker'), findsNothing);
    });

    testWidgets('shows fallback response type label when unknown', (tester) async {
      await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) async => [
                _question(
                  id: 5,
                  title: 'Custom',
                  content: 'Custom response',
                  responseType: 'custom_type',
                ),
              ]),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('custom_type'), findsOneWidget);
    });

    testWidgets('existing question is disabled and marked already added', (
      tester,
    ) async {
      await _openDialog(
        tester,
        existingQuestionIds: {2},
        overrides: [
          questionsProvider.overrideWith((ref) async => [
                _question(id: 1, title: 'Selectable', content: 'A'),
                _question(id: 2, title: 'Existing', content: 'B'),
              ]),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Already added'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);

      await tester.tap(find.text('Existing'));
      await tester.pumpAndSettle();

      final addButton = tester.widget<AppFilledButton>(find.byType(AppFilledButton));
      expect(addButton.onPressed, isNull);
    });

    testWidgets('can select questions and returns selected list on add', (
      tester,
    ) async {
      final resultFuture = await _openDialog(
        tester,
        existingQuestionIds: {3},
        overrides: [
          questionsProvider.overrideWith((ref) async => [
                _question(id: 1, title: 'Q1', content: 'One'),
                _question(id: 2, title: 'Q2', content: 'Two'),
                _question(id: 3, title: 'Q3', content: 'Three'),
              ]),
        ],
      );
      await tester.pumpAndSettle();

      AppFilledButton addButton = tester.widget<AppFilledButton>(find.byType(AppFilledButton));
      expect(addButton.onPressed, isNull);
      expect(find.text('Add Selected (0)'), findsOneWidget);

      await tester.tap(find.text('Q1'));
      await tester.pumpAndSettle();

      addButton = tester.widget<AppFilledButton>(find.byType(AppFilledButton));
      expect(addButton.onPressed, isNotNull);
      expect(find.text('Add Selected (1)'), findsOneWidget);

      await tester.tap(find.widgetWithText(AppFilledButton, 'Add Selected (1)'));
      await tester.pumpAndSettle();

      final result = await resultFuture;
      expect(result, isNotNull);
      expect(result!.map((q) => q.questionId), [1]);
    });

    testWidgets('tapping same tile twice toggles selection on and off', (
      tester,
    ) async {
      await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) async => [
                _question(id: 1, title: 'Toggle Me', content: 'One'),
              ]),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Add Selected (0)'), findsOneWidget);

      await tester.tap(find.text('Toggle Me'));
      await tester.pumpAndSettle();
      expect(find.text('Add Selected (1)'), findsOneWidget);

      await tester.tap(find.text('Toggle Me'));
      await tester.pumpAndSettle();
      expect(find.text('Add Selected (0)'), findsOneWidget);
    });

    testWidgets('checkbox onChanged covers select and deselect branches', (
      tester,
    ) async {
      await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) async => [
                _question(id: 1, title: 'Checkbox', content: 'One'),
              ]),
        ],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(find.text('Add Selected (1)'), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(find.text('Add Selected (0)'), findsOneWidget);
    });

    testWidgets('cancel button closes dialog and returns null', (tester) async {
      final resultFuture = await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) async => [
                _question(id: 1, title: 'Q1', content: 'One'),
              ]),
        ],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(AppTextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(await resultFuture, isNull);
      expect(find.byType(QuestionBankImportDialog), findsNothing);
    });

    testWidgets('close icon closes dialog and returns null', (tester) async {
      final resultFuture = await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) async => [
                _question(id: 1, title: 'Q1', content: 'One'),
              ]),
        ],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(await resultFuture, isNull);
      expect(find.byType(QuestionBankImportDialog), findsNothing);
    });

    testWidgets('shows no-results state when search has no matches', (tester) async {
      await _openDialog(
        tester,
        overrides: [
          questionsProvider.overrideWith((ref) async => [
                _question(id: 1, title: 'Alpha', content: 'One'),
              ]),
        ],
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'zzzzz');
      await tester.pumpAndSettle();

      expect(find.text('No questions in bank yet'), findsOneWidget);
    });
  });
}
