import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';
import 'package:frontend/src/features/messaging/pages/conversation_page.dart';
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
  Object? sendMessageError;
  int? lastSendConvId;
  Map<String, dynamic>? lastSendBody;

  @override
  Future<MessageCreated> sendMessage(int convId, Map<String, dynamic> body) async {
    if (sendMessageError != null) {
      throw sendMessageError!;
    }
    lastSendConvId = convId;
    lastSendBody = body;
    return const MessageCreated(messageId: 123);
  }

  @override
  Future<List<Message>> getMessages(int convId) async => const [];

  @override
  Future<List<Conversation>> getConversations() async => const [];

  @override
  Future<List<FriendRequest>> getIncomingFriendRequests() async => const [];

  @override
  Future<List<ResearcherResult>> getFriends() async => const [];

  @override
  Future<ConversationCreated> createConversation(Map<String, dynamic> body) async {
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
  Future<List<ResearcherResult>> listResearchers({String? query}) async => [];

  @override
  Future<void> sendDirectFriendRequest(Map<String, dynamic> body) async {}
}

SessionMeResponse _session({int accountId = 1}) {
  return SessionMeResponse(
    user: SessionUserInfo(
      accountId: accountId,
      firstName: 'Ada',
      lastName: 'Lovelace',
      email: 'ada@example.com',
      role: 'participant',
      roleId: 1,
    ),
    isImpersonating: false,
    sessionExpiresAt: '2099-01-01T00:00:00Z',
  );
}

Message _message({
  required int id,
  required int senderId,
  String? senderName,
  required String body,
}) {
  return Message(
    messageId: id,
    senderId: senderId,
    senderName: senderName,
    body: body,
    sentAt: DateTime.parse('2026-03-16T10:00:00Z'),
  );
}

Widget _buildPage({
  required int convId,
  required List<Override> overrides,
}) {
  return buildTestPage(
    ConversationPage(convId: convId),
    overrides: overrides,
  );
}

AppLocalizations _l10n(WidgetTester tester) {
  final context = tester.element(find.byType(ConversationPage));
  return AppLocalizations.of(context);
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

List<Override> _commonOverrides({
  required int convId,
  Future<List<Message>> Function(Ref ref)? messagesOverride,
  MessagingApi? messagingApi,
  SessionMeResponse? session,
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
    participantSessionProvider.overrideWith((ref) async => session ?? _session()),
    messagingUnreadCountProvider.overrideWith((ref) => 0),
    if (messagingApi != null) messagingApiProvider.overrideWith((ref) => messagingApi),
    if (messagesOverride != null)
      messagesProvider(convId).overrideWith(messagesOverride),
  ];
}

void main() {
  group('ConversationPage', () {
    testWidgets('shows loading state while messages are loading', (tester) async {
      _setDesktopViewport(tester);
      final completer = Completer<List<Message>>();
      addTearDown(() {
        if (!completer.isCompleted) {
          completer.complete(const []);
        }
      });

      await tester.pumpWidget(
        _buildPage(
          convId: 7,
          overrides: _commonOverrides(
            convId: 7,
            messagesOverride: (ref) => completer.future,
          ),
        ),
      );
      await tester.pump();

      final l10n = _l10n(tester);
      expect(find.text(l10n.messagingConversationTitle), findsOneWidget);
      expect(find.text(l10n.messagingLoading), findsOneWidget);
    });

    testWidgets('shows error state with retry action', (tester) async {
      _setDesktopViewport(tester);
      await tester.pumpWidget(
        _buildPage(
          convId: 7,
          overrides: _commonOverrides(
            convId: 7,
            messagesOverride: (ref) async => throw Exception('boom'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.messagingError), findsOneWidget);
      expect(find.text(l10n.commonRetry), findsOneWidget);
    });

    testWidgets('shows empty state when no messages are available',
        (tester) async {
      _setDesktopViewport(tester);
      await tester.pumpWidget(
        _buildPage(
          convId: 7,
          overrides: _commonOverrides(
            convId: 7,
            messagesOverride: (ref) async => const [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.messagingNoMessages), findsOneWidget);
    });

    testWidgets('renders messages and marks current-user messages as You',
        (tester) async {
      _setDesktopViewport(tester);
      final messages = [
        _message(id: 1, senderId: 1, senderName: 'Ada', body: 'My message'),
        _message(id: 2, senderId: 2, senderName: 'Bob', body: 'Other message'),
      ];

      await tester.pumpWidget(
        _buildPage(
          convId: 7,
          overrides: _commonOverrides(
            convId: 7,
            messagesOverride: (ref) async => messages,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text('My message'), findsOneWidget);
      expect(find.text('Other message'), findsOneWidget);
      expect(find.text(l10n.messagingYou), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('sends message and clears input on success', (tester) async {
      _setDesktopViewport(tester);
      final api = _FakeMessagingApi();

      await tester.pumpWidget(
        _buildPage(
          convId: 7,
          overrides: _commonOverrides(
            convId: 7,
            messagingApi: api,
            messagesOverride: (ref) async => const [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final inputFinder = find.byType(TextField);
      await tester.enterText(inputFinder, 'Hello there');
      await tester.tap(find.byTooltip(l10n.messagingSend));
      await tester.pumpAndSettle();

      expect(api.lastSendConvId, 7);
      expect(api.lastSendBody?['body'], 'Hello there');

      final textField = tester.widget<TextField>(inputFinder);
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('does not send when message is empty or whitespace',
        (tester) async {
      _setDesktopViewport(tester);
      final api = _FakeMessagingApi();

      await tester.pumpWidget(
        _buildPage(
          convId: 7,
          overrides: _commonOverrides(
            convId: 7,
            messagingApi: api,
            messagesOverride: (ref) async => const [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.byTooltip(l10n.messagingSend));
      await tester.pumpAndSettle();

      expect(api.lastSendConvId, isNull);
      expect(api.lastSendBody, isNull);
    });

    testWidgets('shows toast when sending message fails', (tester) async {
      _setDesktopViewport(tester);
      final api = _FakeMessagingApi()..sendMessageError = Exception('send failed');

      await tester.pumpWidget(
        _buildPage(
          convId: 7,
          overrides: _commonOverrides(
            convId: 7,
            messagingApi: api,
            messagesOverride: (ref) async => const [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField), 'Will fail');
      await tester.tap(find.byTooltip(l10n.messagingSend));
      await tester.pumpAndSettle();

      expect(find.text(l10n.messagingSendError), findsOneWidget);
    });
  });
}
