// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsentStatusResponse {

@JsonKey(name: 'has_signed_consent') bool get hasSignedConsent;@JsonKey(name: 'consent_version') String? get consentVersion;@JsonKey(name: 'consent_signed_at') String? get consentSignedAt;@JsonKey(name: 'current_version') String get currentVersion;@JsonKey(name: 'needs_consent') bool get needsConsent;
/// Create a copy of ConsentStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentStatusResponseCopyWith<ConsentStatusResponse> get copyWith => _$ConsentStatusResponseCopyWithImpl<ConsentStatusResponse>(this as ConsentStatusResponse, _$identity);

  /// Serializes this ConsentStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentStatusResponse&&(identical(other.hasSignedConsent, hasSignedConsent) || other.hasSignedConsent == hasSignedConsent)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion)&&(identical(other.consentSignedAt, consentSignedAt) || other.consentSignedAt == consentSignedAt)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.needsConsent, needsConsent) || other.needsConsent == needsConsent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasSignedConsent,consentVersion,consentSignedAt,currentVersion,needsConsent);

@override
String toString() {
  return 'ConsentStatusResponse(hasSignedConsent: $hasSignedConsent, consentVersion: $consentVersion, consentSignedAt: $consentSignedAt, currentVersion: $currentVersion, needsConsent: $needsConsent)';
}


}

/// @nodoc
abstract mixin class $ConsentStatusResponseCopyWith<$Res>  {
  factory $ConsentStatusResponseCopyWith(ConsentStatusResponse value, $Res Function(ConsentStatusResponse) _then) = _$ConsentStatusResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'has_signed_consent') bool hasSignedConsent,@JsonKey(name: 'consent_version') String? consentVersion,@JsonKey(name: 'consent_signed_at') String? consentSignedAt,@JsonKey(name: 'current_version') String currentVersion,@JsonKey(name: 'needs_consent') bool needsConsent
});




}
/// @nodoc
class _$ConsentStatusResponseCopyWithImpl<$Res>
    implements $ConsentStatusResponseCopyWith<$Res> {
  _$ConsentStatusResponseCopyWithImpl(this._self, this._then);

  final ConsentStatusResponse _self;
  final $Res Function(ConsentStatusResponse) _then;

/// Create a copy of ConsentStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasSignedConsent = null,Object? consentVersion = freezed,Object? consentSignedAt = freezed,Object? currentVersion = null,Object? needsConsent = null,}) {
  return _then(_self.copyWith(
hasSignedConsent: null == hasSignedConsent ? _self.hasSignedConsent : hasSignedConsent // ignore: cast_nullable_to_non_nullable
as bool,consentVersion: freezed == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String?,consentSignedAt: freezed == consentSignedAt ? _self.consentSignedAt : consentSignedAt // ignore: cast_nullable_to_non_nullable
as String?,currentVersion: null == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as String,needsConsent: null == needsConsent ? _self.needsConsent : needsConsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentStatusResponse].
extension ConsentStatusResponsePatterns on ConsentStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _ConsentStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_signed_consent')  bool hasSignedConsent, @JsonKey(name: 'consent_version')  String? consentVersion, @JsonKey(name: 'consent_signed_at')  String? consentSignedAt, @JsonKey(name: 'current_version')  String currentVersion, @JsonKey(name: 'needs_consent')  bool needsConsent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentStatusResponse() when $default != null:
return $default(_that.hasSignedConsent,_that.consentVersion,_that.consentSignedAt,_that.currentVersion,_that.needsConsent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_signed_consent')  bool hasSignedConsent, @JsonKey(name: 'consent_version')  String? consentVersion, @JsonKey(name: 'consent_signed_at')  String? consentSignedAt, @JsonKey(name: 'current_version')  String currentVersion, @JsonKey(name: 'needs_consent')  bool needsConsent)  $default,) {final _that = this;
switch (_that) {
case _ConsentStatusResponse():
return $default(_that.hasSignedConsent,_that.consentVersion,_that.consentSignedAt,_that.currentVersion,_that.needsConsent);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'has_signed_consent')  bool hasSignedConsent, @JsonKey(name: 'consent_version')  String? consentVersion, @JsonKey(name: 'consent_signed_at')  String? consentSignedAt, @JsonKey(name: 'current_version')  String currentVersion, @JsonKey(name: 'needs_consent')  bool needsConsent)?  $default,) {final _that = this;
switch (_that) {
case _ConsentStatusResponse() when $default != null:
return $default(_that.hasSignedConsent,_that.consentVersion,_that.consentSignedAt,_that.currentVersion,_that.needsConsent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsentStatusResponse implements ConsentStatusResponse {
  const _ConsentStatusResponse({@JsonKey(name: 'has_signed_consent') required this.hasSignedConsent, @JsonKey(name: 'consent_version') this.consentVersion, @JsonKey(name: 'consent_signed_at') this.consentSignedAt, @JsonKey(name: 'current_version') required this.currentVersion, @JsonKey(name: 'needs_consent') required this.needsConsent});
  factory _ConsentStatusResponse.fromJson(Map<String, dynamic> json) => _$ConsentStatusResponseFromJson(json);

@override@JsonKey(name: 'has_signed_consent') final  bool hasSignedConsent;
@override@JsonKey(name: 'consent_version') final  String? consentVersion;
@override@JsonKey(name: 'consent_signed_at') final  String? consentSignedAt;
@override@JsonKey(name: 'current_version') final  String currentVersion;
@override@JsonKey(name: 'needs_consent') final  bool needsConsent;

/// Create a copy of ConsentStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentStatusResponseCopyWith<_ConsentStatusResponse> get copyWith => __$ConsentStatusResponseCopyWithImpl<_ConsentStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsentStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentStatusResponse&&(identical(other.hasSignedConsent, hasSignedConsent) || other.hasSignedConsent == hasSignedConsent)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion)&&(identical(other.consentSignedAt, consentSignedAt) || other.consentSignedAt == consentSignedAt)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.needsConsent, needsConsent) || other.needsConsent == needsConsent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasSignedConsent,consentVersion,consentSignedAt,currentVersion,needsConsent);

@override
String toString() {
  return 'ConsentStatusResponse(hasSignedConsent: $hasSignedConsent, consentVersion: $consentVersion, consentSignedAt: $consentSignedAt, currentVersion: $currentVersion, needsConsent: $needsConsent)';
}


}

/// @nodoc
abstract mixin class _$ConsentStatusResponseCopyWith<$Res> implements $ConsentStatusResponseCopyWith<$Res> {
  factory _$ConsentStatusResponseCopyWith(_ConsentStatusResponse value, $Res Function(_ConsentStatusResponse) _then) = __$ConsentStatusResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'has_signed_consent') bool hasSignedConsent,@JsonKey(name: 'consent_version') String? consentVersion,@JsonKey(name: 'consent_signed_at') String? consentSignedAt,@JsonKey(name: 'current_version') String currentVersion,@JsonKey(name: 'needs_consent') bool needsConsent
});




}
/// @nodoc
class __$ConsentStatusResponseCopyWithImpl<$Res>
    implements _$ConsentStatusResponseCopyWith<$Res> {
  __$ConsentStatusResponseCopyWithImpl(this._self, this._then);

  final _ConsentStatusResponse _self;
  final $Res Function(_ConsentStatusResponse) _then;

/// Create a copy of ConsentStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasSignedConsent = null,Object? consentVersion = freezed,Object? consentSignedAt = freezed,Object? currentVersion = null,Object? needsConsent = null,}) {
  return _then(_ConsentStatusResponse(
hasSignedConsent: null == hasSignedConsent ? _self.hasSignedConsent : hasSignedConsent // ignore: cast_nullable_to_non_nullable
as bool,consentVersion: freezed == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String?,consentSignedAt: freezed == consentSignedAt ? _self.consentSignedAt : consentSignedAt // ignore: cast_nullable_to_non_nullable
as String?,currentVersion: null == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as String,needsConsent: null == needsConsent ? _self.needsConsent : needsConsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ConsentSubmitRequest {

@JsonKey(name: 'document_text') String get documentText;@JsonKey(name: 'document_language') String get documentLanguage;@JsonKey(name: 'signature_name') String get signatureName;
/// Create a copy of ConsentSubmitRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentSubmitRequestCopyWith<ConsentSubmitRequest> get copyWith => _$ConsentSubmitRequestCopyWithImpl<ConsentSubmitRequest>(this as ConsentSubmitRequest, _$identity);

  /// Serializes this ConsentSubmitRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentSubmitRequest&&(identical(other.documentText, documentText) || other.documentText == documentText)&&(identical(other.documentLanguage, documentLanguage) || other.documentLanguage == documentLanguage)&&(identical(other.signatureName, signatureName) || other.signatureName == signatureName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentText,documentLanguage,signatureName);

@override
String toString() {
  return 'ConsentSubmitRequest(documentText: $documentText, documentLanguage: $documentLanguage, signatureName: $signatureName)';
}


}

/// @nodoc
abstract mixin class $ConsentSubmitRequestCopyWith<$Res>  {
  factory $ConsentSubmitRequestCopyWith(ConsentSubmitRequest value, $Res Function(ConsentSubmitRequest) _then) = _$ConsentSubmitRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'document_text') String documentText,@JsonKey(name: 'document_language') String documentLanguage,@JsonKey(name: 'signature_name') String signatureName
});




}
/// @nodoc
class _$ConsentSubmitRequestCopyWithImpl<$Res>
    implements $ConsentSubmitRequestCopyWith<$Res> {
  _$ConsentSubmitRequestCopyWithImpl(this._self, this._then);

  final ConsentSubmitRequest _self;
  final $Res Function(ConsentSubmitRequest) _then;

/// Create a copy of ConsentSubmitRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentText = null,Object? documentLanguage = null,Object? signatureName = null,}) {
  return _then(_self.copyWith(
documentText: null == documentText ? _self.documentText : documentText // ignore: cast_nullable_to_non_nullable
as String,documentLanguage: null == documentLanguage ? _self.documentLanguage : documentLanguage // ignore: cast_nullable_to_non_nullable
as String,signatureName: null == signatureName ? _self.signatureName : signatureName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentSubmitRequest].
extension ConsentSubmitRequestPatterns on ConsentSubmitRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentSubmitRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentSubmitRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentSubmitRequest value)  $default,){
final _that = this;
switch (_that) {
case _ConsentSubmitRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentSubmitRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentSubmitRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'document_text')  String documentText, @JsonKey(name: 'document_language')  String documentLanguage, @JsonKey(name: 'signature_name')  String signatureName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentSubmitRequest() when $default != null:
return $default(_that.documentText,_that.documentLanguage,_that.signatureName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'document_text')  String documentText, @JsonKey(name: 'document_language')  String documentLanguage, @JsonKey(name: 'signature_name')  String signatureName)  $default,) {final _that = this;
switch (_that) {
case _ConsentSubmitRequest():
return $default(_that.documentText,_that.documentLanguage,_that.signatureName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'document_text')  String documentText, @JsonKey(name: 'document_language')  String documentLanguage, @JsonKey(name: 'signature_name')  String signatureName)?  $default,) {final _that = this;
switch (_that) {
case _ConsentSubmitRequest() when $default != null:
return $default(_that.documentText,_that.documentLanguage,_that.signatureName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsentSubmitRequest implements ConsentSubmitRequest {
  const _ConsentSubmitRequest({@JsonKey(name: 'document_text') required this.documentText, @JsonKey(name: 'document_language') required this.documentLanguage, @JsonKey(name: 'signature_name') required this.signatureName});
  factory _ConsentSubmitRequest.fromJson(Map<String, dynamic> json) => _$ConsentSubmitRequestFromJson(json);

@override@JsonKey(name: 'document_text') final  String documentText;
@override@JsonKey(name: 'document_language') final  String documentLanguage;
@override@JsonKey(name: 'signature_name') final  String signatureName;

/// Create a copy of ConsentSubmitRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentSubmitRequestCopyWith<_ConsentSubmitRequest> get copyWith => __$ConsentSubmitRequestCopyWithImpl<_ConsentSubmitRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsentSubmitRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentSubmitRequest&&(identical(other.documentText, documentText) || other.documentText == documentText)&&(identical(other.documentLanguage, documentLanguage) || other.documentLanguage == documentLanguage)&&(identical(other.signatureName, signatureName) || other.signatureName == signatureName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentText,documentLanguage,signatureName);

@override
String toString() {
  return 'ConsentSubmitRequest(documentText: $documentText, documentLanguage: $documentLanguage, signatureName: $signatureName)';
}


}

/// @nodoc
abstract mixin class _$ConsentSubmitRequestCopyWith<$Res> implements $ConsentSubmitRequestCopyWith<$Res> {
  factory _$ConsentSubmitRequestCopyWith(_ConsentSubmitRequest value, $Res Function(_ConsentSubmitRequest) _then) = __$ConsentSubmitRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'document_text') String documentText,@JsonKey(name: 'document_language') String documentLanguage,@JsonKey(name: 'signature_name') String signatureName
});




}
/// @nodoc
class __$ConsentSubmitRequestCopyWithImpl<$Res>
    implements _$ConsentSubmitRequestCopyWith<$Res> {
  __$ConsentSubmitRequestCopyWithImpl(this._self, this._then);

  final _ConsentSubmitRequest _self;
  final $Res Function(_ConsentSubmitRequest) _then;

/// Create a copy of ConsentSubmitRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentText = null,Object? documentLanguage = null,Object? signatureName = null,}) {
  return _then(_ConsentSubmitRequest(
documentText: null == documentText ? _self.documentText : documentText // ignore: cast_nullable_to_non_nullable
as String,documentLanguage: null == documentLanguage ? _self.documentLanguage : documentLanguage // ignore: cast_nullable_to_non_nullable
as String,signatureName: null == signatureName ? _self.signatureName : signatureName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ConsentSubmitResponse {

 bool get accepted; String get version;@JsonKey(name: 'consent_record_id') int get consentRecordId;
/// Create a copy of ConsentSubmitResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentSubmitResponseCopyWith<ConsentSubmitResponse> get copyWith => _$ConsentSubmitResponseCopyWithImpl<ConsentSubmitResponse>(this as ConsentSubmitResponse, _$identity);

  /// Serializes this ConsentSubmitResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentSubmitResponse&&(identical(other.accepted, accepted) || other.accepted == accepted)&&(identical(other.version, version) || other.version == version)&&(identical(other.consentRecordId, consentRecordId) || other.consentRecordId == consentRecordId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accepted,version,consentRecordId);

@override
String toString() {
  return 'ConsentSubmitResponse(accepted: $accepted, version: $version, consentRecordId: $consentRecordId)';
}


}

/// @nodoc
abstract mixin class $ConsentSubmitResponseCopyWith<$Res>  {
  factory $ConsentSubmitResponseCopyWith(ConsentSubmitResponse value, $Res Function(ConsentSubmitResponse) _then) = _$ConsentSubmitResponseCopyWithImpl;
@useResult
$Res call({
 bool accepted, String version,@JsonKey(name: 'consent_record_id') int consentRecordId
});




}
/// @nodoc
class _$ConsentSubmitResponseCopyWithImpl<$Res>
    implements $ConsentSubmitResponseCopyWith<$Res> {
  _$ConsentSubmitResponseCopyWithImpl(this._self, this._then);

  final ConsentSubmitResponse _self;
  final $Res Function(ConsentSubmitResponse) _then;

/// Create a copy of ConsentSubmitResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accepted = null,Object? version = null,Object? consentRecordId = null,}) {
  return _then(_self.copyWith(
accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,consentRecordId: null == consentRecordId ? _self.consentRecordId : consentRecordId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentSubmitResponse].
extension ConsentSubmitResponsePatterns on ConsentSubmitResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentSubmitResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentSubmitResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentSubmitResponse value)  $default,){
final _that = this;
switch (_that) {
case _ConsentSubmitResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentSubmitResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentSubmitResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool accepted,  String version, @JsonKey(name: 'consent_record_id')  int consentRecordId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentSubmitResponse() when $default != null:
return $default(_that.accepted,_that.version,_that.consentRecordId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool accepted,  String version, @JsonKey(name: 'consent_record_id')  int consentRecordId)  $default,) {final _that = this;
switch (_that) {
case _ConsentSubmitResponse():
return $default(_that.accepted,_that.version,_that.consentRecordId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool accepted,  String version, @JsonKey(name: 'consent_record_id')  int consentRecordId)?  $default,) {final _that = this;
switch (_that) {
case _ConsentSubmitResponse() when $default != null:
return $default(_that.accepted,_that.version,_that.consentRecordId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsentSubmitResponse implements ConsentSubmitResponse {
  const _ConsentSubmitResponse({required this.accepted, required this.version, @JsonKey(name: 'consent_record_id') required this.consentRecordId});
  factory _ConsentSubmitResponse.fromJson(Map<String, dynamic> json) => _$ConsentSubmitResponseFromJson(json);

@override final  bool accepted;
@override final  String version;
@override@JsonKey(name: 'consent_record_id') final  int consentRecordId;

/// Create a copy of ConsentSubmitResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentSubmitResponseCopyWith<_ConsentSubmitResponse> get copyWith => __$ConsentSubmitResponseCopyWithImpl<_ConsentSubmitResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsentSubmitResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentSubmitResponse&&(identical(other.accepted, accepted) || other.accepted == accepted)&&(identical(other.version, version) || other.version == version)&&(identical(other.consentRecordId, consentRecordId) || other.consentRecordId == consentRecordId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accepted,version,consentRecordId);

@override
String toString() {
  return 'ConsentSubmitResponse(accepted: $accepted, version: $version, consentRecordId: $consentRecordId)';
}


}

/// @nodoc
abstract mixin class _$ConsentSubmitResponseCopyWith<$Res> implements $ConsentSubmitResponseCopyWith<$Res> {
  factory _$ConsentSubmitResponseCopyWith(_ConsentSubmitResponse value, $Res Function(_ConsentSubmitResponse) _then) = __$ConsentSubmitResponseCopyWithImpl;
@override @useResult
$Res call({
 bool accepted, String version,@JsonKey(name: 'consent_record_id') int consentRecordId
});




}
/// @nodoc
class __$ConsentSubmitResponseCopyWithImpl<$Res>
    implements _$ConsentSubmitResponseCopyWith<$Res> {
  __$ConsentSubmitResponseCopyWithImpl(this._self, this._then);

  final _ConsentSubmitResponse _self;
  final $Res Function(_ConsentSubmitResponse) _then;

/// Create a copy of ConsentSubmitResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accepted = null,Object? version = null,Object? consentRecordId = null,}) {
  return _then(_ConsentSubmitResponse(
accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,consentRecordId: null == consentRecordId ? _self.consentRecordId : consentRecordId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UserConsentRecordResponse {

@JsonKey(name: 'consent_record_id') int get consentRecordId;@JsonKey(name: 'account_id') int get accountId;@JsonKey(name: 'role_id') int get roleId;@JsonKey(name: 'consent_version') String get consentVersion;@JsonKey(name: 'document_language') String get documentLanguage;@JsonKey(name: 'document_text') String get documentText;@JsonKey(name: 'signature_name') String? get signatureName;@JsonKey(name: 'signed_at') String get signedAt;@JsonKey(name: 'ip_address') String? get ipAddress;@JsonKey(name: 'user_agent') String? get userAgent;
/// Create a copy of UserConsentRecordResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserConsentRecordResponseCopyWith<UserConsentRecordResponse> get copyWith => _$UserConsentRecordResponseCopyWithImpl<UserConsentRecordResponse>(this as UserConsentRecordResponse, _$identity);

  /// Serializes this UserConsentRecordResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserConsentRecordResponse&&(identical(other.consentRecordId, consentRecordId) || other.consentRecordId == consentRecordId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion)&&(identical(other.documentLanguage, documentLanguage) || other.documentLanguage == documentLanguage)&&(identical(other.documentText, documentText) || other.documentText == documentText)&&(identical(other.signatureName, signatureName) || other.signatureName == signatureName)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,consentRecordId,accountId,roleId,consentVersion,documentLanguage,documentText,signatureName,signedAt,ipAddress,userAgent);

@override
String toString() {
  return 'UserConsentRecordResponse(consentRecordId: $consentRecordId, accountId: $accountId, roleId: $roleId, consentVersion: $consentVersion, documentLanguage: $documentLanguage, documentText: $documentText, signatureName: $signatureName, signedAt: $signedAt, ipAddress: $ipAddress, userAgent: $userAgent)';
}


}

/// @nodoc
abstract mixin class $UserConsentRecordResponseCopyWith<$Res>  {
  factory $UserConsentRecordResponseCopyWith(UserConsentRecordResponse value, $Res Function(UserConsentRecordResponse) _then) = _$UserConsentRecordResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'consent_record_id') int consentRecordId,@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'role_id') int roleId,@JsonKey(name: 'consent_version') String consentVersion,@JsonKey(name: 'document_language') String documentLanguage,@JsonKey(name: 'document_text') String documentText,@JsonKey(name: 'signature_name') String? signatureName,@JsonKey(name: 'signed_at') String signedAt,@JsonKey(name: 'ip_address') String? ipAddress,@JsonKey(name: 'user_agent') String? userAgent
});




}
/// @nodoc
class _$UserConsentRecordResponseCopyWithImpl<$Res>
    implements $UserConsentRecordResponseCopyWith<$Res> {
  _$UserConsentRecordResponseCopyWithImpl(this._self, this._then);

  final UserConsentRecordResponse _self;
  final $Res Function(UserConsentRecordResponse) _then;

/// Create a copy of UserConsentRecordResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? consentRecordId = null,Object? accountId = null,Object? roleId = null,Object? consentVersion = null,Object? documentLanguage = null,Object? documentText = null,Object? signatureName = freezed,Object? signedAt = null,Object? ipAddress = freezed,Object? userAgent = freezed,}) {
  return _then(_self.copyWith(
consentRecordId: null == consentRecordId ? _self.consentRecordId : consentRecordId // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,consentVersion: null == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String,documentLanguage: null == documentLanguage ? _self.documentLanguage : documentLanguage // ignore: cast_nullable_to_non_nullable
as String,documentText: null == documentText ? _self.documentText : documentText // ignore: cast_nullable_to_non_nullable
as String,signatureName: freezed == signatureName ? _self.signatureName : signatureName // ignore: cast_nullable_to_non_nullable
as String?,signedAt: null == signedAt ? _self.signedAt : signedAt // ignore: cast_nullable_to_non_nullable
as String,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserConsentRecordResponse].
extension UserConsentRecordResponsePatterns on UserConsentRecordResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserConsentRecordResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserConsentRecordResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserConsentRecordResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserConsentRecordResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserConsentRecordResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserConsentRecordResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'consent_record_id')  int consentRecordId, @JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'role_id')  int roleId, @JsonKey(name: 'consent_version')  String consentVersion, @JsonKey(name: 'document_language')  String documentLanguage, @JsonKey(name: 'document_text')  String documentText, @JsonKey(name: 'signature_name')  String? signatureName, @JsonKey(name: 'signed_at')  String signedAt, @JsonKey(name: 'ip_address')  String? ipAddress, @JsonKey(name: 'user_agent')  String? userAgent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserConsentRecordResponse() when $default != null:
return $default(_that.consentRecordId,_that.accountId,_that.roleId,_that.consentVersion,_that.documentLanguage,_that.documentText,_that.signatureName,_that.signedAt,_that.ipAddress,_that.userAgent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'consent_record_id')  int consentRecordId, @JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'role_id')  int roleId, @JsonKey(name: 'consent_version')  String consentVersion, @JsonKey(name: 'document_language')  String documentLanguage, @JsonKey(name: 'document_text')  String documentText, @JsonKey(name: 'signature_name')  String? signatureName, @JsonKey(name: 'signed_at')  String signedAt, @JsonKey(name: 'ip_address')  String? ipAddress, @JsonKey(name: 'user_agent')  String? userAgent)  $default,) {final _that = this;
switch (_that) {
case _UserConsentRecordResponse():
return $default(_that.consentRecordId,_that.accountId,_that.roleId,_that.consentVersion,_that.documentLanguage,_that.documentText,_that.signatureName,_that.signedAt,_that.ipAddress,_that.userAgent);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'consent_record_id')  int consentRecordId, @JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'role_id')  int roleId, @JsonKey(name: 'consent_version')  String consentVersion, @JsonKey(name: 'document_language')  String documentLanguage, @JsonKey(name: 'document_text')  String documentText, @JsonKey(name: 'signature_name')  String? signatureName, @JsonKey(name: 'signed_at')  String signedAt, @JsonKey(name: 'ip_address')  String? ipAddress, @JsonKey(name: 'user_agent')  String? userAgent)?  $default,) {final _that = this;
switch (_that) {
case _UserConsentRecordResponse() when $default != null:
return $default(_that.consentRecordId,_that.accountId,_that.roleId,_that.consentVersion,_that.documentLanguage,_that.documentText,_that.signatureName,_that.signedAt,_that.ipAddress,_that.userAgent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserConsentRecordResponse implements UserConsentRecordResponse {
  const _UserConsentRecordResponse({@JsonKey(name: 'consent_record_id') required this.consentRecordId, @JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'role_id') required this.roleId, @JsonKey(name: 'consent_version') required this.consentVersion, @JsonKey(name: 'document_language') required this.documentLanguage, @JsonKey(name: 'document_text') required this.documentText, @JsonKey(name: 'signature_name') this.signatureName, @JsonKey(name: 'signed_at') required this.signedAt, @JsonKey(name: 'ip_address') this.ipAddress, @JsonKey(name: 'user_agent') this.userAgent});
  factory _UserConsentRecordResponse.fromJson(Map<String, dynamic> json) => _$UserConsentRecordResponseFromJson(json);

@override@JsonKey(name: 'consent_record_id') final  int consentRecordId;
@override@JsonKey(name: 'account_id') final  int accountId;
@override@JsonKey(name: 'role_id') final  int roleId;
@override@JsonKey(name: 'consent_version') final  String consentVersion;
@override@JsonKey(name: 'document_language') final  String documentLanguage;
@override@JsonKey(name: 'document_text') final  String documentText;
@override@JsonKey(name: 'signature_name') final  String? signatureName;
@override@JsonKey(name: 'signed_at') final  String signedAt;
@override@JsonKey(name: 'ip_address') final  String? ipAddress;
@override@JsonKey(name: 'user_agent') final  String? userAgent;

/// Create a copy of UserConsentRecordResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserConsentRecordResponseCopyWith<_UserConsentRecordResponse> get copyWith => __$UserConsentRecordResponseCopyWithImpl<_UserConsentRecordResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserConsentRecordResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserConsentRecordResponse&&(identical(other.consentRecordId, consentRecordId) || other.consentRecordId == consentRecordId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion)&&(identical(other.documentLanguage, documentLanguage) || other.documentLanguage == documentLanguage)&&(identical(other.documentText, documentText) || other.documentText == documentText)&&(identical(other.signatureName, signatureName) || other.signatureName == signatureName)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,consentRecordId,accountId,roleId,consentVersion,documentLanguage,documentText,signatureName,signedAt,ipAddress,userAgent);

@override
String toString() {
  return 'UserConsentRecordResponse(consentRecordId: $consentRecordId, accountId: $accountId, roleId: $roleId, consentVersion: $consentVersion, documentLanguage: $documentLanguage, documentText: $documentText, signatureName: $signatureName, signedAt: $signedAt, ipAddress: $ipAddress, userAgent: $userAgent)';
}


}

/// @nodoc
abstract mixin class _$UserConsentRecordResponseCopyWith<$Res> implements $UserConsentRecordResponseCopyWith<$Res> {
  factory _$UserConsentRecordResponseCopyWith(_UserConsentRecordResponse value, $Res Function(_UserConsentRecordResponse) _then) = __$UserConsentRecordResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'consent_record_id') int consentRecordId,@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'role_id') int roleId,@JsonKey(name: 'consent_version') String consentVersion,@JsonKey(name: 'document_language') String documentLanguage,@JsonKey(name: 'document_text') String documentText,@JsonKey(name: 'signature_name') String? signatureName,@JsonKey(name: 'signed_at') String signedAt,@JsonKey(name: 'ip_address') String? ipAddress,@JsonKey(name: 'user_agent') String? userAgent
});




}
/// @nodoc
class __$UserConsentRecordResponseCopyWithImpl<$Res>
    implements _$UserConsentRecordResponseCopyWith<$Res> {
  __$UserConsentRecordResponseCopyWithImpl(this._self, this._then);

  final _UserConsentRecordResponse _self;
  final $Res Function(_UserConsentRecordResponse) _then;

/// Create a copy of UserConsentRecordResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? consentRecordId = null,Object? accountId = null,Object? roleId = null,Object? consentVersion = null,Object? documentLanguage = null,Object? documentText = null,Object? signatureName = freezed,Object? signedAt = null,Object? ipAddress = freezed,Object? userAgent = freezed,}) {
  return _then(_UserConsentRecordResponse(
consentRecordId: null == consentRecordId ? _self.consentRecordId : consentRecordId // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,consentVersion: null == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String,documentLanguage: null == documentLanguage ? _self.documentLanguage : documentLanguage // ignore: cast_nullable_to_non_nullable
as String,documentText: null == documentText ? _self.documentText : documentText // ignore: cast_nullable_to_non_nullable
as String,signatureName: freezed == signatureName ? _self.signatureName : signatureName // ignore: cast_nullable_to_non_nullable
as String?,signedAt: null == signedAt ? _self.signedAt : signedAt // ignore: cast_nullable_to_non_nullable
as String,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
