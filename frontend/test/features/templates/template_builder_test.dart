// Created with the Assistance of Claude Code
// frontend/test/features/templates/template_builder_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/templates/templates.dart';
import 'package:frontend/src/core/api/models/template.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';

import '../../test_helpers.dart';

// ---------------------------------------------------------------------------
// Mock notifier for edit-mode tests — avoids real HTTP calls.
// loadTemplate() is overridden so _initializeBuilder() in the page can run
// without touching the network.
// ---------------------------------------------------------------------------

class _MockTemplateBuilderNotifier extends TemplateBuilderNotifier {
  _MockTemplateBuilderNotifier(super.ref);

  @override
  void reset() {} // no-op

  @override
  Future<void> loadTemplate(int templateId) async {
    state = const TemplateBuilderState(
      templateId: 1,
      title: 'Loaded Template',
      isLoading: false,
    );
  }
}

class _PreloadedTemplateBuilderNotifier extends TemplateBuilderNotifier {
  _PreloadedTemplateBuilderNotifier(super.ref) {
    state = const TemplateBuilderState(
      title: 'Responsive Template',
      questions: [
        TemplateQuestionItem(
          questionId: 1,
          title: 'Question title that should remain readable',
          questionContent:
              'Question title that should remain readable on narrow widths',
          responseType: 'multi_choice',
          isRequired: true,
        ),
      ],
    );
  }

  @override
  void reset() {}

  @override
  Future<void> loadTemplate(int templateId) async {}
}

final _messagingOverride = incomingFriendRequestsProvider.overrideWith(
  (ref) => Future.value([]),
);

List<Override> get _templateBuilderOverrides => [_messagingOverride];

void main() {
  group('TemplateBuilderPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TemplateBuilderPage), findsOneWidget);
      });

      testWidgets('renders ResearcherScaffold', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherScaffold), findsOneWidget);
      });

      testWidgets('shows new template title when templateId is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('New Template'), findsOneWidget);
      });

      testWidgets('renders title input field', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsWidgets);
      });

      testWidgets('renders back button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });

      testWidgets('renders save button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets('renders add questions button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('Add'), findsWidgets);
      });

      testWidgets('renders public visibility toggle', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SwitchListTile), findsOneWidget);
      });

      testWidgets(
        'reflows action bar and question tiles at narrow width with large text',
        (tester) async {
          tester.view.physicalSize = const Size(640, 1400);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestPage(
              const MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(2)),
                child: TemplateBuilderPage(),
              ),
              overrides: [
                ..._templateBuilderOverrides,
                templateBuilderProvider.overrideWith(
                  (ref) => _PreloadedTemplateBuilderNotifier(ref),
                ),
              ],
            ),
          );
          await tester.pumpAndSettle();

          expect(find.textContaining('New Template'), findsOneWidget);
          expect(find.text('Save'), findsOneWidget);
          expect(
            find.textContaining('Question title that should remain readable'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    });

    group('Form Interaction', () {
      testWidgets('can enter title text', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        final titleField = find.byType(TextFormField).first;
        await tester.enterText(titleField, 'My Test Template');
        await tester.pumpAndSettle();

        expect(find.text('My Test Template'), findsOneWidget);
      });
    });

    group('Edit Mode', () {
      testWidgets('shows edit title when templateId is provided', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(templateId: 1),
            overrides: [
              ..._templateBuilderOverrides,
              templateBuilderProvider.overrideWith(
                (ref) => _MockTemplateBuilderNotifier(ref),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // In edit mode, the action bar shows 'Edit Template' instead of
        // 'New Template'
        expect(find.textContaining('Edit Template'), findsOneWidget);
        expect(find.textContaining('New Template'), findsNothing);
      });

      testWidgets('loaded template title appears in form field', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(templateId: 1),
            overrides: [
              ..._templateBuilderOverrides,
              templateBuilderProvider.overrideWith(
                (ref) => _MockTemplateBuilderNotifier(ref),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // The mock loads title 'Loaded Template', which should be set in the
        // title TextFormField
        expect(find.text('Loaded Template'), findsOneWidget);
      });

      testWidgets('edit mode shows same structural widgets as create mode', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(templateId: 1),
            overrides: [
              ..._templateBuilderOverrides,
              templateBuilderProvider.overrideWith(
                (ref) => _MockTemplateBuilderNotifier(ref),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
        expect(find.byType(SwitchListTile), findsOneWidget);
      });
    });

    group('Empty State', () {
      testWidgets('shows empty questions state', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateBuilderPage(),
            overrides: _templateBuilderOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.quiz_outlined), findsWidgets);
      });
    });
  });

  group('TemplateListPage', () {
    // Mock empty template list to avoid API calls
    final templateListOverrides = <Override>[
      _messagingOverride,
      templatesProvider.overrideWith((ref) async => <Template>[]),
    ];

    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateListPage(),
            overrides: templateListOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TemplateListPage), findsOneWidget);
      });

      testWidgets('renders ResearcherScaffold', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateListPage(),
            overrides: templateListOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherScaffold), findsOneWidget);
      });

      testWidgets('renders create template button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const TemplateListPage(),
            overrides: templateListOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.add), findsWidgets);
      });
    });

    group('Selection Mode', () {
      testWidgets('selection mode works when enabled', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            TemplateListPage(
              selectionMode: true,
              onTemplateSelected: (template) {},
            ),
            overrides: templateListOverrides,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TemplateListPage), findsOneWidget);
      });
    });
  });

  group('TemplateBuilderState', () {
    test('initial state has correct defaults', () {
      const state = TemplateBuilderState();

      expect(state.templateId, null);
      expect(state.title, '');
      expect(state.description, '');
      expect(state.isPublic, false);
      expect(state.questions, isEmpty);
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
    });

    test('isEditMode returns true when templateId is not null', () {
      const state = TemplateBuilderState(templateId: 1);

      expect(state.isEditMode, true);
    });

    test('isEditMode returns false when templateId is null', () {
      const state = TemplateBuilderState();

      expect(state.isEditMode, false);
    });

    test('questions list is not empty when questions are added', () {
      const state = TemplateBuilderState(
        questions: [
          TemplateQuestionItem(
            questionId: 1,
            questionContent: 'Test?',
            responseType: 'yesno',
            isRequired: false,
          ),
        ],
      );

      expect(state.questions.isNotEmpty, true);
    });

    test('questions list is empty by default', () {
      const state = TemplateBuilderState();

      expect(state.questions.isEmpty, true);
    });

    test('copyWith updates title', () {
      const state = TemplateBuilderState(title: 'Old Title');
      final newState = state.copyWith(title: 'New Title');

      expect(newState.title, 'New Title');
    });

    test('copyWith updates isPublic', () {
      const state = TemplateBuilderState(isPublic: false);
      final newState = state.copyWith(isPublic: true);

      expect(newState.isPublic, true);
    });

    test('copyWith updates multiple fields', () {
      const state = TemplateBuilderState();
      final newState = state.copyWith(
        title: 'Template',
        description: 'Description',
        isPublic: true,
        isLoading: true,
      );

      expect(newState.title, 'Template');
      expect(newState.description, 'Description');
      expect(newState.isPublic, true);
      expect(newState.isLoading, true);
    });
  });

  group('TemplateQuestionItem', () {
    test('creates instance with required fields', () {
      const item = TemplateQuestionItem(
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
      const item = TemplateQuestionItem(
        questionId: 1,
        title: 'Name Question',
        questionContent: 'What is your name?',
        responseType: 'openended',
        isRequired: false,
      );

      expect(item.title, 'Name Question');
    });

    test('creates instance with category', () {
      const item = TemplateQuestionItem(
        questionId: 1,
        questionContent: 'Question',
        responseType: 'yesno',
        isRequired: false,
        category: 'health',
      );

      expect(item.category, 'health');
    });
  });
}
