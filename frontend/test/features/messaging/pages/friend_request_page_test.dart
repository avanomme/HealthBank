import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';
import 'package:frontend/src/features/messaging/pages/friend_request_page.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';

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
  Object? sendFriendRequestError;
  Object? respondError;
  String? lastFriendEmail;
  int? lastRespondId;
  String? lastRespondAction;

  @override
  Future<void> sendFriendRequest(Map<String, dynamic> body) async {
    if (sendFriendRequestError != null) {
      throw sendFriendRequestError!;
    }
    lastFriendEmail = body['email'] as String?;
  }

  @override
  Future<void> respondToFriendRequest(int requestId, Map<String, dynamic> body) async {
    if (respondError != null) {
      throw respondError!;
    }
    lastRespondId = requestId;
    lastRespondAction = body['action'] as String?;
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
  Future<ConversationCreated> createConversation(Map<String, dynamic> body) async {
    throw UnimplementedError();
  }

  @override
  Future<MessageCreated> sendMessage(int convId, Map<String, dynamic> body) async {
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
  Future<List<ResearcherResult>> listResearchers({String? query}) async => [];

  @override
  Future<void> sendDirectFriendRequest(Map<String, dynamic> body) async {}
}

FriendRequest _request({
  required int id,
  int requesterId = 11,
  String? requesterName,
}) {
  return FriendRequest(
    requestId: id,
    requesterId: requesterId,
    requesterName: requesterName,
    requestedAt: DateTime.parse('2026-03-16T10:00:00Z'),
  );
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

AppLocalizations _l10n(WidgetTester tester) {
  final context = tester.element(find.byType(FriendRequestPage));
  return AppLocalizations.of(context);
}

Widget _buildPage(List<Override> overrides) {
  return buildTestPage(
    const FriendRequestPage(),
    overrides: overrides,
  );
}

List<Override> _commonOverrides({
  required _FakeMessagingApi api,
  Future<List<FriendRequest>> Function(Ref ref)? incomingOverride,
}) {
  return [
    authProvider.overrideWith(
      (ref) => _AuthNotifier(
        const AuthState(
          isAuthenticated: true,
          user: LoginResponse(
            expiresAt: '2099-01-01T00:00:00Z',
            accountId: 1,
            firstName: 'Ada',
            lastName: 'Lovelace',
            email: 'ada@example.com',
            role: 'participant',
          ),
        ),
      ),
    ),
    currentUserRoleProvider.overrideWith((ref) => 'participant'),
    messagingApiProvider.overrideWith((ref) => api),
    conversationsProvider.overrideWith((ref) async => []),
    participantSessionProvider.overrideWith((ref) async => const SessionMeResponse(
      user: SessionUserInfo(
        accountId: 1,
        email: 'ada@example.com',
        role: 'participant',
        roleId: 1,
      ),
      isImpersonating: false,
      sessionExpiresAt: '2099-01-01T00:00:00Z',
    )),
    if (incomingOverride != null)
      incomingFriendRequestsProvider.overrideWith(incomingOverride)
    else
      incomingFriendRequestsProvider.overrideWith((ref) async => const []),
  ];
}

void main() {
  group('FriendRequestPage', () {
    late _FakeMessagingApi api;

    setUp(() {
      api = _FakeMessagingApi();
    });

    testWidgets('shows loading state for incoming requests', (tester) async {
      _setDesktopViewport(tester);
      final completer = Completer<List<FriendRequest>>();
      addTearDown(() {
        if (!completer.isCompleted) {
          completer.complete(const []);
        }
      });

      await tester.pumpWidget(
        _buildPage(
          _commonOverrides(
            api: api,
            incomingOverride: (ref) => completer.future,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsWidgets);
    });

    testWidgets('shows error text when incoming requests fail', (tester) async {
      _setDesktopViewport(tester);
      await tester.pumpWidget(
        _buildPage(
          _commonOverrides(
            api: api,
            incomingOverride: (ref) async => throw Exception('boom'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.messagingError), findsOneWidget);
    });

    testWidgets('shows empty state when no incoming requests', (tester) async {
      _setDesktopViewport(tester);
      await tester.pumpWidget(
        _buildPage(_commonOverrides(api: api)),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.messagingNoIncomingRequests), findsOneWidget);
    });

    testWidgets('renders incoming request tiles and fallback requester name',
        (tester) async {
      _setDesktopViewport(tester);
      await tester.pumpWidget(
        _buildPage(
          _commonOverrides(
            api: api,
            incomingOverride: (ref) async => [
              _request(id: 1, requesterName: 'Dr Smith'),
              _request(id: 2, requesterId: 22, requesterName: null),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dr Smith'), findsOneWidget);
      expect(find.text('User #22'), findsOneWidget);
    });

    testWidgets('send friend request success shows confirmation message',
        (tester) async {
      _setDesktopViewport(tester);
      await tester.pumpWidget(_buildPage(_commonOverrides(api: api)));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField).first, 'friend@example.com');
      await tester.tap(find.text(l10n.messagingFriendRequestSend));
      await tester.pumpAndSettle();

      expect(api.lastFriendEmail, 'friend@example.com');
      expect(find.text(l10n.messagingFriendRequestSent), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField).first);
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('send request preserves privacy for client errors (404/409)',
        (tester) async {
      _setDesktopViewport(tester);
      final reqOptions = RequestOptions(path: '/friends/requests');
      api.sendFriendRequestError = DioException(
        requestOptions: reqOptions,
        response: Response(
          requestOptions: reqOptions,
          statusCode: 404,
          data: const {'detail': 'not found'},
        ),
      );

      await tester.pumpWidget(_buildPage(_commonOverrides(api: api)));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField).first, 'missing@example.com');
      await tester.tap(find.text(l10n.messagingFriendRequestSend));
      await tester.pumpAndSettle();

      expect(find.text(l10n.messagingFriendRequestSent), findsOneWidget);
      expect(find.text(l10n.errorNetwork), findsNothing);
    });

    testWidgets('send request shows network error for non-client failures',
        (tester) async {
      _setDesktopViewport(tester);
      final reqOptions = RequestOptions(path: '/friends/requests');
      api.sendFriendRequestError = DioException(
        requestOptions: reqOptions,
        response: Response(
          requestOptions: reqOptions,
          statusCode: 500,
          data: const {'detail': 'server error'},
        ),
      );

      await tester.pumpWidget(_buildPage(_commonOverrides(api: api)));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField).first, 'friend@example.com');
      await tester.tap(find.text(l10n.messagingFriendRequestSend));
      await tester.pumpAndSettle();

      expect(find.text(l10n.errorNetwork), findsOneWidget);
      expect(find.text(l10n.messagingFriendRequestSent), findsNothing);
    });

    testWidgets('accept action responds and shows success toast',
        (tester) async {
      _setDesktopViewport(tester);
      await tester.pumpWidget(
        _buildPage(
          _commonOverrides(
            api: api,
            incomingOverride: (ref) async => [_request(id: 10, requesterName: 'Dr Smith')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.tap(find.text(l10n.messagingAcceptRequest).first);
      await tester.pumpAndSettle();

      expect(api.lastRespondId, 10);
      expect(api.lastRespondAction, 'accept');
      expect(find.text(l10n.messagingFriendAccepted), findsOneWidget);
    });

    testWidgets('reject action responds and shows success toast',
        (tester) async {
      _setDesktopViewport(tester);
      await tester.pumpWidget(
        _buildPage(
          _commonOverrides(
            api: api,
            incomingOverride: (ref) async => [_request(id: 12, requesterName: 'Dr Jones')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.tap(find.text(l10n.messagingRejectRequest));
      await tester.pumpAndSettle();

      expect(api.lastRespondId, 12);
      expect(api.lastRespondAction, 'reject');
      expect(find.text(l10n.messagingFriendDeclined), findsOneWidget);
    });

    testWidgets('respond failure shows friend-request error toast',
        (tester) async {
      _setDesktopViewport(tester);
      api.respondError = Exception('respond failed');
      await tester.pumpWidget(
        _buildPage(
          _commonOverrides(
            api: api,
            incomingOverride: (ref) async => [_request(id: 20, requesterName: 'Dr Lee')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.tap(find.text(l10n.messagingAcceptRequest).first);
      await tester.pumpAndSettle();

      expect(find.text(l10n.messagingFriendRequestError), findsOneWidget);
    });
  });
}
