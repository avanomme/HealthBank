// Created with the Assistance of Claude Code
// frontend/test/features/surveys/survey_builder_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/surveys/surveys.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';

import '../../test_helpers.dart';

// ---------------------------------------------------------------------------
// Mock notifier for edit-mode tests — avoids real HTTP calls.
// reset() and loadSurvey() are overridden so _initializeBuilder() in the
// page can run without touching the network.
// ---------------------------------------------------------------------------

class _MockSurveyBuilderNotifier extends SurveyBuilderNotifier {
  _MockSurveyBuilderNotifier(super.ref);

  @override
  void reset() {} // no-op — keeps any pre-seeded state intact

  @override
  Future<void> loadSurvey(int surveyId) async {
    state = const SurveyBuilderState(
      surveyId: 1,
      title: 'Loaded Survey',
      isLoading: false,
    );
  }

  @override
  Future<void> loadFromTemplate(int templateId) async {} // no-op
}

final _messagingOverride = incomingFriendRequestsProvider.overrideWith(
  (ref) => Future.value([]),
);

List<Override> get _surveyBuilderOverrides => [_messagingOverride];

List<Override> get _surveyListOverrides => [
  _messagingOverride,
  surveysProvider.overrideWith((ref) async => <Survey>[]),
];

void main() {
  group('SurveyBuilderPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SurveyBuilderPage), findsOneWidget);
      });

      testWidgets('renders ResearcherScaffold', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherScaffold), findsOneWidget);
      });

      testWidgets('shows new survey title when surveyId is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('New Survey'), findsOneWidget);
      });

      testWidgets('renders title input field', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsWidgets);
      });

      testWidgets('renders back button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });

      testWidgets('renders publish button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Publish'), findsOneWidget);
      });

      testWidgets('renders preview button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.preview_outlined), findsOneWidget);
      });

      testWidgets(
        'reflows action bar and date fields at narrow width with large text',
        (tester) async {
          tester.view.physicalSize = const Size(640, 1400);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestPage(
              const MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(2)),
                child: SurveyBuilderPage(),
              ),
              overrides: _surveyBuilderOverrides,
            ),
          );
          await tester.pumpAndSettle();

          expect(find.textContaining('New Survey'), findsOneWidget);
          expect(find.text('Save Draft'), findsOneWidget);
          expect(find.text('Publish'), findsOneWidget);
          expect(find.text('Start Date'), findsOneWidget);
          expect(find.text('End Date'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    });

    group('Form Interaction', () {
      testWidgets('can enter title text', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        final titleField = find.byType(TextFormField).first;
        await tester.enterText(titleField, 'My Test Survey');
        await tester.pumpAndSettle();

        expect(find.text('My Test Survey'), findsOneWidget);
      });

      testWidgets('validates empty title on submit', (tester) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        // Try to publish without title - find publish button by text
        await tester.tap(find.text('Publish'));
        await tester.pumpAndSettle();

        // Should show validation error
        expect(find.textContaining('required'), findsWidgets);
      });
    });

    group('Edit Mode', () {
      testWidgets('shows edit title when surveyId is provided', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(surveyId: 1),
            overrides: [
              ..._surveyBuilderOverrides,
              surveyBuilderProvider.overrideWith(
                (ref) => _MockSurveyBuilderNotifier(ref),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // In edit mode, the action bar shows 'Edit Survey' instead of
        // 'New Survey'
        expect(find.textContaining('Edit Survey'), findsOneWidget);
        expect(find.textContaining('New Survey'), findsNothing);
      });

      testWidgets('loaded survey title appears in form field', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(surveyId: 1),
            overrides: [
              ..._surveyBuilderOverrides,
              surveyBuilderProvider.overrideWith(
                (ref) => _MockSurveyBuilderNotifier(ref),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // The mock loads title 'Loaded Survey', which should be set in the
        // title TextFormField
        expect(find.text('Loaded Survey'), findsOneWidget);
      });

      testWidgets('edit mode shows same action buttons as create mode', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(surveyId: 1),
            overrides: [
              ..._surveyBuilderOverrides,
              surveyBuilderProvider.overrideWith(
                (ref) => _MockSurveyBuilderNotifier(ref),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.text('Publish'), findsOneWidget);
        expect(find.byIcon(Icons.preview_outlined), findsOneWidget);
      });
    });

    group('Empty State', () {
      testWidgets('shows empty questions state', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.quiz_outlined), findsWidgets);
      });

      testWidgets('shows start from template option in add menu', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(
            const SurveyBuilderPage(),
            overrides: _surveyBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        // Open the add questions popup menu
        await tester.tap(find.text('Add Questions'));
        await tester.pumpAndSettle();

        expect(find.text('Start from Template'), findsOneWidget);
      });
    });
  });

  group('SurveyListPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyListPage(),
            overrides: _surveyListOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SurveyListPage), findsOneWidget);
      });

      testWidgets('renders ResearcherScaffold', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyListPage(),
            overrides: _surveyListOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherScaffold), findsOneWidget);
      });

      testWidgets('renders create survey button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const SurveyListPage(),
            overrides: _surveyListOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.add), findsWidgets);
      });
    });
  });

  group('SurveyPreviewDialog', () {
    testWidgets('showSurveyPreview displays dialog', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'Test Survey',
                description: 'A test description',
                questions: const [],
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      expect(find.text('Test Survey'), findsOneWidget);
    });

    testWidgets('preview dialog shows description when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'Survey',
                description: 'This is a description',
                questions: const [],
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      expect(find.text('This is a description'), findsOneWidget);
    });

    testWidgets('preview dialog can be closed', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSurveyPreview(
                context,
                title: 'Test Survey',
                questions: const [],
              ),
              child: const Text('Show Preview'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Preview'));
      await tester.pumpAndSettle();

      // Find and tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Test Survey'), findsNothing);
    });
  });

  group('SurveyBuilderState', () {
    test('initial state has correct defaults', () {
      const state = SurveyBuilderState();

      expect(state.surveyId, null);
      expect(state.title, '');
      expect(state.description, '');
      expect(state.questions, isEmpty);
      expect(state.startDate, null);
      expect(state.endDate, null);
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
      expect(state.autoSaveStatus, AutoSaveStatus.idle);
    });

    test('isEditMode returns true when surveyId is not null', () {
      const state = SurveyBuilderState(surveyId: 1);

      expect(state.isEditMode, true);
    });

    test('isEditMode returns false when surveyId is null', () {
      const state = SurveyBuilderState();

      expect(state.isEditMode, false);
    });

    test('hasQuestions returns true when questions list is not empty', () {
      const state = SurveyBuilderState(
        questions: [
          SurveyQuestionItem(
            questionId: 1,
            questionContent: 'Test?',
            responseType: 'yesno',
            isRequired: false,
          ),
        ],
      );

      expect(state.hasQuestions, true);
    });

    test('hasQuestions returns false when questions list is empty', () {
      const state = SurveyBuilderState();

      expect(state.hasQuestions, false);
    });

    test('copyWith updates title', () {
      const state = SurveyBuilderState(title: 'Old Title');
      final newState = state.copyWith(title: 'New Title');

      expect(newState.title, 'New Title');
      expect(newState.description, '');
    });

    test('copyWith updates multiple fields', () {
      const state = SurveyBuilderState();
      final newState = state.copyWith(
        title: 'Survey',
        description: 'Description',
        isLoading: true,
      );

      expect(newState.title, 'Survey');
      expect(newState.description, 'Description');
      expect(newState.isLoading, true);
    });
  });

  group('SurveyQuestionItem', () {
    test('creates instance with required fields', () {
      const item = SurveyQuestionItem(
        questionId: 1,
        questionContent: 'What is your name?',
        responseType: 'openended',
        isRequired: true,
      );

      expect(item.questionId, 1);
      expect(item.questionContent, 'What is your name?');
      expect(item.responseType, 'openended');
      expect(item.isRequired, true);
    });

    test('creates instance with optional title', () {
      const item = SurveyQuestionItem(
        questionId: 1,
        title: 'Name Question',
        questionContent: 'What is your name?',
        responseType: 'openended',
        isRequired: false,
      );

      expect(item.title, 'Name Question');
    });

    test('creates instance with options', () {
      const item = SurveyQuestionItem(
        questionId: 1,
        questionContent: 'Pick one',
        responseType: 'single_choice',
        isRequired: false,
        options: [
          QuestionOptionResponse(optionId: 1, optionText: 'A'),
          QuestionOptionResponse(optionId: 2, optionText: 'B'),
        ],
      );

      expect(item.options, hasLength(2));
      expect(item.options![0].optionText, 'A');
    });
  });

  group('QuestionOptionResponse (used in SurveyQuestionItem)', () {
    test('creates instance with required fields', () {
      const option = QuestionOptionResponse(optionId: 1, optionText: 'Yes');

      expect(option.optionId, 1);
      expect(option.optionText, 'Yes');
      expect(option.displayOrder, null);
    });

    test('creates instance with display order', () {
      const option = QuestionOptionResponse(
        optionId: 1,
        optionText: 'Yes',
        displayOrder: 0,
      );

      expect(option.displayOrder, 0);
    });
  });

  group('AutoSaveStatus', () {
    test('has all expected values', () {
      expect(AutoSaveStatus.values, hasLength(5));
      expect(AutoSaveStatus.values, contains(AutoSaveStatus.idle));
      expect(AutoSaveStatus.values, contains(AutoSaveStatus.pending));
      expect(AutoSaveStatus.values, contains(AutoSaveStatus.saving));
      expect(AutoSaveStatus.values, contains(AutoSaveStatus.saved));
      expect(AutoSaveStatus.values, contains(AutoSaveStatus.error));
    });
  });
}
