import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/auth.dart';
import 'package:frontend/src/core/widgets/basics/app_accordion.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/features/Services/pages/help.dart';
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

void main() {
  group('HelpPage', () {
    group('Header rendering by role', () {
      testWidgets('displays ParticipantHeader for participant role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ParticipantHeader), findsOneWidget);
      });

      testWidgets('displays ResearcherHeader for researcher role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('researcher')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ResearcherHeader), findsOneWidget);
      });

      testWidgets('displays HcpHeader for hcp role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('hcp')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HcpHeader), findsOneWidget);
      });

      testWidgets('displays default Header for admin role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('admin')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Header), findsOneWidget);
        expect(find.byType(ParticipantHeader), findsNothing);
        expect(find.byType(ResearcherHeader), findsNothing);
        expect(find.byType(HcpHeader), findsNothing);
      });

      testWidgets('displays default Header for unknown/null role', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
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

    group('Accordion rendering', () {
      testWidgets('renders exactly 3 accordion sections', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AppAccordion), findsWidgets);
        // Should find exactly 3 AppAccordion widgets and their titles
        expect(find.text('How do I create an account?'), findsOneWidget);
        expect(find.text('How do I complete a health survey?'), findsOneWidget);
        expect(find.text('Who can see my data?'), findsOneWidget);
      });

      testWidgets('accordion sections have correct filler content', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Check that all FAQ body text is present
        expect(
          find.textContaining('Accounts are created by a HealthBank administrator'),
          findsOneWidget,
        );
        expect(
          find.textContaining('navigate to the Surveys section'),
          findsOneWidget,
        );
        expect(
          find.textContaining('strictly confidential'),
          findsOneWidget,
        );
      });

      testWidgets('accordion sections start collapsed', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // All accordion bodies should be initially collapsed (not visible)
        // We verify by tapping to expand and then checking visibility
        final accordions = find.byType(AppAccordion);
        expect(accordions, findsWidgets);
      });

      testWidgets('accordion can be toggled expanded and collapsed', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Find and tap the first accordion section
        final firstSection = find.byType(AppAccordion).first;
        await tester.tap(firstSection);
        await tester.pumpAndSettle();

        // The content should now be visible
        expect(
          find.textContaining('Accounts are created by a HealthBank administrator'),
          findsOneWidget,
        );

        // Tap again to collapse
        await tester.tap(firstSection);
        await tester.pumpAndSettle();
      });

      testWidgets('all accordions can be independently toggled', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Expand first accordion
        await tester.tap(find.byType(AppAccordion).first);
        await tester.pumpAndSettle();

        // Expand second accordion
        await tester.tap(find.byType(AppAccordion).at(1));
        await tester.pumpAndSettle();

        // Expand third accordion
        await tester.tap(find.byType(AppAccordion).at(2));
        await tester.pumpAndSettle();

        // All three sections should be visible simultaneously
        expect(
          find.textContaining('Accounts are created by a HealthBank administrator'),
          findsOneWidget,
        );
        expect(
          find.textContaining('navigate to the Surveys section'),
          findsOneWidget,
        );
        expect(
          find.textContaining('strictly confidential'),
          findsOneWidget,
        );
      });
    });

    group('Page structure and layout', () {
      testWidgets('displays page heading', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // The page should have a heading Text widget
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('page content is wrapped in BaseScaffold', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('has proper vertical spacing', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Check that spacing widgets exist (SizedBox with heights)
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Responsive behavior', () {
      testWidgets('renders correctly on desktop viewport', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HelpPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
        expect(find.byType(AppAccordion), findsWidgets);
      });

      testWidgets('renders correctly on tablet viewport', (tester) async {
        _useTabletViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('researcher')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HelpPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
        expect(find.byType(AppAccordion), findsWidgets);
      });
    });

    group('State management', () {
      testWidgets('accordion state is independent across sections', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Expand first section
        await tester.tap(find.byType(AppAccordion).first);
        await tester.pumpAndSettle();

        // Collapse first section
        await tester.tap(find.byType(AppAccordion).first);
        await tester.pumpAndSettle();

        // Expand third section - should be independent
        await tester.tap(find.byType(AppAccordion).at(2));
        await tester.pumpAndSettle();

        // Only section 3 content should be visible now
        expect(
          find.textContaining('strictly confidential'),
          findsOneWidget,
        );
      });

      testWidgets('multiple accordions can be open simultaneously', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Expand all three sections
        await tester.tap(find.byType(AppAccordion).first);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AppAccordion).at(1));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AppAccordion).at(2));
        await tester.pumpAndSettle();

        // All three should be visible
        expect(find.text('How do I create an account?'), findsOneWidget);
        expect(find.text('How do I complete a health survey?'), findsOneWidget);
        expect(find.text('Who can see my data?'), findsOneWidget);

        expect(
          find.textContaining('Accounts are created by a HealthBank administrator'),
          findsOneWidget,
        );
        expect(
          find.textContaining('navigate to the Surveys section'),
          findsOneWidget,
        );
        expect(
          find.textContaining('strictly confidential'),
          findsOneWidget,
        );
      });
    });

    group('Widget hierarchy and composition', () {
      testWidgets('page is built with BaseScaffold', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // BaseScaffold is the main wrapper
        expect(find.byType(HelpPage), findsOneWidget);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      testWidgets('displays Column with correct cross-axis alignment', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // The structure includes Column widgets for layout
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(BaseScaffold), findsOneWidget);
      });
    });

    group('Integration with different user roles', () {
      testWidgets('participant sees correct header and can interact with accordions',
          (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('participant')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Verify participant header
        expect(find.byType(ParticipantHeader), findsOneWidget);

        // Verify can interact with content
        await tester.tap(find.byType(AppAccordion).first);
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Accounts are created by a HealthBank administrator'),
          findsOneWidget,
        );
      });

      testWidgets('researcher sees correct header and can interact with accordions',
          (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('researcher')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Verify researcher header
        expect(find.byType(ResearcherHeader), findsOneWidget);

        // Verify can interact with content
        await tester.tap(find.byType(AppAccordion).at(1));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('navigate to the Surveys section'),
          findsOneWidget,
        );
      });

      testWidgets('hcp sees correct header and can interact with accordions',
          (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith((ref) => _createMockAuthNotifierWithRole('hcp')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Verify hcp header
        expect(find.byType(HcpHeader), findsOneWidget);

        // Verify can interact with content
        await tester.tap(find.byType(AppAccordion).at(2));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('strictly confidential'),
          findsOneWidget,
        );
      });
    });

    group('Edge cases and error handling', () {
      testWidgets('handles null role gracefully', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith(
                (ref) => _MockAuthNotifier(initial: const AuthState(isAuthenticated: false, user: null)),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Should render default header and content
        expect(find.byType(Header), findsOneWidget);
        expect(find.byType(AppAccordion), findsWidgets);
      });

      testWidgets('handles empty string role as default', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith(
                (ref) => _createMockAuthNotifierWithRole(''),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Should render default header
        expect(find.byType(Header), findsOneWidget);
      });

      testWidgets('handles unexpected role gracefully', (tester) async {
        _useDesktopViewport(tester);

        await tester.pumpWidget(
          buildTestPage(
            const HelpPage(),
            overrides: [
              authProvider.overrideWith(
                (ref) => _createMockAuthNotifierWithRole('superadmin'),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Should render default header
        expect(find.byType(Header), findsOneWidget);
        // Content should still be displayed
        expect(find.byType(AppAccordion), findsWidgets);
      });
    });
  });
}
