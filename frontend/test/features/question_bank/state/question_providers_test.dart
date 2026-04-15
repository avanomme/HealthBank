import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart';
import 'package:mocktail/mocktail.dart';

/// Mock Question API
class _MockQuestionApi extends Mock implements QuestionApi {}

/// Create a test question
Question _createQuestion({
  int id = 1,
  String? title = 'Test Question',
  String content = 'Question content',
  String responseType = 'yesno',
  bool isRequired = false,
  String? category = 'demographics',
}) {
  return Question(
    questionId: id,
    title: title,
    questionContent: content,
    responseType: responseType,
    isRequired: isRequired,
    category: category,
  );
}

/// Create a test category
QuestionCategory _createCategory({
  int id = 1,
  String key = 'demographics',
  int order = 1,
}) {
  return QuestionCategory(
    categoryId: id,
    categoryKey: key,
    displayOrder: order,
  );
}

void main() {
  group('QuestionFilters', () {
    test('initializes with default values', () {
      const filters = QuestionFilters();

      expect(filters.searchQuery, '');
      expect(filters.responseType, isNull);
      expect(filters.category, isNull);
    });

    test('initializes with provided values', () {
      const filters = QuestionFilters(
        searchQuery: 'mood',
        responseType: 'scale',
        category: 'mental_health',
      );

      expect(filters.searchQuery, 'mood');
      expect(filters.responseType, 'scale');
      expect(filters.category, 'mental_health');
    });

    test('copyWith updates responseType while preserving others', () {
      const base = QuestionFilters(
        searchQuery: 'test',
        responseType: 'yesno',
        category: 'demographics',
      );

      final updated = base.copyWith(responseType: 'scale');

      expect(updated.responseType, 'scale');
      expect(updated.searchQuery, 'test');
      expect(updated.category, 'demographics');
    });

    test('copyWith updates category while preserving others', () {
      const base = QuestionFilters(
        searchQuery: 'test',
        responseType: 'yesno',
        category: 'demographics',
      );

      final updated = base.copyWith(category: 'mental_health');

      expect(updated.category, 'mental_health');
      expect(updated.searchQuery, 'test');
      expect(updated.responseType, 'yesno');
    });

    test('copyWith updates searchQuery while preserving others', () {
      const base = QuestionFilters(
        searchQuery: 'mood',
        responseType: 'yesno',
        category: 'demographics',
      );

      final updated = base.copyWith(searchQuery: 'sleep');

      expect(updated.searchQuery, 'sleep');
      expect(updated.responseType, 'yesno');
      expect(updated.category, 'demographics');
    });

    test('copyWith with null values preserves existing', () {
      const base = QuestionFilters(
        searchQuery: 'mood',
        responseType: 'yesno',
        category: 'demographics',
      );

      final updated = base.copyWith();

      expect(updated.searchQuery, 'mood');
      expect(updated.responseType, 'yesno');
      expect(updated.category, 'demographics');
    });

    test('clearFilter removes responseType', () {
      const base = QuestionFilters(
        searchQuery: 'test',
        responseType: 'yesno',
        category: 'demographics',
      );

      final cleared = base.clearFilter('responseType');

      expect(cleared.responseType, isNull);
      expect(cleared.searchQuery, 'test');
      expect(cleared.category, 'demographics');
    });

    test('clearFilter removes category', () {
      const base = QuestionFilters(
        searchQuery: 'test',
        responseType: 'yesno',
        category: 'demographics',
      );

      final cleared = base.clearFilter('category');

      expect(cleared.category, isNull);
      expect(cleared.searchQuery, 'test');
      expect(cleared.responseType, 'yesno');
    });

    test('clearFilter clears searchQuery', () {
      const base = QuestionFilters(
        searchQuery: 'test',
        responseType: 'yesno',
        category: 'demographics',
      );

      final cleared = base.clearFilter('searchQuery');

      expect(cleared.searchQuery, '');
      expect(cleared.responseType, 'yesno');
      expect(cleared.category, 'demographics');
    });

    test('clearFilter with unknown name returns same instance', () {
      const base = QuestionFilters(
        searchQuery: 'test',
        responseType: 'yesno',
        category: 'demographics',
      );

      final result = base.clearFilter('unknown');

      expect(result, base);
    });

    test('clearAll returns default filters', () {
      const base = QuestionFilters(
        searchQuery: 'mood',
        responseType: 'scale',
        category: 'mental_health',
      );

      final cleared = base.clearAll();

      expect(cleared.searchQuery, '');
      expect(cleared.responseType, isNull);
      expect(cleared.category, isNull);
    });
  });

  group('QuestionFiltersNotifier', () {
    test('initializes with default filters', () {
      final notifier = QuestionFiltersNotifier();

      expect(notifier.state.searchQuery, '');
      expect(notifier.state.responseType, isNull);
      expect(notifier.state.category, isNull);
    });

    test('setResponseType updates state', () {
      final notifier = QuestionFiltersNotifier();

      notifier.setResponseType('yesno');

      expect(notifier.state.responseType, 'yesno');
      expect(notifier.state.searchQuery, '');
      expect(notifier.state.category, isNull);
    });

    test('setResponseType to null preserves existing type', () {
      final notifier = QuestionFiltersNotifier();
      notifier.setResponseType('yesno');

      notifier.setResponseType(null);

      // copyWith uses ?? so null preserves existing value
      expect(notifier.state.responseType, 'yesno');
    });

    test('setCategory updates state', () {
      final notifier = QuestionFiltersNotifier();

      notifier.setCategory('mental_health');

      expect(notifier.state.category, 'mental_health');
      expect(notifier.state.searchQuery, '');
      expect(notifier.state.responseType, isNull);
    });

    test('setCategory to null preserves existing category', () {
      final notifier = QuestionFiltersNotifier();
      notifier.setCategory('demographics');

      notifier.setCategory(null);

      // copyWith uses ?? so null preserves existing value
      expect(notifier.state.category, 'demographics');
    });

    test('setSearchQuery updates state', () {
      final notifier = QuestionFiltersNotifier();

      notifier.setSearchQuery('mood');

      expect(notifier.state.searchQuery, 'mood');
      expect(notifier.state.responseType, isNull);
      expect(notifier.state.category, isNull);
    });

    test('setSearchQuery with empty string clears search', () {
      final notifier = QuestionFiltersNotifier();
      notifier.setSearchQuery('mood');

      notifier.setSearchQuery('');

      expect(notifier.state.searchQuery, '');
    });

    test('clearFilter delegates to QuestionFilters', () {
      final notifier = QuestionFiltersNotifier();
      notifier.setSearchQuery('test');
      notifier.setResponseType('yesno');
      notifier.setCategory('demographics');

      notifier.clearFilter('responseType');

      expect(notifier.state.responseType, isNull);
      expect(notifier.state.searchQuery, 'test');
      expect(notifier.state.category, 'demographics');
    });

    test('clearAll resets all filters', () {
      final notifier = QuestionFiltersNotifier();
      notifier.setSearchQuery('mood');
      notifier.setResponseType('scale');
      notifier.setCategory('mental_health');

      notifier.clearAll();

      expect(notifier.state.searchQuery, '');
      expect(notifier.state.responseType, isNull);
      expect(notifier.state.category, isNull);
    });

    test('multiple operations preserve state correctly', () {
      final notifier = QuestionFiltersNotifier();

      notifier.setSearchQuery('health');
      notifier.setResponseType('yesno');
      notifier.setCategory('physical_health');

      expect(notifier.state.searchQuery, 'health');
      expect(notifier.state.responseType, 'yesno');
      expect(notifier.state.category, 'physical_health');

      notifier.setSearchQuery('mood');
      expect(notifier.state.searchQuery, 'mood');
      expect(notifier.state.responseType, 'yesno');
      expect(notifier.state.category, 'physical_health');
    });
  });

  group('SelectedQuestionsNotifier', () {
    test('initializes with empty set', () {
      final notifier = SelectedQuestionsNotifier();

      expect(notifier.state, isEmpty);
    });

    test('toggle adds question when not selected', () {
      final notifier = SelectedQuestionsNotifier();

      notifier.toggle(1);

      expect(notifier.state, {1});
      expect(notifier.isSelected(1), true);
    });

    test('toggle removes question when already selected', () {
      final notifier = SelectedQuestionsNotifier();
      notifier.toggle(1);

      notifier.toggle(1);

      expect(notifier.state, isEmpty);
      expect(notifier.isSelected(1), false);
    });

    test('toggle with multiple questions', () {
      final notifier = SelectedQuestionsNotifier();

      notifier.toggle(1);
      notifier.toggle(2);
      notifier.toggle(3);

      expect(notifier.state, {1, 2, 3});
    });

    test('select adds question to selection', () {
      final notifier = SelectedQuestionsNotifier();

      notifier.select(1);
      notifier.select(2);

      expect(notifier.state, {1, 2});
    });

    test('select duplicate question does not create duplicates', () {
      final notifier = SelectedQuestionsNotifier();

      notifier.select(1);
      notifier.select(1);

      expect(notifier.state, {1});
    });

    test('deselect removes question from selection', () {
      final notifier = SelectedQuestionsNotifier();
      notifier.select(1);
      notifier.select(2);
      notifier.select(3);

      notifier.deselect(2);

      expect(notifier.state, {1, 3});
      expect(notifier.isSelected(2), false);
    });

    test('deselect non-existent question does nothing', () {
      final notifier = SelectedQuestionsNotifier();
      notifier.select(1);

      notifier.deselect(99);

      expect(notifier.state, {1});
    });

    test('selectAll adds all provided questions', () {
      final notifier = SelectedQuestionsNotifier();
      notifier.select(1);

      notifier.selectAll([2, 3, 4]);

      expect(notifier.state, {1, 2, 3, 4});
    });

    test('selectAll with existing selections merges correctly', () {
      final notifier = SelectedQuestionsNotifier();
      notifier.selectAll([1, 2]);

      notifier.selectAll([2, 3, 4]);

      expect(notifier.state, {1, 2, 3, 4});
    });

    test('clear empties the selection', () {
      final notifier = SelectedQuestionsNotifier();
      notifier.selectAll([1, 2, 3, 4, 5]);

      notifier.clear();

      expect(notifier.state, isEmpty);
    });

    test('isSelected returns correct boolean', () {
      final notifier = SelectedQuestionsNotifier();
      notifier.select(1);
      notifier.select(3);

      expect(notifier.isSelected(1), true);
      expect(notifier.isSelected(2), false);
      expect(notifier.isSelected(3), true);
      expect(notifier.isSelected(99), false);
    });

    test('complex scenario with multiple operations', () {
      final notifier = SelectedQuestionsNotifier();

      notifier.selectAll([1, 2, 3]);
      expect(notifier.state.length, 3);

      notifier.toggle(1);
      expect(notifier.state, {2, 3});

      notifier.select(4);
      expect(notifier.state, {2, 3, 4});

      notifier.deselect(3);
      expect(notifier.state, {2, 4});

      notifier.clear();
      expect(notifier.state, isEmpty);
    });
  });

  group('questionsProvider', () {
    test('fetches questions with no filters', () async {
      final mockApi = _MockQuestionApi();
      final questions = [
        _createQuestion(id: 1, title: 'Q1'),
        _createQuestion(id: 2, title: 'Q2'),
      ];

      when(() => mockApi.listQuestions(
            responseType: null,
            category: null,
            isActive: true,
          )).thenAnswer((_) async => questions);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(questionsProvider.future);

      expect(result, questions);
      verify(() => mockApi.listQuestions(
            responseType: null,
            category: null,
            isActive: true,
          )).called(1);
    });

    test('applies local search filter to results', () async {
      final mockApi = _MockQuestionApi();
      final questions = [
        _createQuestion(id: 1, title: 'Mood Tracker', content: 'How is mood?'),
        _createQuestion(id: 2, title: 'Sleep Study', content: 'Hours slept'),
        _createQuestion(id: 3, title: 'Energy', content: 'Energy level'),
      ];

      when(() => mockApi.listQuestions(
            responseType: null,
            category: null,
            isActive: true,
          )).thenAnswer((_) async => questions);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      // Set search filter
      container.read(questionFiltersProvider.notifier).setSearchQuery('mood');

      final result = await container.read(questionsProvider.future);

      // Should find 'Mood Tracker' (matches title)
      expect(result.length, 1);
      expect(result[0].questionId, 1);
    });

    test('applies search filter to question content', () async {
      final mockApi = _MockQuestionApi();
      final questions = [
        _createQuestion(id: 1, title: 'Q1', content: 'How is your mood?'),
        _createQuestion(id: 2, title: 'Q2', content: 'How many hours slept?'),
      ];

      when(() => mockApi.listQuestions(
            responseType: null,
            category: null,
            isActive: true,
          )).thenAnswer((_) async => questions);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      container.read(questionFiltersProvider.notifier).setSearchQuery('hours');

      final result = await container.read(questionsProvider.future);

      expect(result.length, 1);
      expect(result[0].questionId, 2);
    });

    test('search filter is case-insensitive', () async {
      final mockApi = _MockQuestionApi();
      final questions = [
        _createQuestion(id: 1, title: 'Mood Tracker'),
        _createQuestion(id: 2, title: 'Sleep Study'),
      ];

      when(() => mockApi.listQuestions(
            responseType: null,
            category: null,
            isActive: true,
          )).thenAnswer((_) async => questions);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      container.read(questionFiltersProvider.notifier).setSearchQuery('MOOD');

      final result = await container.read(questionsProvider.future);

      expect(result.length, 1);
      expect(result[0].questionId, 1);
    });

    test('forwards response type filter to API', () async {
      final mockApi = _MockQuestionApi();

      when(() => mockApi.listQuestions(
            responseType: 'yesno',
            category: null,
            isActive: true,
          )).thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      container.read(questionFiltersProvider.notifier).setResponseType('yesno');

      await container.read(questionsProvider.future);

      verify(() => mockApi.listQuestions(
            responseType: 'yesno',
            category: null,
            isActive: true,
          )).called(1);
    });

    test('forwards category filter to API', () async {
      final mockApi = _MockQuestionApi();

      when(() => mockApi.listQuestions(
            responseType: null,
            category: 'mental_health',
            isActive: true,
          )).thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      container.read(questionFiltersProvider.notifier).setCategory('mental_health');

      await container.read(questionsProvider.future);

      verify(() => mockApi.listQuestions(
            responseType: null,
            category: 'mental_health',
            isActive: true,
          )).called(1);
    });

    test('combines API and search filters', () async {
      final mockApi = _MockQuestionApi();
      final questions = [
        _createQuestion(id: 1, title: 'Happy Mood', responseType: 'scale', category: 'mental_health'),
        _createQuestion(id: 2, title: 'Sad Mood', responseType: 'yesno', category: 'mental_health'),
        _createQuestion(id: 3, title: 'Sleep Hours', responseType: 'scale', category: 'physical_health'),
      ];

      when(() => mockApi.listQuestions(
            responseType: 'scale',
            category: 'mental_health',
            isActive: true,
          )).thenAnswer((_) async => [questions[0]]);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      container.read(questionFiltersProvider.notifier).setResponseType('scale');
      container.read(questionFiltersProvider.notifier).setCategory('mental_health');
      container.read(questionFiltersProvider.notifier).setSearchQuery('happy');

      final result = await container.read(questionsProvider.future);

      expect(result.length, 1);
      expect(result[0].questionId, 1);
    });

    test('empty search query does not filter results', () async {
      final mockApi = _MockQuestionApi();
      final questions = [
        _createQuestion(id: 1),
        _createQuestion(id: 2),
      ];

      when(() => mockApi.listQuestions(
            responseType: null,
            category: null,
            isActive: true,
          )).thenAnswer((_) async => questions);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      container.read(questionFiltersProvider.notifier).setSearchQuery('');

      final result = await container.read(questionsProvider.future);

      expect(result, questions);
    });
  });

  group('questionByIdProvider', () {
    test('fetches single question by ID', () async {
      final mockApi = _MockQuestionApi();
      final question = _createQuestion(id: 42, title: 'Specific Question');

      when(() => mockApi.getQuestion(42)).thenAnswer((_) async => question);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(questionByIdProvider(42).future);

      expect(result.questionId, 42);
      expect(result.title, 'Specific Question');
      verify(() => mockApi.getQuestion(42)).called(1);
    });

    test('fetches different questions for different IDs', () async {
      final mockApi = _MockQuestionApi();

      when(() => mockApi.getQuestion(1)).thenAnswer(
        (_) async => _createQuestion(id: 1, title: 'Q1'),
      );
      when(() => mockApi.getQuestion(2)).thenAnswer(
        (_) async => _createQuestion(id: 2, title: 'Q2'),
      );

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final result1 = await container.read(questionByIdProvider(1).future);
      final result2 = await container.read(questionByIdProvider(2).future);

      expect(result1.questionId, 1);
      expect(result2.questionId, 2);
    });
  });

  group('questionCategoriesProvider', () {
    test('fetches categories from API', () async {
      final mockApi = _MockQuestionApi();
      final categories = [
        _createCategory(id: 1, key: 'demographics'),
        _createCategory(id: 2, key: 'mental_health'),
        _createCategory(id: 3, key: 'physical_health'),
      ];

      when(() => mockApi.listCategories()).thenAnswer((_) async => categories);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(questionCategoriesProvider.future);

      expect(result, categories);
      expect(result.length, 3);
      verify(() => mockApi.listCategories()).called(1);
    });

    test('handles empty category list', () async {
      final mockApi = _MockQuestionApi();

      when(() => mockApi.listCategories()).thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => mockApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(questionCategoriesProvider.future);

      expect(result, isEmpty);
    });
  });

  group('localizedResponseTypeLabels', () {
    test('returns correct labels for all response types', () {
      // Create a mock AppLocalizations
      final mockL10n = _MockAppLocalizations();

      when(() => mockL10n.questionTypeNumber).thenReturn('Number');
      when(() => mockL10n.questionTypeYesNo).thenReturn('Yes/No');
      when(() => mockL10n.questionTypeOpenEnded).thenReturn('Open-ended');
      when(() => mockL10n.questionTypeSingleChoice).thenReturn('Single Choice');
      when(() => mockL10n.questionTypeMultiChoice).thenReturn('Multiple Choice');
      when(() => mockL10n.questionTypeScale).thenReturn('Scale');

      final labels = localizedResponseTypeLabels(mockL10n);

      expect(labels['number'], 'Number');
      expect(labels['yesno'], 'Yes/No');
      expect(labels['openended'], 'Open-ended');
      expect(labels['single_choice'], 'Single Choice');
      expect(labels['multi_choice'], 'Multiple Choice');
      expect(labels['scale'], 'Scale');
    });

    test('returns map with 6 entries', () {
      final mockL10n = _MockAppLocalizations();

      when(() => mockL10n.questionTypeNumber).thenReturn('Number');
      when(() => mockL10n.questionTypeYesNo).thenReturn('Yes/No');
      when(() => mockL10n.questionTypeOpenEnded).thenReturn('Open-ended');
      when(() => mockL10n.questionTypeSingleChoice).thenReturn('Single Choice');
      when(() => mockL10n.questionTypeMultiChoice).thenReturn('Multiple Choice');
      when(() => mockL10n.questionTypeScale).thenReturn('Scale');

      final labels = localizedResponseTypeLabels(mockL10n);

      expect(labels.length, 6);
    });
  });

  group('responseTypes constant', () {
    test('contains all expected response types', () {
      expect(responseTypes, contains('number'));
      expect(responseTypes, contains('yesno'));
      expect(responseTypes, contains('openended'));
      expect(responseTypes, contains('single_choice'));
      expect(responseTypes, contains('multi_choice'));
      expect(responseTypes, contains('scale'));
    });

    test('has exactly 6 response types', () {
      expect(responseTypes.length, 6);
    });
  });

  group('responseTypeLabels constant', () {
    test('contains all response types as keys', () {
      expect(responseTypeLabels, containsPair('number', 'Number'));
      expect(responseTypeLabels, containsPair('yesno', 'Yes/No'));
      expect(responseTypeLabels, containsPair('openended', 'Open-ended'));
      expect(responseTypeLabels, containsPair('single_choice', 'Single Choice'));
      expect(responseTypeLabels, containsPair('multi_choice', 'Multiple Choice'));
      expect(responseTypeLabels, containsPair('scale', 'Scale'));
    });

    test('has exactly 6 label mappings', () {
      expect(responseTypeLabels.length, 6);
    });
  });
}

/// Mock AppLocalizations for testing localized labels
class _MockAppLocalizations extends Mock implements AppLocalizations {}
