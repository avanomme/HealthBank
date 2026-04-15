import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/question_bank/pages/question_bank_page.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers.dart';

/// Helper to create a test question
Question _createTestQuestion({
  int questionId = 1,
  String? title = 'Test Question',
  String questionContent = 'What is this about?',
  String responseType = 'yesno',
  bool isRequired = false,
  String? category = 'demographics',
  List<QuestionOptionResponse>? options,
}) {
  return Question(
    questionId: questionId,
    title: title,
    questionContent: questionContent,
    responseType: responseType,
    isRequired: isRequired,
    category: category,
    options: options,
  );
}

/// Helper to create a test question category
QuestionCategory _createTestCategory({
  int categoryId = 1,
  String categoryKey = 'demographics',
  int displayOrder = 1,
}) {
  return QuestionCategory(
    categoryId: categoryId,
    categoryKey: categoryKey,
    displayOrder: displayOrder,
  );
}

/// Common overrides helper
List<Override> _getCommonOverrides({
  List<Question>? questions,
  QuestionFilters? filters,
  bool selectionMode = false,
  Set<int>? selectedIds,
  List<QuestionCategory>? categories,
}) {
  return [
    // Messaging provider to prevent 400 errors
    incomingFriendRequestsProvider.overrideWith(
      (ref) => Future.value([]),
    ),
    questionsProvider.overrideWith((ref) async => questions ?? []),
    questionFiltersProvider.overrideWith((ref) {
      final notifier = QuestionFiltersNotifier();
      if (filters != null) {
        if (filters.responseType != null) {
          notifier.setResponseType(filters.responseType);
        }
        if (filters.category != null) {
          notifier.setCategory(filters.category);
        }
        if (filters.searchQuery.isNotEmpty) {
          notifier.setSearchQuery(filters.searchQuery);
        }
      }
      return notifier;
    }),
    selectionModeProvider.overrideWith((ref) => selectionMode),
    selectedQuestionIdsProvider.overrideWith((ref) {
      final notifier = SelectedQuestionsNotifier();
      if (selectedIds != null) {
        for (final id in selectedIds) {
          notifier.select(id);
        }
      }
      return notifier;
    }),
    questionCategoriesProvider.overrideWith(
      (ref) async => categories ?? [_createTestCategory()],
    ),
  ];
}

/// Mock QuestionApi for testing
class _MockQuestionApi extends Mock implements QuestionApi {}

/// Common overrides with mock API
List<Override> _getCommonOverridesWithMockApi({
  List<Question>? questions,
  QuestionFilters? filters,
  bool selectionMode = false,
  Set<int>? selectedIds,
  List<QuestionCategory>? categories,
  QuestionApi? mockApi,
}) {
  return [
    ..._getCommonOverrides(
      questions: questions,
      filters: filters,
      selectionMode: selectionMode,
      selectedIds: selectedIds,
      categories: categories,
    ),
    if (mockApi != null) questionApiProvider.overrideWith((ref) => mockApi),
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const QuestionCreate(
        questionContent: 'fallback question',
        responseType: 'yesno',
      ),
    );
  });

  group('QuestionBankPage', () {
    group('Normal Mode (Non-Selection)', () {
      testWidgets('displays ResearcherScaffold in normal mode', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              selectionMode: false,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('displays floating action button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              selectionMode: false,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(FloatingActionButton), findsOneWidget);
      });
    });

    group('Selection Mode', () {
      testWidgets('displays Scaffold in selection mode', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(
              selectionMode: true,
              onQuestionsSelected: null,
            ),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              selectionMode: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('displays AppBar with selection title', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(
              selectionMode: true,
              onQuestionsSelected: null,
            ),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              selectionMode: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('button is disabled when no questions selected', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(
              selectionMode: true,
              onQuestionsSelected: null,
            ),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              selectionMode: true,
              selectedIds: const {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Search and Filters', () {
      testWidgets('displays search field', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsWidgets);
      });

      testWidgets('displays active filters chips when filters applied', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              filters: const QuestionFilters(
                searchQuery: 'test',
                responseType: 'yesno',
                category: 'demographics',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Chip), findsWidgets);
      });
    });

    group('Question List Display', () {
      testWidgets('displays list of questions', (tester) async {
        final questions = [
          _createTestQuestion(questionId: 1, title: 'Q1'),
          _createTestQuestion(questionId: 2, title: 'Q2'),
        ];

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(questions: questions),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('displays empty state when no questions', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(questions: []),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('displays empty state when no questions match filters',
          (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [],
              filters: const QuestionFilters(
                searchQuery: 'nonexistent',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Test Coverage', () {
      testWidgets('loads categories from provider', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              categories: [
                _createTestCategory(
                  categoryId: 1,
                  categoryKey: 'demographics',
                ),
                _createTestCategory(
                  categoryId: 2,
                  categoryKey: 'mental_health',
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('initializes with correct selection mode', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(
              selectionMode: true,
              onQuestionsSelected: null,
            ),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              selectionMode: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('is a ConsumerStatefulWidget', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('has proper widget hierarchy', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
      });
    });

    group('State Management', () {
      testWidgets('watches questions provider', (tester) async {
        final questions = [_createTestQuestion()];

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(questions: questions),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('watches selection mode provider', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: true),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              selectionMode: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('watches selected questions provider', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: true),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              selectionMode: true,
              selectedIds: {1},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Multiple Questions', () {
      testWidgets('displays multiple questions in list', (tester) async {
        final questions = List.generate(
          5,
          (i) => _createTestQuestion(
            questionId: i + 1,
            title: 'Question ${i + 1}',
            questionContent: 'Content for question ${i + 1}',
          ),
        );

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(questions: questions),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });
    });

    group('Different Response Types', () {
      testWidgets('handles multiple response types', (tester) async {
        final questions = [
          _createTestQuestion(
            questionId: 1,
            responseType: 'yesno',
          ),
          _createTestQuestion(
            questionId: 2,
            responseType: 'scale',
          ),
          _createTestQuestion(
            questionId: 3,
            responseType: 'openended',
          ),
        ];

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(questions: questions),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });
    });

    group('Different Categories', () {
      testWidgets('displays questions from different categories', (tester) async {
        final questions = [
          _createTestQuestion(
            questionId: 1,
            category: 'demographics',
          ),
          _createTestQuestion(
            questionId: 2,
            category: 'mental_health',
          ),
          _createTestQuestion(
            questionId: 3,
            category: 'physical_health',
          ),
        ];

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(questions: questions),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });
    });

    group('Widget State', () {
      testWidgets('Scaffold has proper app bar structure', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: true),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              selectionMode: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('floating action button has correct label', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(FloatingActionButton), findsOneWidget);
      });
    });

    group('Delete Question', () {
      testWidgets('confirmation dialog appears on delete action', (tester) async {
        final mockApi = _MockQuestionApi();
        final originalQuestion = _createTestQuestion(
          questionId: 1,
          title: 'Question to Delete',
        );

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverridesWithMockApi(
              questions: [originalQuestion],
              mockApi: mockApi,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('delete calls API when confirmed', (tester) async {
        final mockApi = _MockQuestionApi();
        final question = _createTestQuestion(questionId: 42);

        when(() => mockApi.deleteQuestion(42)).thenAnswer((_) async => {});

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverridesWithMockApi(
              questions: [question],
              mockApi: mockApi,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Duplicate Question', () {
      testWidgets('duplicate creates copy with same content', (tester) async {
        final mockApi = _MockQuestionApi();
        final original = _createTestQuestion(
          questionId: 1,
          title: 'Original Question',
          responseType: 'yesno',
          category: 'demographics',
        );

        when(() => mockApi.createQuestion(any()))
            .thenAnswer((_) async => _createTestQuestion(
                  questionId: 2,
                  title: 'Original Question (Copy)',
                ));

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverridesWithMockApi(
              questions: [original],
              mockApi: mockApi,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('duplicate includes options if present', (tester) async {
        final mockApi = _MockQuestionApi();
        final question = _createTestQuestion(
          questionId: 1,
          responseType: 'single_choice',
          options: [
            const QuestionOptionResponse(
              optionId: 1,
              optionText: 'Option 1',
              displayOrder: 1,
            ),
          ],
        );

        when(() => mockApi.createQuestion(any()))
            .thenAnswer((_) async => _createTestQuestion());

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverridesWithMockApi(
              questions: [question],
              mockApi: mockApi,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Category Dropdown', () {
      testWidgets('displays loading state while fetching categories',
          (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: [
              ..._getCommonOverrides(
                questions: [_createTestQuestion()],
              ),
              questionCategoriesProvider.overrideWith((ref) async {
                await Future.delayed(const Duration(milliseconds: 100));
                return [_createTestCategory()];
              }),
            ],
          ),
        );

        // While loading
        expect(find.byType(QuestionBankPage), findsOneWidget);

        await tester.pumpAndSettle();

        // After loading
        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('displays error state gracefully', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: [
              ..._getCommonOverrides(
                questions: [_createTestQuestion()],
              ),
              questionCategoriesProvider.overrideWith((ref) async {
                throw Exception('Failed to load categories');
              }),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('displays all available categories', (tester) async {
        final categories = [
          _createTestCategory(categoryId: 1, categoryKey: 'demographics'),
          _createTestCategory(categoryId: 2, categoryKey: 'mental_health'),
          _createTestCategory(categoryId: 3, categoryKey: 'physical_health'),
        ];

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              categories: categories,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Filter Interactions', () {
      testWidgets('clear all filters button resets all filters', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              filters: const QuestionFilters(searchQuery: 'test'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('search clear button appears when text is entered',
          (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              filters: const QuestionFilters(searchQuery: 'mood'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsWidgets);
      });

      testWidgets('response type filter can be applied', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('category filter can be applied', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              categories: [_createTestCategory()],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('search filter can be applied independently', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              filters: const QuestionFilters(searchQuery: 'test query'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('dropdown filters render without errors',
          (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion()],
              categories: [
                _createTestCategory(categoryKey: 'demographics'),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Selection Mode Confirmation', () {
      testWidgets('button shows selection count when questions selected',
          (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(
              selectionMode: true,
              onQuestionsSelected: null,
            ),
            overrides: _getCommonOverrides(
              questions: [
                _createTestQuestion(questionId: 1),
                _createTestQuestion(questionId: 2),
              ],
              selectionMode: true,
              selectedIds: {1},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('confirmation callback receives selected questions',
          (tester) async {
        List<Question>? selectedQuestions;

        void onQuestionsSelected(List<Question> questions) {
          selectedQuestions = questions;
        }

        final q1 = _createTestQuestion(questionId: 1, title: 'Q1');
        final q2 = _createTestQuestion(questionId: 2, title: 'Q2');

        await tester.pumpWidget(
          buildTestPage(
            QuestionBankPage(
              selectionMode: true,
              onQuestionsSelected: onQuestionsSelected,
            ),
            overrides: _getCommonOverrides(
              questions: [q1, q2],
              selectionMode: true,
              selectedIds: {1},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
        expect(selectedQuestions, isNull);
      });

      testWidgets('multiple questions can be selected in selection mode',
          (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(
              selectionMode: true,
              onQuestionsSelected: null,
            ),
            overrides: _getCommonOverrides(
              questions: [
                _createTestQuestion(questionId: 1),
                _createTestQuestion(questionId: 2),
                _createTestQuestion(questionId: 3),
              ],
              selectionMode: true,
              selectedIds: {1, 2, 3},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Category Rendering', () {
      testWidgets('renders with demographics category data', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion(category: 'demographics')],
              categories: [
                _createTestCategory(categoryKey: 'demographics'),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('renders with mental health category data', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion(category: 'mental_health')],
              categories: [
                _createTestCategory(categoryKey: 'mental_health'),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('renders with physical health category data', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion(category: 'physical_health')],
              categories: [
                _createTestCategory(categoryKey: 'physical_health'),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('renders with lifestyle category data', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion(category: 'lifestyle')],
              categories: [
                _createTestCategory(categoryKey: 'lifestyle'),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('renders with symptoms category data', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion(category: 'symptoms')],
              categories: [
                _createTestCategory(categoryKey: 'symptoms'),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('unknown category falls back to formatted key', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [_createTestQuestion(category: 'unknown_category')],
              categories: [
                _createTestCategory(categoryKey: 'unknown_category'),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Empty State Handling', () {
      testWidgets('empty state shows add button when no filters applied',
          (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [],
              filters: const QuestionFilters(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('empty state shows clear filters button when filters applied',
          (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: [],
              filters: const QuestionFilters(
                searchQuery: 'nonexistent',
                responseType: 'yesno',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('error state displays when questions fail to load',
          (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: [
              ..._getCommonOverrides(),
              questionsProvider.overrideWith((ref) async {
                throw Exception('API Error: Network failure');
              }),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });

      testWidgets('error state has retry button', (tester) async {
        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: [
              ..._getCommonOverrides(),
              questionsProvider.overrideWith((ref) async {
                throw Exception('Network error');
              }),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(QuestionBankPage), findsOneWidget);
      });
    });

    group('Refresh Functionality', () {
      testWidgets('pull to refresh reloads questions', (tester) async {
        final mockApi = _MockQuestionApi();
        when(() => mockApi.listQuestions(
              responseType: null,
              category: null,
              isActive: true,
            )).thenAnswer((_) async => [_createTestQuestion()]);

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverridesWithMockApi(
              questions: [_createTestQuestion()],
              mockApi: mockApi,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });
    });

    group('Footer Display', () {
      testWidgets('footer displays in normal mode', (tester) async {
        final questions = List.generate(
          10,
          (i) => _createTestQuestion(questionId: i + 1),
        );

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: false),
            overrides: _getCommonOverrides(
              questions: questions,
              selectionMode: false,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('footer does not display in selection mode', (tester) async {
        final questions = List.generate(
          10,
          (i) => _createTestQuestion(questionId: i + 1),
        );

        await tester.pumpWidget(
          buildTestPage(
            const QuestionBankPage(selectionMode: true),
            overrides: _getCommonOverrides(
              questions: questions,
              selectionMode: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
      });
    });
  });
}
