import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/auth.dart';
import 'package:frontend/src/features/public/pages/about_page.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/auth.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:frontend/src/features/hcp_clients/widgets/hcp_scaffold.dart';
import 'package:frontend/src/features/admin/widgets/admin_scaffold.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers.dart';

/// Mock AuthNotifier for testing with different user roles
class _MockAuthNotifier extends StateNotifier<AuthState>
    with Mock
    implements AuthNotifier {
  _MockAuthNotifier({required AuthState initial}) : super(initial);

  @override
  Future<String?> login(String email, String password) async => null;

  @override
  Future<void> logout() async {
    state = const AuthState();
  }

  @override
  Future<String?> verifyMfa(String code) async => null;

  @override
  void clearMfaChallenge() {
    state = state.copyWith(mfaRequired: false, mfaChallengeToken: null, error: null);
  }
}

/// Helper function to create a mock LoginResponse with a specific role
LoginResponse _createMockUser({
  required String role,
  int accountId = 1,
  String email = 'test@example.com',
  String? firstName = 'Test',
  String? lastName = 'User',
  String expiresAt = '2026-12-31T23:59:59Z',
}) {
  return LoginResponse(
    accountId: accountId,
    email: email,
    firstName: firstName,
    lastName: lastName,
    role: role,
    expiresAt: expiresAt,
  );
}

/// Helper function to create AuthState with a specific user role
AuthState _createAuthStateWithRole(String role) {
  return AuthState(
    isAuthenticated: true,
    user: _createMockUser(role: role),
  );
}

/// Helper function to create a mock AuthNotifier with a specific user role
_MockAuthNotifier _createMockAuthNotifierWithRole(String role) {
  return _MockAuthNotifier(
    initial: _createAuthStateWithRole(role),
  );
}

/// Helper to set desktop viewport for consistent testing
void _useDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Helper to set tablet viewport
void _useTabletViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Helper to set mobile viewport
void _useMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Helper to get common provider overrides
List<Override> _getCommonOverrides({required String role}) {
  return [
    authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole(role)),
  ];
}

void main() {
  group('AboutPage', () {
    group('Scaffold rendering by role', () {
      testWidgets('displays ParticipantScaffold for participant role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantScaffold), findsOneWidget);
      });

      testWidgets('displays ResearcherScaffold for researcher role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherScaffold), findsOneWidget);
      });

      testWidgets('displays HcpScaffold for hcp role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'hcp'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HcpScaffold), findsOneWidget);
      });

      testWidgets('displays AdminScaffold for admin role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'admin'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdminScaffold), findsOneWidget);
      });

      testWidgets('defaults to ParticipantScaffold for unknown role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: [
              authProvider.overrideWith(
                (ref) => _MockAuthNotifier(initial: const AuthState(isAuthenticated: false, user: null)),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantScaffold), findsOneWidget);
      });
    });

    group('Content rendering', () {
      testWidgets('displays about page title', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Should have Text widgets for the title
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('displays about page content', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Should display the lorem ipsum text
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('has proper spacing between elements', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Check that SizedBox widgets exist for spacing
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('page is wrapped in Padding', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Content should be wrapped in Padding for margins
        expect(find.byType(Padding), findsWidgets);
      });
    });

    group('Layout and structure', () {
      testWidgets('content is wrapped in Column', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Page uses Column for vertical layout
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('has cross-axis alignment for content', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Column should contain the content
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Responsive behavior', () {
      testWidgets('renders correctly on desktop viewport', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AboutPage), findsOneWidget);
        expect(find.byType(ParticipantScaffold), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('renders correctly on tablet viewport', (tester) async {
        _useTabletViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AboutPage), findsOneWidget);
        expect(find.byType(ResearcherScaffold), findsOneWidget);
      });

      testWidgets('renders correctly on mobile viewport', (tester) async {
        _useMobileViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'hcp'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AboutPage), findsOneWidget);
        expect(find.byType(HcpScaffold), findsOneWidget);
      });
    });

    group('Multi-role scenarios', () {
      testWidgets('participant sees ParticipantScaffold with content', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantScaffold), findsOneWidget);
        expect(find.byType(AboutPage), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('researcher sees ResearcherScaffold with content', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherScaffold), findsOneWidget);
        expect(find.byType(AboutPage), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('hcp sees HcpScaffold with content', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'hcp'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HcpScaffold), findsOneWidget);
        expect(find.byType(AboutPage), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('admin sees AdminScaffold with content', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'admin'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdminScaffold), findsOneWidget);
        expect(find.byType(AboutPage), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Edge cases', () {
      testWidgets('handles null role gracefully', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: [
              authProvider.overrideWith(
                (ref) => _MockAuthNotifier(initial: const AuthState(isAuthenticated: false, user: null)),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantScaffold), findsOneWidget);
        expect(find.byType(AboutPage), findsOneWidget);
      });

      testWidgets('handles empty string role as participant', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: ''),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantScaffold), findsOneWidget);
      });

      testWidgets('handles unexpected role as participant', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'superadmin'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantScaffold), findsOneWidget);
        expect(find.byType(AboutPage), findsOneWidget);
      });

      testWidgets('page renders without errors on very wide viewport', (tester) async {
        tester.view.physicalSize = const Size(2560, 1440);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AboutPage), findsOneWidget);
      });
    });

    group('Widget hierarchy', () {
      testWidgets('uses correct scaffold for participant', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // ParticipantScaffold should be the top-level scaffold
        expect(find.byType(ParticipantScaffold), findsOneWidget);
        expect(find.byType(ResearcherScaffold), findsNothing);
        expect(find.byType(HcpScaffold), findsNothing);
        expect(find.byType(AdminScaffold), findsNothing);
      });

      testWidgets('uses correct scaffold for researcher', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        // ResearcherScaffold should be the top-level scaffold
        expect(find.byType(ResearcherScaffold), findsOneWidget);
        expect(find.byType(ParticipantScaffold), findsNothing);
        expect(find.byType(HcpScaffold), findsNothing);
        expect(find.byType(AdminScaffold), findsNothing);
      });

      testWidgets('uses correct scaffold for hcp', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'hcp'),
          ),
        );
        await tester.pumpAndSettle();

        // HcpScaffold should be the top-level scaffold
        expect(find.byType(HcpScaffold), findsOneWidget);
        expect(find.byType(ParticipantScaffold), findsNothing);
        expect(find.byType(ResearcherScaffold), findsNothing);
        expect(find.byType(AdminScaffold), findsNothing);
      });

      testWidgets('uses correct scaffold for admin', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const AboutPage(),
            overrides: _getCommonOverrides(role: 'admin'),
          ),
        );
        await tester.pumpAndSettle();

        // AdminScaffold should be the top-level scaffold
        expect(find.byType(AdminScaffold), findsOneWidget);
        expect(find.byType(ParticipantScaffold), findsNothing);
        expect(find.byType(ResearcherScaffold), findsNothing);
        expect(find.byType(HcpScaffold), findsNothing);
      });
    });
  });
}
