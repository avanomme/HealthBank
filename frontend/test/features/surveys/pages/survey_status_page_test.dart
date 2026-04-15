import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/surveys/pages/survey_status_page.dart';
import 'package:frontend/src/features/surveys/state/survey_providers.dart';
import 'package:go_router/go_router.dart';

import '../../../test_helpers.dart';

class _FakeSurveyApi implements SurveyApi {
  int? publishedId;
  int? closedId;
  int? deletedId;

  @override
  Future<Survey> publishSurvey(int id) async {
    publishedId = id;
    return _publishedSurvey;
  }

  @override
  Future<Survey> closeSurvey(int id) async {
    closedId = id;
    return _closedSurvey;
  }

  @override
  Future<void> deleteSurvey(int id) async {
    deletedId = id;
  }

  @override
  Future<Survey> createFromTemplate(int templateId, SurveyFromTemplateCreate? overrides) async {
    throw UnimplementedError();
  }

  @override
  Future<Survey> createSurvey(SurveyCreate survey) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Assignment>> bulkAssignSurvey(int id, BulkAssignmentCreate assignment) async {
    throw UnimplementedError();
  }

  @override
  Future<Assignment> assignSurvey(int id, AssignmentCreate assignment) async {
    throw UnimplementedError();
  }

  @override
  Future<Survey> getSurvey(int id, {String? language}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Assignment>> getSurveyAssignments(int id, {String? status}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Survey>> listSurveys({String? publicationStatus, int? creatorId}) async {
    throw UnimplementedError();
  }

  @override
  Future<Survey> updateSurvey(int id, SurveyUpdate survey) async {
    throw UnimplementedError();
  }
}

class _FakeAssignmentApiForStatus implements AssignmentApi {
  @override
  Future<BulkAssignmentResult> assignSurveyBulk(int surveyId, Map<String, dynamic> body) async {
    return const BulkAssignmentResult(assigned: 2, skipped: 0, totalTargeted: 2);
  }

  @override
  Future<void> assignSurvey(int surveyId, AssignmentCreate body) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAssignment(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<MyAssignment>> getMyAssignments({String? status}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Assignment>> getSurveyAssignments(int surveyId, {String? status}) async {
    throw UnimplementedError();
  }

  @override
  Future<Assignment> updateAssignment(int id, AssignmentUpdate assignment) async {
    throw UnimplementedError();
  }
}

const _draftSurvey = Survey(
  surveyId: 1,
  title: 'Mood Survey',
  description: 'Track wellbeing over time',
  status: 'not-started',
  publicationStatus: 'draft',
  questionCount: 4,
);

const _publishedSurvey = Survey(
  surveyId: 1,
  title: 'Mood Survey',
  description: 'Track wellbeing over time',
  status: 'active',
  publicationStatus: 'published',
  questionCount: 4,
);

const _closedSurvey = Survey(
  surveyId: 1,
  title: 'Mood Survey',
  description: 'Track wellbeing over time',
  status: 'closed',
  publicationStatus: 'closed',
  questionCount: 4,
);

List<Assignment> _statusAssignments() => [
      Assignment(
        assignmentId: 1,
        surveyId: 1,
        accountId: 10,
        assignedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        status: 'pending',
      ),
      Assignment(
        assignmentId: 2,
        surveyId: 1,
        accountId: 11,
        assignedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
        status: 'completed',
      ),
      Assignment(
        assignmentId: 3,
        surveyId: 1,
        accountId: 12,
        assignedAt: DateTime.parse('2024-01-03T00:00:00.000Z'),
        status: 'expired',
      ),
    ];

GoRouter _buildRouter(List<Override> overrides) {
  return GoRouter(
    initialLocation: '/surveys/1/status',
    routes: [
      GoRoute(
        path: '/surveys/1/status',
        builder: (context, state) => ProviderScope(
          overrides: overrides,
          child: const SurveyStatusPage(surveyId: 1),
        ),
      ),
      GoRoute(
        path: '/surveys/1/edit',
        builder: (context, state) => const Scaffold(body: Text('Edit Survey Page')),
      ),
      GoRoute(
        path: AppRoutes.surveys,
        builder: (context, state) => const Scaffold(body: Text('Survey List Page')),
      ),
    ],
  );
}

void main() {
  const previewParams = AssignmentTargetPreviewParams(surveyId: 1);

  group('SurveyStatusPage', () {
    late _FakeSurveyApi surveyApi;

    setUp(() {
      surveyApi = _FakeSurveyApi();
    });

    List<Override> overridesForSurvey(Survey survey) => [
          surveyApiProvider.overrideWith((ref) => surveyApi),
          assignmentApiProvider.overrideWith((ref) => _FakeAssignmentApiForStatus()),
          messagingUnreadCountProvider.overrideWith((ref) => 0),
          surveyByIdProvider(1).overrideWith((ref) async => survey),
          surveyAssignmentsProvider(1).overrideWith((ref) async => _statusAssignments()),
          assignmentTargetPreviewProvider(previewParams).overrideWith(
            (ref) async => const AssignmentTargetPreview(
              totalTargeted: 2,
              alreadyAssigned: 0,
              assignable: 2,
            ),
          ),
        ];

    void setDesktopViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(1600, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('renders survey summary and assignment analytics', (tester) async {
      setDesktopViewport(tester);
      final router = _buildRouter(overridesForSurvey(_publishedSurvey));

      await tester.pumpWidget(TestRouterApp(router: router));
      await tester.pumpAndSettle();

      expect(find.text('Survey Status'), findsOneWidget);
      expect(find.text('Mood Survey'), findsOneWidget);
      expect(find.text('Track wellbeing over time'), findsOneWidget);
      expect(find.text('Published'), findsOneWidget);
      expect(find.text('Assignment Analytics'), findsOneWidget);
      expect(find.text('Assigned Total'), findsOneWidget);
      expect(find.byType(AppPieChart), findsOneWidget);
    });

    testWidgets('draft survey publishes through confirm dialog', (tester) async {
      setDesktopViewport(tester);
      final router = _buildRouter(overridesForSurvey(_draftSurvey));

      await tester.pumpWidget(TestRouterApp(router: router));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Publish').first);
      await tester.tap(find.text('Publish').first, warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Publish').last, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(surveyApi.publishedId, 1);
      expect(find.text('Survey published successfully'), findsOneWidget);
    });

    testWidgets('published survey closes through confirm dialog', (tester) async {
      setDesktopViewport(tester);
      final router = _buildRouter(overridesForSurvey(_publishedSurvey));

      await tester.pumpWidget(TestRouterApp(router: router));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Close').first);
      await tester.tap(find.text('Close').first, warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Close Survey'),
        ).last,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(surveyApi.closedId, 1);
      expect(find.text('Survey closed'), findsOneWidget);
    });

    testWidgets('delete action navigates back to survey list', (tester) async {
      setDesktopViewport(tester);
      final router = _buildRouter(overridesForSurvey(_publishedSurvey));

      await tester.pumpWidget(TestRouterApp(router: router));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Delete').first);
      await tester.tap(find.text('Delete').first, warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete').last, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(surveyApi.deletedId, 1);
      expect(find.text('Survey List Page'), findsOneWidget);
    });

    testWidgets('edit action pushes edit route', (tester) async {
      setDesktopViewport(tester);
      final router = _buildRouter(overridesForSurvey(_publishedSurvey));

      await tester.pumpWidget(TestRouterApp(router: router));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Edit'));
      await tester.tap(find.text('Edit'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('Edit Survey Page'), findsOneWidget);
    });

    testWidgets('published survey shows assign action', (tester) async {
      setDesktopViewport(tester);
      final router = _buildRouter(overridesForSurvey(_publishedSurvey));

      await tester.pumpWidget(TestRouterApp(router: router));
      await tester.pumpAndSettle();

      expect(find.text('Assign'), findsOneWidget);
    });

    testWidgets('null survey id shows not found state', (tester) async {
      setDesktopViewport(tester);
      await tester.pumpWidget(buildTestPage(
        const SurveyStatusPage(surveyId: null),
        overrides: [
          messagingUnreadCountProvider.overrideWith((ref) => 0),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Not found.'), findsOneWidget);
    });
  });
}
