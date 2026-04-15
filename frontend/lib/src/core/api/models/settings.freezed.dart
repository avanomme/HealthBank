// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SystemSettings {

@JsonKey(name: 'k_anonymity_threshold') int get kAnonymityThreshold;@JsonKey(name: 'registration_open') bool get registrationOpen;@JsonKey(name: 'maintenance_mode') bool get maintenanceMode;@JsonKey(name: 'maintenance_message') String get maintenanceMessage;@JsonKey(name: 'maintenance_completion') String get maintenanceCompletion;@JsonKey(name: 'max_login_attempts') int get maxLoginAttempts;@JsonKey(name: 'lockout_duration_minutes') int get lockoutDurationMinutes;@JsonKey(name: 'consent_required') bool get consentRequired; Map<String, dynamic> get defaults;
/// Create a copy of SystemSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemSettingsCopyWith<SystemSettings> get copyWith => _$SystemSettingsCopyWithImpl<SystemSettings>(this as SystemSettings, _$identity);

  /// Serializes this SystemSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemSettings&&(identical(other.kAnonymityThreshold, kAnonymityThreshold) || other.kAnonymityThreshold == kAnonymityThreshold)&&(identical(other.registrationOpen, registrationOpen) || other.registrationOpen == registrationOpen)&&(identical(other.maintenanceMode, maintenanceMode) || other.maintenanceMode == maintenanceMode)&&(identical(other.maintenanceMessage, maintenanceMessage) || other.maintenanceMessage == maintenanceMessage)&&(identical(other.maintenanceCompletion, maintenanceCompletion) || other.maintenanceCompletion == maintenanceCompletion)&&(identical(other.maxLoginAttempts, maxLoginAttempts) || other.maxLoginAttempts == maxLoginAttempts)&&(identical(other.lockoutDurationMinutes, lockoutDurationMinutes) || other.lockoutDurationMinutes == lockoutDurationMinutes)&&(identical(other.consentRequired, consentRequired) || other.consentRequired == consentRequired)&&const DeepCollectionEquality().equals(other.defaults, defaults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kAnonymityThreshold,registrationOpen,maintenanceMode,maintenanceMessage,maintenanceCompletion,maxLoginAttempts,lockoutDurationMinutes,consentRequired,const DeepCollectionEquality().hash(defaults));

@override
String toString() {
  return 'SystemSettings(kAnonymityThreshold: $kAnonymityThreshold, registrationOpen: $registrationOpen, maintenanceMode: $maintenanceMode, maintenanceMessage: $maintenanceMessage, maintenanceCompletion: $maintenanceCompletion, maxLoginAttempts: $maxLoginAttempts, lockoutDurationMinutes: $lockoutDurationMinutes, consentRequired: $consentRequired, defaults: $defaults)';
}


}

/// @nodoc
abstract mixin class $SystemSettingsCopyWith<$Res>  {
  factory $SystemSettingsCopyWith(SystemSettings value, $Res Function(SystemSettings) _then) = _$SystemSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'k_anonymity_threshold') int kAnonymityThreshold,@JsonKey(name: 'registration_open') bool registrationOpen,@JsonKey(name: 'maintenance_mode') bool maintenanceMode,@JsonKey(name: 'maintenance_message') String maintenanceMessage,@JsonKey(name: 'maintenance_completion') String maintenanceCompletion,@JsonKey(name: 'max_login_attempts') int maxLoginAttempts,@JsonKey(name: 'lockout_duration_minutes') int lockoutDurationMinutes,@JsonKey(name: 'consent_required') bool consentRequired, Map<String, dynamic> defaults
});




}
/// @nodoc
class _$SystemSettingsCopyWithImpl<$Res>
    implements $SystemSettingsCopyWith<$Res> {
  _$SystemSettingsCopyWithImpl(this._self, this._then);

  final SystemSettings _self;
  final $Res Function(SystemSettings) _then;

/// Create a copy of SystemSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kAnonymityThreshold = null,Object? registrationOpen = null,Object? maintenanceMode = null,Object? maintenanceMessage = null,Object? maintenanceCompletion = null,Object? maxLoginAttempts = null,Object? lockoutDurationMinutes = null,Object? consentRequired = null,Object? defaults = null,}) {
  return _then(_self.copyWith(
kAnonymityThreshold: null == kAnonymityThreshold ? _self.kAnonymityThreshold : kAnonymityThreshold // ignore: cast_nullable_to_non_nullable
as int,registrationOpen: null == registrationOpen ? _self.registrationOpen : registrationOpen // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMode: null == maintenanceMode ? _self.maintenanceMode : maintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMessage: null == maintenanceMessage ? _self.maintenanceMessage : maintenanceMessage // ignore: cast_nullable_to_non_nullable
as String,maintenanceCompletion: null == maintenanceCompletion ? _self.maintenanceCompletion : maintenanceCompletion // ignore: cast_nullable_to_non_nullable
as String,maxLoginAttempts: null == maxLoginAttempts ? _self.maxLoginAttempts : maxLoginAttempts // ignore: cast_nullable_to_non_nullable
as int,lockoutDurationMinutes: null == lockoutDurationMinutes ? _self.lockoutDurationMinutes : lockoutDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,consentRequired: null == consentRequired ? _self.consentRequired : consentRequired // ignore: cast_nullable_to_non_nullable
as bool,defaults: null == defaults ? _self.defaults : defaults // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [SystemSettings].
extension SystemSettingsPatterns on SystemSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemSettings value)  $default,){
final _that = this;
switch (_that) {
case _SystemSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemSettings value)?  $default,){
final _that = this;
switch (_that) {
case _SystemSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'k_anonymity_threshold')  int kAnonymityThreshold, @JsonKey(name: 'registration_open')  bool registrationOpen, @JsonKey(name: 'maintenance_mode')  bool maintenanceMode, @JsonKey(name: 'maintenance_message')  String maintenanceMessage, @JsonKey(name: 'maintenance_completion')  String maintenanceCompletion, @JsonKey(name: 'max_login_attempts')  int maxLoginAttempts, @JsonKey(name: 'lockout_duration_minutes')  int lockoutDurationMinutes, @JsonKey(name: 'consent_required')  bool consentRequired,  Map<String, dynamic> defaults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemSettings() when $default != null:
return $default(_that.kAnonymityThreshold,_that.registrationOpen,_that.maintenanceMode,_that.maintenanceMessage,_that.maintenanceCompletion,_that.maxLoginAttempts,_that.lockoutDurationMinutes,_that.consentRequired,_that.defaults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'k_anonymity_threshold')  int kAnonymityThreshold, @JsonKey(name: 'registration_open')  bool registrationOpen, @JsonKey(name: 'maintenance_mode')  bool maintenanceMode, @JsonKey(name: 'maintenance_message')  String maintenanceMessage, @JsonKey(name: 'maintenance_completion')  String maintenanceCompletion, @JsonKey(name: 'max_login_attempts')  int maxLoginAttempts, @JsonKey(name: 'lockout_duration_minutes')  int lockoutDurationMinutes, @JsonKey(name: 'consent_required')  bool consentRequired,  Map<String, dynamic> defaults)  $default,) {final _that = this;
switch (_that) {
case _SystemSettings():
return $default(_that.kAnonymityThreshold,_that.registrationOpen,_that.maintenanceMode,_that.maintenanceMessage,_that.maintenanceCompletion,_that.maxLoginAttempts,_that.lockoutDurationMinutes,_that.consentRequired,_that.defaults);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'k_anonymity_threshold')  int kAnonymityThreshold, @JsonKey(name: 'registration_open')  bool registrationOpen, @JsonKey(name: 'maintenance_mode')  bool maintenanceMode, @JsonKey(name: 'maintenance_message')  String maintenanceMessage, @JsonKey(name: 'maintenance_completion')  String maintenanceCompletion, @JsonKey(name: 'max_login_attempts')  int maxLoginAttempts, @JsonKey(name: 'lockout_duration_minutes')  int lockoutDurationMinutes, @JsonKey(name: 'consent_required')  bool consentRequired,  Map<String, dynamic> defaults)?  $default,) {final _that = this;
switch (_that) {
case _SystemSettings() when $default != null:
return $default(_that.kAnonymityThreshold,_that.registrationOpen,_that.maintenanceMode,_that.maintenanceMessage,_that.maintenanceCompletion,_that.maxLoginAttempts,_that.lockoutDurationMinutes,_that.consentRequired,_that.defaults);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SystemSettings implements SystemSettings {
  const _SystemSettings({@JsonKey(name: 'k_anonymity_threshold') required this.kAnonymityThreshold, @JsonKey(name: 'registration_open') required this.registrationOpen, @JsonKey(name: 'maintenance_mode') required this.maintenanceMode, @JsonKey(name: 'maintenance_message') this.maintenanceMessage = '', @JsonKey(name: 'maintenance_completion') this.maintenanceCompletion = '', @JsonKey(name: 'max_login_attempts') required this.maxLoginAttempts, @JsonKey(name: 'lockout_duration_minutes') required this.lockoutDurationMinutes, @JsonKey(name: 'consent_required') this.consentRequired = true, final  Map<String, dynamic> defaults = const {}}): _defaults = defaults;
  factory _SystemSettings.fromJson(Map<String, dynamic> json) => _$SystemSettingsFromJson(json);

@override@JsonKey(name: 'k_anonymity_threshold') final  int kAnonymityThreshold;
@override@JsonKey(name: 'registration_open') final  bool registrationOpen;
@override@JsonKey(name: 'maintenance_mode') final  bool maintenanceMode;
@override@JsonKey(name: 'maintenance_message') final  String maintenanceMessage;
@override@JsonKey(name: 'maintenance_completion') final  String maintenanceCompletion;
@override@JsonKey(name: 'max_login_attempts') final  int maxLoginAttempts;
@override@JsonKey(name: 'lockout_duration_minutes') final  int lockoutDurationMinutes;
@override@JsonKey(name: 'consent_required') final  bool consentRequired;
 final  Map<String, dynamic> _defaults;
@override@JsonKey() Map<String, dynamic> get defaults {
  if (_defaults is EqualUnmodifiableMapView) return _defaults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_defaults);
}


/// Create a copy of SystemSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemSettingsCopyWith<_SystemSettings> get copyWith => __$SystemSettingsCopyWithImpl<_SystemSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SystemSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemSettings&&(identical(other.kAnonymityThreshold, kAnonymityThreshold) || other.kAnonymityThreshold == kAnonymityThreshold)&&(identical(other.registrationOpen, registrationOpen) || other.registrationOpen == registrationOpen)&&(identical(other.maintenanceMode, maintenanceMode) || other.maintenanceMode == maintenanceMode)&&(identical(other.maintenanceMessage, maintenanceMessage) || other.maintenanceMessage == maintenanceMessage)&&(identical(other.maintenanceCompletion, maintenanceCompletion) || other.maintenanceCompletion == maintenanceCompletion)&&(identical(other.maxLoginAttempts, maxLoginAttempts) || other.maxLoginAttempts == maxLoginAttempts)&&(identical(other.lockoutDurationMinutes, lockoutDurationMinutes) || other.lockoutDurationMinutes == lockoutDurationMinutes)&&(identical(other.consentRequired, consentRequired) || other.consentRequired == consentRequired)&&const DeepCollectionEquality().equals(other._defaults, _defaults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kAnonymityThreshold,registrationOpen,maintenanceMode,maintenanceMessage,maintenanceCompletion,maxLoginAttempts,lockoutDurationMinutes,consentRequired,const DeepCollectionEquality().hash(_defaults));

@override
String toString() {
  return 'SystemSettings(kAnonymityThreshold: $kAnonymityThreshold, registrationOpen: $registrationOpen, maintenanceMode: $maintenanceMode, maintenanceMessage: $maintenanceMessage, maintenanceCompletion: $maintenanceCompletion, maxLoginAttempts: $maxLoginAttempts, lockoutDurationMinutes: $lockoutDurationMinutes, consentRequired: $consentRequired, defaults: $defaults)';
}


}

/// @nodoc
abstract mixin class _$SystemSettingsCopyWith<$Res> implements $SystemSettingsCopyWith<$Res> {
  factory _$SystemSettingsCopyWith(_SystemSettings value, $Res Function(_SystemSettings) _then) = __$SystemSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'k_anonymity_threshold') int kAnonymityThreshold,@JsonKey(name: 'registration_open') bool registrationOpen,@JsonKey(name: 'maintenance_mode') bool maintenanceMode,@JsonKey(name: 'maintenance_message') String maintenanceMessage,@JsonKey(name: 'maintenance_completion') String maintenanceCompletion,@JsonKey(name: 'max_login_attempts') int maxLoginAttempts,@JsonKey(name: 'lockout_duration_minutes') int lockoutDurationMinutes,@JsonKey(name: 'consent_required') bool consentRequired, Map<String, dynamic> defaults
});




}
/// @nodoc
class __$SystemSettingsCopyWithImpl<$Res>
    implements _$SystemSettingsCopyWith<$Res> {
  __$SystemSettingsCopyWithImpl(this._self, this._then);

  final _SystemSettings _self;
  final $Res Function(_SystemSettings) _then;

/// Create a copy of SystemSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kAnonymityThreshold = null,Object? registrationOpen = null,Object? maintenanceMode = null,Object? maintenanceMessage = null,Object? maintenanceCompletion = null,Object? maxLoginAttempts = null,Object? lockoutDurationMinutes = null,Object? consentRequired = null,Object? defaults = null,}) {
  return _then(_SystemSettings(
kAnonymityThreshold: null == kAnonymityThreshold ? _self.kAnonymityThreshold : kAnonymityThreshold // ignore: cast_nullable_to_non_nullable
as int,registrationOpen: null == registrationOpen ? _self.registrationOpen : registrationOpen // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMode: null == maintenanceMode ? _self.maintenanceMode : maintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,maintenanceMessage: null == maintenanceMessage ? _self.maintenanceMessage : maintenanceMessage // ignore: cast_nullable_to_non_nullable
as String,maintenanceCompletion: null == maintenanceCompletion ? _self.maintenanceCompletion : maintenanceCompletion // ignore: cast_nullable_to_non_nullable
as String,maxLoginAttempts: null == maxLoginAttempts ? _self.maxLoginAttempts : maxLoginAttempts // ignore: cast_nullable_to_non_nullable
as int,lockoutDurationMinutes: null == lockoutDurationMinutes ? _self.lockoutDurationMinutes : lockoutDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,consentRequired: null == consentRequired ? _self.consentRequired : consentRequired // ignore: cast_nullable_to_non_nullable
as bool,defaults: null == defaults ? _self._defaults : defaults // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
