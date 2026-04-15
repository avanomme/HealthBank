// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      convId: (json['conv_id'] as num).toInt(),
      otherParticipantId: (json['other_participant_id'] as num).toInt(),
      otherParticipantName: json['other_participant_name'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] == null
          ? null
          : DateTime.parse(json['last_message_at'] as String),
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'conv_id': instance.convId,
      'other_participant_id': instance.otherParticipantId,
      'other_participant_name': instance.otherParticipantName,
      'last_message': instance.lastMessage,
      'last_message_at': instance.lastMessageAt?.toIso8601String(),
      'unread_count': instance.unreadCount,
    };

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  messageId: (json['message_id'] as num).toInt(),
  senderId: (json['sender_id'] as num).toInt(),
  senderName: json['sender_name'] as String?,
  body: json['body'] as String,
  sentAt: DateTime.parse(json['sent_at'] as String),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'message_id': instance.messageId,
  'sender_id': instance.senderId,
  'sender_name': instance.senderName,
  'body': instance.body,
  'sent_at': instance.sentAt.toIso8601String(),
};

_FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    _FriendRequest(
      requestId: (json['request_id'] as num).toInt(),
      requesterId: (json['requester_id'] as num).toInt(),
      requesterName: json['requester_name'] as String?,
      requestedAt: DateTime.parse(json['requested_at'] as String),
    );

Map<String, dynamic> _$FriendRequestToJson(_FriendRequest instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'requester_id': instance.requesterId,
      'requester_name': instance.requesterName,
      'requested_at': instance.requestedAt.toIso8601String(),
    };

_ResearcherResult _$ResearcherResultFromJson(Map<String, dynamic> json) =>
    _ResearcherResult(
      accountId: (json['account_id'] as num).toInt(),
      displayName: json['display_name'] as String,
      roleName: json['role_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$ResearcherResultToJson(_ResearcherResult instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'display_name': instance.displayName,
      'role_name': instance.roleName,
      'email': instance.email,
    };

_ConversationCreated _$ConversationCreatedFromJson(Map<String, dynamic> json) =>
    _ConversationCreated(convId: (json['conv_id'] as num).toInt());

Map<String, dynamic> _$ConversationCreatedToJson(
  _ConversationCreated instance,
) => <String, dynamic>{'conv_id': instance.convId};

_MessageCreated _$MessageCreatedFromJson(Map<String, dynamic> json) =>
    _MessageCreated(messageId: (json['message_id'] as num).toInt());

Map<String, dynamic> _$MessageCreatedToJson(_MessageCreated instance) =>
    <String, dynamic>{'message_id': instance.messageId};
