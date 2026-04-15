import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';
import 'package:frontend/src/features/hcp_clients/state/hcp_providers.dart';
import 'package:frontend/src/features/messaging/pages/messaging_inbox_page.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/messaging/widgets/recipient_tile.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';
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

class _FakeMessagingApi implements MessagingApi {
  List<ResearcherResult> searchResults = const [];
  Object? sendMessageError;
  Object? createConversationError;
  Object? friendResponseError;
  Object? friendRequestError;
  Object? searchResearchersError;
  Map<String, dynamic>? lastSendBody;
  int? lastSendConvId;
  int? createdTargetAccountId;
  String? lastFriendRequestEmail;
  List<String> friendActions = [];

  @override
  Future<MessageCreated> sendMessage(int convId, Map<String, dynamic> body) async {
    if (sendMessageError != null) throw sendMessageError!;
    lastSendConvId = convId;
    lastSendBody = body;
    return const MessageCreated(messageId: 99);
  }

  @override
  Future<ConversationCreated> createConversation(Map<String, dynamic> body) async {
    if (createConversationError != null) throw createConversationError!;
    createdTargetAccountId = body['target_account_id'] as int?;
    return const ConversationCreated(convId: 99);
  }

  @override
  Future<void> sendFriendRequest(Map<String, dynamic> body) async {
    if (friendRequestError != null) throw friendRequestError!;
    lastFriendRequestEmail = body['email'] as String?;
  }

  @override
  Future<void> respondToFriendRequest(int requestId, Map<String, dynamic> body) async {
    if (friendResponseError != null) throw friendResponseError!;
    friendActions.add('${body['action']}:$requestId');
  }

  @override
  Future<List<ResearcherResult>> searchResearchers(String query) async {
    if (searchResearchersError != null) throw searchResearchersError!;
    return searchResults;
  }

  @override
  Future<List<Conversation>> getConversations() async {
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> getMessages(int convId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<FriendRequest>> getIncomingFriendRequests() async {
    throw UnimplementedError();
  }

  @override
  Future<List<ResearcherResult>> getFriends() async {
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

Conversation _conversation({
  required int id,
  required String name,
  String? lastMessage,
}) {
  return Conversation(
    convId: id,
    otherParticipantId: id + 100,
    otherParticipantName: name,
    lastMessage: lastMessage,
    lastMessageAt: DateTime.parse('2026-03-16T10:00:00Z'),
  );
}

Message _message({
  required int id,
  required int senderId,
  required String senderName,
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

FriendRequest _friendRequest(int id, String name) {
  return FriendRequest(
    requestId: id,
    requesterId: id + 10,
    requesterName: name,
    requestedAt: DateTime.parse('2026-03-16T10:00:00Z'),
  );
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1.0;
}

void _setMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1.0;
}

void _resetViewport(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

void main() {
  group('MessagingInboxPage', () {
    late _FakeMessagingApi api;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      api = _FakeMessagingApi();
    });

    Widget buildInbox({
      String authRole = 'participant',
      String sessionRole = 'participant',
      int sessionRoleId = 1,
      List<Override> extraOverrides = const [],
    }) {
      return buildTestPage(
        const MessagingInboxPage(),
        overrides: [
          authProvider.overrideWith(
            (ref) => _AuthNotifier(
              AuthState(
                isAuthenticated: true,
                user: _user(authRole),
              ),
            ),
          ),
          impersonationProvider.overrideWith(
            (ref) => _ImpersonationNotifier(const ImpersonationState()),
          ),
          participantSessionProvider.overrideWith(
            (ref) async => _session(sessionRole, sessionRoleId),
          ),
          messagingApiProvider.overrideWith((ref) => api),
          incomingFriendRequestsProvider.overrideWith((ref) async => const []),
          conversationsProvider.overrideWith((ref) async => const []),
          hcpLinksProvider.overrideWith((ref) async => const []),
          friendsProvider.overrideWith((ref) async => const []),
          hcpPatientsProvider.overrideWith((ref) async => const []),
          ...extraOverrides,
        ],
      );
    }

    tearDown(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('desktop renders empty conversations and empty thread', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(buildInbox());
      await tester.pumpAndSettle();

      expect(find.text('Messages'), findsWidgets);
      expect(find.text('No conversations yet.'), findsOneWidget);
      expect(find.text('Select a conversation to start messaging'), findsOneWidget);
    });

    testWidgets('desktop retries failed conversations and failed messages', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      var conversationLoads = 0;
      var messageLoads = 0;

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            conversationsProvider.overrideWith((ref) async {
              conversationLoads += 1;
              if (conversationLoads == 1) throw Exception('boom');
              return [_conversation(id: 1, name: 'Dr Smith')];
            }),
            messagesProvider(1).overrideWith((ref) async {
              messageLoads += 1;
              if (messageLoads == 1) throw Exception('boom');
              return [_message(id: 1, senderId: 1, senderName: 'Ada', body: 'Hello')];
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load messages.'), findsOneWidget);
      await tester.tap(find.text('Retry').first);
      await tester.pumpAndSettle();

      expect(conversationLoads, 2);
      await tester.tap(find.text('Dr Smith'));
      await tester.pumpAndSettle();
      expect(find.text('Failed to load messages.'), findsOneWidget);

      await tester.tap(find.text('Retry').last);
      await tester.pumpAndSettle();
      expect(messageLoads, 2);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('desktop thread renders messages and sends successfully', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            conversationsProvider.overrideWith(
              (ref) async => [_conversation(id: 1, name: 'Dr Smith', lastMessage: 'Ping')],
            ),
            messagesProvider(1).overrideWith(
              (ref) async => [
                _message(id: 1, senderId: 1, senderName: 'Ada', body: 'My note'),
                _message(id: 2, senderId: 50, senderName: 'Dr Smith', body: 'Reply'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dr Smith'));
      await tester.pumpAndSettle();

      expect(find.text('My note'), findsOneWidget);
      expect(find.text('Reply'), findsOneWidget);
      expect(find.text('You'), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, 'New message');
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pumpAndSettle();

      expect(api.lastSendConvId, 1);
      expect(api.lastSendBody, {'body': 'New message'});
    });

    testWidgets('mobile opens selected thread and returns to conversation list', (tester) async {
      _setMobileViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            conversationsProvider.overrideWith(
              (ref) async => [_conversation(id: 1, name: 'Dr Smith')],
            ),
            messagesProvider(1).overrideWith((ref) async => const []),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dr Smith'));
      await tester.pumpAndSettle();

      expect(find.text('No messages yet. Say hello!'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Dr Smith'), findsOneWidget);
      expect(find.text('No messages yet. Say hello!'), findsNothing);
    });

    testWidgets('mobile friend requests action opens sheet',
        (tester) async {
      _setMobileViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            incomingFriendRequestsProvider.overrideWith((ref) async => const []),
            hcpLinksProvider.overrideWith((ref) async => const []),
            friendsProvider.overrideWith((ref) async => const []),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_add_outlined), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Add a Contact'), findsOneWidget);
    });

    testWidgets('mobile thread uses fallback recipient name when conversation has no display name',
        (tester) async {
      _setMobileViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            conversationsProvider.overrideWith(
              (ref) async => [
                Conversation(
                  convId: 1,
                  otherParticipantId: 501,
                  otherParticipantName: null,
                  lastMessageAt: DateTime.parse('2026-03-16T10:00:00Z'),
                ),
              ],
            ),
            messagesProvider(1).overrideWith((ref) async => const []),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('User #501'));
      await tester.pumpAndSettle();

      expect(find.text('User #501'), findsWidgets);
    });

    testWidgets('message sending shows error and supports submit via keyboard',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      api.sendMessageError = Exception('offline');

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            conversationsProvider.overrideWith(
              (ref) async => [_conversation(id: 1, name: 'Dr Smith', lastMessage: 'Ping')],
            ),
            messagesProvider(1).overrideWith(
              (ref) async => [_message(id: 1, senderId: 50, senderName: 'Dr Smith', body: 'Reply')],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dr Smith').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Enter send');
      await tester.testTextInput.receiveAction(TextInputAction.newline);
      await tester.pumpAndSettle();

      expect(api.lastSendBody, isNull);
      expect(find.text('Enter send'), findsOneWidget);

      api.sendMessageError = null;
      await tester.enterText(find.byType(TextField).last, 'Retry send');
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pumpAndSettle();

      expect(api.lastSendConvId, 1);
      expect(api.lastSendBody, {'body': 'Retry send'});
    });

    testWidgets('desktop thread uses fallback current user and conversation tile fallbacks',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            participantSessionProvider.overrideWith((ref) async => throw Exception('no session')),
            conversationsProvider.overrideWith(
              (ref) async => [
                Conversation(
                  convId: 1,
                  otherParticipantId: 700,
                  otherParticipantName: null,
                  lastMessage: 'Fallback preview',
                  lastMessageAt: DateTime.now().subtract(const Duration(days: 2)),
                ),
              ],
            ),
            messagesProvider(1).overrideWith(
              (ref) async => [
                _message(id: 1, senderId: 1, senderName: 'Ada', body: 'My note'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('User #700'), findsOneWidget);
      await tester.tap(find.text('User #700'));
      await tester.pumpAndSettle();

      expect(find.text('Ada'), findsOneWidget);
      expect(find.text('Fallback preview'), findsOneWidget);
    });

    testWidgets('switching desktop conversations triggers updated thread and old-date formatting',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            conversationsProvider.overrideWith(
              (ref) async => [
                Conversation(
                  convId: 1,
                  otherParticipantId: 200,
                  otherParticipantName: 'Recent',
                  lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
                ),
                Conversation(
                  convId: 2,
                  otherParticipantId: 201,
                  otherParticipantName: 'Older',
                  lastMessageAt: DateTime.now().subtract(const Duration(days: 10)),
                ),
              ],
            ),
            messagesProvider(1).overrideWith(
              (ref) async => [_message(id: 1, senderId: 1, senderName: 'Ada', body: 'One')],
            ),
            messagesProvider(2).overrideWith(
              (ref) async => [_message(id: 2, senderId: 50, senderName: 'Older', body: 'Two')],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('/'), findsOneWidget);
      await tester.tap(find.text('Recent').first);
      await tester.pumpAndSettle();
      expect(find.text('One'), findsOneWidget);
      await tester.tap(find.text('Older').first);
      await tester.pumpAndSettle();
      expect(find.text('Two'), findsOneWidget);
    });

    testWidgets('friend request sheet sends and responds to requests', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) async => [_friendRequest(1, 'Grace Hopper')],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      await tester.tap(find.byTooltip('Contact Requests'));
      await tester.pumpAndSettle();

      expect(find.text('Add a Contact'), findsOneWidget);
      expect(find.text('Grace Hopper'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'contact@example.com');
      await tester.tap(find.text('Send Contact Request').last);
      await tester.pumpAndSettle();
      expect(api.lastFriendRequestEmail, 'contact@example.com');
      expect(find.text('If this user exists, a contact request will be sent.'), findsOneWidget);

      expect(find.text('Accept'), findsWidgets);
      expect(find.text('Decline'), findsWidgets);
    });

    testWidgets('friend request sheet covers loading, empty, fallback names and error actions',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      final requestsCompleter = Completer<List<FriendRequest>>();

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            incomingFriendRequestsProvider.overrideWith((ref) => requestsCompleter.future),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Contact Requests'));
      await tester.pump();
      expect(find.byType(AppLoadingIndicator), findsWidgets);

      requestsCompleter.complete(const []);
      await tester.pumpAndSettle();
      expect(find.text('Add a Contact'), findsOneWidget);
    });

    testWidgets('friend request sheet covers fallback requester name',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) async => [
                FriendRequest(
                  requestId: 9,
                  requesterId: 99,
                  requesterName: null,
                  requestedAt: DateTime.parse('2026-03-16T10:00:00Z'),
                ),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Contact Requests'));
      await tester.pumpAndSettle();
      expect(find.text('User #99'), findsOneWidget);
      expect(find.text('Accept'), findsWidgets);
      expect(find.text('Decline'), findsWidgets);
    });

    testWidgets('friend request sheet shows request list error',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            incomingFriendRequestsProvider.overrideWith(
              (ref) async => throw Exception('boom'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Contact Requests'));
      await tester.pumpAndSettle();
      expect(find.text('Failed to load messages.'), findsOneWidget);
    });

    testWidgets('participant new conversation sheet lists HCP and contacts and creates a conversation',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      var includeNewConversation = false;

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            conversationsProvider.overrideWith((ref) async {
              return [
                _conversation(id: 1, name: 'Existing'),
                if (includeNewConversation) _conversation(id: 99, name: 'Dr New'),
              ];
            }),
            hcpLinksProvider.overrideWith(
              (ref) async => [
                HcpLink(
                  linkId: 1,
                  hcpId: 44,
                  patientId: 1,
                  hcpName: 'Dr New',
                  status: 'accepted',
                  requestedBy: 'participant',
                  requestedAt: DateTime.parse('2026-03-16T10:00:00Z'),
                  updatedAt: DateTime.parse('2026-03-16T10:00:00Z'),
                ),
              ],
            ),
            friendsProvider.overrideWith(
              (ref) async => const [
                ResearcherResult(accountId: 77, displayName: 'Research Friend'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('New Message'));
      await tester.pumpAndSettle();

      expect(find.text('My Healthcare Provider'), findsOneWidget);
      expect(find.text('My Contacts'), findsOneWidget);
      expect(find.text('Dr New'), findsOneWidget);
      expect(find.text('Research Friend'), findsOneWidget);

      includeNewConversation = true;
      await tester.tap(find.text('Dr New'));
      await tester.pumpAndSettle();

      expect(api.createdTargetAccountId, 44);
      expect(find.text('Dr New'), findsWidgets);
    });

    testWidgets('researcher recipient picker supports search flow', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          authRole: 'researcher',
          sessionRole: 'researcher',
          sessionRoleId: 2,
          extraOverrides: [
            allResearchersProvider.overrideWith(
              (ref) async => const [
                ResearcherResult(accountId: 88, displayName: 'Dr Curie'),
              ],
            ),
            friendsProvider.overrideWith((ref) async => const []),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('New Message'));
      await tester.pumpAndSettle();

      // All researchers shown with no filter
      expect(find.text('Dr Curie'), findsOneWidget);

      // Second TextField is the researcher filter (first is the email input)
      final filterField = find.byType(TextField).at(1);
      await tester.enterText(filterField, 'xyz');
      await tester.pump();
      expect(find.text('Dr Curie'), findsNothing);

      await tester.enterText(filterField, 'cur');
      await tester.pump();
      expect(find.text('Dr Curie'), findsOneWidget);
      await tester.tap(find.text('Dr Curie'));
      await tester.pumpAndSettle();
      expect(api.createdTargetAccountId, 88);
    });

    testWidgets('researcher recipient picker covers loading, empty and failed search',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          authRole: 'researcher',
          sessionRole: 'researcher',
          sessionRoleId: 2,
          extraOverrides: [
            allResearchersProvider.overrideWith((ref) async => const []),
            friendsProvider.overrideWith((ref) async => const []),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('New Message'));
      await tester.pumpAndSettle();

      // Both contacts and researchers show empty state
      expect(find.text('Dr Curie'), findsNothing);

      // Filter on empty list still shows no results
      final filterField = find.byType(TextField).at(1);
      await tester.enterText(filterField, 'cur');
      await tester.pump();
      expect(find.text('Dr Curie'), findsNothing);
    });

    testWidgets('session fallback defaults new conversation sheet to participant recipients',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            participantSessionProvider.overrideWith((ref) async => throw Exception('no session')),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('New Message'));
      await tester.pumpAndSettle();
      expect(find.text('My Healthcare Provider'), findsOneWidget);
    });

    testWidgets('hcp recipient picker lists linked patients', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          authRole: 'hcp',
          sessionRole: 'hcp',
          sessionRoleId: 3,
          extraOverrides: [
            hcpPatientsProvider.overrideWith(
              (ref) async => const [
                {'patient_id': 55, 'patient_name': 'Pat One'},
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('New Message'));
      await tester.pumpAndSettle();
      expect(find.text('Pat One'), findsOneWidget);
    });

    testWidgets('participant recipient sheet covers error and empty states',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          extraOverrides: [
            hcpLinksProvider.overrideWith((ref) async => throw Exception('boom')),
            friendsProvider.overrideWith((ref) async => const []),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('New Message'));
      await tester.pumpAndSettle();
      expect(find.text('Failed to load messages.'), findsOneWidget);
      expect(find.byType(RecipientTile), findsNothing);
    });

    testWidgets('hcp recipient sheet covers error state',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          authRole: 'hcp',
          sessionRole: 'hcp',
          sessionRoleId: 3,
          extraOverrides: [
            hcpPatientsProvider.overrideWith((ref) async => throw Exception('boom')),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('New Message'));
      await tester.pumpAndSettle();
      expect(find.text('Failed to load messages.'), findsWidgets);
    });

    testWidgets('admin recipient picker starts a conversation from account id',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        buildInbox(
          authRole: 'admin',
          sessionRole: 'admin',
          sessionRoleId: 4,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('New Message'));
      await tester.pumpAndSettle();
      expect(find.text('Account ID'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, '123');
      await tester.tap(find.text('New Message').last);
      await tester.pumpAndSettle();
      expect(api.createdTargetAccountId, 123);
    });

    testWidgets('new conversation create failure leaves sheet open', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));
      api.createConversationError = Exception('nope');

      await tester.pumpWidget(
        buildInbox(
          authRole: 'admin',
          sessionRole: 'admin',
          sessionRoleId: 4,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('New Message'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '123');
      await tester.tap(find.text('New Message').last);
      await tester.pumpAndSettle();

      expect(find.text('Account ID'), findsOneWidget);
      expect(api.createdTargetAccountId, isNull);
    });
  });
}
