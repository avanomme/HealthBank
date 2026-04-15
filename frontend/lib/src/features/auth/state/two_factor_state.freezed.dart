// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'two_factor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TwoFactorState {

 bool get isBusy; String? get error; String? get provisioningUri; String? get confirmMessage;
/// Create a copy of TwoFactorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TwoFactorStateCopyWith<TwoFactorState> get copyWith => _$TwoFactorStateCopyWithImpl<TwoFactorState>(this as TwoFactorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TwoFactorState&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.error, error) || other.error == error)&&(identical(other.provisioningUri, provisioningUri) || other.provisioningUri == provisioningUri)&&(identical(other.confirmMessage, confirmMessage) || other.confirmMessage == confirmMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isBusy,error,provisioningUri,confirmMessage);

@override
String toString() {
  return 'TwoFactorState(isBusy: $isBusy, error: $error, provisioningUri: $provisioningUri, confirmMessage: $confirmMessage)';
}


}

/// @nodoc
abstract mixin class $TwoFactorStateCopyWith<$Res>  {
  factory $TwoFactorStateCopyWith(TwoFactorState value, $Res Function(TwoFactorState) _then) = _$TwoFactorStateCopyWithImpl;
@useResult
$Res call({
 bool isBusy, String? error, String? provisioningUri, String? confirmMessage
});




}
/// @nodoc
class _$TwoFactorStateCopyWithImpl<$Res>
    implements $TwoFactorStateCopyWith<$Res> {
  _$TwoFactorStateCopyWithImpl(this._self, this._then);

  final TwoFactorState _self;
  final $Res Function(TwoFactorState) _then;

/// Create a copy of TwoFactorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isBusy = null,Object? error = freezed,Object? provisioningUri = freezed,Object? confirmMessage = freezed,}) {
  return _then(_self.copyWith(
isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,provisioningUri: freezed == provisioningUri ? _self.provisioningUri : provisioningUri // ignore: cast_nullable_to_non_nullable
as String?,confirmMessage: freezed == confirmMessage ? _self.confirmMessage : confirmMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TwoFactorState].
extension TwoFactorStatePatterns on TwoFactorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TwoFactorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TwoFactorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TwoFactorState value)  $default,){
final _that = this;
switch (_that) {
case _TwoFactorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TwoFactorState value)?  $default,){
final _that = this;
switch (_that) {
case _TwoFactorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isBusy,  String? error,  String? provisioningUri,  String? confirmMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TwoFactorState() when $default != null:
return $default(_that.isBusy,_that.error,_that.provisioningUri,_that.confirmMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isBusy,  String? error,  String? provisioningUri,  String? confirmMessage)  $default,) {final _that = this;
switch (_that) {
case _TwoFactorState():
return $default(_that.isBusy,_that.error,_that.provisioningUri,_that.confirmMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isBusy,  String? error,  String? provisioningUri,  String? confirmMessage)?  $default,) {final _that = this;
switch (_that) {
case _TwoFactorState() when $default != null:
return $default(_that.isBusy,_that.error,_that.provisioningUri,_that.confirmMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TwoFactorState implements TwoFactorState {
  const _TwoFactorState({this.isBusy = false, this.error, this.provisioningUri, this.confirmMessage});
  

@override@JsonKey() final  bool isBusy;
@override final  String? error;
@override final  String? provisioningUri;
@override final  String? confirmMessage;

/// Create a copy of TwoFactorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TwoFactorStateCopyWith<_TwoFactorState> get copyWith => __$TwoFactorStateCopyWithImpl<_TwoFactorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TwoFactorState&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.error, error) || other.error == error)&&(identical(other.provisioningUri, provisioningUri) || other.provisioningUri == provisioningUri)&&(identical(other.confirmMessage, confirmMessage) || other.confirmMessage == confirmMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isBusy,error,provisioningUri,confirmMessage);

@override
String toString() {
  return 'TwoFactorState(isBusy: $isBusy, error: $error, provisioningUri: $provisioningUri, confirmMessage: $confirmMessage)';
}


}

/// @nodoc
abstract mixin class _$TwoFactorStateCopyWith<$Res> implements $TwoFactorStateCopyWith<$Res> {
  factory _$TwoFactorStateCopyWith(_TwoFactorState value, $Res Function(_TwoFactorState) _then) = __$TwoFactorStateCopyWithImpl;
@override @useResult
$Res call({
 bool isBusy, String? error, String? provisioningUri, String? confirmMessage
});




}
/// @nodoc
class __$TwoFactorStateCopyWithImpl<$Res>
    implements _$TwoFactorStateCopyWith<$Res> {
  __$TwoFactorStateCopyWithImpl(this._self, this._then);

  final _TwoFactorState _self;
  final $Res Function(_TwoFactorState) _then;

/// Create a copy of TwoFactorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isBusy = null,Object? error = freezed,Object? provisioningUri = freezed,Object? confirmMessage = freezed,}) {
  return _then(_TwoFactorState(
isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,provisioningUri: freezed == provisioningUri ? _self.provisioningUri : provisioningUri // ignore: cast_nullable_to_non_nullable
as String?,confirmMessage: freezed == confirmMessage ? _self.confirmMessage : confirmMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
