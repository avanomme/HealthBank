import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';
import 'package:frontend/src/features/hcp_clients/widgets/hcp_scaffold.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/messaging/widgets/messaging_scaffold.dart';
import 'package:frontend/src/features/participant/widgets/participant_scaffold.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<void> logout() async {
    state = const AuthState();
  }

  @override
  void clearError() {
    state = state.clearError();
  }

  @override
  void clearMfaChallenge() {
    state = state.copyWith(mfaRequired: false, mfaChallengeToken: null, error: null);
  }

  @override
  void clearMustChangePassword() {
    state = state.copyWith(mustChangePassword: false);
  }

  @override
  void clearNeedsProfileCompletion() {
    state = state.copyWith(needsProfileCompletion: false);
  }

  @override
  void markConsentSigned() {
    state = state.copyWith(hasSignedConsent: true);
  }

  @override
  void reset() {
    state = const AuthState();
  }
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
  void clearImpersonationState() {
    state = const ImpersonationState();
  }

  @override
  void clearError() {
    state = state.copyWith(error: null);
  }
}

LoginResponse _user(String role) => LoginResponse(
      expiresAt: '2099-01-01T00:00:00Z',
      accountId: 1,
      firstName: 'Ada',
      lastName: 'Lovelace',
      email: 'ada@example.com',
      role: role,
    );

SessionUserInfo _sessionUser(String role, int roleId) => SessionUserInfo(
      accountId: 2,
      firstName: 'Session',
      lastName: 'User',
      email: 'session@example.com',
      role: role,
      roleId: roleId,
    );

final _messagingOverride = incomingFriendRequestsProvider.overrideWith(
  (ref) async => const <FriendRequest>[],
);

Widget _buildScaffold({
  required String authRole,
  String? adminViewAsRole,
  SessionUserInfo? impersonatedUser,
}) {
  // Build the correct ImpersonationState based on the parameters:
  // - adminViewAsRole set -> rolePreview mode
  // - impersonatedUser set -> fullUser mode
  // - neither -> none
  final ImpersonationState impState;
  if (adminViewAsRole != null) {
    impState = ImpersonationState(
      mode: ViewAsMode.rolePreview,
      previewRole: adminViewAsRole.toLowerCase(),
    );
  } else if (impersonatedUser != null) {
    impState = ImpersonationState(
      mode: ViewAsMode.fullUser,
      currentUser: impersonatedUser,
    );
  } else {
    impState = const ImpersonationState();
  }

  return buildTestPage(
    const MessagingScaffold(
      userName: 'Ada',
      child: Text('Inbox'),
    ),
    overrides: [
      _messagingOverride,
      authProvider.overrideWith(
        (ref) => _AuthNotifier(
          AuthState(
            isAuthenticated: true,
            user: _user(authRole),
          ),
        ),
      ),
      impersonationProvider.overrideWith(
        (ref) => _ImpersonationNotifier(impState),
      ),
    ],
  );
}

void main() {
  group('MessagingScaffold', () {
    testWidgets('uses participant scaffold for participant role', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(_buildScaffold(authRole: 'participant'));
      await tester.pumpAndSettle();

      expect(find.byType(ParticipantScaffold), findsOneWidget);
      expect(find.text('Inbox'), findsOneWidget);
    });

    testWidgets('uses researcher scaffold for researcher role', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(_buildScaffold(authRole: 'researcher'));
      await tester.pumpAndSettle();

      expect(find.byType(ResearcherScaffold), findsOneWidget);
    });

    testWidgets('uses hcp scaffold for hcp role', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(_buildScaffold(authRole: 'hcp'));
      await tester.pumpAndSettle();

      expect(find.byType(HcpScaffold), findsOneWidget);
    });

    testWidgets('admin view-as role takes precedence over auth role', (tester) async {
      SharedPreferences.setMockInitialValues({
        'admin_view_as_role': 'researcher',
      });
      await tester.pumpWidget(
        _buildScaffold(
          authRole: 'participant',
          adminViewAsRole: 'researcher',
          impersonatedUser: _sessionUser('hcp', 3),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ResearcherScaffold), findsOneWidget);
      expect(find.byType(HcpScaffold), findsNothing);
    });

    testWidgets('backend impersonation role overrides auth role when no admin view-as',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(
        _buildScaffold(
          authRole: 'participant',
          impersonatedUser: _sessionUser('hcp', 3),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HcpScaffold), findsOneWidget);
      expect(find.byType(ParticipantScaffold), findsNothing);
    });

    testWidgets('admin role falls back to participant scaffold', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(_buildScaffold(authRole: 'admin'));
      await tester.pumpAndSettle();

      expect(find.byType(ParticipantScaffold), findsOneWidget);
    });
  });
}
