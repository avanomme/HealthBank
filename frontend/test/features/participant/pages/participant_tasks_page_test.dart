import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/pages/participant_tasks_page.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
import 'package:go_router/go_router.dart';

import '../../../test_helpers.dart';

class _FakeHcpLinkApi implements HcpLinkApi {
  final List<Map<String, dynamic>> respondCalls = [];
  final List<int> revokeCalls = [];
  final List<int> restoreCalls = [];

  @override
  Future<void> respondToLink(int linkId, Map<String, dynamic> body) async {
    respondCalls.add({'linkId': linkId, 'body': body});
  }

  @override
  Future<void> revokeConsent(int linkId) async {
    revokeCalls.add(linkId);
  }

  @override
  Future<void> restoreConsent(int linkId) async {
    restoreCalls.add(linkId);
  }

  @override
  Future<List<HcpLink>> getMyLinks({String? status}) =>
      throw UnimplementedError();

  @override
  Future<void> deleteLink(int linkId) => throw UnimplementedError();

  @override
  Future<void> requestLink(Map<String, dynamic> body) =>
      throw UnimplementedError();
}

MyAssignment _assignment({
  required int id,
  required String title,
  required String status,
  DateTime? dueDate,
}) {
  return MyAssignment(
    assignmentId: id,
    surveyId: id,
    surveyTitle: title,
    status: status,
    dueDate: dueDate,
  );
}

HcpLink _link({
  required int id,
  required String status,
  required String requestedBy,
  String? hcpName,
  bool consentRevoked = false,
}) {
  final now = DateTime.parse('2026-01-01T00:00:00.000Z');
  return HcpLink(
    linkId: id,
    hcpId: 10 + id,
    patientId: 100 + id,
    hcpName: hcpName,
    status: status,
    requestedBy: requestedBy,
    requestedAt: now,
    updatedAt: now,
    consentRevoked: consentRevoked,
  );
}

List<Override> _overrides({
  Future<List<MyAssignment>> Function(Ref ref)? assignments,
  Future<List<HcpLink>> Function(Ref ref)? links,
  Future<bool> Function(Ref ref)? consentStatus,
  bool profileComplete = true,
  int unreadMessages = 0,
  _FakeHcpLinkApi? hcpApi,
}) {
  return [
    participantAssignmentsProvider.overrideWith(
      assignments ?? (ref) async => const [],
    ),
    hcpLinksProvider.overrideWith(
      links ?? (ref) async => const [],
    ),
    participantConsentStatusProvider.overrideWith(
      consentStatus ?? (ref) async => true,
    ),
    participantProfileCompleteProvider.overrideWith((ref) => profileComplete),
    messagingUnreadCountProvider.overrideWith((ref) => unreadMessages),
    hcpLinkApiProvider.overrideWith((ref) => hcpApi ?? _FakeHcpLinkApi()),
  ];
}

GoRouter _routerForTasksPage() {
  return GoRouter(
    initialLocation: AppRoutes.participantTasks,
    routes: [
      GoRoute(
        path: AppRoutes.participantTasks,
        builder: (_, __) => const ParticipantTasksPage(),
      ),
      GoRoute(
        path: AppRoutes.completeProfile,
        builder: (_, __) => const Scaffold(body: Text('Complete Profile Page')),
      ),
      GoRoute(
        path: AppRoutes.consent,
        builder: (_, __) => const Scaffold(body: Text('Consent Page')),
      ),
      GoRoute(
        path: AppRoutes.participantSurvey,
        builder: (_, state) => Scaffold(
          body: Text('Survey ${state.pathParameters['surveyId']}'),
        ),
      ),
      GoRoute(
        path: AppRoutes.participantResults,
        builder: (_, __) => const Scaffold(body: Text('Results Page')),
      ),
    ],
  );
}

void main() {
  group('ParticipantTasksPage', () {
    testWidgets('renders pending surveys sorted by due date and progress summary',
        (tester) async {
      final now = DateTime.now();
      final overdue = now.subtract(const Duration(days: 1));
      final dueSoon = now.add(const Duration(hours: 8));
      final later = now.add(const Duration(days: 4));

      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForTasksPage(),
          overrides: _overrides(
            assignments: (ref) async => [
              _assignment(id: 1, title: 'Later survey', status: 'pending', dueDate: later),
              _assignment(id: 2, title: 'Overdue survey', status: 'pending', dueDate: overdue),
              _assignment(id: 3, title: 'Due soon survey', status: 'pending', dueDate: dueSoon),
              _assignment(id: 4, title: 'Completed survey', status: 'completed'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Tasks'), findsOneWidget);
      expect(find.text('Pending Surveys'), findsOneWidget);
      expect(find.text('Your Progress'), findsOneWidget);
      expect(find.text('1 out of 4 tasks completed'), findsOneWidget);
      expect(find.textContaining('Overdue'), findsWidgets);
      expect(find.text('View Results'), findsOneWidget);

      final overdueDy = tester.getTopLeft(find.text('Overdue survey')).dy;
      final dueSoonDy = tester.getTopLeft(find.text('Due soon survey')).dy;
      final laterDy = tester.getTopLeft(find.text('Later survey')).dy;
      expect(overdueDy < dueSoonDy, isTrue);
      expect(dueSoonDy < laterDy, isTrue);
    });

    testWidgets('shows loading state while assignments are unresolved',
      (tester) async {
      final completer = Completer<List<MyAssignment>>();

      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForTasksPage(),
          overrides: _overrides(assignments: (ref) => completer.future),
        ),
      );
      await tester.pump();

      expect(find.text('Loading...'), findsWidgets);
    });

    testWidgets('shows error state when assignments fail', (tester) async {
      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForTasksPage(),
          overrides: _overrides(
            assignments: (ref) async => throw Exception('boom'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Something went wrong'), findsWidgets);
    });

    testWidgets('navigates from profile and consent alerts', (tester) async {
      final router = _routerForTasksPage();

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: _overrides(
            profileComplete: false,
            consentStatus: (ref) async => false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Your profile is incomplete. Please add your name.'),
        findsOneWidget,
      );
      expect(
        find.text('Your consent needs to be renewed. Please review and sign.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Your profile is incomplete. Please add your name.'));
      await tester.pumpAndSettle();
      expect(find.text('Complete Profile Page'), findsOneWidget);

      router.go(AppRoutes.participantTasks);
      await tester.pumpAndSettle();

      await tester.tap(
        find.text('Your consent needs to be renewed. Please review and sign.'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Consent Page'), findsOneWidget);
    });

    testWidgets('navigates to survey and results pages from CTA buttons',
        (tester) async {
      final router = _routerForTasksPage();

      await tester.pumpWidget(
        TestRouterApp(
          router: router,
          overrides: _overrides(
            assignments: (ref) async => [
              _assignment(id: 77, title: 'Survey A', status: 'pending'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Survey'));
      await tester.pumpAndSettle();
      expect(find.text('Survey 77'), findsOneWidget);

      router.go(AppRoutes.participantTasks);
      await tester.pumpAndSettle();

      await tester.tap(find.text('View Results'));
      await tester.pumpAndSettle();
      expect(find.text('Results Page'), findsOneWidget);
    });

    testWidgets('accept/decline HCP request uses respondToLink API',
        (tester) async {
      final fakeApi = _FakeHcpLinkApi();

      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForTasksPage(),
          overrides: _overrides(
            hcpApi: fakeApi,
            links: (ref) async => [
              _link(
                id: 101,
                status: 'pending',
                requestedBy: 'hcp',
                hcpName: 'Dr. Rivera',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Dr. Rivera has requested to track your health data.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Accept').first);
      await tester.pumpAndSettle();

      expect(fakeApi.respondCalls, hasLength(1));
      expect(fakeApi.respondCalls.first['linkId'], 101);
      expect(fakeApi.respondCalls.first['body'], {'action': 'accept'});

      await tester.tap(find.text('Decline').first);
      await tester.pumpAndSettle();

      expect(fakeApi.respondCalls, hasLength(2));
      expect(fakeApi.respondCalls.last['body'], {'action': 'reject'});
    });

    testWidgets('restore and revoke HCP consent invoke API methods',
        (tester) async {
      final fakeApi = _FakeHcpLinkApi();

      await tester.pumpWidget(
        TestRouterApp(
          router: _routerForTasksPage(),
          overrides: _overrides(
            hcpApi: fakeApi,
            links: (ref) async => [
              _link(
                id: 201,
                status: 'active',
                requestedBy: 'hcp',
                hcpName: 'Dr. Active',
                consentRevoked: false,
              ),
              _link(
                id: 202,
                status: 'active',
                requestedBy: 'hcp',
                hcpName: 'Dr. Revoked',
                consentRevoked: true,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Restore HCP Access'));
      await tester.pumpAndSettle();
      expect(fakeApi.restoreCalls, [202]);

      await tester.tap(find.text('Revoke HCP Access').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Revoke HCP Access').last);
      await tester.pumpAndSettle();

      expect(fakeApi.revokeCalls, [201]);
    });
  });
}
