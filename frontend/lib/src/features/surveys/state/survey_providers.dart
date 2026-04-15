// Created with the Assistance of Claude Code
// frontend/lib/features/surveys/state/survey_providers.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/state/locale_provider.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider, questionApiProvider, questionsProvider;
import 'package:frontend/src/features/templates/state/template_providers.dart'
    show templateApiProvider;

/// Auto-save status for the survey builder
enum AutoSaveStatus {
  idle, // No changes to save
  pending, // Changes detected, waiting for debounce
  saving, // Currently saving
  saved, // Recently saved successfully
  error, // Save failed
}

/// Provider for the AssignmentApi service
final assignmentApiProvider = Provider<AssignmentApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return AssignmentApi(client.dio);
});

/// Provider for all assignments for a specific survey (keyed by surveyId)
final surveyAssignmentsProvider = FutureProvider.family<List<Assignment>, int>((
  ref,
  surveyId,
) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(assignmentApiProvider);
  return api.getSurveyAssignments(surveyId);
});

/// Parameters for assignment target preview requests.
class AssignmentTargetPreviewParams {
  const AssignmentTargetPreviewParams({
    required this.surveyId,
    this.gender,
    this.ageMin,
    this.ageMax,
  });

  final int surveyId;
  final String? gender;
  final int? ageMin;
  final int? ageMax;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssignmentTargetPreviewParams &&
        other.surveyId == surveyId &&
        other.gender == gender &&
        other.ageMin == ageMin &&
        other.ageMax == ageMax;
  }

  @override
  int get hashCode => Object.hash(surveyId, gender, ageMin, ageMax);
}

/// Preview result for how many participants would be newly assigned.
class AssignmentTargetPreview {
  const AssignmentTargetPreview({
    required this.totalTargeted,
    required this.alreadyAssigned,
    required this.assignable,
  });

  final int totalTargeted;
  final int alreadyAssigned;
  final int assignable;
}

/// Provider for previewing assignment target counts for a survey.
final assignmentTargetPreviewProvider =
    FutureProvider.family<
      AssignmentTargetPreview,
      AssignmentTargetPreviewParams
    >((ref, params) async {
      ref.watch(sessionKeyProvider); // re-fetch when session changes
      final client = ref.watch(apiClientProvider);
      final response = await client.dio.get<Map<String, dynamic>>(
        '/surveys/${params.surveyId}/assignments/preview-target',
        queryParameters: <String, dynamic>{
          if (params.gender != null) 'gender': params.gender,
          if (params.ageMin != null) 'age_min': params.ageMin,
          if (params.ageMax != null) 'age_max': params.ageMax,
        },
      );

      final data = response.data ?? const <String, dynamic>{};
      return AssignmentTargetPreview(
        totalTargeted: (data['total_targeted'] as num?)?.toInt() ?? 0,
        alreadyAssigned: (data['already_assigned'] as num?)?.toInt() ?? 0,
        assignable: (data['assignable'] as num?)?.toInt() ?? 0,
      );
    });

/// Provider for the SurveyApi service
final surveyApiProvider = Provider<SurveyApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return SurveyApi(client.dio);
});

/// Filter state for survey list
class SurveyFilters {
  final String? publicationStatus;
  final String searchQuery;

  const SurveyFilters({this.publicationStatus, this.searchQuery = ''});

  SurveyFilters copyWith({String? publicationStatus, String? searchQuery}) {
    return SurveyFilters(
      publicationStatus: publicationStatus ?? this.publicationStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  SurveyFilters clearFilter(String filterName) {
    switch (filterName) {
      case 'publicationStatus':
        return SurveyFilters(publicationStatus: null, searchQuery: searchQuery);
      case 'searchQuery':
        return SurveyFilters(
          publicationStatus: publicationStatus,
          searchQuery: '',
        );
      default:
        return this;
    }
  }

  SurveyFilters clearAll() {
    return const SurveyFilters();
  }
}

/// Provider for survey filter state
final surveyFiltersProvider =
    StateNotifierProvider<SurveyFiltersNotifier, SurveyFilters>((ref) {
      return SurveyFiltersNotifier();
    });

/// Notifier for survey filter state management
class SurveyFiltersNotifier extends StateNotifier<SurveyFilters> {
  SurveyFiltersNotifier() : super(const SurveyFilters());

  void setPublicationStatus(String? status) {
    state = state.copyWith(publicationStatus: status);
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

/// Provider for fetching surveys from API
final surveysProvider = FutureProvider<List<Survey>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(surveyApiProvider);
  final filters = ref.watch(surveyFiltersProvider);

  final surveys = await api.listSurveys(
    publicationStatus: filters.publicationStatus,
  );

  // Apply local search filter if present
  if (filters.searchQuery.isNotEmpty) {
    final query = filters.searchQuery.toLowerCase();
    return surveys.where((s) {
      final titleMatch = s.title.toLowerCase().contains(query);
      final descMatch = s.description?.toLowerCase().contains(query) ?? false;
      return titleMatch || descMatch;
    }).toList();
  }

  return surveys;
});

/// Provider for a single survey by ID
/// Re-fetches when session or locale changes so questions are shown in the
/// user's selected language.
final surveyByIdProvider = FutureProvider.family<Survey, int>((ref, id) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(surveyApiProvider);
  final lang = ref.watch(localeProvider).languageCode;
  return api.getSurvey(id, language: lang == 'en' ? null : lang);
});

// ----------------------------------------------------------------------------
// Survey Builder State
// ----------------------------------------------------------------------------

/// A question item in the survey builder (local state)
class SurveyQuestionItem {
  final int questionId;
  final String? title;
  final String questionContent;
  final String responseType;
  final bool isRequired;
  final String? category;
  final int? scaleMin;
  final int? scaleMax;
  final List<QuestionOptionResponse>? options;

  const SurveyQuestionItem({
    required this.questionId,
    this.title,
    required this.questionContent,
    required this.responseType,
    required this.isRequired,
    this.category,
    this.scaleMin,
    this.scaleMax,
    this.options,
  });

  /// Create from a Question model
  ///
  /// Note: required-ness is no longer authoritative on the reusable question
  /// bank item, so imported question-bank questions default to optional until
  /// the survey builder explicitly marks them required.
  factory SurveyQuestionItem.fromQuestion(Question question) {
    return SurveyQuestionItem(
      questionId: question.questionId,
      title: question.title,
      questionContent: question.questionContent,
      responseType: question.responseType,
      isRequired: false,
      category: question.category,
      scaleMin: question.scaleMin,
      scaleMax: question.scaleMax,
      options: question.options,
    );
  }

  /// Create from a QuestionInSurvey model
  factory SurveyQuestionItem.fromQuestionInSurvey(QuestionInSurvey q) {
    return SurveyQuestionItem(
      questionId: q.questionId,
      title: q.title,
      questionContent: q.questionContent,
      responseType: q.responseType,
      isRequired: q.isRequired,
      category: q.category,
      scaleMin: q.scaleMin,
      scaleMax: q.scaleMax,
      options: q.options
          ?.map(
            (o) => QuestionOptionResponse(
              optionId: o.optionId,
              optionText: o.optionText,
              displayOrder: o.displayOrder,
            ),
          )
          .toList(),
    );
  }

  SurveyQuestionItem copyWith({
    int? questionId,
    String? title,
    String? questionContent,
    String? responseType,
    bool? isRequired,
    String? category,
    int? scaleMin,
    int? scaleMax,
    List<QuestionOptionResponse>? options,
  }) {
    return SurveyQuestionItem(
      questionId: questionId ?? this.questionId,
      title: title ?? this.title,
      questionContent: questionContent ?? this.questionContent,
      responseType: responseType ?? this.responseType,
      isRequired: isRequired ?? this.isRequired,
      category: category ?? this.category,
      scaleMin: scaleMin ?? this.scaleMin,
      scaleMax: scaleMax ?? this.scaleMax,
      options: options ?? this.options,
    );
  }
}

/// State for building/editing a survey
class SurveyBuilderState {
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<SurveyQuestionItem> questions;
  final bool isLoading;
  final String? errorMessage;
  final int? surveyId; // null for new survey
  final String publicationStatus;
  final AutoSaveStatus autoSaveStatus;
  final DateTime? lastSavedAt;

  const SurveyBuilderState({
    this.title = '',
    this.description = '',
    this.startDate,
    this.endDate,
    this.questions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.surveyId,
    this.publicationStatus = 'draft',
    this.autoSaveStatus = AutoSaveStatus.idle,
    this.lastSavedAt,
  });

  SurveyBuilderState copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<SurveyQuestionItem>? questions,
    bool? isLoading,
    String? errorMessage,
    int? surveyId,
    String? publicationStatus,
    AutoSaveStatus? autoSaveStatus,
    DateTime? lastSavedAt,
  }) {
    return SurveyBuilderState(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      surveyId: surveyId ?? this.surveyId,
      publicationStatus: publicationStatus ?? this.publicationStatus,
      autoSaveStatus: autoSaveStatus ?? this.autoSaveStatus,
      lastSavedAt: lastSavedAt ?? this.lastSavedAt,
    );
  }

  bool get isValid => title.isNotEmpty;
  bool get isEditMode => surveyId != null;
  bool get hasQuestions => questions.isNotEmpty;
}

/// Provider for survey builder state
final surveyBuilderProvider =
    StateNotifierProvider<SurveyBuilderNotifier, SurveyBuilderState>((ref) {
      return SurveyBuilderNotifier(ref);
    });

/// Notifier for survey builder state management
class SurveyBuilderNotifier extends StateNotifier<SurveyBuilderState> {
  final Ref ref;
  Timer? _autoSaveTimer;
  static const _autoSaveDelay = Duration(seconds: 2);

  SurveyBuilderNotifier(this.ref) : super(const SurveyBuilderState());

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  List<SurveyQuestionLinkCreate> _buildQuestionLinks() {
    return state.questions
        .map(
          (q) => SurveyQuestionLinkCreate(
            questionId: q.questionId,
            isRequired: q.isRequired,
          ),
        )
        .toList();
  }

  /// Schedule an auto-save after debounce period
  void _scheduleAutoSave() {
    // Cancel any pending auto-save
    _autoSaveTimer?.cancel();

    // Don't auto-save if title is empty (invalid)
    if (!state.isValid) {
      state = state.copyWith(autoSaveStatus: AutoSaveStatus.idle);
      return;
    }

    // Mark as pending
    state = state.copyWith(autoSaveStatus: AutoSaveStatus.pending);

    // Schedule new auto-save
    _autoSaveTimer = Timer(_autoSaveDelay, () {
      _performAutoSave();
    });
  }

  /// Perform the auto-save (silent, doesn't set isLoading)
  Future<void> _performAutoSave() async {
    if (!state.isValid) return;

    state = state.copyWith(autoSaveStatus: AutoSaveStatus.saving);

    try {
      final api = ref.read(surveyApiProvider);
      final questionLinks = _buildQuestionLinks();

      Survey result;

      if (state.isEditMode) {
        result = await api.updateSurvey(
          state.surveyId!,
          SurveyUpdate(
            title: state.title,
            description: state.description.isEmpty ? null : state.description,
            startDate: state.startDate,
            endDate: state.endDate,
            questions: questionLinks,
          ),
        );
      } else {
        result = await api.createSurvey(
          SurveyCreate(
            title: state.title,
            description: state.description.isEmpty ? null : state.description,
            publicationStatus: PublicationStatus.draft,
            startDate: state.startDate,
            endDate: state.endDate,
            questions: questionLinks,
          ),
        );
      }

      // Update state with survey ID and saved status
      state = state.copyWith(
        surveyId: result.surveyId,
        autoSaveStatus: AutoSaveStatus.saved,
        lastSavedAt: DateTime.now(),
      );

      // Invalidate surveys list to refresh
      ref.invalidate(surveysProvider);
      if (state.surveyId != null) {
        ref.invalidate(surveyByIdProvider(state.surveyId!));
      }

      // Reset to idle after showing "saved" for a moment
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && state.autoSaveStatus == AutoSaveStatus.saved) {
          state = state.copyWith(autoSaveStatus: AutoSaveStatus.idle);
        }
      });
    } catch (e) {
      state = state.copyWith(autoSaveStatus: AutoSaveStatus.error);
    }
  }

  /// Reset to initial state for creating a new survey
  void reset() {
    _autoSaveTimer?.cancel();
    state = const SurveyBuilderState();
  }

  /// Load an existing survey for editing
  Future<void> loadSurvey(int surveyId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final api = ref.read(surveyApiProvider);
      final survey = await api.getSurvey(surveyId);

      state = SurveyBuilderState(
        surveyId: survey.surveyId,
        title: survey.title,
        description: survey.description ?? '',
        startDate: survey.startDate,
        endDate: survey.endDate,
        publicationStatus: survey.publicationStatus,
        questions:
            survey.questions
                ?.map((q) => SurveyQuestionItem.fromQuestionInSurvey(q))
                .toList() ??
            [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load survey: $e',
      );
    }
  }

  /// Load questions from a template (for "Use Template" feature)
  /// This populates the builder with the template's questions but creates a NEW survey
  Future<void> loadFromTemplate(int templateId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final templateApi = ref.read(templateApiProvider);
      final template = await templateApi.getTemplate(templateId);

      // Convert template questions to survey question items
      final questions =
          template.questions
              ?.map(
                (q) => SurveyQuestionItem(
                  questionId: q.questionId,
                  title: q.title,
                  questionContent: q.questionContent,
                  responseType: q.responseType,
                  isRequired: q.isRequired,
                  options: q.options
                      ?.map(
                        (o) => QuestionOptionResponse(
                          optionId: o.optionId,
                          optionText: o.optionText,
                          displayOrder: o.displayOrder,
                        ),
                      )
                      .toList(),
                ),
              )
              .toList() ??
          [];

      // Set title and description from template but keep surveyId null (new survey)
      state = SurveyBuilderState(
        title: template.title,
        description: template.description ?? '',
        publicationStatus: 'draft',
        questions: questions,
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
    _scheduleAutoSave();
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
    _scheduleAutoSave();
  }

  void setStartDate(DateTime? date) {
    state = state.copyWith(startDate: date);
    _scheduleAutoSave();
  }

  void setEndDate(DateTime? date) {
    state = state.copyWith(endDate: date);
    _scheduleAutoSave();
  }

  /// Add questions from the question bank
  void addQuestions(List<Question> questions) {
    final newItems = questions
        .map((q) => SurveyQuestionItem.fromQuestion(q))
        .toList();

    // Filter out duplicates
    final existingIds = state.questions.map((q) => q.questionId).toSet();
    final uniqueItems = newItems
        .where((q) => !existingIds.contains(q.questionId))
        .toList();

    state = state.copyWith(questions: [...state.questions, ...uniqueItems]);
    _scheduleAutoSave();
  }

  /// Create a new question via API and add it to the survey.
  /// Called when user confirms an inline question card in the builder.
  ///
  /// Flow:
  ///   1. POST /api/v1/questions — creates the question in the question bank
  ///   2. Adds the question to the local survey state
  ///   3. Immediately saves/updates the survey so the question is linked
  ///      (rather than waiting for the 2-second auto-save timer)
  Future<Question?> createAndAddQuestion(QuestionCreate createData) async {
    try {
      final api = ref.read(questionApiProvider);
      final question = await api.createQuestion(createData);

      // Add to survey questions list (also schedules auto-save timer)
      addQuestions([question]);

      // Invalidate question bank so it shows the new question
      ref.invalidate(questionsProvider);

      // Cancel the auto-save timer and save immediately so the question
      // is linked to the survey right away (not after a 2-second delay).
      if (state.isValid) {
        _autoSaveTimer?.cancel();
        await _performAutoSave();
      }

      return question;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to create question: $e');
      return null;
    }
  }

  /// Update an existing question's content via API.
  ///
  /// Calls PUT /api/v1/questions/{id} — only updates the question in the
  /// question bank. The survey's question link metadata (like isRequired)
  /// remains local to the survey builder and must be preserved.
  Future<Question?> updateQuestion(
      int questionId, QuestionUpdate updateData) async {
    try {
      final api = ref.read(questionApiProvider);
      final updated = await api.updateQuestion(questionId, updateData);

      // Preserve survey-level link metadata like isRequired when replacing
      // the locally cached question content.
      state = state.copyWith(
        questions: state.questions
            .map((q) => q.questionId == questionId
                ? q.copyWith(
                    title: updated.title,
                    questionContent: updated.questionContent,
                    responseType: updated.responseType,
                    category: updated.category,
                    scaleMin: updated.scaleMin,
                    scaleMax: updated.scaleMax,
                    options: updated.options,
                  )
                : q)
            .toList(),
      );

      // Refresh the question bank list so changes appear there too
      ref.invalidate(questionsProvider);

      return updated;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update question: $e');
      return null;
    }
  }

  /// Update the required flag for a question within this survey
  void setQuestionRequired(int questionId, bool isRequired) {
    state = state.copyWith(
      questions: state.questions
          .map((q) => q.questionId == questionId
              ? q.copyWith(isRequired: isRequired)
              : q)
          .toList(),
    );
    _scheduleAutoSave();
  }

  /// Remove a question from the survey
  void removeQuestion(int questionId) {
    state = state.copyWith(
      questions: state.questions
          .where((q) => q.questionId != questionId)
          .toList(),
    );
    _scheduleAutoSave();
  }

  /// Reorder questions
  void reorderQuestions(int oldIndex, int newIndex) {
    final questions = List<SurveyQuestionItem>.from(state.questions);
    if (newIndex > oldIndex) newIndex--;
    final item = questions.removeAt(oldIndex);
    questions.insert(newIndex, item);
    state = state.copyWith(questions: questions);
    _scheduleAutoSave();
  }

  /// Save the survey as draft (create or update)
  Future<Survey?> saveDraft() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'Title is required');
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final api = ref.read(surveyApiProvider);
      final questionLinks = _buildQuestionLinks();

      Survey result;

      if (state.isEditMode) {
        result = await api.updateSurvey(
          state.surveyId!,
          SurveyUpdate(
            title: state.title,
            description: state.description.isEmpty ? null : state.description,
            startDate: state.startDate,
            endDate: state.endDate,
            questions: questionLinks,
          ),
        );
      } else {
        result = await api.createSurvey(
          SurveyCreate(
            title: state.title,
            description: state.description.isEmpty ? null : state.description,
            publicationStatus: PublicationStatus.draft,
            startDate: state.startDate,
            endDate: state.endDate,
            questions: questionLinks,
          ),
        );
      }

      // Update state with new survey ID if created
      state = state.copyWith(isLoading: false, surveyId: result.surveyId);

      // Invalidate surveys list to refresh
      ref.invalidate(surveysProvider);
      ref.invalidate(surveyByIdProvider(result.surveyId));

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save survey: $e',
      );
      return null;
    }
  }

  /// Save and publish the survey
  Future<Survey?> saveAndPublish() async {
    // First save as draft
    final saved = await saveDraft();
    if (saved == null) return null;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final api = ref.read(surveyApiProvider);
      final published = await api.publishSurvey(saved.surveyId);

      state = state.copyWith(isLoading: false);
      ref.invalidate(surveysProvider);
      ref.invalidate(surveyByIdProvider(saved.surveyId));

      return published;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to publish survey: $e',
      );
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}