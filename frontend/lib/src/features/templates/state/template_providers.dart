// Created with the Assistance of Claude Code
// frontend/lib/features/templates/state/template_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

/// Provider for the TemplateApi service
final templateApiProvider = Provider<TemplateApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return TemplateApi(client.dio);
});

/// Filter state for template list
class TemplateFilters {
  final bool? isPublic;
  final String searchQuery;

  const TemplateFilters({
    this.isPublic,
    this.searchQuery = '',
  });

  TemplateFilters copyWith({
    bool? isPublic,
    String? searchQuery,
  }) {
    return TemplateFilters(
      isPublic: isPublic ?? this.isPublic,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Clear a specific filter
  TemplateFilters clearFilter(String filterName) {
    switch (filterName) {
      case 'isPublic':
        return TemplateFilters(
          isPublic: null,
          searchQuery: searchQuery,
        );
      case 'searchQuery':
        return TemplateFilters(
          isPublic: isPublic,
          searchQuery: '',
        );
      default:
        return this;
    }
  }

  /// Clear all filters
  TemplateFilters clearAll() {
    return const TemplateFilters();
  }
}

/// Provider for filter state
final templateFiltersProvider =
    StateNotifierProvider<TemplateFiltersNotifier, TemplateFilters>((ref) {
  return TemplateFiltersNotifier();
});

/// Notifier for filter state management
class TemplateFiltersNotifier extends StateNotifier<TemplateFilters> {
  TemplateFiltersNotifier() : super(const TemplateFilters());

  void setIsPublic(bool? isPublic) {
    state = state.copyWith(isPublic: isPublic);
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

/// Provider for fetching templates from API
final templatesProvider = FutureProvider<List<Template>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(templateApiProvider);
  final filters = ref.watch(templateFiltersProvider);

  // Fetch templates with filters
  final templates = await api.listTemplates(
    isPublic: filters.isPublic,
  );

  // Apply local search filter if present
  if (filters.searchQuery.isNotEmpty) {
    final query = filters.searchQuery.toLowerCase();
    return templates.where((t) {
      final titleMatch = t.title.toLowerCase().contains(query);
      final descMatch = t.description?.toLowerCase().contains(query) ?? false;
      return titleMatch || descMatch;
    }).toList();
  }

  return templates;
});

/// Provider for a single template by ID
final templateByIdProvider =
    FutureProvider.family<Template, int>((ref, id) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(templateApiProvider);
  return api.getTemplate(id);
});

/// Provider for selected template IDs (for multi-select mode)
final selectedTemplateIdsProvider =
    StateNotifierProvider<SelectedTemplatesNotifier, Set<int>>((ref) {
  return SelectedTemplatesNotifier();
});

/// Notifier for managing selected templates
class SelectedTemplatesNotifier extends StateNotifier<Set<int>> {
  SelectedTemplatesNotifier() : super({});

  void toggle(int templateId) {
    if (state.contains(templateId)) {
      state = {...state}..remove(templateId);
    } else {
      state = {...state, templateId};
    }
  }

  void select(int templateId) {
    state = {...state, templateId};
  }

  void deselect(int templateId) {
    state = {...state}..remove(templateId);
  }

  void selectAll(List<int> templateIds) {
    state = {...state, ...templateIds};
  }

  void clear() {
    state = {};
  }

  bool isSelected(int templateId) {
    return state.contains(templateId);
  }
}

/// Provider for tracking if selection mode is active
final templateSelectionModeProvider = StateProvider<bool>((ref) => false);

// ----------------------------------------------------------------------------
// Template Builder State
// ----------------------------------------------------------------------------

/// State for building/editing a template
class TemplateBuilderState {
  final String title;
  final String description;
  final bool isPublic;
  final List<TemplateQuestionItem> questions;
  final bool isLoading;
  final String? errorMessage;
  final int? templateId; // null for new template

  const TemplateBuilderState({
    this.title = '',
    this.description = '',
    this.isPublic = false,
    this.questions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.templateId,
  });

  TemplateBuilderState copyWith({
    String? title,
    String? description,
    bool? isPublic,
    List<TemplateQuestionItem>? questions,
    bool? isLoading,
    String? errorMessage,
    int? templateId,
  }) {
    return TemplateBuilderState(
      title: title ?? this.title,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      templateId: templateId ?? this.templateId,
    );
  }

  bool get isValid => title.isNotEmpty;
  bool get isEditMode => templateId != null;
}

/// A question item in the template builder (local state)
class TemplateQuestionItem {
  final int questionId;
  final String? title;
  final String questionContent;
  final String responseType;
  final bool isRequired;
  final String? category;
  final List<QuestionOptionResponse>? options;

  const TemplateQuestionItem({
    required this.questionId,
    this.title,
    required this.questionContent,
    required this.responseType,
    required this.isRequired,
    this.category,
    this.options,
  });

  /// Create from a Question model
  ///
  /// Note: required-ness is no longer authoritative on the reusable question
  /// bank item, so imported question-bank questions default to optional until
  /// the template builder explicitly marks them required.
  factory TemplateQuestionItem.fromQuestion(Question question) {
    return TemplateQuestionItem(
      questionId: question.questionId,
      title: question.title,
      questionContent: question.questionContent,
      responseType: question.responseType,
      isRequired: false,
      category: question.category,
      options: question.options,
    );
  }

  /// Create from a QuestionInTemplate model
  factory TemplateQuestionItem.fromQuestionInTemplate(QuestionInTemplate q) {
    return TemplateQuestionItem(
      questionId: q.questionId,
      title: q.title,
      questionContent: q.questionContent,
      responseType: q.responseType,
      isRequired: q.isRequired,
      options: q.options?.map((o) => QuestionOptionResponse(
        optionId: o.optionId,
        optionText: o.optionText,
        displayOrder: o.displayOrder,
      )).toList(),
    );
  }

  TemplateQuestionItem copyWith({
    int? questionId,
    String? title,
    String? questionContent,
    String? responseType,
    bool? isRequired,
    String? category,
    List<QuestionOptionResponse>? options,
  }) {
    return TemplateQuestionItem(
      questionId: questionId ?? this.questionId,
      title: title ?? this.title,
      questionContent: questionContent ?? this.questionContent,
      responseType: responseType ?? this.responseType,
      isRequired: isRequired ?? this.isRequired,
      category: category ?? this.category,
      options: options ?? this.options,
    );
  }
}

/// Provider for template builder state
final templateBuilderProvider =
    StateNotifierProvider<TemplateBuilderNotifier, TemplateBuilderState>((ref) {
  return TemplateBuilderNotifier(ref);
});

/// Notifier for template builder state management
class TemplateBuilderNotifier extends StateNotifier<TemplateBuilderState> {
  final Ref ref;

  TemplateBuilderNotifier(this.ref) : super(const TemplateBuilderState());

  List<TemplateQuestionLinkCreate> _buildQuestionLinks() {
    return state.questions
        .map(
          (q) => TemplateQuestionLinkCreate(
            questionId: q.questionId,
            isRequired: q.isRequired,
          ),
        )
        .toList();
  }

  /// Reset to initial state for creating a new template
  void reset() {
    state = const TemplateBuilderState();
  }

  /// Load an existing template for editing
  Future<void> loadTemplate(int templateId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final api = ref.read(templateApiProvider);
      final template = await api.getTemplate(templateId);

      state = TemplateBuilderState(
        templateId: template.templateId,
        title: template.title,
        description: template.description ?? '',
        isPublic: template.isPublic,
        questions: template.questions
                ?.map((q) => TemplateQuestionItem.fromQuestionInTemplate(q))
                .toList() ??
            [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load template: $e',
      );
    }
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setIsPublic(bool isPublic) {
    state = state.copyWith(isPublic: isPublic);
  }

  /// Add questions from the question bank
  void addQuestions(List<Question> questions) {
    final newItems =
        questions.map((q) => TemplateQuestionItem.fromQuestion(q)).toList();

    // Filter out duplicates
    final existingIds = state.questions.map((q) => q.questionId).toSet();
    final uniqueItems =
        newItems.where((q) => !existingIds.contains(q.questionId)).toList();

    state = state.copyWith(questions: [...state.questions, ...uniqueItems]);
  }

  /// Update the required flag for a question within this template
  void setQuestionRequired(int questionId, bool isRequired) {
    state = state.copyWith(
      questions: state.questions
          .map((q) => q.questionId == questionId
              ? q.copyWith(isRequired: isRequired)
              : q)
          .toList(),
    );
  }

  /// Remove a question from the template
  void removeQuestion(int questionId) {
    state = state.copyWith(
      questions:
          state.questions.where((q) => q.questionId != questionId).toList(),
    );
  }

  /// Reorder questions
  void reorderQuestions(int oldIndex, int newIndex) {
    final questions = List<TemplateQuestionItem>.from(state.questions);
    if (newIndex > oldIndex) newIndex--;
    final item = questions.removeAt(oldIndex);
    questions.insert(newIndex, item);
    state = state.copyWith(questions: questions);
  }

  /// Save the template (create or update)
  Future<Template?> save() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'Title is required');
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final api = ref.read(templateApiProvider);
      final questionLinks = _buildQuestionLinks();

      Template result;

      if (state.isEditMode) {
        result = await api.updateTemplate(
          state.templateId!,
          TemplateUpdate(
            title: state.title,
            description: state.description.isEmpty ? null : state.description,
            isPublic: state.isPublic,
            questions: questionLinks,
          ),
        );
      } else {
        result = await api.createTemplate(
          TemplateCreate(
            title: state.title,
            description: state.description.isEmpty ? null : state.description,
            isPublic: state.isPublic,
            questions: questionLinks,
          ),
        );
      }

      // Invalidate templates list to refresh
      ref.invalidate(templatesProvider);
      ref.invalidate(templateByIdProvider(result.templateId));

      state = state.copyWith(
        isLoading: false,
        templateId: result.templateId,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save template: $e',
      );
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}