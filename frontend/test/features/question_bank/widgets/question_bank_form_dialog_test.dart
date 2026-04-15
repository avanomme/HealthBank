import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart';
import 'package:frontend/src/features/question_bank/widgets/question_bank_form_dialog.dart';

import '../../../test_helpers.dart';

class _FakeQuestionApi implements QuestionApi {
  QuestionCreate? lastCreate;
  QuestionUpdate? lastUpdate;
  int? lastUpdatedId;
  Question? createResult;
  Question? updateResult;
  Object? error;

  @override
  Future<Question> createQuestion(QuestionCreate question) async {
    lastCreate = question;
    if (error != null) throw error!;
    return createResult ??
        const Question(
          questionId: 100,
          title: 'Created',
          questionContent: 'Created question',
          responseType: 'yesno',
          isRequired: false,
        );
  }

  @override
  Future<Question> updateQuestion(int id, QuestionUpdate question) async {
    lastUpdatedId = id;
    lastUpdate = question;
    if (error != null) throw error!;
    return updateResult ??
        const Question(
          questionId: 100,
          title: 'Updated',
          questionContent: 'Updated question',
          responseType: 'yesno',
          isRequired: false,
        );
  }

  @override
  Future<void> deleteQuestion(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<Question> getQuestion(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<QuestionCategory>> listCategories() async {
    throw UnimplementedError();
  }

  @override
  Future<List<Question>> listQuestions({
    String? responseType,
    String? category,
    bool? isActive,
  }) async {
    throw UnimplementedError();
  }
}

class _QuestionDialogHarness extends StatefulWidget {
  const _QuestionDialogHarness({this.question});

  final Question? question;

  @override
  State<_QuestionDialogHarness> createState() => _QuestionDialogHarnessState();
}

class _QuestionDialogHarnessState extends State<_QuestionDialogHarness> {
  String _result = 'none';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final result = await QuestionBankFormDialog.show(
              context,
              question: widget.question,
            );
            setState(() {
              _result = result?.title ?? result?.questionContent ?? 'null';
            });
          },
          child: const Text('Open'),
        ),
        Text(_result),
      ],
    );
  }
}

void main() {
  group('QuestionBankFormDialog', () {
    late _FakeQuestionApi api;

    setUp(() {
      api = _FakeQuestionApi();
    });

    Future<void> openDialog(
      WidgetTester tester, {
      Question? question,
    }) async {
      await tester.pumpWidget(buildTestWidget(
        _QuestionDialogHarness(question: question),
        overrides: [
          questionApiProvider.overrideWith((ref) => api),
          questionsProvider.overrideWith((ref) async => const <Question>[]),
        ],
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    testWidgets('validates required question content', (tester) async {
      await openDialog(tester);

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(find.text('Question text is required'), findsOneWidget);
      expect(api.lastCreate, isNull);
    });

    testWidgets('choice type requires at least two options', (tester) async {
      await openDialog(tester);

      await tester.tap(find.widgetWithText(ChoiceChip, 'Single Choice'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Question *').first,
        'Pick one answer',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Option 1'),
        'Option A',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Option 2'),
        '',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(find.text('Please provide at least 2 options'), findsOneWidget);
      expect(api.lastCreate, isNull);
    });

    testWidgets('create mode submits question and returns dialog result',
        (tester) async {
      api.createResult = const Question(
        questionId: 44,
        title: 'Mood Tracker',
        questionContent: 'How is your mood today?',
        responseType: 'scale',
        isRequired: true,
        category: 'wellbeing',
        scaleMin: 1,
        scaleMax: 5,
      );

      await openDialog(tester);

      await tester.tap(find.text('Scale'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.first, '');
      await tester.enterText(fields.at(1), 'How is your mood today?');
      await tester.enterText(fields.at(2), '2');
      await tester.enterText(fields.at(3), '7');
      await tester.enterText(fields.at(4), 'wellbeing');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Create'));
      await tester.tap(find.text('Create'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(api.lastCreate?.title, 'How is your mood today?');
      expect(api.lastCreate?.questionContent, 'How is your mood today?');
      expect(api.lastCreate?.responseType, 'scale');
      expect(api.lastCreate?.scaleMin, 2);
      expect(api.lastCreate?.scaleMax, 7);
      expect(api.lastCreate?.isRequired, false);
      expect(find.text('Mood Tracker'), findsOneWidget);
    });

    testWidgets('edit mode populates fields and saves updates', (tester) async {
      api.updateResult = const Question(
        questionId: 7,
        title: 'Updated title',
        questionContent: 'Updated content',
        responseType: 'single_choice',
        isRequired: true,
        category: 'updated',
        options: [
          QuestionOptionResponse(optionId: 1, optionText: 'Red', displayOrder: 0),
          QuestionOptionResponse(optionId: 2, optionText: 'Blue', displayOrder: 1),
        ],
      );

      await openDialog(
        tester,
        question: const Question(
          questionId: 7,
          title: 'Original title',
          questionContent: 'Original content',
          responseType: 'single_choice',
          isRequired: false,
          category: 'original',
          options: [
            QuestionOptionResponse(optionId: 1, optionText: 'Yes', displayOrder: 0),
            QuestionOptionResponse(optionId: 2, optionText: 'No', displayOrder: 1),
          ],
        ),
      );

      expect(find.text('Edit Question'), findsOneWidget);
      expect(find.text('Original title'), findsOneWidget);
      expect(find.text('Original content'), findsOneWidget);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.first, 'Updated title');
      await tester.enterText(fields.at(1), 'Updated content');
      await tester.enterText(fields.at(2), 'Red');
      await tester.enterText(fields.at(3), 'Blue');
      await tester.enterText(fields.at(4), 'updated');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(api.lastUpdatedId, 7);
      expect(api.lastUpdate?.title, 'Updated title');
      expect(api.lastUpdate?.questionContent, 'Updated content');
      expect(api.lastUpdate?.category, 'updated');
      expect(api.lastUpdate?.isRequired, isNull); // deprecated at bank level
      expect(api.lastUpdate?.options?.map((o) => o.optionText), ['Red', 'Blue']);
      expect(find.text('Updated title'), findsOneWidget);
    });
  });
}
