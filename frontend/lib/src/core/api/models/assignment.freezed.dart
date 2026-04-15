// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssignmentCreate {

@JsonKey(name: 'account_id') int get accountId;@JsonKey(name: 'due_date') DateTime? get dueDate;
/// Create a copy of AssignmentCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignmentCreateCopyWith<AssignmentCreate> get copyWith => _$AssignmentCreateCopyWithImpl<AssignmentCreate>(this as AssignmentCreate, _$identity);

  /// Serializes this AssignmentCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignmentCreate&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,dueDate);

@override
String toString() {
  return 'AssignmentCreate(accountId: $accountId, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $AssignmentCreateCopyWith<$Res>  {
  factory $AssignmentCreateCopyWith(AssignmentCreate value, $Res Function(AssignmentCreate) _then) = _$AssignmentCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'due_date') DateTime? dueDate
});




}
/// @nodoc
class _$AssignmentCreateCopyWithImpl<$Res>
    implements $AssignmentCreateCopyWith<$Res> {
  _$AssignmentCreateCopyWithImpl(this._self, this._then);

  final AssignmentCreate _self;
  final $Res Function(AssignmentCreate) _then;

/// Create a copy of AssignmentCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? dueDate = freezed,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignmentCreate].
extension AssignmentCreatePatterns on AssignmentCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignmentCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignmentCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignmentCreate value)  $default,){
final _that = this;
switch (_that) {
case _AssignmentCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignmentCreate value)?  $default,){
final _that = this;
switch (_that) {
case _AssignmentCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'due_date')  DateTime? dueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignmentCreate() when $default != null:
return $default(_that.accountId,_that.dueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'due_date')  DateTime? dueDate)  $default,) {final _that = this;
switch (_that) {
case _AssignmentCreate():
return $default(_that.accountId,_that.dueDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'due_date')  DateTime? dueDate)?  $default,) {final _that = this;
switch (_that) {
case _AssignmentCreate() when $default != null:
return $default(_that.accountId,_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignmentCreate implements AssignmentCreate {
  const _AssignmentCreate({@JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'due_date') this.dueDate});
  factory _AssignmentCreate.fromJson(Map<String, dynamic> json) => _$AssignmentCreateFromJson(json);

@override@JsonKey(name: 'account_id') final  int accountId;
@override@JsonKey(name: 'due_date') final  DateTime? dueDate;

/// Create a copy of AssignmentCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignmentCreateCopyWith<_AssignmentCreate> get copyWith => __$AssignmentCreateCopyWithImpl<_AssignmentCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignmentCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignmentCreate&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,dueDate);

@override
String toString() {
  return 'AssignmentCreate(accountId: $accountId, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class _$AssignmentCreateCopyWith<$Res> implements $AssignmentCreateCopyWith<$Res> {
  factory _$AssignmentCreateCopyWith(_AssignmentCreate value, $Res Function(_AssignmentCreate) _then) = __$AssignmentCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'due_date') DateTime? dueDate
});




}
/// @nodoc
class __$AssignmentCreateCopyWithImpl<$Res>
    implements _$AssignmentCreateCopyWith<$Res> {
  __$AssignmentCreateCopyWithImpl(this._self, this._then);

  final _AssignmentCreate _self;
  final $Res Function(_AssignmentCreate) _then;

/// Create a copy of AssignmentCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? dueDate = freezed,}) {
  return _then(_AssignmentCreate(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$BulkAssignmentCreate {

@JsonKey(name: 'account_ids') List<int> get accountIds;@JsonKey(name: 'due_date') DateTime? get dueDate;
/// Create a copy of BulkAssignmentCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkAssignmentCreateCopyWith<BulkAssignmentCreate> get copyWith => _$BulkAssignmentCreateCopyWithImpl<BulkAssignmentCreate>(this as BulkAssignmentCreate, _$identity);

  /// Serializes this BulkAssignmentCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAssignmentCreate&&const DeepCollectionEquality().equals(other.accountIds, accountIds)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(accountIds),dueDate);

@override
String toString() {
  return 'BulkAssignmentCreate(accountIds: $accountIds, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $BulkAssignmentCreateCopyWith<$Res>  {
  factory $BulkAssignmentCreateCopyWith(BulkAssignmentCreate value, $Res Function(BulkAssignmentCreate) _then) = _$BulkAssignmentCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'account_ids') List<int> accountIds,@JsonKey(name: 'due_date') DateTime? dueDate
});




}
/// @nodoc
class _$BulkAssignmentCreateCopyWithImpl<$Res>
    implements $BulkAssignmentCreateCopyWith<$Res> {
  _$BulkAssignmentCreateCopyWithImpl(this._self, this._then);

  final BulkAssignmentCreate _self;
  final $Res Function(BulkAssignmentCreate) _then;

/// Create a copy of BulkAssignmentCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountIds = null,Object? dueDate = freezed,}) {
  return _then(_self.copyWith(
accountIds: null == accountIds ? _self.accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<int>,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkAssignmentCreate].
extension BulkAssignmentCreatePatterns on BulkAssignmentCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkAssignmentCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkAssignmentCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkAssignmentCreate value)  $default,){
final _that = this;
switch (_that) {
case _BulkAssignmentCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkAssignmentCreate value)?  $default,){
final _that = this;
switch (_that) {
case _BulkAssignmentCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_ids')  List<int> accountIds, @JsonKey(name: 'due_date')  DateTime? dueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkAssignmentCreate() when $default != null:
return $default(_that.accountIds,_that.dueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'account_ids')  List<int> accountIds, @JsonKey(name: 'due_date')  DateTime? dueDate)  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentCreate():
return $default(_that.accountIds,_that.dueDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'account_ids')  List<int> accountIds, @JsonKey(name: 'due_date')  DateTime? dueDate)?  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentCreate() when $default != null:
return $default(_that.accountIds,_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkAssignmentCreate implements BulkAssignmentCreate {
  const _BulkAssignmentCreate({@JsonKey(name: 'account_ids') required final  List<int> accountIds, @JsonKey(name: 'due_date') this.dueDate}): _accountIds = accountIds;
  factory _BulkAssignmentCreate.fromJson(Map<String, dynamic> json) => _$BulkAssignmentCreateFromJson(json);

 final  List<int> _accountIds;
@override@JsonKey(name: 'account_ids') List<int> get accountIds {
  if (_accountIds is EqualUnmodifiableListView) return _accountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accountIds);
}

@override@JsonKey(name: 'due_date') final  DateTime? dueDate;

/// Create a copy of BulkAssignmentCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkAssignmentCreateCopyWith<_BulkAssignmentCreate> get copyWith => __$BulkAssignmentCreateCopyWithImpl<_BulkAssignmentCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkAssignmentCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkAssignmentCreate&&const DeepCollectionEquality().equals(other._accountIds, _accountIds)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_accountIds),dueDate);

@override
String toString() {
  return 'BulkAssignmentCreate(accountIds: $accountIds, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class _$BulkAssignmentCreateCopyWith<$Res> implements $BulkAssignmentCreateCopyWith<$Res> {
  factory _$BulkAssignmentCreateCopyWith(_BulkAssignmentCreate value, $Res Function(_BulkAssignmentCreate) _then) = __$BulkAssignmentCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'account_ids') List<int> accountIds,@JsonKey(name: 'due_date') DateTime? dueDate
});




}
/// @nodoc
class __$BulkAssignmentCreateCopyWithImpl<$Res>
    implements _$BulkAssignmentCreateCopyWith<$Res> {
  __$BulkAssignmentCreateCopyWithImpl(this._self, this._then);

  final _BulkAssignmentCreate _self;
  final $Res Function(_BulkAssignmentCreate) _then;

/// Create a copy of BulkAssignmentCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountIds = null,Object? dueDate = freezed,}) {
  return _then(_BulkAssignmentCreate(
accountIds: null == accountIds ? _self._accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<int>,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$BulkAssignmentResult {

 int get assigned; int get skipped;@JsonKey(name: 'total_targeted') int get totalTargeted;
/// Create a copy of BulkAssignmentResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkAssignmentResultCopyWith<BulkAssignmentResult> get copyWith => _$BulkAssignmentResultCopyWithImpl<BulkAssignmentResult>(this as BulkAssignmentResult, _$identity);

  /// Serializes this BulkAssignmentResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAssignmentResult&&(identical(other.assigned, assigned) || other.assigned == assigned)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.totalTargeted, totalTargeted) || other.totalTargeted == totalTargeted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assigned,skipped,totalTargeted);

@override
String toString() {
  return 'BulkAssignmentResult(assigned: $assigned, skipped: $skipped, totalTargeted: $totalTargeted)';
}


}

/// @nodoc
abstract mixin class $BulkAssignmentResultCopyWith<$Res>  {
  factory $BulkAssignmentResultCopyWith(BulkAssignmentResult value, $Res Function(BulkAssignmentResult) _then) = _$BulkAssignmentResultCopyWithImpl;
@useResult
$Res call({
 int assigned, int skipped,@JsonKey(name: 'total_targeted') int totalTargeted
});




}
/// @nodoc
class _$BulkAssignmentResultCopyWithImpl<$Res>
    implements $BulkAssignmentResultCopyWith<$Res> {
  _$BulkAssignmentResultCopyWithImpl(this._self, this._then);

  final BulkAssignmentResult _self;
  final $Res Function(BulkAssignmentResult) _then;

/// Create a copy of BulkAssignmentResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assigned = null,Object? skipped = null,Object? totalTargeted = null,}) {
  return _then(_self.copyWith(
assigned: null == assigned ? _self.assigned : assigned // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,totalTargeted: null == totalTargeted ? _self.totalTargeted : totalTargeted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkAssignmentResult].
extension BulkAssignmentResultPatterns on BulkAssignmentResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkAssignmentResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkAssignmentResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkAssignmentResult value)  $default,){
final _that = this;
switch (_that) {
case _BulkAssignmentResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkAssignmentResult value)?  $default,){
final _that = this;
switch (_that) {
case _BulkAssignmentResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int assigned,  int skipped, @JsonKey(name: 'total_targeted')  int totalTargeted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkAssignmentResult() when $default != null:
return $default(_that.assigned,_that.skipped,_that.totalTargeted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int assigned,  int skipped, @JsonKey(name: 'total_targeted')  int totalTargeted)  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentResult():
return $default(_that.assigned,_that.skipped,_that.totalTargeted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int assigned,  int skipped, @JsonKey(name: 'total_targeted')  int totalTargeted)?  $default,) {final _that = this;
switch (_that) {
case _BulkAssignmentResult() when $default != null:
return $default(_that.assigned,_that.skipped,_that.totalTargeted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkAssignmentResult implements BulkAssignmentResult {
  const _BulkAssignmentResult({required this.assigned, required this.skipped, @JsonKey(name: 'total_targeted') required this.totalTargeted});
  factory _BulkAssignmentResult.fromJson(Map<String, dynamic> json) => _$BulkAssignmentResultFromJson(json);

@override final  int assigned;
@override final  int skipped;
@override@JsonKey(name: 'total_targeted') final  int totalTargeted;

/// Create a copy of BulkAssignmentResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkAssignmentResultCopyWith<_BulkAssignmentResult> get copyWith => __$BulkAssignmentResultCopyWithImpl<_BulkAssignmentResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkAssignmentResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkAssignmentResult&&(identical(other.assigned, assigned) || other.assigned == assigned)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.totalTargeted, totalTargeted) || other.totalTargeted == totalTargeted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assigned,skipped,totalTargeted);

@override
String toString() {
  return 'BulkAssignmentResult(assigned: $assigned, skipped: $skipped, totalTargeted: $totalTargeted)';
}


}

/// @nodoc
abstract mixin class _$BulkAssignmentResultCopyWith<$Res> implements $BulkAssignmentResultCopyWith<$Res> {
  factory _$BulkAssignmentResultCopyWith(_BulkAssignmentResult value, $Res Function(_BulkAssignmentResult) _then) = __$BulkAssignmentResultCopyWithImpl;
@override @useResult
$Res call({
 int assigned, int skipped,@JsonKey(name: 'total_targeted') int totalTargeted
});




}
/// @nodoc
class __$BulkAssignmentResultCopyWithImpl<$Res>
    implements _$BulkAssignmentResultCopyWith<$Res> {
  __$BulkAssignmentResultCopyWithImpl(this._self, this._then);

  final _BulkAssignmentResult _self;
  final $Res Function(_BulkAssignmentResult) _then;

/// Create a copy of BulkAssignmentResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assigned = null,Object? skipped = null,Object? totalTargeted = null,}) {
  return _then(_BulkAssignmentResult(
assigned: null == assigned ? _self.assigned : assigned // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,totalTargeted: null == totalTargeted ? _self.totalTargeted : totalTargeted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AssignmentUpdate {

@JsonKey(name: 'due_date') DateTime? get dueDate; String? get status;
/// Create a copy of AssignmentUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignmentUpdateCopyWith<AssignmentUpdate> get copyWith => _$AssignmentUpdateCopyWithImpl<AssignmentUpdate>(this as AssignmentUpdate, _$identity);

  /// Serializes this AssignmentUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignmentUpdate&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dueDate,status);

@override
String toString() {
  return 'AssignmentUpdate(dueDate: $dueDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $AssignmentUpdateCopyWith<$Res>  {
  factory $AssignmentUpdateCopyWith(AssignmentUpdate value, $Res Function(AssignmentUpdate) _then) = _$AssignmentUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'due_date') DateTime? dueDate, String? status
});




}
/// @nodoc
class _$AssignmentUpdateCopyWithImpl<$Res>
    implements $AssignmentUpdateCopyWith<$Res> {
  _$AssignmentUpdateCopyWithImpl(this._self, this._then);

  final AssignmentUpdate _self;
  final $Res Function(AssignmentUpdate) _then;

/// Create a copy of AssignmentUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dueDate = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignmentUpdate].
extension AssignmentUpdatePatterns on AssignmentUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignmentUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignmentUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignmentUpdate value)  $default,){
final _that = this;
switch (_that) {
case _AssignmentUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignmentUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _AssignmentUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'due_date')  DateTime? dueDate,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignmentUpdate() when $default != null:
return $default(_that.dueDate,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'due_date')  DateTime? dueDate,  String? status)  $default,) {final _that = this;
switch (_that) {
case _AssignmentUpdate():
return $default(_that.dueDate,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'due_date')  DateTime? dueDate,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _AssignmentUpdate() when $default != null:
return $default(_that.dueDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignmentUpdate implements AssignmentUpdate {
  const _AssignmentUpdate({@JsonKey(name: 'due_date') this.dueDate, this.status});
  factory _AssignmentUpdate.fromJson(Map<String, dynamic> json) => _$AssignmentUpdateFromJson(json);

@override@JsonKey(name: 'due_date') final  DateTime? dueDate;
@override final  String? status;

/// Create a copy of AssignmentUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignmentUpdateCopyWith<_AssignmentUpdate> get copyWith => __$AssignmentUpdateCopyWithImpl<_AssignmentUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignmentUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignmentUpdate&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dueDate,status);

@override
String toString() {
  return 'AssignmentUpdate(dueDate: $dueDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AssignmentUpdateCopyWith<$Res> implements $AssignmentUpdateCopyWith<$Res> {
  factory _$AssignmentUpdateCopyWith(_AssignmentUpdate value, $Res Function(_AssignmentUpdate) _then) = __$AssignmentUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'due_date') DateTime? dueDate, String? status
});




}
/// @nodoc
class __$AssignmentUpdateCopyWithImpl<$Res>
    implements _$AssignmentUpdateCopyWith<$Res> {
  __$AssignmentUpdateCopyWithImpl(this._self, this._then);

  final _AssignmentUpdate _self;
  final $Res Function(_AssignmentUpdate) _then;

/// Create a copy of AssignmentUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dueDate = freezed,Object? status = freezed,}) {
  return _then(_AssignmentUpdate(
dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Assignment {

@JsonKey(name: 'assignment_id') int get assignmentId;@JsonKey(name: 'survey_id') int get surveyId;@JsonKey(name: 'account_id') int get accountId;@JsonKey(name: 'assigned_at') DateTime? get assignedAt;@JsonKey(name: 'due_date') DateTime? get dueDate;@JsonKey(name: 'completed_at') DateTime? get completedAt; String get status;
/// Create a copy of Assignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignmentCopyWith<Assignment> get copyWith => _$AssignmentCopyWithImpl<Assignment>(this as Assignment, _$identity);

  /// Serializes this Assignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Assignment&&(identical(other.assignmentId, assignmentId) || other.assignmentId == assignmentId)&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assignmentId,surveyId,accountId,assignedAt,dueDate,completedAt,status);

@override
String toString() {
  return 'Assignment(assignmentId: $assignmentId, surveyId: $surveyId, accountId: $accountId, assignedAt: $assignedAt, dueDate: $dueDate, completedAt: $completedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $AssignmentCopyWith<$Res>  {
  factory $AssignmentCopyWith(Assignment value, $Res Function(Assignment) _then) = _$AssignmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assignment_id') int assignmentId,@JsonKey(name: 'survey_id') int surveyId,@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'assigned_at') DateTime? assignedAt,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'completed_at') DateTime? completedAt, String status
});




}
/// @nodoc
class _$AssignmentCopyWithImpl<$Res>
    implements $AssignmentCopyWith<$Res> {
  _$AssignmentCopyWithImpl(this._self, this._then);

  final Assignment _self;
  final $Res Function(Assignment) _then;

/// Create a copy of Assignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assignmentId = null,Object? surveyId = null,Object? accountId = null,Object? assignedAt = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as int,surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Assignment].
extension AssignmentPatterns on Assignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Assignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Assignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Assignment value)  $default,){
final _that = this;
switch (_that) {
case _Assignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Assignment value)?  $default,){
final _that = this;
switch (_that) {
case _Assignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'assignment_id')  int assignmentId, @JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Assignment() when $default != null:
return $default(_that.assignmentId,_that.surveyId,_that.accountId,_that.assignedAt,_that.dueDate,_that.completedAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'assignment_id')  int assignmentId, @JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt,  String status)  $default,) {final _that = this;
switch (_that) {
case _Assignment():
return $default(_that.assignmentId,_that.surveyId,_that.accountId,_that.assignedAt,_that.dueDate,_that.completedAt,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'assignment_id')  int assignmentId, @JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'account_id')  int accountId, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt,  String status)?  $default,) {final _that = this;
switch (_that) {
case _Assignment() when $default != null:
return $default(_that.assignmentId,_that.surveyId,_that.accountId,_that.assignedAt,_that.dueDate,_that.completedAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Assignment implements Assignment {
  const _Assignment({@JsonKey(name: 'assignment_id') required this.assignmentId, @JsonKey(name: 'survey_id') required this.surveyId, @JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'assigned_at') this.assignedAt, @JsonKey(name: 'due_date') this.dueDate, @JsonKey(name: 'completed_at') this.completedAt, required this.status});
  factory _Assignment.fromJson(Map<String, dynamic> json) => _$AssignmentFromJson(json);

@override@JsonKey(name: 'assignment_id') final  int assignmentId;
@override@JsonKey(name: 'survey_id') final  int surveyId;
@override@JsonKey(name: 'account_id') final  int accountId;
@override@JsonKey(name: 'assigned_at') final  DateTime? assignedAt;
@override@JsonKey(name: 'due_date') final  DateTime? dueDate;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override final  String status;

/// Create a copy of Assignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignmentCopyWith<_Assignment> get copyWith => __$AssignmentCopyWithImpl<_Assignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Assignment&&(identical(other.assignmentId, assignmentId) || other.assignmentId == assignmentId)&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assignmentId,surveyId,accountId,assignedAt,dueDate,completedAt,status);

@override
String toString() {
  return 'Assignment(assignmentId: $assignmentId, surveyId: $surveyId, accountId: $accountId, assignedAt: $assignedAt, dueDate: $dueDate, completedAt: $completedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AssignmentCopyWith<$Res> implements $AssignmentCopyWith<$Res> {
  factory _$AssignmentCopyWith(_Assignment value, $Res Function(_Assignment) _then) = __$AssignmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assignment_id') int assignmentId,@JsonKey(name: 'survey_id') int surveyId,@JsonKey(name: 'account_id') int accountId,@JsonKey(name: 'assigned_at') DateTime? assignedAt,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'completed_at') DateTime? completedAt, String status
});




}
/// @nodoc
class __$AssignmentCopyWithImpl<$Res>
    implements _$AssignmentCopyWith<$Res> {
  __$AssignmentCopyWithImpl(this._self, this._then);

  final _Assignment _self;
  final $Res Function(_Assignment) _then;

/// Create a copy of Assignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assignmentId = null,Object? surveyId = null,Object? accountId = null,Object? assignedAt = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? status = null,}) {
  return _then(_Assignment(
assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as int,surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MyAssignment {

@JsonKey(name: 'assignment_id') int get assignmentId;@JsonKey(name: 'survey_id') int get surveyId;@JsonKey(name: 'survey_title') String? get surveyTitle;@JsonKey(name: 'assigned_at') DateTime? get assignedAt;@JsonKey(name: 'due_date') DateTime? get dueDate;@JsonKey(name: 'completed_at') DateTime? get completedAt; String get status;
/// Create a copy of MyAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyAssignmentCopyWith<MyAssignment> get copyWith => _$MyAssignmentCopyWithImpl<MyAssignment>(this as MyAssignment, _$identity);

  /// Serializes this MyAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyAssignment&&(identical(other.assignmentId, assignmentId) || other.assignmentId == assignmentId)&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.surveyTitle, surveyTitle) || other.surveyTitle == surveyTitle)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assignmentId,surveyId,surveyTitle,assignedAt,dueDate,completedAt,status);

@override
String toString() {
  return 'MyAssignment(assignmentId: $assignmentId, surveyId: $surveyId, surveyTitle: $surveyTitle, assignedAt: $assignedAt, dueDate: $dueDate, completedAt: $completedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $MyAssignmentCopyWith<$Res>  {
  factory $MyAssignmentCopyWith(MyAssignment value, $Res Function(MyAssignment) _then) = _$MyAssignmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assignment_id') int assignmentId,@JsonKey(name: 'survey_id') int surveyId,@JsonKey(name: 'survey_title') String? surveyTitle,@JsonKey(name: 'assigned_at') DateTime? assignedAt,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'completed_at') DateTime? completedAt, String status
});




}
/// @nodoc
class _$MyAssignmentCopyWithImpl<$Res>
    implements $MyAssignmentCopyWith<$Res> {
  _$MyAssignmentCopyWithImpl(this._self, this._then);

  final MyAssignment _self;
  final $Res Function(MyAssignment) _then;

/// Create a copy of MyAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assignmentId = null,Object? surveyId = null,Object? surveyTitle = freezed,Object? assignedAt = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as int,surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,surveyTitle: freezed == surveyTitle ? _self.surveyTitle : surveyTitle // ignore: cast_nullable_to_non_nullable
as String?,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MyAssignment].
extension MyAssignmentPatterns on MyAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyAssignment value)  $default,){
final _that = this;
switch (_that) {
case _MyAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _MyAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'assignment_id')  int assignmentId, @JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'survey_title')  String? surveyTitle, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyAssignment() when $default != null:
return $default(_that.assignmentId,_that.surveyId,_that.surveyTitle,_that.assignedAt,_that.dueDate,_that.completedAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'assignment_id')  int assignmentId, @JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'survey_title')  String? surveyTitle, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt,  String status)  $default,) {final _that = this;
switch (_that) {
case _MyAssignment():
return $default(_that.assignmentId,_that.surveyId,_that.surveyTitle,_that.assignedAt,_that.dueDate,_that.completedAt,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'assignment_id')  int assignmentId, @JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'survey_title')  String? surveyTitle, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt,  String status)?  $default,) {final _that = this;
switch (_that) {
case _MyAssignment() when $default != null:
return $default(_that.assignmentId,_that.surveyId,_that.surveyTitle,_that.assignedAt,_that.dueDate,_that.completedAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyAssignment implements MyAssignment {
  const _MyAssignment({@JsonKey(name: 'assignment_id') required this.assignmentId, @JsonKey(name: 'survey_id') required this.surveyId, @JsonKey(name: 'survey_title') this.surveyTitle, @JsonKey(name: 'assigned_at') this.assignedAt, @JsonKey(name: 'due_date') this.dueDate, @JsonKey(name: 'completed_at') this.completedAt, required this.status});
  factory _MyAssignment.fromJson(Map<String, dynamic> json) => _$MyAssignmentFromJson(json);

@override@JsonKey(name: 'assignment_id') final  int assignmentId;
@override@JsonKey(name: 'survey_id') final  int surveyId;
@override@JsonKey(name: 'survey_title') final  String? surveyTitle;
@override@JsonKey(name: 'assigned_at') final  DateTime? assignedAt;
@override@JsonKey(name: 'due_date') final  DateTime? dueDate;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override final  String status;

/// Create a copy of MyAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyAssignmentCopyWith<_MyAssignment> get copyWith => __$MyAssignmentCopyWithImpl<_MyAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyAssignment&&(identical(other.assignmentId, assignmentId) || other.assignmentId == assignmentId)&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.surveyTitle, surveyTitle) || other.surveyTitle == surveyTitle)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assignmentId,surveyId,surveyTitle,assignedAt,dueDate,completedAt,status);

@override
String toString() {
  return 'MyAssignment(assignmentId: $assignmentId, surveyId: $surveyId, surveyTitle: $surveyTitle, assignedAt: $assignedAt, dueDate: $dueDate, completedAt: $completedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MyAssignmentCopyWith<$Res> implements $MyAssignmentCopyWith<$Res> {
  factory _$MyAssignmentCopyWith(_MyAssignment value, $Res Function(_MyAssignment) _then) = __$MyAssignmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assignment_id') int assignmentId,@JsonKey(name: 'survey_id') int surveyId,@JsonKey(name: 'survey_title') String? surveyTitle,@JsonKey(name: 'assigned_at') DateTime? assignedAt,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'completed_at') DateTime? completedAt, String status
});




}
/// @nodoc
class __$MyAssignmentCopyWithImpl<$Res>
    implements _$MyAssignmentCopyWith<$Res> {
  __$MyAssignmentCopyWithImpl(this._self, this._then);

  final _MyAssignment _self;
  final $Res Function(_MyAssignment) _then;

/// Create a copy of MyAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assignmentId = null,Object? surveyId = null,Object? surveyTitle = freezed,Object? assignedAt = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? status = null,}) {
  return _then(_MyAssignment(
assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as int,surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,surveyTitle: freezed == surveyTitle ? _self.surveyTitle : surveyTitle // ignore: cast_nullable_to_non_nullable
as String?,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
