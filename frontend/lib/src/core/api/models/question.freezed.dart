// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionOptionCreate {

@JsonKey(name: 'option_text') String get optionText;@JsonKey(name: 'display_order') int? get displayOrder;
/// Create a copy of QuestionOptionCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionOptionCreateCopyWith<QuestionOptionCreate> get copyWith => _$QuestionOptionCreateCopyWithImpl<QuestionOptionCreate>(this as QuestionOptionCreate, _$identity);

  /// Serializes this QuestionOptionCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionOptionCreate&&(identical(other.optionText, optionText) || other.optionText == optionText)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,optionText,displayOrder);

@override
String toString() {
  return 'QuestionOptionCreate(optionText: $optionText, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $QuestionOptionCreateCopyWith<$Res>  {
  factory $QuestionOptionCreateCopyWith(QuestionOptionCreate value, $Res Function(QuestionOptionCreate) _then) = _$QuestionOptionCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'option_text') String optionText,@JsonKey(name: 'display_order') int? displayOrder
});




}
/// @nodoc
class _$QuestionOptionCreateCopyWithImpl<$Res>
    implements $QuestionOptionCreateCopyWith<$Res> {
  _$QuestionOptionCreateCopyWithImpl(this._self, this._then);

  final QuestionOptionCreate _self;
  final $Res Function(QuestionOptionCreate) _then;

/// Create a copy of QuestionOptionCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? optionText = null,Object? displayOrder = freezed,}) {
  return _then(_self.copyWith(
optionText: null == optionText ? _self.optionText : optionText // ignore: cast_nullable_to_non_nullable
as String,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionOptionCreate].
extension QuestionOptionCreatePatterns on QuestionOptionCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionOptionCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionOptionCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionOptionCreate value)  $default,){
final _that = this;
switch (_that) {
case _QuestionOptionCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionOptionCreate value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionOptionCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'option_text')  String optionText, @JsonKey(name: 'display_order')  int? displayOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionOptionCreate() when $default != null:
return $default(_that.optionText,_that.displayOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'option_text')  String optionText, @JsonKey(name: 'display_order')  int? displayOrder)  $default,) {final _that = this;
switch (_that) {
case _QuestionOptionCreate():
return $default(_that.optionText,_that.displayOrder);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'option_text')  String optionText, @JsonKey(name: 'display_order')  int? displayOrder)?  $default,) {final _that = this;
switch (_that) {
case _QuestionOptionCreate() when $default != null:
return $default(_that.optionText,_that.displayOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionOptionCreate implements QuestionOptionCreate {
  const _QuestionOptionCreate({@JsonKey(name: 'option_text') required this.optionText, @JsonKey(name: 'display_order') this.displayOrder});
  factory _QuestionOptionCreate.fromJson(Map<String, dynamic> json) => _$QuestionOptionCreateFromJson(json);

@override@JsonKey(name: 'option_text') final  String optionText;
@override@JsonKey(name: 'display_order') final  int? displayOrder;

/// Create a copy of QuestionOptionCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionOptionCreateCopyWith<_QuestionOptionCreate> get copyWith => __$QuestionOptionCreateCopyWithImpl<_QuestionOptionCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionOptionCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionOptionCreate&&(identical(other.optionText, optionText) || other.optionText == optionText)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,optionText,displayOrder);

@override
String toString() {
  return 'QuestionOptionCreate(optionText: $optionText, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class _$QuestionOptionCreateCopyWith<$Res> implements $QuestionOptionCreateCopyWith<$Res> {
  factory _$QuestionOptionCreateCopyWith(_QuestionOptionCreate value, $Res Function(_QuestionOptionCreate) _then) = __$QuestionOptionCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'option_text') String optionText,@JsonKey(name: 'display_order') int? displayOrder
});




}
/// @nodoc
class __$QuestionOptionCreateCopyWithImpl<$Res>
    implements _$QuestionOptionCreateCopyWith<$Res> {
  __$QuestionOptionCreateCopyWithImpl(this._self, this._then);

  final _QuestionOptionCreate _self;
  final $Res Function(_QuestionOptionCreate) _then;

/// Create a copy of QuestionOptionCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? optionText = null,Object? displayOrder = freezed,}) {
  return _then(_QuestionOptionCreate(
optionText: null == optionText ? _self.optionText : optionText // ignore: cast_nullable_to_non_nullable
as String,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$QuestionCreate {

 String? get title;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType;@JsonKey(name: 'is_required') bool get isRequired; String? get category; List<QuestionOptionCreate>? get options;@JsonKey(name: 'scale_min') int? get scaleMin;@JsonKey(name: 'scale_max') int? get scaleMax;
/// Create a copy of QuestionCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCreateCopyWith<QuestionCreate> get copyWith => _$QuestionCreateCopyWithImpl<QuestionCreate>(this as QuestionCreate, _$identity);

  /// Serializes this QuestionCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,questionContent,responseType,isRequired,category,const DeepCollectionEquality().hash(options),scaleMin,scaleMax);

@override
String toString() {
  return 'QuestionCreate(title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, options: $options, scaleMin: $scaleMin, scaleMax: $scaleMax)';
}


}

/// @nodoc
abstract mixin class $QuestionCreateCopyWith<$Res>  {
  factory $QuestionCreateCopyWith(QuestionCreate value, $Res Function(QuestionCreate) _then) = _$QuestionCreateCopyWithImpl;
@useResult
$Res call({
 String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category, List<QuestionOptionCreate>? options,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax
});




}
/// @nodoc
class _$QuestionCreateCopyWithImpl<$Res>
    implements $QuestionCreateCopyWith<$Res> {
  _$QuestionCreateCopyWithImpl(this._self, this._then);

  final QuestionCreate _self;
  final $Res Function(QuestionCreate) _then;

/// Create a copy of QuestionCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? options = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOptionCreate>?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionCreate].
extension QuestionCreatePatterns on QuestionCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionCreate value)  $default,){
final _that = this;
switch (_that) {
case _QuestionCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionCreate value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category,  List<QuestionOptionCreate>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionCreate() when $default != null:
return $default(_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.options,_that.scaleMin,_that.scaleMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category,  List<QuestionOptionCreate>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax)  $default,) {final _that = this;
switch (_that) {
case _QuestionCreate():
return $default(_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.options,_that.scaleMin,_that.scaleMax);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category,  List<QuestionOptionCreate>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax)?  $default,) {final _that = this;
switch (_that) {
case _QuestionCreate() when $default != null:
return $default(_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.options,_that.scaleMin,_that.scaleMax);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionCreate implements QuestionCreate {
  const _QuestionCreate({this.title, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, @JsonKey(name: 'is_required') this.isRequired = false, this.category, final  List<QuestionOptionCreate>? options, @JsonKey(name: 'scale_min') this.scaleMin, @JsonKey(name: 'scale_max') this.scaleMax}): _options = options;
  factory _QuestionCreate.fromJson(Map<String, dynamic> json) => _$QuestionCreateFromJson(json);

@override final  String? title;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override@JsonKey(name: 'is_required') final  bool isRequired;
@override final  String? category;
 final  List<QuestionOptionCreate>? _options;
@override List<QuestionOptionCreate>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'scale_min') final  int? scaleMin;
@override@JsonKey(name: 'scale_max') final  int? scaleMax;

/// Create a copy of QuestionCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCreateCopyWith<_QuestionCreate> get copyWith => __$QuestionCreateCopyWithImpl<_QuestionCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,questionContent,responseType,isRequired,category,const DeepCollectionEquality().hash(_options),scaleMin,scaleMax);

@override
String toString() {
  return 'QuestionCreate(title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, options: $options, scaleMin: $scaleMin, scaleMax: $scaleMax)';
}


}

/// @nodoc
abstract mixin class _$QuestionCreateCopyWith<$Res> implements $QuestionCreateCopyWith<$Res> {
  factory _$QuestionCreateCopyWith(_QuestionCreate value, $Res Function(_QuestionCreate) _then) = __$QuestionCreateCopyWithImpl;
@override @useResult
$Res call({
 String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category, List<QuestionOptionCreate>? options,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax
});




}
/// @nodoc
class __$QuestionCreateCopyWithImpl<$Res>
    implements _$QuestionCreateCopyWith<$Res> {
  __$QuestionCreateCopyWithImpl(this._self, this._then);

  final _QuestionCreate _self;
  final $Res Function(_QuestionCreate) _then;

/// Create a copy of QuestionCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? options = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,}) {
  return _then(_QuestionCreate(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOptionCreate>?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$QuestionUpdate {

 String? get title;@JsonKey(name: 'question_content') String? get questionContent;@JsonKey(name: 'response_type') String? get responseType;@JsonKey(name: 'is_required') bool? get isRequired; String? get category;@JsonKey(name: 'is_active') bool? get isActive; List<QuestionOptionCreate>? get options;@JsonKey(name: 'scale_min') int? get scaleMin;@JsonKey(name: 'scale_max') int? get scaleMax;
/// Create a copy of QuestionUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionUpdateCopyWith<QuestionUpdate> get copyWith => _$QuestionUpdateCopyWithImpl<QuestionUpdate>(this as QuestionUpdate, _$identity);

  /// Serializes this QuestionUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionUpdate&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,questionContent,responseType,isRequired,category,isActive,const DeepCollectionEquality().hash(options),scaleMin,scaleMax);

@override
String toString() {
  return 'QuestionUpdate(title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, isActive: $isActive, options: $options, scaleMin: $scaleMin, scaleMax: $scaleMax)';
}


}

/// @nodoc
abstract mixin class $QuestionUpdateCopyWith<$Res>  {
  factory $QuestionUpdateCopyWith(QuestionUpdate value, $Res Function(QuestionUpdate) _then) = _$QuestionUpdateCopyWithImpl;
@useResult
$Res call({
 String? title,@JsonKey(name: 'question_content') String? questionContent,@JsonKey(name: 'response_type') String? responseType,@JsonKey(name: 'is_required') bool? isRequired, String? category,@JsonKey(name: 'is_active') bool? isActive, List<QuestionOptionCreate>? options,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax
});




}
/// @nodoc
class _$QuestionUpdateCopyWithImpl<$Res>
    implements $QuestionUpdateCopyWith<$Res> {
  _$QuestionUpdateCopyWithImpl(this._self, this._then);

  final QuestionUpdate _self;
  final $Res Function(QuestionUpdate) _then;

/// Create a copy of QuestionUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? questionContent = freezed,Object? responseType = freezed,Object? isRequired = freezed,Object? category = freezed,Object? isActive = freezed,Object? options = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: freezed == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String?,responseType: freezed == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOptionCreate>?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionUpdate].
extension QuestionUpdatePatterns on QuestionUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionUpdate value)  $default,){
final _that = this;
switch (_that) {
case _QuestionUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'question_content')  String? questionContent, @JsonKey(name: 'response_type')  String? responseType, @JsonKey(name: 'is_required')  bool? isRequired,  String? category, @JsonKey(name: 'is_active')  bool? isActive,  List<QuestionOptionCreate>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionUpdate() when $default != null:
return $default(_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.isActive,_that.options,_that.scaleMin,_that.scaleMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title, @JsonKey(name: 'question_content')  String? questionContent, @JsonKey(name: 'response_type')  String? responseType, @JsonKey(name: 'is_required')  bool? isRequired,  String? category, @JsonKey(name: 'is_active')  bool? isActive,  List<QuestionOptionCreate>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax)  $default,) {final _that = this;
switch (_that) {
case _QuestionUpdate():
return $default(_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.isActive,_that.options,_that.scaleMin,_that.scaleMax);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title, @JsonKey(name: 'question_content')  String? questionContent, @JsonKey(name: 'response_type')  String? responseType, @JsonKey(name: 'is_required')  bool? isRequired,  String? category, @JsonKey(name: 'is_active')  bool? isActive,  List<QuestionOptionCreate>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax)?  $default,) {final _that = this;
switch (_that) {
case _QuestionUpdate() when $default != null:
return $default(_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.isActive,_that.options,_that.scaleMin,_that.scaleMax);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionUpdate implements QuestionUpdate {
  const _QuestionUpdate({this.title, @JsonKey(name: 'question_content') this.questionContent, @JsonKey(name: 'response_type') this.responseType, @JsonKey(name: 'is_required') this.isRequired, this.category, @JsonKey(name: 'is_active') this.isActive, final  List<QuestionOptionCreate>? options, @JsonKey(name: 'scale_min') this.scaleMin, @JsonKey(name: 'scale_max') this.scaleMax}): _options = options;
  factory _QuestionUpdate.fromJson(Map<String, dynamic> json) => _$QuestionUpdateFromJson(json);

@override final  String? title;
@override@JsonKey(name: 'question_content') final  String? questionContent;
@override@JsonKey(name: 'response_type') final  String? responseType;
@override@JsonKey(name: 'is_required') final  bool? isRequired;
@override final  String? category;
@override@JsonKey(name: 'is_active') final  bool? isActive;
 final  List<QuestionOptionCreate>? _options;
@override List<QuestionOptionCreate>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'scale_min') final  int? scaleMin;
@override@JsonKey(name: 'scale_max') final  int? scaleMax;

/// Create a copy of QuestionUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionUpdateCopyWith<_QuestionUpdate> get copyWith => __$QuestionUpdateCopyWithImpl<_QuestionUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionUpdate&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,questionContent,responseType,isRequired,category,isActive,const DeepCollectionEquality().hash(_options),scaleMin,scaleMax);

@override
String toString() {
  return 'QuestionUpdate(title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, isActive: $isActive, options: $options, scaleMin: $scaleMin, scaleMax: $scaleMax)';
}


}

/// @nodoc
abstract mixin class _$QuestionUpdateCopyWith<$Res> implements $QuestionUpdateCopyWith<$Res> {
  factory _$QuestionUpdateCopyWith(_QuestionUpdate value, $Res Function(_QuestionUpdate) _then) = __$QuestionUpdateCopyWithImpl;
@override @useResult
$Res call({
 String? title,@JsonKey(name: 'question_content') String? questionContent,@JsonKey(name: 'response_type') String? responseType,@JsonKey(name: 'is_required') bool? isRequired, String? category,@JsonKey(name: 'is_active') bool? isActive, List<QuestionOptionCreate>? options,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax
});




}
/// @nodoc
class __$QuestionUpdateCopyWithImpl<$Res>
    implements _$QuestionUpdateCopyWith<$Res> {
  __$QuestionUpdateCopyWithImpl(this._self, this._then);

  final _QuestionUpdate _self;
  final $Res Function(_QuestionUpdate) _then;

/// Create a copy of QuestionUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? questionContent = freezed,Object? responseType = freezed,Object? isRequired = freezed,Object? category = freezed,Object? isActive = freezed,Object? options = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,}) {
  return _then(_QuestionUpdate(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: freezed == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String?,responseType: freezed == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOptionCreate>?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$QuestionOptionResponse {

@JsonKey(name: 'option_id') int get optionId;@JsonKey(name: 'option_text') String get optionText;@JsonKey(name: 'display_order') int? get displayOrder;
/// Create a copy of QuestionOptionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionOptionResponseCopyWith<QuestionOptionResponse> get copyWith => _$QuestionOptionResponseCopyWithImpl<QuestionOptionResponse>(this as QuestionOptionResponse, _$identity);

  /// Serializes this QuestionOptionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionOptionResponse&&(identical(other.optionId, optionId) || other.optionId == optionId)&&(identical(other.optionText, optionText) || other.optionText == optionText)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,optionId,optionText,displayOrder);

@override
String toString() {
  return 'QuestionOptionResponse(optionId: $optionId, optionText: $optionText, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $QuestionOptionResponseCopyWith<$Res>  {
  factory $QuestionOptionResponseCopyWith(QuestionOptionResponse value, $Res Function(QuestionOptionResponse) _then) = _$QuestionOptionResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'option_id') int optionId,@JsonKey(name: 'option_text') String optionText,@JsonKey(name: 'display_order') int? displayOrder
});




}
/// @nodoc
class _$QuestionOptionResponseCopyWithImpl<$Res>
    implements $QuestionOptionResponseCopyWith<$Res> {
  _$QuestionOptionResponseCopyWithImpl(this._self, this._then);

  final QuestionOptionResponse _self;
  final $Res Function(QuestionOptionResponse) _then;

/// Create a copy of QuestionOptionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? optionId = null,Object? optionText = null,Object? displayOrder = freezed,}) {
  return _then(_self.copyWith(
optionId: null == optionId ? _self.optionId : optionId // ignore: cast_nullable_to_non_nullable
as int,optionText: null == optionText ? _self.optionText : optionText // ignore: cast_nullable_to_non_nullable
as String,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionOptionResponse].
extension QuestionOptionResponsePatterns on QuestionOptionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionOptionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionOptionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionOptionResponse value)  $default,){
final _that = this;
switch (_that) {
case _QuestionOptionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionOptionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionOptionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'option_id')  int optionId, @JsonKey(name: 'option_text')  String optionText, @JsonKey(name: 'display_order')  int? displayOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionOptionResponse() when $default != null:
return $default(_that.optionId,_that.optionText,_that.displayOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'option_id')  int optionId, @JsonKey(name: 'option_text')  String optionText, @JsonKey(name: 'display_order')  int? displayOrder)  $default,) {final _that = this;
switch (_that) {
case _QuestionOptionResponse():
return $default(_that.optionId,_that.optionText,_that.displayOrder);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'option_id')  int optionId, @JsonKey(name: 'option_text')  String optionText, @JsonKey(name: 'display_order')  int? displayOrder)?  $default,) {final _that = this;
switch (_that) {
case _QuestionOptionResponse() when $default != null:
return $default(_that.optionId,_that.optionText,_that.displayOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionOptionResponse implements QuestionOptionResponse {
  const _QuestionOptionResponse({@JsonKey(name: 'option_id') required this.optionId, @JsonKey(name: 'option_text') required this.optionText, @JsonKey(name: 'display_order') this.displayOrder});
  factory _QuestionOptionResponse.fromJson(Map<String, dynamic> json) => _$QuestionOptionResponseFromJson(json);

@override@JsonKey(name: 'option_id') final  int optionId;
@override@JsonKey(name: 'option_text') final  String optionText;
@override@JsonKey(name: 'display_order') final  int? displayOrder;

/// Create a copy of QuestionOptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionOptionResponseCopyWith<_QuestionOptionResponse> get copyWith => __$QuestionOptionResponseCopyWithImpl<_QuestionOptionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionOptionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionOptionResponse&&(identical(other.optionId, optionId) || other.optionId == optionId)&&(identical(other.optionText, optionText) || other.optionText == optionText)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,optionId,optionText,displayOrder);

@override
String toString() {
  return 'QuestionOptionResponse(optionId: $optionId, optionText: $optionText, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class _$QuestionOptionResponseCopyWith<$Res> implements $QuestionOptionResponseCopyWith<$Res> {
  factory _$QuestionOptionResponseCopyWith(_QuestionOptionResponse value, $Res Function(_QuestionOptionResponse) _then) = __$QuestionOptionResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'option_id') int optionId,@JsonKey(name: 'option_text') String optionText,@JsonKey(name: 'display_order') int? displayOrder
});




}
/// @nodoc
class __$QuestionOptionResponseCopyWithImpl<$Res>
    implements _$QuestionOptionResponseCopyWith<$Res> {
  __$QuestionOptionResponseCopyWithImpl(this._self, this._then);

  final _QuestionOptionResponse _self;
  final $Res Function(_QuestionOptionResponse) _then;

/// Create a copy of QuestionOptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? optionId = null,Object? optionText = null,Object? displayOrder = freezed,}) {
  return _then(_QuestionOptionResponse(
optionId: null == optionId ? _self.optionId : optionId // ignore: cast_nullable_to_non_nullable
as int,optionText: null == optionText ? _self.optionText : optionText // ignore: cast_nullable_to_non_nullable
as String,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Question {

@JsonKey(name: 'question_id') int get questionId; String? get title;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType;@JsonKey(name: 'is_required') bool get isRequired; String? get category;@JsonKey(name: 'is_active') bool? get isActive; List<QuestionOptionResponse>? get options;@JsonKey(name: 'scale_min') int? get scaleMin;@JsonKey(name: 'scale_max') int? get scaleMax;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCopyWith<Question> get copyWith => _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Question&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,category,isActive,const DeepCollectionEquality().hash(options),scaleMin,scaleMax,createdAt,updatedAt);

@override
String toString() {
  return 'Question(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, isActive: $isActive, options: $options, scaleMin: $scaleMin, scaleMax: $scaleMax, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res>  {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) = _$QuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category,@JsonKey(name: 'is_active') bool? isActive, List<QuestionOptionResponse>? options,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$QuestionCopyWithImpl<$Res>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? isActive = freezed,Object? options = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOptionResponse>?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Question].
extension QuestionPatterns on Question {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Question value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Question value)  $default,){
final _that = this;
switch (_that) {
case _Question():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Question value)?  $default,){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category, @JsonKey(name: 'is_active')  bool? isActive,  List<QuestionOptionResponse>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.isActive,_that.options,_that.scaleMin,_that.scaleMax,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category, @JsonKey(name: 'is_active')  bool? isActive,  List<QuestionOptionResponse>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Question():
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.isActive,_that.options,_that.scaleMin,_that.scaleMax,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category, @JsonKey(name: 'is_active')  bool? isActive,  List<QuestionOptionResponse>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.isActive,_that.options,_that.scaleMin,_that.scaleMax,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Question implements Question {
  const _Question({@JsonKey(name: 'question_id') required this.questionId, this.title, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, @JsonKey(name: 'is_required') required this.isRequired, this.category, @JsonKey(name: 'is_active') this.isActive, final  List<QuestionOptionResponse>? options, @JsonKey(name: 'scale_min') this.scaleMin, @JsonKey(name: 'scale_max') this.scaleMax, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _options = options;
  factory _Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override final  String? title;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override@JsonKey(name: 'is_required') final  bool isRequired;
@override final  String? category;
@override@JsonKey(name: 'is_active') final  bool? isActive;
 final  List<QuestionOptionResponse>? _options;
@override List<QuestionOptionResponse>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'scale_min') final  int? scaleMin;
@override@JsonKey(name: 'scale_max') final  int? scaleMax;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCopyWith<_Question> get copyWith => __$QuestionCopyWithImpl<_Question>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Question&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,category,isActive,const DeepCollectionEquality().hash(_options),scaleMin,scaleMax,createdAt,updatedAt);

@override
String toString() {
  return 'Question(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, isActive: $isActive, options: $options, scaleMin: $scaleMin, scaleMax: $scaleMax, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) = __$QuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category,@JsonKey(name: 'is_active') bool? isActive, List<QuestionOptionResponse>? options,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? isActive = freezed,Object? options = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Question(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOptionResponse>?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$QuestionCategory {

@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'category_key') String get categoryKey;@JsonKey(name: 'display_order') int get displayOrder;
/// Create a copy of QuestionCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCategoryCopyWith<QuestionCategory> get copyWith => _$QuestionCategoryCopyWithImpl<QuestionCategory>(this as QuestionCategory, _$identity);

  /// Serializes this QuestionCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryKey,displayOrder);

@override
String toString() {
  return 'QuestionCategory(categoryId: $categoryId, categoryKey: $categoryKey, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $QuestionCategoryCopyWith<$Res>  {
  factory $QuestionCategoryCopyWith(QuestionCategory value, $Res Function(QuestionCategory) _then) = _$QuestionCategoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_key') String categoryKey,@JsonKey(name: 'display_order') int displayOrder
});




}
/// @nodoc
class _$QuestionCategoryCopyWithImpl<$Res>
    implements $QuestionCategoryCopyWith<$Res> {
  _$QuestionCategoryCopyWithImpl(this._self, this._then);

  final QuestionCategory _self;
  final $Res Function(QuestionCategory) _then;

/// Create a copy of QuestionCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryKey = null,Object? displayOrder = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionCategory].
extension QuestionCategoryPatterns on QuestionCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionCategory value)  $default,){
final _that = this;
switch (_that) {
case _QuestionCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionCategory value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_key')  String categoryKey, @JsonKey(name: 'display_order')  int displayOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionCategory() when $default != null:
return $default(_that.categoryId,_that.categoryKey,_that.displayOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_key')  String categoryKey, @JsonKey(name: 'display_order')  int displayOrder)  $default,) {final _that = this;
switch (_that) {
case _QuestionCategory():
return $default(_that.categoryId,_that.categoryKey,_that.displayOrder);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_key')  String categoryKey, @JsonKey(name: 'display_order')  int displayOrder)?  $default,) {final _that = this;
switch (_that) {
case _QuestionCategory() when $default != null:
return $default(_that.categoryId,_that.categoryKey,_that.displayOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionCategory implements QuestionCategory {
  const _QuestionCategory({@JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'category_key') required this.categoryKey, @JsonKey(name: 'display_order') required this.displayOrder});
  factory _QuestionCategory.fromJson(Map<String, dynamic> json) => _$QuestionCategoryFromJson(json);

@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'category_key') final  String categoryKey;
@override@JsonKey(name: 'display_order') final  int displayOrder;

/// Create a copy of QuestionCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCategoryCopyWith<_QuestionCategory> get copyWith => __$QuestionCategoryCopyWithImpl<_QuestionCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryKey,displayOrder);

@override
String toString() {
  return 'QuestionCategory(categoryId: $categoryId, categoryKey: $categoryKey, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class _$QuestionCategoryCopyWith<$Res> implements $QuestionCategoryCopyWith<$Res> {
  factory _$QuestionCategoryCopyWith(_QuestionCategory value, $Res Function(_QuestionCategory) _then) = __$QuestionCategoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_key') String categoryKey,@JsonKey(name: 'display_order') int displayOrder
});




}
/// @nodoc
class __$QuestionCategoryCopyWithImpl<$Res>
    implements _$QuestionCategoryCopyWith<$Res> {
  __$QuestionCategoryCopyWithImpl(this._self, this._then);

  final _QuestionCategory _self;
  final $Res Function(_QuestionCategory) _then;

/// Create a copy of QuestionCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryKey = null,Object? displayOrder = null,}) {
  return _then(_QuestionCategory(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
