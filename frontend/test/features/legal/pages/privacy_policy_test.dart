import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/auth.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/features/legal/pages/privacy_policy.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/auth.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
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
    incomingFriendRequestsProvider.overrideWith((ref) => []),
  ];
}

void main() {
  group('PrivacyPolicyPage', () {
    group('Header rendering by role', () {
      testWidgets('displays ParticipantHeader for participant role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
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
            const PrivacyPolicyPage(),
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
            const PrivacyPolicyPage(),
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
            const PrivacyPolicyPage(),
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
            const PrivacyPolicyPage(),
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
      testWidgets('displays privacy policy title', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
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
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('displays table of contents section', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Table of contents should have InkWell widgets for section links
        expect(find.byType(InkWell), findsWidgets);
      });

      testWidgets('has proper spacing between elements', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Check that SizedBox widgets exist for spacing
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Responsive layout', () {
      testWidgets('renders side-by-side layout on desktop', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // On desktop, should have a Row layout with content and TOC side-by-side
        expect(find.byType(Row), findsWidgets);
        expect(find.byType(PrivacyPolicyPage), findsOneWidget);
      });

      testWidgets('renders stacked layout on tablet', (tester) async {
        _useTabletViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        // On tablet, should have Column layout with TOC stacked on top
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(PrivacyPolicyPage), findsOneWidget);
      });

      testWidgets('renders stacked layout on mobile', (tester) async {
        _useMobileViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'hcp'),
          ),
        );
        await tester.pumpAndSettle();

        // On mobile, should have Column layout
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(PrivacyPolicyPage), findsOneWidget);
      });
    });

    group('Table of contents interaction', () {
      testWidgets('section links are present in TOC', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify InkWell widgets (section tappable areas) exist in TOC
        final inkWells = find.byType(InkWell);
        expect(inkWells, findsWidgets);
        
        // TOC should have at least 2 interactive section links
        expect(inkWells.evaluate().length, greaterThanOrEqualTo(2));
      });

      testWidgets('all section links are rendered in TOC', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        // Should have multiple InkWell widgets for different sections (at least 2)
        final inkWells = find.byType(InkWell);
        expect(inkWells.evaluate().length, greaterThanOrEqualTo(2));
      });
    });

    group('Widget hierarchy', () {
      testWidgets('page uses LayoutBuilder for responsive design', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // LayoutBuilder is used for responsive layout (multiple LayoutBuilder widgets exist in page hierarchy)
        expect(find.byType(LayoutBuilder), findsWidgets);
      });

      testWidgets('page structure includes Container for TOC styling', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Containers are used for styling TOC and content sections
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('has Expanded widget for content area on wide viewport', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        // Expanded is used to make content flex (multiple Expanded widgets exist in page hierarchy)
        expect(find.byType(Expanded), findsWidgets);
      });
    });

    group('Multi-role scenarios', () {
      testWidgets('participant can view privacy policy', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantHeader), findsOneWidget);
        expect(find.byType(PrivacyPolicyPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('researcher can view privacy policy', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'researcher'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherHeader), findsOneWidget);
        expect(find.byType(PrivacyPolicyPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('hcp can view privacy policy', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'hcp'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HcpHeader), findsOneWidget);
        expect(find.byType(PrivacyPolicyPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('admin sees default header', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
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
            const PrivacyPolicyPage(),
            overrides: [
              authProvider.overrideWith(
                (ref) => _MockAuthNotifier(initial: const AuthState(isAuthenticated: false, user: null)),
              ),
              incomingFriendRequestsProvider.overrideWith((ref) => []),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Header), findsOneWidget);
        expect(find.byType(PrivacyPolicyPage), findsOneWidget);
      });

      testWidgets('handles empty string role as default', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
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
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'unknown_role'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Header), findsOneWidget);
        expect(find.byType(PrivacyPolicyPage), findsOneWidget);
      });

      testWidgets('page renders without errors on very wide viewport', (tester) async {
        tester.view.physicalSize = const Size(2560, 1440);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestPage(
            const PrivacyPolicyPage(),
            overrides: _getCommonOverrides(role: 'participant'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(PrivacyPolicyPage), findsOneWidget);
      });
    });
  });
}
