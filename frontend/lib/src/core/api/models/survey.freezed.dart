// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'survey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionOption {

@JsonKey(name: 'option_id') int get optionId;@JsonKey(name: 'option_text') String get optionText;@JsonKey(name: 'display_order') int? get displayOrder;
/// Create a copy of QuestionOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionOptionCopyWith<QuestionOption> get copyWith => _$QuestionOptionCopyWithImpl<QuestionOption>(this as QuestionOption, _$identity);

  /// Serializes this QuestionOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionOption&&(identical(other.optionId, optionId) || other.optionId == optionId)&&(identical(other.optionText, optionText) || other.optionText == optionText)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,optionId,optionText,displayOrder);

@override
String toString() {
  return 'QuestionOption(optionId: $optionId, optionText: $optionText, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $QuestionOptionCopyWith<$Res>  {
  factory $QuestionOptionCopyWith(QuestionOption value, $Res Function(QuestionOption) _then) = _$QuestionOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'option_id') int optionId,@JsonKey(name: 'option_text') String optionText,@JsonKey(name: 'display_order') int? displayOrder
});




}
/// @nodoc
class _$QuestionOptionCopyWithImpl<$Res>
    implements $QuestionOptionCopyWith<$Res> {
  _$QuestionOptionCopyWithImpl(this._self, this._then);

  final QuestionOption _self;
  final $Res Function(QuestionOption) _then;

/// Create a copy of QuestionOption
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


/// Adds pattern-matching-related methods to [QuestionOption].
extension QuestionOptionPatterns on QuestionOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionOption value)  $default,){
final _that = this;
switch (_that) {
case _QuestionOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionOption value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionOption() when $default != null:
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
case _QuestionOption() when $default != null:
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
case _QuestionOption():
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
case _QuestionOption() when $default != null:
return $default(_that.optionId,_that.optionText,_that.displayOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionOption implements QuestionOption {
  const _QuestionOption({@JsonKey(name: 'option_id') required this.optionId, @JsonKey(name: 'option_text') required this.optionText, @JsonKey(name: 'display_order') this.displayOrder});
  factory _QuestionOption.fromJson(Map<String, dynamic> json) => _$QuestionOptionFromJson(json);

@override@JsonKey(name: 'option_id') final  int optionId;
@override@JsonKey(name: 'option_text') final  String optionText;
@override@JsonKey(name: 'display_order') final  int? displayOrder;

/// Create a copy of QuestionOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionOptionCopyWith<_QuestionOption> get copyWith => __$QuestionOptionCopyWithImpl<_QuestionOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionOption&&(identical(other.optionId, optionId) || other.optionId == optionId)&&(identical(other.optionText, optionText) || other.optionText == optionText)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,optionId,optionText,displayOrder);

@override
String toString() {
  return 'QuestionOption(optionId: $optionId, optionText: $optionText, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class _$QuestionOptionCopyWith<$Res> implements $QuestionOptionCopyWith<$Res> {
  factory _$QuestionOptionCopyWith(_QuestionOption value, $Res Function(_QuestionOption) _then) = __$QuestionOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'option_id') int optionId,@JsonKey(name: 'option_text') String optionText,@JsonKey(name: 'display_order') int? displayOrder
});




}
/// @nodoc
class __$QuestionOptionCopyWithImpl<$Res>
    implements _$QuestionOptionCopyWith<$Res> {
  __$QuestionOptionCopyWithImpl(this._self, this._then);

  final _QuestionOption _self;
  final $Res Function(_QuestionOption) _then;

/// Create a copy of QuestionOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? optionId = null,Object? optionText = null,Object? displayOrder = freezed,}) {
  return _then(_QuestionOption(
optionId: null == optionId ? _self.optionId : optionId // ignore: cast_nullable_to_non_nullable
as int,optionText: null == optionText ? _self.optionText : optionText // ignore: cast_nullable_to_non_nullable
as String,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$QuestionInSurvey {

@JsonKey(name: 'question_id') int get questionId; String? get title;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType;@JsonKey(name: 'is_required') bool get isRequired; String? get category;@JsonKey(name: 'scale_min') int? get scaleMin;@JsonKey(name: 'scale_max') int? get scaleMax; List<QuestionOption>? get options;
/// Create a copy of QuestionInSurvey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionInSurveyCopyWith<QuestionInSurvey> get copyWith => _$QuestionInSurveyCopyWithImpl<QuestionInSurvey>(this as QuestionInSurvey, _$identity);

  /// Serializes this QuestionInSurvey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionInSurvey&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,category,scaleMin,scaleMax,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'QuestionInSurvey(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, scaleMin: $scaleMin, scaleMax: $scaleMax, options: $options)';
}


}

/// @nodoc
abstract mixin class $QuestionInSurveyCopyWith<$Res>  {
  factory $QuestionInSurveyCopyWith(QuestionInSurvey value, $Res Function(QuestionInSurvey) _then) = _$QuestionInSurveyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax, List<QuestionOption>? options
});




}
/// @nodoc
class _$QuestionInSurveyCopyWithImpl<$Res>
    implements $QuestionInSurveyCopyWith<$Res> {
  _$QuestionInSurveyCopyWithImpl(this._self, this._then);

  final QuestionInSurvey _self;
  final $Res Function(QuestionInSurvey) _then;

/// Create a copy of QuestionInSurvey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,Object? options = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOption>?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionInSurvey].
extension QuestionInSurveyPatterns on QuestionInSurvey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionInSurvey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionInSurvey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionInSurvey value)  $default,){
final _that = this;
switch (_that) {
case _QuestionInSurvey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionInSurvey value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionInSurvey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax,  List<QuestionOption>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionInSurvey() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.scaleMin,_that.scaleMax,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax,  List<QuestionOption>? options)  $default,) {final _that = this;
switch (_that) {
case _QuestionInSurvey():
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.scaleMin,_that.scaleMax,_that.options);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax,  List<QuestionOption>? options)?  $default,) {final _that = this;
switch (_that) {
case _QuestionInSurvey() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.scaleMin,_that.scaleMax,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionInSurvey implements QuestionInSurvey {
  const _QuestionInSurvey({@JsonKey(name: 'question_id') required this.questionId, this.title, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, @JsonKey(name: 'is_required') required this.isRequired, this.category, @JsonKey(name: 'scale_min') this.scaleMin, @JsonKey(name: 'scale_max') this.scaleMax, final  List<QuestionOption>? options}): _options = options;
  factory _QuestionInSurvey.fromJson(Map<String, dynamic> json) => _$QuestionInSurveyFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override final  String? title;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override@JsonKey(name: 'is_required') final  bool isRequired;
@override final  String? category;
@override@JsonKey(name: 'scale_min') final  int? scaleMin;
@override@JsonKey(name: 'scale_max') final  int? scaleMax;
 final  List<QuestionOption>? _options;
@override List<QuestionOption>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of QuestionInSurvey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionInSurveyCopyWith<_QuestionInSurvey> get copyWith => __$QuestionInSurveyCopyWithImpl<_QuestionInSurvey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionInSurveyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionInSurvey&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,category,scaleMin,scaleMax,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'QuestionInSurvey(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, scaleMin: $scaleMin, scaleMax: $scaleMax, options: $options)';
}


}

/// @nodoc
abstract mixin class _$QuestionInSurveyCopyWith<$Res> implements $QuestionInSurveyCopyWith<$Res> {
  factory _$QuestionInSurveyCopyWith(_QuestionInSurvey value, $Res Function(_QuestionInSurvey) _then) = __$QuestionInSurveyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax, List<QuestionOption>? options
});




}
/// @nodoc
class __$QuestionInSurveyCopyWithImpl<$Res>
    implements _$QuestionInSurveyCopyWith<$Res> {
  __$QuestionInSurveyCopyWithImpl(this._self, this._then);

  final _QuestionInSurvey _self;
  final $Res Function(_QuestionInSurvey) _then;

/// Create a copy of QuestionInSurvey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,Object? options = freezed,}) {
  return _then(_QuestionInSurvey(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOption>?,
  ));
}


}


/// @nodoc
mixin _$SurveyQuestionLinkCreate {

@JsonKey(name: 'question_id') int get questionId;@JsonKey(name: 'is_required') bool get isRequired;
/// Create a copy of SurveyQuestionLinkCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyQuestionLinkCreateCopyWith<SurveyQuestionLinkCreate> get copyWith => _$SurveyQuestionLinkCreateCopyWithImpl<SurveyQuestionLinkCreate>(this as SurveyQuestionLinkCreate, _$identity);

  /// Serializes this SurveyQuestionLinkCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyQuestionLinkCreate&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,isRequired);

@override
String toString() {
  return 'SurveyQuestionLinkCreate(questionId: $questionId, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class $SurveyQuestionLinkCreateCopyWith<$Res>  {
  factory $SurveyQuestionLinkCreateCopyWith(SurveyQuestionLinkCreate value, $Res Function(SurveyQuestionLinkCreate) _then) = _$SurveyQuestionLinkCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'is_required') bool isRequired
});




}
/// @nodoc
class _$SurveyQuestionLinkCreateCopyWithImpl<$Res>
    implements $SurveyQuestionLinkCreateCopyWith<$Res> {
  _$SurveyQuestionLinkCreateCopyWithImpl(this._self, this._then);

  final SurveyQuestionLinkCreate _self;
  final $Res Function(SurveyQuestionLinkCreate) _then;

/// Create a copy of SurveyQuestionLinkCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? isRequired = null,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyQuestionLinkCreate].
extension SurveyQuestionLinkCreatePatterns on SurveyQuestionLinkCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyQuestionLinkCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyQuestionLinkCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyQuestionLinkCreate value)  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionLinkCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyQuestionLinkCreate value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyQuestionLinkCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'is_required')  bool isRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyQuestionLinkCreate() when $default != null:
return $default(_that.questionId,_that.isRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'is_required')  bool isRequired)  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionLinkCreate():
return $default(_that.questionId,_that.isRequired);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'is_required')  bool isRequired)?  $default,) {final _that = this;
switch (_that) {
case _SurveyQuestionLinkCreate() when $default != null:
return $default(_that.questionId,_that.isRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyQuestionLinkCreate implements SurveyQuestionLinkCreate {
  const _SurveyQuestionLinkCreate({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'is_required') this.isRequired = false});
  factory _SurveyQuestionLinkCreate.fromJson(Map<String, dynamic> json) => _$SurveyQuestionLinkCreateFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override@JsonKey(name: 'is_required') final  bool isRequired;

/// Create a copy of SurveyQuestionLinkCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyQuestionLinkCreateCopyWith<_SurveyQuestionLinkCreate> get copyWith => __$SurveyQuestionLinkCreateCopyWithImpl<_SurveyQuestionLinkCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyQuestionLinkCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyQuestionLinkCreate&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,isRequired);

@override
String toString() {
  return 'SurveyQuestionLinkCreate(questionId: $questionId, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class _$SurveyQuestionLinkCreateCopyWith<$Res> implements $SurveyQuestionLinkCreateCopyWith<$Res> {
  factory _$SurveyQuestionLinkCreateCopyWith(_SurveyQuestionLinkCreate value, $Res Function(_SurveyQuestionLinkCreate) _then) = __$SurveyQuestionLinkCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'is_required') bool isRequired
});




}
/// @nodoc
class __$SurveyQuestionLinkCreateCopyWithImpl<$Res>
    implements _$SurveyQuestionLinkCreateCopyWith<$Res> {
  __$SurveyQuestionLinkCreateCopyWithImpl(this._self, this._then);

  final _SurveyQuestionLinkCreate _self;
  final $Res Function(_SurveyQuestionLinkCreate) _then;

/// Create a copy of SurveyQuestionLinkCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? isRequired = null,}) {
  return _then(_SurveyQuestionLinkCreate(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SurveyCreate {

 String get title; String? get description;@JsonKey(name: 'publication_status') PublicationStatus? get publicationStatus;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate;@JsonKey(name: 'question_ids') List<int>? get questionIds; List<SurveyQuestionLinkCreate>? get questions;
/// Create a copy of SurveyCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyCreateCopyWith<SurveyCreate> get copyWith => _$SurveyCreateCopyWithImpl<SurveyCreate>(this as SurveyCreate, _$identity);

  /// Serializes this SurveyCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.questionIds, questionIds)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,publicationStatus,startDate,endDate,const DeepCollectionEquality().hash(questionIds),const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'SurveyCreate(title: $title, description: $description, publicationStatus: $publicationStatus, startDate: $startDate, endDate: $endDate, questionIds: $questionIds, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $SurveyCreateCopyWith<$Res>  {
  factory $SurveyCreateCopyWith(SurveyCreate value, $Res Function(SurveyCreate) _then) = _$SurveyCreateCopyWithImpl;
@useResult
$Res call({
 String title, String? description,@JsonKey(name: 'publication_status') PublicationStatus? publicationStatus,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'question_ids') List<int>? questionIds, List<SurveyQuestionLinkCreate>? questions
});




}
/// @nodoc
class _$SurveyCreateCopyWithImpl<$Res>
    implements $SurveyCreateCopyWith<$Res> {
  _$SurveyCreateCopyWithImpl(this._self, this._then);

  final SurveyCreate _self;
  final $Res Function(SurveyCreate) _then;

/// Create a copy of SurveyCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? publicationStatus = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? questionIds = freezed,Object? questions = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,publicationStatus: freezed == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as PublicationStatus?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,questionIds: freezed == questionIds ? _self.questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,questions: freezed == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionLinkCreate>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyCreate].
extension SurveyCreatePatterns on SurveyCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyCreate value)  $default,){
final _that = this;
switch (_that) {
case _SurveyCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyCreate value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(name: 'publication_status')  PublicationStatus? publicationStatus, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<SurveyQuestionLinkCreate>? questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyCreate() when $default != null:
return $default(_that.title,_that.description,_that.publicationStatus,_that.startDate,_that.endDate,_that.questionIds,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(name: 'publication_status')  PublicationStatus? publicationStatus, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<SurveyQuestionLinkCreate>? questions)  $default,) {final _that = this;
switch (_that) {
case _SurveyCreate():
return $default(_that.title,_that.description,_that.publicationStatus,_that.startDate,_that.endDate,_that.questionIds,_that.questions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description, @JsonKey(name: 'publication_status')  PublicationStatus? publicationStatus, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<SurveyQuestionLinkCreate>? questions)?  $default,) {final _that = this;
switch (_that) {
case _SurveyCreate() when $default != null:
return $default(_that.title,_that.description,_that.publicationStatus,_that.startDate,_that.endDate,_that.questionIds,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyCreate implements SurveyCreate {
  const _SurveyCreate({required this.title, this.description, @JsonKey(name: 'publication_status') this.publicationStatus, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, @JsonKey(name: 'question_ids') final  List<int>? questionIds, final  List<SurveyQuestionLinkCreate>? questions}): _questionIds = questionIds,_questions = questions;
  factory _SurveyCreate.fromJson(Map<String, dynamic> json) => _$SurveyCreateFromJson(json);

@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'publication_status') final  PublicationStatus? publicationStatus;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
 final  List<int>? _questionIds;
@override@JsonKey(name: 'question_ids') List<int>? get questionIds {
  final value = _questionIds;
  if (value == null) return null;
  if (_questionIds is EqualUnmodifiableListView) return _questionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SurveyQuestionLinkCreate>? _questions;
@override List<SurveyQuestionLinkCreate>? get questions {
  final value = _questions;
  if (value == null) return null;
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SurveyCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyCreateCopyWith<_SurveyCreate> get copyWith => __$SurveyCreateCopyWithImpl<_SurveyCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._questionIds, _questionIds)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,publicationStatus,startDate,endDate,const DeepCollectionEquality().hash(_questionIds),const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'SurveyCreate(title: $title, description: $description, publicationStatus: $publicationStatus, startDate: $startDate, endDate: $endDate, questionIds: $questionIds, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$SurveyCreateCopyWith<$Res> implements $SurveyCreateCopyWith<$Res> {
  factory _$SurveyCreateCopyWith(_SurveyCreate value, $Res Function(_SurveyCreate) _then) = __$SurveyCreateCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description,@JsonKey(name: 'publication_status') PublicationStatus? publicationStatus,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'question_ids') List<int>? questionIds, List<SurveyQuestionLinkCreate>? questions
});




}
/// @nodoc
class __$SurveyCreateCopyWithImpl<$Res>
    implements _$SurveyCreateCopyWith<$Res> {
  __$SurveyCreateCopyWithImpl(this._self, this._then);

  final _SurveyCreate _self;
  final $Res Function(_SurveyCreate) _then;

/// Create a copy of SurveyCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? publicationStatus = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? questionIds = freezed,Object? questions = freezed,}) {
  return _then(_SurveyCreate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,publicationStatus: freezed == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as PublicationStatus?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,questionIds: freezed == questionIds ? _self._questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,questions: freezed == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionLinkCreate>?,
  ));
}


}


/// @nodoc
mixin _$SurveyUpdate {

 String? get title; String? get description;@JsonKey(name: 'publication_status') PublicationStatus? get publicationStatus;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate;@JsonKey(name: 'question_ids') List<int>? get questionIds; List<SurveyQuestionLinkCreate>? get questions;
/// Create a copy of SurveyUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyUpdateCopyWith<SurveyUpdate> get copyWith => _$SurveyUpdateCopyWithImpl<SurveyUpdate>(this as SurveyUpdate, _$identity);

  /// Serializes this SurveyUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyUpdate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.questionIds, questionIds)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,publicationStatus,startDate,endDate,const DeepCollectionEquality().hash(questionIds),const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'SurveyUpdate(title: $title, description: $description, publicationStatus: $publicationStatus, startDate: $startDate, endDate: $endDate, questionIds: $questionIds, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $SurveyUpdateCopyWith<$Res>  {
  factory $SurveyUpdateCopyWith(SurveyUpdate value, $Res Function(SurveyUpdate) _then) = _$SurveyUpdateCopyWithImpl;
@useResult
$Res call({
 String? title, String? description,@JsonKey(name: 'publication_status') PublicationStatus? publicationStatus,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'question_ids') List<int>? questionIds, List<SurveyQuestionLinkCreate>? questions
});




}
/// @nodoc
class _$SurveyUpdateCopyWithImpl<$Res>
    implements $SurveyUpdateCopyWith<$Res> {
  _$SurveyUpdateCopyWithImpl(this._self, this._then);

  final SurveyUpdate _self;
  final $Res Function(SurveyUpdate) _then;

/// Create a copy of SurveyUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? publicationStatus = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? questionIds = freezed,Object? questions = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,publicationStatus: freezed == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as PublicationStatus?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,questionIds: freezed == questionIds ? _self.questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,questions: freezed == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionLinkCreate>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyUpdate].
extension SurveyUpdatePatterns on SurveyUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyUpdate value)  $default,){
final _that = this;
switch (_that) {
case _SurveyUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description, @JsonKey(name: 'publication_status')  PublicationStatus? publicationStatus, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<SurveyQuestionLinkCreate>? questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyUpdate() when $default != null:
return $default(_that.title,_that.description,_that.publicationStatus,_that.startDate,_that.endDate,_that.questionIds,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description, @JsonKey(name: 'publication_status')  PublicationStatus? publicationStatus, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<SurveyQuestionLinkCreate>? questions)  $default,) {final _that = this;
switch (_that) {
case _SurveyUpdate():
return $default(_that.title,_that.description,_that.publicationStatus,_that.startDate,_that.endDate,_that.questionIds,_that.questions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description, @JsonKey(name: 'publication_status')  PublicationStatus? publicationStatus, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<SurveyQuestionLinkCreate>? questions)?  $default,) {final _that = this;
switch (_that) {
case _SurveyUpdate() when $default != null:
return $default(_that.title,_that.description,_that.publicationStatus,_that.startDate,_that.endDate,_that.questionIds,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyUpdate implements SurveyUpdate {
  const _SurveyUpdate({this.title, this.description, @JsonKey(name: 'publication_status') this.publicationStatus, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, @JsonKey(name: 'question_ids') final  List<int>? questionIds, final  List<SurveyQuestionLinkCreate>? questions}): _questionIds = questionIds,_questions = questions;
  factory _SurveyUpdate.fromJson(Map<String, dynamic> json) => _$SurveyUpdateFromJson(json);

@override final  String? title;
@override final  String? description;
@override@JsonKey(name: 'publication_status') final  PublicationStatus? publicationStatus;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
 final  List<int>? _questionIds;
@override@JsonKey(name: 'question_ids') List<int>? get questionIds {
  final value = _questionIds;
  if (value == null) return null;
  if (_questionIds is EqualUnmodifiableListView) return _questionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SurveyQuestionLinkCreate>? _questions;
@override List<SurveyQuestionLinkCreate>? get questions {
  final value = _questions;
  if (value == null) return null;
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SurveyUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyUpdateCopyWith<_SurveyUpdate> get copyWith => __$SurveyUpdateCopyWithImpl<_SurveyUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyUpdate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._questionIds, _questionIds)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,publicationStatus,startDate,endDate,const DeepCollectionEquality().hash(_questionIds),const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'SurveyUpdate(title: $title, description: $description, publicationStatus: $publicationStatus, startDate: $startDate, endDate: $endDate, questionIds: $questionIds, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$SurveyUpdateCopyWith<$Res> implements $SurveyUpdateCopyWith<$Res> {
  factory _$SurveyUpdateCopyWith(_SurveyUpdate value, $Res Function(_SurveyUpdate) _then) = __$SurveyUpdateCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description,@JsonKey(name: 'publication_status') PublicationStatus? publicationStatus,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'question_ids') List<int>? questionIds, List<SurveyQuestionLinkCreate>? questions
});




}
/// @nodoc
class __$SurveyUpdateCopyWithImpl<$Res>
    implements _$SurveyUpdateCopyWith<$Res> {
  __$SurveyUpdateCopyWithImpl(this._self, this._then);

  final _SurveyUpdate _self;
  final $Res Function(_SurveyUpdate) _then;

/// Create a copy of SurveyUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? publicationStatus = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? questionIds = freezed,Object? questions = freezed,}) {
  return _then(_SurveyUpdate(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,publicationStatus: freezed == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as PublicationStatus?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,questionIds: freezed == questionIds ? _self._questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,questions: freezed == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<SurveyQuestionLinkCreate>?,
  ));
}


}


/// @nodoc
mixin _$SurveyFromTemplateCreate {

 String? get title; String? get description;
/// Create a copy of SurveyFromTemplateCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyFromTemplateCreateCopyWith<SurveyFromTemplateCreate> get copyWith => _$SurveyFromTemplateCreateCopyWithImpl<SurveyFromTemplateCreate>(this as SurveyFromTemplateCreate, _$identity);

  /// Serializes this SurveyFromTemplateCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyFromTemplateCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description);

@override
String toString() {
  return 'SurveyFromTemplateCreate(title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $SurveyFromTemplateCreateCopyWith<$Res>  {
  factory $SurveyFromTemplateCreateCopyWith(SurveyFromTemplateCreate value, $Res Function(SurveyFromTemplateCreate) _then) = _$SurveyFromTemplateCreateCopyWithImpl;
@useResult
$Res call({
 String? title, String? description
});




}
/// @nodoc
class _$SurveyFromTemplateCreateCopyWithImpl<$Res>
    implements $SurveyFromTemplateCreateCopyWith<$Res> {
  _$SurveyFromTemplateCreateCopyWithImpl(this._self, this._then);

  final SurveyFromTemplateCreate _self;
  final $Res Function(SurveyFromTemplateCreate) _then;

/// Create a copy of SurveyFromTemplateCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyFromTemplateCreate].
extension SurveyFromTemplateCreatePatterns on SurveyFromTemplateCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyFromTemplateCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyFromTemplateCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyFromTemplateCreate value)  $default,){
final _that = this;
switch (_that) {
case _SurveyFromTemplateCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyFromTemplateCreate value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyFromTemplateCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyFromTemplateCreate() when $default != null:
return $default(_that.title,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description)  $default,) {final _that = this;
switch (_that) {
case _SurveyFromTemplateCreate():
return $default(_that.title,_that.description);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _SurveyFromTemplateCreate() when $default != null:
return $default(_that.title,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyFromTemplateCreate implements SurveyFromTemplateCreate {
  const _SurveyFromTemplateCreate({this.title, this.description});
  factory _SurveyFromTemplateCreate.fromJson(Map<String, dynamic> json) => _$SurveyFromTemplateCreateFromJson(json);

@override final  String? title;
@override final  String? description;

/// Create a copy of SurveyFromTemplateCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyFromTemplateCreateCopyWith<_SurveyFromTemplateCreate> get copyWith => __$SurveyFromTemplateCreateCopyWithImpl<_SurveyFromTemplateCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyFromTemplateCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyFromTemplateCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description);

@override
String toString() {
  return 'SurveyFromTemplateCreate(title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class _$SurveyFromTemplateCreateCopyWith<$Res> implements $SurveyFromTemplateCreateCopyWith<$Res> {
  factory _$SurveyFromTemplateCreateCopyWith(_SurveyFromTemplateCreate value, $Res Function(_SurveyFromTemplateCreate) _then) = __$SurveyFromTemplateCreateCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description
});




}
/// @nodoc
class __$SurveyFromTemplateCreateCopyWithImpl<$Res>
    implements _$SurveyFromTemplateCreateCopyWith<$Res> {
  __$SurveyFromTemplateCreateCopyWithImpl(this._self, this._then);

  final _SurveyFromTemplateCreate _self;
  final $Res Function(_SurveyFromTemplateCreate) _then;

/// Create a copy of SurveyFromTemplateCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,}) {
  return _then(_SurveyFromTemplateCreate(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Survey {

@JsonKey(name: 'survey_id') int get surveyId; String get title; String? get description; String get status;@JsonKey(name: 'publication_status') String get publicationStatus;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate; List<QuestionInSurvey>? get questions;@JsonKey(name: 'question_count') int? get questionCount;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Survey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyCopyWith<Survey> get copyWith => _$SurveyCopyWithImpl<Survey>(this as Survey, _$identity);

  /// Serializes this Survey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Survey&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,description,status,publicationStatus,startDate,endDate,const DeepCollectionEquality().hash(questions),questionCount,createdAt,updatedAt);

@override
String toString() {
  return 'Survey(surveyId: $surveyId, title: $title, description: $description, status: $status, publicationStatus: $publicationStatus, startDate: $startDate, endDate: $endDate, questions: $questions, questionCount: $questionCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SurveyCopyWith<$Res>  {
  factory $SurveyCopyWith(Survey value, $Res Function(Survey) _then) = _$SurveyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title, String? description, String status,@JsonKey(name: 'publication_status') String publicationStatus,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, List<QuestionInSurvey>? questions,@JsonKey(name: 'question_count') int? questionCount,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$SurveyCopyWithImpl<$Res>
    implements $SurveyCopyWith<$Res> {
  _$SurveyCopyWithImpl(this._self, this._then);

  final Survey _self;
  final $Res Function(Survey) _then;

/// Create a copy of Survey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? description = freezed,Object? status = null,Object? publicationStatus = null,Object? startDate = freezed,Object? endDate = freezed,Object? questions = freezed,Object? questionCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publicationStatus: null == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,questions: freezed == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionInSurvey>?,questionCount: freezed == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Survey].
extension SurveyPatterns on Survey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Survey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Survey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Survey value)  $default,){
final _that = this;
switch (_that) {
case _Survey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Survey value)?  $default,){
final _that = this;
switch (_that) {
case _Survey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title,  String? description,  String status, @JsonKey(name: 'publication_status')  String publicationStatus, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  List<QuestionInSurvey>? questions, @JsonKey(name: 'question_count')  int? questionCount, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Survey() when $default != null:
return $default(_that.surveyId,_that.title,_that.description,_that.status,_that.publicationStatus,_that.startDate,_that.endDate,_that.questions,_that.questionCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title,  String? description,  String status, @JsonKey(name: 'publication_status')  String publicationStatus, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  List<QuestionInSurvey>? questions, @JsonKey(name: 'question_count')  int? questionCount, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Survey():
return $default(_that.surveyId,_that.title,_that.description,_that.status,_that.publicationStatus,_that.startDate,_that.endDate,_that.questions,_that.questionCount,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title,  String? description,  String status, @JsonKey(name: 'publication_status')  String publicationStatus, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate,  List<QuestionInSurvey>? questions, @JsonKey(name: 'question_count')  int? questionCount, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Survey() when $default != null:
return $default(_that.surveyId,_that.title,_that.description,_that.status,_that.publicationStatus,_that.startDate,_that.endDate,_that.questions,_that.questionCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Survey implements Survey {
  const _Survey({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, this.description, required this.status, @JsonKey(name: 'publication_status') required this.publicationStatus, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, final  List<QuestionInSurvey>? questions, @JsonKey(name: 'question_count') this.questionCount, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _questions = questions;
  factory _Survey.fromJson(Map<String, dynamic> json) => _$SurveyFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
@override final  String? description;
@override final  String status;
@override@JsonKey(name: 'publication_status') final  String publicationStatus;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
 final  List<QuestionInSurvey>? _questions;
@override List<QuestionInSurvey>? get questions {
  final value = _questions;
  if (value == null) return null;
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'question_count') final  int? questionCount;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Survey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyCopyWith<_Survey> get copyWith => __$SurveyCopyWithImpl<_Survey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Survey&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,description,status,publicationStatus,startDate,endDate,const DeepCollectionEquality().hash(_questions),questionCount,createdAt,updatedAt);

@override
String toString() {
  return 'Survey(surveyId: $surveyId, title: $title, description: $description, status: $status, publicationStatus: $publicationStatus, startDate: $startDate, endDate: $endDate, questions: $questions, questionCount: $questionCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SurveyCopyWith<$Res> implements $SurveyCopyWith<$Res> {
  factory _$SurveyCopyWith(_Survey value, $Res Function(_Survey) _then) = __$SurveyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title, String? description, String status,@JsonKey(name: 'publication_status') String publicationStatus,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate, List<QuestionInSurvey>? questions,@JsonKey(name: 'question_count') int? questionCount,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$SurveyCopyWithImpl<$Res>
    implements _$SurveyCopyWith<$Res> {
  __$SurveyCopyWithImpl(this._self, this._then);

  final _Survey _self;
  final $Res Function(_Survey) _then;

/// Create a copy of Survey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? description = freezed,Object? status = null,Object? publicationStatus = null,Object? startDate = freezed,Object? endDate = freezed,Object? questions = freezed,Object? questionCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Survey(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publicationStatus: null == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,questions: freezed == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionInSurvey>?,questionCount: freezed == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
