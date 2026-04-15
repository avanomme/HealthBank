import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/hcp_clients/pages/hcp_client_list_page.dart';
import 'package:frontend/src/features/hcp_clients/state/hcp_providers.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';

import '../../test_helpers.dart';

class _FakeHcpLinkApi implements HcpLinkApi {
  int? deletedLinkId;
  int deleteCalls = 0;
  Exception? deleteError;
  Map<String, dynamic>? requestedBody;
  Exception? requestError;

  @override
  Future<void> deleteLink(int linkId) async {
    deleteCalls += 1;
    if (deleteError != null) {
      throw deleteError!;
    }
    deletedLinkId = linkId;
  }

  @override
  Future<List<HcpLink>> getMyLinks({String? status}) async => const [];

  @override
  Future<void> requestLink(Map<String, dynamic> body) async {
    requestedBody = body;
    if (requestError != null) {
      throw requestError!;
    }
  }

  @override
  Future<void> respondToLink(int linkId, Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  @override
  Future<void> restoreConsent(int linkId) {
    throw UnimplementedError();
  }

  @override
  Future<void> revokeConsent(int linkId) {
    throw UnimplementedError();
  }
}

final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

final _sessionOverride = participantSessionProvider.overrideWith(
  (ref) async => const SessionMeResponse(
    user: SessionUserInfo(
      accountId: 7,
      email: 'hcp@example.com',
      role: 'hcp',
      roleId: 3,
      firstName: 'Hana',
      lastName: 'Care',
    ),
    isImpersonating: false,
    sessionExpiresAt: '2099-01-01T00:00:00Z',
  ),
);

HcpLink _link({
  required int linkId,
  required int patientId,
  required String status,
  required String requestedBy,
  bool consentRevoked = false,
  String? patientName,
}) {
  final now = DateTime.parse('2026-01-01T00:00:00.000Z');
  return HcpLink(
    linkId: linkId,
    hcpId: 10,
    patientId: patientId,
    patientName: patientName,
    status: status,
    requestedBy: requestedBy,
    requestedAt: now,
    updatedAt: now,
    consentRevoked: consentRevoked,
  );
}

Widget _buildPage({required List<Override> overrides}) {
  return buildTestPage(
    const HcpClientListPage(),
    overrides: [
      ..._messagingOverrides,
      _sessionOverride,
      ...overrides,
    ],
  );
}

void main() {
  group('HcpClientListPage coverage', () {
    testWidgets('shows loading indicator while links load', (tester) async {
      final completer = Completer<List<HcpLink>>();

      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith((ref) => completer.future),
      ]));
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows generic error when links provider fails',
        (tester) async {
      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith(
          (ref) => Future<List<HcpLink>>.error(Exception('boom')),
        ),
      ]));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong. Please try again.'), findsOneWidget);
    });

    testWidgets('shows empty active and pending states', (tester) async {
      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith((ref) async => const []),
      ]));
      await tester.pumpAndSettle();

      expect(find.text('Linked Patients'), findsOneWidget);
      expect(find.text('No linked patients yet.'), findsOneWidget);
      expect(find.text('Pending Requests'), findsOneWidget);
      expect(find.text('No pending requests.'), findsOneWidget);
    });

    testWidgets('categorizes active, revoked, and pending links',
        (tester) async {
      final links = [
        _link(
          linkId: 1,
          patientId: 101,
          patientName: 'Active Person',
          status: 'active',
          requestedBy: 'hcp',
        ),
        _link(
          linkId: 2,
          patientId: 102,
          patientName: 'Revoked Person',
          status: 'active',
          requestedBy: 'hcp',
          consentRevoked: true,
        ),
        _link(
          linkId: 3,
          patientId: 103,
          patientName: 'Pending Person',
          status: 'pending',
          requestedBy: 'hcp',
        ),
      ];

      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith((ref) async => links),
        hcpPatientSurveysProvider(101).overrideWith(
          (ref) async => const [
            {
              'title': 'Intake Survey',
              'completed_at': '2026-01-02T00:00:00.000Z',
            },
          ],
        ),
      ]));
      await tester.pumpAndSettle();

      expect(find.text('Active Person'), findsOneWidget);
      expect(find.text('Revoked Person'), findsOneWidget);
      expect(find.text('Pending Person'), findsOneWidget);
      expect(find.text('Consent Revoked'), findsAtLeast(1));
      expect(find.text('Pending'), findsOneWidget);

      await tester.tap(find.text('Active Person'));
      await tester.pumpAndSettle();

      expect(find.text('Completed Surveys'), findsOneWidget);
      expect(find.text('Intake Survey'), findsOneWidget);
    });

    testWidgets('expanded patient shows no surveys message', (tester) async {
      final links = [
        _link(
          linkId: 1,
          patientId: 201,
          patientName: 'Empty Surveys',
          status: 'active',
          requestedBy: 'hcp',
        ),
      ];

      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith((ref) async => links),
        hcpPatientSurveysProvider(201).overrideWith((ref) async => const []),
      ]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Empty Surveys'));
      await tester.pumpAndSettle();

      expect(find.text('No completed surveys.'), findsOneWidget);
    });

    testWidgets('expanded patient shows survey fetch error', (tester) async {
      final links = [
        _link(
          linkId: 1,
          patientId: 301,
          patientName: 'Error Surveys',
          status: 'active',
          requestedBy: 'hcp',
        ),
      ];

      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith((ref) async => links),
        hcpPatientSurveysProvider(301).overrideWith(
          (ref) => Future<List<Map<String, dynamic>>>.error(Exception('fail')),
        ),
      ]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Error Surveys'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong. Please try again.'), findsOneWidget);
    });

    testWidgets('request dialog opens and can be cancelled', (tester) async {
      final fakeApi = _FakeHcpLinkApi();

      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith((ref) async => const []),
        hcpLinkApiProvider.overrideWith((ref) => fakeApi),
      ]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request Patient Link').first);
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);
      expect(fakeApi.requestedBody, isNull);
    });

    testWidgets('request dialog ignores empty email input',
        (tester) async {
      final fakeApi = _FakeHcpLinkApi();

      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith((ref) async => const []),
        hcpLinkApiProvider.overrideWith((ref) => fakeApi),
      ]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request Patient Link').first);
      await tester.pumpAndSettle();

      // Leave field empty and tap Confirm — should not submit
      await tester.tap(find.text('Confirm'));
      await tester.pump();

      expect(fakeApi.requestedBody, isNull);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('remove link confirmation calls delete API', (tester) async {
      final fakeApi = _FakeHcpLinkApi();

      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith(
          (ref) async => [
            _link(
              linkId: 10,
              patientId: 555,
              patientName: 'Removable Patient',
              status: 'active',
              requestedBy: 'hcp',
            ),
          ],
        ),
        hcpLinkApiProvider.overrideWith((ref) => fakeApi),
      ]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove').last);
      await tester.pumpAndSettle();

      expect(fakeApi.deleteCalls, 1);
      expect(fakeApi.deletedLinkId, 10);
    });

    testWidgets('remove link delete error path does not crash',
        (tester) async {
      final fakeApi = _FakeHcpLinkApi()
        ..deleteError = Exception('delete failed');

      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith(
          (ref) async => [
            _link(
              linkId: 11,
              patientId: 556,
              patientName: 'Delete Error Patient',
              status: 'active',
              requestedBy: 'hcp',
            ),
          ],
        ),
        hcpLinkApiProvider.overrideWith((ref) => fakeApi),
      ]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove').last);
      await tester.pumpAndSettle();

      expect(fakeApi.deleteCalls, 1);
      expect(fakeApi.deletedLinkId, isNull);
      expect(find.text('Delete Error Patient'), findsOneWidget);
    });

    testWidgets('survey row supports survey_title and invalid date fallback',
        (tester) async {
      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith(
          (ref) async => [
            _link(
              linkId: 12,
              patientId: 600,
              patientName: 'Fallback Survey Fields',
              status: 'active',
              requestedBy: 'hcp',
            ),
          ],
        ),
        hcpPatientSurveysProvider(600).overrideWith(
          (ref) async => const [
            {
              'survey_title': 'Fallback Title Field',
              'completed_at': 'not-a-real-date',
            },
          ],
        ),
      ]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fallback Survey Fields'));
      await tester.pumpAndSettle();

      expect(find.text('Fallback Title Field'), findsOneWidget);
      expect(find.text('not-a-real-date'), findsOneWidget);
    });

    testWidgets('pending section excludes non-hcp initiated requests',
        (tester) async {
      await tester.pumpWidget(_buildPage(overrides: [
        hcpLinksProvider.overrideWith(
          (ref) async => [
            _link(
              linkId: 13,
              patientId: 700,
              patientName: 'Participant Initiated Pending',
              status: 'pending',
              requestedBy: 'participant',
            ),
          ],
        ),
      ]));
      await tester.pumpAndSettle();

      expect(find.text('Participant Initiated Pending'), findsNothing);
      expect(find.text('No pending requests.'), findsOneWidget);
    });
  });
}
