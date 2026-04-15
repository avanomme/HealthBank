// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'database.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ColumnInfo {

 String get name; String get type;@JsonKey(name: 'is_primary_key') bool get isPrimaryKey;@JsonKey(name: 'is_foreign_key') bool get isForeignKey;@JsonKey(name: 'is_nullable') bool get isNullable;@JsonKey(name: 'foreign_key_ref') String? get foreignKeyRef;
/// Create a copy of ColumnInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColumnInfoCopyWith<ColumnInfo> get copyWith => _$ColumnInfoCopyWithImpl<ColumnInfo>(this as ColumnInfo, _$identity);

  /// Serializes this ColumnInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColumnInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isPrimaryKey, isPrimaryKey) || other.isPrimaryKey == isPrimaryKey)&&(identical(other.isForeignKey, isForeignKey) || other.isForeignKey == isForeignKey)&&(identical(other.isNullable, isNullable) || other.isNullable == isNullable)&&(identical(other.foreignKeyRef, foreignKeyRef) || other.foreignKeyRef == foreignKeyRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,isPrimaryKey,isForeignKey,isNullable,foreignKeyRef);

@override
String toString() {
  return 'ColumnInfo(name: $name, type: $type, isPrimaryKey: $isPrimaryKey, isForeignKey: $isForeignKey, isNullable: $isNullable, foreignKeyRef: $foreignKeyRef)';
}


}

/// @nodoc
abstract mixin class $ColumnInfoCopyWith<$Res>  {
  factory $ColumnInfoCopyWith(ColumnInfo value, $Res Function(ColumnInfo) _then) = _$ColumnInfoCopyWithImpl;
@useResult
$Res call({
 String name, String type,@JsonKey(name: 'is_primary_key') bool isPrimaryKey,@JsonKey(name: 'is_foreign_key') bool isForeignKey,@JsonKey(name: 'is_nullable') bool isNullable,@JsonKey(name: 'foreign_key_ref') String? foreignKeyRef
});




}
/// @nodoc
class _$ColumnInfoCopyWithImpl<$Res>
    implements $ColumnInfoCopyWith<$Res> {
  _$ColumnInfoCopyWithImpl(this._self, this._then);

  final ColumnInfo _self;
  final $Res Function(ColumnInfo) _then;

/// Create a copy of ColumnInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? isPrimaryKey = null,Object? isForeignKey = null,Object? isNullable = null,Object? foreignKeyRef = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isPrimaryKey: null == isPrimaryKey ? _self.isPrimaryKey : isPrimaryKey // ignore: cast_nullable_to_non_nullable
as bool,isForeignKey: null == isForeignKey ? _self.isForeignKey : isForeignKey // ignore: cast_nullable_to_non_nullable
as bool,isNullable: null == isNullable ? _self.isNullable : isNullable // ignore: cast_nullable_to_non_nullable
as bool,foreignKeyRef: freezed == foreignKeyRef ? _self.foreignKeyRef : foreignKeyRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ColumnInfo].
extension ColumnInfoPatterns on ColumnInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ColumnInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ColumnInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ColumnInfo value)  $default,){
final _that = this;
switch (_that) {
case _ColumnInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ColumnInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ColumnInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String type, @JsonKey(name: 'is_primary_key')  bool isPrimaryKey, @JsonKey(name: 'is_foreign_key')  bool isForeignKey, @JsonKey(name: 'is_nullable')  bool isNullable, @JsonKey(name: 'foreign_key_ref')  String? foreignKeyRef)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ColumnInfo() when $default != null:
return $default(_that.name,_that.type,_that.isPrimaryKey,_that.isForeignKey,_that.isNullable,_that.foreignKeyRef);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String type, @JsonKey(name: 'is_primary_key')  bool isPrimaryKey, @JsonKey(name: 'is_foreign_key')  bool isForeignKey, @JsonKey(name: 'is_nullable')  bool isNullable, @JsonKey(name: 'foreign_key_ref')  String? foreignKeyRef)  $default,) {final _that = this;
switch (_that) {
case _ColumnInfo():
return $default(_that.name,_that.type,_that.isPrimaryKey,_that.isForeignKey,_that.isNullable,_that.foreignKeyRef);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String type, @JsonKey(name: 'is_primary_key')  bool isPrimaryKey, @JsonKey(name: 'is_foreign_key')  bool isForeignKey, @JsonKey(name: 'is_nullable')  bool isNullable, @JsonKey(name: 'foreign_key_ref')  String? foreignKeyRef)?  $default,) {final _that = this;
switch (_that) {
case _ColumnInfo() when $default != null:
return $default(_that.name,_that.type,_that.isPrimaryKey,_that.isForeignKey,_that.isNullable,_that.foreignKeyRef);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ColumnInfo implements ColumnInfo {
  const _ColumnInfo({required this.name, required this.type, @JsonKey(name: 'is_primary_key') this.isPrimaryKey = false, @JsonKey(name: 'is_foreign_key') this.isForeignKey = false, @JsonKey(name: 'is_nullable') this.isNullable = true, @JsonKey(name: 'foreign_key_ref') this.foreignKeyRef});
  factory _ColumnInfo.fromJson(Map<String, dynamic> json) => _$ColumnInfoFromJson(json);

@override final  String name;
@override final  String type;
@override@JsonKey(name: 'is_primary_key') final  bool isPrimaryKey;
@override@JsonKey(name: 'is_foreign_key') final  bool isForeignKey;
@override@JsonKey(name: 'is_nullable') final  bool isNullable;
@override@JsonKey(name: 'foreign_key_ref') final  String? foreignKeyRef;

/// Create a copy of ColumnInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColumnInfoCopyWith<_ColumnInfo> get copyWith => __$ColumnInfoCopyWithImpl<_ColumnInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ColumnInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColumnInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isPrimaryKey, isPrimaryKey) || other.isPrimaryKey == isPrimaryKey)&&(identical(other.isForeignKey, isForeignKey) || other.isForeignKey == isForeignKey)&&(identical(other.isNullable, isNullable) || other.isNullable == isNullable)&&(identical(other.foreignKeyRef, foreignKeyRef) || other.foreignKeyRef == foreignKeyRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,isPrimaryKey,isForeignKey,isNullable,foreignKeyRef);

@override
String toString() {
  return 'ColumnInfo(name: $name, type: $type, isPrimaryKey: $isPrimaryKey, isForeignKey: $isForeignKey, isNullable: $isNullable, foreignKeyRef: $foreignKeyRef)';
}


}

/// @nodoc
abstract mixin class _$ColumnInfoCopyWith<$Res> implements $ColumnInfoCopyWith<$Res> {
  factory _$ColumnInfoCopyWith(_ColumnInfo value, $Res Function(_ColumnInfo) _then) = __$ColumnInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String type,@JsonKey(name: 'is_primary_key') bool isPrimaryKey,@JsonKey(name: 'is_foreign_key') bool isForeignKey,@JsonKey(name: 'is_nullable') bool isNullable,@JsonKey(name: 'foreign_key_ref') String? foreignKeyRef
});




}
/// @nodoc
class __$ColumnInfoCopyWithImpl<$Res>
    implements _$ColumnInfoCopyWith<$Res> {
  __$ColumnInfoCopyWithImpl(this._self, this._then);

  final _ColumnInfo _self;
  final $Res Function(_ColumnInfo) _then;

/// Create a copy of ColumnInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? isPrimaryKey = null,Object? isForeignKey = null,Object? isNullable = null,Object? foreignKeyRef = freezed,}) {
  return _then(_ColumnInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isPrimaryKey: null == isPrimaryKey ? _self.isPrimaryKey : isPrimaryKey // ignore: cast_nullable_to_non_nullable
as bool,isForeignKey: null == isForeignKey ? _self.isForeignKey : isForeignKey // ignore: cast_nullable_to_non_nullable
as bool,isNullable: null == isNullable ? _self.isNullable : isNullable // ignore: cast_nullable_to_non_nullable
as bool,foreignKeyRef: freezed == foreignKeyRef ? _self.foreignKeyRef : foreignKeyRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TableSchema {

 String get name; String get description; List<ColumnInfo> get columns;@JsonKey(name: 'row_count') int get rowCount;
/// Create a copy of TableSchema
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableSchemaCopyWith<TableSchema> get copyWith => _$TableSchemaCopyWithImpl<TableSchema>(this as TableSchema, _$identity);

  /// Serializes this TableSchema to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableSchema&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.columns, columns)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(columns),rowCount);

@override
String toString() {
  return 'TableSchema(name: $name, description: $description, columns: $columns, rowCount: $rowCount)';
}


}

/// @nodoc
abstract mixin class $TableSchemaCopyWith<$Res>  {
  factory $TableSchemaCopyWith(TableSchema value, $Res Function(TableSchema) _then) = _$TableSchemaCopyWithImpl;
@useResult
$Res call({
 String name, String description, List<ColumnInfo> columns,@JsonKey(name: 'row_count') int rowCount
});




}
/// @nodoc
class _$TableSchemaCopyWithImpl<$Res>
    implements $TableSchemaCopyWith<$Res> {
  _$TableSchemaCopyWithImpl(this._self, this._then);

  final TableSchema _self;
  final $Res Function(TableSchema) _then;

/// Create a copy of TableSchema
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? columns = null,Object? rowCount = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<ColumnInfo>,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableSchema].
extension TableSchemaPatterns on TableSchema {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableSchema value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableSchema() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableSchema value)  $default,){
final _that = this;
switch (_that) {
case _TableSchema():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableSchema value)?  $default,){
final _that = this;
switch (_that) {
case _TableSchema() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  List<ColumnInfo> columns, @JsonKey(name: 'row_count')  int rowCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableSchema() when $default != null:
return $default(_that.name,_that.description,_that.columns,_that.rowCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  List<ColumnInfo> columns, @JsonKey(name: 'row_count')  int rowCount)  $default,) {final _that = this;
switch (_that) {
case _TableSchema():
return $default(_that.name,_that.description,_that.columns,_that.rowCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  List<ColumnInfo> columns, @JsonKey(name: 'row_count')  int rowCount)?  $default,) {final _that = this;
switch (_that) {
case _TableSchema() when $default != null:
return $default(_that.name,_that.description,_that.columns,_that.rowCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TableSchema implements TableSchema {
  const _TableSchema({required this.name, required this.description, required final  List<ColumnInfo> columns, @JsonKey(name: 'row_count') required this.rowCount}): _columns = columns;
  factory _TableSchema.fromJson(Map<String, dynamic> json) => _$TableSchemaFromJson(json);

@override final  String name;
@override final  String description;
 final  List<ColumnInfo> _columns;
@override List<ColumnInfo> get columns {
  if (_columns is EqualUnmodifiableListView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_columns);
}

@override@JsonKey(name: 'row_count') final  int rowCount;

/// Create a copy of TableSchema
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableSchemaCopyWith<_TableSchema> get copyWith => __$TableSchemaCopyWithImpl<_TableSchema>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableSchemaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableSchema&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._columns, _columns)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(_columns),rowCount);

@override
String toString() {
  return 'TableSchema(name: $name, description: $description, columns: $columns, rowCount: $rowCount)';
}


}

/// @nodoc
abstract mixin class _$TableSchemaCopyWith<$Res> implements $TableSchemaCopyWith<$Res> {
  factory _$TableSchemaCopyWith(_TableSchema value, $Res Function(_TableSchema) _then) = __$TableSchemaCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, List<ColumnInfo> columns,@JsonKey(name: 'row_count') int rowCount
});




}
/// @nodoc
class __$TableSchemaCopyWithImpl<$Res>
    implements _$TableSchemaCopyWith<$Res> {
  __$TableSchemaCopyWithImpl(this._self, this._then);

  final _TableSchema _self;
  final $Res Function(_TableSchema) _then;

/// Create a copy of TableSchema
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? columns = null,Object? rowCount = null,}) {
  return _then(_TableSchema(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as List<ColumnInfo>,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TableData {

 String get name; List<String> get columns; List<Map<String, dynamic>> get rows; int get total;
/// Create a copy of TableData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableDataCopyWith<TableData> get copyWith => _$TableDataCopyWithImpl<TableData>(this as TableData, _$identity);

  /// Serializes this TableData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableData&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.columns, columns)&&const DeepCollectionEquality().equals(other.rows, rows)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(columns),const DeepCollectionEquality().hash(rows),total);

@override
String toString() {
  return 'TableData(name: $name, columns: $columns, rows: $rows, total: $total)';
}


}

/// @nodoc
abstract mixin class $TableDataCopyWith<$Res>  {
  factory $TableDataCopyWith(TableData value, $Res Function(TableData) _then) = _$TableDataCopyWithImpl;
@useResult
$Res call({
 String name, List<String> columns, List<Map<String, dynamic>> rows, int total
});




}
/// @nodoc
class _$TableDataCopyWithImpl<$Res>
    implements $TableDataCopyWith<$Res> {
  _$TableDataCopyWithImpl(this._self, this._then);

  final TableData _self;
  final $Res Function(TableData) _then;

/// Create a copy of TableData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? columns = null,Object? rows = null,Object? total = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<String>,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableData].
extension TableDataPatterns on TableData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableData value)  $default,){
final _that = this;
switch (_that) {
case _TableData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableData value)?  $default,){
final _that = this;
switch (_that) {
case _TableData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<String> columns,  List<Map<String, dynamic>> rows,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableData() when $default != null:
return $default(_that.name,_that.columns,_that.rows,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<String> columns,  List<Map<String, dynamic>> rows,  int total)  $default,) {final _that = this;
switch (_that) {
case _TableData():
return $default(_that.name,_that.columns,_that.rows,_that.total);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<String> columns,  List<Map<String, dynamic>> rows,  int total)?  $default,) {final _that = this;
switch (_that) {
case _TableData() when $default != null:
return $default(_that.name,_that.columns,_that.rows,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableData implements TableData {
  const _TableData({required this.name, required final  List<String> columns, required final  List<Map<String, dynamic>> rows, required this.total}): _columns = columns,_rows = rows;
  factory _TableData.fromJson(Map<String, dynamic> json) => _$TableDataFromJson(json);

@override final  String name;
 final  List<String> _columns;
@override List<String> get columns {
  if (_columns is EqualUnmodifiableListView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_columns);
}

 final  List<Map<String, dynamic>> _rows;
@override List<Map<String, dynamic>> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override final  int total;

/// Create a copy of TableData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableDataCopyWith<_TableData> get copyWith => __$TableDataCopyWithImpl<_TableData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableData&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._columns, _columns)&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_columns),const DeepCollectionEquality().hash(_rows),total);

@override
String toString() {
  return 'TableData(name: $name, columns: $columns, rows: $rows, total: $total)';
}


}

/// @nodoc
abstract mixin class _$TableDataCopyWith<$Res> implements $TableDataCopyWith<$Res> {
  factory _$TableDataCopyWith(_TableData value, $Res Function(_TableData) _then) = __$TableDataCopyWithImpl;
@override @useResult
$Res call({
 String name, List<String> columns, List<Map<String, dynamic>> rows, int total
});




}
/// @nodoc
class __$TableDataCopyWithImpl<$Res>
    implements _$TableDataCopyWith<$Res> {
  __$TableDataCopyWithImpl(this._self, this._then);

  final _TableData _self;
  final $Res Function(_TableData) _then;

/// Create a copy of TableData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? columns = null,Object? rows = null,Object? total = null,}) {
  return _then(_TableData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as List<String>,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TableListResponse {

 List<TableSchema> get tables;
/// Create a copy of TableListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableListResponseCopyWith<TableListResponse> get copyWith => _$TableListResponseCopyWithImpl<TableListResponse>(this as TableListResponse, _$identity);

  /// Serializes this TableListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableListResponse&&const DeepCollectionEquality().equals(other.tables, tables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tables));

@override
String toString() {
  return 'TableListResponse(tables: $tables)';
}


}

/// @nodoc
abstract mixin class $TableListResponseCopyWith<$Res>  {
  factory $TableListResponseCopyWith(TableListResponse value, $Res Function(TableListResponse) _then) = _$TableListResponseCopyWithImpl;
@useResult
$Res call({
 List<TableSchema> tables
});




}
/// @nodoc
class _$TableListResponseCopyWithImpl<$Res>
    implements $TableListResponseCopyWith<$Res> {
  _$TableListResponseCopyWithImpl(this._self, this._then);

  final TableListResponse _self;
  final $Res Function(TableListResponse) _then;

/// Create a copy of TableListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tables = null,}) {
  return _then(_self.copyWith(
tables: null == tables ? _self.tables : tables // ignore: cast_nullable_to_non_nullable
as List<TableSchema>,
  ));
}

}


/// Adds pattern-matching-related methods to [TableListResponse].
extension TableListResponsePatterns on TableListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableListResponse value)  $default,){
final _that = this;
switch (_that) {
case _TableListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TableListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TableSchema> tables)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableListResponse() when $default != null:
return $default(_that.tables);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TableSchema> tables)  $default,) {final _that = this;
switch (_that) {
case _TableListResponse():
return $default(_that.tables);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TableSchema> tables)?  $default,) {final _that = this;
switch (_that) {
case _TableListResponse() when $default != null:
return $default(_that.tables);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TableListResponse implements TableListResponse {
  const _TableListResponse({required final  List<TableSchema> tables}): _tables = tables;
  factory _TableListResponse.fromJson(Map<String, dynamic> json) => _$TableListResponseFromJson(json);

 final  List<TableSchema> _tables;
@override List<TableSchema> get tables {
  if (_tables is EqualUnmodifiableListView) return _tables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tables);
}


/// Create a copy of TableListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableListResponseCopyWith<_TableListResponse> get copyWith => __$TableListResponseCopyWithImpl<_TableListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableListResponse&&const DeepCollectionEquality().equals(other._tables, _tables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tables));

@override
String toString() {
  return 'TableListResponse(tables: $tables)';
}


}

/// @nodoc
abstract mixin class _$TableListResponseCopyWith<$Res> implements $TableListResponseCopyWith<$Res> {
  factory _$TableListResponseCopyWith(_TableListResponse value, $Res Function(_TableListResponse) _then) = __$TableListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<TableSchema> tables
});




}
/// @nodoc
class __$TableListResponseCopyWithImpl<$Res>
    implements _$TableListResponseCopyWith<$Res> {
  __$TableListResponseCopyWithImpl(this._self, this._then);

  final _TableListResponse _self;
  final $Res Function(_TableListResponse) _then;

/// Create a copy of TableListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tables = null,}) {
  return _then(_TableListResponse(
tables: null == tables ? _self._tables : tables // ignore: cast_nullable_to_non_nullable
as List<TableSchema>,
  ));
}


}


/// @nodoc
mixin _$TableDetailResponse {

@JsonKey(name: 'schema_info') TableSchema get schemaInfo; TableData get data;
/// Create a copy of TableDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableDetailResponseCopyWith<TableDetailResponse> get copyWith => _$TableDetailResponseCopyWithImpl<TableDetailResponse>(this as TableDetailResponse, _$identity);

  /// Serializes this TableDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableDetailResponse&&(identical(other.schemaInfo, schemaInfo) || other.schemaInfo == schemaInfo)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaInfo,data);

@override
String toString() {
  return 'TableDetailResponse(schemaInfo: $schemaInfo, data: $data)';
}


}

/// @nodoc
abstract mixin class $TableDetailResponseCopyWith<$Res>  {
  factory $TableDetailResponseCopyWith(TableDetailResponse value, $Res Function(TableDetailResponse) _then) = _$TableDetailResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'schema_info') TableSchema schemaInfo, TableData data
});


$TableSchemaCopyWith<$Res> get schemaInfo;$TableDataCopyWith<$Res> get data;

}
/// @nodoc
class _$TableDetailResponseCopyWithImpl<$Res>
    implements $TableDetailResponseCopyWith<$Res> {
  _$TableDetailResponseCopyWithImpl(this._self, this._then);

  final TableDetailResponse _self;
  final $Res Function(TableDetailResponse) _then;

/// Create a copy of TableDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaInfo = null,Object? data = null,}) {
  return _then(_self.copyWith(
schemaInfo: null == schemaInfo ? _self.schemaInfo : schemaInfo // ignore: cast_nullable_to_non_nullable
as TableSchema,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TableData,
  ));
}
/// Create a copy of TableDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TableSchemaCopyWith<$Res> get schemaInfo {
  
  return $TableSchemaCopyWith<$Res>(_self.schemaInfo, (value) {
    return _then(_self.copyWith(schemaInfo: value));
  });
}/// Create a copy of TableDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TableDataCopyWith<$Res> get data {
  
  return $TableDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [TableDetailResponse].
extension TableDetailResponsePatterns on TableDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _TableDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TableDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'schema_info')  TableSchema schemaInfo,  TableData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableDetailResponse() when $default != null:
return $default(_that.schemaInfo,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'schema_info')  TableSchema schemaInfo,  TableData data)  $default,) {final _that = this;
switch (_that) {
case _TableDetailResponse():
return $default(_that.schemaInfo,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'schema_info')  TableSchema schemaInfo,  TableData data)?  $default,) {final _that = this;
switch (_that) {
case _TableDetailResponse() when $default != null:
return $default(_that.schemaInfo,_that.data);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TableDetailResponse implements TableDetailResponse {
  const _TableDetailResponse({@JsonKey(name: 'schema_info') required this.schemaInfo, required this.data});
  factory _TableDetailResponse.fromJson(Map<String, dynamic> json) => _$TableDetailResponseFromJson(json);

@override@JsonKey(name: 'schema_info') final  TableSchema schemaInfo;
@override final  TableData data;

/// Create a copy of TableDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableDetailResponseCopyWith<_TableDetailResponse> get copyWith => __$TableDetailResponseCopyWithImpl<_TableDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableDetailResponse&&(identical(other.schemaInfo, schemaInfo) || other.schemaInfo == schemaInfo)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaInfo,data);

@override
String toString() {
  return 'TableDetailResponse(schemaInfo: $schemaInfo, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TableDetailResponseCopyWith<$Res> implements $TableDetailResponseCopyWith<$Res> {
  factory _$TableDetailResponseCopyWith(_TableDetailResponse value, $Res Function(_TableDetailResponse) _then) = __$TableDetailResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'schema_info') TableSchema schemaInfo, TableData data
});


@override $TableSchemaCopyWith<$Res> get schemaInfo;@override $TableDataCopyWith<$Res> get data;

}
/// @nodoc
class __$TableDetailResponseCopyWithImpl<$Res>
    implements _$TableDetailResponseCopyWith<$Res> {
  __$TableDetailResponseCopyWithImpl(this._self, this._then);

  final _TableDetailResponse _self;
  final $Res Function(_TableDetailResponse) _then;

/// Create a copy of TableDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaInfo = null,Object? data = null,}) {
  return _then(_TableDetailResponse(
schemaInfo: null == schemaInfo ? _self.schemaInfo : schemaInfo // ignore: cast_nullable_to_non_nullable
as TableSchema,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TableData,
  ));
}

/// Create a copy of TableDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TableSchemaCopyWith<$Res> get schemaInfo {
  
  return $TableSchemaCopyWith<$Res>(_self.schemaInfo, (value) {
    return _then(_self.copyWith(schemaInfo: value));
  });
}/// Create a copy of TableDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TableDataCopyWith<$Res> get data {
  
  return $TableDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$PasswordResetRequest {

@JsonKey(name: 'new_password') String get newPassword;
/// Create a copy of PasswordResetRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordResetRequestCopyWith<PasswordResetRequest> get copyWith => _$PasswordResetRequestCopyWithImpl<PasswordResetRequest>(this as PasswordResetRequest, _$identity);

  /// Serializes this PasswordResetRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetRequest&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,newPassword);

@override
String toString() {
  return 'PasswordResetRequest(newPassword: $newPassword)';
}


}

/// @nodoc
abstract mixin class $PasswordResetRequestCopyWith<$Res>  {
  factory $PasswordResetRequestCopyWith(PasswordResetRequest value, $Res Function(PasswordResetRequest) _then) = _$PasswordResetRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'new_password') String newPassword
});




}
/// @nodoc
class _$PasswordResetRequestCopyWithImpl<$Res>
    implements $PasswordResetRequestCopyWith<$Res> {
  _$PasswordResetRequestCopyWithImpl(this._self, this._then);

  final PasswordResetRequest _self;
  final $Res Function(PasswordResetRequest) _then;

/// Create a copy of PasswordResetRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? newPassword = null,}) {
  return _then(_self.copyWith(
newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PasswordResetRequest].
extension PasswordResetRequestPatterns on PasswordResetRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PasswordResetRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PasswordResetRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PasswordResetRequest value)  $default,){
final _that = this;
switch (_that) {
case _PasswordResetRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PasswordResetRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PasswordResetRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'new_password')  String newPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PasswordResetRequest() when $default != null:
return $default(_that.newPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'new_password')  String newPassword)  $default,) {final _that = this;
switch (_that) {
case _PasswordResetRequest():
return $default(_that.newPassword);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'new_password')  String newPassword)?  $default,) {final _that = this;
switch (_that) {
case _PasswordResetRequest() when $default != null:
return $default(_that.newPassword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PasswordResetRequest implements PasswordResetRequest {
  const _PasswordResetRequest({@JsonKey(name: 'new_password') required this.newPassword});
  factory _PasswordResetRequest.fromJson(Map<String, dynamic> json) => _$PasswordResetRequestFromJson(json);

@override@JsonKey(name: 'new_password') final  String newPassword;

/// Create a copy of PasswordResetRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasswordResetRequestCopyWith<_PasswordResetRequest> get copyWith => __$PasswordResetRequestCopyWithImpl<_PasswordResetRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PasswordResetRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordResetRequest&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,newPassword);

@override
String toString() {
  return 'PasswordResetRequest(newPassword: $newPassword)';
}


}

/// @nodoc
abstract mixin class _$PasswordResetRequestCopyWith<$Res> implements $PasswordResetRequestCopyWith<$Res> {
  factory _$PasswordResetRequestCopyWith(_PasswordResetRequest value, $Res Function(_PasswordResetRequest) _then) = __$PasswordResetRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'new_password') String newPassword
});




}
/// @nodoc
class __$PasswordResetRequestCopyWithImpl<$Res>
    implements _$PasswordResetRequestCopyWith<$Res> {
  __$PasswordResetRequestCopyWithImpl(this._self, this._then);

  final _PasswordResetRequest _self;
  final $Res Function(_PasswordResetRequest) _then;

/// Create a copy of PasswordResetRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? newPassword = null,}) {
  return _then(_PasswordResetRequest(
newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PasswordResetResponse {

 String get message;@JsonKey(name: 'user_id') int get userId;
/// Create a copy of PasswordResetResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordResetResponseCopyWith<PasswordResetResponse> get copyWith => _$PasswordResetResponseCopyWithImpl<PasswordResetResponse>(this as PasswordResetResponse, _$identity);

  /// Serializes this PasswordResetResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,userId);

@override
String toString() {
  return 'PasswordResetResponse(message: $message, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $PasswordResetResponseCopyWith<$Res>  {
  factory $PasswordResetResponseCopyWith(PasswordResetResponse value, $Res Function(PasswordResetResponse) _then) = _$PasswordResetResponseCopyWithImpl;
@useResult
$Res call({
 String message,@JsonKey(name: 'user_id') int userId
});




}
/// @nodoc
class _$PasswordResetResponseCopyWithImpl<$Res>
    implements $PasswordResetResponseCopyWith<$Res> {
  _$PasswordResetResponseCopyWithImpl(this._self, this._then);

  final PasswordResetResponse _self;
  final $Res Function(PasswordResetResponse) _then;

/// Create a copy of PasswordResetResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? userId = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PasswordResetResponse].
extension PasswordResetResponsePatterns on PasswordResetResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PasswordResetResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PasswordResetResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PasswordResetResponse value)  $default,){
final _that = this;
switch (_that) {
case _PasswordResetResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PasswordResetResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PasswordResetResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'user_id')  int userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PasswordResetResponse() when $default != null:
return $default(_that.message,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'user_id')  int userId)  $default,) {final _that = this;
switch (_that) {
case _PasswordResetResponse():
return $default(_that.message,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message, @JsonKey(name: 'user_id')  int userId)?  $default,) {final _that = this;
switch (_that) {
case _PasswordResetResponse() when $default != null:
return $default(_that.message,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PasswordResetResponse implements PasswordResetResponse {
  const _PasswordResetResponse({required this.message, @JsonKey(name: 'user_id') required this.userId});
  factory _PasswordResetResponse.fromJson(Map<String, dynamic> json) => _$PasswordResetResponseFromJson(json);

@override final  String message;
@override@JsonKey(name: 'user_id') final  int userId;

/// Create a copy of PasswordResetResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasswordResetResponseCopyWith<_PasswordResetResponse> get copyWith => __$PasswordResetResponseCopyWithImpl<_PasswordResetResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PasswordResetResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordResetResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,userId);

@override
String toString() {
  return 'PasswordResetResponse(message: $message, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$PasswordResetResponseCopyWith<$Res> implements $PasswordResetResponseCopyWith<$Res> {
  factory _$PasswordResetResponseCopyWith(_PasswordResetResponse value, $Res Function(_PasswordResetResponse) _then) = __$PasswordResetResponseCopyWithImpl;
@override @useResult
$Res call({
 String message,@JsonKey(name: 'user_id') int userId
});




}
/// @nodoc
class __$PasswordResetResponseCopyWithImpl<$Res>
    implements _$PasswordResetResponseCopyWith<$Res> {
  __$PasswordResetResponseCopyWithImpl(this._self, this._then);

  final _PasswordResetResponse _self;
  final $Res Function(_PasswordResetResponse) _then;

/// Create a copy of PasswordResetResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? userId = null,}) {
  return _then(_PasswordResetResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SendResetEmailRequest {

@JsonKey(name: 'temporary_password') String get temporaryPassword;@JsonKey(name: 'email_override') String? get emailOverride;
/// Create a copy of SendResetEmailRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendResetEmailRequestCopyWith<SendResetEmailRequest> get copyWith => _$SendResetEmailRequestCopyWithImpl<SendResetEmailRequest>(this as SendResetEmailRequest, _$identity);

  /// Serializes this SendResetEmailRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendResetEmailRequest&&(identical(other.temporaryPassword, temporaryPassword) || other.temporaryPassword == temporaryPassword)&&(identical(other.emailOverride, emailOverride) || other.emailOverride == emailOverride));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temporaryPassword,emailOverride);

@override
String toString() {
  return 'SendResetEmailRequest(temporaryPassword: $temporaryPassword, emailOverride: $emailOverride)';
}


}

/// @nodoc
abstract mixin class $SendResetEmailRequestCopyWith<$Res>  {
  factory $SendResetEmailRequestCopyWith(SendResetEmailRequest value, $Res Function(SendResetEmailRequest) _then) = _$SendResetEmailRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'temporary_password') String temporaryPassword,@JsonKey(name: 'email_override') String? emailOverride
});




}
/// @nodoc
class _$SendResetEmailRequestCopyWithImpl<$Res>
    implements $SendResetEmailRequestCopyWith<$Res> {
  _$SendResetEmailRequestCopyWithImpl(this._self, this._then);

  final SendResetEmailRequest _self;
  final $Res Function(SendResetEmailRequest) _then;

/// Create a copy of SendResetEmailRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temporaryPassword = null,Object? emailOverride = freezed,}) {
  return _then(_self.copyWith(
temporaryPassword: null == temporaryPassword ? _self.temporaryPassword : temporaryPassword // ignore: cast_nullable_to_non_nullable
as String,emailOverride: freezed == emailOverride ? _self.emailOverride : emailOverride // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SendResetEmailRequest].
extension SendResetEmailRequestPatterns on SendResetEmailRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendResetEmailRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendResetEmailRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendResetEmailRequest value)  $default,){
final _that = this;
switch (_that) {
case _SendResetEmailRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendResetEmailRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SendResetEmailRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'temporary_password')  String temporaryPassword, @JsonKey(name: 'email_override')  String? emailOverride)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendResetEmailRequest() when $default != null:
return $default(_that.temporaryPassword,_that.emailOverride);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'temporary_password')  String temporaryPassword, @JsonKey(name: 'email_override')  String? emailOverride)  $default,) {final _that = this;
switch (_that) {
case _SendResetEmailRequest():
return $default(_that.temporaryPassword,_that.emailOverride);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'temporary_password')  String temporaryPassword, @JsonKey(name: 'email_override')  String? emailOverride)?  $default,) {final _that = this;
switch (_that) {
case _SendResetEmailRequest() when $default != null:
return $default(_that.temporaryPassword,_that.emailOverride);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendResetEmailRequest implements SendResetEmailRequest {
  const _SendResetEmailRequest({@JsonKey(name: 'temporary_password') required this.temporaryPassword, @JsonKey(name: 'email_override') this.emailOverride});
  factory _SendResetEmailRequest.fromJson(Map<String, dynamic> json) => _$SendResetEmailRequestFromJson(json);

@override@JsonKey(name: 'temporary_password') final  String temporaryPassword;
@override@JsonKey(name: 'email_override') final  String? emailOverride;

/// Create a copy of SendResetEmailRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendResetEmailRequestCopyWith<_SendResetEmailRequest> get copyWith => __$SendResetEmailRequestCopyWithImpl<_SendResetEmailRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendResetEmailRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendResetEmailRequest&&(identical(other.temporaryPassword, temporaryPassword) || other.temporaryPassword == temporaryPassword)&&(identical(other.emailOverride, emailOverride) || other.emailOverride == emailOverride));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temporaryPassword,emailOverride);

@override
String toString() {
  return 'SendResetEmailRequest(temporaryPassword: $temporaryPassword, emailOverride: $emailOverride)';
}


}

/// @nodoc
abstract mixin class _$SendResetEmailRequestCopyWith<$Res> implements $SendResetEmailRequestCopyWith<$Res> {
  factory _$SendResetEmailRequestCopyWith(_SendResetEmailRequest value, $Res Function(_SendResetEmailRequest) _then) = __$SendResetEmailRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'temporary_password') String temporaryPassword,@JsonKey(name: 'email_override') String? emailOverride
});




}
/// @nodoc
class __$SendResetEmailRequestCopyWithImpl<$Res>
    implements _$SendResetEmailRequestCopyWith<$Res> {
  __$SendResetEmailRequestCopyWithImpl(this._self, this._then);

  final _SendResetEmailRequest _self;
  final $Res Function(_SendResetEmailRequest) _then;

/// Create a copy of SendResetEmailRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temporaryPassword = null,Object? emailOverride = freezed,}) {
  return _then(_SendResetEmailRequest(
temporaryPassword: null == temporaryPassword ? _self.temporaryPassword : temporaryPassword // ignore: cast_nullable_to_non_nullable
as String,emailOverride: freezed == emailOverride ? _self.emailOverride : emailOverride // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SendResetEmailResponse {

 String get message;@JsonKey(name: 'sent_to') String get sentTo;@JsonKey(name: 'user_id') int get userId;
/// Create a copy of SendResetEmailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendResetEmailResponseCopyWith<SendResetEmailResponse> get copyWith => _$SendResetEmailResponseCopyWithImpl<SendResetEmailResponse>(this as SendResetEmailResponse, _$identity);

  /// Serializes this SendResetEmailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendResetEmailResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.sentTo, sentTo) || other.sentTo == sentTo)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,sentTo,userId);

@override
String toString() {
  return 'SendResetEmailResponse(message: $message, sentTo: $sentTo, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $SendResetEmailResponseCopyWith<$Res>  {
  factory $SendResetEmailResponseCopyWith(SendResetEmailResponse value, $Res Function(SendResetEmailResponse) _then) = _$SendResetEmailResponseCopyWithImpl;
@useResult
$Res call({
 String message,@JsonKey(name: 'sent_to') String sentTo,@JsonKey(name: 'user_id') int userId
});




}
/// @nodoc
class _$SendResetEmailResponseCopyWithImpl<$Res>
    implements $SendResetEmailResponseCopyWith<$Res> {
  _$SendResetEmailResponseCopyWithImpl(this._self, this._then);

  final SendResetEmailResponse _self;
  final $Res Function(SendResetEmailResponse) _then;

/// Create a copy of SendResetEmailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? sentTo = null,Object? userId = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sentTo: null == sentTo ? _self.sentTo : sentTo // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SendResetEmailResponse].
extension SendResetEmailResponsePatterns on SendResetEmailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendResetEmailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendResetEmailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendResetEmailResponse value)  $default,){
final _that = this;
switch (_that) {
case _SendResetEmailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendResetEmailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SendResetEmailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'sent_to')  String sentTo, @JsonKey(name: 'user_id')  int userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendResetEmailResponse() when $default != null:
return $default(_that.message,_that.sentTo,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message, @JsonKey(name: 'sent_to')  String sentTo, @JsonKey(name: 'user_id')  int userId)  $default,) {final _that = this;
switch (_that) {
case _SendResetEmailResponse():
return $default(_that.message,_that.sentTo,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message, @JsonKey(name: 'sent_to')  String sentTo, @JsonKey(name: 'user_id')  int userId)?  $default,) {final _that = this;
switch (_that) {
case _SendResetEmailResponse() when $default != null:
return $default(_that.message,_that.sentTo,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendResetEmailResponse implements SendResetEmailResponse {
  const _SendResetEmailResponse({required this.message, @JsonKey(name: 'sent_to') required this.sentTo, @JsonKey(name: 'user_id') required this.userId});
  factory _SendResetEmailResponse.fromJson(Map<String, dynamic> json) => _$SendResetEmailResponseFromJson(json);

@override final  String message;
@override@JsonKey(name: 'sent_to') final  String sentTo;
@override@JsonKey(name: 'user_id') final  int userId;

/// Create a copy of SendResetEmailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendResetEmailResponseCopyWith<_SendResetEmailResponse> get copyWith => __$SendResetEmailResponseCopyWithImpl<_SendResetEmailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendResetEmailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendResetEmailResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.sentTo, sentTo) || other.sentTo == sentTo)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,sentTo,userId);

@override
String toString() {
  return 'SendResetEmailResponse(message: $message, sentTo: $sentTo, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$SendResetEmailResponseCopyWith<$Res> implements $SendResetEmailResponseCopyWith<$Res> {
  factory _$SendResetEmailResponseCopyWith(_SendResetEmailResponse value, $Res Function(_SendResetEmailResponse) _then) = __$SendResetEmailResponseCopyWithImpl;
@override @useResult
$Res call({
 String message,@JsonKey(name: 'sent_to') String sentTo,@JsonKey(name: 'user_id') int userId
});




}
/// @nodoc
class __$SendResetEmailResponseCopyWithImpl<$Res>
    implements _$SendResetEmailResponseCopyWith<$Res> {
  __$SendResetEmailResponseCopyWithImpl(this._self, this._then);

  final _SendResetEmailResponse _self;
  final $Res Function(_SendResetEmailResponse) _then;

/// Create a copy of SendResetEmailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? sentTo = null,Object? userId = null,}) {
  return _then(_SendResetEmailResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sentTo: null == sentTo ? _self.sentTo : sentTo // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
