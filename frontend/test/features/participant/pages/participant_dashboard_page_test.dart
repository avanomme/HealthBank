import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/api/models/assignment.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/pages/participant_dashboard_page.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
import 'package:frontend/src/features/participant/state/participant_providers.dart';
import 'package:go_router/go_router.dart';

import '../../../test_helpers.dart';

MyAssignment _assignment({
  required int id,
  required String status,
  String? title,
  DateTime? dueDate,
  DateTime? completedAt,
}) {
  return MyAssignment(
    assignmentId: id,
    surveyId: id,
    status: status,
    surveyTitle: title,
    dueDate: dueDate,
    completedAt: completedAt ?? (status == 'completed' ? DateTime.now() : null),
  );
}

List<Override> _overrides({
  Future<ParticipantProfile> Function(Ref ref)? profile,
  Future<List<MyAssignment>> Function(Ref ref)? assignments,
  Future<List<ParticipantSurveyWithResponses>> Function(Ref ref)? surveys,
  int notificationCount = 0,
  int unreadMessages = 0,
}) {
  return [
    participantProfileProvider.overrideWith(
      profile ??
          (ref) async => const ParticipantProfile(
                accountId: 1,
                email: 'participant@example.com',
                firstName: 'Alex',
                lastName: 'Morgan',
              ),
    ),
    participantAssignmentsProvider.overrideWith(
      assignments ?? (ref) async => const [],
    ),
    participantSurveyDataProvider.overrideWith(
      surveys ?? (ref) async => const [],
    ),
    participantNotificationCountProvider.overrideWith(
      (ref) => notificationCount,
    ),
    messagingUnreadCountProvider.overrideWith((ref) => unreadMessages),
  ];
}

GoRouter _routerForDashboard() {
  return GoRouter(
    initialLocation: AppRoutes.participantDashboard,
    routes: [
      GoRoute(
        path: AppRoutes.participantDashboard,
        builder: (_, __) => const ParticipantDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.participantTasks,
        builder: (_, __) => const Scaffold(body: Text('Tasks Destination')),
      ),
      GoRoute(
        path: AppRoutes.participantSurvey,
        builder: (_, state) => Scaffold(
          body: Text('Survey Destination ${state.pathParameters['surveyId']}'),
        ),
      ),
      GoRoute(
        path: AppRoutes.participantResults,
        builder: (_, state) => Scaffold(
          body: Text('Results Destination ${state.uri.queryParameters['surveyId'] ?? '-'}'),
        ),
      ),
      GoRoute(
        path: AppRoutes.messagesInbox,
        builder: (_, __) => const Scaffold(body: Text('Messages Destination')),
      ),
    ],
  );
}

void main() {
  group('ParticipantDashboardPage', () {
    void setTallViewport(WidgetTester tester) {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 2200);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('shows loading while profile is pending', (tester) async {
      final profileCompleter = Completer<ParticipantProfile>();
      addTearDown(() {
        if (!profileCompleter.isCompleted) {
          profileCompleter.completeError(Exception('test teardown'));
        }
      });

      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            profile: (ref) => profileCompleter.future,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Loading...'), findsWidgets);

      profileCompleter.completeError(Exception('test teardown'));
      await tester.pumpAndSettle();
    });

    testWidgets('shows generic error when profile fails', (tester) async {
      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            profile: (ref) async => throw Exception('boom'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Something went wrong'), findsWidgets);
    });

    testWidgets('shows loading and error states for assignments provider',
        (tester) async {
      final assignmentsCompleter = Completer<List<MyAssignment>>();

      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            assignments: (ref) => assignmentsCompleter.future,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Loading...'), findsWidgets);

      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            assignments: (ref) async => throw Exception('assignments failed'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome, Alex. How are you today?'), findsOneWidget);
      expect(find.text('Your Task Progress:'), findsNothing);
    });

    testWidgets('shows task progress and no-tasks-due-today state', (tester) async {
      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            assignments: (ref) async => [
              _assignment(id: 1, status: 'completed', title: 'Sleep Survey'),
              _assignment(id: 2, status: 'completed', title: 'Diet Survey'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome, Alex. How are you today?'), findsOneWidget);
      expect(find.text('Your Task Progress:'), findsOneWidget);
      expect(find.text('2 of 2 current tasks completed this week'), findsOneWidget);
      expect(find.text('No tasks due today'), findsOneWidget);
    });

    testWidgets('shows quick insights empty-completed state',
        (tester) async {
      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            assignments: (ref) async => [
              _assignment(id: 1, status: 'pending', title: 'Pending 1'),
            ],
            surveys: (ref) async => const [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quick Insights'), findsOneWidget);
      expect(
        find.text(
          'No completed surveys yet. Once you finish one, it will appear here.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows quick insights most recent completed survey',
        (tester) async {
      setTallViewport(tester);
      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            surveys: (ref) async => [
              const ParticipantSurveyWithResponses(
                surveyId: 900,
                title: 'Vitals Survey',
                publicationStatus: 'published',
                assignmentStatus: 'completed',
                questions: [
                  ParticipantQuestionResponse(
                    questionId: 1,
                    questionContent: 'Tell us more',
                    responseType: 'open_ended',
                    isRequired: true,
                    responseValue: 'good',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quick Insights'), findsOneWidget);
      expect(find.text('Most recent survey completed'), findsOneWidget);
      expect(find.text('Vitals Survey'), findsWidgets);
      expect(find.text('View in Results'), findsOneWidget);
    });

    testWidgets('formats due text for no deadline and future due date',
        (tester) async {
      final dueFuture = DateTime.now().add(const Duration(days: 3));

      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            assignments: (ref) async => [
              _assignment(id: 10, status: 'pending', title: null, dueDate: null),
              _assignment(
                id: 11,
                status: 'pending',
                title: 'Future task',
                dueDate: dueFuture,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Survey'), findsWidgets);
      expect(find.text('No deadline'), findsWidgets);
      expect(find.textContaining('Due on'), findsWidgets);
    });

    testWidgets('shows notification banner and navigates to messages on tap',
        (tester) async {
      final router = _routerForDashboard();

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: _overrides(notificationCount: 2),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('new messages'), findsOneWidget);

      await tester.tap(find.textContaining('new messages'));
      await tester.pumpAndSettle();

      expect(find.text('Messages Destination'), findsOneWidget);
    });

    testWidgets('quick insights view in results navigates with surveyId query',
        (tester) async {
      setTallViewport(tester);
      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            assignments: (ref) async => [
              _assignment(id: 1, status: 'completed', title: 'Completed 1'),
            ],
            surveys: (ref) async => [
              ParticipantSurveyWithResponses(
                surveyId: 77,
                title: 'Recent Completed Survey',
                publicationStatus: 'published',
                assignmentStatus: 'completed',
                completedAt: DateTime(2026, 2, 2),
                questions: const [],
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('View in Results'));
      await tester.tap(find.text('View in Results'));
      await tester.pumpAndSettle();

      expect(find.text('Results Destination 77'), findsOneWidget);
    });

    testWidgets('sorts pending tasks and supports task/result navigation',
        (tester) async {
      final now = DateTime.now();
      final today = DateUtils.dateOnly(now);
      final soonToday = DateTime(today.year, today.month, today.day, 10, 0);
      final laterToday = DateTime(today.year, today.month, today.day, 16, 0);

      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForDashboard(),
          overrides: _overrides(
            assignments: (ref) async => [
              _assignment(
                id: 4,
                status: 'pending',
                title: 'Later task',
                dueDate: laterToday,
              ),
              _assignment(
                id: 3,
                status: 'pending',
                title: 'Soon task',
                dueDate: soonToday,
              ),
              _assignment(id: 8, status: 'completed', title: 'Done task'),
            ],
            surveys: (ref) async => [
              ParticipantSurveyWithResponses(
                surveyId: 55,
                title: 'Mood Check',
                publicationStatus: 'published',
                assignmentStatus: 'completed',
                completedAt: DateTime(2026, 2, 1),
                questions: const [],
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Remaining tasks for today: 2'), findsOneWidget);
      expect(find.text('Soon task'), findsWidgets);
      expect(find.text('Later task'), findsWidgets);

      final soonY = tester.getTopLeft(find.text('Soon task').first).dy;
      final laterY = tester.getTopLeft(find.text('Later task').first).dy;
      expect(soonY < laterY, isTrue);

      expect(find.textContaining('Due today at'), findsWidgets);
      expect(find.text('View All Tasks'), findsWidgets);
    });

    testWidgets('task CTAs navigate to survey and tasks routes', (tester) async {
      setTallViewport(tester);
      final today = DateUtils.dateOnly(DateTime.now());
      final dueToday = DateTime(today.year, today.month, today.day, 13, 30);
      final router = _routerForDashboard();

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: _overrides(
            assignments: (ref) async => [
              _assignment(
                id: 30,
                status: 'pending',
                title: 'Startable task',
                dueDate: dueToday,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Do Task').first);
      await tester.tap(find.text('Do Task').first);
      await tester.pumpAndSettle();

      expect(find.text('Survey Destination 30'), findsOneWidget);

      router.go(AppRoutes.participantDashboard);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('View All Tasks').first);
      await tester.tap(find.text('View All Tasks').first);
      await tester.pumpAndSettle();

      expect(find.text('Tasks Destination'), findsOneWidget);
    });
  });
}
