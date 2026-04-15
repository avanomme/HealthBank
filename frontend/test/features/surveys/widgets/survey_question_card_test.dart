import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/features/surveys/state/survey_providers.dart';
import 'package:frontend/src/features/surveys/widgets/survey_question_card.dart';

import '../../../test_helpers.dart';

class _FakeSurveyBuilderNotifier extends SurveyBuilderNotifier {
  _FakeSurveyBuilderNotifier(super.ref);

  QuestionCreate? lastCreateData;
  QuestionUpdate? lastUpdateData;
  int? lastUpdatedQuestionId;
  Question? createResult;
  Question? updateResult;

  @override
  Future<Question?> createAndAddQuestion(QuestionCreate createData) async {
    lastCreateData = createData;
    return createResult;
  }

  @override
  Future<Question?> updateQuestion(
    int questionId,
    QuestionUpdate updateData,
  ) async {
    lastUpdatedQuestionId = questionId;
    lastUpdateData = updateData;
    return updateResult;
  }
}

Question _buildQuestion({
  int id = 1,
  String? title = 'Mood',
  String content = 'How are you today?',
  String responseType = 'yesno',
  bool isRequired = false,
  List<QuestionOptionResponse>? options,
  int? scaleMin,
  int? scaleMax,
}) {
  return Question(
    questionId: id,
    title: title,
    questionContent: content,
    responseType: responseType,
    isRequired: isRequired,
    options: options,
    scaleMin: scaleMin,
    scaleMax: scaleMax,
  );
}

SurveyQuestionItem _buildQuestionItem({
  int id = 1,
  String? title = 'Mood',
  String content = 'How are you today?',
  String responseType = 'yesno',
  bool isRequired = false,
  List<QuestionOptionResponse>? options,
  int? scaleMin,
  int? scaleMax,
}) {
  return SurveyQuestionItem(
    questionId: id,
    title: title,
    questionContent: content,
    responseType: responseType,
    isRequired: isRequired,
    options: options,
    scaleMin: scaleMin,
    scaleMax: scaleMax,
  );
}

void main() {
  group('SurveyQuestionCard', () {
    late _FakeSurveyBuilderNotifier notifier;

    testWidgets('collapsed persisted card shows summary and focuses on tap', (
      tester,
    ) async {
      var focused = false;

      await tester.pumpWidget(
        buildTestWidget(
          SurveyQuestionCard(
            question: _buildQuestionItem(
              title: 'Mood Check',
              responseType: 'yesno',
              isRequired: true,
            ),
            index: 1,
            isFocused: false,
            onFocus: () => focused = true,
            onDelete: () {},
            onQuestionCreated: (_) {},
            isDraft: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mood Check'), findsOneWidget);
      expect(find.text('Required'), findsOneWidget);

      await tester.tap(find.text('Mood Check'));
      await tester.pumpAndSettle();

      expect(focused, true);
    });

    testWidgets('draft card validates empty question content', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SurveyQuestionCard(
            index: 0,
            isFocused: true,
            onFocus: () {},
            onDelete: () {},
            onQuestionCreated: (_) {},
            isDraft: true,
          ),
          overrides: [
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _FakeSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(SurveyQuestionCard)),
      );

      await tester.tap(find.byTooltip(l10n.surveyBuilderQuestionCardConfirm));
      await tester.pumpAndSettle();

      expect(find.text(l10n.questionFormQuestionRequired), findsOneWidget);
    });

    testWidgets('draft choice question requires at least two options', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          SurveyQuestionCard(
            index: 0,
            isFocused: true,
            onFocus: () {},
            onDelete: () {},
            onQuestionCreated: (_) {},
            isDraft: true,
          ),
          overrides: [
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _FakeSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(SurveyQuestionCard)),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.questionTypeSingleChoice).last);
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Choose one');
      await tester.enterText(textFields.at(1), 'Option A');
      await tester.enterText(textFields.at(2), '');
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(l10n.surveyBuilderQuestionCardConfirm));
      await tester.pumpAndSettle();

      expect(find.text(l10n.questionFormProvideOptions), findsOneWidget);
    });

    testWidgets('draft confirm creates question and calls callback', (
      tester,
    ) async {
      Question? createdQuestion;
      await tester.pumpWidget(
        buildTestWidget(
          SurveyQuestionCard(
            index: 0,
            isFocused: true,
            onFocus: () {},
            onDelete: () {},
            onQuestionCreated: (question) => createdQuestion = question,
            isDraft: true,
          ),
          overrides: [
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _FakeSurveyBuilderNotifier(ref)
                ..createResult = _buildQuestion(
                  id: 55,
                  title: 'Daily Mood',
                  content: 'How are you feeling?',
                );
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(SurveyQuestionCard)),
      );

      final formFields = find.byType(TextFormField);
      await tester.enterText(formFields.at(1), 'How are you feeling?');
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(l10n.surveyBuilderQuestionCardConfirm));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(createdQuestion?.questionId, 55);
      expect(notifier.lastCreateData?.questionContent, 'How are you feeling?');
      expect(notifier.lastCreateData?.title, 'How are you feeling?');
      expect(notifier.lastCreateData?.responseType, 'yesno');
    });

    testWidgets('persisted card can edit save and cancel', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SurveyQuestionCard(
            question: _buildQuestionItem(
              id: 9,
              title: 'Original title',
              content: 'Original question',
              responseType: 'single_choice',
              isRequired: false,
              options: const [
                QuestionOptionResponse(
                  optionId: 1,
                  optionText: 'Yes',
                  displayOrder: 0,
                ),
                QuestionOptionResponse(
                  optionId: 2,
                  optionText: 'No',
                  displayOrder: 1,
                ),
              ],
            ),
            index: 0,
            isFocused: true,
            onFocus: () {},
            onDelete: () {},
            onQuestionCreated: (_) {},
            isDraft: false,
          ),
          overrides: [
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _FakeSurveyBuilderNotifier(ref)
                ..updateResult = _buildQuestion(
                  id: 9,
                  title: 'Updated title',
                  content: 'Updated question',
                  responseType: 'single_choice',
                  isRequired: true,
                  options: const [
                    QuestionOptionResponse(
                      optionId: 1,
                      optionText: 'Red',
                      displayOrder: 0,
                    ),
                    QuestionOptionResponse(
                      optionId: 2,
                      optionText: 'Blue',
                      displayOrder: 1,
                    ),
                  ],
                );
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(SurveyQuestionCard)),
      );

      // Card is already in edit mode when isFocused: true — no separate edit button
      final formFields = find.byType(TextFormField);
      await tester.enterText(formFields.first, 'Updated title');
      await tester.enterText(formFields.at(1), 'Updated question');
      await tester.pumpAndSettle();

      final switches = find.byType(Switch);
      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      final optionFields = find.byType(TextField);
      await tester.enterText(optionFields.at(2), 'Red');
      await tester.enterText(optionFields.at(3), 'Blue');
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(l10n.surveyBuilderQuestionCardSave));
      await tester.pumpAndSettle();

      expect(notifier.lastUpdatedQuestionId, 9);
      expect(notifier.lastUpdateData?.title, 'Updated title');
      expect(notifier.lastUpdateData?.questionContent, 'Updated question');
      // isRequired is now null in QuestionUpdate (deprecated at bank level;
      // required-ness is handled via setQuestionRequired on the survey link)
      expect(notifier.lastUpdateData?.isRequired, isNull);
      expect(notifier.lastUpdateData?.options?.map((o) => o.optionText), [
        'Red',
        'Blue',
      ]);

      await tester.enterText(formFields.first, 'Throwaway title');
      await tester.pumpAndSettle();
      await tester.tap(
        find.byTooltip(l10n.surveyBuilderQuestionCardCancelEdit),
      );
      await tester.pumpAndSettle();

      expect(find.text('Original title'), findsOneWidget);
    });

    testWidgets('delete button calls onDelete', (tester) async {
      var deleted = false;

      await tester.pumpWidget(
        buildTestWidget(
          SurveyQuestionCard(
            question: _buildQuestionItem(),
            index: 0,
            isFocused: true,
            onFocus: () {},
            onDelete: () => deleted = true,
            onQuestionCreated: (_) {},
            isDraft: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(SurveyQuestionCard)),
      );

      await tester.tap(find.byTooltip(l10n.surveyBuilderRemoveQuestion));
      await tester.pumpAndSettle();

      expect(deleted, true);
    });

    testWidgets('reflows expanded controls at narrow width with large text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(460, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: SurveyQuestionCard(
              question: _buildQuestionItem(
                id: 7,
                title: 'Long question title for layout testing',
                content: 'How strongly do you agree with this statement?',
                responseType: 'scale',
                isRequired: true,
                scaleMin: 1,
                scaleMax: 7,
              ),
              index: 0,
              isFocused: true,
              onFocus: () {},
              onDelete: () {},
              onQuestionCreated: (_) {},
              isDraft: false,
            ),
          ),
          overrides: [
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _FakeSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(SurveyQuestionCard)),
      );
      // Card is already in edit mode when isFocused: true — no separate edit button
      expect(find.text(l10n.questionFormScaleMin), findsOneWidget);
      expect(find.text(l10n.questionFormScaleMax), findsOneWidget);
      expect(find.text(l10n.questionFormRequiredLabel), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
