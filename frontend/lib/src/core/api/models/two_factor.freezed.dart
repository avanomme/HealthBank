// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'two_factor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TwoFactorEnrollResponse {

// If your backend uses a different key name, change the JsonKey to match.
// Common options: "provisioning_uri", "uri", "otpauth_uri"
@JsonKey(name: 'provisioning_uri') String get provisioningUri;
/// Create a copy of TwoFactorEnrollResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TwoFactorEnrollResponseCopyWith<TwoFactorEnrollResponse> get copyWith => _$TwoFactorEnrollResponseCopyWithImpl<TwoFactorEnrollResponse>(this as TwoFactorEnrollResponse, _$identity);

  /// Serializes this TwoFactorEnrollResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TwoFactorEnrollResponse&&(identical(other.provisioningUri, provisioningUri) || other.provisioningUri == provisioningUri));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provisioningUri);

@override
String toString() {
  return 'TwoFactorEnrollResponse(provisioningUri: $provisioningUri)';
}


}

/// @nodoc
abstract mixin class $TwoFactorEnrollResponseCopyWith<$Res>  {
  factory $TwoFactorEnrollResponseCopyWith(TwoFactorEnrollResponse value, $Res Function(TwoFactorEnrollResponse) _then) = _$TwoFactorEnrollResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'provisioning_uri') String provisioningUri
});




}
/// @nodoc
class _$TwoFactorEnrollResponseCopyWithImpl<$Res>
    implements $TwoFactorEnrollResponseCopyWith<$Res> {
  _$TwoFactorEnrollResponseCopyWithImpl(this._self, this._then);

  final TwoFactorEnrollResponse _self;
  final $Res Function(TwoFactorEnrollResponse) _then;

/// Create a copy of TwoFactorEnrollResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provisioningUri = null,}) {
  return _then(_self.copyWith(
provisioningUri: null == provisioningUri ? _self.provisioningUri : provisioningUri // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TwoFactorEnrollResponse].
extension TwoFactorEnrollResponsePatterns on TwoFactorEnrollResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TwoFactorEnrollResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TwoFactorEnrollResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TwoFactorEnrollResponse value)  $default,){
final _that = this;
switch (_that) {
case _TwoFactorEnrollResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TwoFactorEnrollResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TwoFactorEnrollResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'provisioning_uri')  String provisioningUri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TwoFactorEnrollResponse() when $default != null:
return $default(_that.provisioningUri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'provisioning_uri')  String provisioningUri)  $default,) {final _that = this;
switch (_that) {
case _TwoFactorEnrollResponse():
return $default(_that.provisioningUri);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'provisioning_uri')  String provisioningUri)?  $default,) {final _that = this;
switch (_that) {
case _TwoFactorEnrollResponse() when $default != null:
return $default(_that.provisioningUri);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TwoFactorEnrollResponse implements TwoFactorEnrollResponse {
  const _TwoFactorEnrollResponse({@JsonKey(name: 'provisioning_uri') required this.provisioningUri});
  factory _TwoFactorEnrollResponse.fromJson(Map<String, dynamic> json) => _$TwoFactorEnrollResponseFromJson(json);

// If your backend uses a different key name, change the JsonKey to match.
// Common options: "provisioning_uri", "uri", "otpauth_uri"
@override@JsonKey(name: 'provisioning_uri') final  String provisioningUri;

/// Create a copy of TwoFactorEnrollResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TwoFactorEnrollResponseCopyWith<_TwoFactorEnrollResponse> get copyWith => __$TwoFactorEnrollResponseCopyWithImpl<_TwoFactorEnrollResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TwoFactorEnrollResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TwoFactorEnrollResponse&&(identical(other.provisioningUri, provisioningUri) || other.provisioningUri == provisioningUri));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provisioningUri);

@override
String toString() {
  return 'TwoFactorEnrollResponse(provisioningUri: $provisioningUri)';
}


}

/// @nodoc
abstract mixin class _$TwoFactorEnrollResponseCopyWith<$Res> implements $TwoFactorEnrollResponseCopyWith<$Res> {
  factory _$TwoFactorEnrollResponseCopyWith(_TwoFactorEnrollResponse value, $Res Function(_TwoFactorEnrollResponse) _then) = __$TwoFactorEnrollResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'provisioning_uri') String provisioningUri
});




}
/// @nodoc
class __$TwoFactorEnrollResponseCopyWithImpl<$Res>
    implements _$TwoFactorEnrollResponseCopyWith<$Res> {
  __$TwoFactorEnrollResponseCopyWithImpl(this._self, this._then);

  final _TwoFactorEnrollResponse _self;
  final $Res Function(_TwoFactorEnrollResponse) _then;

/// Create a copy of TwoFactorEnrollResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provisioningUri = null,}) {
  return _then(_TwoFactorEnrollResponse(
provisioningUri: null == provisioningUri ? _self.provisioningUri : provisioningUri // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TwoFactorConfirmResponse {

// If your backend uses a different key name, change the JsonKey to match.
// Common options: "provisioning_uri", "uri", "otpauth_uri"
@JsonKey(name: 'message') String get message;
/// Create a copy of TwoFactorConfirmResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TwoFactorConfirmResponseCopyWith<TwoFactorConfirmResponse> get copyWith => _$TwoFactorConfirmResponseCopyWithImpl<TwoFactorConfirmResponse>(this as TwoFactorConfirmResponse, _$identity);

  /// Serializes this TwoFactorConfirmResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TwoFactorConfirmResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TwoFactorConfirmResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class $TwoFactorConfirmResponseCopyWith<$Res>  {
  factory $TwoFactorConfirmResponseCopyWith(TwoFactorConfirmResponse value, $Res Function(TwoFactorConfirmResponse) _then) = _$TwoFactorConfirmResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message') String message
});




}
/// @nodoc
class _$TwoFactorConfirmResponseCopyWithImpl<$Res>
    implements $TwoFactorConfirmResponseCopyWith<$Res> {
  _$TwoFactorConfirmResponseCopyWithImpl(this._self, this._then);

  final TwoFactorConfirmResponse _self;
  final $Res Function(TwoFactorConfirmResponse) _then;

/// Create a copy of TwoFactorConfirmResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TwoFactorConfirmResponse].
extension TwoFactorConfirmResponsePatterns on TwoFactorConfirmResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TwoFactorConfirmResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TwoFactorConfirmResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TwoFactorConfirmResponse value)  $default,){
final _that = this;
switch (_that) {
case _TwoFactorConfirmResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TwoFactorConfirmResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TwoFactorConfirmResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TwoFactorConfirmResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message)  $default,) {final _that = this;
switch (_that) {
case _TwoFactorConfirmResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message')  String message)?  $default,) {final _that = this;
switch (_that) {
case _TwoFactorConfirmResponse() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TwoFactorConfirmResponse implements TwoFactorConfirmResponse {
  const _TwoFactorConfirmResponse({@JsonKey(name: 'message') required this.message});
  factory _TwoFactorConfirmResponse.fromJson(Map<String, dynamic> json) => _$TwoFactorConfirmResponseFromJson(json);

// If your backend uses a different key name, change the JsonKey to match.
// Common options: "provisioning_uri", "uri", "otpauth_uri"
@override@JsonKey(name: 'message') final  String message;

/// Create a copy of TwoFactorConfirmResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TwoFactorConfirmResponseCopyWith<_TwoFactorConfirmResponse> get copyWith => __$TwoFactorConfirmResponseCopyWithImpl<_TwoFactorConfirmResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TwoFactorConfirmResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TwoFactorConfirmResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TwoFactorConfirmResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class _$TwoFactorConfirmResponseCopyWith<$Res> implements $TwoFactorConfirmResponseCopyWith<$Res> {
  factory _$TwoFactorConfirmResponseCopyWith(_TwoFactorConfirmResponse value, $Res Function(_TwoFactorConfirmResponse) _then) = __$TwoFactorConfirmResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message') String message
});




}
/// @nodoc
class __$TwoFactorConfirmResponseCopyWithImpl<$Res>
    implements _$TwoFactorConfirmResponseCopyWith<$Res> {
  __$TwoFactorConfirmResponseCopyWithImpl(this._self, this._then);

  final _TwoFactorConfirmResponse _self;
  final $Res Function(_TwoFactorConfirmResponse) _then;

/// Create a copy of TwoFactorConfirmResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_TwoFactorConfirmResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TwoFactorDisableResponse {

// If your backend uses a different key name, change the JsonKey to match.
// Common options: "provisioning_uri", "uri", "otpauth_uri"
@JsonKey(name: 'message') String get message;
/// Create a copy of TwoFactorDisableResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TwoFactorDisableResponseCopyWith<TwoFactorDisableResponse> get copyWith => _$TwoFactorDisableResponseCopyWithImpl<TwoFactorDisableResponse>(this as TwoFactorDisableResponse, _$identity);

  /// Serializes this TwoFactorDisableResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TwoFactorDisableResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TwoFactorDisableResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class $TwoFactorDisableResponseCopyWith<$Res>  {
  factory $TwoFactorDisableResponseCopyWith(TwoFactorDisableResponse value, $Res Function(TwoFactorDisableResponse) _then) = _$TwoFactorDisableResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message') String message
});




}
/// @nodoc
class _$TwoFactorDisableResponseCopyWithImpl<$Res>
    implements $TwoFactorDisableResponseCopyWith<$Res> {
  _$TwoFactorDisableResponseCopyWithImpl(this._self, this._then);

  final TwoFactorDisableResponse _self;
  final $Res Function(TwoFactorDisableResponse) _then;

/// Create a copy of TwoFactorDisableResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TwoFactorDisableResponse].
extension TwoFactorDisableResponsePatterns on TwoFactorDisableResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TwoFactorDisableResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TwoFactorDisableResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TwoFactorDisableResponse value)  $default,){
final _that = this;
switch (_that) {
case _TwoFactorDisableResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TwoFactorDisableResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TwoFactorDisableResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TwoFactorDisableResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message)  $default,) {final _that = this;
switch (_that) {
case _TwoFactorDisableResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message')  String message)?  $default,) {final _that = this;
switch (_that) {
case _TwoFactorDisableResponse() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TwoFactorDisableResponse implements TwoFactorDisableResponse {
  const _TwoFactorDisableResponse({@JsonKey(name: 'message') required this.message});
  factory _TwoFactorDisableResponse.fromJson(Map<String, dynamic> json) => _$TwoFactorDisableResponseFromJson(json);

// If your backend uses a different key name, change the JsonKey to match.
// Common options: "provisioning_uri", "uri", "otpauth_uri"
@override@JsonKey(name: 'message') final  String message;

/// Create a copy of TwoFactorDisableResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TwoFactorDisableResponseCopyWith<_TwoFactorDisableResponse> get copyWith => __$TwoFactorDisableResponseCopyWithImpl<_TwoFactorDisableResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TwoFactorDisableResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TwoFactorDisableResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TwoFactorDisableResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class _$TwoFactorDisableResponseCopyWith<$Res> implements $TwoFactorDisableResponseCopyWith<$Res> {
  factory _$TwoFactorDisableResponseCopyWith(_TwoFactorDisableResponse value, $Res Function(_TwoFactorDisableResponse) _then) = __$TwoFactorDisableResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message') String message
});




}
/// @nodoc
class __$TwoFactorDisableResponseCopyWithImpl<$Res>
    implements _$TwoFactorDisableResponseCopyWith<$Res> {
  __$TwoFactorDisableResponseCopyWithImpl(this._self, this._then);

  final _TwoFactorDisableResponse _self;
  final $Res Function(_TwoFactorDisableResponse) _then;

/// Create a copy of TwoFactorDisableResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_TwoFactorDisableResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TwoFactorConfirmRequest {

// Change key name if backend expects "totp" or "token" etc.
@JsonKey(name: 'code') String get code;
/// Create a copy of TwoFactorConfirmRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TwoFactorConfirmRequestCopyWith<TwoFactorConfirmRequest> get copyWith => _$TwoFactorConfirmRequestCopyWithImpl<TwoFactorConfirmRequest>(this as TwoFactorConfirmRequest, _$identity);

  /// Serializes this TwoFactorConfirmRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TwoFactorConfirmRequest&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'TwoFactorConfirmRequest(code: $code)';
}


}

/// @nodoc
abstract mixin class $TwoFactorConfirmRequestCopyWith<$Res>  {
  factory $TwoFactorConfirmRequestCopyWith(TwoFactorConfirmRequest value, $Res Function(TwoFactorConfirmRequest) _then) = _$TwoFactorConfirmRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code
});




}
/// @nodoc
class _$TwoFactorConfirmRequestCopyWithImpl<$Res>
    implements $TwoFactorConfirmRequestCopyWith<$Res> {
  _$TwoFactorConfirmRequestCopyWithImpl(this._self, this._then);

  final TwoFactorConfirmRequest _self;
  final $Res Function(TwoFactorConfirmRequest) _then;

/// Create a copy of TwoFactorConfirmRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TwoFactorConfirmRequest].
extension TwoFactorConfirmRequestPatterns on TwoFactorConfirmRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TwoFactorConfirmRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TwoFactorConfirmRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TwoFactorConfirmRequest value)  $default,){
final _that = this;
switch (_that) {
case _TwoFactorConfirmRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TwoFactorConfirmRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TwoFactorConfirmRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'code')  String code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TwoFactorConfirmRequest() when $default != null:
return $default(_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'code')  String code)  $default,) {final _that = this;
switch (_that) {
case _TwoFactorConfirmRequest():
return $default(_that.code);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'code')  String code)?  $default,) {final _that = this;
switch (_that) {
case _TwoFactorConfirmRequest() when $default != null:
return $default(_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TwoFactorConfirmRequest implements TwoFactorConfirmRequest {
  const _TwoFactorConfirmRequest({@JsonKey(name: 'code') required this.code});
  factory _TwoFactorConfirmRequest.fromJson(Map<String, dynamic> json) => _$TwoFactorConfirmRequestFromJson(json);

// Change key name if backend expects "totp" or "token" etc.
@override@JsonKey(name: 'code') final  String code;

/// Create a copy of TwoFactorConfirmRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TwoFactorConfirmRequestCopyWith<_TwoFactorConfirmRequest> get copyWith => __$TwoFactorConfirmRequestCopyWithImpl<_TwoFactorConfirmRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TwoFactorConfirmRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TwoFactorConfirmRequest&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'TwoFactorConfirmRequest(code: $code)';
}


}

/// @nodoc
abstract mixin class _$TwoFactorConfirmRequestCopyWith<$Res> implements $TwoFactorConfirmRequestCopyWith<$Res> {
  factory _$TwoFactorConfirmRequestCopyWith(_TwoFactorConfirmRequest value, $Res Function(_TwoFactorConfirmRequest) _then) = __$TwoFactorConfirmRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code
});




}
/// @nodoc
class __$TwoFactorConfirmRequestCopyWithImpl<$Res>
    implements _$TwoFactorConfirmRequestCopyWith<$Res> {
  __$TwoFactorConfirmRequestCopyWithImpl(this._self, this._then);

  final _TwoFactorConfirmRequest _self;
  final $Res Function(_TwoFactorConfirmRequest) _then;

/// Create a copy of TwoFactorConfirmRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(_TwoFactorConfirmRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
