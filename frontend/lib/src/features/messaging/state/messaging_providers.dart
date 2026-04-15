// Created with the Assistance of Claude Code
// frontend/lib/src/features/messaging/state/messaging_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

final messagingApiProvider = Provider<MessagingApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return MessagingApi(client.dio);
});

final conversationsProvider =
    FutureProvider.autoDispose<List<Conversation>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(messagingApiProvider);
  return api.getConversations();
});

final messagesProvider =
    FutureProvider.autoDispose.family<List<Message>, int>((ref, convId) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(messagingApiProvider);
  return api.getMessages(convId);
});

final incomingFriendRequestsProvider =
    FutureProvider.autoDispose<List<FriendRequest>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(messagingApiProvider);
  return api.getIncomingFriendRequests();
});

final friendsProvider =
    FutureProvider.autoDispose<List<ResearcherResult>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(messagingApiProvider);
  return api.getFriends();
});

/// All researchers visible to the current user (researchers + admins only).
final allResearchersProvider =
    FutureProvider.autoDispose<List<ResearcherResult>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(messagingApiProvider);
  return api.listResearchers();
});

/// Total unread count: unread messages across all conversations + pending contact requests.
final messagingUnreadCountProvider = Provider<int>((ref) {
  final conversationsAsync = ref.watch(conversationsProvider);
  final requestsAsync = ref.watch(incomingFriendRequestsProvider);

  final unreadMessages = conversationsAsync.maybeWhen(
    data: (convs) => convs.fold(0, (sum, c) => sum + c.unreadCount),
    orElse: () => 0,
  );
  final pendingRequests = requestsAsync.maybeWhen(
    data: (reqs) => reqs.length,
    orElse: () => 0,
  );
  return unreadMessages + pendingRequests;
});
