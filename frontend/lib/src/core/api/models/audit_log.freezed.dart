// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditEvent {

@JsonKey(name: 'audit_event_id') int get auditEventId;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'request_id') String? get requestId;@JsonKey(name: 'actor_type') String get actorType;@JsonKey(name: 'actor_account_id') int? get actorAccountId;@JsonKey(name: 'actor_email') String? get actorEmail;@JsonKey(name: 'actor_name') String? get actorName;@JsonKey(name: 'ip_address') String? get ipAddress;@JsonKey(name: 'user_agent') String? get userAgent;@JsonKey(name: 'http_method') String? get httpMethod; String? get path; String get action;@JsonKey(name: 'resource_type') String get resourceType;@JsonKey(name: 'resource_id') String? get resourceId; String get status;@JsonKey(name: 'http_status_code') int? get httpStatusCode;@JsonKey(name: 'error_code') String? get errorCode; Map<String, dynamic>? get metadata;
/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEventCopyWith<AuditEvent> get copyWith => _$AuditEventCopyWithImpl<AuditEvent>(this as AuditEvent, _$identity);

  /// Serializes this AuditEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEvent&&(identical(other.auditEventId, auditEventId) || other.auditEventId == auditEventId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.actorAccountId, actorAccountId) || other.actorAccountId == actorAccountId)&&(identical(other.actorEmail, actorEmail) || other.actorEmail == actorEmail)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent)&&(identical(other.httpMethod, httpMethod) || other.httpMethod == httpMethod)&&(identical(other.path, path) || other.path == path)&&(identical(other.action, action) || other.action == action)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.httpStatusCode, httpStatusCode) || other.httpStatusCode == httpStatusCode)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,auditEventId,createdAt,requestId,actorType,actorAccountId,actorEmail,actorName,ipAddress,userAgent,httpMethod,path,action,resourceType,resourceId,status,httpStatusCode,errorCode,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'AuditEvent(auditEventId: $auditEventId, createdAt: $createdAt, requestId: $requestId, actorType: $actorType, actorAccountId: $actorAccountId, actorEmail: $actorEmail, actorName: $actorName, ipAddress: $ipAddress, userAgent: $userAgent, httpMethod: $httpMethod, path: $path, action: $action, resourceType: $resourceType, resourceId: $resourceId, status: $status, httpStatusCode: $httpStatusCode, errorCode: $errorCode, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AuditEventCopyWith<$Res>  {
  factory $AuditEventCopyWith(AuditEvent value, $Res Function(AuditEvent) _then) = _$AuditEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'audit_event_id') int auditEventId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'request_id') String? requestId,@JsonKey(name: 'actor_type') String actorType,@JsonKey(name: 'actor_account_id') int? actorAccountId,@JsonKey(name: 'actor_email') String? actorEmail,@JsonKey(name: 'actor_name') String? actorName,@JsonKey(name: 'ip_address') String? ipAddress,@JsonKey(name: 'user_agent') String? userAgent,@JsonKey(name: 'http_method') String? httpMethod, String? path, String action,@JsonKey(name: 'resource_type') String resourceType,@JsonKey(name: 'resource_id') String? resourceId, String status,@JsonKey(name: 'http_status_code') int? httpStatusCode,@JsonKey(name: 'error_code') String? errorCode, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$AuditEventCopyWithImpl<$Res>
    implements $AuditEventCopyWith<$Res> {
  _$AuditEventCopyWithImpl(this._self, this._then);

  final AuditEvent _self;
  final $Res Function(AuditEvent) _then;

/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? auditEventId = null,Object? createdAt = null,Object? requestId = freezed,Object? actorType = null,Object? actorAccountId = freezed,Object? actorEmail = freezed,Object? actorName = freezed,Object? ipAddress = freezed,Object? userAgent = freezed,Object? httpMethod = freezed,Object? path = freezed,Object? action = null,Object? resourceType = null,Object? resourceId = freezed,Object? status = null,Object? httpStatusCode = freezed,Object? errorCode = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
auditEventId: null == auditEventId ? _self.auditEventId : auditEventId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as String,actorAccountId: freezed == actorAccountId ? _self.actorAccountId : actorAccountId // ignore: cast_nullable_to_non_nullable
as int?,actorEmail: freezed == actorEmail ? _self.actorEmail : actorEmail // ignore: cast_nullable_to_non_nullable
as String?,actorName: freezed == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String?,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,httpMethod: freezed == httpMethod ? _self.httpMethod : httpMethod // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,httpStatusCode: freezed == httpStatusCode ? _self.httpStatusCode : httpStatusCode // ignore: cast_nullable_to_non_nullable
as int?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEvent].
extension AuditEventPatterns on AuditEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEvent value)  $default,){
final _that = this;
switch (_that) {
case _AuditEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'audit_event_id')  int auditEventId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'request_id')  String? requestId, @JsonKey(name: 'actor_type')  String actorType, @JsonKey(name: 'actor_account_id')  int? actorAccountId, @JsonKey(name: 'actor_email')  String? actorEmail, @JsonKey(name: 'actor_name')  String? actorName, @JsonKey(name: 'ip_address')  String? ipAddress, @JsonKey(name: 'user_agent')  String? userAgent, @JsonKey(name: 'http_method')  String? httpMethod,  String? path,  String action, @JsonKey(name: 'resource_type')  String resourceType, @JsonKey(name: 'resource_id')  String? resourceId,  String status, @JsonKey(name: 'http_status_code')  int? httpStatusCode, @JsonKey(name: 'error_code')  String? errorCode,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
return $default(_that.auditEventId,_that.createdAt,_that.requestId,_that.actorType,_that.actorAccountId,_that.actorEmail,_that.actorName,_that.ipAddress,_that.userAgent,_that.httpMethod,_that.path,_that.action,_that.resourceType,_that.resourceId,_that.status,_that.httpStatusCode,_that.errorCode,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'audit_event_id')  int auditEventId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'request_id')  String? requestId, @JsonKey(name: 'actor_type')  String actorType, @JsonKey(name: 'actor_account_id')  int? actorAccountId, @JsonKey(name: 'actor_email')  String? actorEmail, @JsonKey(name: 'actor_name')  String? actorName, @JsonKey(name: 'ip_address')  String? ipAddress, @JsonKey(name: 'user_agent')  String? userAgent, @JsonKey(name: 'http_method')  String? httpMethod,  String? path,  String action, @JsonKey(name: 'resource_type')  String resourceType, @JsonKey(name: 'resource_id')  String? resourceId,  String status, @JsonKey(name: 'http_status_code')  int? httpStatusCode, @JsonKey(name: 'error_code')  String? errorCode,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _AuditEvent():
return $default(_that.auditEventId,_that.createdAt,_that.requestId,_that.actorType,_that.actorAccountId,_that.actorEmail,_that.actorName,_that.ipAddress,_that.userAgent,_that.httpMethod,_that.path,_that.action,_that.resourceType,_that.resourceId,_that.status,_that.httpStatusCode,_that.errorCode,_that.metadata);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'audit_event_id')  int auditEventId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'request_id')  String? requestId, @JsonKey(name: 'actor_type')  String actorType, @JsonKey(name: 'actor_account_id')  int? actorAccountId, @JsonKey(name: 'actor_email')  String? actorEmail, @JsonKey(name: 'actor_name')  String? actorName, @JsonKey(name: 'ip_address')  String? ipAddress, @JsonKey(name: 'user_agent')  String? userAgent, @JsonKey(name: 'http_method')  String? httpMethod,  String? path,  String action, @JsonKey(name: 'resource_type')  String resourceType, @JsonKey(name: 'resource_id')  String? resourceId,  String status, @JsonKey(name: 'http_status_code')  int? httpStatusCode, @JsonKey(name: 'error_code')  String? errorCode,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _AuditEvent() when $default != null:
return $default(_that.auditEventId,_that.createdAt,_that.requestId,_that.actorType,_that.actorAccountId,_that.actorEmail,_that.actorName,_that.ipAddress,_that.userAgent,_that.httpMethod,_that.path,_that.action,_that.resourceType,_that.resourceId,_that.status,_that.httpStatusCode,_that.errorCode,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditEvent implements AuditEvent {
  const _AuditEvent({@JsonKey(name: 'audit_event_id') required this.auditEventId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'request_id') this.requestId, @JsonKey(name: 'actor_type') required this.actorType, @JsonKey(name: 'actor_account_id') this.actorAccountId, @JsonKey(name: 'actor_email') this.actorEmail, @JsonKey(name: 'actor_name') this.actorName, @JsonKey(name: 'ip_address') this.ipAddress, @JsonKey(name: 'user_agent') this.userAgent, @JsonKey(name: 'http_method') this.httpMethod, this.path, required this.action, @JsonKey(name: 'resource_type') required this.resourceType, @JsonKey(name: 'resource_id') this.resourceId, required this.status, @JsonKey(name: 'http_status_code') this.httpStatusCode, @JsonKey(name: 'error_code') this.errorCode, final  Map<String, dynamic>? metadata}): _metadata = metadata;
  factory _AuditEvent.fromJson(Map<String, dynamic> json) => _$AuditEventFromJson(json);

@override@JsonKey(name: 'audit_event_id') final  int auditEventId;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'request_id') final  String? requestId;
@override@JsonKey(name: 'actor_type') final  String actorType;
@override@JsonKey(name: 'actor_account_id') final  int? actorAccountId;
@override@JsonKey(name: 'actor_email') final  String? actorEmail;
@override@JsonKey(name: 'actor_name') final  String? actorName;
@override@JsonKey(name: 'ip_address') final  String? ipAddress;
@override@JsonKey(name: 'user_agent') final  String? userAgent;
@override@JsonKey(name: 'http_method') final  String? httpMethod;
@override final  String? path;
@override final  String action;
@override@JsonKey(name: 'resource_type') final  String resourceType;
@override@JsonKey(name: 'resource_id') final  String? resourceId;
@override final  String status;
@override@JsonKey(name: 'http_status_code') final  int? httpStatusCode;
@override@JsonKey(name: 'error_code') final  String? errorCode;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEventCopyWith<_AuditEvent> get copyWith => __$AuditEventCopyWithImpl<_AuditEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEvent&&(identical(other.auditEventId, auditEventId) || other.auditEventId == auditEventId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.actorAccountId, actorAccountId) || other.actorAccountId == actorAccountId)&&(identical(other.actorEmail, actorEmail) || other.actorEmail == actorEmail)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent)&&(identical(other.httpMethod, httpMethod) || other.httpMethod == httpMethod)&&(identical(other.path, path) || other.path == path)&&(identical(other.action, action) || other.action == action)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.httpStatusCode, httpStatusCode) || other.httpStatusCode == httpStatusCode)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,auditEventId,createdAt,requestId,actorType,actorAccountId,actorEmail,actorName,ipAddress,userAgent,httpMethod,path,action,resourceType,resourceId,status,httpStatusCode,errorCode,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'AuditEvent(auditEventId: $auditEventId, createdAt: $createdAt, requestId: $requestId, actorType: $actorType, actorAccountId: $actorAccountId, actorEmail: $actorEmail, actorName: $actorName, ipAddress: $ipAddress, userAgent: $userAgent, httpMethod: $httpMethod, path: $path, action: $action, resourceType: $resourceType, resourceId: $resourceId, status: $status, httpStatusCode: $httpStatusCode, errorCode: $errorCode, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AuditEventCopyWith<$Res> implements $AuditEventCopyWith<$Res> {
  factory _$AuditEventCopyWith(_AuditEvent value, $Res Function(_AuditEvent) _then) = __$AuditEventCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'audit_event_id') int auditEventId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'request_id') String? requestId,@JsonKey(name: 'actor_type') String actorType,@JsonKey(name: 'actor_account_id') int? actorAccountId,@JsonKey(name: 'actor_email') String? actorEmail,@JsonKey(name: 'actor_name') String? actorName,@JsonKey(name: 'ip_address') String? ipAddress,@JsonKey(name: 'user_agent') String? userAgent,@JsonKey(name: 'http_method') String? httpMethod, String? path, String action,@JsonKey(name: 'resource_type') String resourceType,@JsonKey(name: 'resource_id') String? resourceId, String status,@JsonKey(name: 'http_status_code') int? httpStatusCode,@JsonKey(name: 'error_code') String? errorCode, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$AuditEventCopyWithImpl<$Res>
    implements _$AuditEventCopyWith<$Res> {
  __$AuditEventCopyWithImpl(this._self, this._then);

  final _AuditEvent _self;
  final $Res Function(_AuditEvent) _then;

/// Create a copy of AuditEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? auditEventId = null,Object? createdAt = null,Object? requestId = freezed,Object? actorType = null,Object? actorAccountId = freezed,Object? actorEmail = freezed,Object? actorName = freezed,Object? ipAddress = freezed,Object? userAgent = freezed,Object? httpMethod = freezed,Object? path = freezed,Object? action = null,Object? resourceType = null,Object? resourceId = freezed,Object? status = null,Object? httpStatusCode = freezed,Object? errorCode = freezed,Object? metadata = freezed,}) {
  return _then(_AuditEvent(
auditEventId: null == auditEventId ? _self.auditEventId : auditEventId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as String,actorAccountId: freezed == actorAccountId ? _self.actorAccountId : actorAccountId // ignore: cast_nullable_to_non_nullable
as int?,actorEmail: freezed == actorEmail ? _self.actorEmail : actorEmail // ignore: cast_nullable_to_non_nullable
as String?,actorName: freezed == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String?,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,httpMethod: freezed == httpMethod ? _self.httpMethod : httpMethod // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,httpStatusCode: freezed == httpStatusCode ? _self.httpStatusCode : httpStatusCode // ignore: cast_nullable_to_non_nullable
as int?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$AuditLogResponse {

 List<AuditEvent> get events; int get total; int get limit; int get offset;
/// Create a copy of AuditLogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogResponseCopyWith<AuditLogResponse> get copyWith => _$AuditLogResponseCopyWithImpl<AuditLogResponse>(this as AuditLogResponse, _$identity);

  /// Serializes this AuditLogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLogResponse&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(events),total,limit,offset);

@override
String toString() {
  return 'AuditLogResponse(events: $events, total: $total, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $AuditLogResponseCopyWith<$Res>  {
  factory $AuditLogResponseCopyWith(AuditLogResponse value, $Res Function(AuditLogResponse) _then) = _$AuditLogResponseCopyWithImpl;
@useResult
$Res call({
 List<AuditEvent> events, int total, int limit, int offset
});




}
/// @nodoc
class _$AuditLogResponseCopyWithImpl<$Res>
    implements $AuditLogResponseCopyWith<$Res> {
  _$AuditLogResponseCopyWithImpl(this._self, this._then);

  final AuditLogResponse _self;
  final $Res Function(AuditLogResponse) _then;

/// Create a copy of AuditLogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? events = null,Object? total = null,Object? limit = null,Object? offset = null,}) {
  return _then(_self.copyWith(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<AuditEvent>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLogResponse].
extension AuditLogResponsePatterns on AuditLogResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLogResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLogResponse value)  $default,){
final _that = this;
switch (_that) {
case _AuditLogResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLogResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AuditEvent> events,  int total,  int limit,  int offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLogResponse() when $default != null:
return $default(_that.events,_that.total,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AuditEvent> events,  int total,  int limit,  int offset)  $default,) {final _that = this;
switch (_that) {
case _AuditLogResponse():
return $default(_that.events,_that.total,_that.limit,_that.offset);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AuditEvent> events,  int total,  int limit,  int offset)?  $default,) {final _that = this;
switch (_that) {
case _AuditLogResponse() when $default != null:
return $default(_that.events,_that.total,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AuditLogResponse implements AuditLogResponse {
  const _AuditLogResponse({required final  List<AuditEvent> events, required this.total, required this.limit, required this.offset}): _events = events;
  factory _AuditLogResponse.fromJson(Map<String, dynamic> json) => _$AuditLogResponseFromJson(json);

 final  List<AuditEvent> _events;
@override List<AuditEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  int total;
@override final  int limit;
@override final  int offset;

/// Create a copy of AuditLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogResponseCopyWith<_AuditLogResponse> get copyWith => __$AuditLogResponseCopyWithImpl<_AuditLogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLogResponse&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_events),total,limit,offset);

@override
String toString() {
  return 'AuditLogResponse(events: $events, total: $total, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$AuditLogResponseCopyWith<$Res> implements $AuditLogResponseCopyWith<$Res> {
  factory _$AuditLogResponseCopyWith(_AuditLogResponse value, $Res Function(_AuditLogResponse) _then) = __$AuditLogResponseCopyWithImpl;
@override @useResult
$Res call({
 List<AuditEvent> events, int total, int limit, int offset
});




}
/// @nodoc
class __$AuditLogResponseCopyWithImpl<$Res>
    implements _$AuditLogResponseCopyWith<$Res> {
  __$AuditLogResponseCopyWithImpl(this._self, this._then);

  final _AuditLogResponse _self;
  final $Res Function(_AuditLogResponse) _then;

/// Create a copy of AuditLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? events = null,Object? total = null,Object? limit = null,Object? offset = null,}) {
  return _then(_AuditLogResponse(
events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<AuditEvent>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
