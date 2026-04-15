import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api_client.dart';
import 'package:frontend/src/core/api/models/research.dart';
import 'package:frontend/src/core/api/services/research_api.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
  show apiClientProvider;
import 'package:frontend/src/features/researcher/state/research_providers.dart';

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this._dio);

  final Dio _dio;

  @override
  Dio get dio => _dio;
}

class _FakeResearchApi implements ResearchApi {
  int? overviewSurveyId;
  int? individualSurveyId;
  String? individualCategory;
  String? individualResponseType;
  int? aggregatesSurveyId;
  String? aggregatesCategory;
  String? aggregatesResponseType;
  int? exportSurveyId;
  String? exportCategory;
  String? exportResponseType;

  List<int>? availableQuestionsSurveyIds;
  String? availableQuestionsCategory;
  String? availableQuestionsResponseType;

  List<int>? crossOverviewSurveyIds;
  String? crossOverviewDateFrom;
  String? crossOverviewDateTo;

  List<int>? crossResponsesSurveyIds;
  List<int>? crossResponsesQuestionIds;
  String? crossResponsesCategory;
  String? crossResponsesResponseType;
  String? crossResponsesDateFrom;
  String? crossResponsesDateTo;

  List<int>? crossAggregatesSurveyIds;
  List<int>? crossAggregatesQuestionIds;
  String? crossAggregatesCategory;
  String? crossAggregatesResponseType;
  String? crossAggregatesDateFrom;
  String? crossAggregatesDateTo;

  List<int>? crossCsvSurveyIds;
  List<int>? crossCsvQuestionIds;
  String? crossCsvCategory;
  String? crossCsvResponseType;
  String? crossCsvDateFrom;
  String? crossCsvDateTo;

  final surveys = const [
    ResearchSurvey(
      surveyId: 1,
      title: 'Health Survey',
      publicationStatus: 'published',
      responseCount: 12,
      questionCount: 4,
    ),
  ];

  final overview = const SurveyOverview(
    surveyId: 1,
    title: 'Health Survey',
    respondentCount: 12,
    completionRate: 90,
    questionCount: 4,
    suppressed: false,
  );

  final individual = const IndividualResponseData(
    surveyId: 1,
    title: 'Health Survey',
    respondentCount: 12,
    suppressed: false,
    questions: [],
    rows: [],
  );

  final aggregate = const AggregateResponse(
    surveyId: 1,
    title: 'Health Survey',
    totalRespondents: 12,
    aggregates: [],
  );

  final crossOverview = const CrossSurveyOverview(
    surveyIds: [1],
    surveys: [
      CrossSurveySummary(surveyId: 1, title: 'Health Survey', respondentCount: 12),
    ],
    totalRespondentCount: 12,
    totalQuestionCount: 4,
    avgCompletionRate: 90,
    suppressed: false,
  );

  final crossResponses = const CrossSurveyResponseData(
    surveyIds: [1],
    surveys: [
      CrossSurveySummary(surveyId: 1, title: 'Health Survey', respondentCount: 12),
    ],
    totalRespondentCount: 12,
    suppressed: false,
    questions: [],
    rows: [],
  );

  final crossAggregates = const CrossSurveyAggregateResponse(
    surveyIds: [1],
    totalRespondents: 12,
    aggregates: [],
  );

  final availableQuestions = const [
    CrossSurveyQuestion(
      questionId: 10,
      questionContent: 'How many hours?',
      responseType: 'number',
      surveyId: 1,
      surveyTitle: 'Health Survey',
    ),
  ];

  @override
  Future<List<ResearchSurvey>> listResearchSurveys() async => surveys;

  @override
  Future<SurveyOverview> getSurveyOverview(int id) async {
    overviewSurveyId = id;
    return overview;
  }

  @override
  Future<IndividualResponseData> getIndividualResponses(
    int id, {
    String? category,
    String? responseType,
  }) async {
    individualSurveyId = id;
    individualCategory = category;
    individualResponseType = responseType;
    return individual;
  }

  @override
  Future<AggregateResponse> getSurveyAggregates(
    int id, {
    String? category,
    String? responseType,
  }) async {
    aggregatesSurveyId = id;
    aggregatesCategory = category;
    aggregatesResponseType = responseType;
    return aggregate;
  }

  @override
  Future<String> exportCsv(
    int id, {
    String? category,
    String? responseType,
  }) async {
    exportSurveyId = id;
    exportCategory = category;
    exportResponseType = responseType;
    return 'csv-data';
  }

  @override
  Future<CrossSurveyOverview> getCrossSurveyOverview({
    List<int>? surveyIds,
    String? dateFrom,
    String? dateTo,
  }) async {
    crossOverviewSurveyIds = surveyIds;
    crossOverviewDateFrom = dateFrom;
    crossOverviewDateTo = dateTo;
    return crossOverview;
  }

  @override
  Future<List<CrossSurveyQuestion>> getAvailableQuestions({
    List<int>? surveyIds,
    String? category,
    String? responseType,
  }) async {
    availableQuestionsSurveyIds = surveyIds;
    availableQuestionsCategory = category;
    availableQuestionsResponseType = responseType;
    return availableQuestions;
  }

  @override
  Future<CrossSurveyResponseData> getCrossSurveyResponses({
    List<int>? surveyIds,
    List<int>? questionIds,
    String? category,
    String? responseType,
    String? dateFrom,
    String? dateTo,
  }) async {
    crossResponsesSurveyIds = surveyIds;
    crossResponsesQuestionIds = questionIds;
    crossResponsesCategory = category;
    crossResponsesResponseType = responseType;
    crossResponsesDateFrom = dateFrom;
    crossResponsesDateTo = dateTo;
    return crossResponses;
  }

  @override
  Future<CrossSurveyAggregateResponse> getCrossSurveyAggregates({
    List<int>? surveyIds,
    List<int>? questionIds,
    String? category,
    String? responseType,
    String? dateFrom,
    String? dateTo,
  }) async {
    crossAggregatesSurveyIds = surveyIds;
    crossAggregatesQuestionIds = questionIds;
    crossAggregatesCategory = category;
    crossAggregatesResponseType = responseType;
    crossAggregatesDateFrom = dateFrom;
    crossAggregatesDateTo = dateTo;
    return crossAggregates;
  }

  @override
  Future<String> exportCrossSurveyCsv({
    List<int>? surveyIds,
    List<int>? questionIds,
    String? category,
    String? responseType,
    String? dateFrom,
    String? dateTo,
  }) async {
    crossCsvSurveyIds = surveyIds;
    crossCsvQuestionIds = questionIds;
    crossCsvCategory = category;
    crossCsvResponseType = responseType;
    crossCsvDateFrom = dateFrom;
    crossCsvDateTo = dateTo;
    return 'cross-csv-data';
  }

  @override
  Future<QuestionAggregate> getQuestionAggregate(int id, int questionId) {
    throw UnimplementedError();
  }
}

void main() {
  group('research providers', () {
    test('researchApiProvider creates a ResearchApi instance', () {
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWith((ref) => _FakeApiClient(Dio())),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(researchApiProvider), isA<ResearchApi>());
    });

    test('researchSurveysProvider returns surveys', () async {
      final fakeApi = _FakeResearchApi();
      final container = ProviderContainer(
        overrides: [
          researchApiProvider.overrideWith((ref) => fakeApi),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(researchSurveysProvider.future);

      expect(result, fakeApi.surveys);
    });

    test('surveyOverviewProvider forwards survey id', () async {
      final fakeApi = _FakeResearchApi();
      final container = ProviderContainer(
        overrides: [researchApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final result = await container.read(surveyOverviewProvider(7).future);

      expect(fakeApi.overviewSurveyId, 7);
      expect(result, fakeApi.overview);
    });

    test('individualResponsesProvider applies category filter', () async {
      final fakeApi = _FakeResearchApi();
      final container = ProviderContainer(
        overrides: [researchApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final filters = container.read(researchFiltersProvider.notifier);
      filters.setCategory('sleep');

      final result = await container.read(individualResponsesProvider(5).future);

      expect(fakeApi.individualSurveyId, 5);
      expect(fakeApi.individualCategory, 'sleep');
      expect(fakeApi.individualResponseType, isNull);
      expect(result, fakeApi.individual);
    });

    test('surveyAggregatesProvider applies response type filter', () async {
      final fakeApi = _FakeResearchApi();
      final container = ProviderContainer(
        overrides: [researchApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final filters = container.read(researchFiltersProvider.notifier);
      filters.setResponseType('yesno');

      final result = await container.read(surveyAggregatesProvider(8).future);

      expect(fakeApi.aggregatesSurveyId, 8);
      expect(fakeApi.aggregatesCategory, isNull);
      expect(fakeApi.aggregatesResponseType, 'yesno');
      expect(result, fakeApi.aggregate);
    });

    test('csvExportProvider applies category filter', () async {
      final fakeApi = _FakeResearchApi();
      final container = ProviderContainer(
        overrides: [researchApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final filters = container.read(researchFiltersProvider.notifier);
      filters.setCategory('exercise');

      final result = await container.read(csvExportProvider(9).future);

      expect(fakeApi.exportSurveyId, 9);
      expect(fakeApi.exportCategory, 'exercise');
      expect(fakeApi.exportResponseType, isNull);
      expect(result, 'csv-data');
    });

    test('cross-survey providers map filter fields to API params', () async {
      final fakeApi = _FakeResearchApi();
      final container = ProviderContainer(
        overrides: [researchApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final filters = container.read(crossSurveyFiltersProvider.notifier);
      filters.toggleSurvey(1);
      filters.toggleQuestion(101);
      filters.setDateFrom('2026-01-01');
      filters.setDateTo('2026-01-31');
      filters.setCategory('sleep');
      filters.setResponseType('number');

      final questions = await container.read(availableQuestionsProvider.future);
      final overview = await container.read(crossSurveyOverviewProvider.future);
      final responses = await container.read(crossSurveyResponsesProvider.future);
      final aggregates = await container.read(crossSurveyAggregatesProvider.future);
      final csv = await container.read(crossSurveyCsvExportProvider.future);

      expect(questions, fakeApi.availableQuestions);
      expect(overview, fakeApi.crossOverview);
      expect(responses, fakeApi.crossResponses);
      expect(aggregates, fakeApi.crossAggregates);
      expect(csv, 'cross-csv-data');

      expect(fakeApi.availableQuestionsSurveyIds, [1]);
      expect(fakeApi.availableQuestionsCategory, 'sleep');
      expect(fakeApi.availableQuestionsResponseType, 'number');

      expect(fakeApi.crossOverviewSurveyIds, [1]);
      expect(fakeApi.crossOverviewDateFrom, '2026-01-01');
      expect(fakeApi.crossOverviewDateTo, '2026-01-31');

      expect(fakeApi.crossResponsesSurveyIds, [1]);
      expect(fakeApi.crossResponsesQuestionIds, [101]);
      expect(fakeApi.crossResponsesCategory, 'sleep');
      expect(fakeApi.crossResponsesResponseType, 'number');
      expect(fakeApi.crossResponsesDateFrom, '2026-01-01');
      expect(fakeApi.crossResponsesDateTo, '2026-01-31');

      expect(fakeApi.crossAggregatesSurveyIds, [1]);
      expect(fakeApi.crossAggregatesQuestionIds, [101]);
      expect(fakeApi.crossAggregatesCategory, 'sleep');
      expect(fakeApi.crossAggregatesResponseType, 'number');
      expect(fakeApi.crossAggregatesDateFrom, '2026-01-01');
      expect(fakeApi.crossAggregatesDateTo, '2026-01-31');

      expect(fakeApi.crossCsvSurveyIds, [1]);
      expect(fakeApi.crossCsvQuestionIds, [101]);
      expect(fakeApi.crossCsvCategory, 'sleep');
      expect(fakeApi.crossCsvResponseType, 'number');
      expect(fakeApi.crossCsvDateFrom, '2026-01-01');
      expect(fakeApi.crossCsvDateTo, '2026-01-31');
    });
  });

  group('ResearchFilters', () {
    test('copyWith and clear helpers update fields', () {
      const base = ResearchFilters(category: 'cat', responseType: 'type');

      final updated = base.copyWith(category: 'new-cat', responseType: 'new-type');
      final clearedCategory = updated.clearCategory();
      final clearedResponseType = updated.clearResponseType();
      final clearedAll = updated.clearAll();

      expect(updated.category, 'new-cat');
      expect(updated.responseType, 'new-type');

      expect(clearedCategory.category, isNull);
      expect(clearedCategory.responseType, 'new-type');

      expect(clearedResponseType.category, 'new-cat');
      expect(clearedResponseType.responseType, isNull);

      expect(clearedAll.category, isNull);
      expect(clearedAll.responseType, isNull);
    });

    test('ResearchFiltersNotifier mutates and clears state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(researchFiltersProvider.notifier);
      notifier.setCategory('mental-health');

      expect(container.read(researchFiltersProvider).category, 'mental-health');
      expect(container.read(researchFiltersProvider).responseType, isNull);

      notifier.setResponseType('scale');

      expect(container.read(researchFiltersProvider).category, isNull);
      expect(container.read(researchFiltersProvider).responseType, 'scale');

      notifier.clearAll();

      expect(container.read(researchFiltersProvider).category, isNull);
      expect(container.read(researchFiltersProvider).responseType, isNull);
    });
  });

  group('CrossSurveyFilters', () {
    test('copyWith supports clear flags', () {
      const base = CrossSurveyFilters(
        selectedSurveyIds: [1],
        selectedQuestionIds: [2],
        dateFrom: '2026-01-01',
        dateTo: '2026-01-31',
        category: 'sleep',
        responseType: 'number',
      );

      final next = base.copyWith(
        selectedSurveyIds: [3],
        selectedQuestionIds: [4],
        clearDateFrom: true,
        clearDateTo: true,
        clearCategory: true,
        clearResponseType: true,
      );

      expect(next.selectedSurveyIds, [3]);
      expect(next.selectedQuestionIds, [4]);
      expect(next.dateFrom, isNull);
      expect(next.dateTo, isNull);
      expect(next.category, isNull);
      expect(next.responseType, isNull);
    });

    test('CrossSurveyFiltersNotifier toggles, sets, and clears values', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(crossSurveyFiltersProvider.notifier);

      notifier.toggleSurvey(1);
      notifier.toggleSurvey(2);
      notifier.toggleSurvey(1);
      notifier.toggleQuestion(10);
      notifier.toggleQuestion(11);
      notifier.toggleQuestion(10);
      notifier.setQuestions([20, 21]);
      notifier.setDateFrom('2026-02-01');
      notifier.setDateTo('2026-02-29');
      notifier.setCategory('exercise');
      notifier.setResponseType('yesno');

      var state = container.read(crossSurveyFiltersProvider);
      expect(state.selectedSurveyIds, [2]);
      expect(state.selectedQuestionIds, [20, 21]);
      expect(state.dateFrom, '2026-02-01');
      expect(state.dateTo, '2026-02-29');
      expect(state.category, 'exercise');
      expect(state.responseType, 'yesno');

      notifier.clearQuestions();
      state = container.read(crossSurveyFiltersProvider);
      expect(state.selectedQuestionIds, isEmpty);

      notifier.setDateFrom(null);
      notifier.setDateTo(null);
      notifier.setCategory(null);
      notifier.setResponseType(null);

      state = container.read(crossSurveyFiltersProvider);
      expect(state.dateFrom, isNull);
      expect(state.dateTo, isNull);
      expect(state.category, isNull);
      expect(state.responseType, isNull);

      notifier.clearAll();
      state = container.read(crossSurveyFiltersProvider);
      expect(state.selectedSurveyIds, isEmpty);
      expect(state.selectedQuestionIds, isEmpty);
      expect(state.dateFrom, isNull);
      expect(state.dateTo, isNull);
      expect(state.category, isNull);
      expect(state.responseType, isNull);
    });
  });
}
