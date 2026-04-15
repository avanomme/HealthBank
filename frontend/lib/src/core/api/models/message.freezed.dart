// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Conversation {

@JsonKey(name: 'conv_id') int get convId;@JsonKey(name: 'other_participant_id') int get otherParticipantId;@JsonKey(name: 'other_participant_name') String? get otherParticipantName;@JsonKey(name: 'last_message') String? get lastMessage;@JsonKey(name: 'last_message_at') DateTime? get lastMessageAt;@JsonKey(name: 'unread_count') int get unreadCount;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.convId, convId) || other.convId == convId)&&(identical(other.otherParticipantId, otherParticipantId) || other.otherParticipantId == otherParticipantId)&&(identical(other.otherParticipantName, otherParticipantName) || other.otherParticipantName == otherParticipantName)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,convId,otherParticipantId,otherParticipantName,lastMessage,lastMessageAt,unreadCount);

@override
String toString() {
  return 'Conversation(convId: $convId, otherParticipantId: $otherParticipantId, otherParticipantName: $otherParticipantName, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conv_id') int convId,@JsonKey(name: 'other_participant_id') int otherParticipantId,@JsonKey(name: 'other_participant_name') String? otherParticipantName,@JsonKey(name: 'last_message') String? lastMessage,@JsonKey(name: 'last_message_at') DateTime? lastMessageAt,@JsonKey(name: 'unread_count') int unreadCount
});




}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? convId = null,Object? otherParticipantId = null,Object? otherParticipantName = freezed,Object? lastMessage = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,}) {
  return _then(_self.copyWith(
convId: null == convId ? _self.convId : convId // ignore: cast_nullable_to_non_nullable
as int,otherParticipantId: null == otherParticipantId ? _self.otherParticipantId : otherParticipantId // ignore: cast_nullable_to_non_nullable
as int,otherParticipantName: freezed == otherParticipantName ? _self.otherParticipantName : otherParticipantName // ignore: cast_nullable_to_non_nullable
as String?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'conv_id')  int convId, @JsonKey(name: 'other_participant_id')  int otherParticipantId, @JsonKey(name: 'other_participant_name')  String? otherParticipantName, @JsonKey(name: 'last_message')  String? lastMessage, @JsonKey(name: 'last_message_at')  DateTime? lastMessageAt, @JsonKey(name: 'unread_count')  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.convId,_that.otherParticipantId,_that.otherParticipantName,_that.lastMessage,_that.lastMessageAt,_that.unreadCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'conv_id')  int convId, @JsonKey(name: 'other_participant_id')  int otherParticipantId, @JsonKey(name: 'other_participant_name')  String? otherParticipantName, @JsonKey(name: 'last_message')  String? lastMessage, @JsonKey(name: 'last_message_at')  DateTime? lastMessageAt, @JsonKey(name: 'unread_count')  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.convId,_that.otherParticipantId,_that.otherParticipantName,_that.lastMessage,_that.lastMessageAt,_that.unreadCount);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'conv_id')  int convId, @JsonKey(name: 'other_participant_id')  int otherParticipantId, @JsonKey(name: 'other_participant_name')  String? otherParticipantName, @JsonKey(name: 'last_message')  String? lastMessage, @JsonKey(name: 'last_message_at')  DateTime? lastMessageAt, @JsonKey(name: 'unread_count')  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.convId,_that.otherParticipantId,_that.otherParticipantName,_that.lastMessage,_that.lastMessageAt,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conversation implements Conversation {
  const _Conversation({@JsonKey(name: 'conv_id') required this.convId, @JsonKey(name: 'other_participant_id') required this.otherParticipantId, @JsonKey(name: 'other_participant_name') this.otherParticipantName, @JsonKey(name: 'last_message') this.lastMessage, @JsonKey(name: 'last_message_at') this.lastMessageAt, @JsonKey(name: 'unread_count') this.unreadCount = 0});
  factory _Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

@override@JsonKey(name: 'conv_id') final  int convId;
@override@JsonKey(name: 'other_participant_id') final  int otherParticipantId;
@override@JsonKey(name: 'other_participant_name') final  String? otherParticipantName;
@override@JsonKey(name: 'last_message') final  String? lastMessage;
@override@JsonKey(name: 'last_message_at') final  DateTime? lastMessageAt;
@override@JsonKey(name: 'unread_count') final  int unreadCount;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.convId, convId) || other.convId == convId)&&(identical(other.otherParticipantId, otherParticipantId) || other.otherParticipantId == otherParticipantId)&&(identical(other.otherParticipantName, otherParticipantName) || other.otherParticipantName == otherParticipantName)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,convId,otherParticipantId,otherParticipantName,lastMessage,lastMessageAt,unreadCount);

@override
String toString() {
  return 'Conversation(convId: $convId, otherParticipantId: $otherParticipantId, otherParticipantName: $otherParticipantName, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'conv_id') int convId,@JsonKey(name: 'other_participant_id') int otherParticipantId,@JsonKey(name: 'other_participant_name') String? otherParticipantName,@JsonKey(name: 'last_message') String? lastMessage,@JsonKey(name: 'last_message_at') DateTime? lastMessageAt,@JsonKey(name: 'unread_count') int unreadCount
});




}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? convId = null,Object? otherParticipantId = null,Object? otherParticipantName = freezed,Object? lastMessage = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,}) {
  return _then(_Conversation(
convId: null == convId ? _self.convId : convId // ignore: cast_nullable_to_non_nullable
as int,otherParticipantId: null == otherParticipantId ? _self.otherParticipantId : otherParticipantId // ignore: cast_nullable_to_non_nullable
as int,otherParticipantName: freezed == otherParticipantName ? _self.otherParticipantName : otherParticipantName // ignore: cast_nullable_to_non_nullable
as String?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Message {

@JsonKey(name: 'message_id') int get messageId;@JsonKey(name: 'sender_id') int get senderId;@JsonKey(name: 'sender_name') String? get senderName; String get body;@JsonKey(name: 'sent_at') DateTime get sentAt;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.body, body) || other.body == body)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,senderId,senderName,body,sentAt);

@override
String toString() {
  return 'Message(messageId: $messageId, senderId: $senderId, senderName: $senderName, body: $body, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message_id') int messageId,@JsonKey(name: 'sender_id') int senderId,@JsonKey(name: 'sender_name') String? senderName, String body,@JsonKey(name: 'sent_at') DateTime sentAt
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? senderId = null,Object? senderName = freezed,Object? body = null,Object? sentAt = null,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  int messageId, @JsonKey(name: 'sender_id')  int senderId, @JsonKey(name: 'sender_name')  String? senderName,  String body, @JsonKey(name: 'sent_at')  DateTime sentAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.messageId,_that.senderId,_that.senderName,_that.body,_that.sentAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  int messageId, @JsonKey(name: 'sender_id')  int senderId, @JsonKey(name: 'sender_name')  String? senderName,  String body, @JsonKey(name: 'sent_at')  DateTime sentAt)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.messageId,_that.senderId,_that.senderName,_that.body,_that.sentAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message_id')  int messageId, @JsonKey(name: 'sender_id')  int senderId, @JsonKey(name: 'sender_name')  String? senderName,  String body, @JsonKey(name: 'sent_at')  DateTime sentAt)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.messageId,_that.senderId,_that.senderName,_that.body,_that.sentAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({@JsonKey(name: 'message_id') required this.messageId, @JsonKey(name: 'sender_id') required this.senderId, @JsonKey(name: 'sender_name') this.senderName, required this.body, @JsonKey(name: 'sent_at') required this.sentAt});
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override@JsonKey(name: 'message_id') final  int messageId;
@override@JsonKey(name: 'sender_id') final  int senderId;
@override@JsonKey(name: 'sender_name') final  String? senderName;
@override final  String body;
@override@JsonKey(name: 'sent_at') final  DateTime sentAt;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.body, body) || other.body == body)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,senderId,senderName,body,sentAt);

@override
String toString() {
  return 'Message(messageId: $messageId, senderId: $senderId, senderName: $senderName, body: $body, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message_id') int messageId,@JsonKey(name: 'sender_id') int senderId,@JsonKey(name: 'sender_name') String? senderName, String body,@JsonKey(name: 'sent_at') DateTime sentAt
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? senderId = null,Object? senderName = freezed,Object? body = null,Object? sentAt = null,}) {
  return _then(_Message(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$FriendRequest {

@JsonKey(name: 'request_id') int get requestId;@JsonKey(name: 'requester_id') int get requesterId;@JsonKey(name: 'requester_name') String? get requesterName;@JsonKey(name: 'requested_at') DateTime get requestedAt;
/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendRequestCopyWith<FriendRequest> get copyWith => _$FriendRequestCopyWithImpl<FriendRequest>(this as FriendRequest, _$identity);

  /// Serializes this FriendRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.requesterId, requesterId) || other.requesterId == requesterId)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,requesterId,requesterName,requestedAt);

@override
String toString() {
  return 'FriendRequest(requestId: $requestId, requesterId: $requesterId, requesterName: $requesterName, requestedAt: $requestedAt)';
}


}

/// @nodoc
abstract mixin class $FriendRequestCopyWith<$Res>  {
  factory $FriendRequestCopyWith(FriendRequest value, $Res Function(FriendRequest) _then) = _$FriendRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'request_id') int requestId,@JsonKey(name: 'requester_id') int requesterId,@JsonKey(name: 'requester_name') String? requesterName,@JsonKey(name: 'requested_at') DateTime requestedAt
});




}
/// @nodoc
class _$FriendRequestCopyWithImpl<$Res>
    implements $FriendRequestCopyWith<$Res> {
  _$FriendRequestCopyWithImpl(this._self, this._then);

  final FriendRequest _self;
  final $Res Function(FriendRequest) _then;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? requesterId = null,Object? requesterName = freezed,Object? requestedAt = null,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as int,requesterId: null == requesterId ? _self.requesterId : requesterId // ignore: cast_nullable_to_non_nullable
as int,requesterName: freezed == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String?,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendRequest].
extension FriendRequestPatterns on FriendRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendRequest value)  $default,){
final _that = this;
switch (_that) {
case _FriendRequest():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  int requestId, @JsonKey(name: 'requester_id')  int requesterId, @JsonKey(name: 'requester_name')  String? requesterName, @JsonKey(name: 'requested_at')  DateTime requestedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that.requestId,_that.requesterId,_that.requesterName,_that.requestedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  int requestId, @JsonKey(name: 'requester_id')  int requesterId, @JsonKey(name: 'requester_name')  String? requesterName, @JsonKey(name: 'requested_at')  DateTime requestedAt)  $default,) {final _that = this;
switch (_that) {
case _FriendRequest():
return $default(_that.requestId,_that.requesterId,_that.requesterName,_that.requestedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'request_id')  int requestId, @JsonKey(name: 'requester_id')  int requesterId, @JsonKey(name: 'requester_name')  String? requesterName, @JsonKey(name: 'requested_at')  DateTime requestedAt)?  $default,) {final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that.requestId,_that.requesterId,_that.requesterName,_that.requestedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendRequest implements FriendRequest {
  const _FriendRequest({@JsonKey(name: 'request_id') required this.requestId, @JsonKey(name: 'requester_id') required this.requesterId, @JsonKey(name: 'requester_name') this.requesterName, @JsonKey(name: 'requested_at') required this.requestedAt});
  factory _FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);

@override@JsonKey(name: 'request_id') final  int requestId;
@override@JsonKey(name: 'requester_id') final  int requesterId;
@override@JsonKey(name: 'requester_name') final  String? requesterName;
@override@JsonKey(name: 'requested_at') final  DateTime requestedAt;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendRequestCopyWith<_FriendRequest> get copyWith => __$FriendRequestCopyWithImpl<_FriendRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.requesterId, requesterId) || other.requesterId == requesterId)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,requesterId,requesterName,requestedAt);

@override
String toString() {
  return 'FriendRequest(requestId: $requestId, requesterId: $requesterId, requesterName: $requesterName, requestedAt: $requestedAt)';
}


}

/// @nodoc
abstract mixin class _$FriendRequestCopyWith<$Res> implements $FriendRequestCopyWith<$Res> {
  factory _$FriendRequestCopyWith(_FriendRequest value, $Res Function(_FriendRequest) _then) = __$FriendRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'request_id') int requestId,@JsonKey(name: 'requester_id') int requesterId,@JsonKey(name: 'requester_name') String? requesterName,@JsonKey(name: 'requested_at') DateTime requestedAt
});




}
/// @nodoc
class __$FriendRequestCopyWithImpl<$Res>
    implements _$FriendRequestCopyWith<$Res> {
  __$FriendRequestCopyWithImpl(this._self, this._then);

  final _FriendRequest _self;
  final $Res Function(_FriendRequest) _then;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? requesterId = null,Object? requesterName = freezed,Object? requestedAt = null,}) {
  return _then(_FriendRequest(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as int,requesterId: null == requesterId ? _self.requesterId : requesterId // ignore: cast_nullable_to_non_nullable
as int,requesterName: freezed == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String?,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ResearcherResult {

@JsonKey(name: 'account_id') int get accountId;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'role_name') String get roleName;@JsonKey(name: 'email') String get email;
/// Create a copy of ResearcherResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResearcherResultCopyWith<ResearcherResult> get copyWith => _$ResearcherResultCopyWithImpl<ResearcherResult>(this as ResearcherResult, _$identity);

  /// Serializes this ResearcherResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResearcherResult&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.roleName, roleName) || other.roleName == roleName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,displayName,roleName,email);

@override
String toString() {
  return 'ResearcherResult(accountId: $accountId, displayName: $displayName, roleName: $roleName, email: $email)';
}


}

/// @nodoc
abstract mixin class $ResearcherResultCopyWith<$Res>  {
  factory $ResearcherResultCopyWith(ResearcherResult value, $Res Function(ResearcherResult) _then) = _$ResearcherResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'role_name') String roleName,@JsonKey(name: 'email') String email
});




}
/// @nodoc
class _$ResearcherResultCopyWithImpl<$Res>
    implements $ResearcherResultCopyWith<$Res> {
  _$ResearcherResultCopyWithImpl(this._self, this._then);

  final ResearcherResult _self;
  final $Res Function(ResearcherResult) _then;

/// Create a copy of ResearcherResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? displayName = null,Object? roleName = null,Object? email = null,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,roleName: null == roleName ? _self.roleName : roleName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResearcherResult].
extension ResearcherResultPatterns on ResearcherResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResearcherResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResearcherResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResearcherResult value)  $default,){
final _that = this;
switch (_that) {
case _ResearcherResult():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResearcherResult value)?  $default,){
final _that = this;
switch (_that) {
case _ResearcherResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'role_name')  String roleName, @JsonKey(name: 'email')  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResearcherResult() when $default != null:
return $default(_that.accountId,_that.displayName,_that.roleName,_that.email);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'role_name')  String roleName, @JsonKey(name: 'email')  String email)  $default,) {final _that = this;
switch (_that) {
case _ResearcherResult():
return $default(_that.accountId,_that.displayName,_that.roleName,_that.email);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'role_name')  String roleName, @JsonKey(name: 'email')  String email)?  $default,) {final _that = this;
switch (_that) {
case _ResearcherResult() when $default != null:
return $default(_that.accountId,_that.displayName,_that.roleName,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResearcherResult implements ResearcherResult {
  const _ResearcherResult({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'display_name') required this.displayName, @JsonKey(name: 'role_name') this.roleName = '', @JsonKey(name: 'email') this.email = ''});
  factory _ResearcherResult.fromJson(Map<String, dynamic> json) => _$ResearcherResultFromJson(json);

@override@JsonKey(name: 'account_id') final  int accountId;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'role_name') final  String roleName;
@override@JsonKey(name: 'email') final  String email;

/// Create a copy of ResearcherResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResearcherResultCopyWith<_ResearcherResult> get copyWith => __$ResearcherResultCopyWithImpl<_ResearcherResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResearcherResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResearcherResult&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.roleName, roleName) || other.roleName == roleName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,displayName,roleName,email);

@override
String toString() {
  return 'ResearcherResult(accountId: $accountId, displayName: $displayName, roleName: $roleName, email: $email)';
}


}

/// @nodoc
abstract mixin class _$ResearcherResultCopyWith<$Res> implements $ResearcherResultCopyWith<$Res> {
  factory _$ResearcherResultCopyWith(_ResearcherResult value, $Res Function(_ResearcherResult) _then) = __$ResearcherResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'role_name') String roleName,@JsonKey(name: 'email') String email
});




}
/// @nodoc
class __$ResearcherResultCopyWithImpl<$Res>
    implements _$ResearcherResultCopyWith<$Res> {
  __$ResearcherResultCopyWithImpl(this._self, this._then);

  final _ResearcherResult _self;
  final $Res Function(_ResearcherResult) _then;

/// Create a copy of ResearcherResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? displayName = null,Object? roleName = null,Object? email = null,}) {
  return _then(_ResearcherResult(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,roleName: null == roleName ? _self.roleName : roleName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ConversationCreated {

@JsonKey(name: 'conv_id') int get convId;
/// Create a copy of ConversationCreated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCreatedCopyWith<ConversationCreated> get copyWith => _$ConversationCreatedCopyWithImpl<ConversationCreated>(this as ConversationCreated, _$identity);

  /// Serializes this ConversationCreated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationCreated&&(identical(other.convId, convId) || other.convId == convId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,convId);

@override
String toString() {
  return 'ConversationCreated(convId: $convId)';
}


}

/// @nodoc
abstract mixin class $ConversationCreatedCopyWith<$Res>  {
  factory $ConversationCreatedCopyWith(ConversationCreated value, $Res Function(ConversationCreated) _then) = _$ConversationCreatedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conv_id') int convId
});




}
/// @nodoc
class _$ConversationCreatedCopyWithImpl<$Res>
    implements $ConversationCreatedCopyWith<$Res> {
  _$ConversationCreatedCopyWithImpl(this._self, this._then);

  final ConversationCreated _self;
  final $Res Function(ConversationCreated) _then;

/// Create a copy of ConversationCreated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? convId = null,}) {
  return _then(_self.copyWith(
convId: null == convId ? _self.convId : convId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationCreated].
extension ConversationCreatedPatterns on ConversationCreated {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationCreated value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationCreated() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationCreated value)  $default,){
final _that = this;
switch (_that) {
case _ConversationCreated():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationCreated value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationCreated() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'conv_id')  int convId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationCreated() when $default != null:
return $default(_that.convId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'conv_id')  int convId)  $default,) {final _that = this;
switch (_that) {
case _ConversationCreated():
return $default(_that.convId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'conv_id')  int convId)?  $default,) {final _that = this;
switch (_that) {
case _ConversationCreated() when $default != null:
return $default(_that.convId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationCreated implements ConversationCreated {
  const _ConversationCreated({@JsonKey(name: 'conv_id') required this.convId});
  factory _ConversationCreated.fromJson(Map<String, dynamic> json) => _$ConversationCreatedFromJson(json);

@override@JsonKey(name: 'conv_id') final  int convId;

/// Create a copy of ConversationCreated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCreatedCopyWith<_ConversationCreated> get copyWith => __$ConversationCreatedCopyWithImpl<_ConversationCreated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationCreatedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationCreated&&(identical(other.convId, convId) || other.convId == convId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,convId);

@override
String toString() {
  return 'ConversationCreated(convId: $convId)';
}


}

/// @nodoc
abstract mixin class _$ConversationCreatedCopyWith<$Res> implements $ConversationCreatedCopyWith<$Res> {
  factory _$ConversationCreatedCopyWith(_ConversationCreated value, $Res Function(_ConversationCreated) _then) = __$ConversationCreatedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'conv_id') int convId
});




}
/// @nodoc
class __$ConversationCreatedCopyWithImpl<$Res>
    implements _$ConversationCreatedCopyWith<$Res> {
  __$ConversationCreatedCopyWithImpl(this._self, this._then);

  final _ConversationCreated _self;
  final $Res Function(_ConversationCreated) _then;

/// Create a copy of ConversationCreated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? convId = null,}) {
  return _then(_ConversationCreated(
convId: null == convId ? _self.convId : convId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MessageCreated {

@JsonKey(name: 'message_id') int get messageId;
/// Create a copy of MessageCreated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCreatedCopyWith<MessageCreated> get copyWith => _$MessageCreatedCopyWithImpl<MessageCreated>(this as MessageCreated, _$identity);

  /// Serializes this MessageCreated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageCreated&&(identical(other.messageId, messageId) || other.messageId == messageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId);

@override
String toString() {
  return 'MessageCreated(messageId: $messageId)';
}


}

/// @nodoc
abstract mixin class $MessageCreatedCopyWith<$Res>  {
  factory $MessageCreatedCopyWith(MessageCreated value, $Res Function(MessageCreated) _then) = _$MessageCreatedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message_id') int messageId
});




}
/// @nodoc
class _$MessageCreatedCopyWithImpl<$Res>
    implements $MessageCreatedCopyWith<$Res> {
  _$MessageCreatedCopyWithImpl(this._self, this._then);

  final MessageCreated _self;
  final $Res Function(MessageCreated) _then;

/// Create a copy of MessageCreated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageCreated].
extension MessageCreatedPatterns on MessageCreated {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageCreated value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageCreated() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageCreated value)  $default,){
final _that = this;
switch (_that) {
case _MessageCreated():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageCreated value)?  $default,){
final _that = this;
switch (_that) {
case _MessageCreated() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  int messageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageCreated() when $default != null:
return $default(_that.messageId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  int messageId)  $default,) {final _that = this;
switch (_that) {
case _MessageCreated():
return $default(_that.messageId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message_id')  int messageId)?  $default,) {final _that = this;
switch (_that) {
case _MessageCreated() when $default != null:
return $default(_that.messageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageCreated implements MessageCreated {
  const _MessageCreated({@JsonKey(name: 'message_id') required this.messageId});
  factory _MessageCreated.fromJson(Map<String, dynamic> json) => _$MessageCreatedFromJson(json);

@override@JsonKey(name: 'message_id') final  int messageId;

/// Create a copy of MessageCreated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCreatedCopyWith<_MessageCreated> get copyWith => __$MessageCreatedCopyWithImpl<_MessageCreated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageCreatedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageCreated&&(identical(other.messageId, messageId) || other.messageId == messageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId);

@override
String toString() {
  return 'MessageCreated(messageId: $messageId)';
}


}

/// @nodoc
abstract mixin class _$MessageCreatedCopyWith<$Res> implements $MessageCreatedCopyWith<$Res> {
  factory _$MessageCreatedCopyWith(_MessageCreated value, $Res Function(_MessageCreated) _then) = __$MessageCreatedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message_id') int messageId
});




}
/// @nodoc
class __$MessageCreatedCopyWithImpl<$Res>
    implements _$MessageCreatedCopyWith<$Res> {
  __$MessageCreatedCopyWithImpl(this._self, this._then);

  final _MessageCreated _self;
  final $Res Function(_MessageCreated) _then;

/// Create a copy of MessageCreated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,}) {
  return _then(_MessageCreated(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
