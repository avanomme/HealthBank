import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/assignment.dart';
import 'package:frontend/src/core/api/models/participant.dart';
import 'package:frontend/src/core/widgets/feedback/app_announcement.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/participant.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
import 'package:go_router/go_router.dart';

import '../../test_helpers.dart';

final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

ParticipantProfile _profile({
  String email = 'ada@example.com',
  String? firstName = 'Ada',
  String? lastName = 'Lovelace',
}) {
  return ParticipantProfile(
    accountId: 1,
    email: email,
    firstName: firstName,
    lastName: lastName,
  );
}

MyAssignment _assignment({
  required int id,
  required String title,
  required String status,
  DateTime? dueDate,
  DateTime? completedAt,
}) {
  return MyAssignment(
    assignmentId: id,
    surveyId: id,
    surveyTitle: title,
    dueDate: dueDate,
    status: status,
    completedAt: completedAt ?? (status == 'completed' ? DateTime.now() : null),
  );
}

ParticipantSurveyWithResponses _completedSurvey({
  required int id,
  required String title,
  DateTime? completedAt,
}) {
  return ParticipantSurveyWithResponses(
    surveyId: id,
    title: title,
    publicationStatus: 'published',
    assignmentStatus: 'completed',
    completedAt: completedAt,
    questions: const [],
  );
}

List<Override> _pageOverrides({
  ParticipantProfile? profile,
  required Future<List<MyAssignment>> Function(Ref ref) assignments,
  required Future<List<ParticipantSurveyWithResponses>> Function(Ref ref)
      surveyData,
  int notificationCount = 0,
}) {
  return [
    ..._messagingOverrides,
    participantProfileProvider.overrideWith(
      (ref) async => profile ?? _profile(),
    ),
    participantAssignmentsProvider.overrideWith(assignments),
    participantSurveyDataProvider.overrideWith(surveyData),
    participantNotificationCountProvider.overrideWith((ref) {
      return notificationCount;
    }),
  ];
}

void _setSurfaceSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
}

void main() {
  group('ParticipantDashboardPage', () {
    testWidgets('renders provider-backed dashboard content', (tester) async {
      _setSurfaceSize(tester, const Size(1440, 1800));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final now = DateTime.now();
      final todayDue = DateTime(now.year, now.month, now.day, 14);
      final tomorrowDue = DateTime(now.year, now.month, now.day + 1, 9);

      await tester.pumpWidget(
        buildTestPage(
          const ParticipantDashboardPage(),
          overrides: _pageOverrides(
            assignments: (ref) async => [
              _assignment(
                id: 1,
                title: 'Today Survey',
                status: 'pending',
                dueDate: todayDue,
              ),
              _assignment(
                id: 2,
                title: 'Tomorrow Survey',
                status: 'pending',
                dueDate: tomorrowDue,
              ),
              _assignment(
                id: 3,
                title: 'Finished Assignment',
                status: 'completed',
                dueDate: now.subtract(const Duration(days: 1)),
              ),
            ],
            surveyData: (ref) async => [
              _completedSurvey(
                id: 91,
                title: 'Recent Results Survey',
                completedAt: now.subtract(const Duration(days: 1)),
              ),
            ],
            notificationCount: 2,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Welcome, Ada. How are you today?'),
        findsOneWidget,
      );
      expect(find.textContaining('2 new messages'), findsOneWidget);
      expect(find.byType(ParticipantQuickInsightsCard), findsOneWidget);
      expect(find.text('Recent Results Survey'), findsOneWidget);
      expect(find.text('1 of 3 current tasks completed this week'), findsOneWidget);
      expect(find.text('Remaining tasks for today: 1'), findsOneWidget);
      expect(find.text('Today Survey'), findsWidgets);
      expect(find.text('Tomorrow Survey'), findsOneWidget);
      expect(find.text('Finished Assignment'), findsWidgets);
      expect(find.text('View in Results'), findsOneWidget);
      expect(find.text('View All Tasks'), findsWidgets);
      expect(find.textContaining('Due today at'), findsWidgets);
      expect(find.textContaining('Due on'), findsWidgets);
    });

    testWidgets('shows loading while assignments are unresolved', (tester) async {
      final assignmentsCompleter = Completer<List<MyAssignment>>();

      await tester.pumpWidget(
        buildTestPage(
          const ParticipantDashboardPage(),
          overrides: _pageOverrides(
            assignments: (ref) => assignmentsCompleter.future,
            surveyData: (ref) async => const [],
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Loading...'), findsWidgets);

      assignmentsCompleter.completeError(Exception('test teardown'));
      await tester.pumpAndSettle();
    });

    testWidgets('shows error state when assignments fail', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const ParticipantDashboardPage(),
          overrides: _pageOverrides(
            assignments: (ref) async => throw Exception('boom'),
            surveyData: (ref) async => const [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Something went wrong. Please try again.'),
        findsWidgets,
      );
    });

    testWidgets('hides notification banner and shows caught-up message',
        (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const ParticipantDashboardPage(),
          overrides: _pageOverrides(
            assignments: (ref) async => [
              _assignment(
                id: 1,
                title: 'Completed Assignment',
                status: 'completed',
              ),
            ],
            surveyData: (ref) async => const [],
            notificationCount: 0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppAnnouncement), findsNothing);
      expect(
        find.text('You’re all caught up. No surveys are waiting right now.'),
        findsOneWidget,
      );
    });

    testWidgets('navigates from notification, task, results and view-all CTAs',
        (tester) async {
      _setSurfaceSize(tester, const Size(1440, 1800));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final now = DateTime.now();
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const ParticipantDashboardPage(),
          ),
          GoRoute(
            path: '/participant/tasks',
            builder: (_, __) => const Scaffold(body: Text('Tasks Page')),
          ),
          GoRoute(
            path: '/participant/surveys/:surveyId',
            builder: (_, state) => Scaffold(
              body: Text('Surveys Page ${state.pathParameters['surveyId']}'),
            ),
          ),
          GoRoute(
            path: '/participant/results',
            builder: (_, state) => Scaffold(
              body: Text('Results ${state.uri.queryParameters['surveyId']}'),
            ),
          ),
          GoRoute(
            path: '/messages',
            builder: (_, __) => const Scaffold(body: Text('Messages Page')),
          ),
        ],
      );

      final overrides = _pageOverrides(
        assignments: (ref) async => [
          _assignment(
            id: 1,
            title: 'Task Survey',
            status: 'pending',
            dueDate: now,
          ),
        ],
        surveyData: (ref) async => [
          _completedSurvey(
            id: 42,
            title: 'Results Survey',
            completedAt: now,
          ),
        ],
        notificationCount: 1,
      );

      await tester.pumpWidget(TestRouterApp(router: router, overrides: overrides));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('1 new message'));
      await tester.pumpAndSettle();
      expect(find.text('Messages Page'), findsOneWidget);

      router.go('/');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Do Task').first);
      await tester.pumpAndSettle();
      expect(find.text('Surveys Page 1'), findsOneWidget);

      router.go('/');
      await tester.pumpAndSettle();

      await tester.tap(find.text('View in Results'));
      await tester.pumpAndSettle();
      expect(find.text('Results 42'), findsOneWidget);

      router.go('/');
      await tester.pumpAndSettle();

      await tester.tap(find.text('View All Tasks').first);
      await tester.pumpAndSettle();
      expect(find.text('Tasks Page'), findsOneWidget);
    });
  });

  group('ParticipantScaffold', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const ParticipantScaffold(
            currentRoute: '/participant/dashboard',
            child: Text('Test Content'),
          ),
          overrides: [..._messagingOverrides],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Content'), findsOneWidget);
    });
  });

  group('TaskCard', () {
    testWidgets('calls onDoTask when do task button is pressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildTestWidget(
          TaskCard(
            title: 'Task',
            dueTime: 'Due today at 2:00 PM',
            onDoTask: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Do Task'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
