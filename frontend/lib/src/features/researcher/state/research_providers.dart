// Created with the Assistance of Claude Code
// frontend/lib/src/features/researcher/state/research_providers.dart
/// Riverpod providers for the research data view page.
///
/// Provider chain: apiClientProvider → researchApiProvider → data providers.
/// Filter state managed by [ResearchFiltersNotifier].
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/research.dart';
import 'package:frontend/src/core/api/services/research_api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

/// Provider for the ResearchApi Retrofit service.
final researchApiProvider = Provider<ResearchApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return ResearchApi(client.dio);
});

/// Provider for the list of research surveys with response counts.
final researchSurveysProvider =
    FutureProvider<List<ResearchSurvey>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  return api.listResearchSurveys();
});

/// Provider for survey overview stats by survey ID.
final surveyOverviewProvider =
    FutureProvider.family<SurveyOverview, int>((ref, surveyId) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  return api.getSurveyOverview(surveyId);
});

/// Filter state for aggregate queries.
class ResearchFilters {
  const ResearchFilters({this.category, this.responseType});

  final String? category;
  final String? responseType;

  ResearchFilters copyWith({String? category, String? responseType}) {
    return ResearchFilters(
      category: category,
      responseType: responseType,
    );
  }

  ResearchFilters clearCategory() =>
      ResearchFilters(responseType: responseType);
  ResearchFilters clearResponseType() =>
      ResearchFilters(category: category);
  ResearchFilters clearAll() => const ResearchFilters();
}

/// Notifier for research filter state.
class ResearchFiltersNotifier extends StateNotifier<ResearchFilters> {
  ResearchFiltersNotifier() : super(const ResearchFilters());

  void setCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void setResponseType(String? responseType) {
    state = state.copyWith(responseType: responseType);
  }

  void clearAll() {
    state = const ResearchFilters();
  }
}

/// Provider for research filter state.
final researchFiltersProvider =
    StateNotifierProvider<ResearchFiltersNotifier, ResearchFilters>((ref) {
  return ResearchFiltersNotifier();
});

/// Provider for individual anonymized response data by survey ID (applies active filters).
final individualResponsesProvider =
    FutureProvider.family<IndividualResponseData, int>((ref, surveyId) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  final filters = ref.watch(researchFiltersProvider);
  return api.getIndividualResponses(
    surveyId,
    category: filters.category,
    responseType: filters.responseType,
  );
});

/// Provider for survey aggregates by survey ID (applies active filters).
final surveyAggregatesProvider =
    FutureProvider.family<AggregateResponse, int>((ref, surveyId) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  final filters = ref.watch(researchFiltersProvider);
  return api.getSurveyAggregates(
    surveyId,
    category: filters.category,
    responseType: filters.responseType,
  );
});

/// Provider for CSV export by survey ID (applies active filters).
final csvExportProvider =
    FutureProvider.family<String, int>((ref, surveyId) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  final filters = ref.watch(researchFiltersProvider);
  return api.exportCsv(
    surveyId,
    category: filters.category,
    responseType: filters.responseType,
  );
});

// ---------------------------------------------------------------------------
// Data bank state & providers
// ---------------------------------------------------------------------------

/// Filter/selection state for data bank mode.
class CrossSurveyFilters {
  const CrossSurveyFilters({
    this.selectedSurveyIds = const [],
    this.selectedQuestionIds = const [],
    this.dateFrom,
    this.dateTo,
    this.category,
    this.responseType,
  });

  final List<int> selectedSurveyIds;
  final List<int> selectedQuestionIds;
  final String? dateFrom;
  final String? dateTo;
  final String? category;
  final String? responseType;

  CrossSurveyFilters copyWith({
    List<int>? selectedSurveyIds,
    List<int>? selectedQuestionIds,
    String? dateFrom,
    String? dateTo,
    String? category,
    String? responseType,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    bool clearCategory = false,
    bool clearResponseType = false,
  }) {
    return CrossSurveyFilters(
      selectedSurveyIds: selectedSurveyIds ?? this.selectedSurveyIds,
      selectedQuestionIds: selectedQuestionIds ?? this.selectedQuestionIds,
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      category: clearCategory ? null : (category ?? this.category),
      responseType: clearResponseType ? null : (responseType ?? this.responseType),
    );
  }
}

/// Notifier for data bank filter state.
class CrossSurveyFiltersNotifier extends StateNotifier<CrossSurveyFilters> {
  CrossSurveyFiltersNotifier() : super(const CrossSurveyFilters());

  void toggleSurvey(int id) {
    final current = List<int>.from(state.selectedSurveyIds);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(selectedSurveyIds: current);
  }

  void toggleQuestion(int id) {
    final current = List<int>.from(state.selectedQuestionIds);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(selectedQuestionIds: current);
  }

  void setQuestions(List<int> ids) {
    state = state.copyWith(selectedQuestionIds: ids);
  }

  void clearQuestions() {
    state = state.copyWith(selectedQuestionIds: []);
  }

  void setDateFrom(String? dateFrom) {
    state = state.copyWith(dateFrom: dateFrom, clearDateFrom: dateFrom == null);
  }

  void setDateTo(String? dateTo) {
    state = state.copyWith(dateTo: dateTo, clearDateTo: dateTo == null);
  }

  void setCategory(String? category) {
    state = state.copyWith(category: category, clearCategory: category == null);
  }

  void setResponseType(String? responseType) {
    state = state.copyWith(responseType: responseType, clearResponseType: responseType == null);
  }

  void clearAll() {
    state = const CrossSurveyFilters();
  }
}

/// Provider for data bank filter state.
final crossSurveyFiltersProvider =
    StateNotifierProvider<CrossSurveyFiltersNotifier, CrossSurveyFilters>(
        (ref) {
  return CrossSurveyFiltersNotifier();
});

/// Available questions in the data bank for the field picker.
final availableQuestionsProvider =
    FutureProvider<List<CrossSurveyQuestion>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  final filters = ref.watch(crossSurveyFiltersProvider);
  return api.getAvailableQuestions(
    surveyIds: filters.selectedSurveyIds.isEmpty
        ? null
        : filters.selectedSurveyIds,
    category: filters.category,
    responseType: filters.responseType,
  );
});

/// Data bank overview stats.
final crossSurveyOverviewProvider =
    FutureProvider<CrossSurveyOverview>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  final filters = ref.watch(crossSurveyFiltersProvider);
  return api.getCrossSurveyOverview(
    surveyIds: filters.selectedSurveyIds.isEmpty
        ? null
        : filters.selectedSurveyIds,
    dateFrom: filters.dateFrom,
    dateTo: filters.dateTo,
  );
});

/// Data bank individual response data.
final crossSurveyResponsesProvider =
    FutureProvider<CrossSurveyResponseData>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  final filters = ref.watch(crossSurveyFiltersProvider);
  return api.getCrossSurveyResponses(
    surveyIds: filters.selectedSurveyIds.isEmpty
        ? null
        : filters.selectedSurveyIds,
    questionIds: filters.selectedQuestionIds.isEmpty
        ? null
        : filters.selectedQuestionIds,
    category: filters.category,
    responseType: filters.responseType,
    dateFrom: filters.dateFrom,
    dateTo: filters.dateTo,
  );
});

/// Data bank aggregate stats for charting.
final crossSurveyAggregatesProvider =
    FutureProvider<CrossSurveyAggregateResponse>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  final filters = ref.watch(crossSurveyFiltersProvider);
  return api.getCrossSurveyAggregates(
    surveyIds: filters.selectedSurveyIds.isEmpty
        ? null
        : filters.selectedSurveyIds,
    questionIds: filters.selectedQuestionIds.isEmpty
        ? null
        : filters.selectedQuestionIds,
    category: filters.category,
    responseType: filters.responseType,
    dateFrom: filters.dateFrom,
    dateTo: filters.dateTo,
  );
});

/// Data bank CSV export.
final crossSurveyCsvExportProvider = FutureProvider<String>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(researchApiProvider);
  final filters = ref.watch(crossSurveyFiltersProvider);
  return api.exportCrossSurveyCsv(
    surveyIds: filters.selectedSurveyIds.isEmpty
        ? null
        : filters.selectedSurveyIds,
    questionIds: filters.selectedQuestionIds.isEmpty
        ? null
        : filters.selectedQuestionIds,
    category: filters.category,
    responseType: filters.responseType,
    dateFrom: filters.dateFrom,
    dateTo: filters.dateTo,
  );
});
