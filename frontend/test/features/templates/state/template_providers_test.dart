import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/templates/state/template_providers.dart';

class _FakeTemplateApi implements TemplateApi {
  bool throwOnGetTemplate = false;
  bool throwOnCreateTemplate = false;
  bool throwOnUpdateTemplate = false;

  int listTemplatesCalls = 0;
  int? lastListIsPublic;
  int? lastGetTemplateId;
  int createTemplateCalls = 0;
  int updateTemplateCalls = 0;
  int? lastUpdateTemplateId;
  TemplateCreate? lastCreatePayload;
  TemplateUpdate? lastUpdatePayload;

  Template? getTemplateResult;
  Template? createTemplateResult;
  Template? updateTemplateResult;

  @override
  Future<List<Template>> listTemplates({bool? isPublic, int? creatorId}) async {
    listTemplatesCalls++;
    lastListIsPublic = isPublic == null ? null : (isPublic ? 1 : 0);
    return const [];
  }

  @override
  Future<Template> getTemplate(int id) async {
    lastGetTemplateId = id;
    if (throwOnGetTemplate) {
      throw Exception('get-template-failed');
    }

    return getTemplateResult ??
        Template(
          templateId: id,
          title: 'Template $id',
          description: 'Description',
          isPublic: false,
          questions: const [],
        );
  }

  @override
  Future<Template> createTemplate(TemplateCreate template) async {
    createTemplateCalls++;
    lastCreatePayload = template;

    if (throwOnCreateTemplate) {
      throw Exception('create-template-failed');
    }

    return createTemplateResult ??
        const Template(
          templateId: 100,
          title: 'Created',
          description: null,
          isPublic: false,
          questions: [],
        );
  }

  @override
  Future<Template> updateTemplate(int id, TemplateUpdate template) async {
    updateTemplateCalls++;
    lastUpdateTemplateId = id;
    lastUpdatePayload = template;

    if (throwOnUpdateTemplate) {
      throw Exception('update-template-failed');
    }

    return updateTemplateResult ??
        Template(
          templateId: id,
          title: template.title ?? 'Updated',
          description: template.description,
          isPublic: template.isPublic ?? false,
          questions: const [],
        );
  }

  @override
  Future<void> deleteTemplate(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Template> duplicateTemplate(int id) {
    throw UnimplementedError();
  }
}

Question _question(int id, String content, {String? title}) {
  return Question(
    questionId: id,
    title: title,
    questionContent: content,
    responseType: 'openended',
    isRequired: false,
  );
}

void main() {
  group('TemplateFilters', () {
    test('copyWith updates fields and preserves existing values', () {
      const base = TemplateFilters(isPublic: true, searchQuery: 'heart');

      final updatedQuery = base.copyWith(searchQuery: 'sleep');
      final updatedVisibility = base.copyWith(isPublic: false);

      expect(updatedQuery.isPublic, true);
      expect(updatedQuery.searchQuery, 'sleep');
      expect(updatedVisibility.isPublic, false);
      expect(updatedVisibility.searchQuery, 'heart');
    });

    test('clearFilter clears only the requested filter', () {
      const base = TemplateFilters(isPublic: true, searchQuery: 'vitals');

      final noVisibility = base.clearFilter('isPublic');
      final noSearch = base.clearFilter('searchQuery');
      final unchanged = base.clearFilter('unknown');

      expect(noVisibility.isPublic, isNull);
      expect(noVisibility.searchQuery, 'vitals');
      expect(noSearch.isPublic, true);
      expect(noSearch.searchQuery, '');
      expect(unchanged, same(base));
    });

    test('clearAll returns default filters', () {
      const base = TemplateFilters(isPublic: false, searchQuery: 'abc');
      final cleared = base.clearAll();

      expect(cleared.isPublic, isNull);
      expect(cleared.searchQuery, '');
    });
  });

  group('TemplateFiltersNotifier', () {
    test('updates each filter method and clear helpers', () {
      final notifier = TemplateFiltersNotifier();

      notifier.setIsPublic(true);
      expect(notifier.state.isPublic, true);

      notifier.setSearchQuery('energy');
      expect(notifier.state.searchQuery, 'energy');

      notifier.clearFilter('searchQuery');
      expect(notifier.state.searchQuery, '');
      expect(notifier.state.isPublic, true);

      notifier.clearAll();
      expect(notifier.state, const TemplateFilters());
    });
  });

  group('SelectedTemplatesNotifier', () {
    test('toggle, select, deselect, selectAll, clear, isSelected work', () {
      final notifier = SelectedTemplatesNotifier();

      expect(notifier.state, isEmpty);

      notifier.toggle(1);
      expect(notifier.isSelected(1), true);

      notifier.toggle(1);
      expect(notifier.isSelected(1), false);

      notifier.select(2);
      notifier.select(3);
      expect(notifier.state, {2, 3});

      notifier.deselect(2);
      expect(notifier.state, {3});

      notifier.selectAll([3, 4, 5]);
      expect(notifier.state, {3, 4, 5});

      notifier.clear();
      expect(notifier.state, isEmpty);
    });
  });

  group('template providers', () {
    test('templateSelectionModeProvider defaults to false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(templateSelectionModeProvider), false);
    });

    test('templatesProvider forwards visibility filter to API', () async {
      final fakeApi = _FakeTemplateApi();
      final container = ProviderContainer(
        overrides: [
          templateApiProvider.overrideWith((ref) => fakeApi),
        ],
      );
      addTearDown(container.dispose);

      container.read(templateFiltersProvider.notifier).setIsPublic(true);
      await container.read(templatesProvider.future);

      expect(fakeApi.listTemplatesCalls, 1);
      expect(fakeApi.lastListIsPublic, 1);
    });

    test('templatesProvider applies local search filtering', () async {
      final container = ProviderContainer(
        overrides: [
          templateApiProvider.overrideWith((ref) => _SearchFakeApi()),
        ],
      );
      addTearDown(container.dispose);

      container.read(templateFiltersProvider.notifier).setSearchQuery('sleep');
      final result = await container.read(templatesProvider.future);

      expect(result.map((t) => t.templateId), [2, 3]);
    });

    test('templateByIdProvider forwards requested id', () async {
      final fakeApi = _FakeTemplateApi();
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final template = await container.read(templateByIdProvider(77).future);

      expect(fakeApi.lastGetTemplateId, 77);
      expect(template.templateId, 77);
    });
  });

  group('TemplateQuestionItem factories', () {
    test('fromQuestion maps fields', () {
      final model = _question(10, 'How are you?', title: 'Mood');

      final item = TemplateQuestionItem.fromQuestion(model);

      expect(item.questionId, 10);
      expect(item.title, 'Mood');
      expect(item.questionContent, 'How are you?');
      expect(item.responseType, 'openended');
      expect(item.isRequired, false);
    });

    test('fromQuestionInTemplate maps fields and converts options', () {
      const model = QuestionInTemplate(
        questionId: 11,
        title: 'Pain level',
        questionContent: 'Rate pain',
        responseType: 'single_choice',
        isRequired: true,
        displayOrder: 1,
        options: [
          QuestionOption(optionId: 22, optionText: 'Low', displayOrder: 1),
          QuestionOption(optionId: 23, optionText: 'High', displayOrder: 2),
        ],
      );

      final item = TemplateQuestionItem.fromQuestionInTemplate(model);

      expect(item.questionId, 11);
      expect(item.title, 'Pain level');
      expect(item.options, isNotNull);
      expect(item.options!.length, 2);
      expect(item.options!.first.optionId, 22); // preserves source optionId
      expect(item.options!.first.optionText, 'Low');
    });
  });

  group('TemplateBuilderNotifier', () {
    test('reset and field setters update state', () {
      final fakeApi = _FakeTemplateApi();
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);

      notifier.setTitle('Template A');
      notifier.setDescription('Description A');
      notifier.setIsPublic(true);

      final updated = container.read(templateBuilderProvider);
      expect(updated.title, 'Template A');
      expect(updated.description, 'Description A');
      expect(updated.isPublic, true);

      notifier.reset();
      expect(container.read(templateBuilderProvider), const TemplateBuilderState());
    });

    test('loadTemplate success populates edit state', () async {
      final fakeApi = _FakeTemplateApi()
        ..getTemplateResult = const Template(
          templateId: 5,
          title: 'Loaded Template',
          description: 'Loaded description',
          isPublic: true,
          questions: [
            QuestionInTemplate(
              questionId: 3,
              title: 'Q1',
              questionContent: 'Body',
              responseType: 'yesno',
              isRequired: false,
              displayOrder: 1,
            ),
          ],
        );

      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);
      await notifier.loadTemplate(5);

      final state = container.read(templateBuilderProvider);
      expect(fakeApi.lastGetTemplateId, 5);
      expect(state.templateId, 5);
      expect(state.title, 'Loaded Template');
      expect(state.description, 'Loaded description');
      expect(state.isPublic, true);
      expect(state.questions.length, 1);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
    });

    test('loadTemplate failure sets errorMessage', () async {
      final fakeApi = _FakeTemplateApi()..throwOnGetTemplate = true;
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);
      await notifier.loadTemplate(9);

      final state = container.read(templateBuilderProvider);
      expect(state.isLoading, false);
      expect(state.errorMessage, contains('Failed to load template'));
      expect(state.errorMessage, contains('get-template-failed'));
    });

    test('addQuestions filters duplicates and appends unique items', () {
      final fakeApi = _FakeTemplateApi();
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);
      notifier.addQuestions([
        _question(1, 'First'),
        _question(2, 'Second'),
      ]);
      notifier.addQuestions([
        _question(2, 'Second duplicate'),
        _question(3, 'Third'),
      ]);

      final ids = container.read(templateBuilderProvider).questions.map((q) => q.questionId).toList();
      expect(ids, [1, 2, 3]);
    });

    test('removeQuestion and reorderQuestions update list correctly', () {
      final fakeApi = _FakeTemplateApi();
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);
      notifier.addQuestions([
        _question(1, 'First'),
        _question(2, 'Second'),
        _question(3, 'Third'),
      ]);

      notifier.reorderQuestions(0, 3); // move first item to the end
      var ids = container.read(templateBuilderProvider).questions.map((q) => q.questionId).toList();
      expect(ids, [2, 3, 1]);

      notifier.removeQuestion(3);
      ids = container.read(templateBuilderProvider).questions.map((q) => q.questionId).toList();
      expect(ids, [2, 1]);
    });

    test('save returns null and sets error for invalid title', () async {
      final fakeApi = _FakeTemplateApi();
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);
      final result = await notifier.save();

      expect(result, isNull);
      expect(fakeApi.createTemplateCalls, 0);
      expect(fakeApi.updateTemplateCalls, 0);
      expect(container.read(templateBuilderProvider).errorMessage, 'Title is required');
    });

    test('save in create mode calls createTemplate and normalizes empty description', () async {
      final fakeApi = _FakeTemplateApi()
        ..createTemplateResult = const Template(
          templateId: 70,
          title: 'Saved Create',
          description: null,
          isPublic: true,
          questions: [],
        );
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);
      notifier.setTitle('Create Me');
      notifier.setDescription('');
      notifier.setIsPublic(true);
      notifier.addQuestions([_question(9, 'Q9'), _question(10, 'Q10')]);

      final result = await notifier.save();

      expect(result?.templateId, 70);
      expect(fakeApi.createTemplateCalls, 1);
      expect(fakeApi.updateTemplateCalls, 0);
      expect(fakeApi.lastCreatePayload?.title, 'Create Me');
      expect(fakeApi.lastCreatePayload?.description, isNull);
      expect(fakeApi.lastCreatePayload?.isPublic, true);
      expect(fakeApi.lastCreatePayload?.questions?.map((q) => q.questionId).toList(), [9, 10]);
      expect(container.read(templateBuilderProvider).isLoading, false);
      expect(container.read(templateBuilderProvider).errorMessage, isNull);
    });

    test('save in edit mode calls updateTemplate', () async {
      final fakeApi = _FakeTemplateApi();
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);

      fakeApi.getTemplateResult = const Template(
        templateId: 88,
        title: 'Original',
        description: 'Original description',
        isPublic: false,
        questions: [],
      );
      await notifier.loadTemplate(88);

      notifier.setTitle('Edited title');
      notifier.setDescription('Edited description');
      notifier.setIsPublic(true);
      notifier.addQuestions([_question(5, 'Q5')]);

      final result = await notifier.save();

      expect(result, isNotNull);
      expect(fakeApi.createTemplateCalls, 0);
      expect(fakeApi.updateTemplateCalls, 1);
      expect(fakeApi.lastUpdateTemplateId, 88);
      expect(fakeApi.lastUpdatePayload?.title, 'Edited title');
      expect(fakeApi.lastUpdatePayload?.description, 'Edited description');
      expect(fakeApi.lastUpdatePayload?.isPublic, true);
      expect(fakeApi.lastUpdatePayload?.questions?.map((q) => q.questionId).toList(), [5]);
    });

    test('save failure sets errorMessage and returns null', () async {
      final fakeApi = _FakeTemplateApi()..throwOnCreateTemplate = true;
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);
      notifier.setTitle('Will fail');

      final result = await notifier.save();

      expect(result, isNull);
      expect(container.read(templateBuilderProvider).isLoading, false);
      expect(container.read(templateBuilderProvider).errorMessage, contains('Failed to save template'));
      expect(container.read(templateBuilderProvider).errorMessage, contains('create-template-failed'));
    });

    test('clearError clears current error message', () async {
      final fakeApi = _FakeTemplateApi();
      final container = ProviderContainer(
        overrides: [templateApiProvider.overrideWith((ref) => fakeApi)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(templateBuilderProvider.notifier);
      await notifier.save(); // invalid title -> sets error
      expect(container.read(templateBuilderProvider).errorMessage, isNotNull);

      notifier.clearError();
      expect(container.read(templateBuilderProvider).errorMessage, isNull);
    });
  });
}

class _SearchFakeApi extends _FakeTemplateApi {
  @override
  Future<List<Template>> listTemplates({bool? isPublic, int? creatorId}) async {
    return const [
      Template(
        templateId: 1,
        title: 'Mood Tracker',
        description: 'Daily reflection',
        isPublic: false,
        questions: [],
      ),
      Template(
        templateId: 2,
        title: 'Sleep Quality',
        description: 'Sleep baseline',
        isPublic: true,
        questions: [],
      ),
      Template(
        templateId: 3,
        title: 'Hydration',
        description: 'SLEEP and water habits',
        isPublic: true,
        questions: [],
      ),
    ];
  }
}
