import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/assignment.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
import 'package:frontend/src/features/participant/state/participant_providers.dart';
import 'package:frontend/src/features/participant/widgets/participant_header.dart';
import 'package:frontend/src/features/participant/widgets/quick_insights.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';

import '../../../test_helpers.dart';

ParticipantSurveyWithResponses _completedSurvey({
  required int surveyId,
  required String title,
  DateTime? completedAt,
}) {
  return ParticipantSurveyWithResponses(
    surveyId: surveyId,
    title: title,
    publicationStatus: 'published',
    assignmentStatus: 'completed',
    completedAt: completedAt,
    questions: const [],
  );
}

MyAssignment _assignment({required int id, required String status}) {
  return MyAssignment(
    assignmentId: id,
    surveyId: id,
    status: status,
  );
}

Widget _buildInsights({
  required List<Override> overrides,
  void Function(int surveyId)? onViewResults,
}) {
  return buildTestWidget(
    ParticipantQuickInsightsCard(
      basePadding: 16,
      onViewResults: onViewResults ?? (_) {},
    ),
    overrides: overrides,
  );
}

void main() {
  group('ParticipantQuickInsightsCard', () {
    testWidgets('shows loading while survey data is pending', (tester) async {
      final completer = Completer<List<ParticipantSurveyWithResponses>>();

      await tester.pumpWidget(
        _buildInsights(
          overrides: [
            participantSurveyDataProvider.overrideWith((ref) => completer.future),
            participantAssignmentsProvider.overrideWith((ref) async => const []),
          ],
        ),
      );
      await tester.pump();

      expect(find.text('Quick Insights'), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('shows survey data error state', (tester) async {
      await tester.pumpWidget(
        _buildInsights(
          overrides: [
            participantSurveyDataProvider.overrideWith(
              (ref) async => throw Exception('boom'),
            ),
            participantAssignmentsProvider.overrideWith((ref) async => const []),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows assignments loading state', (tester) async {
      final assignmentsCompleter = Completer<List<MyAssignment>>();

      await tester.pumpWidget(
        _buildInsights(
          overrides: [
            participantSurveyDataProvider.overrideWith(
              (ref) async => [
                _completedSurvey(surveyId: 1, title: 'Done'),
              ],
            ),
            participantAssignmentsProvider.overrideWith(
              (ref) => assignmentsCompleter.future,
            ),
          ],
        ),
      );
      await tester.pump();

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('shows assignments error state', (tester) async {
      await tester.pumpWidget(
        _buildInsights(
          overrides: [
            participantSurveyDataProvider.overrideWith(
              (ref) async => [
                _completedSurvey(surveyId: 1, title: 'Done'),
              ],
            ),
            participantAssignmentsProvider.overrideWith(
              (ref) async => throw Exception('boom'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Something went wrong'), findsOneWidget);
    });

    testWidgets('renders most recent completed survey and view results action',
        (tester) async {
      int? tappedSurveyId;
      await tester.pumpWidget(
        _buildInsights(
          overrides: [
            participantSurveyDataProvider.overrideWith(
              (ref) async => [
                _completedSurvey(
                  surveyId: 2,
                  title: 'Old Survey',
                  completedAt: DateTime(2026, 1, 1),
                ),
                _completedSurvey(
                  surveyId: 5,
                  title: 'Newest Survey',
                  completedAt: DateTime(2026, 2, 1),
                ),
              ],
            ),
            participantAssignmentsProvider.overrideWith(
              (ref) async => [
                _assignment(id: 1, status: 'completed'),
                _assignment(id: 2, status: 'completed'),
              ],
            ),
          ],
          onViewResults: (id) => tappedSurveyId = id,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Most recent survey completed'), findsOneWidget);
      expect(find.text('Newest Survey'), findsOneWidget);
      expect(find.text('View in Results'), findsOneWidget);
      expect(find.text('You’re all caught up'), findsOneWidget);

      await tester.tap(find.text('View in Results'));
      await tester.pumpAndSettle();

      expect(tappedSurveyId, 5);
    });

    testWidgets('shows caught up message when no completed survey exists',
        (tester) async {
      await tester.pumpWidget(
        _buildInsights(
          overrides: [
            participantSurveyDataProvider.overrideWith((ref) async => const []),
            participantAssignmentsProvider.overrideWith(
              (ref) async => [
                _assignment(id: 1, status: 'completed'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('You’re all caught up. No surveys are waiting right now.'),
        findsOneWidget,
      );
    });

    testWidgets('shows no completed surveys message when work remains',
        (tester) async {
      await tester.pumpWidget(
        _buildInsights(
          overrides: [
            participantSurveyDataProvider.overrideWith((ref) async => const []),
            participantAssignmentsProvider.overrideWith(
              (ref) async => [
                _assignment(id: 1, status: 'pending'),
                _assignment(id: 2, status: 'completed'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('No completed surveys yet. Once you finish one, it will appear here.'),
        findsOneWidget,
      );
    });
  });

  group('ParticipantHeader', () {
    testWidgets('renders participant nav labels with unread badge input',
        (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1600, 1000);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 1400,
            child: ParticipantHeader(currentRoute: '/participant/dashboard'),
          ),
          overrides: [
            messagingUnreadCountProvider.overrideWith((ref) => 3),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final menuButton = find.byTooltip('Menu');
      if (menuButton.evaluate().isNotEmpty) {
        await tester.tap(menuButton);
        await tester.pumpAndSettle();
      }

      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('To-Do'), findsWidgets);
      expect(find.text('Surveys'), findsWidgets);
      expect(find.text('Results'), findsWidgets);
      expect(find.text('Messages'), findsWidgets);
    });
  });
}
