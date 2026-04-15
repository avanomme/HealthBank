// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'impersonation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImpersonatedUserInfo {

@JsonKey(name: 'account_id') int get accountId;@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName; String get email; String get role;
/// Create a copy of ImpersonatedUserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImpersonatedUserInfoCopyWith<ImpersonatedUserInfo> get copyWith => _$ImpersonatedUserInfoCopyWithImpl<ImpersonatedUserInfo>(this as ImpersonatedUserInfo, _$identity);

  /// Serializes this ImpersonatedUserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImpersonatedUserInfo&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,firstName,lastName,email,role);

@override
String toString() {
  return 'ImpersonatedUserInfo(accountId: $accountId, firstName: $firstName, lastName: $lastName, email: $email, role: $role)';
}


}

/// @nodoc
abstract mixin class $ImpersonatedUserInfoCopyWith<$Res>  {
  factory $ImpersonatedUserInfoCopyWith(ImpersonatedUserInfo value, $Res Function(ImpersonatedUserInfo) _then) = _$ImpersonatedUserInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String email, String role
});




}
/// @nodoc
class _$ImpersonatedUserInfoCopyWithImpl<$Res>
    implements $ImpersonatedUserInfoCopyWith<$Res> {
  _$ImpersonatedUserInfoCopyWithImpl(this._self, this._then);

  final ImpersonatedUserInfo _self;
  final $Res Function(ImpersonatedUserInfo) _then;

/// Create a copy of ImpersonatedUserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? firstName = freezed,Object? lastName = freezed,Object? email = null,Object? role = null,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ImpersonatedUserInfo].
extension ImpersonatedUserInfoPatterns on ImpersonatedUserInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImpersonatedUserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImpersonatedUserInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImpersonatedUserInfo value)  $default,){
final _that = this;
switch (_that) {
case _ImpersonatedUserInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImpersonatedUserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ImpersonatedUserInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String email,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImpersonatedUserInfo() when $default != null:
return $default(_that.accountId,_that.firstName,_that.lastName,_that.email,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String email,  String role)  $default,) {final _that = this;
switch (_that) {
case _ImpersonatedUserInfo():
return $default(_that.accountId,_that.firstName,_that.lastName,_that.email,_that.role);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String email,  String role)?  $default,) {final _that = this;
switch (_that) {
case _ImpersonatedUserInfo() when $default != null:
return $default(_that.accountId,_that.firstName,_that.lastName,_that.email,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImpersonatedUserInfo implements ImpersonatedUserInfo {
  const _ImpersonatedUserInfo({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, required this.email, required this.role});
  factory _ImpersonatedUserInfo.fromJson(Map<String, dynamic> json) => _$ImpersonatedUserInfoFromJson(json);

@override@JsonKey(name: 'account_id') final  int accountId;
@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String email;
@override final  String role;

/// Create a copy of ImpersonatedUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImpersonatedUserInfoCopyWith<_ImpersonatedUserInfo> get copyWith => __$ImpersonatedUserInfoCopyWithImpl<_ImpersonatedUserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImpersonatedUserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImpersonatedUserInfo&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,firstName,lastName,email,role);

@override
String toString() {
  return 'ImpersonatedUserInfo(accountId: $accountId, firstName: $firstName, lastName: $lastName, email: $email, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ImpersonatedUserInfoCopyWith<$Res> implements $ImpersonatedUserInfoCopyWith<$Res> {
  factory _$ImpersonatedUserInfoCopyWith(_ImpersonatedUserInfo value, $Res Function(_ImpersonatedUserInfo) _then) = __$ImpersonatedUserInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String email, String role
});




}
/// @nodoc
class __$ImpersonatedUserInfoCopyWithImpl<$Res>
    implements _$ImpersonatedUserInfoCopyWith<$Res> {
  __$ImpersonatedUserInfoCopyWithImpl(this._self, this._then);

  final _ImpersonatedUserInfo _self;
  final $Res Function(_ImpersonatedUserInfo) _then;

/// Create a copy of ImpersonatedUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? firstName = freezed,Object? lastName = freezed,Object? email = null,Object? role = null,}) {
  return _then(_ImpersonatedUserInfo(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ImpersonateResponse {

 String get message;@JsonKey(name: 'session_token') String get sessionToken;@JsonKey(name: 'expires_at') String get expiresAt;@JsonKey(name: 'is_impersonating') bool get isImpersonating;@JsonKey(name: 'impersonated_user') ImpersonatedUserInfo get impersonatedUser;@JsonKey(name: 'admin_account_id') int get adminAccountId;
/// Create a copy of ImpersonateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImpersonateResponseCopyWith<ImpersonateResponse> get copyWith => _$ImpersonateResponseCopyWithImpl<ImpersonateResponse>(this as ImpersonateResponse, _$identity);

  /// Serializes this ImpersonateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImpersonateResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isImpersonating, isImpersonating) || other.isImpersonating == isImpersonating)&&(identical(other.impersonatedUser, impersonatedUser) || other.impersonatedUser == impersonatedUser)&&(identical(other.adminAccountId, adminAccountId) || other.adminAccountId == adminAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,sessionToken,expiresAt,isImpersonating,impersonatedUser,adminAccountId);

@override
String toString() {
  return 'ImpersonateResponse(message: $message, sessionToken: $sessionToken, expiresAt: $expiresAt, isImpersonating: $isImpersonating, impersonatedUser: $impersonatedUser, adminAccountId: $adminAccountId)';
}


}

/// @nodoc
abstract mixin class $ImpersonateResponseCopyWith<$Res>  {
  factory $ImpersonateResponseCopyWith(ImpersonateResponse value, $Res Function(ImpersonateResponse) _then) = _$ImpersonateResponseCopyWithImpl;
@useResult
$Res call({
 String message,@JsonKey(name: 'session_token') String sessionToken,@JsonKey(name: 'expires_at') String expiresAt,@JsonKey(name: 'is_impersonating') bool isImpersonating,@JsonKey(name: 'impersonated_user') ImpersonatedUserInfo impersonatedUser,@JsonKey(name: 'admin_account_id') int adminAccountId
});


$ImpersonatedUserInfoCopyWith<$Res> get impersonatedUser;

}
/// @nodoc
class _$ImpersonateResponseCopyWithImpl<$Res>
    implements $ImpersonateResponseCopyWith<$Res> {
  _$ImpersonateResponseCopyWithImpl(this._self, this._then);

  final ImpersonateResponse _self;
  final $Res Function(ImpersonateResponse) _then;

/// Create a copy of ImpersonateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? sessionToken = null,Object? expiresAt = null,Object? isImpersonating = null,Object? impersonatedUser = null,Object? adminAccountId = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sessionToken: null == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,isImpersonating: null == isImpersonating ? _self.isImpersonating : isImpersonating // ignore: cast_nullable_to_non_nullable
as bool,impersonatedUser: null == impersonatedUser ? _self.impersonatedUser : impersonatedUser // ignore: cast_nullable_to_non_nullable
as ImpersonatedUserInfo,adminAccountId: null == adminAccountId ? _self.adminAccountId : adminAccountId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ImpersonateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImpersonatedUserInfoCopyWith<$Res> get impersonatedUser {
  
  return $ImpersonatedUserInfoCopyWith<$Res>(_self.impersonatedUser, (value) {
    return _then(_self.copyWith(impersonatedUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [ImpersonateResponse].
extension ImpersonateResponsePatterns on ImpersonateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImpersonateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImpersonateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImpersonateResponse value)  $default,){
final _that = this;
switch (_that) {
case _ImpersonateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImpersonateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ImpersonateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'session_token')  String sessionToken, @JsonKey(name: 'expires_at')  String expiresAt, @JsonKey(name: 'is_impersonating')  bool isImpersonating, @JsonKey(name: 'impersonated_user')  ImpersonatedUserInfo impersonatedUser, @JsonKey(name: 'admin_account_id')  int adminAccountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImpersonateResponse() when $default != null:
return $default(_that.message,_that.sessionToken,_that.expiresAt,_that.isImpersonating,_that.impersonatedUser,_that.adminAccountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'session_token')  String sessionToken, @JsonKey(name: 'expires_at')  String expiresAt, @JsonKey(name: 'is_impersonating')  bool isImpersonating, @JsonKey(name: 'impersonated_user')  ImpersonatedUserInfo impersonatedUser, @JsonKey(name: 'admin_account_id')  int adminAccountId)  $default,) {final _that = this;
switch (_that) {
case _ImpersonateResponse():
return $default(_that.message,_that.sessionToken,_that.expiresAt,_that.isImpersonating,_that.impersonatedUser,_that.adminAccountId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message, @JsonKey(name: 'session_token')  String sessionToken, @JsonKey(name: 'expires_at')  String expiresAt, @JsonKey(name: 'is_impersonating')  bool isImpersonating, @JsonKey(name: 'impersonated_user')  ImpersonatedUserInfo impersonatedUser, @JsonKey(name: 'admin_account_id')  int adminAccountId)?  $default,) {final _that = this;
switch (_that) {
case _ImpersonateResponse() when $default != null:
return $default(_that.message,_that.sessionToken,_that.expiresAt,_that.isImpersonating,_that.impersonatedUser,_that.adminAccountId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ImpersonateResponse implements ImpersonateResponse {
  const _ImpersonateResponse({required this.message, @JsonKey(name: 'session_token') required this.sessionToken, @JsonKey(name: 'expires_at') required this.expiresAt, @JsonKey(name: 'is_impersonating') required this.isImpersonating, @JsonKey(name: 'impersonated_user') required this.impersonatedUser, @JsonKey(name: 'admin_account_id') required this.adminAccountId});
  factory _ImpersonateResponse.fromJson(Map<String, dynamic> json) => _$ImpersonateResponseFromJson(json);

@override final  String message;
@override@JsonKey(name: 'session_token') final  String sessionToken;
@override@JsonKey(name: 'expires_at') final  String expiresAt;
@override@JsonKey(name: 'is_impersonating') final  bool isImpersonating;
@override@JsonKey(name: 'impersonated_user') final  ImpersonatedUserInfo impersonatedUser;
@override@JsonKey(name: 'admin_account_id') final  int adminAccountId;

/// Create a copy of ImpersonateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImpersonateResponseCopyWith<_ImpersonateResponse> get copyWith => __$ImpersonateResponseCopyWithImpl<_ImpersonateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImpersonateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImpersonateResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isImpersonating, isImpersonating) || other.isImpersonating == isImpersonating)&&(identical(other.impersonatedUser, impersonatedUser) || other.impersonatedUser == impersonatedUser)&&(identical(other.adminAccountId, adminAccountId) || other.adminAccountId == adminAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,sessionToken,expiresAt,isImpersonating,impersonatedUser,adminAccountId);

@override
String toString() {
  return 'ImpersonateResponse(message: $message, sessionToken: $sessionToken, expiresAt: $expiresAt, isImpersonating: $isImpersonating, impersonatedUser: $impersonatedUser, adminAccountId: $adminAccountId)';
}


}

/// @nodoc
abstract mixin class _$ImpersonateResponseCopyWith<$Res> implements $ImpersonateResponseCopyWith<$Res> {
  factory _$ImpersonateResponseCopyWith(_ImpersonateResponse value, $Res Function(_ImpersonateResponse) _then) = __$ImpersonateResponseCopyWithImpl;
@override @useResult
$Res call({
 String message,@JsonKey(name: 'session_token') String sessionToken,@JsonKey(name: 'expires_at') String expiresAt,@JsonKey(name: 'is_impersonating') bool isImpersonating,@JsonKey(name: 'impersonated_user') ImpersonatedUserInfo impersonatedUser,@JsonKey(name: 'admin_account_id') int adminAccountId
});


@override $ImpersonatedUserInfoCopyWith<$Res> get impersonatedUser;

}
/// @nodoc
class __$ImpersonateResponseCopyWithImpl<$Res>
    implements _$ImpersonateResponseCopyWith<$Res> {
  __$ImpersonateResponseCopyWithImpl(this._self, this._then);

  final _ImpersonateResponse _self;
  final $Res Function(_ImpersonateResponse) _then;

/// Create a copy of ImpersonateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? sessionToken = null,Object? expiresAt = null,Object? isImpersonating = null,Object? impersonatedUser = null,Object? adminAccountId = null,}) {
  return _then(_ImpersonateResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sessionToken: null == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,isImpersonating: null == isImpersonating ? _self.isImpersonating : isImpersonating // ignore: cast_nullable_to_non_nullable
as bool,impersonatedUser: null == impersonatedUser ? _self.impersonatedUser : impersonatedUser // ignore: cast_nullable_to_non_nullable
as ImpersonatedUserInfo,adminAccountId: null == adminAccountId ? _self.adminAccountId : adminAccountId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ImpersonateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImpersonatedUserInfoCopyWith<$Res> get impersonatedUser {
  
  return $ImpersonatedUserInfoCopyWith<$Res>(_self.impersonatedUser, (value) {
    return _then(_self.copyWith(impersonatedUser: value));
  });
}
}


/// @nodoc
mixin _$EndImpersonationResponse {

 String get message;@JsonKey(name: 'admin_account_id') int get adminAccountId;
/// Create a copy of EndImpersonationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndImpersonationResponseCopyWith<EndImpersonationResponse> get copyWith => _$EndImpersonationResponseCopyWithImpl<EndImpersonationResponse>(this as EndImpersonationResponse, _$identity);

  /// Serializes this EndImpersonationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndImpersonationResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.adminAccountId, adminAccountId) || other.adminAccountId == adminAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,adminAccountId);

@override
String toString() {
  return 'EndImpersonationResponse(message: $message, adminAccountId: $adminAccountId)';
}


}

/// @nodoc
abstract mixin class $EndImpersonationResponseCopyWith<$Res>  {
  factory $EndImpersonationResponseCopyWith(EndImpersonationResponse value, $Res Function(EndImpersonationResponse) _then) = _$EndImpersonationResponseCopyWithImpl;
@useResult
$Res call({
 String message,@JsonKey(name: 'admin_account_id') int adminAccountId
});




}
/// @nodoc
class _$EndImpersonationResponseCopyWithImpl<$Res>
    implements $EndImpersonationResponseCopyWith<$Res> {
  _$EndImpersonationResponseCopyWithImpl(this._self, this._then);

  final EndImpersonationResponse _self;
  final $Res Function(EndImpersonationResponse) _then;

/// Create a copy of EndImpersonationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? adminAccountId = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,adminAccountId: null == adminAccountId ? _self.adminAccountId : adminAccountId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EndImpersonationResponse].
extension EndImpersonationResponsePatterns on EndImpersonationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EndImpersonationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EndImpersonationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EndImpersonationResponse value)  $default,){
final _that = this;
switch (_that) {
case _EndImpersonationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EndImpersonationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EndImpersonationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'admin_account_id')  int adminAccountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EndImpersonationResponse() when $default != null:
return $default(_that.message,_that.adminAccountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'admin_account_id')  int adminAccountId)  $default,) {final _that = this;
switch (_that) {
case _EndImpersonationResponse():
return $default(_that.message,_that.adminAccountId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message, @JsonKey(name: 'admin_account_id')  int adminAccountId)?  $default,) {final _that = this;
switch (_that) {
case _EndImpersonationResponse() when $default != null:
return $default(_that.message,_that.adminAccountId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EndImpersonationResponse implements EndImpersonationResponse {
  const _EndImpersonationResponse({required this.message, @JsonKey(name: 'admin_account_id') required this.adminAccountId});
  factory _EndImpersonationResponse.fromJson(Map<String, dynamic> json) => _$EndImpersonationResponseFromJson(json);

@override final  String message;
@override@JsonKey(name: 'admin_account_id') final  int adminAccountId;

/// Create a copy of EndImpersonationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndImpersonationResponseCopyWith<_EndImpersonationResponse> get copyWith => __$EndImpersonationResponseCopyWithImpl<_EndImpersonationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EndImpersonationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndImpersonationResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.adminAccountId, adminAccountId) || other.adminAccountId == adminAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,adminAccountId);

@override
String toString() {
  return 'EndImpersonationResponse(message: $message, adminAccountId: $adminAccountId)';
}


}

/// @nodoc
abstract mixin class _$EndImpersonationResponseCopyWith<$Res> implements $EndImpersonationResponseCopyWith<$Res> {
  factory _$EndImpersonationResponseCopyWith(_EndImpersonationResponse value, $Res Function(_EndImpersonationResponse) _then) = __$EndImpersonationResponseCopyWithImpl;
@override @useResult
$Res call({
 String message,@JsonKey(name: 'admin_account_id') int adminAccountId
});




}
/// @nodoc
class __$EndImpersonationResponseCopyWithImpl<$Res>
    implements _$EndImpersonationResponseCopyWith<$Res> {
  __$EndImpersonationResponseCopyWithImpl(this._self, this._then);

  final _EndImpersonationResponse _self;
  final $Res Function(_EndImpersonationResponse) _then;

/// Create a copy of EndImpersonationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? adminAccountId = null,}) {
  return _then(_EndImpersonationResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,adminAccountId: null == adminAccountId ? _self.adminAccountId : adminAccountId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SessionUserInfo {

@JsonKey(name: 'account_id') int get accountId;@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName; String get email; String get role;@JsonKey(name: 'role_id') int get roleId;@JsonKey(name: 'birthdate') String? get birthdate;@JsonKey(name: 'gender') String? get gender;
/// Create a copy of SessionUserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionUserInfoCopyWith<SessionUserInfo> get copyWith => _$SessionUserInfoCopyWithImpl<SessionUserInfo>(this as SessionUserInfo, _$identity);

  /// Serializes this SessionUserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionUserInfo&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,firstName,lastName,email,role,roleId,birthdate,gender);

@override
String toString() {
  return 'SessionUserInfo(accountId: $accountId, firstName: $firstName, lastName: $lastName, email: $email, role: $role, roleId: $roleId, birthdate: $birthdate, gender: $gender)';
}


}

/// @nodoc
abstract mixin class $SessionUserInfoCopyWith<$Res>  {
  factory $SessionUserInfoCopyWith(SessionUserInfo value, $Res Function(SessionUserInfo) _then) = _$SessionUserInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String email, String role,@JsonKey(name: 'role_id') int roleId,@JsonKey(name: 'birthdate') String? birthdate,@JsonKey(name: 'gender') String? gender
});




}
/// @nodoc
class _$SessionUserInfoCopyWithImpl<$Res>
    implements $SessionUserInfoCopyWith<$Res> {
  _$SessionUserInfoCopyWithImpl(this._self, this._then);

  final SessionUserInfo _self;
  final $Res Function(SessionUserInfo) _then;

/// Create a copy of SessionUserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? firstName = freezed,Object? lastName = freezed,Object? email = null,Object? role = null,Object? roleId = null,Object? birthdate = freezed,Object? gender = freezed,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionUserInfo].
extension SessionUserInfoPatterns on SessionUserInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionUserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionUserInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionUserInfo value)  $default,){
final _that = this;
switch (_that) {
case _SessionUserInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionUserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SessionUserInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String email,  String role, @JsonKey(name: 'role_id')  int roleId, @JsonKey(name: 'birthdate')  String? birthdate, @JsonKey(name: 'gender')  String? gender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionUserInfo() when $default != null:
return $default(_that.accountId,_that.firstName,_that.lastName,_that.email,_that.role,_that.roleId,_that.birthdate,_that.gender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String email,  String role, @JsonKey(name: 'role_id')  int roleId, @JsonKey(name: 'birthdate')  String? birthdate, @JsonKey(name: 'gender')  String? gender)  $default,) {final _that = this;
switch (_that) {
case _SessionUserInfo():
return $default(_that.accountId,_that.firstName,_that.lastName,_that.email,_that.role,_that.roleId,_that.birthdate,_that.gender);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String email,  String role, @JsonKey(name: 'role_id')  int roleId, @JsonKey(name: 'birthdate')  String? birthdate, @JsonKey(name: 'gender')  String? gender)?  $default,) {final _that = this;
switch (_that) {
case _SessionUserInfo() when $default != null:
return $default(_that.accountId,_that.firstName,_that.lastName,_that.email,_that.role,_that.roleId,_that.birthdate,_that.gender);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionUserInfo implements SessionUserInfo {
  const _SessionUserInfo({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, required this.email, required this.role, @JsonKey(name: 'role_id') required this.roleId, @JsonKey(name: 'birthdate') this.birthdate, @JsonKey(name: 'gender') this.gender});
  factory _SessionUserInfo.fromJson(Map<String, dynamic> json) => _$SessionUserInfoFromJson(json);

@override@JsonKey(name: 'account_id') final  int accountId;
@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String email;
@override final  String role;
@override@JsonKey(name: 'role_id') final  int roleId;
@override@JsonKey(name: 'birthdate') final  String? birthdate;
@override@JsonKey(name: 'gender') final  String? gender;

/// Create a copy of SessionUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionUserInfoCopyWith<_SessionUserInfo> get copyWith => __$SessionUserInfoCopyWithImpl<_SessionUserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionUserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionUserInfo&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,firstName,lastName,email,role,roleId,birthdate,gender);

@override
String toString() {
  return 'SessionUserInfo(accountId: $accountId, firstName: $firstName, lastName: $lastName, email: $email, role: $role, roleId: $roleId, birthdate: $birthdate, gender: $gender)';
}


}

/// @nodoc
abstract mixin class _$SessionUserInfoCopyWith<$Res> implements $SessionUserInfoCopyWith<$Res> {
  factory _$SessionUserInfoCopyWith(_SessionUserInfo value, $Res Function(_SessionUserInfo) _then) = __$SessionUserInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String email, String role,@JsonKey(name: 'role_id') int roleId,@JsonKey(name: 'birthdate') String? birthdate,@JsonKey(name: 'gender') String? gender
});




}
/// @nodoc
class __$SessionUserInfoCopyWithImpl<$Res>
    implements _$SessionUserInfoCopyWith<$Res> {
  __$SessionUserInfoCopyWithImpl(this._self, this._then);

  final _SessionUserInfo _self;
  final $Res Function(_SessionUserInfo) _then;

/// Create a copy of SessionUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? firstName = freezed,Object? lastName = freezed,Object? email = null,Object? role = null,Object? roleId = null,Object? birthdate = freezed,Object? gender = freezed,}) {
  return _then(_SessionUserInfo(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ImpersonationInfo {

@JsonKey(name: 'admin_account_id') int get adminAccountId;@JsonKey(name: 'admin_first_name') String? get adminFirstName;@JsonKey(name: 'admin_last_name') String? get adminLastName;@JsonKey(name: 'admin_email') String get adminEmail;
/// Create a copy of ImpersonationInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImpersonationInfoCopyWith<ImpersonationInfo> get copyWith => _$ImpersonationInfoCopyWithImpl<ImpersonationInfo>(this as ImpersonationInfo, _$identity);

  /// Serializes this ImpersonationInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImpersonationInfo&&(identical(other.adminAccountId, adminAccountId) || other.adminAccountId == adminAccountId)&&(identical(other.adminFirstName, adminFirstName) || other.adminFirstName == adminFirstName)&&(identical(other.adminLastName, adminLastName) || other.adminLastName == adminLastName)&&(identical(other.adminEmail, adminEmail) || other.adminEmail == adminEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adminAccountId,adminFirstName,adminLastName,adminEmail);

@override
String toString() {
  return 'ImpersonationInfo(adminAccountId: $adminAccountId, adminFirstName: $adminFirstName, adminLastName: $adminLastName, adminEmail: $adminEmail)';
}


}

/// @nodoc
abstract mixin class $ImpersonationInfoCopyWith<$Res>  {
  factory $ImpersonationInfoCopyWith(ImpersonationInfo value, $Res Function(ImpersonationInfo) _then) = _$ImpersonationInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'admin_account_id') int adminAccountId,@JsonKey(name: 'admin_first_name') String? adminFirstName,@JsonKey(name: 'admin_last_name') String? adminLastName,@JsonKey(name: 'admin_email') String adminEmail
});




}
/// @nodoc
class _$ImpersonationInfoCopyWithImpl<$Res>
    implements $ImpersonationInfoCopyWith<$Res> {
  _$ImpersonationInfoCopyWithImpl(this._self, this._then);

  final ImpersonationInfo _self;
  final $Res Function(ImpersonationInfo) _then;

/// Create a copy of ImpersonationInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adminAccountId = null,Object? adminFirstName = freezed,Object? adminLastName = freezed,Object? adminEmail = null,}) {
  return _then(_self.copyWith(
adminAccountId: null == adminAccountId ? _self.adminAccountId : adminAccountId // ignore: cast_nullable_to_non_nullable
as int,adminFirstName: freezed == adminFirstName ? _self.adminFirstName : adminFirstName // ignore: cast_nullable_to_non_nullable
as String?,adminLastName: freezed == adminLastName ? _self.adminLastName : adminLastName // ignore: cast_nullable_to_non_nullable
as String?,adminEmail: null == adminEmail ? _self.adminEmail : adminEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ImpersonationInfo].
extension ImpersonationInfoPatterns on ImpersonationInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImpersonationInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImpersonationInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImpersonationInfo value)  $default,){
final _that = this;
switch (_that) {
case _ImpersonationInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImpersonationInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ImpersonationInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'admin_account_id')  int adminAccountId, @JsonKey(name: 'admin_first_name')  String? adminFirstName, @JsonKey(name: 'admin_last_name')  String? adminLastName, @JsonKey(name: 'admin_email')  String adminEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImpersonationInfo() when $default != null:
return $default(_that.adminAccountId,_that.adminFirstName,_that.adminLastName,_that.adminEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'admin_account_id')  int adminAccountId, @JsonKey(name: 'admin_first_name')  String? adminFirstName, @JsonKey(name: 'admin_last_name')  String? adminLastName, @JsonKey(name: 'admin_email')  String adminEmail)  $default,) {final _that = this;
switch (_that) {
case _ImpersonationInfo():
return $default(_that.adminAccountId,_that.adminFirstName,_that.adminLastName,_that.adminEmail);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'admin_account_id')  int adminAccountId, @JsonKey(name: 'admin_first_name')  String? adminFirstName, @JsonKey(name: 'admin_last_name')  String? adminLastName, @JsonKey(name: 'admin_email')  String adminEmail)?  $default,) {final _that = this;
switch (_that) {
case _ImpersonationInfo() when $default != null:
return $default(_that.adminAccountId,_that.adminFirstName,_that.adminLastName,_that.adminEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImpersonationInfo implements ImpersonationInfo {
  const _ImpersonationInfo({@JsonKey(name: 'admin_account_id') required this.adminAccountId, @JsonKey(name: 'admin_first_name') this.adminFirstName, @JsonKey(name: 'admin_last_name') this.adminLastName, @JsonKey(name: 'admin_email') required this.adminEmail});
  factory _ImpersonationInfo.fromJson(Map<String, dynamic> json) => _$ImpersonationInfoFromJson(json);

@override@JsonKey(name: 'admin_account_id') final  int adminAccountId;
@override@JsonKey(name: 'admin_first_name') final  String? adminFirstName;
@override@JsonKey(name: 'admin_last_name') final  String? adminLastName;
@override@JsonKey(name: 'admin_email') final  String adminEmail;

/// Create a copy of ImpersonationInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImpersonationInfoCopyWith<_ImpersonationInfo> get copyWith => __$ImpersonationInfoCopyWithImpl<_ImpersonationInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImpersonationInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImpersonationInfo&&(identical(other.adminAccountId, adminAccountId) || other.adminAccountId == adminAccountId)&&(identical(other.adminFirstName, adminFirstName) || other.adminFirstName == adminFirstName)&&(identical(other.adminLastName, adminLastName) || other.adminLastName == adminLastName)&&(identical(other.adminEmail, adminEmail) || other.adminEmail == adminEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adminAccountId,adminFirstName,adminLastName,adminEmail);

@override
String toString() {
  return 'ImpersonationInfo(adminAccountId: $adminAccountId, adminFirstName: $adminFirstName, adminLastName: $adminLastName, adminEmail: $adminEmail)';
}


}

/// @nodoc
abstract mixin class _$ImpersonationInfoCopyWith<$Res> implements $ImpersonationInfoCopyWith<$Res> {
  factory _$ImpersonationInfoCopyWith(_ImpersonationInfo value, $Res Function(_ImpersonationInfo) _then) = __$ImpersonationInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'admin_account_id') int adminAccountId,@JsonKey(name: 'admin_first_name') String? adminFirstName,@JsonKey(name: 'admin_last_name') String? adminLastName,@JsonKey(name: 'admin_email') String adminEmail
});




}
/// @nodoc
class __$ImpersonationInfoCopyWithImpl<$Res>
    implements _$ImpersonationInfoCopyWith<$Res> {
  __$ImpersonationInfoCopyWithImpl(this._self, this._then);

  final _ImpersonationInfo _self;
  final $Res Function(_ImpersonationInfo) _then;

/// Create a copy of ImpersonationInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adminAccountId = null,Object? adminFirstName = freezed,Object? adminLastName = freezed,Object? adminEmail = null,}) {
  return _then(_ImpersonationInfo(
adminAccountId: null == adminAccountId ? _self.adminAccountId : adminAccountId // ignore: cast_nullable_to_non_nullable
as int,adminFirstName: freezed == adminFirstName ? _self.adminFirstName : adminFirstName // ignore: cast_nullable_to_non_nullable
as String?,adminLastName: freezed == adminLastName ? _self.adminLastName : adminLastName // ignore: cast_nullable_to_non_nullable
as String?,adminEmail: null == adminEmail ? _self.adminEmail : adminEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SessionMeResponse {

 SessionUserInfo get user;@JsonKey(name: 'is_impersonating') bool get isImpersonating;@JsonKey(name: 'impersonation_info') ImpersonationInfo? get impersonationInfo;@JsonKey(name: 'viewing_as') ViewingAsUserInfo? get viewingAs;@JsonKey(name: 'session_expires_at') String get sessionExpiresAt;@JsonKey(name: 'has_signed_consent') bool get hasSignedConsent;@JsonKey(name: 'needs_profile_completion') bool get needsProfileCompletion;@JsonKey(name: 'must_change_password') bool get mustChangePassword;
/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionMeResponseCopyWith<SessionMeResponse> get copyWith => _$SessionMeResponseCopyWithImpl<SessionMeResponse>(this as SessionMeResponse, _$identity);

  /// Serializes this SessionMeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionMeResponse&&(identical(other.user, user) || other.user == user)&&(identical(other.isImpersonating, isImpersonating) || other.isImpersonating == isImpersonating)&&(identical(other.impersonationInfo, impersonationInfo) || other.impersonationInfo == impersonationInfo)&&(identical(other.viewingAs, viewingAs) || other.viewingAs == viewingAs)&&(identical(other.sessionExpiresAt, sessionExpiresAt) || other.sessionExpiresAt == sessionExpiresAt)&&(identical(other.hasSignedConsent, hasSignedConsent) || other.hasSignedConsent == hasSignedConsent)&&(identical(other.needsProfileCompletion, needsProfileCompletion) || other.needsProfileCompletion == needsProfileCompletion)&&(identical(other.mustChangePassword, mustChangePassword) || other.mustChangePassword == mustChangePassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,isImpersonating,impersonationInfo,viewingAs,sessionExpiresAt,hasSignedConsent,needsProfileCompletion,mustChangePassword);

@override
String toString() {
  return 'SessionMeResponse(user: $user, isImpersonating: $isImpersonating, impersonationInfo: $impersonationInfo, viewingAs: $viewingAs, sessionExpiresAt: $sessionExpiresAt, hasSignedConsent: $hasSignedConsent, needsProfileCompletion: $needsProfileCompletion, mustChangePassword: $mustChangePassword)';
}


}

/// @nodoc
abstract mixin class $SessionMeResponseCopyWith<$Res>  {
  factory $SessionMeResponseCopyWith(SessionMeResponse value, $Res Function(SessionMeResponse) _then) = _$SessionMeResponseCopyWithImpl;
@useResult
$Res call({
 SessionUserInfo user,@JsonKey(name: 'is_impersonating') bool isImpersonating,@JsonKey(name: 'impersonation_info') ImpersonationInfo? impersonationInfo,@JsonKey(name: 'viewing_as') ViewingAsUserInfo? viewingAs,@JsonKey(name: 'session_expires_at') String sessionExpiresAt,@JsonKey(name: 'has_signed_consent') bool hasSignedConsent,@JsonKey(name: 'needs_profile_completion') bool needsProfileCompletion,@JsonKey(name: 'must_change_password') bool mustChangePassword
});


$SessionUserInfoCopyWith<$Res> get user;$ImpersonationInfoCopyWith<$Res>? get impersonationInfo;$ViewingAsUserInfoCopyWith<$Res>? get viewingAs;

}
/// @nodoc
class _$SessionMeResponseCopyWithImpl<$Res>
    implements $SessionMeResponseCopyWith<$Res> {
  _$SessionMeResponseCopyWithImpl(this._self, this._then);

  final SessionMeResponse _self;
  final $Res Function(SessionMeResponse) _then;

/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? isImpersonating = null,Object? impersonationInfo = freezed,Object? viewingAs = freezed,Object? sessionExpiresAt = null,Object? hasSignedConsent = null,Object? needsProfileCompletion = null,Object? mustChangePassword = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as SessionUserInfo,isImpersonating: null == isImpersonating ? _self.isImpersonating : isImpersonating // ignore: cast_nullable_to_non_nullable
as bool,impersonationInfo: freezed == impersonationInfo ? _self.impersonationInfo : impersonationInfo // ignore: cast_nullable_to_non_nullable
as ImpersonationInfo?,viewingAs: freezed == viewingAs ? _self.viewingAs : viewingAs // ignore: cast_nullable_to_non_nullable
as ViewingAsUserInfo?,sessionExpiresAt: null == sessionExpiresAt ? _self.sessionExpiresAt : sessionExpiresAt // ignore: cast_nullable_to_non_nullable
as String,hasSignedConsent: null == hasSignedConsent ? _self.hasSignedConsent : hasSignedConsent // ignore: cast_nullable_to_non_nullable
as bool,needsProfileCompletion: null == needsProfileCompletion ? _self.needsProfileCompletion : needsProfileCompletion // ignore: cast_nullable_to_non_nullable
as bool,mustChangePassword: null == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionUserInfoCopyWith<$Res> get user {
  
  return $SessionUserInfoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImpersonationInfoCopyWith<$Res>? get impersonationInfo {
    if (_self.impersonationInfo == null) {
    return null;
  }

  return $ImpersonationInfoCopyWith<$Res>(_self.impersonationInfo!, (value) {
    return _then(_self.copyWith(impersonationInfo: value));
  });
}/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewingAsUserInfoCopyWith<$Res>? get viewingAs {
    if (_self.viewingAs == null) {
    return null;
  }

  return $ViewingAsUserInfoCopyWith<$Res>(_self.viewingAs!, (value) {
    return _then(_self.copyWith(viewingAs: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionMeResponse].
extension SessionMeResponsePatterns on SessionMeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionMeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionMeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionMeResponse value)  $default,){
final _that = this;
switch (_that) {
case _SessionMeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionMeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SessionMeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SessionUserInfo user, @JsonKey(name: 'is_impersonating')  bool isImpersonating, @JsonKey(name: 'impersonation_info')  ImpersonationInfo? impersonationInfo, @JsonKey(name: 'viewing_as')  ViewingAsUserInfo? viewingAs, @JsonKey(name: 'session_expires_at')  String sessionExpiresAt, @JsonKey(name: 'has_signed_consent')  bool hasSignedConsent, @JsonKey(name: 'needs_profile_completion')  bool needsProfileCompletion, @JsonKey(name: 'must_change_password')  bool mustChangePassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionMeResponse() when $default != null:
return $default(_that.user,_that.isImpersonating,_that.impersonationInfo,_that.viewingAs,_that.sessionExpiresAt,_that.hasSignedConsent,_that.needsProfileCompletion,_that.mustChangePassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SessionUserInfo user, @JsonKey(name: 'is_impersonating')  bool isImpersonating, @JsonKey(name: 'impersonation_info')  ImpersonationInfo? impersonationInfo, @JsonKey(name: 'viewing_as')  ViewingAsUserInfo? viewingAs, @JsonKey(name: 'session_expires_at')  String sessionExpiresAt, @JsonKey(name: 'has_signed_consent')  bool hasSignedConsent, @JsonKey(name: 'needs_profile_completion')  bool needsProfileCompletion, @JsonKey(name: 'must_change_password')  bool mustChangePassword)  $default,) {final _that = this;
switch (_that) {
case _SessionMeResponse():
return $default(_that.user,_that.isImpersonating,_that.impersonationInfo,_that.viewingAs,_that.sessionExpiresAt,_that.hasSignedConsent,_that.needsProfileCompletion,_that.mustChangePassword);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SessionUserInfo user, @JsonKey(name: 'is_impersonating')  bool isImpersonating, @JsonKey(name: 'impersonation_info')  ImpersonationInfo? impersonationInfo, @JsonKey(name: 'viewing_as')  ViewingAsUserInfo? viewingAs, @JsonKey(name: 'session_expires_at')  String sessionExpiresAt, @JsonKey(name: 'has_signed_consent')  bool hasSignedConsent, @JsonKey(name: 'needs_profile_completion')  bool needsProfileCompletion, @JsonKey(name: 'must_change_password')  bool mustChangePassword)?  $default,) {final _that = this;
switch (_that) {
case _SessionMeResponse() when $default != null:
return $default(_that.user,_that.isImpersonating,_that.impersonationInfo,_that.viewingAs,_that.sessionExpiresAt,_that.hasSignedConsent,_that.needsProfileCompletion,_that.mustChangePassword);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SessionMeResponse implements SessionMeResponse {
  const _SessionMeResponse({required this.user, @JsonKey(name: 'is_impersonating') required this.isImpersonating, @JsonKey(name: 'impersonation_info') this.impersonationInfo, @JsonKey(name: 'viewing_as') this.viewingAs, @JsonKey(name: 'session_expires_at') required this.sessionExpiresAt, @JsonKey(name: 'has_signed_consent') this.hasSignedConsent = true, @JsonKey(name: 'needs_profile_completion') this.needsProfileCompletion = false, @JsonKey(name: 'must_change_password') this.mustChangePassword = false});
  factory _SessionMeResponse.fromJson(Map<String, dynamic> json) => _$SessionMeResponseFromJson(json);

@override final  SessionUserInfo user;
@override@JsonKey(name: 'is_impersonating') final  bool isImpersonating;
@override@JsonKey(name: 'impersonation_info') final  ImpersonationInfo? impersonationInfo;
@override@JsonKey(name: 'viewing_as') final  ViewingAsUserInfo? viewingAs;
@override@JsonKey(name: 'session_expires_at') final  String sessionExpiresAt;
@override@JsonKey(name: 'has_signed_consent') final  bool hasSignedConsent;
@override@JsonKey(name: 'needs_profile_completion') final  bool needsProfileCompletion;
@override@JsonKey(name: 'must_change_password') final  bool mustChangePassword;

/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionMeResponseCopyWith<_SessionMeResponse> get copyWith => __$SessionMeResponseCopyWithImpl<_SessionMeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionMeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionMeResponse&&(identical(other.user, user) || other.user == user)&&(identical(other.isImpersonating, isImpersonating) || other.isImpersonating == isImpersonating)&&(identical(other.impersonationInfo, impersonationInfo) || other.impersonationInfo == impersonationInfo)&&(identical(other.viewingAs, viewingAs) || other.viewingAs == viewingAs)&&(identical(other.sessionExpiresAt, sessionExpiresAt) || other.sessionExpiresAt == sessionExpiresAt)&&(identical(other.hasSignedConsent, hasSignedConsent) || other.hasSignedConsent == hasSignedConsent)&&(identical(other.needsProfileCompletion, needsProfileCompletion) || other.needsProfileCompletion == needsProfileCompletion)&&(identical(other.mustChangePassword, mustChangePassword) || other.mustChangePassword == mustChangePassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,isImpersonating,impersonationInfo,viewingAs,sessionExpiresAt,hasSignedConsent,needsProfileCompletion,mustChangePassword);

@override
String toString() {
  return 'SessionMeResponse(user: $user, isImpersonating: $isImpersonating, impersonationInfo: $impersonationInfo, viewingAs: $viewingAs, sessionExpiresAt: $sessionExpiresAt, hasSignedConsent: $hasSignedConsent, needsProfileCompletion: $needsProfileCompletion, mustChangePassword: $mustChangePassword)';
}


}

/// @nodoc
abstract mixin class _$SessionMeResponseCopyWith<$Res> implements $SessionMeResponseCopyWith<$Res> {
  factory _$SessionMeResponseCopyWith(_SessionMeResponse value, $Res Function(_SessionMeResponse) _then) = __$SessionMeResponseCopyWithImpl;
@override @useResult
$Res call({
 SessionUserInfo user,@JsonKey(name: 'is_impersonating') bool isImpersonating,@JsonKey(name: 'impersonation_info') ImpersonationInfo? impersonationInfo,@JsonKey(name: 'viewing_as') ViewingAsUserInfo? viewingAs,@JsonKey(name: 'session_expires_at') String sessionExpiresAt,@JsonKey(name: 'has_signed_consent') bool hasSignedConsent,@JsonKey(name: 'needs_profile_completion') bool needsProfileCompletion,@JsonKey(name: 'must_change_password') bool mustChangePassword
});


@override $SessionUserInfoCopyWith<$Res> get user;@override $ImpersonationInfoCopyWith<$Res>? get impersonationInfo;@override $ViewingAsUserInfoCopyWith<$Res>? get viewingAs;

}
/// @nodoc
class __$SessionMeResponseCopyWithImpl<$Res>
    implements _$SessionMeResponseCopyWith<$Res> {
  __$SessionMeResponseCopyWithImpl(this._self, this._then);

  final _SessionMeResponse _self;
  final $Res Function(_SessionMeResponse) _then;

/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? isImpersonating = null,Object? impersonationInfo = freezed,Object? viewingAs = freezed,Object? sessionExpiresAt = null,Object? hasSignedConsent = null,Object? needsProfileCompletion = null,Object? mustChangePassword = null,}) {
  return _then(_SessionMeResponse(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as SessionUserInfo,isImpersonating: null == isImpersonating ? _self.isImpersonating : isImpersonating // ignore: cast_nullable_to_non_nullable
as bool,impersonationInfo: freezed == impersonationInfo ? _self.impersonationInfo : impersonationInfo // ignore: cast_nullable_to_non_nullable
as ImpersonationInfo?,viewingAs: freezed == viewingAs ? _self.viewingAs : viewingAs // ignore: cast_nullable_to_non_nullable
as ViewingAsUserInfo?,sessionExpiresAt: null == sessionExpiresAt ? _self.sessionExpiresAt : sessionExpiresAt // ignore: cast_nullable_to_non_nullable
as String,hasSignedConsent: null == hasSignedConsent ? _self.hasSignedConsent : hasSignedConsent // ignore: cast_nullable_to_non_nullable
as bool,needsProfileCompletion: null == needsProfileCompletion ? _self.needsProfileCompletion : needsProfileCompletion // ignore: cast_nullable_to_non_nullable
as bool,mustChangePassword: null == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionUserInfoCopyWith<$Res> get user {
  
  return $SessionUserInfoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImpersonationInfoCopyWith<$Res>? get impersonationInfo {
    if (_self.impersonationInfo == null) {
    return null;
  }

  return $ImpersonationInfoCopyWith<$Res>(_self.impersonationInfo!, (value) {
    return _then(_self.copyWith(impersonationInfo: value));
  });
}/// Create a copy of SessionMeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewingAsUserInfoCopyWith<$Res>? get viewingAs {
    if (_self.viewingAs == null) {
    return null;
  }

  return $ViewingAsUserInfoCopyWith<$Res>(_self.viewingAs!, (value) {
    return _then(_self.copyWith(viewingAs: value));
  });
}
}


/// @nodoc
mixin _$ViewingAsUserInfo {

@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName; String get email; String get role;@JsonKey(name: 'role_id') int get roleId;@JsonKey(name: 'birthdate') String? get birthdate;@JsonKey(name: 'gender') String? get gender;
/// Create a copy of ViewingAsUserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewingAsUserInfoCopyWith<ViewingAsUserInfo> get copyWith => _$ViewingAsUserInfoCopyWithImpl<ViewingAsUserInfo>(this as ViewingAsUserInfo, _$identity);

  /// Serializes this ViewingAsUserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewingAsUserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,firstName,lastName,email,role,roleId,birthdate,gender);

@override
String toString() {
  return 'ViewingAsUserInfo(userId: $userId, firstName: $firstName, lastName: $lastName, email: $email, role: $role, roleId: $roleId, birthdate: $birthdate, gender: $gender)';
}


}

/// @nodoc
abstract mixin class $ViewingAsUserInfoCopyWith<$Res>  {
  factory $ViewingAsUserInfoCopyWith(ViewingAsUserInfo value, $Res Function(ViewingAsUserInfo) _then) = _$ViewingAsUserInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String email, String role,@JsonKey(name: 'role_id') int roleId,@JsonKey(name: 'birthdate') String? birthdate,@JsonKey(name: 'gender') String? gender
});




}
/// @nodoc
class _$ViewingAsUserInfoCopyWithImpl<$Res>
    implements $ViewingAsUserInfoCopyWith<$Res> {
  _$ViewingAsUserInfoCopyWithImpl(this._self, this._then);

  final ViewingAsUserInfo _self;
  final $Res Function(ViewingAsUserInfo) _then;

/// Create a copy of ViewingAsUserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = freezed,Object? lastName = freezed,Object? email = null,Object? role = null,Object? roleId = null,Object? birthdate = freezed,Object? gender = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ViewingAsUserInfo].
extension ViewingAsUserInfoPatterns on ViewingAsUserInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ViewingAsUserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ViewingAsUserInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ViewingAsUserInfo value)  $default,){
final _that = this;
switch (_that) {
case _ViewingAsUserInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ViewingAsUserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ViewingAsUserInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String email,  String role, @JsonKey(name: 'role_id')  int roleId, @JsonKey(name: 'birthdate')  String? birthdate, @JsonKey(name: 'gender')  String? gender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ViewingAsUserInfo() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.email,_that.role,_that.roleId,_that.birthdate,_that.gender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String email,  String role, @JsonKey(name: 'role_id')  int roleId, @JsonKey(name: 'birthdate')  String? birthdate, @JsonKey(name: 'gender')  String? gender)  $default,) {final _that = this;
switch (_that) {
case _ViewingAsUserInfo():
return $default(_that.userId,_that.firstName,_that.lastName,_that.email,_that.role,_that.roleId,_that.birthdate,_that.gender);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String email,  String role, @JsonKey(name: 'role_id')  int roleId, @JsonKey(name: 'birthdate')  String? birthdate, @JsonKey(name: 'gender')  String? gender)?  $default,) {final _that = this;
switch (_that) {
case _ViewingAsUserInfo() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.email,_that.role,_that.roleId,_that.birthdate,_that.gender);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ViewingAsUserInfo implements ViewingAsUserInfo {
  const _ViewingAsUserInfo({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, required this.email, required this.role, @JsonKey(name: 'role_id') required this.roleId, @JsonKey(name: 'birthdate') this.birthdate, @JsonKey(name: 'gender') this.gender});
  factory _ViewingAsUserInfo.fromJson(Map<String, dynamic> json) => _$ViewingAsUserInfoFromJson(json);

@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String email;
@override final  String role;
@override@JsonKey(name: 'role_id') final  int roleId;
@override@JsonKey(name: 'birthdate') final  String? birthdate;
@override@JsonKey(name: 'gender') final  String? gender;

/// Create a copy of ViewingAsUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewingAsUserInfoCopyWith<_ViewingAsUserInfo> get copyWith => __$ViewingAsUserInfoCopyWithImpl<_ViewingAsUserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ViewingAsUserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewingAsUserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,firstName,lastName,email,role,roleId,birthdate,gender);

@override
String toString() {
  return 'ViewingAsUserInfo(userId: $userId, firstName: $firstName, lastName: $lastName, email: $email, role: $role, roleId: $roleId, birthdate: $birthdate, gender: $gender)';
}


}

/// @nodoc
abstract mixin class _$ViewingAsUserInfoCopyWith<$Res> implements $ViewingAsUserInfoCopyWith<$Res> {
  factory _$ViewingAsUserInfoCopyWith(_ViewingAsUserInfo value, $Res Function(_ViewingAsUserInfo) _then) = __$ViewingAsUserInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String email, String role,@JsonKey(name: 'role_id') int roleId,@JsonKey(name: 'birthdate') String? birthdate,@JsonKey(name: 'gender') String? gender
});




}
/// @nodoc
class __$ViewingAsUserInfoCopyWithImpl<$Res>
    implements _$ViewingAsUserInfoCopyWith<$Res> {
  __$ViewingAsUserInfoCopyWithImpl(this._self, this._then);

  final _ViewingAsUserInfo _self;
  final $Res Function(_ViewingAsUserInfo) _then;

/// Create a copy of ViewingAsUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = freezed,Object? lastName = freezed,Object? email = null,Object? role = null,Object? roleId = null,Object? birthdate = freezed,Object? gender = freezed,}) {
  return _then(_ViewingAsUserInfo(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ViewAsResponse {

 String get message;@JsonKey(name: 'is_viewing_as') bool get isViewingAs;@JsonKey(name: 'viewed_user') ViewingAsUserInfo get viewedUser;
/// Create a copy of ViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewAsResponseCopyWith<ViewAsResponse> get copyWith => _$ViewAsResponseCopyWithImpl<ViewAsResponse>(this as ViewAsResponse, _$identity);

  /// Serializes this ViewAsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewAsResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.isViewingAs, isViewingAs) || other.isViewingAs == isViewingAs)&&(identical(other.viewedUser, viewedUser) || other.viewedUser == viewedUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,isViewingAs,viewedUser);

@override
String toString() {
  return 'ViewAsResponse(message: $message, isViewingAs: $isViewingAs, viewedUser: $viewedUser)';
}


}

/// @nodoc
abstract mixin class $ViewAsResponseCopyWith<$Res>  {
  factory $ViewAsResponseCopyWith(ViewAsResponse value, $Res Function(ViewAsResponse) _then) = _$ViewAsResponseCopyWithImpl;
@useResult
$Res call({
 String message,@JsonKey(name: 'is_viewing_as') bool isViewingAs,@JsonKey(name: 'viewed_user') ViewingAsUserInfo viewedUser
});


$ViewingAsUserInfoCopyWith<$Res> get viewedUser;

}
/// @nodoc
class _$ViewAsResponseCopyWithImpl<$Res>
    implements $ViewAsResponseCopyWith<$Res> {
  _$ViewAsResponseCopyWithImpl(this._self, this._then);

  final ViewAsResponse _self;
  final $Res Function(ViewAsResponse) _then;

/// Create a copy of ViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? isViewingAs = null,Object? viewedUser = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isViewingAs: null == isViewingAs ? _self.isViewingAs : isViewingAs // ignore: cast_nullable_to_non_nullable
as bool,viewedUser: null == viewedUser ? _self.viewedUser : viewedUser // ignore: cast_nullable_to_non_nullable
as ViewingAsUserInfo,
  ));
}
/// Create a copy of ViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewingAsUserInfoCopyWith<$Res> get viewedUser {
  
  return $ViewingAsUserInfoCopyWith<$Res>(_self.viewedUser, (value) {
    return _then(_self.copyWith(viewedUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [ViewAsResponse].
extension ViewAsResponsePatterns on ViewAsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ViewAsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ViewAsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ViewAsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ViewAsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ViewAsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ViewAsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'is_viewing_as')  bool isViewingAs, @JsonKey(name: 'viewed_user')  ViewingAsUserInfo viewedUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ViewAsResponse() when $default != null:
return $default(_that.message,_that.isViewingAs,_that.viewedUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'is_viewing_as')  bool isViewingAs, @JsonKey(name: 'viewed_user')  ViewingAsUserInfo viewedUser)  $default,) {final _that = this;
switch (_that) {
case _ViewAsResponse():
return $default(_that.message,_that.isViewingAs,_that.viewedUser);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message, @JsonKey(name: 'is_viewing_as')  bool isViewingAs, @JsonKey(name: 'viewed_user')  ViewingAsUserInfo viewedUser)?  $default,) {final _that = this;
switch (_that) {
case _ViewAsResponse() when $default != null:
return $default(_that.message,_that.isViewingAs,_that.viewedUser);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ViewAsResponse implements ViewAsResponse {
  const _ViewAsResponse({required this.message, @JsonKey(name: 'is_viewing_as') required this.isViewingAs, @JsonKey(name: 'viewed_user') required this.viewedUser});
  factory _ViewAsResponse.fromJson(Map<String, dynamic> json) => _$ViewAsResponseFromJson(json);

@override final  String message;
@override@JsonKey(name: 'is_viewing_as') final  bool isViewingAs;
@override@JsonKey(name: 'viewed_user') final  ViewingAsUserInfo viewedUser;

/// Create a copy of ViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewAsResponseCopyWith<_ViewAsResponse> get copyWith => __$ViewAsResponseCopyWithImpl<_ViewAsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ViewAsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewAsResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.isViewingAs, isViewingAs) || other.isViewingAs == isViewingAs)&&(identical(other.viewedUser, viewedUser) || other.viewedUser == viewedUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,isViewingAs,viewedUser);

@override
String toString() {
  return 'ViewAsResponse(message: $message, isViewingAs: $isViewingAs, viewedUser: $viewedUser)';
}


}

/// @nodoc
abstract mixin class _$ViewAsResponseCopyWith<$Res> implements $ViewAsResponseCopyWith<$Res> {
  factory _$ViewAsResponseCopyWith(_ViewAsResponse value, $Res Function(_ViewAsResponse) _then) = __$ViewAsResponseCopyWithImpl;
@override @useResult
$Res call({
 String message,@JsonKey(name: 'is_viewing_as') bool isViewingAs,@JsonKey(name: 'viewed_user') ViewingAsUserInfo viewedUser
});


@override $ViewingAsUserInfoCopyWith<$Res> get viewedUser;

}
/// @nodoc
class __$ViewAsResponseCopyWithImpl<$Res>
    implements _$ViewAsResponseCopyWith<$Res> {
  __$ViewAsResponseCopyWithImpl(this._self, this._then);

  final _ViewAsResponse _self;
  final $Res Function(_ViewAsResponse) _then;

/// Create a copy of ViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isViewingAs = null,Object? viewedUser = null,}) {
  return _then(_ViewAsResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isViewingAs: null == isViewingAs ? _self.isViewingAs : isViewingAs // ignore: cast_nullable_to_non_nullable
as bool,viewedUser: null == viewedUser ? _self.viewedUser : viewedUser // ignore: cast_nullable_to_non_nullable
as ViewingAsUserInfo,
  ));
}

/// Create a copy of ViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewingAsUserInfoCopyWith<$Res> get viewedUser {
  
  return $ViewingAsUserInfoCopyWith<$Res>(_self.viewedUser, (value) {
    return _then(_self.copyWith(viewedUser: value));
  });
}
}


/// @nodoc
mixin _$EndViewAsResponse {

 String get message;
/// Create a copy of EndViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndViewAsResponseCopyWith<EndViewAsResponse> get copyWith => _$EndViewAsResponseCopyWithImpl<EndViewAsResponse>(this as EndViewAsResponse, _$identity);

  /// Serializes this EndViewAsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndViewAsResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'EndViewAsResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class $EndViewAsResponseCopyWith<$Res>  {
  factory $EndViewAsResponseCopyWith(EndViewAsResponse value, $Res Function(EndViewAsResponse) _then) = _$EndViewAsResponseCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$EndViewAsResponseCopyWithImpl<$Res>
    implements $EndViewAsResponseCopyWith<$Res> {
  _$EndViewAsResponseCopyWithImpl(this._self, this._then);

  final EndViewAsResponse _self;
  final $Res Function(EndViewAsResponse) _then;

/// Create a copy of EndViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EndViewAsResponse].
extension EndViewAsResponsePatterns on EndViewAsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EndViewAsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EndViewAsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EndViewAsResponse value)  $default,){
final _that = this;
switch (_that) {
case _EndViewAsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EndViewAsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EndViewAsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EndViewAsResponse() when $default != null:
return $default(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message)  $default,) {final _that = this;
switch (_that) {
case _EndViewAsResponse():
return $default(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message)?  $default,) {final _that = this;
switch (_that) {
case _EndViewAsResponse() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EndViewAsResponse implements EndViewAsResponse {
  const _EndViewAsResponse({required this.message});
  factory _EndViewAsResponse.fromJson(Map<String, dynamic> json) => _$EndViewAsResponseFromJson(json);

@override final  String message;

/// Create a copy of EndViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndViewAsResponseCopyWith<_EndViewAsResponse> get copyWith => __$EndViewAsResponseCopyWithImpl<_EndViewAsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EndViewAsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndViewAsResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'EndViewAsResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class _$EndViewAsResponseCopyWith<$Res> implements $EndViewAsResponseCopyWith<$Res> {
  factory _$EndViewAsResponseCopyWith(_EndViewAsResponse value, $Res Function(_EndViewAsResponse) _then) = __$EndViewAsResponseCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$EndViewAsResponseCopyWithImpl<$Res>
    implements _$EndViewAsResponseCopyWith<$Res> {
  __$EndViewAsResponseCopyWithImpl(this._self, this._then);

  final _EndViewAsResponse _self;
  final $Res Function(_EndViewAsResponse) _then;

/// Create a copy of EndViewAsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_EndViewAsResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
