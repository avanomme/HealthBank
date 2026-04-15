import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/basics/healthbank_logo.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/app_empty_state.dart';
import 'package:frontend/src/features/surveys/widgets/question_types/question_types.dart';
import 'package:frontend/src/features/templates/widgets/template_preview_dialog.dart';

import '../../test_helpers.dart';

Template _template({
  int id = 1,
  String title = 'Template Preview',
  List<QuestionInTemplate>? questions,
}) {
  return Template(
    templateId: id,
    title: title,
    isPublic: false,
    description: 'Preview description',
    questions: questions,
  );
}

QuestionInTemplate _question({
  required int id,
  required String responseType,
  String? title,
  String content = 'Question body',
  bool isRequired = false,
  List<QuestionOption>? options,
}) {
  return QuestionInTemplate(
    questionId: id,
    title: title,
    questionContent: content,
    responseType: responseType,
    isRequired: isRequired,
    displayOrder: id,
    options: options,
  );
}

Future<void> _openPreview(WidgetTester tester, Template template) async {
  await tester.pumpWidget(
    buildTestWidget(
      Builder(
        builder: (context) {
          return Center(
            child: ElevatedButton(
              onPressed: () => showTemplatePreview(context, template),
              child: const Text('Open Preview'),
            ),
          );
        },
      ),
    ),
  );

  await tester.tap(find.text('Open Preview'));
  await tester.pumpAndSettle();
}

void main() {
  group('TemplatePreviewDialog', () {
    testWidgets('showTemplatePreview opens dialog and shows template title', (
      tester,
    ) async {
      const templateTitle = 'Stress Screener';

      await _openPreview(
        tester,
        _template(
          title: templateTitle,
          questions: const [
            QuestionInTemplate(
              questionId: 1,
              title: 'Q1',
              questionContent: 'How are you?',
              responseType: 'openended',
              isRequired: false,
              displayOrder: 1,
            ),
          ],
        ),
      );

      expect(find.byType(TemplatePreviewDialog), findsOneWidget);
      expect(find.text(templateTitle), findsOneWidget);
      expect(find.byIcon(Icons.preview), findsOneWidget);
      expect(find.byType(HealthBankLogoHeader), findsOneWidget);
    });

    testWidgets('renders empty state when template has no questions', (
      tester,
    ) async {
      await _openPreview(tester, _template(questions: const []));

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.byIcon(Icons.quiz_outlined), findsOneWidget);
    });

    testWidgets('renders supported question widgets by response type', (
      tester,
    ) async {
      final singleChoiceQuestion = _question(
        id: 4,
        responseType: 'single_choice',
        title: 'Single choice question',
        options: const [
          QuestionOption(optionId: 1, optionText: 'A', displayOrder: 1),
          QuestionOption(optionId: 2, optionText: 'B', displayOrder: 2),
        ],
      );
      final multiChoiceQuestion = _question(
        id: 5,
        responseType: 'multi_choice',
        title: 'Multi choice question',
        options: const [
          QuestionOption(optionId: 3, optionText: 'X', displayOrder: 1),
          QuestionOption(optionId: 4, optionText: 'Y', displayOrder: 2),
        ],
      );

      await _openPreview(
        tester,
        _template(questions: [_question(id: 1, responseType: 'number')]),
      );
      expect(find.byType(NumberQuestionWidget), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      await _openPreview(
        tester,
        _template(questions: [_question(id: 2, responseType: 'yesno')]),
      );
      expect(find.byType(YesNoQuestionWidget), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      await _openPreview(
        tester,
        _template(questions: [_question(id: 3, responseType: 'openended')]),
      );
      expect(find.byType(OpenEndedQuestionWidget), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      await _openPreview(tester, _template(questions: [singleChoiceQuestion]));
      expect(find.byType(SingleChoiceWidget), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      await _openPreview(tester, _template(questions: [multiChoiceQuestion]));
      expect(find.byType(MultiChoiceWidget), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      await _openPreview(
        tester,
        _template(questions: [_question(id: 6, responseType: 'scale')]),
      );
      expect(find.byType(ScaleQuestionWidget), findsOneWidget);
    });

    testWidgets('renders date and time questions with outlined action buttons', (
      tester,
    ) async {
      await _openPreview(
        tester,
        _template(
          questions: [
            _question(
              id: 10,
              responseType: 'date',
              title: 'Date question',
              isRequired: true,
            ),
            _question(
              id: 11,
              responseType: 'time',
              title: 'Time question',
              isRequired: true,
            ),
          ],
        ),
      );

      expect(find.text('Date question'), findsOneWidget);
      expect(find.text('Time question'), findsOneWidget);
      expect(find.byType(AppOutlinedButton), findsNWidgets(2));
      expect(find.text('*'), findsNWidgets(2));
    });

    testWidgets('renders fallback for unsupported question type', (tester) async {
      await _openPreview(
        tester,
        _template(
          questions: [
            _question(
              id: 20,
              responseType: 'unsupported_type',
              title: 'Unsupported question',
            ),
          ],
        ),
      );

      expect(find.text('Unsupported question'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('close icon dismisses dialog', (tester) async {
      await _openPreview(
        tester,
        _template(
          questions: const [
            QuestionInTemplate(
              questionId: 30,
              title: 'Q',
              questionContent: 'Body',
              responseType: 'openended',
              isRequired: false,
              displayOrder: 1,
            ),
          ],
        ),
      );

      expect(find.byType(TemplatePreviewDialog), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(TemplatePreviewDialog), findsNothing);
    });

    testWidgets('footer close button dismisses dialog', (tester) async {
      await _openPreview(
        tester,
        _template(
          questions: const [
            QuestionInTemplate(
              questionId: 40,
              title: 'Q',
              questionContent: 'Body',
              responseType: 'openended',
              isRequired: false,
              displayOrder: 1,
            ),
          ],
        ),
      );

      expect(find.byType(TemplatePreviewDialog), findsOneWidget);

      await tester.tap(find.widgetWithText(AppFilledButton, 'Close'));
      await tester.pumpAndSettle();

      expect(find.byType(TemplatePreviewDialog), findsNothing);
    });
  });
}
