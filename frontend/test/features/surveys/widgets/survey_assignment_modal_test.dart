import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/surveys/state/survey_providers.dart';
import 'package:frontend/src/features/surveys/widgets/survey_assignment_modal.dart';

import '../../../test_helpers.dart';

class _FakeAssignmentApi implements AssignmentApi {
  Map<String, dynamic>? lastBulkBody;
  int? lastSurveyId;
  BulkAssignmentResult bulkResult = const BulkAssignmentResult(
    assigned: 3,
    skipped: 1,
    totalTargeted: 4,
  );
  Object? bulkError;

  @override
  Future<BulkAssignmentResult> assignSurveyBulk(
    int surveyId,
    Map<String, dynamic> body,
  ) async {
    lastSurveyId = surveyId;
    lastBulkBody = body;
    if (bulkError != null) {
      throw bulkError!;
    }
    return bulkResult;
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

class _ModalLauncher extends StatelessWidget {
  const _ModalLauncher();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showSurveyAssignmentModal(
            context,
            surveyId: 1,
            surveyTitle: 'Sleep Survey',
          );
        },
        child: const Text('Open'),
      ),
    );
  }
}

List<Assignment> _assignments() => [
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

void main() {
  const allParams = AssignmentTargetPreviewParams(surveyId: 1);
  const demographicParams = AssignmentTargetPreviewParams(
    surveyId: 1,
    ageMin: 0,
    ageMax: 999,
  );

  group('Survey assignment modal', () {
    late _FakeAssignmentApi api;

    setUp(() {
      api = _FakeAssignmentApi();
    });

    Future<void> openModal(
      WidgetTester tester, {
      List<Override> extraOverrides = const [],
    }) async {
      await tester.pumpWidget(buildTestWidget(
        const _ModalLauncher(),
        overrides: [
          assignmentApiProvider.overrideWith((ref) => api),
          surveyAssignmentsProvider(1).overrideWith((ref) async => _assignments()),
          assignmentTargetPreviewProvider(allParams).overrideWith(
            (ref) async => const AssignmentTargetPreview(
              totalTargeted: 5,
              alreadyAssigned: 2,
              assignable: 3,
            ),
          ),
          assignmentTargetPreviewProvider(demographicParams).overrideWith(
            (ref) async => const AssignmentTargetPreview(
              totalTargeted: 8,
              alreadyAssigned: 3,
              assignable: 5,
            ),
          ),
          ...extraOverrides,
        ],
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    testWidgets('renders preview and assignment summary', (tester) async {
      await openModal(tester);

      expect(find.text('Assign Survey'), findsOneWidget);
      expect(find.text('Sleep Survey'), findsOneWidget);
      expect(find.text('Assigning survey to 3 participants'), findsOneWidget);
      expect(find.textContaining('3 assigned'), findsOneWidget);
      expect(find.textContaining('1 pending'), findsOneWidget);
      expect(find.textContaining('1 completed'), findsOneWidget);
      expect(find.textContaining('1 expired'), findsOneWidget);
    });

    testWidgets('demographic mode validates age range before assigning',
        (tester) async {
      await openModal(tester);

      await tester.tap(find.text('By Demographic'));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Age Min'), '50');
      await tester.enterText(find.widgetWithText(TextFormField, 'Age Max'), '20');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Assign Now'));
      await tester.pumpAndSettle();

      expect(
        find.text('Minimum age must be less than or equal to maximum age.'),
        findsOneWidget,
      );
      expect(api.lastBulkBody, isNull);
    });

    testWidgets('successful assignment submits expected payload and result',
        (tester) async {
      await openModal(tester);

      await tester.tap(find.text('Assign Now'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(api.lastSurveyId, 1);
      expect(api.lastBulkBody, containsPair('assign_all', true));
      expect(find.text('Targeted: 4 • Assigned: 3 • Skipped: 1'), findsWidgets);
    });

    testWidgets('shows not published error from API', (tester) async {
      api.bulkError = DioException(
        requestOptions: RequestOptions(path: '/surveys/1/assign'),
        response: Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/surveys/1/assign'),
          statusCode: 400,
          data: const {'detail': 'survey must be published before assigning'},
        ),
      );

      await openModal(tester);

      await tester.tap(find.text('Assign Now'));
      await tester.pumpAndSettle();

      expect(
        find.text('Only published surveys can be assigned.'),
        findsOneWidget,
      );
    });

    testWidgets('shows empty assignment summary state', (tester) async {
      await openModal(
        tester,
        extraOverrides: [
          surveyAssignmentsProvider(1).overrideWith((ref) async => const <Assignment>[]),
        ],
      );

      expect(find.text('No assignments yet'), findsOneWidget);
    });
  });
}
