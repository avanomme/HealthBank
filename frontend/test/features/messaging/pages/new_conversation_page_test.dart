import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';
import 'package:frontend/src/features/hcp_clients/state/hcp_providers.dart';
import 'package:frontend/src/features/messaging/pages/new_conversation_page.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
import 'package:go_router/go_router.dart';

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

class _FakeMessagingApi implements MessagingApi {
  Map<String, dynamic>? lastCreateConversationBody;
  Object? createConversationError;

  @override
  Future<ConversationCreated> createConversation(Map<String, dynamic> body) async {
    if (createConversationError != null) {
      throw createConversationError!;
    }
    lastCreateConversationBody = body;
    return const ConversationCreated(convId: 77);
  }

  @override
  Future<List<Conversation>> getConversations() async => const [];

  @override
  Future<List<Message>> getMessages(int convId) async => const [];

  @override
  Future<List<FriendRequest>> getIncomingFriendRequests() async => const [];

  @override
  Future<List<ResearcherResult>> getFriends() async => const [];

  @override
  Future<MessageCreated> sendMessage(int convId, Map<String, dynamic> body) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendFriendRequest(Map<String, dynamic> body) async {
    throw UnimplementedError();
  }

  @override
  Future<void> respondToFriendRequest(int requestId, Map<String, dynamic> body) async {
    throw UnimplementedError();
  }

  @override
  Future<List<ResearcherResult>> searchResearchers(String query) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMessage(int convId, int messageId) async {}

  @override
  Future<void> deleteContact(int contactId) async {}

  @override
  Future<List<ResearcherResult>> listResearchers({String? query}) async => const [];

  @override
  Future<void> sendDirectFriendRequest(Map<String, dynamic> body) async {}
}

LoginResponse _user(String role) => LoginResponse(
      expiresAt: '2099-01-01T00:00:00Z',
      accountId: 1,
      firstName: 'Ada',
      lastName: 'Lovelace',
      email: 'ada@example.com',
      role: role,
    );

SessionMeResponse _session(String role, int roleId) => SessionMeResponse(
      user: SessionUserInfo(
        accountId: 1,
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        role: role,
        roleId: roleId,
      ),
      isImpersonating: false,
      sessionExpiresAt: '2099-01-01T00:00:00Z',
    );

HcpLink _link({
  required int linkId,
  required int hcpId,
  required String status,
  String? hcpName,
}) {
  final now = DateTime.parse('2026-03-16T10:00:00Z');
  return HcpLink(
    linkId: linkId,
    hcpId: hcpId,
    patientId: 1,
    hcpName: hcpName,
    status: status,
    requestedBy: 'participant',
    requestedAt: now,
    updatedAt: now,
  );
}

ResearcherResult _friend({required int id, required String name}) {
  return ResearcherResult(
    accountId: id,
    displayName: name,
    roleName: 'participant',
    email: '${name.toLowerCase()}@example.com',
  );
}

DioException _dioStatusError(int statusCode) {
  final request = RequestOptions(path: '/api/v1/messages/conversations');
  return DioException(
    requestOptions: request,
    response: Response<void>(
      requestOptions: request,
      statusCode: statusCode,
    ),
    type: DioExceptionType.badResponse,
  );
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

List<Override> _commonOverrides({
  required _FakeMessagingApi api,
  required String role,
  required int roleId,
  Future<List<HcpLink>> Function(Ref ref)? hcpLinksOverride,
  Future<List<ResearcherResult>> Function(Ref ref)? friendsOverride,
  Future<List<Map<String, dynamic>>> Function(Ref ref)? hcpPatientsOverride,
}) {
  return [
    authProvider.overrideWith(
      (ref) => _AuthNotifier(
        AuthState(
          isAuthenticated: true,
          user: _user(role),
        ),
      ),
    ),
    currentUserRoleProvider.overrideWith((ref) => role),
    participantSessionProvider.overrideWith((ref) async => _session(role, roleId)),
    messagingApiProvider.overrideWith((ref) => api),
    hcpLinksProvider.overrideWith(hcpLinksOverride ?? (ref) async => const []),
    friendsProvider.overrideWith(friendsOverride ?? (ref) async => const []),
    hcpPatientsProvider.overrideWith(
      hcpPatientsOverride ?? (ref) async => const <Map<String, dynamic>>[],
    ),
  ];
}

Widget _buildRoutedPage(List<Override> overrides) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const NewConversationPage(),
      ),
      GoRoute(
        path: '/messages/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return Scaffold(body: Text('Conversation $id'));
        },
      ),
    ],
  );

  return TestRouterApp(
    router: router,
    overrides: overrides,
  );
}

AppLocalizations _l10n(WidgetTester tester) {
  final context = tester.element(find.byType(NewConversationPage));
  return AppLocalizations.of(context);
}

void main() {
  group('NewConversationPage', () {
    late _FakeMessagingApi api;

    setUp(() {
      api = _FakeMessagingApi();
    });

    testWidgets('participant shows accepted HCPs and friends', (tester) async {
      _setDesktopViewport(tester);

      await tester.pumpWidget(
        _buildRoutedPage(
          _commonOverrides(
            api: api,
            role: 'participant',
            roleId: 1,
            hcpLinksOverride: (ref) async => [
              _link(linkId: 1, hcpId: 10, status: 'accepted', hcpName: 'Dr Smith'),
              _link(linkId: 2, hcpId: 11, status: 'pending', hcpName: 'Dr Pending'),
            ],
            friendsOverride: (ref) async => [
              _friend(id: 40, name: 'Bob'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.messagingSelectRecipient), findsOneWidget);
      expect(find.text('Dr Smith'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Dr Pending'), findsNothing);
      expect(find.text(l10n.messagingEmailLabel), findsNothing);
    });

    testWidgets('participant tap recipient creates conversation by account id and navigates',
        (tester) async {
      _setDesktopViewport(tester);

      await tester.pumpWidget(
        _buildRoutedPage(
          _commonOverrides(
            api: api,
            role: 'participant',
            roleId: 1,
            hcpLinksOverride: (ref) async => [
              _link(linkId: 1, hcpId: 10, status: 'accepted', hcpName: 'Dr Smith'),
            ],
            friendsOverride: (ref) async => const [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dr Smith'));
      await tester.pumpAndSettle();

      expect(api.lastCreateConversationBody, {'target_account_id': 10});
      expect(find.text('Conversation 77'), findsOneWidget);
    });

    testWidgets('hcp can start conversation by email', (tester) async {
      _setDesktopViewport(tester);

      await tester.pumpWidget(
        _buildRoutedPage(
          _commonOverrides(
            api: api,
            role: 'hcp',
            roleId: 3,
            hcpPatientsOverride: (ref) async => [
              {
                'patient_id': 7,
                'patient_name': 'Patient One',
              },
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField).first, 'user@example.com');
      await tester.tap(find.text(l10n.messagingStartConversation));
      await tester.pumpAndSettle();

      expect(api.lastCreateConversationBody, {'target_email': 'user@example.com'});
      expect(find.text('Conversation 77'), findsOneWidget);
    });

    testWidgets('shows localized 404 error when target email is not found', (tester) async {
      _setDesktopViewport(tester);
      api.createConversationError = _dioStatusError(404);

      await tester.pumpWidget(
        _buildRoutedPage(
          _commonOverrides(
            api: api,
            role: 'researcher',
            roleId: 2,
            friendsOverride: (ref) async => [
              _friend(id: 25, name: 'Researcher A'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField).first, 'missing@example.com');
      await tester.tap(find.text(l10n.messagingStartConversation));
      await tester.pumpAndSettle();

      expect(find.text(l10n.messagingEmailNotFound), findsOneWidget);
    });
  });
}
