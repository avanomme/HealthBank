// Created with the Assistance of Claude Code
// frontend/test/features/hcp_clients/hcp_pages_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/hcp_link.dart';
import 'package:frontend/src/core/api/models/impersonation.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/hcp_clients/hcp_clients.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';

import '../../test_helpers.dart';

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

final _linksOverride = hcpLinksProvider.overrideWith(
  (ref) async => <HcpLink>[],
);

final _patientsOverride = hcpPatientsProvider.overrideWith(
  (ref) async => <Map<String, dynamic>>[],
);

List<Override> get _pageOverrides => [
      ..._messagingOverrides,
      _sessionOverride,
      _linksOverride,
      _patientsOverride,
    ];

void main() {
  group('HcpDashboardPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpDashboardPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(HcpDashboardPage), findsOneWidget);
      });

      testWidgets('renders HcpScaffold', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpDashboardPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(HcpScaffold), findsOneWidget);
      });

      testWidgets('shows current route as hcp dashboard', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpDashboardPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        final scaffold = tester.widget<HcpScaffold>(
          find.byType(HcpScaffold),
        );
        expect(scaffold.currentRoute, '/hcp/dashboard');
      });

      testWidgets('displays placeholder content', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpDashboardPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        expect(find.text('Welcome, Hana'), findsOneWidget);
        expect(find.text('HCP Dashboard'), findsOneWidget);
      });
    });
  });

  group('HcpClientListPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpClientListPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(HcpClientListPage), findsOneWidget);
      });

      testWidgets('renders HcpScaffold', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpClientListPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(HcpScaffold), findsOneWidget);
      });

      testWidgets('shows current route as hcp clients', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpClientListPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        final scaffold = tester.widget<HcpScaffold>(
          find.byType(HcpScaffold),
        );
        expect(scaffold.currentRoute, '/hcp/clients');
      });

      testWidgets('displays placeholder content', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpClientListPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        expect(find.text('My Patients'), findsOneWidget);
        expect(find.text('Request Patient Link'), findsOneWidget);
      });
    });
  });

  group('HcpReportsPage', () {
    group('Rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpReportsPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(HcpReportsPage), findsOneWidget);
      });

      testWidgets('renders HcpScaffold', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpReportsPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(HcpScaffold), findsOneWidget);
      });

      testWidgets('shows current route as hcp reports', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpReportsPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        final scaffold = tester.widget<HcpScaffold>(
          find.byType(HcpScaffold),
        );
        expect(scaffold.currentRoute, '/hcp/reports');
      });

      testWidgets('displays placeholder content', (tester) async {
        await tester.pumpWidget(buildTestPage(
          const HcpReportsPage(),
          overrides: _pageOverrides,
        ));
        await tester.pumpAndSettle();

        expect(find.text('Patient Reports'), findsOneWidget);
      });
    });
  });

  group('HcpScaffold', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(buildTestPage(
        const HcpScaffold(
          currentRoute: '/hcp/dashboard',
          child: Text('HCP Content'),
        ),
        overrides: _pageOverrides,
      ));
      await tester.pumpAndSettle();

      expect(find.text('HCP Content'), findsOneWidget);
    });

    testWidgets('renders with dashboard route', (tester) async {
      await tester.pumpWidget(buildTestPage(
        const HcpScaffold(
          currentRoute: '/hcp/dashboard',
          child: SizedBox(),
        ),
        overrides: _pageOverrides,
      ));
      await tester.pumpAndSettle();

      final scaffold = tester.widget<HcpScaffold>(
        find.byType(HcpScaffold),
      );
      expect(scaffold.currentRoute, '/hcp/dashboard');
    });

    testWidgets('renders with clients route', (tester) async {
      await tester.pumpWidget(buildTestPage(
        const HcpScaffold(
          currentRoute: '/hcp/clients',
          child: SizedBox(),
        ),
        overrides: _pageOverrides,
      ));
      await tester.pumpAndSettle();

      final scaffold = tester.widget<HcpScaffold>(
        find.byType(HcpScaffold),
      );
      expect(scaffold.currentRoute, '/hcp/clients');
    });

    testWidgets('renders with reports route', (tester) async {
      await tester.pumpWidget(buildTestPage(
        const HcpScaffold(
          currentRoute: '/hcp/reports',
          child: SizedBox(),
        ),
        overrides: _pageOverrides,
      ));
      await tester.pumpAndSettle();

      final scaffold = tester.widget<HcpScaffold>(
        find.byType(HcpScaffold),
      );
      expect(scaffold.currentRoute, '/hcp/reports');
    });
  });
}
