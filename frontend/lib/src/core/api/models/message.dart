// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/message.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
sealed class Conversation with _$Conversation {
  const factory Conversation({
    @JsonKey(name: 'conv_id') required int convId,
    @JsonKey(name: 'other_participant_id') required int otherParticipantId,
    @JsonKey(name: 'other_participant_name') String? otherParticipantName,
    @JsonKey(name: 'last_message') String? lastMessage,
    @JsonKey(name: 'last_message_at') DateTime? lastMessageAt,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
  }) = _Conversation;
  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

@freezed
sealed class Message with _$Message {
  const factory Message({
    @JsonKey(name: 'message_id') required int messageId,
    @JsonKey(name: 'sender_id') required int senderId,
    @JsonKey(name: 'sender_name') String? senderName,
    required String body,
    @JsonKey(name: 'sent_at') required DateTime sentAt,
  }) = _Message;
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

@freezed
sealed class FriendRequest with _$FriendRequest {
  const factory FriendRequest({
    @JsonKey(name: 'request_id') required int requestId,
    @JsonKey(name: 'requester_id') required int requesterId,
    @JsonKey(name: 'requester_name') String? requesterName,
    @JsonKey(name: 'requested_at') required DateTime requestedAt,
  }) = _FriendRequest;
  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);
}

@freezed
sealed class ResearcherResult with _$ResearcherResult {
  const factory ResearcherResult({
    @JsonKey(name: 'account_id') required int accountId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'role_name') @Default('') String roleName,
    @JsonKey(name: 'email') @Default('') String email,
  }) = _ResearcherResult;
  factory ResearcherResult.fromJson(Map<String, dynamic> json) =>
      _$ResearcherResultFromJson(json);
}

@freezed
sealed class ConversationCreated with _$ConversationCreated {
  const factory ConversationCreated({
    @JsonKey(name: 'conv_id') required int convId,
  }) = _ConversationCreated;
  factory ConversationCreated.fromJson(Map<String, dynamic> json) =>
      _$ConversationCreatedFromJson(json);
}

@freezed
sealed class MessageCreated with _$MessageCreated {
  const factory MessageCreated({
    @JsonKey(name: 'message_id') required int messageId,
  }) = _MessageCreated;
  factory MessageCreated.fromJson(Map<String, dynamic> json) =>
      _$MessageCreatedFromJson(json);
}
