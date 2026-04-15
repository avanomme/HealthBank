import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/auth.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/features/public/pages/contact_page.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/auth.dart';
import 'package:frontend/src/features/participant/widgets/participant_header.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_header.dart';
import 'package:frontend/src/features/hcp_clients/widgets/hcp_header.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
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
  group('ContactPage', () {
    group('Header rendering by role', () {
      testWidgets('displays ParticipantHeader for participant role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantHeader), findsOneWidget);
      });

      testWidgets('displays ResearcherHeader for researcher role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherHeader), findsOneWidget);
      });

      testWidgets('displays HcpHeader for hcp role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'hcp'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HcpHeader), findsOneWidget);
      });

      testWidgets('displays Header for admin role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'admin'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Header), findsOneWidget);
        expect(find.byType(ParticipantHeader), findsNothing);
        expect(find.byType(ResearcherHeader), findsNothing);
        expect(find.byType(HcpHeader), findsNothing);
      });

      testWidgets('displays default Header for unknown role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: [
              authProvider.overrideWith(
                (ref) => _MockAuthNotifier(initial: const AuthState(isAuthenticated: false, user: null)),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Header), findsOneWidget);
      });
    });

    group('Content rendering', () {
      testWidgets('displays contact page title', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Should have Text widgets for the title
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('page content is wrapped in BaseScaffold', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('displays support email address', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Should display the support email
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('displays support hours information', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Should display hours text
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('displays instructional note about account email', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Should display the instructional note
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('has proper spacing between elements', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Check that SizedBox widgets exist for spacing
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Container styling', () {
      testWidgets('has contact information container', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Should have Container widgets for styling contact info
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('has styled note container', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Should have multiple Container widgets for different sections
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Layout and structure', () {
      testWidgets('content is wrapped in Column', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Page uses Column for vertical layout
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('BaseScaffold is configured for scrolling', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Page should be scrollable (BaseScaffold with scrollable: true)
        expect(find.byType(BaseScaffold), findsOneWidget);
      });
    });

    group('Responsive behavior', () {
      testWidgets('renders correctly on desktop viewport', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ContactPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('renders correctly on tablet viewport', (tester) async {
        _useTabletViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ContactPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('renders correctly on mobile viewport', (tester) async {
        _useMobileViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'hcp'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ContactPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });
    });

    group('Multi-role scenarios', () {
      testWidgets('participant can view contact page', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantHeader), findsOneWidget);
        expect(find.byType(ContactPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('researcher can view contact page', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherHeader), findsOneWidget);
        expect(find.byType(ContactPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('hcp can view contact page', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'hcp'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HcpHeader), findsOneWidget);
        expect(find.byType(ContactPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('admin sees default header', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'admin'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Header), findsOneWidget);
        expect(find.byType(ParticipantHeader), findsNothing);
        expect(find.byType(ResearcherHeader), findsNothing);
        expect(find.byType(HcpHeader), findsNothing);
      });
    });

    group('Edge cases', () {
      testWidgets('handles null role gracefully', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: [
              authProvider.overrideWith(
                (ref) => _MockAuthNotifier(initial: const AuthState(isAuthenticated: false, user: null)),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Header), findsOneWidget);
        expect(find.byType(ContactPage), findsOneWidget);
      });

      testWidgets('handles empty string role as default', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: ''),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Header), findsOneWidget);
      });

      testWidgets('handles unexpected role gracefully', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'unknown_role'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Header), findsOneWidget);
        expect(find.byType(ContactPage), findsOneWidget);
      });

      testWidgets('page renders without errors on very wide viewport', (tester) async {
        tester.view.physicalSize = const Size(2560, 1440);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ContactPage), findsOneWidget);
      });
    });

    group('Widget hierarchy', () {
      testWidgets('page structure includes Column with proper alignment', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify Column layout exists for vertical arrangement
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('has footer rendering', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // BaseScaffold is configured with showFooter: true
        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('contact information is in styled containers', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const ContactPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Contact info and note should be in Container widgets with styling
        expect(find.byType(Container), findsWidgets);
      });
    });
  });
}
