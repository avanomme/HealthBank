// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupInfo {

 String get filename;@JsonKey(name: 'backup_type') String get backupType;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'size_bytes') int get sizeBytes;@JsonKey(name: 'size_human') String get sizeHuman;
/// Create a copy of BackupInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupInfoCopyWith<BackupInfo> get copyWith => _$BackupInfoCopyWithImpl<BackupInfo>(this as BackupInfo, _$identity);

  /// Serializes this BackupInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupInfo&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.backupType, backupType) || other.backupType == backupType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.sizeHuman, sizeHuman) || other.sizeHuman == sizeHuman));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filename,backupType,createdAt,sizeBytes,sizeHuman);

@override
String toString() {
  return 'BackupInfo(filename: $filename, backupType: $backupType, createdAt: $createdAt, sizeBytes: $sizeBytes, sizeHuman: $sizeHuman)';
}


}

/// @nodoc
abstract mixin class $BackupInfoCopyWith<$Res>  {
  factory $BackupInfoCopyWith(BackupInfo value, $Res Function(BackupInfo) _then) = _$BackupInfoCopyWithImpl;
@useResult
$Res call({
 String filename,@JsonKey(name: 'backup_type') String backupType,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'size_bytes') int sizeBytes,@JsonKey(name: 'size_human') String sizeHuman
});




}
/// @nodoc
class _$BackupInfoCopyWithImpl<$Res>
    implements $BackupInfoCopyWith<$Res> {
  _$BackupInfoCopyWithImpl(this._self, this._then);

  final BackupInfo _self;
  final $Res Function(BackupInfo) _then;

/// Create a copy of BackupInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filename = null,Object? backupType = null,Object? createdAt = null,Object? sizeBytes = null,Object? sizeHuman = null,}) {
  return _then(_self.copyWith(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,backupType: null == backupType ? _self.backupType : backupType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,sizeHuman: null == sizeHuman ? _self.sizeHuman : sizeHuman // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupInfo].
extension BackupInfoPatterns on BackupInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupInfo value)  $default,){
final _that = this;
switch (_that) {
case _BackupInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BackupInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String filename, @JsonKey(name: 'backup_type')  String backupType, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'size_bytes')  int sizeBytes, @JsonKey(name: 'size_human')  String sizeHuman)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupInfo() when $default != null:
return $default(_that.filename,_that.backupType,_that.createdAt,_that.sizeBytes,_that.sizeHuman);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String filename, @JsonKey(name: 'backup_type')  String backupType, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'size_bytes')  int sizeBytes, @JsonKey(name: 'size_human')  String sizeHuman)  $default,) {final _that = this;
switch (_that) {
case _BackupInfo():
return $default(_that.filename,_that.backupType,_that.createdAt,_that.sizeBytes,_that.sizeHuman);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String filename, @JsonKey(name: 'backup_type')  String backupType, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'size_bytes')  int sizeBytes, @JsonKey(name: 'size_human')  String sizeHuman)?  $default,) {final _that = this;
switch (_that) {
case _BackupInfo() when $default != null:
return $default(_that.filename,_that.backupType,_that.createdAt,_that.sizeBytes,_that.sizeHuman);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupInfo implements BackupInfo {
  const _BackupInfo({required this.filename, @JsonKey(name: 'backup_type') required this.backupType, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'size_bytes') required this.sizeBytes, @JsonKey(name: 'size_human') required this.sizeHuman});
  factory _BackupInfo.fromJson(Map<String, dynamic> json) => _$BackupInfoFromJson(json);

@override final  String filename;
@override@JsonKey(name: 'backup_type') final  String backupType;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'size_bytes') final  int sizeBytes;
@override@JsonKey(name: 'size_human') final  String sizeHuman;

/// Create a copy of BackupInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupInfoCopyWith<_BackupInfo> get copyWith => __$BackupInfoCopyWithImpl<_BackupInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupInfo&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.backupType, backupType) || other.backupType == backupType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.sizeHuman, sizeHuman) || other.sizeHuman == sizeHuman));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filename,backupType,createdAt,sizeBytes,sizeHuman);

@override
String toString() {
  return 'BackupInfo(filename: $filename, backupType: $backupType, createdAt: $createdAt, sizeBytes: $sizeBytes, sizeHuman: $sizeHuman)';
}


}

/// @nodoc
abstract mixin class _$BackupInfoCopyWith<$Res> implements $BackupInfoCopyWith<$Res> {
  factory _$BackupInfoCopyWith(_BackupInfo value, $Res Function(_BackupInfo) _then) = __$BackupInfoCopyWithImpl;
@override @useResult
$Res call({
 String filename,@JsonKey(name: 'backup_type') String backupType,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'size_bytes') int sizeBytes,@JsonKey(name: 'size_human') String sizeHuman
});




}
/// @nodoc
class __$BackupInfoCopyWithImpl<$Res>
    implements _$BackupInfoCopyWith<$Res> {
  __$BackupInfoCopyWithImpl(this._self, this._then);

  final _BackupInfo _self;
  final $Res Function(_BackupInfo) _then;

/// Create a copy of BackupInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filename = null,Object? backupType = null,Object? createdAt = null,Object? sizeBytes = null,Object? sizeHuman = null,}) {
  return _then(_BackupInfo(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,backupType: null == backupType ? _self.backupType : backupType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,sizeHuman: null == sizeHuman ? _self.sizeHuman : sizeHuman // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RestoreResult {

@JsonKey(name: 'pre_backup_filename') String get preBackupFilename;@JsonKey(name: 'pre_backup_size_human') String get preBackupSizeHuman;@JsonKey(name: 'restored_file') String get restoredFile;@JsonKey(name: 'migrations_run') int get migrationsRun; String get message;
/// Create a copy of RestoreResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestoreResultCopyWith<RestoreResult> get copyWith => _$RestoreResultCopyWithImpl<RestoreResult>(this as RestoreResult, _$identity);

  /// Serializes this RestoreResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestoreResult&&(identical(other.preBackupFilename, preBackupFilename) || other.preBackupFilename == preBackupFilename)&&(identical(other.preBackupSizeHuman, preBackupSizeHuman) || other.preBackupSizeHuman == preBackupSizeHuman)&&(identical(other.restoredFile, restoredFile) || other.restoredFile == restoredFile)&&(identical(other.migrationsRun, migrationsRun) || other.migrationsRun == migrationsRun)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preBackupFilename,preBackupSizeHuman,restoredFile,migrationsRun,message);

@override
String toString() {
  return 'RestoreResult(preBackupFilename: $preBackupFilename, preBackupSizeHuman: $preBackupSizeHuman, restoredFile: $restoredFile, migrationsRun: $migrationsRun, message: $message)';
}


}

/// @nodoc
abstract mixin class $RestoreResultCopyWith<$Res>  {
  factory $RestoreResultCopyWith(RestoreResult value, $Res Function(RestoreResult) _then) = _$RestoreResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'pre_backup_filename') String preBackupFilename,@JsonKey(name: 'pre_backup_size_human') String preBackupSizeHuman,@JsonKey(name: 'restored_file') String restoredFile,@JsonKey(name: 'migrations_run') int migrationsRun, String message
});




}
/// @nodoc
class _$RestoreResultCopyWithImpl<$Res>
    implements $RestoreResultCopyWith<$Res> {
  _$RestoreResultCopyWithImpl(this._self, this._then);

  final RestoreResult _self;
  final $Res Function(RestoreResult) _then;

/// Create a copy of RestoreResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preBackupFilename = null,Object? preBackupSizeHuman = null,Object? restoredFile = null,Object? migrationsRun = null,Object? message = null,}) {
  return _then(_self.copyWith(
preBackupFilename: null == preBackupFilename ? _self.preBackupFilename : preBackupFilename // ignore: cast_nullable_to_non_nullable
as String,preBackupSizeHuman: null == preBackupSizeHuman ? _self.preBackupSizeHuman : preBackupSizeHuman // ignore: cast_nullable_to_non_nullable
as String,restoredFile: null == restoredFile ? _self.restoredFile : restoredFile // ignore: cast_nullable_to_non_nullable
as String,migrationsRun: null == migrationsRun ? _self.migrationsRun : migrationsRun // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RestoreResult].
extension RestoreResultPatterns on RestoreResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestoreResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestoreResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestoreResult value)  $default,){
final _that = this;
switch (_that) {
case _RestoreResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestoreResult value)?  $default,){
final _that = this;
switch (_that) {
case _RestoreResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'pre_backup_filename')  String preBackupFilename, @JsonKey(name: 'pre_backup_size_human')  String preBackupSizeHuman, @JsonKey(name: 'restored_file')  String restoredFile, @JsonKey(name: 'migrations_run')  int migrationsRun,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestoreResult() when $default != null:
return $default(_that.preBackupFilename,_that.preBackupSizeHuman,_that.restoredFile,_that.migrationsRun,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'pre_backup_filename')  String preBackupFilename, @JsonKey(name: 'pre_backup_size_human')  String preBackupSizeHuman, @JsonKey(name: 'restored_file')  String restoredFile, @JsonKey(name: 'migrations_run')  int migrationsRun,  String message)  $default,) {final _that = this;
switch (_that) {
case _RestoreResult():
return $default(_that.preBackupFilename,_that.preBackupSizeHuman,_that.restoredFile,_that.migrationsRun,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'pre_backup_filename')  String preBackupFilename, @JsonKey(name: 'pre_backup_size_human')  String preBackupSizeHuman, @JsonKey(name: 'restored_file')  String restoredFile, @JsonKey(name: 'migrations_run')  int migrationsRun,  String message)?  $default,) {final _that = this;
switch (_that) {
case _RestoreResult() when $default != null:
return $default(_that.preBackupFilename,_that.preBackupSizeHuman,_that.restoredFile,_that.migrationsRun,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestoreResult implements RestoreResult {
  const _RestoreResult({@JsonKey(name: 'pre_backup_filename') required this.preBackupFilename, @JsonKey(name: 'pre_backup_size_human') required this.preBackupSizeHuman, @JsonKey(name: 'restored_file') required this.restoredFile, @JsonKey(name: 'migrations_run') required this.migrationsRun, required this.message});
  factory _RestoreResult.fromJson(Map<String, dynamic> json) => _$RestoreResultFromJson(json);

@override@JsonKey(name: 'pre_backup_filename') final  String preBackupFilename;
@override@JsonKey(name: 'pre_backup_size_human') final  String preBackupSizeHuman;
@override@JsonKey(name: 'restored_file') final  String restoredFile;
@override@JsonKey(name: 'migrations_run') final  int migrationsRun;
@override final  String message;

/// Create a copy of RestoreResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestoreResultCopyWith<_RestoreResult> get copyWith => __$RestoreResultCopyWithImpl<_RestoreResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestoreResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestoreResult&&(identical(other.preBackupFilename, preBackupFilename) || other.preBackupFilename == preBackupFilename)&&(identical(other.preBackupSizeHuman, preBackupSizeHuman) || other.preBackupSizeHuman == preBackupSizeHuman)&&(identical(other.restoredFile, restoredFile) || other.restoredFile == restoredFile)&&(identical(other.migrationsRun, migrationsRun) || other.migrationsRun == migrationsRun)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preBackupFilename,preBackupSizeHuman,restoredFile,migrationsRun,message);

@override
String toString() {
  return 'RestoreResult(preBackupFilename: $preBackupFilename, preBackupSizeHuman: $preBackupSizeHuman, restoredFile: $restoredFile, migrationsRun: $migrationsRun, message: $message)';
}


}

/// @nodoc
abstract mixin class _$RestoreResultCopyWith<$Res> implements $RestoreResultCopyWith<$Res> {
  factory _$RestoreResultCopyWith(_RestoreResult value, $Res Function(_RestoreResult) _then) = __$RestoreResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'pre_backup_filename') String preBackupFilename,@JsonKey(name: 'pre_backup_size_human') String preBackupSizeHuman,@JsonKey(name: 'restored_file') String restoredFile,@JsonKey(name: 'migrations_run') int migrationsRun, String message
});




}
/// @nodoc
class __$RestoreResultCopyWithImpl<$Res>
    implements _$RestoreResultCopyWith<$Res> {
  __$RestoreResultCopyWithImpl(this._self, this._then);

  final _RestoreResult _self;
  final $Res Function(_RestoreResult) _then;

/// Create a copy of RestoreResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preBackupFilename = null,Object? preBackupSizeHuman = null,Object? restoredFile = null,Object? migrationsRun = null,Object? message = null,}) {
  return _then(_RestoreResult(
preBackupFilename: null == preBackupFilename ? _self.preBackupFilename : preBackupFilename // ignore: cast_nullable_to_non_nullable
as String,preBackupSizeHuman: null == preBackupSizeHuman ? _self.preBackupSizeHuman : preBackupSizeHuman // ignore: cast_nullable_to_non_nullable
as String,restoredFile: null == restoredFile ? _self.restoredFile : restoredFile // ignore: cast_nullable_to_non_nullable
as String,migrationsRun: null == migrationsRun ? _self.migrationsRun : migrationsRun // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
