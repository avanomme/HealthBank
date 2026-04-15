import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider, questionApiProvider, questionsProvider;
import 'package:frontend/src/features/surveys/state/survey_providers.dart';
import 'package:frontend/src/features/templates/state/template_providers.dart'
    show templateApiProvider;

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _FakeSurveyApi implements SurveyApi {
  bool throwOnList = false;
  bool throwOnGet = false;
  bool throwOnCreate = false;
  bool throwOnUpdate = false;
  bool throwOnPublish = false;

  String? lastPublicationStatus;
  int? lastGetId;
  int? lastUpdateId;
  int? lastPublishId;
  SurveyCreate? lastCreatePayload;
  SurveyUpdate? lastUpdatePayload;

  List<Survey> listResult = const [];
  Survey? getResult;
  Survey? createResult;
  Survey? updateResult;

  @override
  Future<List<Survey>> listSurveys({
    String? publicationStatus,
    int? creatorId,
  }) async {
    if (throwOnList) throw Exception('list-failed');
    lastPublicationStatus = publicationStatus;
    return listResult;
  }

  @override
  Future<Survey> getSurvey(int id, {String? language}) async {
    if (throwOnGet) throw Exception('get-failed');
    lastGetId = id;
    return getResult ??
        Survey(
          surveyId: id,
          title: 'Survey $id',
          publicationStatus: 'draft',
          status: 'not-started',
          description: 'desc',
          questions: const [],
        );
  }

  @override
  Future<Survey> createSurvey(SurveyCreate survey) async {
    if (throwOnCreate) throw Exception('create-failed');
    lastCreatePayload = survey;
    return createResult ??
        Survey(
          surveyId: 88,
          title: survey.title,
          publicationStatus: 'draft',
          status: 'not-started',
          description: survey.description,
          questions: const [],
        );
  }

  @override
  Future<Survey> updateSurvey(int id, SurveyUpdate survey) async {
    if (throwOnUpdate) throw Exception('update-failed');
    lastUpdateId = id;
    lastUpdatePayload = survey;
    return updateResult ??
        Survey(
          surveyId: id,
          title: survey.title ?? 'updated',
          publicationStatus: 'draft',
          status: 'not-started',
          description: survey.description,
          questions: const [],
        );
  }

  @override
  Future<Survey> publishSurvey(int id) async {
    if (throwOnPublish) throw Exception('publish-failed');
    lastPublishId = id;
    return Survey(
      surveyId: id,
      title: 'published',
      publicationStatus: 'published',
      status: 'active',
      questions: const [],
    );
  }

  @override
  Future<List<Assignment>> getSurveyAssignments(int id, {String? status}) {
    throw UnimplementedError();
  }

  @override
  Future<Survey> closeSurvey(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Survey> createFromTemplate(
    int templateId,
    SurveyFromTemplateCreate? overrides,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSurvey(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Assignment> assignSurvey(int id, AssignmentCreate assignment) {
    throw UnimplementedError();
  }

  @override
  Future<List<Assignment>> bulkAssignSurvey(
    int id,
    BulkAssignmentCreate assignment,
  ) {
    throw UnimplementedError();
  }
}

class _FakeAssignmentApi implements AssignmentApi {
  int? lastSurveyId;
  List<Assignment> result = const [];

  @override
  Future<List<Assignment>> getSurveyAssignments(int surveyId, {String? status}) async {
    lastSurveyId = surveyId;
    return result;
  }

  @override
  Future<void> assignSurvey(int surveyId, AssignmentCreate body) {
    throw UnimplementedError();
  }

  @override
  Future<BulkAssignmentResult> assignSurveyBulk(
    int surveyId,
    Map<String, dynamic> body,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAssignment(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<MyAssignment>> getMyAssignments({String? status}) {
    throw UnimplementedError();
  }

  @override
  Future<Assignment> updateAssignment(int id, AssignmentUpdate assignment) {
    throw UnimplementedError();
  }
}

class _FakeQuestionApi implements QuestionApi {
  bool throwOnCreate = false;
  bool throwOnUpdate = false;
  int createCalls = 0;
  int updateCalls = 0;
  int? lastUpdateId;

  @override
  Future<Question> createQuestion(QuestionCreate question) async {
    if (throwOnCreate) throw Exception('question-create-failed');
    createCalls++;
    return Question(
      questionId: 900,
      title: question.title,
      questionContent: question.questionContent,
      responseType: question.responseType,
      isRequired: question.isRequired,
      category: question.category,
      scaleMin: question.scaleMin,
      scaleMax: question.scaleMax,
      options: question.options
          ?.asMap()
          .entries
          .map(
            (e) => QuestionOptionResponse(
              optionId: e.key + 1,
              optionText: e.value.optionText,
              displayOrder: e.value.displayOrder,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<Question> updateQuestion(int id, QuestionUpdate question) async {
    if (throwOnUpdate) throw Exception('question-update-failed');
    updateCalls++;
    lastUpdateId = id;
    return Question(
      questionId: id,
      title: question.title,
      questionContent: question.questionContent ?? 'updated',
      responseType: question.responseType ?? 'openended',
      isRequired: question.isRequired ?? false,
      category: question.category,
      scaleMin: question.scaleMin,
      scaleMax: question.scaleMax,
      options: question.options
          ?.asMap()
          .entries
          .map(
            (e) => QuestionOptionResponse(
              optionId: e.key + 1,
              optionText: e.value.optionText,
              displayOrder: e.value.displayOrder,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> deleteQuestion(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Question> getQuestion(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<QuestionCategory>> listCategories() {
    throw UnimplementedError();
  }

  @override
  Future<List<Question>> listQuestions({
    String? responseType,
    String? category,
    bool? isActive,
  }) {
    throw UnimplementedError();
  }
}

class _FakeTemplateApi implements TemplateApi {
  bool throwOnGet = false;
  int? lastTemplateId;
  Template? getResult;

  @override
  Future<Template> getTemplate(int id) async {
    if (throwOnGet) throw Exception('template-get-failed');
    lastTemplateId = id;
    return getResult ??
        Template(
          templateId: id,
          title: 'Template $id',
          description: 'template desc',
          isPublic: false,
          questions: const [],
        );
  }

  @override
  Future<Template> createTemplate(TemplateCreate template) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTemplate(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Template> duplicateTemplate(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Template>> listTemplates({bool? isPublic, int? creatorId}) {
    throw UnimplementedError();
  }

  @override
  Future<Template> updateTemplate(int id, TemplateUpdate template) {
    throw UnimplementedError();
  }
}

Question _q(int id, String content) {
  return Question(
    questionId: id,
    title: 'Q$id',
    questionContent: content,
    responseType: 'openended',
    isRequired: false,
  );
}

void main() {
  group('filters and value types', () {
    test('SurveyFilters and notifier methods', () {
      final notifier = SurveyFiltersNotifier();
      notifier.setPublicationStatus('draft');
      notifier.setSearchQuery('abc');

      expect(notifier.state.publicationStatus, 'draft');
      expect(notifier.state.searchQuery, 'abc');

      notifier.clearFilter('searchQuery');
      expect(notifier.state.searchQuery, '');

      notifier.clearAll();
      expect(notifier.state, const SurveyFilters());
    });

    test('AssignmentTargetPreviewParams equality and hashCode', () {
      const a = AssignmentTargetPreviewParams(
        surveyId: 1,
        gender: 'F',
        ageMin: 18,
        ageMax: 35,
      );
      const b = AssignmentTargetPreviewParams(
        surveyId: 1,
        gender: 'F',
        ageMin: 18,
        ageMax: 35,
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('SurveyQuestionItem factories map source models', () {
      final fromQuestion = SurveyQuestionItem.fromQuestion(_q(7, 'How are you?'));
      expect(fromQuestion.questionId, 7);

      const inSurvey = QuestionInSurvey(
        questionId: 8,
        title: 'Pain',
        questionContent: 'Rate pain',
        responseType: 'single_choice',
        isRequired: true,
        options: [
          QuestionOption(optionId: 1, optionText: 'Low', displayOrder: 1),
        ],
      );
      final fromInSurvey = SurveyQuestionItem.fromQuestionInSurvey(inSurvey);
      expect(fromInSurvey.questionId, 8);
      expect(fromInSurvey.options, isNotNull);
      expect(fromInSurvey.options!.first.optionText, 'Low');
    });

    test('SurveyBuilderState computed properties', () {
      const empty = SurveyBuilderState();
      expect(empty.isValid, false);
      expect(empty.isEditMode, false);
      expect(empty.hasQuestions, false);

      const populated = SurveyBuilderState(
        title: 'X',
        surveyId: 9,
        questions: [
          SurveyQuestionItem(
            questionId: 1,
            questionContent: 'Q',
            responseType: 'openended',
            isRequired: false,
          ),
        ],
      );
      expect(populated.isValid, true);
      expect(populated.isEditMode, true);
      expect(populated.hasQuestions, true);
    });
  });

  group('top-level survey providers', () {
    test('assignmentApiProvider creates AssignmentApi from apiClient', () {
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWith((ref) => _FakeApiClient(Dio())),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(assignmentApiProvider), isA<AssignmentApi>());
    });

    test('surveyAssignmentsProvider forwards surveyId to api', () async {
      final fake = _FakeAssignmentApi()
        ..result = [
          Assignment(
            assignmentId: 1,
            surveyId: 22,
            accountId: 1,
            assignedAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
            status: 'pending',
          ),
        ];
      final container = ProviderContainer(
        overrides: [assignmentApiProvider.overrideWith((ref) => fake)],
      );
      addTearDown(container.dispose);

      final result = await container.read(surveyAssignmentsProvider(22).future);
      expect(fake.lastSurveyId, 22);
      expect(result.length, 1);
    });

    test('assignmentTargetPreviewProvider parses response payload', () async {
      RequestOptions? captured;
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: const {
                  'total_targeted': 20,
                  'already_assigned': 6,
                  'assignable': 14,
                },
              ),
            );
          },
        ),
      );

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWith((ref) => _FakeApiClient(dio)),
        ],
      );
      addTearDown(container.dispose);

      const params = AssignmentTargetPreviewParams(
        surveyId: 50,
        gender: 'M',
        ageMin: 30,
        ageMax: 65,
      );

      final preview = await container.read(assignmentTargetPreviewProvider(params).future);
      expect(preview.totalTargeted, 20);
      expect(preview.alreadyAssigned, 6);
      expect(preview.assignable, 14);
      expect(captured?.path, '/surveys/50/assignments/preview-target');
      expect(captured?.queryParameters['gender'], 'M');
      expect(captured?.queryParameters['age_min'], 30);
      expect(captured?.queryParameters['age_max'], 65);
    });

    test('surveysProvider forwards status filter and applies search filter', () async {
      final fake = _FakeSurveyApi()
        ..listResult = [
          const Survey(
            surveyId: 1,
            title: 'Mood Tracker',
            publicationStatus: 'draft',
            status: 'not-started',
            description: 'daily check',
            questions: [],
          ),
          const Survey(
            surveyId: 2,
            title: 'Sleep Study',
            publicationStatus: 'draft',
            status: 'not-started',
            description: 'sleep quality',
            questions: [],
          ),
        ];

      final container = ProviderContainer(
        overrides: [surveyApiProvider.overrideWith((ref) => fake)],
      );
      addTearDown(container.dispose);

      final filters = container.read(surveyFiltersProvider.notifier);
      filters.setPublicationStatus('draft');
      filters.setSearchQuery('sleep');

      final result = await container.read(surveysProvider.future);
      expect(fake.lastPublicationStatus, 'draft');
      expect(result.map((s) => s.surveyId), [2]);
    });

    test('surveyByIdProvider forwards id', () async {
      final fake = _FakeSurveyApi();
      final container = ProviderContainer(
        overrides: [surveyApiProvider.overrideWith((ref) => fake)],
      );
      addTearDown(container.dispose);

      final survey = await container.read(surveyByIdProvider(70).future);
      expect(fake.lastGetId, 70);
      expect(survey.surveyId, 70);
    });
  });

  group('SurveyBuilderNotifier', () {
    test('reset and field setters update state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      notifier.setTitle('T');
      notifier.setDescription('D');
      notifier.setStartDate(DateTime(2026, 1, 1));
      notifier.setEndDate(DateTime(2026, 2, 1));

      final state = container.read(surveyBuilderProvider);
      expect(state.title, 'T');
      expect(state.description, 'D');
      expect(state.autoSaveStatus, AutoSaveStatus.pending);

      notifier.reset();
      expect(container.read(surveyBuilderProvider), const SurveyBuilderState());
    });

    test('loadSurvey success populates edit state', () async {
      final fake = _FakeSurveyApi()
        ..getResult = const Survey(
          surveyId: 11,
          title: 'Loaded Survey',
          publicationStatus: 'draft',
          status: 'not-started',
          description: 'loaded desc',
          questions: [
            QuestionInSurvey(
              questionId: 1,
              title: 'Q1',
              questionContent: 'Body',
              responseType: 'yesno',
              isRequired: false,
            ),
          ],
        );
      final container = ProviderContainer(
        overrides: [surveyApiProvider.overrideWith((ref) => fake)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      await notifier.loadSurvey(11);

      final state = container.read(surveyBuilderProvider);
      expect(state.surveyId, 11);
      expect(state.title, 'Loaded Survey');
      expect(state.questions.length, 1);
      expect(state.errorMessage, isNull);
      expect(state.isLoading, false);
    });

    test('loadSurvey failure sets error message', () async {
      final fake = _FakeSurveyApi()..throwOnGet = true;
      final container = ProviderContainer(
        overrides: [surveyApiProvider.overrideWith((ref) => fake)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      await notifier.loadSurvey(12);

      final state = container.read(surveyBuilderProvider);
      expect(state.errorMessage, contains('Failed to load survey'));
      expect(state.errorMessage, contains('get-failed'));
    });

    test('loadFromTemplate success maps template questions', () async {
      final templateApi = _FakeTemplateApi()
        ..getResult = const Template(
          templateId: 2,
          title: 'Template X',
          description: 'tpl desc',
          isPublic: false,
          questions: [
            QuestionInTemplate(
              questionId: 4,
              title: 'Q4',
              questionContent: 'From template',
              responseType: 'single_choice',
              isRequired: true,
              displayOrder: 1,
              options: [
                QuestionOption(optionId: 1, optionText: 'Yes', displayOrder: 1),
              ],
            ),
          ],
        );
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => templateApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      await notifier.loadFromTemplate(2);

      final state = container.read(surveyBuilderProvider);
      expect(state.surveyId, isNull);
      expect(state.title, 'Template X');
      expect(state.questions.length, 1);
      expect(state.questions.first.options, isNotNull);
    });

    test('loadFromTemplate failure sets error message', () async {
      final templateApi = _FakeTemplateApi()..throwOnGet = true;
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => templateApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      await notifier.loadFromTemplate(99);

      final state = container.read(surveyBuilderProvider);
      expect(state.errorMessage, contains('Failed to load template'));
      expect(state.errorMessage, contains('template-get-failed'));
    });

    test('addQuestions filters duplicates and remove/reorder work', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(surveyBuilderProvider.notifier);

      notifier.setTitle('valid');
      notifier.addQuestions([_q(1, 'A'), _q(2, 'B')]);
      notifier.addQuestions([_q(2, 'B dup'), _q(3, 'C')]);

      expect(container.read(surveyBuilderProvider).questions.map((e) => e.questionId), [1, 2, 3]);

      notifier.reorderQuestions(0, 3);
      expect(container.read(surveyBuilderProvider).questions.map((e) => e.questionId), [2, 3, 1]);

      notifier.removeQuestion(3);
      expect(container.read(surveyBuilderProvider).questions.map((e) => e.questionId), [2, 1]);
    });

    test('createAndAddQuestion success creates question and saves survey immediately', () async {
      final surveyApi = _FakeSurveyApi();
      final questionApi = _FakeQuestionApi();
      final container = ProviderContainer(
        overrides: [
          surveyApiProvider.overrideWith((ref) => surveyApi),
          questionApiProvider.overrideWith((ref) => questionApi),
          questionsProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      notifier.setTitle('Builder title');
      final created = await notifier.createAndAddQuestion(
        const QuestionCreate(
          title: 'New Q',
          questionContent: 'Question body',
          responseType: 'openended',
          isRequired: false,
        ),
      );

      expect(created, isNotNull);
      expect(questionApi.createCalls, 1);
      expect(surveyApi.lastCreatePayload, isNotNull);
      expect(container.read(surveyBuilderProvider).questions.any((q) => q.questionId == 900), true);
    });

    test('createAndAddQuestion failure sets error and returns null', () async {
      final questionApi = _FakeQuestionApi()..throwOnCreate = true;
      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => questionApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      final result = await notifier.createAndAddQuestion(
        const QuestionCreate(
          title: 'Bad Q',
          questionContent: 'X',
          responseType: 'openended',
          isRequired: false,
        ),
      );
      expect(result, isNull);
      expect(container.read(surveyBuilderProvider).errorMessage, contains('Failed to create question'));
    });

    test('updateQuestion success replaces local question', () async {
      final questionApi = _FakeQuestionApi();
      final container = ProviderContainer(
        overrides: [
          questionApiProvider.overrideWith((ref) => questionApi),
          questionsProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      notifier.setTitle('Valid');
      notifier.addQuestions([_q(7, 'Old text')]);

      final updated = await notifier.updateQuestion(
        7,
        const QuestionUpdate(questionContent: 'Updated text'),
      );

      expect(updated, isNotNull);
      expect(questionApi.updateCalls, 1);
      expect(questionApi.lastUpdateId, 7);
      expect(container.read(surveyBuilderProvider).questions.first.questionContent, 'Updated text');
    });

    test('updateQuestion failure sets error and returns null', () async {
      final questionApi = _FakeQuestionApi()..throwOnUpdate = true;
      final container = ProviderContainer(
        overrides: [questionApiProvider.overrideWith((ref) => questionApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      final updated = await notifier.updateQuestion(
        1,
        const QuestionUpdate(questionContent: 'Nope'),
      );

      expect(updated, isNull);
      expect(container.read(surveyBuilderProvider).errorMessage, contains('Failed to update question'));
    });

    test('saveDraft validation and create mode success', () async {
      final fake = _FakeSurveyApi();
      final container = ProviderContainer(
        overrides: [surveyApiProvider.overrideWith((ref) => fake)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      final invalid = await notifier.saveDraft();
      expect(invalid, isNull);
      expect(container.read(surveyBuilderProvider).errorMessage, 'Title is required');

      notifier.setTitle('Create survey');
      notifier.setDescription('');
      notifier.addQuestions([_q(1, 'A'), _q(2, 'B')]);
      final saved = await notifier.saveDraft();

      expect(saved, isNotNull);
      expect(fake.lastCreatePayload, isNotNull);
      expect(fake.lastCreatePayload!.description, isNull);
      expect(fake.lastCreatePayload!.questions?.map((q) => q.questionId).toList(), [1, 2]);
    });

    test('saveDraft edit mode success and failure', () async {
      final fake = _FakeSurveyApi();
      final container = ProviderContainer(
        overrides: [surveyApiProvider.overrideWith((ref) => fake)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      await notifier.loadSurvey(5);
      notifier.setTitle('Edited');

      final saved = await notifier.saveDraft();
      expect(saved, isNotNull);
      expect(fake.lastUpdateId, 5);

      fake.throwOnUpdate = true;
      final failed = await notifier.saveDraft();
      expect(failed, isNull);
      expect(container.read(surveyBuilderProvider).errorMessage, contains('Failed to save survey'));
    });

    test('saveAndPublish success and publish failure branches', () async {
      final fake = _FakeSurveyApi();
      final container = ProviderContainer(
        overrides: [surveyApiProvider.overrideWith((ref) => fake)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(surveyBuilderProvider.notifier);
      notifier.setTitle('Publish me');
      final published = await notifier.saveAndPublish();
      expect(published, isNotNull);
      expect(fake.lastPublishId, isNotNull);

      fake.throwOnPublish = true;
      final failPublish = await notifier.saveAndPublish();
      expect(failPublish, isNull);
      expect(container.read(surveyBuilderProvider).errorMessage, contains('Failed to publish survey'));
    });

    test('clearError removes current error', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(surveyBuilderProvider.notifier);

      notifier.state = notifier.state.copyWith(errorMessage: 'x');
      notifier.clearError();
      expect(container.read(surveyBuilderProvider).errorMessage, isNull);
    });
  });
}
