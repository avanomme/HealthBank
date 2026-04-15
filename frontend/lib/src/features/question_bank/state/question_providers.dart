// Created with the Assistance of Claude Code
// frontend/lib/features/question_bank/state/question_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;

/// Provider for the API client singleton
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Provider for the QuestionApi service
final questionApiProvider = Provider<QuestionApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return QuestionApi(client.dio);
});

/// Filter state for question bank
class QuestionFilters {
  final String? responseType;
  final String? category;
  final String searchQuery;

  const QuestionFilters({
    this.responseType,
    this.category,
    this.searchQuery = '',
  });

  QuestionFilters copyWith({
    String? responseType,
    String? category,
    String? searchQuery,
  }) {
    return QuestionFilters(
      responseType: responseType ?? this.responseType,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Clear a specific filter
  QuestionFilters clearFilter(String filterName) {
    switch (filterName) {
      case 'responseType':
        return QuestionFilters(
          responseType: null,
          category: category,
          searchQuery: searchQuery,
        );
      case 'category':
        return QuestionFilters(
          responseType: responseType,
          category: null,
          searchQuery: searchQuery,
        );
      case 'searchQuery':
        return QuestionFilters(
          responseType: responseType,
          category: category,
          searchQuery: '',
        );
      default:
        return this;
    }
  }

  /// Clear all filters
  QuestionFilters clearAll() {
    return const QuestionFilters();
  }
}

/// Provider for filter state
final questionFiltersProvider =
    StateNotifierProvider<QuestionFiltersNotifier, QuestionFilters>((ref) {
  return QuestionFiltersNotifier();
});

/// Notifier for filter state management
class QuestionFiltersNotifier extends StateNotifier<QuestionFilters> {
  QuestionFiltersNotifier() : super(const QuestionFilters());

  void setResponseType(String? type) {
    state = state.copyWith(responseType: type);
  }

  void setCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilter(String filterName) {
    state = state.clearFilter(filterName);
  }

  void clearAll() {
    state = state.clearAll();
  }
}

/// Provider for fetching questions from API
final questionsProvider = FutureProvider<List<Question>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(questionApiProvider);
  final filters = ref.watch(questionFiltersProvider);

  // Fetch questions with filters
  final questions = await api.listQuestions(
    responseType: filters.responseType,
    category: filters.category,
    isActive: true,
  );

  // Apply local search filter if present
  if (filters.searchQuery.isNotEmpty) {
    final query = filters.searchQuery.toLowerCase();
    return questions.where((q) {
      final titleMatch = q.title?.toLowerCase().contains(query) ?? false;
      final contentMatch = q.questionContent.toLowerCase().contains(query);
      return titleMatch || contentMatch;
    }).toList();
  }

  return questions;
});

/// Provider for a single question by ID
final questionByIdProvider =
    FutureProvider.family<Question, int>((ref, id) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(questionApiProvider);
  return api.getQuestion(id);
});

/// Provider for selected question IDs (for multi-select mode)
final selectedQuestionIdsProvider =
    StateNotifierProvider<SelectedQuestionsNotifier, Set<int>>((ref) {
  return SelectedQuestionsNotifier();
});

/// Notifier for managing selected questions
class SelectedQuestionsNotifier extends StateNotifier<Set<int>> {
  SelectedQuestionsNotifier() : super({});

  void toggle(int questionId) {
    if (state.contains(questionId)) {
      state = {...state}..remove(questionId);
    } else {
      state = {...state, questionId};
    }
  }

  void select(int questionId) {
    state = {...state, questionId};
  }

  void deselect(int questionId) {
    state = {...state}..remove(questionId);
  }

  void selectAll(List<int> questionIds) {
    state = {...state, ...questionIds};
  }

  void clear() {
    state = {};
  }

  bool isSelected(int questionId) {
    return state.contains(questionId);
  }
}

/// Provider for tracking if selection mode is active
final selectionModeProvider = StateProvider<bool>((ref) => false);

/// Provider for fetching question categories from API
final questionCategoriesProvider =
    FutureProvider<List<QuestionCategory>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(questionApiProvider);
  return api.listCategories();
});

/// Available response types for filtering
const List<String> responseTypes = [
  'number',
  'yesno',
  'openended',
  'single_choice',
  'multi_choice',
  'scale',
];

/// Human-readable labels for response types (English fallback)
const Map<String, String> responseTypeLabels = {
  'number': 'Number',
  'yesno': 'Yes/No',
  'openended': 'Open-ended',
  'single_choice': 'Single Choice',
  'multi_choice': 'Multiple Choice',
  'scale': 'Scale',
};

/// Localized labels for response types — use this instead of the const map
/// whenever a BuildContext/l10n is available.
Map<String, String> localizedResponseTypeLabels(AppLocalizations l10n) => {
  'number': l10n.questionTypeNumber,
  'yesno': l10n.questionTypeYesNo,
  'openended': l10n.questionTypeOpenEnded,
  'single_choice': l10n.questionTypeSingleChoice,
  'multi_choice': l10n.questionTypeMultiChoice,
  'scale': l10n.questionTypeScale,
};
