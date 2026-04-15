// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserCreate {

@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName; String get email; String? get password; UserRole? get role;@JsonKey(name: 'is_active') bool? get isActive;@JsonKey(name: 'send_setup_email') bool? get sendSetupEmail; String? get birthdate; String? get gender;
/// Create a copy of UserCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCreateCopyWith<UserCreate> get copyWith => _$UserCreateCopyWithImpl<UserCreate>(this as UserCreate, _$identity);

  /// Serializes this UserCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserCreate&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.sendSetupEmail, sendSetupEmail) || other.sendSetupEmail == sendSetupEmail)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,password,role,isActive,sendSetupEmail,birthdate,gender);

@override
String toString() {
  return 'UserCreate(firstName: $firstName, lastName: $lastName, email: $email, password: $password, role: $role, isActive: $isActive, sendSetupEmail: $sendSetupEmail, birthdate: $birthdate, gender: $gender)';
}


}

/// @nodoc
abstract mixin class $UserCreateCopyWith<$Res>  {
  factory $UserCreateCopyWith(UserCreate value, $Res Function(UserCreate) _then) = _$UserCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email, String? password, UserRole? role,@JsonKey(name: 'is_active') bool? isActive,@JsonKey(name: 'send_setup_email') bool? sendSetupEmail, String? birthdate, String? gender
});




}
/// @nodoc
class _$UserCreateCopyWithImpl<$Res>
    implements $UserCreateCopyWith<$Res> {
  _$UserCreateCopyWithImpl(this._self, this._then);

  final UserCreate _self;
  final $Res Function(UserCreate) _then;

/// Create a copy of UserCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? password = freezed,Object? role = freezed,Object? isActive = freezed,Object? sendSetupEmail = freezed,Object? birthdate = freezed,Object? gender = freezed,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,sendSetupEmail: freezed == sendSetupEmail ? _self.sendSetupEmail : sendSetupEmail // ignore: cast_nullable_to_non_nullable
as bool?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserCreate].
extension UserCreatePatterns on UserCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserCreate value)  $default,){
final _that = this;
switch (_that) {
case _UserCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserCreate value)?  $default,){
final _that = this;
switch (_that) {
case _UserCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? password,  UserRole? role, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'send_setup_email')  bool? sendSetupEmail,  String? birthdate,  String? gender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserCreate() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.password,_that.role,_that.isActive,_that.sendSetupEmail,_that.birthdate,_that.gender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? password,  UserRole? role, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'send_setup_email')  bool? sendSetupEmail,  String? birthdate,  String? gender)  $default,) {final _that = this;
switch (_that) {
case _UserCreate():
return $default(_that.firstName,_that.lastName,_that.email,_that.password,_that.role,_that.isActive,_that.sendSetupEmail,_that.birthdate,_that.gender);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? password,  UserRole? role, @JsonKey(name: 'is_active')  bool? isActive, @JsonKey(name: 'send_setup_email')  bool? sendSetupEmail,  String? birthdate,  String? gender)?  $default,) {final _that = this;
switch (_that) {
case _UserCreate() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.password,_that.role,_that.isActive,_that.sendSetupEmail,_that.birthdate,_that.gender);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserCreate implements UserCreate {
  const _UserCreate({@JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, required this.email, this.password, this.role, @JsonKey(name: 'is_active') this.isActive, @JsonKey(name: 'send_setup_email') this.sendSetupEmail, this.birthdate, this.gender});
  factory _UserCreate.fromJson(Map<String, dynamic> json) => _$UserCreateFromJson(json);

@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override final  String email;
@override final  String? password;
@override final  UserRole? role;
@override@JsonKey(name: 'is_active') final  bool? isActive;
@override@JsonKey(name: 'send_setup_email') final  bool? sendSetupEmail;
@override final  String? birthdate;
@override final  String? gender;

/// Create a copy of UserCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCreateCopyWith<_UserCreate> get copyWith => __$UserCreateCopyWithImpl<_UserCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserCreate&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.sendSetupEmail, sendSetupEmail) || other.sendSetupEmail == sendSetupEmail)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,password,role,isActive,sendSetupEmail,birthdate,gender);

@override
String toString() {
  return 'UserCreate(firstName: $firstName, lastName: $lastName, email: $email, password: $password, role: $role, isActive: $isActive, sendSetupEmail: $sendSetupEmail, birthdate: $birthdate, gender: $gender)';
}


}

/// @nodoc
abstract mixin class _$UserCreateCopyWith<$Res> implements $UserCreateCopyWith<$Res> {
  factory _$UserCreateCopyWith(_UserCreate value, $Res Function(_UserCreate) _then) = __$UserCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email, String? password, UserRole? role,@JsonKey(name: 'is_active') bool? isActive,@JsonKey(name: 'send_setup_email') bool? sendSetupEmail, String? birthdate, String? gender
});




}
/// @nodoc
class __$UserCreateCopyWithImpl<$Res>
    implements _$UserCreateCopyWith<$Res> {
  __$UserCreateCopyWithImpl(this._self, this._then);

  final _UserCreate _self;
  final $Res Function(_UserCreate) _then;

/// Create a copy of UserCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? password = freezed,Object? role = freezed,Object? isActive = freezed,Object? sendSetupEmail = freezed,Object? birthdate = freezed,Object? gender = freezed,}) {
  return _then(_UserCreate(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,sendSetupEmail: freezed == sendSetupEmail ? _self.sendSetupEmail : sendSetupEmail // ignore: cast_nullable_to_non_nullable
as bool?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UserUpdate {

@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName; String? get email; UserRole? get role;@JsonKey(name: 'is_active') bool? get isActive;
/// Create a copy of UserUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserUpdateCopyWith<UserUpdate> get copyWith => _$UserUpdateCopyWithImpl<UserUpdate>(this as UserUpdate, _$identity);

  /// Serializes this UserUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserUpdate&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,role,isActive);

@override
String toString() {
  return 'UserUpdate(firstName: $firstName, lastName: $lastName, email: $email, role: $role, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $UserUpdateCopyWith<$Res>  {
  factory $UserUpdateCopyWith(UserUpdate value, $Res Function(UserUpdate) _then) = _$UserUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? email, UserRole? role,@JsonKey(name: 'is_active') bool? isActive
});




}
/// @nodoc
class _$UserUpdateCopyWithImpl<$Res>
    implements $UserUpdateCopyWith<$Res> {
  _$UserUpdateCopyWithImpl(this._self, this._then);

  final UserUpdate _self;
  final $Res Function(UserUpdate) _then;

/// Create a copy of UserUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? role = freezed,Object? isActive = freezed,}) {
  return _then(_self.copyWith(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserUpdate].
extension UserUpdatePatterns on UserUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserUpdate value)  $default,){
final _that = this;
switch (_that) {
case _UserUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _UserUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  UserRole? role, @JsonKey(name: 'is_active')  bool? isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserUpdate() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.role,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  UserRole? role, @JsonKey(name: 'is_active')  bool? isActive)  $default,) {final _that = this;
switch (_that) {
case _UserUpdate():
return $default(_that.firstName,_that.lastName,_that.email,_that.role,_that.isActive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  UserRole? role, @JsonKey(name: 'is_active')  bool? isActive)?  $default,) {final _that = this;
switch (_that) {
case _UserUpdate() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.role,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserUpdate implements UserUpdate {
  const _UserUpdate({@JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, this.email, this.role, @JsonKey(name: 'is_active') this.isActive});
  factory _UserUpdate.fromJson(Map<String, dynamic> json) => _$UserUpdateFromJson(json);

@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String? email;
@override final  UserRole? role;
@override@JsonKey(name: 'is_active') final  bool? isActive;

/// Create a copy of UserUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserUpdateCopyWith<_UserUpdate> get copyWith => __$UserUpdateCopyWithImpl<_UserUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserUpdate&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,role,isActive);

@override
String toString() {
  return 'UserUpdate(firstName: $firstName, lastName: $lastName, email: $email, role: $role, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UserUpdateCopyWith<$Res> implements $UserUpdateCopyWith<$Res> {
  factory _$UserUpdateCopyWith(_UserUpdate value, $Res Function(_UserUpdate) _then) = __$UserUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? email, UserRole? role,@JsonKey(name: 'is_active') bool? isActive
});




}
/// @nodoc
class __$UserUpdateCopyWithImpl<$Res>
    implements _$UserUpdateCopyWith<$Res> {
  __$UserUpdateCopyWithImpl(this._self, this._then);

  final _UserUpdate _self;
  final $Res Function(_UserUpdate) _then;

/// Create a copy of UserUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? role = freezed,Object? isActive = freezed,}) {
  return _then(_UserUpdate(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$CurrentUserUpdate {

@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName; String? get email; DateTime? get birthdate; String? get gender;
/// Create a copy of CurrentUserUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentUserUpdateCopyWith<CurrentUserUpdate> get copyWith => _$CurrentUserUpdateCopyWithImpl<CurrentUserUpdate>(this as CurrentUserUpdate, _$identity);

  /// Serializes this CurrentUserUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentUserUpdate&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,birthdate,gender);

@override
String toString() {
  return 'CurrentUserUpdate(firstName: $firstName, lastName: $lastName, email: $email, birthdate: $birthdate, gender: $gender)';
}


}

/// @nodoc
abstract mixin class $CurrentUserUpdateCopyWith<$Res>  {
  factory $CurrentUserUpdateCopyWith(CurrentUserUpdate value, $Res Function(CurrentUserUpdate) _then) = _$CurrentUserUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? email, DateTime? birthdate, String? gender
});




}
/// @nodoc
class _$CurrentUserUpdateCopyWithImpl<$Res>
    implements $CurrentUserUpdateCopyWith<$Res> {
  _$CurrentUserUpdateCopyWithImpl(this._self, this._then);

  final CurrentUserUpdate _self;
  final $Res Function(CurrentUserUpdate) _then;

/// Create a copy of CurrentUserUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? birthdate = freezed,Object? gender = freezed,}) {
  return _then(_self.copyWith(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentUserUpdate].
extension CurrentUserUpdatePatterns on CurrentUserUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentUserUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentUserUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentUserUpdate value)  $default,){
final _that = this;
switch (_that) {
case _CurrentUserUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentUserUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentUserUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  DateTime? birthdate,  String? gender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentUserUpdate() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.birthdate,_that.gender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  DateTime? birthdate,  String? gender)  $default,) {final _that = this;
switch (_that) {
case _CurrentUserUpdate():
return $default(_that.firstName,_that.lastName,_that.email,_that.birthdate,_that.gender);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  DateTime? birthdate,  String? gender)?  $default,) {final _that = this;
switch (_that) {
case _CurrentUserUpdate() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.birthdate,_that.gender);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentUserUpdate implements CurrentUserUpdate {
  const _CurrentUserUpdate({@JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, this.email, this.birthdate, this.gender});
  factory _CurrentUserUpdate.fromJson(Map<String, dynamic> json) => _$CurrentUserUpdateFromJson(json);

@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String? email;
@override final  DateTime? birthdate;
@override final  String? gender;

/// Create a copy of CurrentUserUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentUserUpdateCopyWith<_CurrentUserUpdate> get copyWith => __$CurrentUserUpdateCopyWithImpl<_CurrentUserUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentUserUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentUserUpdate&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,birthdate,gender);

@override
String toString() {
  return 'CurrentUserUpdate(firstName: $firstName, lastName: $lastName, email: $email, birthdate: $birthdate, gender: $gender)';
}


}

/// @nodoc
abstract mixin class _$CurrentUserUpdateCopyWith<$Res> implements $CurrentUserUpdateCopyWith<$Res> {
  factory _$CurrentUserUpdateCopyWith(_CurrentUserUpdate value, $Res Function(_CurrentUserUpdate) _then) = __$CurrentUserUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? email, DateTime? birthdate, String? gender
});




}
/// @nodoc
class __$CurrentUserUpdateCopyWithImpl<$Res>
    implements _$CurrentUserUpdateCopyWith<$Res> {
  __$CurrentUserUpdateCopyWithImpl(this._self, this._then);

  final _CurrentUserUpdate _self;
  final $Res Function(_CurrentUserUpdate) _then;

/// Create a copy of CurrentUserUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? birthdate = freezed,Object? gender = freezed,}) {
  return _then(_CurrentUserUpdate(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$User {

@JsonKey(name: 'account_id') int get accountId;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName; String get email; String? get role;@JsonKey(name: 'is_active') bool get isActive; DateTime? get birthdate; String? get gender;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'last_login') DateTime? get lastLogin;@JsonKey(name: 'consent_signed_at') DateTime? get consentSignedAt;@JsonKey(name: 'consent_version') String? get consentVersion;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin)&&(identical(other.consentSignedAt, consentSignedAt) || other.consentSignedAt == consentSignedAt)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,firstName,lastName,email,role,isActive,birthdate,gender,createdAt,lastLogin,consentSignedAt,consentVersion);

@override
String toString() {
  return 'User(accountId: $accountId, firstName: $firstName, lastName: $lastName, email: $email, role: $role, isActive: $isActive, birthdate: $birthdate, gender: $gender, createdAt: $createdAt, lastLogin: $lastLogin, consentSignedAt: $consentSignedAt, consentVersion: $consentVersion)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email, String? role,@JsonKey(name: 'is_active') bool isActive, DateTime? birthdate, String? gender,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'last_login') DateTime? lastLogin,@JsonKey(name: 'consent_signed_at') DateTime? consentSignedAt,@JsonKey(name: 'consent_version') String? consentVersion
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? role = freezed,Object? isActive = null,Object? birthdate = freezed,Object? gender = freezed,Object? createdAt = freezed,Object? lastLogin = freezed,Object? consentSignedAt = freezed,Object? consentVersion = freezed,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLogin: freezed == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as DateTime?,consentSignedAt: freezed == consentSignedAt ? _self.consentSignedAt : consentSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,consentVersion: freezed == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? role, @JsonKey(name: 'is_active')  bool isActive,  DateTime? birthdate,  String? gender, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_login')  DateTime? lastLogin, @JsonKey(name: 'consent_signed_at')  DateTime? consentSignedAt, @JsonKey(name: 'consent_version')  String? consentVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.accountId,_that.firstName,_that.lastName,_that.email,_that.role,_that.isActive,_that.birthdate,_that.gender,_that.createdAt,_that.lastLogin,_that.consentSignedAt,_that.consentVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? role, @JsonKey(name: 'is_active')  bool isActive,  DateTime? birthdate,  String? gender, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_login')  DateTime? lastLogin, @JsonKey(name: 'consent_signed_at')  DateTime? consentSignedAt, @JsonKey(name: 'consent_version')  String? consentVersion)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.accountId,_that.firstName,_that.lastName,_that.email,_that.role,_that.isActive,_that.birthdate,_that.gender,_that.createdAt,_that.lastLogin,_that.consentSignedAt,_that.consentVersion);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName,  String email,  String? role, @JsonKey(name: 'is_active')  bool isActive,  DateTime? birthdate,  String? gender, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_login')  DateTime? lastLogin, @JsonKey(name: 'consent_signed_at')  DateTime? consentSignedAt, @JsonKey(name: 'consent_version')  String? consentVersion)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.accountId,_that.firstName,_that.lastName,_that.email,_that.role,_that.isActive,_that.birthdate,_that.gender,_that.createdAt,_that.lastLogin,_that.consentSignedAt,_that.consentVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, required this.email, this.role, @JsonKey(name: 'is_active') this.isActive = true, this.birthdate, this.gender, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'last_login') this.lastLogin, @JsonKey(name: 'consent_signed_at') this.consentSignedAt, @JsonKey(name: 'consent_version') this.consentVersion});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(name: 'account_id') final  int accountId;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override final  String email;
@override final  String? role;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override final  DateTime? birthdate;
@override final  String? gender;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'last_login') final  DateTime? lastLogin;
@override@JsonKey(name: 'consent_signed_at') final  DateTime? consentSignedAt;
@override@JsonKey(name: 'consent_version') final  String? consentVersion;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin)&&(identical(other.consentSignedAt, consentSignedAt) || other.consentSignedAt == consentSignedAt)&&(identical(other.consentVersion, consentVersion) || other.consentVersion == consentVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,firstName,lastName,email,role,isActive,birthdate,gender,createdAt,lastLogin,consentSignedAt,consentVersion);

@override
String toString() {
  return 'User(accountId: $accountId, firstName: $firstName, lastName: $lastName, email: $email, role: $role, isActive: $isActive, birthdate: $birthdate, gender: $gender, createdAt: $createdAt, lastLogin: $lastLogin, consentSignedAt: $consentSignedAt, consentVersion: $consentVersion)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName, String email, String? role,@JsonKey(name: 'is_active') bool isActive, DateTime? birthdate, String? gender,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'last_login') DateTime? lastLogin,@JsonKey(name: 'consent_signed_at') DateTime? consentSignedAt,@JsonKey(name: 'consent_version') String? consentVersion
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? role = freezed,Object? isActive = null,Object? birthdate = freezed,Object? gender = freezed,Object? createdAt = freezed,Object? lastLogin = freezed,Object? consentSignedAt = freezed,Object? consentVersion = freezed,}) {
  return _then(_User(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLogin: freezed == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as DateTime?,consentSignedAt: freezed == consentSignedAt ? _self.consentSignedAt : consentSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,consentVersion: freezed == consentVersion ? _self.consentVersion : consentVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UserListResponse {

 List<User> get users; int get total;
/// Create a copy of UserListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserListResponseCopyWith<UserListResponse> get copyWith => _$UserListResponseCopyWithImpl<UserListResponse>(this as UserListResponse, _$identity);

  /// Serializes this UserListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserListResponse&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users),total);

@override
String toString() {
  return 'UserListResponse(users: $users, total: $total)';
}


}

/// @nodoc
abstract mixin class $UserListResponseCopyWith<$Res>  {
  factory $UserListResponseCopyWith(UserListResponse value, $Res Function(UserListResponse) _then) = _$UserListResponseCopyWithImpl;
@useResult
$Res call({
 List<User> users, int total
});




}
/// @nodoc
class _$UserListResponseCopyWithImpl<$Res>
    implements $UserListResponseCopyWith<$Res> {
  _$UserListResponseCopyWithImpl(this._self, this._then);

  final UserListResponse _self;
  final $Res Function(UserListResponse) _then;

/// Create a copy of UserListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? total = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<User>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserListResponse].
extension UserListResponsePatterns on UserListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserListResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<User> users,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserListResponse() when $default != null:
return $default(_that.users,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<User> users,  int total)  $default,) {final _that = this;
switch (_that) {
case _UserListResponse():
return $default(_that.users,_that.total);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<User> users,  int total)?  $default,) {final _that = this;
switch (_that) {
case _UserListResponse() when $default != null:
return $default(_that.users,_that.total);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UserListResponse implements UserListResponse {
  const _UserListResponse({required final  List<User> users, required this.total}): _users = users;
  factory _UserListResponse.fromJson(Map<String, dynamic> json) => _$UserListResponseFromJson(json);

 final  List<User> _users;
@override List<User> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

@override final  int total;

/// Create a copy of UserListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserListResponseCopyWith<_UserListResponse> get copyWith => __$UserListResponseCopyWithImpl<_UserListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserListResponse&&const DeepCollectionEquality().equals(other._users, _users)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),total);

@override
String toString() {
  return 'UserListResponse(users: $users, total: $total)';
}


}

/// @nodoc
abstract mixin class _$UserListResponseCopyWith<$Res> implements $UserListResponseCopyWith<$Res> {
  factory _$UserListResponseCopyWith(_UserListResponse value, $Res Function(_UserListResponse) _then) = __$UserListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<User> users, int total
});




}
/// @nodoc
class __$UserListResponseCopyWithImpl<$Res>
    implements _$UserListResponseCopyWith<$Res> {
  __$UserListResponseCopyWithImpl(this._self, this._then);

  final _UserListResponse _self;
  final $Res Function(_UserListResponse) _then;

/// Create a copy of UserListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? total = null,}) {
  return _then(_UserListResponse(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<User>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
