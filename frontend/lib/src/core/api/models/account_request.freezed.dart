// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountRequestCreate {

@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName; String get email;@JsonKey(name: 'role_id') int get roleId; String? get birthdate; String? get gender;@JsonKey(name: 'gender_other') String? get genderOther;
/// Create a copy of AccountRequestCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountRequestCreateCopyWith<AccountRequestCreate> get copyWith => _$AccountRequestCreateCopyWithImpl<AccountRequestCreate>(this as AccountRequestCreate, _$identity);

  /// Serializes this AccountRequestCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountRequestCreate&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.genderOther, genderOther) || other.genderOther == genderOther));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,roleId,birthdate,gender,genderOther);

@override
String toString() {
  return 'AccountRequestCreate(firstName: $firstName, lastName: $lastName, email: $email, roleId: $roleId, birthdate: $birthdate, gender: $gender, genderOther: $genderOther)';
}


}

/// @nodoc
abstract mixin class $AccountRequestCreateCopyWith<$Res>  {
  factory $AccountRequestCreateCopyWith(AccountRequestCreate value, $Res Function(AccountRequestCreate) _then) = _$AccountRequestCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email,@JsonKey(name: 'role_id') int roleId, String? birthdate, String? gender,@JsonKey(name: 'gender_other') String? genderOther
});




}
/// @nodoc
class _$AccountRequestCreateCopyWithImpl<$Res>
    implements $AccountRequestCreateCopyWith<$Res> {
  _$AccountRequestCreateCopyWithImpl(this._self, this._then);

  final AccountRequestCreate _self;
  final $Res Function(AccountRequestCreate) _then;

/// Create a copy of AccountRequestCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? roleId = null,Object? birthdate = freezed,Object? gender = freezed,Object? genderOther = freezed,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,genderOther: freezed == genderOther ? _self.genderOther : genderOther // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountRequestCreate].
extension AccountRequestCreatePatterns on AccountRequestCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountRequestCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountRequestCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountRequestCreate value)  $default,){
final _that = this;
switch (_that) {
case _AccountRequestCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountRequestCreate value)?  $default,){
final _that = this;
switch (_that) {
case _AccountRequestCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email, @JsonKey(name: 'role_id')  int roleId,  String? birthdate,  String? gender, @JsonKey(name: 'gender_other')  String? genderOther)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountRequestCreate() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.roleId,_that.birthdate,_that.gender,_that.genderOther);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email, @JsonKey(name: 'role_id')  int roleId,  String? birthdate,  String? gender, @JsonKey(name: 'gender_other')  String? genderOther)  $default,) {final _that = this;
switch (_that) {
case _AccountRequestCreate():
return $default(_that.firstName,_that.lastName,_that.email,_that.roleId,_that.birthdate,_that.gender,_that.genderOther);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email, @JsonKey(name: 'role_id')  int roleId,  String? birthdate,  String? gender, @JsonKey(name: 'gender_other')  String? genderOther)?  $default,) {final _that = this;
switch (_that) {
case _AccountRequestCreate() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.roleId,_that.birthdate,_that.gender,_that.genderOther);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountRequestCreate implements AccountRequestCreate {
  const _AccountRequestCreate({@JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, required this.email, @JsonKey(name: 'role_id') required this.roleId, this.birthdate, this.gender, @JsonKey(name: 'gender_other') this.genderOther});
  factory _AccountRequestCreate.fromJson(Map<String, dynamic> json) => _$AccountRequestCreateFromJson(json);

@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override final  String email;
@override@JsonKey(name: 'role_id') final  int roleId;
@override final  String? birthdate;
@override final  String? gender;
@override@JsonKey(name: 'gender_other') final  String? genderOther;

/// Create a copy of AccountRequestCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountRequestCreateCopyWith<_AccountRequestCreate> get copyWith => __$AccountRequestCreateCopyWithImpl<_AccountRequestCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountRequestCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountRequestCreate&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.genderOther, genderOther) || other.genderOther == genderOther));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,roleId,birthdate,gender,genderOther);

@override
String toString() {
  return 'AccountRequestCreate(firstName: $firstName, lastName: $lastName, email: $email, roleId: $roleId, birthdate: $birthdate, gender: $gender, genderOther: $genderOther)';
}


}

/// @nodoc
abstract mixin class _$AccountRequestCreateCopyWith<$Res> implements $AccountRequestCreateCopyWith<$Res> {
  factory _$AccountRequestCreateCopyWith(_AccountRequestCreate value, $Res Function(_AccountRequestCreate) _then) = __$AccountRequestCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email,@JsonKey(name: 'role_id') int roleId, String? birthdate, String? gender,@JsonKey(name: 'gender_other') String? genderOther
});




}
/// @nodoc
class __$AccountRequestCreateCopyWithImpl<$Res>
    implements _$AccountRequestCreateCopyWith<$Res> {
  __$AccountRequestCreateCopyWithImpl(this._self, this._then);

  final _AccountRequestCreate _self;
  final $Res Function(_AccountRequestCreate) _then;

/// Create a copy of AccountRequestCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? roleId = null,Object? birthdate = freezed,Object? gender = freezed,Object? genderOther = freezed,}) {
  return _then(_AccountRequestCreate(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,genderOther: freezed == genderOther ? _self.genderOther : genderOther // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AccountRequestResponse {

@JsonKey(name: 'request_id') int get requestId;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName; String get email;@JsonKey(name: 'role_id') int get roleId; String? get birthdate; String? get gender;@JsonKey(name: 'gender_other') String? get genderOther; String get status;@JsonKey(name: 'admin_notes') String? get adminNotes;@JsonKey(name: 'reviewed_by') int? get reviewedBy;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'reviewed_at') String? get reviewedAt;
/// Create a copy of AccountRequestResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountRequestResponseCopyWith<AccountRequestResponse> get copyWith => _$AccountRequestResponseCopyWithImpl<AccountRequestResponse>(this as AccountRequestResponse, _$identity);

  /// Serializes this AccountRequestResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountRequestResponse&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.genderOther, genderOther) || other.genderOther == genderOther)&&(identical(other.status, status) || other.status == status)&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,firstName,lastName,email,roleId,birthdate,gender,genderOther,status,adminNotes,reviewedBy,createdAt,reviewedAt);

@override
String toString() {
  return 'AccountRequestResponse(requestId: $requestId, firstName: $firstName, lastName: $lastName, email: $email, roleId: $roleId, birthdate: $birthdate, gender: $gender, genderOther: $genderOther, status: $status, adminNotes: $adminNotes, reviewedBy: $reviewedBy, createdAt: $createdAt, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class $AccountRequestResponseCopyWith<$Res>  {
  factory $AccountRequestResponseCopyWith(AccountRequestResponse value, $Res Function(AccountRequestResponse) _then) = _$AccountRequestResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'request_id') int requestId,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email,@JsonKey(name: 'role_id') int roleId, String? birthdate, String? gender,@JsonKey(name: 'gender_other') String? genderOther, String status,@JsonKey(name: 'admin_notes') String? adminNotes,@JsonKey(name: 'reviewed_by') int? reviewedBy,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'reviewed_at') String? reviewedAt
});




}
/// @nodoc
class _$AccountRequestResponseCopyWithImpl<$Res>
    implements $AccountRequestResponseCopyWith<$Res> {
  _$AccountRequestResponseCopyWithImpl(this._self, this._then);

  final AccountRequestResponse _self;
  final $Res Function(AccountRequestResponse) _then;

/// Create a copy of AccountRequestResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? roleId = null,Object? birthdate = freezed,Object? gender = freezed,Object? genderOther = freezed,Object? status = null,Object? adminNotes = freezed,Object? reviewedBy = freezed,Object? createdAt = freezed,Object? reviewedAt = freezed,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,genderOther: freezed == genderOther ? _self.genderOther : genderOther // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountRequestResponse].
extension AccountRequestResponsePatterns on AccountRequestResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountRequestResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountRequestResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountRequestResponse value)  $default,){
final _that = this;
switch (_that) {
case _AccountRequestResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountRequestResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AccountRequestResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  int requestId, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email, @JsonKey(name: 'role_id')  int roleId,  String? birthdate,  String? gender, @JsonKey(name: 'gender_other')  String? genderOther,  String status, @JsonKey(name: 'admin_notes')  String? adminNotes, @JsonKey(name: 'reviewed_by')  int? reviewedBy, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'reviewed_at')  String? reviewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountRequestResponse() when $default != null:
return $default(_that.requestId,_that.firstName,_that.lastName,_that.email,_that.roleId,_that.birthdate,_that.gender,_that.genderOther,_that.status,_that.adminNotes,_that.reviewedBy,_that.createdAt,_that.reviewedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  int requestId, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email, @JsonKey(name: 'role_id')  int roleId,  String? birthdate,  String? gender, @JsonKey(name: 'gender_other')  String? genderOther,  String status, @JsonKey(name: 'admin_notes')  String? adminNotes, @JsonKey(name: 'reviewed_by')  int? reviewedBy, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'reviewed_at')  String? reviewedAt)  $default,) {final _that = this;
switch (_that) {
case _AccountRequestResponse():
return $default(_that.requestId,_that.firstName,_that.lastName,_that.email,_that.roleId,_that.birthdate,_that.gender,_that.genderOther,_that.status,_that.adminNotes,_that.reviewedBy,_that.createdAt,_that.reviewedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'request_id')  int requestId, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email, @JsonKey(name: 'role_id')  int roleId,  String? birthdate,  String? gender, @JsonKey(name: 'gender_other')  String? genderOther,  String status, @JsonKey(name: 'admin_notes')  String? adminNotes, @JsonKey(name: 'reviewed_by')  int? reviewedBy, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'reviewed_at')  String? reviewedAt)?  $default,) {final _that = this;
switch (_that) {
case _AccountRequestResponse() when $default != null:
return $default(_that.requestId,_that.firstName,_that.lastName,_that.email,_that.roleId,_that.birthdate,_that.gender,_that.genderOther,_that.status,_that.adminNotes,_that.reviewedBy,_that.createdAt,_that.reviewedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountRequestResponse implements AccountRequestResponse {
  const _AccountRequestResponse({@JsonKey(name: 'request_id') required this.requestId, @JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, required this.email, @JsonKey(name: 'role_id') required this.roleId, this.birthdate, this.gender, @JsonKey(name: 'gender_other') this.genderOther, required this.status, @JsonKey(name: 'admin_notes') this.adminNotes, @JsonKey(name: 'reviewed_by') this.reviewedBy, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'reviewed_at') this.reviewedAt});
  factory _AccountRequestResponse.fromJson(Map<String, dynamic> json) => _$AccountRequestResponseFromJson(json);

@override@JsonKey(name: 'request_id') final  int requestId;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override final  String email;
@override@JsonKey(name: 'role_id') final  int roleId;
@override final  String? birthdate;
@override final  String? gender;
@override@JsonKey(name: 'gender_other') final  String? genderOther;
@override final  String status;
@override@JsonKey(name: 'admin_notes') final  String? adminNotes;
@override@JsonKey(name: 'reviewed_by') final  int? reviewedBy;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'reviewed_at') final  String? reviewedAt;

/// Create a copy of AccountRequestResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountRequestResponseCopyWith<_AccountRequestResponse> get copyWith => __$AccountRequestResponseCopyWithImpl<_AccountRequestResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountRequestResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountRequestResponse&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.genderOther, genderOther) || other.genderOther == genderOther)&&(identical(other.status, status) || other.status == status)&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,firstName,lastName,email,roleId,birthdate,gender,genderOther,status,adminNotes,reviewedBy,createdAt,reviewedAt);

@override
String toString() {
  return 'AccountRequestResponse(requestId: $requestId, firstName: $firstName, lastName: $lastName, email: $email, roleId: $roleId, birthdate: $birthdate, gender: $gender, genderOther: $genderOther, status: $status, adminNotes: $adminNotes, reviewedBy: $reviewedBy, createdAt: $createdAt, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class _$AccountRequestResponseCopyWith<$Res> implements $AccountRequestResponseCopyWith<$Res> {
  factory _$AccountRequestResponseCopyWith(_AccountRequestResponse value, $Res Function(_AccountRequestResponse) _then) = __$AccountRequestResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'request_id') int requestId,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email,@JsonKey(name: 'role_id') int roleId, String? birthdate, String? gender,@JsonKey(name: 'gender_other') String? genderOther, String status,@JsonKey(name: 'admin_notes') String? adminNotes,@JsonKey(name: 'reviewed_by') int? reviewedBy,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'reviewed_at') String? reviewedAt
});




}
/// @nodoc
class __$AccountRequestResponseCopyWithImpl<$Res>
    implements _$AccountRequestResponseCopyWith<$Res> {
  __$AccountRequestResponseCopyWithImpl(this._self, this._then);

  final _AccountRequestResponse _self;
  final $Res Function(_AccountRequestResponse) _then;

/// Create a copy of AccountRequestResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? roleId = null,Object? birthdate = freezed,Object? gender = freezed,Object? genderOther = freezed,Object? status = null,Object? adminNotes = freezed,Object? reviewedBy = freezed,Object? createdAt = freezed,Object? reviewedAt = freezed,}) {
  return _then(_AccountRequestResponse(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as int,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,genderOther: freezed == genderOther ? _self.genderOther : genderOther // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AccountRequestCountResponse {

 int get count;
/// Create a copy of AccountRequestCountResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountRequestCountResponseCopyWith<AccountRequestCountResponse> get copyWith => _$AccountRequestCountResponseCopyWithImpl<AccountRequestCountResponse>(this as AccountRequestCountResponse, _$identity);

  /// Serializes this AccountRequestCountResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountRequestCountResponse&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'AccountRequestCountResponse(count: $count)';
}


}

/// @nodoc
abstract mixin class $AccountRequestCountResponseCopyWith<$Res>  {
  factory $AccountRequestCountResponseCopyWith(AccountRequestCountResponse value, $Res Function(AccountRequestCountResponse) _then) = _$AccountRequestCountResponseCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$AccountRequestCountResponseCopyWithImpl<$Res>
    implements $AccountRequestCountResponseCopyWith<$Res> {
  _$AccountRequestCountResponseCopyWithImpl(this._self, this._then);

  final AccountRequestCountResponse _self;
  final $Res Function(AccountRequestCountResponse) _then;

/// Create a copy of AccountRequestCountResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountRequestCountResponse].
extension AccountRequestCountResponsePatterns on AccountRequestCountResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountRequestCountResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountRequestCountResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountRequestCountResponse value)  $default,){
final _that = this;
switch (_that) {
case _AccountRequestCountResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountRequestCountResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AccountRequestCountResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountRequestCountResponse() when $default != null:
return $default(_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count)  $default,) {final _that = this;
switch (_that) {
case _AccountRequestCountResponse():
return $default(_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count)?  $default,) {final _that = this;
switch (_that) {
case _AccountRequestCountResponse() when $default != null:
return $default(_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountRequestCountResponse implements AccountRequestCountResponse {
  const _AccountRequestCountResponse({required this.count});
  factory _AccountRequestCountResponse.fromJson(Map<String, dynamic> json) => _$AccountRequestCountResponseFromJson(json);

@override final  int count;

/// Create a copy of AccountRequestCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountRequestCountResponseCopyWith<_AccountRequestCountResponse> get copyWith => __$AccountRequestCountResponseCopyWithImpl<_AccountRequestCountResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountRequestCountResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountRequestCountResponse&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'AccountRequestCountResponse(count: $count)';
}


}

/// @nodoc
abstract mixin class _$AccountRequestCountResponseCopyWith<$Res> implements $AccountRequestCountResponseCopyWith<$Res> {
  factory _$AccountRequestCountResponseCopyWith(_AccountRequestCountResponse value, $Res Function(_AccountRequestCountResponse) _then) = __$AccountRequestCountResponseCopyWithImpl;
@override @useResult
$Res call({
 int count
});




}
/// @nodoc
class __$AccountRequestCountResponseCopyWithImpl<$Res>
    implements _$AccountRequestCountResponseCopyWith<$Res> {
  __$AccountRequestCountResponseCopyWithImpl(this._self, this._then);

  final _AccountRequestCountResponse _self;
  final $Res Function(_AccountRequestCountResponse) _then;

/// Create a copy of AccountRequestCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(_AccountRequestCountResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AccountRequestRejectBody {

@JsonKey(name: 'admin_notes') String? get adminNotes;
/// Create a copy of AccountRequestRejectBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountRequestRejectBodyCopyWith<AccountRequestRejectBody> get copyWith => _$AccountRequestRejectBodyCopyWithImpl<AccountRequestRejectBody>(this as AccountRequestRejectBody, _$identity);

  /// Serializes this AccountRequestRejectBody to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountRequestRejectBody&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adminNotes);

@override
String toString() {
  return 'AccountRequestRejectBody(adminNotes: $adminNotes)';
}


}

/// @nodoc
abstract mixin class $AccountRequestRejectBodyCopyWith<$Res>  {
  factory $AccountRequestRejectBodyCopyWith(AccountRequestRejectBody value, $Res Function(AccountRequestRejectBody) _then) = _$AccountRequestRejectBodyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'admin_notes') String? adminNotes
});




}
/// @nodoc
class _$AccountRequestRejectBodyCopyWithImpl<$Res>
    implements $AccountRequestRejectBodyCopyWith<$Res> {
  _$AccountRequestRejectBodyCopyWithImpl(this._self, this._then);

  final AccountRequestRejectBody _self;
  final $Res Function(AccountRequestRejectBody) _then;

/// Create a copy of AccountRequestRejectBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adminNotes = freezed,}) {
  return _then(_self.copyWith(
adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountRequestRejectBody].
extension AccountRequestRejectBodyPatterns on AccountRequestRejectBody {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountRequestRejectBody value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountRequestRejectBody() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountRequestRejectBody value)  $default,){
final _that = this;
switch (_that) {
case _AccountRequestRejectBody():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountRequestRejectBody value)?  $default,){
final _that = this;
switch (_that) {
case _AccountRequestRejectBody() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'admin_notes')  String? adminNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountRequestRejectBody() when $default != null:
return $default(_that.adminNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'admin_notes')  String? adminNotes)  $default,) {final _that = this;
switch (_that) {
case _AccountRequestRejectBody():
return $default(_that.adminNotes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'admin_notes')  String? adminNotes)?  $default,) {final _that = this;
switch (_that) {
case _AccountRequestRejectBody() when $default != null:
return $default(_that.adminNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountRequestRejectBody implements AccountRequestRejectBody {
  const _AccountRequestRejectBody({@JsonKey(name: 'admin_notes') this.adminNotes});
  factory _AccountRequestRejectBody.fromJson(Map<String, dynamic> json) => _$AccountRequestRejectBodyFromJson(json);

@override@JsonKey(name: 'admin_notes') final  String? adminNotes;

/// Create a copy of AccountRequestRejectBody
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountRequestRejectBodyCopyWith<_AccountRequestRejectBody> get copyWith => __$AccountRequestRejectBodyCopyWithImpl<_AccountRequestRejectBody>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountRequestRejectBodyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountRequestRejectBody&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adminNotes);

@override
String toString() {
  return 'AccountRequestRejectBody(adminNotes: $adminNotes)';
}


}

/// @nodoc
abstract mixin class _$AccountRequestRejectBodyCopyWith<$Res> implements $AccountRequestRejectBodyCopyWith<$Res> {
  factory _$AccountRequestRejectBodyCopyWith(_AccountRequestRejectBody value, $Res Function(_AccountRequestRejectBody) _then) = __$AccountRequestRejectBodyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'admin_notes') String? adminNotes
});




}
/// @nodoc
class __$AccountRequestRejectBodyCopyWithImpl<$Res>
    implements _$AccountRequestRejectBodyCopyWith<$Res> {
  __$AccountRequestRejectBodyCopyWithImpl(this._self, this._then);

  final _AccountRequestRejectBody _self;
  final $Res Function(_AccountRequestRejectBody) _then;

/// Create a copy of AccountRequestRejectBody
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adminNotes = freezed,}) {
  return _then(_AccountRequestRejectBody(
adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DeletionRequestResponse {

@JsonKey(name: 'request_id') int get requestId;@JsonKey(name: 'account_id') int get accountId;@JsonKey(name: 'full_name') String? get fullName; String get email; String get status;@JsonKey(name: 'admin_notes') String? get adminNotes;@JsonKey(name: 'reviewed_by') int? get reviewedBy;@JsonKey(name: 'requested_at') String get requestedAt;@JsonKey(name: 'reviewed_at') String? get reviewedAt;
/// Create a copy of DeletionRequestResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletionRequestResponseCopyWith<DeletionRequestResponse> get copyWith => _$DeletionRequestResponseCopyWithImpl<DeletionRequestResponse>(this as DeletionRequestResponse, _$identity);

  /// Serializes this DeletionRequestResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletionRequestResponse&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,accountId,fullName,email,status,adminNotes,reviewedBy,requestedAt,reviewedAt);

@override
String toString() {
  return 'DeletionRequestResponse(requestId: $requestId, accountId: $accountId, fullName: $fullName, email: $email, status: $status, adminNotes: $adminNotes, reviewedBy: $reviewedBy, requestedAt: $requestedAt, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class $DeletionRequestResponseCopyWith<$Res>  {
  factory $DeletionRequestResponseCopyWith(DeletionRequestResponse value, $Res Function(DeletionRequestResponse) _then) = _$DeletionRequestResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'request_id') int requestId,@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'full_name') String? fullName, String email, String status,@JsonKey(name: 'admin_notes') String? adminNotes,@JsonKey(name: 'reviewed_by') int? reviewedBy,@JsonKey(name: 'requested_at') String requestedAt,@JsonKey(name: 'reviewed_at') String? reviewedAt
});




}
/// @nodoc
class _$DeletionRequestResponseCopyWithImpl<$Res>
    implements $DeletionRequestResponseCopyWith<$Res> {
  _$DeletionRequestResponseCopyWithImpl(this._self, this._then);

  final DeletionRequestResponse _self;
  final $Res Function(DeletionRequestResponse) _then;

/// Create a copy of DeletionRequestResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? accountId = null,Object? fullName = freezed,Object? email = null,Object? status = null,Object? adminNotes = freezed,Object? reviewedBy = freezed,Object? requestedAt = null,Object? reviewedAt = freezed,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as int?,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as String,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletionRequestResponse].
extension DeletionRequestResponsePatterns on DeletionRequestResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletionRequestResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletionRequestResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletionRequestResponse value)  $default,){
final _that = this;
switch (_that) {
case _DeletionRequestResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletionRequestResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DeletionRequestResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  int requestId, @JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'full_name')  String? fullName,  String email,  String status, @JsonKey(name: 'admin_notes')  String? adminNotes, @JsonKey(name: 'reviewed_by')  int? reviewedBy, @JsonKey(name: 'requested_at')  String requestedAt, @JsonKey(name: 'reviewed_at')  String? reviewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletionRequestResponse() when $default != null:
return $default(_that.requestId,_that.accountId,_that.fullName,_that.email,_that.status,_that.adminNotes,_that.reviewedBy,_that.requestedAt,_that.reviewedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  int requestId, @JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'full_name')  String? fullName,  String email,  String status, @JsonKey(name: 'admin_notes')  String? adminNotes, @JsonKey(name: 'reviewed_by')  int? reviewedBy, @JsonKey(name: 'requested_at')  String requestedAt, @JsonKey(name: 'reviewed_at')  String? reviewedAt)  $default,) {final _that = this;
switch (_that) {
case _DeletionRequestResponse():
return $default(_that.requestId,_that.accountId,_that.fullName,_that.email,_that.status,_that.adminNotes,_that.reviewedBy,_that.requestedAt,_that.reviewedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'request_id')  int requestId, @JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'full_name')  String? fullName,  String email,  String status, @JsonKey(name: 'admin_notes')  String? adminNotes, @JsonKey(name: 'reviewed_by')  int? reviewedBy, @JsonKey(name: 'requested_at')  String requestedAt, @JsonKey(name: 'reviewed_at')  String? reviewedAt)?  $default,) {final _that = this;
switch (_that) {
case _DeletionRequestResponse() when $default != null:
return $default(_that.requestId,_that.accountId,_that.fullName,_that.email,_that.status,_that.adminNotes,_that.reviewedBy,_that.requestedAt,_that.reviewedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeletionRequestResponse implements DeletionRequestResponse {
  const _DeletionRequestResponse({@JsonKey(name: 'request_id') required this.requestId, @JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'full_name') this.fullName, required this.email, required this.status, @JsonKey(name: 'admin_notes') this.adminNotes, @JsonKey(name: 'reviewed_by') this.reviewedBy, @JsonKey(name: 'requested_at') required this.requestedAt, @JsonKey(name: 'reviewed_at') this.reviewedAt});
  factory _DeletionRequestResponse.fromJson(Map<String, dynamic> json) => _$DeletionRequestResponseFromJson(json);

@override@JsonKey(name: 'request_id') final  int requestId;
@override@JsonKey(name: 'account_id') final  int accountId;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override final  String email;
@override final  String status;
@override@JsonKey(name: 'admin_notes') final  String? adminNotes;
@override@JsonKey(name: 'reviewed_by') final  int? reviewedBy;
@override@JsonKey(name: 'requested_at') final  String requestedAt;
@override@JsonKey(name: 'reviewed_at') final  String? reviewedAt;

/// Create a copy of DeletionRequestResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletionRequestResponseCopyWith<_DeletionRequestResponse> get copyWith => __$DeletionRequestResponseCopyWithImpl<_DeletionRequestResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletionRequestResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletionRequestResponse&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,accountId,fullName,email,status,adminNotes,reviewedBy,requestedAt,reviewedAt);

@override
String toString() {
  return 'DeletionRequestResponse(requestId: $requestId, accountId: $accountId, fullName: $fullName, email: $email, status: $status, adminNotes: $adminNotes, reviewedBy: $reviewedBy, requestedAt: $requestedAt, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class _$DeletionRequestResponseCopyWith<$Res> implements $DeletionRequestResponseCopyWith<$Res> {
  factory _$DeletionRequestResponseCopyWith(_DeletionRequestResponse value, $Res Function(_DeletionRequestResponse) _then) = __$DeletionRequestResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'request_id') int requestId,@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'full_name') String? fullName, String email, String status,@JsonKey(name: 'admin_notes') String? adminNotes,@JsonKey(name: 'reviewed_by') int? reviewedBy,@JsonKey(name: 'requested_at') String requestedAt,@JsonKey(name: 'reviewed_at') String? reviewedAt
});




}
/// @nodoc
class __$DeletionRequestResponseCopyWithImpl<$Res>
    implements _$DeletionRequestResponseCopyWith<$Res> {
  __$DeletionRequestResponseCopyWithImpl(this._self, this._then);

  final _DeletionRequestResponse _self;
  final $Res Function(_DeletionRequestResponse) _then;

/// Create a copy of DeletionRequestResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? accountId = null,Object? fullName = freezed,Object? email = null,Object? status = null,Object? adminNotes = freezed,Object? reviewedBy = freezed,Object? requestedAt = null,Object? reviewedAt = freezed,}) {
  return _then(_DeletionRequestResponse(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as int?,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as String,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DeletionRequestCountResponse {

 int get count;
/// Create a copy of DeletionRequestCountResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletionRequestCountResponseCopyWith<DeletionRequestCountResponse> get copyWith => _$DeletionRequestCountResponseCopyWithImpl<DeletionRequestCountResponse>(this as DeletionRequestCountResponse, _$identity);

  /// Serializes this DeletionRequestCountResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletionRequestCountResponse&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'DeletionRequestCountResponse(count: $count)';
}


}

/// @nodoc
abstract mixin class $DeletionRequestCountResponseCopyWith<$Res>  {
  factory $DeletionRequestCountResponseCopyWith(DeletionRequestCountResponse value, $Res Function(DeletionRequestCountResponse) _then) = _$DeletionRequestCountResponseCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$DeletionRequestCountResponseCopyWithImpl<$Res>
    implements $DeletionRequestCountResponseCopyWith<$Res> {
  _$DeletionRequestCountResponseCopyWithImpl(this._self, this._then);

  final DeletionRequestCountResponse _self;
  final $Res Function(DeletionRequestCountResponse) _then;

/// Create a copy of DeletionRequestCountResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletionRequestCountResponse].
extension DeletionRequestCountResponsePatterns on DeletionRequestCountResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletionRequestCountResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletionRequestCountResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletionRequestCountResponse value)  $default,){
final _that = this;
switch (_that) {
case _DeletionRequestCountResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletionRequestCountResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DeletionRequestCountResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletionRequestCountResponse() when $default != null:
return $default(_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count)  $default,) {final _that = this;
switch (_that) {
case _DeletionRequestCountResponse():
return $default(_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count)?  $default,) {final _that = this;
switch (_that) {
case _DeletionRequestCountResponse() when $default != null:
return $default(_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeletionRequestCountResponse implements DeletionRequestCountResponse {
  const _DeletionRequestCountResponse({required this.count});
  factory _DeletionRequestCountResponse.fromJson(Map<String, dynamic> json) => _$DeletionRequestCountResponseFromJson(json);

@override final  int count;

/// Create a copy of DeletionRequestCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletionRequestCountResponseCopyWith<_DeletionRequestCountResponse> get copyWith => __$DeletionRequestCountResponseCopyWithImpl<_DeletionRequestCountResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletionRequestCountResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletionRequestCountResponse&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'DeletionRequestCountResponse(count: $count)';
}


}

/// @nodoc
abstract mixin class _$DeletionRequestCountResponseCopyWith<$Res> implements $DeletionRequestCountResponseCopyWith<$Res> {
  factory _$DeletionRequestCountResponseCopyWith(_DeletionRequestCountResponse value, $Res Function(_DeletionRequestCountResponse) _then) = __$DeletionRequestCountResponseCopyWithImpl;
@override @useResult
$Res call({
 int count
});




}
/// @nodoc
class __$DeletionRequestCountResponseCopyWithImpl<$Res>
    implements _$DeletionRequestCountResponseCopyWith<$Res> {
  __$DeletionRequestCountResponseCopyWithImpl(this._self, this._then);

  final _DeletionRequestCountResponse _self;
  final $Res Function(_DeletionRequestCountResponse) _then;

/// Create a copy of DeletionRequestCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(_DeletionRequestCountResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
