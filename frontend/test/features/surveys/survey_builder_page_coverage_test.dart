import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/surveys/pages/survey_builder_page.dart';
import 'package:frontend/src/features/surveys/state/survey_providers.dart';
import 'package:frontend/src/features/surveys/widgets/question_bank_import_dialog.dart';
import 'package:frontend/src/features/surveys/widgets/survey_preview_dialog.dart';
import 'package:frontend/src/features/templates/pages/template_list_page.dart';

import '../../test_helpers.dart';

class _TestSurveyBuilderNotifier extends SurveyBuilderNotifier {
  _TestSurveyBuilderNotifier(
    super.ref, {
    this.saveDraftResult,
    this.saveAndPublishResult,
    });

  final Survey? saveDraftResult;
  final Survey? saveAndPublishResult;

  int resetCalls = 0;
  int saveDraftCalls = 0;
  int saveAndPublishCalls = 0;
  int addQuestionsCalls = 0;
  int reorderCalls = 0;
  int clearErrorCalls = 0;
  int? lastLoadedSurveyId;
  int? lastLoadedTemplateId;
  (int, int)? lastReorder;

  void setTestState(SurveyBuilderState next) {
    state = next;
  }

  @override
  void reset() {
    resetCalls++;
  }

  @override
  Future<void> loadSurvey(int surveyId) async {
    lastLoadedSurveyId = surveyId;
    await Future<void>.microtask(() {});
    state = SurveyBuilderState(
      surveyId: surveyId,
      title: 'Loaded Survey',
      description: 'Loaded description',
      questions: const [
        SurveyQuestionItem(
          questionId: 1,
          questionContent: 'Loaded question',
          responseType: 'openended',
          isRequired: false,
        ),
      ],
    );
  }

  @override
  Future<void> loadFromTemplate(int templateId) async {
    lastLoadedTemplateId = templateId;
    await Future<void>.microtask(() {});
    state = const SurveyBuilderState(
      title: 'Template Survey',
      questions: [
        SurveyQuestionItem(
          questionId: 2,
          questionContent: 'Template question',
          responseType: 'yesno',
          isRequired: false,
        ),
      ],
    );
  }

  @override
  Future<Survey?> saveDraft() async {
    saveDraftCalls++;
    return saveDraftResult;
  }

  @override
  Future<Survey?> saveAndPublish() async {
    saveAndPublishCalls++;
    return saveAndPublishResult;
  }

  @override
  void addQuestions(List<Question> questions) {
    addQuestionsCalls++;
    super.addQuestions(questions);
  }

  @override
  void reorderQuestions(int oldIndex, int newIndex) {
    reorderCalls++;
    lastReorder = (oldIndex, newIndex);
    super.reorderQuestions(oldIndex, newIndex);
  }

  @override
  void clearError() {
    clearErrorCalls++;
    super.clearError();
  }
}

final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

Survey _survey({int id = 1, String title = 'Saved Survey'}) {
  return Survey(
    surveyId: id,
    title: title,
    publicationStatus: 'draft',
    status: 'not-started',
    description: 'saved description',
    questions: const [],
  );
}

Template _template({int id = 10, String title = 'Template A'}) {
  return Template(
    templateId: id,
    title: title,
    isPublic: false,
    questions: const [],
  );
}

Question _question(int id, String text) {
  return Question(
    questionId: id,
    questionContent: text,
    responseType: 'openended',
    isRequired: false,
  );
}

void _useDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  group('SurveyBuilderPage coverage', () {
    testWidgets('create mode initializes with reset only', (tester) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(notifier.resetCalls, 1);
      expect(notifier.lastLoadedSurveyId, isNull);
      expect(notifier.lastLoadedTemplateId, isNull);
    });

    testWidgets('survey initialization branch is called', (tester) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(surveyId: 7),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(notifier.lastLoadedSurveyId, 7);
    });

    testWidgets('template initialization branch is called', (tester) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(templateId: 12),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(notifier.lastLoadedTemplateId, 12);
    });

    testWidgets('didUpdateWidget re-initializes when survey id changes', (
      tester,
    ) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;
      late StateSetter setHostState;
      int surveyId = 1;

      await tester.pumpWidget(
        buildTestPage(
          StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              return SurveyBuilderPage(surveyId: surveyId);
            },
          ),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(notifier.lastLoadedSurveyId, 1);

      setHostState(() {
        surveyId = 2;
      });
      await tester.pumpAndSettle();

      expect(notifier.lastLoadedSurveyId, 2);
      expect(notifier.resetCalls, 2);
    });

    testWidgets('shows loading state while loading with no questions', (
      tester,
    ) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
            await tester.pump();
            notifier.setTestState(const SurveyBuilderState(isLoading: true));
            await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      expect(notifier.saveDraftCalls, 0);
    });

    testWidgets('save draft validates title before calling notifier', (
      tester,
    ) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref, saveDraftResult: _survey());
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(AppOutlinedButton, 'Save Draft'));
      await tester.pumpAndSettle();

      expect(notifier.saveDraftCalls, 0);
      expect(find.textContaining('required'), findsWidgets);

      await tester.enterText(find.byType(TextFormField).first, 'Survey title');
      await tester.pump();

      await tester.tap(find.widgetWithText(AppOutlinedButton, 'Save Draft'));
      await tester.pumpAndSettle();

      expect(notifier.saveDraftCalls, 1);
    });

    testWidgets('publish does not call saveAndPublish when no questions', (
      tester,
    ) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref, saveAndPublishResult: _survey());
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Publishable');
      await tester.pump();
      await tester.tap(find.widgetWithText(AppFilledButton, 'Publish'));
      await tester.pumpAndSettle();

      expect(notifier.saveAndPublishCalls, 0);
    });

    testWidgets('publish confirmation cancel and confirm branches', (tester) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(
                ref,
                saveAndPublishResult: _survey(id: 2, title: 'Published'),
              );
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      notifier.setTestState(const SurveyBuilderState(
        title: 'Publishable',
        questions: [
          SurveyQuestionItem(
            questionId: 1,
            questionContent: 'Q1',
            responseType: 'yesno',
            isRequired: false,
          ),
        ],
      ));
      await tester.pump();

      await tester.tap(find.widgetWithText(AppFilledButton, 'Publish'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(notifier.saveAndPublishCalls, 0);

      await tester.tap(find.widgetWithText(AppFilledButton, 'Publish'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Publish').last);
      await tester.pumpAndSettle();

      expect(notifier.saveAndPublishCalls, 1);
    });

    testWidgets('preview action is disabled with no questions and opens when questions exist', (
      tester,
    ) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final previewButtonNoQuestions = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.preview_outlined),
      );
      expect(previewButtonNoQuestions.onPressed, isNull);

      notifier.setTestState(const SurveyBuilderState(
        title: 'Has Questions',
        questions: [
          SurveyQuestionItem(
            questionId: 4,
            questionContent: 'Q',
            responseType: 'openended',
            isRequired: false,
          ),
        ],
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithIcon(IconButton, Icons.preview_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(SurveyPreviewDialog), findsOneWidget);
    });

    testWidgets('add menu new branch shows draft card', (tester) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final addMenuButton = find.ancestor(
        of: find.text('Add Questions'),
        matching: find.byType(PopupMenuButton<String>),
      );
      await tester.ensureVisible(addMenuButton);
      await tester.tap(addMenuButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add New Question'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('draft')), findsOneWidget);
      expect(notifier.addQuestionsCalls, 0);
    });

    testWidgets('add menu template branch loads selected template', (tester) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final addMenuButton = find.ancestor(
        of: find.text('Add Questions'),
        matching: find.byType(PopupMenuButton<String>),
      );
      await tester.ensureVisible(addMenuButton);
      await tester.tap(addMenuButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start from Template'));
      await tester.pumpAndSettle();

      expect(find.byType(TemplateListPage), findsOneWidget);
      final templateContext = tester.element(find.byType(TemplateListPage));
      Navigator.of(templateContext).pop(_template(id: 77));
      await tester.pumpAndSettle();

      expect(notifier.lastLoadedTemplateId, 77);
    });

    testWidgets('add menu import branch adds returned questions', (tester) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final addMenuButton = find.ancestor(
        of: find.text('Add Questions'),
        matching: find.byType(PopupMenuButton<String>),
      );
      await tester.ensureVisible(addMenuButton);
      await tester.tap(addMenuButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Import from Question Bank'));
      await tester.pumpAndSettle();

      expect(find.byType(QuestionBankImportDialog), findsOneWidget);
      final dialogContext = tester.element(find.byType(QuestionBankImportDialog));
      Navigator.of(dialogContext).pop([_question(3, 'Imported')]);
      await tester.pumpAndSettle();

      expect(notifier.addQuestionsCalls, 1);
      expect(notifier.state.questions.map((q) => q.questionId), contains(3));
    });

    testWidgets('error banner close clears error', (tester) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
          await tester.pumpAndSettle();
          notifier.setTestState(const SurveyBuilderState(
            title: 'Publishable',
            questions: [
              SurveyQuestionItem(
                questionId: 1,
                questionContent: 'Q1',
                responseType: 'yesno',
                isRequired: false,
              ),
            ],
          ));
          await tester.pump();
          notifier.setTestState(const SurveyBuilderState(errorMessage: 'Something failed'));
          await tester.pump();

      expect(find.text('Something failed'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(notifier.clearErrorCalls, 1);
      expect(find.text('Something failed'), findsNothing);
    });

    testWidgets('question reorder callback forwards to notifier', (tester) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
          await tester.pumpAndSettle();
          notifier.setTestState(const SurveyBuilderState(
            questions: [
              SurveyQuestionItem(
                questionId: 1,
                questionContent: 'First',
                responseType: 'openended',
                isRequired: false,
              ),
              SurveyQuestionItem(
                questionId: 2,
                questionContent: 'Second',
                responseType: 'openended',
                isRequired: false,
              ),
            ],
          ));
          await tester.pump();

      final reorderable = tester.widget<ReorderableListView>(find.byType(ReorderableListView));
      reorderable.onReorder(0, 2);
      await tester.pumpAndSettle();

      expect(notifier.reorderCalls, 1);
      expect(notifier.lastReorder, (0, 2));
    });

    testWidgets('auto-save status variants render and retry triggers saveDraft', (
      tester,
    ) async {
      _useDesktopViewport(tester);
      late _TestSurveyBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const SurveyBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            surveyBuilderProvider.overrideWith((ref) {
              notifier = _TestSurveyBuilderNotifier(
                ref,
                saveDraftResult: _survey(id: 9),
              );
              return notifier;
            }),
          ],
        ),
      );
          await tester.pumpAndSettle();
          notifier.setTestState(const SurveyBuilderState(
            title: 'Auto Save Survey',
            autoSaveStatus: AutoSaveStatus.pending,
            questions: [
              SurveyQuestionItem(
                questionId: 9,
                questionContent: 'Q',
                responseType: 'yesno',
                isRequired: false,
              ),
            ],
          ));
          await tester.pump();

      expect(find.text('Unsaved'), findsOneWidget);

      notifier.setTestState(notifier.state.copyWith(autoSaveStatus: AutoSaveStatus.saving));
      await tester.pump();
      expect(find.text('Saving...'), findsOneWidget);

      notifier.setTestState(notifier.state.copyWith(autoSaveStatus: AutoSaveStatus.saved));
      await tester.pump();
      expect(find.text('Saved'), findsOneWidget);

      notifier.setTestState(notifier.state.copyWith(autoSaveStatus: AutoSaveStatus.error));
      await tester.pump();
      expect(find.text('Save failed'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(notifier.saveDraftCalls, 1);
    });
  });
}
