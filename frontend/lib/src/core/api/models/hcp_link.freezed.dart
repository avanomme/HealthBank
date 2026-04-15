// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hcp_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HcpLink {

@JsonKey(name: 'link_id') int get linkId;@JsonKey(name: 'hcp_id') int get hcpId;@JsonKey(name: 'patient_id') int get patientId;@JsonKey(name: 'hcp_name') String? get hcpName;@JsonKey(name: 'patient_name') String? get patientName; String get status;@JsonKey(name: 'requested_by') String get requestedBy;@JsonKey(name: 'requested_at') DateTime get requestedAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;@JsonKey(name: 'consent_revoked') bool get consentRevoked;
/// Create a copy of HcpLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HcpLinkCopyWith<HcpLink> get copyWith => _$HcpLinkCopyWithImpl<HcpLink>(this as HcpLink, _$identity);

  /// Serializes this HcpLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HcpLink&&(identical(other.linkId, linkId) || other.linkId == linkId)&&(identical(other.hcpId, hcpId) || other.hcpId == hcpId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.hcpName, hcpName) || other.hcpName == hcpName)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.consentRevoked, consentRevoked) || other.consentRevoked == consentRevoked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,linkId,hcpId,patientId,hcpName,patientName,status,requestedBy,requestedAt,updatedAt,consentRevoked);

@override
String toString() {
  return 'HcpLink(linkId: $linkId, hcpId: $hcpId, patientId: $patientId, hcpName: $hcpName, patientName: $patientName, status: $status, requestedBy: $requestedBy, requestedAt: $requestedAt, updatedAt: $updatedAt, consentRevoked: $consentRevoked)';
}


}

/// @nodoc
abstract mixin class $HcpLinkCopyWith<$Res>  {
  factory $HcpLinkCopyWith(HcpLink value, $Res Function(HcpLink) _then) = _$HcpLinkCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'link_id') int linkId,@JsonKey(name: 'hcp_id') int hcpId,@JsonKey(name: 'patient_id') int patientId,@JsonKey(name: 'hcp_name') String? hcpName,@JsonKey(name: 'patient_name') String? patientName, String status,@JsonKey(name: 'requested_by') String requestedBy,@JsonKey(name: 'requested_at') DateTime requestedAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'consent_revoked') bool consentRevoked
});




}
/// @nodoc
class _$HcpLinkCopyWithImpl<$Res>
    implements $HcpLinkCopyWith<$Res> {
  _$HcpLinkCopyWithImpl(this._self, this._then);

  final HcpLink _self;
  final $Res Function(HcpLink) _then;

/// Create a copy of HcpLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? linkId = null,Object? hcpId = null,Object? patientId = null,Object? hcpName = freezed,Object? patientName = freezed,Object? status = null,Object? requestedBy = null,Object? requestedAt = null,Object? updatedAt = null,Object? consentRevoked = null,}) {
  return _then(_self.copyWith(
linkId: null == linkId ? _self.linkId : linkId // ignore: cast_nullable_to_non_nullable
as int,hcpId: null == hcpId ? _self.hcpId : hcpId // ignore: cast_nullable_to_non_nullable
as int,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,hcpName: freezed == hcpName ? _self.hcpName : hcpName // ignore: cast_nullable_to_non_nullable
as String?,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,consentRevoked: null == consentRevoked ? _self.consentRevoked : consentRevoked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HcpLink].
extension HcpLinkPatterns on HcpLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HcpLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HcpLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HcpLink value)  $default,){
final _that = this;
switch (_that) {
case _HcpLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HcpLink value)?  $default,){
final _that = this;
switch (_that) {
case _HcpLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'link_id')  int linkId, @JsonKey(name: 'hcp_id')  int hcpId, @JsonKey(name: 'patient_id')  int patientId, @JsonKey(name: 'hcp_name')  String? hcpName, @JsonKey(name: 'patient_name')  String? patientName,  String status, @JsonKey(name: 'requested_by')  String requestedBy, @JsonKey(name: 'requested_at')  DateTime requestedAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'consent_revoked')  bool consentRevoked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HcpLink() when $default != null:
return $default(_that.linkId,_that.hcpId,_that.patientId,_that.hcpName,_that.patientName,_that.status,_that.requestedBy,_that.requestedAt,_that.updatedAt,_that.consentRevoked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'link_id')  int linkId, @JsonKey(name: 'hcp_id')  int hcpId, @JsonKey(name: 'patient_id')  int patientId, @JsonKey(name: 'hcp_name')  String? hcpName, @JsonKey(name: 'patient_name')  String? patientName,  String status, @JsonKey(name: 'requested_by')  String requestedBy, @JsonKey(name: 'requested_at')  DateTime requestedAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'consent_revoked')  bool consentRevoked)  $default,) {final _that = this;
switch (_that) {
case _HcpLink():
return $default(_that.linkId,_that.hcpId,_that.patientId,_that.hcpName,_that.patientName,_that.status,_that.requestedBy,_that.requestedAt,_that.updatedAt,_that.consentRevoked);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'link_id')  int linkId, @JsonKey(name: 'hcp_id')  int hcpId, @JsonKey(name: 'patient_id')  int patientId, @JsonKey(name: 'hcp_name')  String? hcpName, @JsonKey(name: 'patient_name')  String? patientName,  String status, @JsonKey(name: 'requested_by')  String requestedBy, @JsonKey(name: 'requested_at')  DateTime requestedAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'consent_revoked')  bool consentRevoked)?  $default,) {final _that = this;
switch (_that) {
case _HcpLink() when $default != null:
return $default(_that.linkId,_that.hcpId,_that.patientId,_that.hcpName,_that.patientName,_that.status,_that.requestedBy,_that.requestedAt,_that.updatedAt,_that.consentRevoked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HcpLink implements HcpLink {
  const _HcpLink({@JsonKey(name: 'link_id') required this.linkId, @JsonKey(name: 'hcp_id') required this.hcpId, @JsonKey(name: 'patient_id') required this.patientId, @JsonKey(name: 'hcp_name') this.hcpName, @JsonKey(name: 'patient_name') this.patientName, required this.status, @JsonKey(name: 'requested_by') required this.requestedBy, @JsonKey(name: 'requested_at') required this.requestedAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'consent_revoked') this.consentRevoked = false});
  factory _HcpLink.fromJson(Map<String, dynamic> json) => _$HcpLinkFromJson(json);

@override@JsonKey(name: 'link_id') final  int linkId;
@override@JsonKey(name: 'hcp_id') final  int hcpId;
@override@JsonKey(name: 'patient_id') final  int patientId;
@override@JsonKey(name: 'hcp_name') final  String? hcpName;
@override@JsonKey(name: 'patient_name') final  String? patientName;
@override final  String status;
@override@JsonKey(name: 'requested_by') final  String requestedBy;
@override@JsonKey(name: 'requested_at') final  DateTime requestedAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
@override@JsonKey(name: 'consent_revoked') final  bool consentRevoked;

/// Create a copy of HcpLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HcpLinkCopyWith<_HcpLink> get copyWith => __$HcpLinkCopyWithImpl<_HcpLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HcpLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HcpLink&&(identical(other.linkId, linkId) || other.linkId == linkId)&&(identical(other.hcpId, hcpId) || other.hcpId == hcpId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.hcpName, hcpName) || other.hcpName == hcpName)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.consentRevoked, consentRevoked) || other.consentRevoked == consentRevoked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,linkId,hcpId,patientId,hcpName,patientName,status,requestedBy,requestedAt,updatedAt,consentRevoked);

@override
String toString() {
  return 'HcpLink(linkId: $linkId, hcpId: $hcpId, patientId: $patientId, hcpName: $hcpName, patientName: $patientName, status: $status, requestedBy: $requestedBy, requestedAt: $requestedAt, updatedAt: $updatedAt, consentRevoked: $consentRevoked)';
}


}

/// @nodoc
abstract mixin class _$HcpLinkCopyWith<$Res> implements $HcpLinkCopyWith<$Res> {
  factory _$HcpLinkCopyWith(_HcpLink value, $Res Function(_HcpLink) _then) = __$HcpLinkCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'link_id') int linkId,@JsonKey(name: 'hcp_id') int hcpId,@JsonKey(name: 'patient_id') int patientId,@JsonKey(name: 'hcp_name') String? hcpName,@JsonKey(name: 'patient_name') String? patientName, String status,@JsonKey(name: 'requested_by') String requestedBy,@JsonKey(name: 'requested_at') DateTime requestedAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'consent_revoked') bool consentRevoked
});




}
/// @nodoc
class __$HcpLinkCopyWithImpl<$Res>
    implements _$HcpLinkCopyWith<$Res> {
  __$HcpLinkCopyWithImpl(this._self, this._then);

  final _HcpLink _self;
  final $Res Function(_HcpLink) _then;

/// Create a copy of HcpLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? linkId = null,Object? hcpId = null,Object? patientId = null,Object? hcpName = freezed,Object? patientName = freezed,Object? status = null,Object? requestedBy = null,Object? requestedAt = null,Object? updatedAt = null,Object? consentRevoked = null,}) {
  return _then(_HcpLink(
linkId: null == linkId ? _self.linkId : linkId // ignore: cast_nullable_to_non_nullable
as int,hcpId: null == hcpId ? _self.hcpId : hcpId // ignore: cast_nullable_to_non_nullable
as int,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,hcpName: freezed == hcpName ? _self.hcpName : hcpName // ignore: cast_nullable_to_non_nullable
as String?,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,consentRevoked: null == consentRevoked ? _self.consentRevoked : consentRevoked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
