// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_tracking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackingCategory {

@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'category_key') String get categoryKey;@JsonKey(name: 'display_name') String get displayName; String? get description; String? get icon;@JsonKey(name: 'display_order') int get displayOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'is_deleted') bool get isDeleted; List<TrackingMetric> get metrics;
/// Create a copy of TrackingCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingCategoryCopyWith<TrackingCategory> get copyWith => _$TrackingCategoryCopyWithImpl<TrackingCategory>(this as TrackingCategory, _$identity);

  /// Serializes this TrackingCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&const DeepCollectionEquality().equals(other.metrics, metrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryKey,displayName,description,icon,displayOrder,isActive,isDeleted,const DeepCollectionEquality().hash(metrics));

@override
String toString() {
  return 'TrackingCategory(categoryId: $categoryId, categoryKey: $categoryKey, displayName: $displayName, description: $description, icon: $icon, displayOrder: $displayOrder, isActive: $isActive, isDeleted: $isDeleted, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class $TrackingCategoryCopyWith<$Res>  {
  factory $TrackingCategoryCopyWith(TrackingCategory value, $Res Function(TrackingCategory) _then) = _$TrackingCategoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_key') String categoryKey,@JsonKey(name: 'display_name') String displayName, String? description, String? icon,@JsonKey(name: 'display_order') int displayOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_deleted') bool isDeleted, List<TrackingMetric> metrics
});




}
/// @nodoc
class _$TrackingCategoryCopyWithImpl<$Res>
    implements $TrackingCategoryCopyWith<$Res> {
  _$TrackingCategoryCopyWithImpl(this._self, this._then);

  final TrackingCategory _self;
  final $Res Function(TrackingCategory) _then;

/// Create a copy of TrackingCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryKey = null,Object? displayName = null,Object? description = freezed,Object? icon = freezed,Object? displayOrder = null,Object? isActive = null,Object? isDeleted = null,Object? metrics = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<TrackingMetric>,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackingCategory].
extension TrackingCategoryPatterns on TrackingCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingCategory value)  $default,){
final _that = this;
switch (_that) {
case _TrackingCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingCategory value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_key')  String categoryKey, @JsonKey(name: 'display_name')  String displayName,  String? description,  String? icon, @JsonKey(name: 'display_order')  int displayOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_deleted')  bool isDeleted,  List<TrackingMetric> metrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingCategory() when $default != null:
return $default(_that.categoryId,_that.categoryKey,_that.displayName,_that.description,_that.icon,_that.displayOrder,_that.isActive,_that.isDeleted,_that.metrics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_key')  String categoryKey, @JsonKey(name: 'display_name')  String displayName,  String? description,  String? icon, @JsonKey(name: 'display_order')  int displayOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_deleted')  bool isDeleted,  List<TrackingMetric> metrics)  $default,) {final _that = this;
switch (_that) {
case _TrackingCategory():
return $default(_that.categoryId,_that.categoryKey,_that.displayName,_that.description,_that.icon,_that.displayOrder,_that.isActive,_that.isDeleted,_that.metrics);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_key')  String categoryKey, @JsonKey(name: 'display_name')  String displayName,  String? description,  String? icon, @JsonKey(name: 'display_order')  int displayOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_deleted')  bool isDeleted,  List<TrackingMetric> metrics)?  $default,) {final _that = this;
switch (_that) {
case _TrackingCategory() when $default != null:
return $default(_that.categoryId,_that.categoryKey,_that.displayName,_that.description,_that.icon,_that.displayOrder,_that.isActive,_that.isDeleted,_that.metrics);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TrackingCategory implements TrackingCategory {
  const _TrackingCategory({@JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'category_key') required this.categoryKey, @JsonKey(name: 'display_name') required this.displayName, this.description, this.icon, @JsonKey(name: 'display_order') required this.displayOrder, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'is_deleted') this.isDeleted = false, final  List<TrackingMetric> metrics = const <TrackingMetric>[]}): _metrics = metrics;
  factory _TrackingCategory.fromJson(Map<String, dynamic> json) => _$TrackingCategoryFromJson(json);

@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'category_key') final  String categoryKey;
@override@JsonKey(name: 'display_name') final  String displayName;
@override final  String? description;
@override final  String? icon;
@override@JsonKey(name: 'display_order') final  int displayOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'is_deleted') final  bool isDeleted;
 final  List<TrackingMetric> _metrics;
@override@JsonKey() List<TrackingMetric> get metrics {
  if (_metrics is EqualUnmodifiableListView) return _metrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_metrics);
}


/// Create a copy of TrackingCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingCategoryCopyWith<_TrackingCategory> get copyWith => __$TrackingCategoryCopyWithImpl<_TrackingCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackingCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&const DeepCollectionEquality().equals(other._metrics, _metrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryKey,displayName,description,icon,displayOrder,isActive,isDeleted,const DeepCollectionEquality().hash(_metrics));

@override
String toString() {
  return 'TrackingCategory(categoryId: $categoryId, categoryKey: $categoryKey, displayName: $displayName, description: $description, icon: $icon, displayOrder: $displayOrder, isActive: $isActive, isDeleted: $isDeleted, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class _$TrackingCategoryCopyWith<$Res> implements $TrackingCategoryCopyWith<$Res> {
  factory _$TrackingCategoryCopyWith(_TrackingCategory value, $Res Function(_TrackingCategory) _then) = __$TrackingCategoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_key') String categoryKey,@JsonKey(name: 'display_name') String displayName, String? description, String? icon,@JsonKey(name: 'display_order') int displayOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_deleted') bool isDeleted, List<TrackingMetric> metrics
});




}
/// @nodoc
class __$TrackingCategoryCopyWithImpl<$Res>
    implements _$TrackingCategoryCopyWith<$Res> {
  __$TrackingCategoryCopyWithImpl(this._self, this._then);

  final _TrackingCategory _self;
  final $Res Function(_TrackingCategory) _then;

/// Create a copy of TrackingCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryKey = null,Object? displayName = null,Object? description = freezed,Object? icon = freezed,Object? displayOrder = null,Object? isActive = null,Object? isDeleted = null,Object? metrics = null,}) {
  return _then(_TrackingCategory(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,metrics: null == metrics ? _self._metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<TrackingMetric>,
  ));
}


}


/// @nodoc
mixin _$TrackingMetric {

@JsonKey(name: 'metric_id') int get metricId;@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'metric_key') String get metricKey;@JsonKey(name: 'display_name') String get displayName; String? get description;@JsonKey(name: 'metric_type') String get metricType; String? get unit;@JsonKey(name: 'scale_min') int? get scaleMin;@JsonKey(name: 'scale_max') int? get scaleMax;@JsonKey(name: 'choice_options') List<String>? get choiceOptions; String get frequency;@JsonKey(name: 'display_order') int get displayOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'is_baseline') bool get isBaseline;@JsonKey(name: 'is_deleted') bool get isDeleted;
/// Create a copy of TrackingMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingMetricCopyWith<TrackingMetric> get copyWith => _$TrackingMetricCopyWithImpl<TrackingMetric>(this as TrackingMetric, _$identity);

  /// Serializes this TrackingMetric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingMetric&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.metricKey, metricKey) || other.metricKey == metricKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.description, description) || other.description == description)&&(identical(other.metricType, metricType) || other.metricType == metricType)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax)&&const DeepCollectionEquality().equals(other.choiceOptions, choiceOptions)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isBaseline, isBaseline) || other.isBaseline == isBaseline)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metricId,categoryId,metricKey,displayName,description,metricType,unit,scaleMin,scaleMax,const DeepCollectionEquality().hash(choiceOptions),frequency,displayOrder,isActive,isBaseline,isDeleted);

@override
String toString() {
  return 'TrackingMetric(metricId: $metricId, categoryId: $categoryId, metricKey: $metricKey, displayName: $displayName, description: $description, metricType: $metricType, unit: $unit, scaleMin: $scaleMin, scaleMax: $scaleMax, choiceOptions: $choiceOptions, frequency: $frequency, displayOrder: $displayOrder, isActive: $isActive, isBaseline: $isBaseline, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $TrackingMetricCopyWith<$Res>  {
  factory $TrackingMetricCopyWith(TrackingMetric value, $Res Function(TrackingMetric) _then) = _$TrackingMetricCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'metric_id') int metricId,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'metric_key') String metricKey,@JsonKey(name: 'display_name') String displayName, String? description,@JsonKey(name: 'metric_type') String metricType, String? unit,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax,@JsonKey(name: 'choice_options') List<String>? choiceOptions, String frequency,@JsonKey(name: 'display_order') int displayOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_baseline') bool isBaseline,@JsonKey(name: 'is_deleted') bool isDeleted
});




}
/// @nodoc
class _$TrackingMetricCopyWithImpl<$Res>
    implements $TrackingMetricCopyWith<$Res> {
  _$TrackingMetricCopyWithImpl(this._self, this._then);

  final TrackingMetric _self;
  final $Res Function(TrackingMetric) _then;

/// Create a copy of TrackingMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metricId = null,Object? categoryId = null,Object? metricKey = null,Object? displayName = null,Object? description = freezed,Object? metricType = null,Object? unit = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,Object? choiceOptions = freezed,Object? frequency = null,Object? displayOrder = null,Object? isActive = null,Object? isBaseline = null,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,metricKey: null == metricKey ? _self.metricKey : metricKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,metricType: null == metricType ? _self.metricType : metricType // ignore: cast_nullable_to_non_nullable
as String,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,choiceOptions: freezed == choiceOptions ? _self.choiceOptions : choiceOptions // ignore: cast_nullable_to_non_nullable
as List<String>?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isBaseline: null == isBaseline ? _self.isBaseline : isBaseline // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackingMetric].
extension TrackingMetricPatterns on TrackingMetric {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingMetric() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingMetric value)  $default,){
final _that = this;
switch (_that) {
case _TrackingMetric():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingMetric value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingMetric() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'metric_id')  int metricId, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'metric_key')  String metricKey, @JsonKey(name: 'display_name')  String displayName,  String? description, @JsonKey(name: 'metric_type')  String metricType,  String? unit, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax, @JsonKey(name: 'choice_options')  List<String>? choiceOptions,  String frequency, @JsonKey(name: 'display_order')  int displayOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_baseline')  bool isBaseline, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingMetric() when $default != null:
return $default(_that.metricId,_that.categoryId,_that.metricKey,_that.displayName,_that.description,_that.metricType,_that.unit,_that.scaleMin,_that.scaleMax,_that.choiceOptions,_that.frequency,_that.displayOrder,_that.isActive,_that.isBaseline,_that.isDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'metric_id')  int metricId, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'metric_key')  String metricKey, @JsonKey(name: 'display_name')  String displayName,  String? description, @JsonKey(name: 'metric_type')  String metricType,  String? unit, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax, @JsonKey(name: 'choice_options')  List<String>? choiceOptions,  String frequency, @JsonKey(name: 'display_order')  int displayOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_baseline')  bool isBaseline, @JsonKey(name: 'is_deleted')  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _TrackingMetric():
return $default(_that.metricId,_that.categoryId,_that.metricKey,_that.displayName,_that.description,_that.metricType,_that.unit,_that.scaleMin,_that.scaleMax,_that.choiceOptions,_that.frequency,_that.displayOrder,_that.isActive,_that.isBaseline,_that.isDeleted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'metric_id')  int metricId, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'metric_key')  String metricKey, @JsonKey(name: 'display_name')  String displayName,  String? description, @JsonKey(name: 'metric_type')  String metricType,  String? unit, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax, @JsonKey(name: 'choice_options')  List<String>? choiceOptions,  String frequency, @JsonKey(name: 'display_order')  int displayOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_baseline')  bool isBaseline, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _TrackingMetric() when $default != null:
return $default(_that.metricId,_that.categoryId,_that.metricKey,_that.displayName,_that.description,_that.metricType,_that.unit,_that.scaleMin,_that.scaleMax,_that.choiceOptions,_that.frequency,_that.displayOrder,_that.isActive,_that.isBaseline,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TrackingMetric implements TrackingMetric {
  const _TrackingMetric({@JsonKey(name: 'metric_id') required this.metricId, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'metric_key') required this.metricKey, @JsonKey(name: 'display_name') required this.displayName, this.description, @JsonKey(name: 'metric_type') required this.metricType, this.unit, @JsonKey(name: 'scale_min') this.scaleMin, @JsonKey(name: 'scale_max') this.scaleMax, @JsonKey(name: 'choice_options') final  List<String>? choiceOptions, required this.frequency, @JsonKey(name: 'display_order') required this.displayOrder, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'is_baseline') required this.isBaseline, @JsonKey(name: 'is_deleted') this.isDeleted = false}): _choiceOptions = choiceOptions;
  factory _TrackingMetric.fromJson(Map<String, dynamic> json) => _$TrackingMetricFromJson(json);

@override@JsonKey(name: 'metric_id') final  int metricId;
@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'metric_key') final  String metricKey;
@override@JsonKey(name: 'display_name') final  String displayName;
@override final  String? description;
@override@JsonKey(name: 'metric_type') final  String metricType;
@override final  String? unit;
@override@JsonKey(name: 'scale_min') final  int? scaleMin;
@override@JsonKey(name: 'scale_max') final  int? scaleMax;
 final  List<String>? _choiceOptions;
@override@JsonKey(name: 'choice_options') List<String>? get choiceOptions {
  final value = _choiceOptions;
  if (value == null) return null;
  if (_choiceOptions is EqualUnmodifiableListView) return _choiceOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String frequency;
@override@JsonKey(name: 'display_order') final  int displayOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'is_baseline') final  bool isBaseline;
@override@JsonKey(name: 'is_deleted') final  bool isDeleted;

/// Create a copy of TrackingMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingMetricCopyWith<_TrackingMetric> get copyWith => __$TrackingMetricCopyWithImpl<_TrackingMetric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackingMetricToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingMetric&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.metricKey, metricKey) || other.metricKey == metricKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.description, description) || other.description == description)&&(identical(other.metricType, metricType) || other.metricType == metricType)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax)&&const DeepCollectionEquality().equals(other._choiceOptions, _choiceOptions)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isBaseline, isBaseline) || other.isBaseline == isBaseline)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metricId,categoryId,metricKey,displayName,description,metricType,unit,scaleMin,scaleMax,const DeepCollectionEquality().hash(_choiceOptions),frequency,displayOrder,isActive,isBaseline,isDeleted);

@override
String toString() {
  return 'TrackingMetric(metricId: $metricId, categoryId: $categoryId, metricKey: $metricKey, displayName: $displayName, description: $description, metricType: $metricType, unit: $unit, scaleMin: $scaleMin, scaleMax: $scaleMax, choiceOptions: $choiceOptions, frequency: $frequency, displayOrder: $displayOrder, isActive: $isActive, isBaseline: $isBaseline, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$TrackingMetricCopyWith<$Res> implements $TrackingMetricCopyWith<$Res> {
  factory _$TrackingMetricCopyWith(_TrackingMetric value, $Res Function(_TrackingMetric) _then) = __$TrackingMetricCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'metric_id') int metricId,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'metric_key') String metricKey,@JsonKey(name: 'display_name') String displayName, String? description,@JsonKey(name: 'metric_type') String metricType, String? unit,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax,@JsonKey(name: 'choice_options') List<String>? choiceOptions, String frequency,@JsonKey(name: 'display_order') int displayOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_baseline') bool isBaseline,@JsonKey(name: 'is_deleted') bool isDeleted
});




}
/// @nodoc
class __$TrackingMetricCopyWithImpl<$Res>
    implements _$TrackingMetricCopyWith<$Res> {
  __$TrackingMetricCopyWithImpl(this._self, this._then);

  final _TrackingMetric _self;
  final $Res Function(_TrackingMetric) _then;

/// Create a copy of TrackingMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metricId = null,Object? categoryId = null,Object? metricKey = null,Object? displayName = null,Object? description = freezed,Object? metricType = null,Object? unit = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,Object? choiceOptions = freezed,Object? frequency = null,Object? displayOrder = null,Object? isActive = null,Object? isBaseline = null,Object? isDeleted = null,}) {
  return _then(_TrackingMetric(
metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,metricKey: null == metricKey ? _self.metricKey : metricKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,metricType: null == metricType ? _self.metricType : metricType // ignore: cast_nullable_to_non_nullable
as String,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,choiceOptions: freezed == choiceOptions ? _self._choiceOptions : choiceOptions // ignore: cast_nullable_to_non_nullable
as List<String>?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isBaseline: null == isBaseline ? _self.isBaseline : isBaseline // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TrackingEntry {

@JsonKey(name: 'entry_id') int get entryId;@JsonKey(name: 'participant_id') int get participantId;@JsonKey(name: 'metric_id') int get metricId; String get value; String? get notes;@JsonKey(name: 'entry_date') DateTime get entryDate;@JsonKey(name: 'is_baseline') bool get isBaseline;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of TrackingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingEntryCopyWith<TrackingEntry> get copyWith => _$TrackingEntryCopyWithImpl<TrackingEntry>(this as TrackingEntry, _$identity);

  /// Serializes this TrackingEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingEntry&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.value, value) || other.value == value)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.isBaseline, isBaseline) || other.isBaseline == isBaseline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryId,participantId,metricId,value,notes,entryDate,isBaseline,createdAt);

@override
String toString() {
  return 'TrackingEntry(entryId: $entryId, participantId: $participantId, metricId: $metricId, value: $value, notes: $notes, entryDate: $entryDate, isBaseline: $isBaseline, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TrackingEntryCopyWith<$Res>  {
  factory $TrackingEntryCopyWith(TrackingEntry value, $Res Function(TrackingEntry) _then) = _$TrackingEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'entry_id') int entryId,@JsonKey(name: 'participant_id') int participantId,@JsonKey(name: 'metric_id') int metricId, String value, String? notes,@JsonKey(name: 'entry_date') DateTime entryDate,@JsonKey(name: 'is_baseline') bool isBaseline,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$TrackingEntryCopyWithImpl<$Res>
    implements $TrackingEntryCopyWith<$Res> {
  _$TrackingEntryCopyWithImpl(this._self, this._then);

  final TrackingEntry _self;
  final $Res Function(TrackingEntry) _then;

/// Create a copy of TrackingEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entryId = null,Object? participantId = null,Object? metricId = null,Object? value = null,Object? notes = freezed,Object? entryDate = null,Object? isBaseline = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as int,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as int,metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,isBaseline: null == isBaseline ? _self.isBaseline : isBaseline // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackingEntry].
extension TrackingEntryPatterns on TrackingEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingEntry value)  $default,){
final _that = this;
switch (_that) {
case _TrackingEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'entry_id')  int entryId, @JsonKey(name: 'participant_id')  int participantId, @JsonKey(name: 'metric_id')  int metricId,  String value,  String? notes, @JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(name: 'is_baseline')  bool isBaseline, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingEntry() when $default != null:
return $default(_that.entryId,_that.participantId,_that.metricId,_that.value,_that.notes,_that.entryDate,_that.isBaseline,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'entry_id')  int entryId, @JsonKey(name: 'participant_id')  int participantId, @JsonKey(name: 'metric_id')  int metricId,  String value,  String? notes, @JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(name: 'is_baseline')  bool isBaseline, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TrackingEntry():
return $default(_that.entryId,_that.participantId,_that.metricId,_that.value,_that.notes,_that.entryDate,_that.isBaseline,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'entry_id')  int entryId, @JsonKey(name: 'participant_id')  int participantId, @JsonKey(name: 'metric_id')  int metricId,  String value,  String? notes, @JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(name: 'is_baseline')  bool isBaseline, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TrackingEntry() when $default != null:
return $default(_that.entryId,_that.participantId,_that.metricId,_that.value,_that.notes,_that.entryDate,_that.isBaseline,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TrackingEntry implements TrackingEntry {
  const _TrackingEntry({@JsonKey(name: 'entry_id') required this.entryId, @JsonKey(name: 'participant_id') required this.participantId, @JsonKey(name: 'metric_id') required this.metricId, required this.value, this.notes, @JsonKey(name: 'entry_date') required this.entryDate, @JsonKey(name: 'is_baseline') required this.isBaseline, @JsonKey(name: 'created_at') this.createdAt});
  factory _TrackingEntry.fromJson(Map<String, dynamic> json) => _$TrackingEntryFromJson(json);

@override@JsonKey(name: 'entry_id') final  int entryId;
@override@JsonKey(name: 'participant_id') final  int participantId;
@override@JsonKey(name: 'metric_id') final  int metricId;
@override final  String value;
@override final  String? notes;
@override@JsonKey(name: 'entry_date') final  DateTime entryDate;
@override@JsonKey(name: 'is_baseline') final  bool isBaseline;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of TrackingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingEntryCopyWith<_TrackingEntry> get copyWith => __$TrackingEntryCopyWithImpl<_TrackingEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackingEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingEntry&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.value, value) || other.value == value)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.isBaseline, isBaseline) || other.isBaseline == isBaseline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryId,participantId,metricId,value,notes,entryDate,isBaseline,createdAt);

@override
String toString() {
  return 'TrackingEntry(entryId: $entryId, participantId: $participantId, metricId: $metricId, value: $value, notes: $notes, entryDate: $entryDate, isBaseline: $isBaseline, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TrackingEntryCopyWith<$Res> implements $TrackingEntryCopyWith<$Res> {
  factory _$TrackingEntryCopyWith(_TrackingEntry value, $Res Function(_TrackingEntry) _then) = __$TrackingEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'entry_id') int entryId,@JsonKey(name: 'participant_id') int participantId,@JsonKey(name: 'metric_id') int metricId, String value, String? notes,@JsonKey(name: 'entry_date') DateTime entryDate,@JsonKey(name: 'is_baseline') bool isBaseline,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$TrackingEntryCopyWithImpl<$Res>
    implements _$TrackingEntryCopyWith<$Res> {
  __$TrackingEntryCopyWithImpl(this._self, this._then);

  final _TrackingEntry _self;
  final $Res Function(_TrackingEntry) _then;

/// Create a copy of TrackingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entryId = null,Object? participantId = null,Object? metricId = null,Object? value = null,Object? notes = freezed,Object? entryDate = null,Object? isBaseline = null,Object? createdAt = freezed,}) {
  return _then(_TrackingEntry(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as int,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as int,metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,isBaseline: null == isBaseline ? _self.isBaseline : isBaseline // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TrackingEntrySubmit {

@JsonKey(name: 'metric_id') int get metricId; String get value; String? get notes;// Serialised as 'yyyy-MM-dd' only — backend expects a date, not datetime.
@JsonKey(name: 'entry_date', toJson: healthTrackingDateToJson, fromJson: healthTrackingDateFromJson) DateTime get entryDate;
/// Create a copy of TrackingEntrySubmit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingEntrySubmitCopyWith<TrackingEntrySubmit> get copyWith => _$TrackingEntrySubmitCopyWithImpl<TrackingEntrySubmit>(this as TrackingEntrySubmit, _$identity);

  /// Serializes this TrackingEntrySubmit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingEntrySubmit&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.value, value) || other.value == value)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metricId,value,notes,entryDate);

@override
String toString() {
  return 'TrackingEntrySubmit(metricId: $metricId, value: $value, notes: $notes, entryDate: $entryDate)';
}


}

/// @nodoc
abstract mixin class $TrackingEntrySubmitCopyWith<$Res>  {
  factory $TrackingEntrySubmitCopyWith(TrackingEntrySubmit value, $Res Function(TrackingEntrySubmit) _then) = _$TrackingEntrySubmitCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'metric_id') int metricId, String value, String? notes,@JsonKey(name: 'entry_date', toJson: healthTrackingDateToJson, fromJson: healthTrackingDateFromJson) DateTime entryDate
});




}
/// @nodoc
class _$TrackingEntrySubmitCopyWithImpl<$Res>
    implements $TrackingEntrySubmitCopyWith<$Res> {
  _$TrackingEntrySubmitCopyWithImpl(this._self, this._then);

  final TrackingEntrySubmit _self;
  final $Res Function(TrackingEntrySubmit) _then;

/// Create a copy of TrackingEntrySubmit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metricId = null,Object? value = null,Object? notes = freezed,Object? entryDate = null,}) {
  return _then(_self.copyWith(
metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackingEntrySubmit].
extension TrackingEntrySubmitPatterns on TrackingEntrySubmit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingEntrySubmit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingEntrySubmit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingEntrySubmit value)  $default,){
final _that = this;
switch (_that) {
case _TrackingEntrySubmit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingEntrySubmit value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingEntrySubmit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'metric_id')  int metricId,  String value,  String? notes, @JsonKey(name: 'entry_date', toJson: healthTrackingDateToJson, fromJson: healthTrackingDateFromJson)  DateTime entryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingEntrySubmit() when $default != null:
return $default(_that.metricId,_that.value,_that.notes,_that.entryDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'metric_id')  int metricId,  String value,  String? notes, @JsonKey(name: 'entry_date', toJson: healthTrackingDateToJson, fromJson: healthTrackingDateFromJson)  DateTime entryDate)  $default,) {final _that = this;
switch (_that) {
case _TrackingEntrySubmit():
return $default(_that.metricId,_that.value,_that.notes,_that.entryDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'metric_id')  int metricId,  String value,  String? notes, @JsonKey(name: 'entry_date', toJson: healthTrackingDateToJson, fromJson: healthTrackingDateFromJson)  DateTime entryDate)?  $default,) {final _that = this;
switch (_that) {
case _TrackingEntrySubmit() when $default != null:
return $default(_that.metricId,_that.value,_that.notes,_that.entryDate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TrackingEntrySubmit implements TrackingEntrySubmit {
  const _TrackingEntrySubmit({@JsonKey(name: 'metric_id') required this.metricId, required this.value, this.notes, @JsonKey(name: 'entry_date', toJson: healthTrackingDateToJson, fromJson: healthTrackingDateFromJson) required this.entryDate});
  factory _TrackingEntrySubmit.fromJson(Map<String, dynamic> json) => _$TrackingEntrySubmitFromJson(json);

@override@JsonKey(name: 'metric_id') final  int metricId;
@override final  String value;
@override final  String? notes;
// Serialised as 'yyyy-MM-dd' only — backend expects a date, not datetime.
@override@JsonKey(name: 'entry_date', toJson: healthTrackingDateToJson, fromJson: healthTrackingDateFromJson) final  DateTime entryDate;

/// Create a copy of TrackingEntrySubmit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingEntrySubmitCopyWith<_TrackingEntrySubmit> get copyWith => __$TrackingEntrySubmitCopyWithImpl<_TrackingEntrySubmit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackingEntrySubmitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingEntrySubmit&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.value, value) || other.value == value)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metricId,value,notes,entryDate);

@override
String toString() {
  return 'TrackingEntrySubmit(metricId: $metricId, value: $value, notes: $notes, entryDate: $entryDate)';
}


}

/// @nodoc
abstract mixin class _$TrackingEntrySubmitCopyWith<$Res> implements $TrackingEntrySubmitCopyWith<$Res> {
  factory _$TrackingEntrySubmitCopyWith(_TrackingEntrySubmit value, $Res Function(_TrackingEntrySubmit) _then) = __$TrackingEntrySubmitCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'metric_id') int metricId, String value, String? notes,@JsonKey(name: 'entry_date', toJson: healthTrackingDateToJson, fromJson: healthTrackingDateFromJson) DateTime entryDate
});




}
/// @nodoc
class __$TrackingEntrySubmitCopyWithImpl<$Res>
    implements _$TrackingEntrySubmitCopyWith<$Res> {
  __$TrackingEntrySubmitCopyWithImpl(this._self, this._then);

  final _TrackingEntrySubmit _self;
  final $Res Function(_TrackingEntrySubmit) _then;

/// Create a copy of TrackingEntrySubmit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metricId = null,Object? value = null,Object? notes = freezed,Object? entryDate = null,}) {
  return _then(_TrackingEntrySubmit(
metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$HealthCheckInStatus {

@JsonKey(name: 'is_complete') bool get isComplete;@JsonKey(name: 'total_due') int get totalDue;@JsonKey(name: 'completed_count') int get completedCount;@JsonKey(name: 'has_any_due') bool get hasAnyDue;
/// Create a copy of HealthCheckInStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthCheckInStatusCopyWith<HealthCheckInStatus> get copyWith => _$HealthCheckInStatusCopyWithImpl<HealthCheckInStatus>(this as HealthCheckInStatus, _$identity);

  /// Serializes this HealthCheckInStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthCheckInStatus&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.totalDue, totalDue) || other.totalDue == totalDue)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.hasAnyDue, hasAnyDue) || other.hasAnyDue == hasAnyDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isComplete,totalDue,completedCount,hasAnyDue);

@override
String toString() {
  return 'HealthCheckInStatus(isComplete: $isComplete, totalDue: $totalDue, completedCount: $completedCount, hasAnyDue: $hasAnyDue)';
}


}

/// @nodoc
abstract mixin class $HealthCheckInStatusCopyWith<$Res>  {
  factory $HealthCheckInStatusCopyWith(HealthCheckInStatus value, $Res Function(HealthCheckInStatus) _then) = _$HealthCheckInStatusCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_complete') bool isComplete,@JsonKey(name: 'total_due') int totalDue,@JsonKey(name: 'completed_count') int completedCount,@JsonKey(name: 'has_any_due') bool hasAnyDue
});




}
/// @nodoc
class _$HealthCheckInStatusCopyWithImpl<$Res>
    implements $HealthCheckInStatusCopyWith<$Res> {
  _$HealthCheckInStatusCopyWithImpl(this._self, this._then);

  final HealthCheckInStatus _self;
  final $Res Function(HealthCheckInStatus) _then;

/// Create a copy of HealthCheckInStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isComplete = null,Object? totalDue = null,Object? completedCount = null,Object? hasAnyDue = null,}) {
  return _then(_self.copyWith(
isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,totalDue: null == totalDue ? _self.totalDue : totalDue // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,hasAnyDue: null == hasAnyDue ? _self.hasAnyDue : hasAnyDue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthCheckInStatus].
extension HealthCheckInStatusPatterns on HealthCheckInStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthCheckInStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthCheckInStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthCheckInStatus value)  $default,){
final _that = this;
switch (_that) {
case _HealthCheckInStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthCheckInStatus value)?  $default,){
final _that = this;
switch (_that) {
case _HealthCheckInStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_complete')  bool isComplete, @JsonKey(name: 'total_due')  int totalDue, @JsonKey(name: 'completed_count')  int completedCount, @JsonKey(name: 'has_any_due')  bool hasAnyDue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthCheckInStatus() when $default != null:
return $default(_that.isComplete,_that.totalDue,_that.completedCount,_that.hasAnyDue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_complete')  bool isComplete, @JsonKey(name: 'total_due')  int totalDue, @JsonKey(name: 'completed_count')  int completedCount, @JsonKey(name: 'has_any_due')  bool hasAnyDue)  $default,) {final _that = this;
switch (_that) {
case _HealthCheckInStatus():
return $default(_that.isComplete,_that.totalDue,_that.completedCount,_that.hasAnyDue);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_complete')  bool isComplete, @JsonKey(name: 'total_due')  int totalDue, @JsonKey(name: 'completed_count')  int completedCount, @JsonKey(name: 'has_any_due')  bool hasAnyDue)?  $default,) {final _that = this;
switch (_that) {
case _HealthCheckInStatus() when $default != null:
return $default(_that.isComplete,_that.totalDue,_that.completedCount,_that.hasAnyDue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthCheckInStatus implements HealthCheckInStatus {
  const _HealthCheckInStatus({@JsonKey(name: 'is_complete') required this.isComplete, @JsonKey(name: 'total_due') required this.totalDue, @JsonKey(name: 'completed_count') required this.completedCount, @JsonKey(name: 'has_any_due') required this.hasAnyDue});
  factory _HealthCheckInStatus.fromJson(Map<String, dynamic> json) => _$HealthCheckInStatusFromJson(json);

@override@JsonKey(name: 'is_complete') final  bool isComplete;
@override@JsonKey(name: 'total_due') final  int totalDue;
@override@JsonKey(name: 'completed_count') final  int completedCount;
@override@JsonKey(name: 'has_any_due') final  bool hasAnyDue;

/// Create a copy of HealthCheckInStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthCheckInStatusCopyWith<_HealthCheckInStatus> get copyWith => __$HealthCheckInStatusCopyWithImpl<_HealthCheckInStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthCheckInStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthCheckInStatus&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.totalDue, totalDue) || other.totalDue == totalDue)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.hasAnyDue, hasAnyDue) || other.hasAnyDue == hasAnyDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isComplete,totalDue,completedCount,hasAnyDue);

@override
String toString() {
  return 'HealthCheckInStatus(isComplete: $isComplete, totalDue: $totalDue, completedCount: $completedCount, hasAnyDue: $hasAnyDue)';
}


}

/// @nodoc
abstract mixin class _$HealthCheckInStatusCopyWith<$Res> implements $HealthCheckInStatusCopyWith<$Res> {
  factory _$HealthCheckInStatusCopyWith(_HealthCheckInStatus value, $Res Function(_HealthCheckInStatus) _then) = __$HealthCheckInStatusCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_complete') bool isComplete,@JsonKey(name: 'total_due') int totalDue,@JsonKey(name: 'completed_count') int completedCount,@JsonKey(name: 'has_any_due') bool hasAnyDue
});




}
/// @nodoc
class __$HealthCheckInStatusCopyWithImpl<$Res>
    implements _$HealthCheckInStatusCopyWith<$Res> {
  __$HealthCheckInStatusCopyWithImpl(this._self, this._then);

  final _HealthCheckInStatus _self;
  final $Res Function(_HealthCheckInStatus) _then;

/// Create a copy of HealthCheckInStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isComplete = null,Object? totalDue = null,Object? completedCount = null,Object? hasAnyDue = null,}) {
  return _then(_HealthCheckInStatus(
isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,totalDue: null == totalDue ? _self.totalDue : totalDue // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,hasAnyDue: null == hasAnyDue ? _self.hasAnyDue : hasAnyDue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BatchEntrySubmit {

 List<TrackingEntrySubmit> get entries;@JsonKey(name: 'is_baseline') bool get isBaseline;
/// Create a copy of BatchEntrySubmit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchEntrySubmitCopyWith<BatchEntrySubmit> get copyWith => _$BatchEntrySubmitCopyWithImpl<BatchEntrySubmit>(this as BatchEntrySubmit, _$identity);

  /// Serializes this BatchEntrySubmit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchEntrySubmit&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.isBaseline, isBaseline) || other.isBaseline == isBaseline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entries),isBaseline);

@override
String toString() {
  return 'BatchEntrySubmit(entries: $entries, isBaseline: $isBaseline)';
}


}

/// @nodoc
abstract mixin class $BatchEntrySubmitCopyWith<$Res>  {
  factory $BatchEntrySubmitCopyWith(BatchEntrySubmit value, $Res Function(BatchEntrySubmit) _then) = _$BatchEntrySubmitCopyWithImpl;
@useResult
$Res call({
 List<TrackingEntrySubmit> entries,@JsonKey(name: 'is_baseline') bool isBaseline
});




}
/// @nodoc
class _$BatchEntrySubmitCopyWithImpl<$Res>
    implements $BatchEntrySubmitCopyWith<$Res> {
  _$BatchEntrySubmitCopyWithImpl(this._self, this._then);

  final BatchEntrySubmit _self;
  final $Res Function(BatchEntrySubmit) _then;

/// Create a copy of BatchEntrySubmit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? isBaseline = null,}) {
  return _then(_self.copyWith(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<TrackingEntrySubmit>,isBaseline: null == isBaseline ? _self.isBaseline : isBaseline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BatchEntrySubmit].
extension BatchEntrySubmitPatterns on BatchEntrySubmit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchEntrySubmit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchEntrySubmit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchEntrySubmit value)  $default,){
final _that = this;
switch (_that) {
case _BatchEntrySubmit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchEntrySubmit value)?  $default,){
final _that = this;
switch (_that) {
case _BatchEntrySubmit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TrackingEntrySubmit> entries, @JsonKey(name: 'is_baseline')  bool isBaseline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchEntrySubmit() when $default != null:
return $default(_that.entries,_that.isBaseline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TrackingEntrySubmit> entries, @JsonKey(name: 'is_baseline')  bool isBaseline)  $default,) {final _that = this;
switch (_that) {
case _BatchEntrySubmit():
return $default(_that.entries,_that.isBaseline);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TrackingEntrySubmit> entries, @JsonKey(name: 'is_baseline')  bool isBaseline)?  $default,) {final _that = this;
switch (_that) {
case _BatchEntrySubmit() when $default != null:
return $default(_that.entries,_that.isBaseline);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BatchEntrySubmit implements BatchEntrySubmit {
  const _BatchEntrySubmit({required final  List<TrackingEntrySubmit> entries, @JsonKey(name: 'is_baseline') this.isBaseline = false}): _entries = entries;
  factory _BatchEntrySubmit.fromJson(Map<String, dynamic> json) => _$BatchEntrySubmitFromJson(json);

 final  List<TrackingEntrySubmit> _entries;
@override List<TrackingEntrySubmit> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey(name: 'is_baseline') final  bool isBaseline;

/// Create a copy of BatchEntrySubmit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchEntrySubmitCopyWith<_BatchEntrySubmit> get copyWith => __$BatchEntrySubmitCopyWithImpl<_BatchEntrySubmit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchEntrySubmitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchEntrySubmit&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.isBaseline, isBaseline) || other.isBaseline == isBaseline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),isBaseline);

@override
String toString() {
  return 'BatchEntrySubmit(entries: $entries, isBaseline: $isBaseline)';
}


}

/// @nodoc
abstract mixin class _$BatchEntrySubmitCopyWith<$Res> implements $BatchEntrySubmitCopyWith<$Res> {
  factory _$BatchEntrySubmitCopyWith(_BatchEntrySubmit value, $Res Function(_BatchEntrySubmit) _then) = __$BatchEntrySubmitCopyWithImpl;
@override @useResult
$Res call({
 List<TrackingEntrySubmit> entries,@JsonKey(name: 'is_baseline') bool isBaseline
});




}
/// @nodoc
class __$BatchEntrySubmitCopyWithImpl<$Res>
    implements _$BatchEntrySubmitCopyWith<$Res> {
  __$BatchEntrySubmitCopyWithImpl(this._self, this._then);

  final _BatchEntrySubmit _self;
  final $Res Function(_BatchEntrySubmit) _then;

/// Create a copy of BatchEntrySubmit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? isBaseline = null,}) {
  return _then(_BatchEntrySubmit(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<TrackingEntrySubmit>,isBaseline: null == isBaseline ? _self.isBaseline : isBaseline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AggregateDataPoint {

@JsonKey(name: 'entry_date') DateTime get entryDate;@JsonKey(name: 'avg_value') double get avgValue;@JsonKey(name: 'participant_count') int get participantCount;
/// Create a copy of AggregateDataPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AggregateDataPointCopyWith<AggregateDataPoint> get copyWith => _$AggregateDataPointCopyWithImpl<AggregateDataPoint>(this as AggregateDataPoint, _$identity);

  /// Serializes this AggregateDataPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AggregateDataPoint&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.avgValue, avgValue) || other.avgValue == avgValue)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryDate,avgValue,participantCount);

@override
String toString() {
  return 'AggregateDataPoint(entryDate: $entryDate, avgValue: $avgValue, participantCount: $participantCount)';
}


}

/// @nodoc
abstract mixin class $AggregateDataPointCopyWith<$Res>  {
  factory $AggregateDataPointCopyWith(AggregateDataPoint value, $Res Function(AggregateDataPoint) _then) = _$AggregateDataPointCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'entry_date') DateTime entryDate,@JsonKey(name: 'avg_value') double avgValue,@JsonKey(name: 'participant_count') int participantCount
});




}
/// @nodoc
class _$AggregateDataPointCopyWithImpl<$Res>
    implements $AggregateDataPointCopyWith<$Res> {
  _$AggregateDataPointCopyWithImpl(this._self, this._then);

  final AggregateDataPoint _self;
  final $Res Function(AggregateDataPoint) _then;

/// Create a copy of AggregateDataPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entryDate = null,Object? avgValue = null,Object? participantCount = null,}) {
  return _then(_self.copyWith(
entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,avgValue: null == avgValue ? _self.avgValue : avgValue // ignore: cast_nullable_to_non_nullable
as double,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AggregateDataPoint].
extension AggregateDataPointPatterns on AggregateDataPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AggregateDataPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AggregateDataPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AggregateDataPoint value)  $default,){
final _that = this;
switch (_that) {
case _AggregateDataPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AggregateDataPoint value)?  $default,){
final _that = this;
switch (_that) {
case _AggregateDataPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(name: 'avg_value')  double avgValue, @JsonKey(name: 'participant_count')  int participantCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AggregateDataPoint() when $default != null:
return $default(_that.entryDate,_that.avgValue,_that.participantCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(name: 'avg_value')  double avgValue, @JsonKey(name: 'participant_count')  int participantCount)  $default,) {final _that = this;
switch (_that) {
case _AggregateDataPoint():
return $default(_that.entryDate,_that.avgValue,_that.participantCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'entry_date')  DateTime entryDate, @JsonKey(name: 'avg_value')  double avgValue, @JsonKey(name: 'participant_count')  int participantCount)?  $default,) {final _that = this;
switch (_that) {
case _AggregateDataPoint() when $default != null:
return $default(_that.entryDate,_that.avgValue,_that.participantCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AggregateDataPoint implements AggregateDataPoint {
  const _AggregateDataPoint({@JsonKey(name: 'entry_date') required this.entryDate, @JsonKey(name: 'avg_value') required this.avgValue, @JsonKey(name: 'participant_count') required this.participantCount});
  factory _AggregateDataPoint.fromJson(Map<String, dynamic> json) => _$AggregateDataPointFromJson(json);

@override@JsonKey(name: 'entry_date') final  DateTime entryDate;
@override@JsonKey(name: 'avg_value') final  double avgValue;
@override@JsonKey(name: 'participant_count') final  int participantCount;

/// Create a copy of AggregateDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AggregateDataPointCopyWith<_AggregateDataPoint> get copyWith => __$AggregateDataPointCopyWithImpl<_AggregateDataPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AggregateDataPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AggregateDataPoint&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.avgValue, avgValue) || other.avgValue == avgValue)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryDate,avgValue,participantCount);

@override
String toString() {
  return 'AggregateDataPoint(entryDate: $entryDate, avgValue: $avgValue, participantCount: $participantCount)';
}


}

/// @nodoc
abstract mixin class _$AggregateDataPointCopyWith<$Res> implements $AggregateDataPointCopyWith<$Res> {
  factory _$AggregateDataPointCopyWith(_AggregateDataPoint value, $Res Function(_AggregateDataPoint) _then) = __$AggregateDataPointCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'entry_date') DateTime entryDate,@JsonKey(name: 'avg_value') double avgValue,@JsonKey(name: 'participant_count') int participantCount
});




}
/// @nodoc
class __$AggregateDataPointCopyWithImpl<$Res>
    implements _$AggregateDataPointCopyWith<$Res> {
  __$AggregateDataPointCopyWithImpl(this._self, this._then);

  final _AggregateDataPoint _self;
  final $Res Function(_AggregateDataPoint) _then;

/// Create a copy of AggregateDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entryDate = null,Object? avgValue = null,Object? participantCount = null,}) {
  return _then(_AggregateDataPoint(
entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,avgValue: null == avgValue ? _self.avgValue : avgValue // ignore: cast_nullable_to_non_nullable
as double,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CategoryOrderItem {

@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'display_order') int get displayOrder;
/// Create a copy of CategoryOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryOrderItemCopyWith<CategoryOrderItem> get copyWith => _$CategoryOrderItemCopyWithImpl<CategoryOrderItem>(this as CategoryOrderItem, _$identity);

  /// Serializes this CategoryOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryOrderItem&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,displayOrder);

@override
String toString() {
  return 'CategoryOrderItem(categoryId: $categoryId, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $CategoryOrderItemCopyWith<$Res>  {
  factory $CategoryOrderItemCopyWith(CategoryOrderItem value, $Res Function(CategoryOrderItem) _then) = _$CategoryOrderItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'display_order') int displayOrder
});




}
/// @nodoc
class _$CategoryOrderItemCopyWithImpl<$Res>
    implements $CategoryOrderItemCopyWith<$Res> {
  _$CategoryOrderItemCopyWithImpl(this._self, this._then);

  final CategoryOrderItem _self;
  final $Res Function(CategoryOrderItem) _then;

/// Create a copy of CategoryOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? displayOrder = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryOrderItem].
extension CategoryOrderItemPatterns on CategoryOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _CategoryOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'display_order')  int displayOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryOrderItem() when $default != null:
return $default(_that.categoryId,_that.displayOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'display_order')  int displayOrder)  $default,) {final _that = this;
switch (_that) {
case _CategoryOrderItem():
return $default(_that.categoryId,_that.displayOrder);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'display_order')  int displayOrder)?  $default,) {final _that = this;
switch (_that) {
case _CategoryOrderItem() when $default != null:
return $default(_that.categoryId,_that.displayOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryOrderItem implements CategoryOrderItem {
  const _CategoryOrderItem({@JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'display_order') required this.displayOrder});
  factory _CategoryOrderItem.fromJson(Map<String, dynamic> json) => _$CategoryOrderItemFromJson(json);

@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'display_order') final  int displayOrder;

/// Create a copy of CategoryOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryOrderItemCopyWith<_CategoryOrderItem> get copyWith => __$CategoryOrderItemCopyWithImpl<_CategoryOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryOrderItem&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,displayOrder);

@override
String toString() {
  return 'CategoryOrderItem(categoryId: $categoryId, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class _$CategoryOrderItemCopyWith<$Res> implements $CategoryOrderItemCopyWith<$Res> {
  factory _$CategoryOrderItemCopyWith(_CategoryOrderItem value, $Res Function(_CategoryOrderItem) _then) = __$CategoryOrderItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'display_order') int displayOrder
});




}
/// @nodoc
class __$CategoryOrderItemCopyWithImpl<$Res>
    implements _$CategoryOrderItemCopyWith<$Res> {
  __$CategoryOrderItemCopyWithImpl(this._self, this._then);

  final _CategoryOrderItem _self;
  final $Res Function(_CategoryOrderItem) _then;

/// Create a copy of CategoryOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? displayOrder = null,}) {
  return _then(_CategoryOrderItem(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MetricOrderItem {

@JsonKey(name: 'metric_id') int get metricId;@JsonKey(name: 'display_order') int get displayOrder;
/// Create a copy of MetricOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetricOrderItemCopyWith<MetricOrderItem> get copyWith => _$MetricOrderItemCopyWithImpl<MetricOrderItem>(this as MetricOrderItem, _$identity);

  /// Serializes this MetricOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetricOrderItem&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metricId,displayOrder);

@override
String toString() {
  return 'MetricOrderItem(metricId: $metricId, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $MetricOrderItemCopyWith<$Res>  {
  factory $MetricOrderItemCopyWith(MetricOrderItem value, $Res Function(MetricOrderItem) _then) = _$MetricOrderItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'metric_id') int metricId,@JsonKey(name: 'display_order') int displayOrder
});




}
/// @nodoc
class _$MetricOrderItemCopyWithImpl<$Res>
    implements $MetricOrderItemCopyWith<$Res> {
  _$MetricOrderItemCopyWithImpl(this._self, this._then);

  final MetricOrderItem _self;
  final $Res Function(MetricOrderItem) _then;

/// Create a copy of MetricOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metricId = null,Object? displayOrder = null,}) {
  return _then(_self.copyWith(
metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MetricOrderItem].
extension MetricOrderItemPatterns on MetricOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetricOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetricOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetricOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _MetricOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetricOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _MetricOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'metric_id')  int metricId, @JsonKey(name: 'display_order')  int displayOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MetricOrderItem() when $default != null:
return $default(_that.metricId,_that.displayOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'metric_id')  int metricId, @JsonKey(name: 'display_order')  int displayOrder)  $default,) {final _that = this;
switch (_that) {
case _MetricOrderItem():
return $default(_that.metricId,_that.displayOrder);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'metric_id')  int metricId, @JsonKey(name: 'display_order')  int displayOrder)?  $default,) {final _that = this;
switch (_that) {
case _MetricOrderItem() when $default != null:
return $default(_that.metricId,_that.displayOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetricOrderItem implements MetricOrderItem {
  const _MetricOrderItem({@JsonKey(name: 'metric_id') required this.metricId, @JsonKey(name: 'display_order') required this.displayOrder});
  factory _MetricOrderItem.fromJson(Map<String, dynamic> json) => _$MetricOrderItemFromJson(json);

@override@JsonKey(name: 'metric_id') final  int metricId;
@override@JsonKey(name: 'display_order') final  int displayOrder;

/// Create a copy of MetricOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetricOrderItemCopyWith<_MetricOrderItem> get copyWith => __$MetricOrderItemCopyWithImpl<_MetricOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetricOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetricOrderItem&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metricId,displayOrder);

@override
String toString() {
  return 'MetricOrderItem(metricId: $metricId, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class _$MetricOrderItemCopyWith<$Res> implements $MetricOrderItemCopyWith<$Res> {
  factory _$MetricOrderItemCopyWith(_MetricOrderItem value, $Res Function(_MetricOrderItem) _then) = __$MetricOrderItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'metric_id') int metricId,@JsonKey(name: 'display_order') int displayOrder
});




}
/// @nodoc
class __$MetricOrderItemCopyWithImpl<$Res>
    implements _$MetricOrderItemCopyWith<$Res> {
  __$MetricOrderItemCopyWithImpl(this._self, this._then);

  final _MetricOrderItem _self;
  final $Res Function(_MetricOrderItem) _then;

/// Create a copy of MetricOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metricId = null,Object? displayOrder = null,}) {
  return _then(_MetricOrderItem(
metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EntryDateRange {

@JsonKey(name: 'min_date') String? get minDate;@JsonKey(name: 'max_date') String? get maxDate;
/// Create a copy of EntryDateRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntryDateRangeCopyWith<EntryDateRange> get copyWith => _$EntryDateRangeCopyWithImpl<EntryDateRange>(this as EntryDateRange, _$identity);

  /// Serializes this EntryDateRange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryDateRange&&(identical(other.minDate, minDate) || other.minDate == minDate)&&(identical(other.maxDate, maxDate) || other.maxDate == maxDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minDate,maxDate);

@override
String toString() {
  return 'EntryDateRange(minDate: $minDate, maxDate: $maxDate)';
}


}

/// @nodoc
abstract mixin class $EntryDateRangeCopyWith<$Res>  {
  factory $EntryDateRangeCopyWith(EntryDateRange value, $Res Function(EntryDateRange) _then) = _$EntryDateRangeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'min_date') String? minDate,@JsonKey(name: 'max_date') String? maxDate
});




}
/// @nodoc
class _$EntryDateRangeCopyWithImpl<$Res>
    implements $EntryDateRangeCopyWith<$Res> {
  _$EntryDateRangeCopyWithImpl(this._self, this._then);

  final EntryDateRange _self;
  final $Res Function(EntryDateRange) _then;

/// Create a copy of EntryDateRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minDate = freezed,Object? maxDate = freezed,}) {
  return _then(_self.copyWith(
minDate: freezed == minDate ? _self.minDate : minDate // ignore: cast_nullable_to_non_nullable
as String?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EntryDateRange].
extension EntryDateRangePatterns on EntryDateRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntryDateRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntryDateRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntryDateRange value)  $default,){
final _that = this;
switch (_that) {
case _EntryDateRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntryDateRange value)?  $default,){
final _that = this;
switch (_that) {
case _EntryDateRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'min_date')  String? minDate, @JsonKey(name: 'max_date')  String? maxDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntryDateRange() when $default != null:
return $default(_that.minDate,_that.maxDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'min_date')  String? minDate, @JsonKey(name: 'max_date')  String? maxDate)  $default,) {final _that = this;
switch (_that) {
case _EntryDateRange():
return $default(_that.minDate,_that.maxDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'min_date')  String? minDate, @JsonKey(name: 'max_date')  String? maxDate)?  $default,) {final _that = this;
switch (_that) {
case _EntryDateRange() when $default != null:
return $default(_that.minDate,_that.maxDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntryDateRange implements EntryDateRange {
  const _EntryDateRange({@JsonKey(name: 'min_date') this.minDate, @JsonKey(name: 'max_date') this.maxDate});
  factory _EntryDateRange.fromJson(Map<String, dynamic> json) => _$EntryDateRangeFromJson(json);

@override@JsonKey(name: 'min_date') final  String? minDate;
@override@JsonKey(name: 'max_date') final  String? maxDate;

/// Create a copy of EntryDateRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntryDateRangeCopyWith<_EntryDateRange> get copyWith => __$EntryDateRangeCopyWithImpl<_EntryDateRange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntryDateRangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntryDateRange&&(identical(other.minDate, minDate) || other.minDate == minDate)&&(identical(other.maxDate, maxDate) || other.maxDate == maxDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minDate,maxDate);

@override
String toString() {
  return 'EntryDateRange(minDate: $minDate, maxDate: $maxDate)';
}


}

/// @nodoc
abstract mixin class _$EntryDateRangeCopyWith<$Res> implements $EntryDateRangeCopyWith<$Res> {
  factory _$EntryDateRangeCopyWith(_EntryDateRange value, $Res Function(_EntryDateRange) _then) = __$EntryDateRangeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'min_date') String? minDate,@JsonKey(name: 'max_date') String? maxDate
});




}
/// @nodoc
class __$EntryDateRangeCopyWithImpl<$Res>
    implements _$EntryDateRangeCopyWith<$Res> {
  __$EntryDateRangeCopyWithImpl(this._self, this._then);

  final _EntryDateRange _self;
  final $Res Function(_EntryDateRange) _then;

/// Create a copy of EntryDateRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minDate = freezed,Object? maxDate = freezed,}) {
  return _then(_EntryDateRange(
minDate: freezed == minDate ? _self.minDate : minDate // ignore: cast_nullable_to_non_nullable
as String?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MultiAggregateResult {

@JsonKey(name: 'metric_id') int get metricId;@JsonKey(name: 'metric_name') String get metricName;@JsonKey(name: 'category_name') String get categoryName; List<AggregateDataPoint> get data;
/// Create a copy of MultiAggregateResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultiAggregateResultCopyWith<MultiAggregateResult> get copyWith => _$MultiAggregateResultCopyWithImpl<MultiAggregateResult>(this as MultiAggregateResult, _$identity);

  /// Serializes this MultiAggregateResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultiAggregateResult&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.metricName, metricName) || other.metricName == metricName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metricId,metricName,categoryName,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'MultiAggregateResult(metricId: $metricId, metricName: $metricName, categoryName: $categoryName, data: $data)';
}


}

/// @nodoc
abstract mixin class $MultiAggregateResultCopyWith<$Res>  {
  factory $MultiAggregateResultCopyWith(MultiAggregateResult value, $Res Function(MultiAggregateResult) _then) = _$MultiAggregateResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'metric_id') int metricId,@JsonKey(name: 'metric_name') String metricName,@JsonKey(name: 'category_name') String categoryName, List<AggregateDataPoint> data
});




}
/// @nodoc
class _$MultiAggregateResultCopyWithImpl<$Res>
    implements $MultiAggregateResultCopyWith<$Res> {
  _$MultiAggregateResultCopyWithImpl(this._self, this._then);

  final MultiAggregateResult _self;
  final $Res Function(MultiAggregateResult) _then;

/// Create a copy of MultiAggregateResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metricId = null,Object? metricName = null,Object? categoryName = null,Object? data = null,}) {
  return _then(_self.copyWith(
metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,metricName: null == metricName ? _self.metricName : metricName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<AggregateDataPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [MultiAggregateResult].
extension MultiAggregateResultPatterns on MultiAggregateResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MultiAggregateResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MultiAggregateResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MultiAggregateResult value)  $default,){
final _that = this;
switch (_that) {
case _MultiAggregateResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MultiAggregateResult value)?  $default,){
final _that = this;
switch (_that) {
case _MultiAggregateResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'metric_id')  int metricId, @JsonKey(name: 'metric_name')  String metricName, @JsonKey(name: 'category_name')  String categoryName,  List<AggregateDataPoint> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MultiAggregateResult() when $default != null:
return $default(_that.metricId,_that.metricName,_that.categoryName,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'metric_id')  int metricId, @JsonKey(name: 'metric_name')  String metricName, @JsonKey(name: 'category_name')  String categoryName,  List<AggregateDataPoint> data)  $default,) {final _that = this;
switch (_that) {
case _MultiAggregateResult():
return $default(_that.metricId,_that.metricName,_that.categoryName,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'metric_id')  int metricId, @JsonKey(name: 'metric_name')  String metricName, @JsonKey(name: 'category_name')  String categoryName,  List<AggregateDataPoint> data)?  $default,) {final _that = this;
switch (_that) {
case _MultiAggregateResult() when $default != null:
return $default(_that.metricId,_that.metricName,_that.categoryName,_that.data);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MultiAggregateResult implements MultiAggregateResult {
  const _MultiAggregateResult({@JsonKey(name: 'metric_id') required this.metricId, @JsonKey(name: 'metric_name') required this.metricName, @JsonKey(name: 'category_name') required this.categoryName, final  List<AggregateDataPoint> data = const <AggregateDataPoint>[]}): _data = data;
  factory _MultiAggregateResult.fromJson(Map<String, dynamic> json) => _$MultiAggregateResultFromJson(json);

@override@JsonKey(name: 'metric_id') final  int metricId;
@override@JsonKey(name: 'metric_name') final  String metricName;
@override@JsonKey(name: 'category_name') final  String categoryName;
 final  List<AggregateDataPoint> _data;
@override@JsonKey() List<AggregateDataPoint> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of MultiAggregateResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MultiAggregateResultCopyWith<_MultiAggregateResult> get copyWith => __$MultiAggregateResultCopyWithImpl<_MultiAggregateResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MultiAggregateResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MultiAggregateResult&&(identical(other.metricId, metricId) || other.metricId == metricId)&&(identical(other.metricName, metricName) || other.metricName == metricName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metricId,metricName,categoryName,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'MultiAggregateResult(metricId: $metricId, metricName: $metricName, categoryName: $categoryName, data: $data)';
}


}

/// @nodoc
abstract mixin class _$MultiAggregateResultCopyWith<$Res> implements $MultiAggregateResultCopyWith<$Res> {
  factory _$MultiAggregateResultCopyWith(_MultiAggregateResult value, $Res Function(_MultiAggregateResult) _then) = __$MultiAggregateResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'metric_id') int metricId,@JsonKey(name: 'metric_name') String metricName,@JsonKey(name: 'category_name') String categoryName, List<AggregateDataPoint> data
});




}
/// @nodoc
class __$MultiAggregateResultCopyWithImpl<$Res>
    implements _$MultiAggregateResultCopyWith<$Res> {
  __$MultiAggregateResultCopyWithImpl(this._self, this._then);

  final _MultiAggregateResult _self;
  final $Res Function(_MultiAggregateResult) _then;

/// Create a copy of MultiAggregateResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metricId = null,Object? metricName = null,Object? categoryName = null,Object? data = null,}) {
  return _then(_MultiAggregateResult(
metricId: null == metricId ? _self.metricId : metricId // ignore: cast_nullable_to_non_nullable
as int,metricName: null == metricName ? _self.metricName : metricName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<AggregateDataPoint>,
  ));
}


}


/// @nodoc
mixin _$TrackingCategoryStats {

@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'category_key') String get categoryKey;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'participant_count') int get participantCount;@JsonKey(name: 'total_entries') int get totalEntries;@JsonKey(name: 'last_entry_date') DateTime? get lastEntryDate;
/// Create a copy of TrackingCategoryStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingCategoryStatsCopyWith<TrackingCategoryStats> get copyWith => _$TrackingCategoryStatsCopyWithImpl<TrackingCategoryStats>(this as TrackingCategoryStats, _$identity);

  /// Serializes this TrackingCategoryStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingCategoryStats&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.totalEntries, totalEntries) || other.totalEntries == totalEntries)&&(identical(other.lastEntryDate, lastEntryDate) || other.lastEntryDate == lastEntryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryKey,displayName,participantCount,totalEntries,lastEntryDate);

@override
String toString() {
  return 'TrackingCategoryStats(categoryId: $categoryId, categoryKey: $categoryKey, displayName: $displayName, participantCount: $participantCount, totalEntries: $totalEntries, lastEntryDate: $lastEntryDate)';
}


}

/// @nodoc
abstract mixin class $TrackingCategoryStatsCopyWith<$Res>  {
  factory $TrackingCategoryStatsCopyWith(TrackingCategoryStats value, $Res Function(TrackingCategoryStats) _then) = _$TrackingCategoryStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_key') String categoryKey,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'participant_count') int participantCount,@JsonKey(name: 'total_entries') int totalEntries,@JsonKey(name: 'last_entry_date') DateTime? lastEntryDate
});




}
/// @nodoc
class _$TrackingCategoryStatsCopyWithImpl<$Res>
    implements $TrackingCategoryStatsCopyWith<$Res> {
  _$TrackingCategoryStatsCopyWithImpl(this._self, this._then);

  final TrackingCategoryStats _self;
  final $Res Function(TrackingCategoryStats) _then;

/// Create a copy of TrackingCategoryStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryKey = null,Object? displayName = null,Object? participantCount = null,Object? totalEntries = null,Object? lastEntryDate = freezed,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,totalEntries: null == totalEntries ? _self.totalEntries : totalEntries // ignore: cast_nullable_to_non_nullable
as int,lastEntryDate: freezed == lastEntryDate ? _self.lastEntryDate : lastEntryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackingCategoryStats].
extension TrackingCategoryStatsPatterns on TrackingCategoryStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingCategoryStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingCategoryStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingCategoryStats value)  $default,){
final _that = this;
switch (_that) {
case _TrackingCategoryStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingCategoryStats value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingCategoryStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_key')  String categoryKey, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'participant_count')  int participantCount, @JsonKey(name: 'total_entries')  int totalEntries, @JsonKey(name: 'last_entry_date')  DateTime? lastEntryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingCategoryStats() when $default != null:
return $default(_that.categoryId,_that.categoryKey,_that.displayName,_that.participantCount,_that.totalEntries,_that.lastEntryDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_key')  String categoryKey, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'participant_count')  int participantCount, @JsonKey(name: 'total_entries')  int totalEntries, @JsonKey(name: 'last_entry_date')  DateTime? lastEntryDate)  $default,) {final _that = this;
switch (_that) {
case _TrackingCategoryStats():
return $default(_that.categoryId,_that.categoryKey,_that.displayName,_that.participantCount,_that.totalEntries,_that.lastEntryDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_key')  String categoryKey, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'participant_count')  int participantCount, @JsonKey(name: 'total_entries')  int totalEntries, @JsonKey(name: 'last_entry_date')  DateTime? lastEntryDate)?  $default,) {final _that = this;
switch (_that) {
case _TrackingCategoryStats() when $default != null:
return $default(_that.categoryId,_that.categoryKey,_that.displayName,_that.participantCount,_that.totalEntries,_that.lastEntryDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackingCategoryStats implements TrackingCategoryStats {
  const _TrackingCategoryStats({@JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'category_key') required this.categoryKey, @JsonKey(name: 'display_name') required this.displayName, @JsonKey(name: 'participant_count') required this.participantCount, @JsonKey(name: 'total_entries') required this.totalEntries, @JsonKey(name: 'last_entry_date') this.lastEntryDate});
  factory _TrackingCategoryStats.fromJson(Map<String, dynamic> json) => _$TrackingCategoryStatsFromJson(json);

@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'category_key') final  String categoryKey;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'participant_count') final  int participantCount;
@override@JsonKey(name: 'total_entries') final  int totalEntries;
@override@JsonKey(name: 'last_entry_date') final  DateTime? lastEntryDate;

/// Create a copy of TrackingCategoryStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingCategoryStatsCopyWith<_TrackingCategoryStats> get copyWith => __$TrackingCategoryStatsCopyWithImpl<_TrackingCategoryStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackingCategoryStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingCategoryStats&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.totalEntries, totalEntries) || other.totalEntries == totalEntries)&&(identical(other.lastEntryDate, lastEntryDate) || other.lastEntryDate == lastEntryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryKey,displayName,participantCount,totalEntries,lastEntryDate);

@override
String toString() {
  return 'TrackingCategoryStats(categoryId: $categoryId, categoryKey: $categoryKey, displayName: $displayName, participantCount: $participantCount, totalEntries: $totalEntries, lastEntryDate: $lastEntryDate)';
}


}

/// @nodoc
abstract mixin class _$TrackingCategoryStatsCopyWith<$Res> implements $TrackingCategoryStatsCopyWith<$Res> {
  factory _$TrackingCategoryStatsCopyWith(_TrackingCategoryStats value, $Res Function(_TrackingCategoryStats) _then) = __$TrackingCategoryStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_key') String categoryKey,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'participant_count') int participantCount,@JsonKey(name: 'total_entries') int totalEntries,@JsonKey(name: 'last_entry_date') DateTime? lastEntryDate
});




}
/// @nodoc
class __$TrackingCategoryStatsCopyWithImpl<$Res>
    implements _$TrackingCategoryStatsCopyWith<$Res> {
  __$TrackingCategoryStatsCopyWithImpl(this._self, this._then);

  final _TrackingCategoryStats _self;
  final $Res Function(_TrackingCategoryStats) _then;

/// Create a copy of TrackingCategoryStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryKey = null,Object? displayName = null,Object? participantCount = null,Object? totalEntries = null,Object? lastEntryDate = freezed,}) {
  return _then(_TrackingCategoryStats(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,totalEntries: null == totalEntries ? _self.totalEntries : totalEntries // ignore: cast_nullable_to_non_nullable
as int,lastEntryDate: freezed == lastEntryDate ? _self.lastEntryDate : lastEntryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
