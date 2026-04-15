import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/admin/widgets/admin_view_as_banner.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';

import '../../../test_helpers.dart';

class _AuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  _AuthNotifier(super.state);

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<String?> login(String email, String password) async => null;

  @override
  Future<String?> verifyMfa(String code) async => null;

  @override
  Future<String?> restoreSession() async => null;

  @override
  Future<void> logout() async {}

  @override
  void clearError() {}

  @override
  void clearMfaChallenge() {}

  @override
  void clearMustChangePassword() {}

  @override
  void clearNeedsProfileCompletion() {}

  @override
  void markConsentSigned() {}

  @override
  void reset() {}
}

class _ImpersonationNotifier extends StateNotifier<ImpersonationState>
    implements ImpersonationNotifier {
  _ImpersonationNotifier(super.state);

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<void> fetchSessionInfo() async {}

  @override
  Future<void> startRolePreview(String role) async {
    state = ImpersonationState(
      mode: ViewAsMode.rolePreview,
      previewRole: role.toLowerCase(),
    );
  }

  @override
  Future<String?> startImpersonation(int userId) async => null;

  @override
  Future<bool> endImpersonation() async => true;

  @override
  void clear() {
    state = const ImpersonationState();
  }

  @override
  void clearError() {}

  @override
  void clearImpersonationState() {
    state = const ImpersonationState();
  }
}

Widget _buildBanner({
  required String? viewingAsRole,
  required bool isAdmin,
}) {
  return buildTestWidget(
    const AdminViewAsBanner(),
    overrides: [
      authProvider.overrideWith(
        (ref) => _AuthNotifier(
          AuthState(
            isAuthenticated: isAdmin,
            user: isAdmin
                ? const LoginResponse(
                    expiresAt: '2099-01-01T00:00:00Z',
                    accountId: 1,
                    firstName: 'Admin',
                    lastName: 'User',
                    email: 'admin@example.com',
                    role: 'admin',
                  )
                : null,
          ),
        ),
      ),
      impersonationProvider.overrideWith(
        (ref) => _ImpersonationNotifier(
          ImpersonationState(
            mode: viewingAsRole != null
                ? ViewAsMode.rolePreview
                : ViewAsMode.none,
            previewRole: viewingAsRole,
            currentUser: isAdmin
                ? const SessionUserInfo(
                    accountId: 1,
                    firstName: 'Admin',
                    lastName: 'User',
                    email: 'admin@example.com',
                    role: 'admin',
                    roleId: 4,
                  )
                : null,
          ),
        ),
      ),
    ],
  );
}

void main() {
  group('AdminViewAsBanner', () {
    testWidgets('is hidden when not viewing as another role', (tester) async {
      await tester.pumpWidget(_buildBanner(viewingAsRole: null, isAdmin: true));
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.textContaining('Viewing as'), findsNothing);
    });

    testWidgets('is hidden for non-admin users', (tester) async {
      await tester.pumpWidget(_buildBanner(viewingAsRole: 'participant', isAdmin: false));
      await tester.pumpAndSettle();

      expect(find.textContaining('Viewing as'), findsNothing);
      expect(find.text('Back to Admin'), findsNothing);
    });

    testWidgets('renders localized role name and action for admin', (tester) async {
      await tester.pumpWidget(_buildBanner(viewingAsRole: 'researcher', isAdmin: true));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.text('Viewing as Researcher'), findsOneWidget);
      expect(find.text('Back to Admin'), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.minHeight, kAdminViewAsBannerHeight);
    });
  });
}
