// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantSurveyQuestionsResponse {

@JsonKey(name: 'survey_id') int get surveyId; String get title; List<ParticipantSurveyQuestion> get questions;
/// Create a copy of ParticipantSurveyQuestionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSurveyQuestionsResponseCopyWith<ParticipantSurveyQuestionsResponse> get copyWith => _$ParticipantSurveyQuestionsResponseCopyWithImpl<ParticipantSurveyQuestionsResponse>(this as ParticipantSurveyQuestionsResponse, _$identity);

  /// Serializes this ParticipantSurveyQuestionsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSurveyQuestionsResponse&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'ParticipantSurveyQuestionsResponse(surveyId: $surveyId, title: $title, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $ParticipantSurveyQuestionsResponseCopyWith<$Res>  {
  factory $ParticipantSurveyQuestionsResponseCopyWith(ParticipantSurveyQuestionsResponse value, $Res Function(ParticipantSurveyQuestionsResponse) _then) = _$ParticipantSurveyQuestionsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title, List<ParticipantSurveyQuestion> questions
});




}
/// @nodoc
class _$ParticipantSurveyQuestionsResponseCopyWithImpl<$Res>
    implements $ParticipantSurveyQuestionsResponseCopyWith<$Res> {
  _$ParticipantSurveyQuestionsResponseCopyWithImpl(this._self, this._then);

  final ParticipantSurveyQuestionsResponse _self;
  final $Res Function(ParticipantSurveyQuestionsResponse) _then;

/// Create a copy of ParticipantSurveyQuestionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? questions = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<ParticipantSurveyQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantSurveyQuestionsResponse].
extension ParticipantSurveyQuestionsResponsePatterns on ParticipantSurveyQuestionsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantSurveyQuestionsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantSurveyQuestionsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantSurveyQuestionsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyQuestionsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantSurveyQuestionsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyQuestionsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title,  List<ParticipantSurveyQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantSurveyQuestionsResponse() when $default != null:
return $default(_that.surveyId,_that.title,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title,  List<ParticipantSurveyQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyQuestionsResponse():
return $default(_that.surveyId,_that.title,_that.questions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title,  List<ParticipantSurveyQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyQuestionsResponse() when $default != null:
return $default(_that.surveyId,_that.title,_that.questions);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ParticipantSurveyQuestionsResponse implements ParticipantSurveyQuestionsResponse {
  const _ParticipantSurveyQuestionsResponse({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, required final  List<ParticipantSurveyQuestion> questions}): _questions = questions;
  factory _ParticipantSurveyQuestionsResponse.fromJson(Map<String, dynamic> json) => _$ParticipantSurveyQuestionsResponseFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
 final  List<ParticipantSurveyQuestion> _questions;
@override List<ParticipantSurveyQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of ParticipantSurveyQuestionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantSurveyQuestionsResponseCopyWith<_ParticipantSurveyQuestionsResponse> get copyWith => __$ParticipantSurveyQuestionsResponseCopyWithImpl<_ParticipantSurveyQuestionsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantSurveyQuestionsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantSurveyQuestionsResponse&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'ParticipantSurveyQuestionsResponse(surveyId: $surveyId, title: $title, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$ParticipantSurveyQuestionsResponseCopyWith<$Res> implements $ParticipantSurveyQuestionsResponseCopyWith<$Res> {
  factory _$ParticipantSurveyQuestionsResponseCopyWith(_ParticipantSurveyQuestionsResponse value, $Res Function(_ParticipantSurveyQuestionsResponse) _then) = __$ParticipantSurveyQuestionsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title, List<ParticipantSurveyQuestion> questions
});




}
/// @nodoc
class __$ParticipantSurveyQuestionsResponseCopyWithImpl<$Res>
    implements _$ParticipantSurveyQuestionsResponseCopyWith<$Res> {
  __$ParticipantSurveyQuestionsResponseCopyWithImpl(this._self, this._then);

  final _ParticipantSurveyQuestionsResponse _self;
  final $Res Function(_ParticipantSurveyQuestionsResponse) _then;

/// Create a copy of ParticipantSurveyQuestionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? questions = null,}) {
  return _then(_ParticipantSurveyQuestionsResponse(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<ParticipantSurveyQuestion>,
  ));
}


}


/// @nodoc
mixin _$ParticipantSurveyQuestion {

@JsonKey(name: 'question_id') int get questionId; String? get title;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType;@JsonKey(name: 'is_required') bool get isRequired; String? get category; List<ParticipantQuestionOption>? get options;@JsonKey(name: 'scale_min') int? get scaleMin;@JsonKey(name: 'scale_max') int? get scaleMax;
/// Create a copy of ParticipantSurveyQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSurveyQuestionCopyWith<ParticipantSurveyQuestion> get copyWith => _$ParticipantSurveyQuestionCopyWithImpl<ParticipantSurveyQuestion>(this as ParticipantSurveyQuestion, _$identity);

  /// Serializes this ParticipantSurveyQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSurveyQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,category,const DeepCollectionEquality().hash(options),scaleMin,scaleMax);

@override
String toString() {
  return 'ParticipantSurveyQuestion(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, options: $options, scaleMin: $scaleMin, scaleMax: $scaleMax)';
}


}

/// @nodoc
abstract mixin class $ParticipantSurveyQuestionCopyWith<$Res>  {
  factory $ParticipantSurveyQuestionCopyWith(ParticipantSurveyQuestion value, $Res Function(ParticipantSurveyQuestion) _then) = _$ParticipantSurveyQuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category, List<ParticipantQuestionOption>? options,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax
});




}
/// @nodoc
class _$ParticipantSurveyQuestionCopyWithImpl<$Res>
    implements $ParticipantSurveyQuestionCopyWith<$Res> {
  _$ParticipantSurveyQuestionCopyWithImpl(this._self, this._then);

  final ParticipantSurveyQuestion _self;
  final $Res Function(ParticipantSurveyQuestion) _then;

/// Create a copy of ParticipantSurveyQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? options = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<ParticipantQuestionOption>?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantSurveyQuestion].
extension ParticipantSurveyQuestionPatterns on ParticipantSurveyQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantSurveyQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantSurveyQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantSurveyQuestion value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantSurveyQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category,  List<ParticipantQuestionOption>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantSurveyQuestion() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.options,_that.scaleMin,_that.scaleMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category,  List<ParticipantQuestionOption>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax)  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyQuestion():
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.options,_that.scaleMin,_that.scaleMax);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category,  List<ParticipantQuestionOption>? options, @JsonKey(name: 'scale_min')  int? scaleMin, @JsonKey(name: 'scale_max')  int? scaleMax)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyQuestion() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.options,_that.scaleMin,_that.scaleMax);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ParticipantSurveyQuestion implements ParticipantSurveyQuestion {
  const _ParticipantSurveyQuestion({@JsonKey(name: 'question_id') required this.questionId, this.title, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, @JsonKey(name: 'is_required') required this.isRequired, this.category, final  List<ParticipantQuestionOption>? options, @JsonKey(name: 'scale_min') this.scaleMin, @JsonKey(name: 'scale_max') this.scaleMax}): _options = options;
  factory _ParticipantSurveyQuestion.fromJson(Map<String, dynamic> json) => _$ParticipantSurveyQuestionFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override final  String? title;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override@JsonKey(name: 'is_required') final  bool isRequired;
@override final  String? category;
 final  List<ParticipantQuestionOption>? _options;
@override List<ParticipantQuestionOption>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'scale_min') final  int? scaleMin;
@override@JsonKey(name: 'scale_max') final  int? scaleMax;

/// Create a copy of ParticipantSurveyQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantSurveyQuestionCopyWith<_ParticipantSurveyQuestion> get copyWith => __$ParticipantSurveyQuestionCopyWithImpl<_ParticipantSurveyQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantSurveyQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantSurveyQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.scaleMin, scaleMin) || other.scaleMin == scaleMin)&&(identical(other.scaleMax, scaleMax) || other.scaleMax == scaleMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,category,const DeepCollectionEquality().hash(_options),scaleMin,scaleMax);

@override
String toString() {
  return 'ParticipantSurveyQuestion(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, options: $options, scaleMin: $scaleMin, scaleMax: $scaleMax)';
}


}

/// @nodoc
abstract mixin class _$ParticipantSurveyQuestionCopyWith<$Res> implements $ParticipantSurveyQuestionCopyWith<$Res> {
  factory _$ParticipantSurveyQuestionCopyWith(_ParticipantSurveyQuestion value, $Res Function(_ParticipantSurveyQuestion) _then) = __$ParticipantSurveyQuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category, List<ParticipantQuestionOption>? options,@JsonKey(name: 'scale_min') int? scaleMin,@JsonKey(name: 'scale_max') int? scaleMax
});




}
/// @nodoc
class __$ParticipantSurveyQuestionCopyWithImpl<$Res>
    implements _$ParticipantSurveyQuestionCopyWith<$Res> {
  __$ParticipantSurveyQuestionCopyWithImpl(this._self, this._then);

  final _ParticipantSurveyQuestion _self;
  final $Res Function(_ParticipantSurveyQuestion) _then;

/// Create a copy of ParticipantSurveyQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? options = freezed,Object? scaleMin = freezed,Object? scaleMax = freezed,}) {
  return _then(_ParticipantSurveyQuestion(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<ParticipantQuestionOption>?,scaleMin: freezed == scaleMin ? _self.scaleMin : scaleMin // ignore: cast_nullable_to_non_nullable
as int?,scaleMax: freezed == scaleMax ? _self.scaleMax : scaleMax // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ParticipantQuestionOption {

@JsonKey(name: 'option_id') int get optionId;@JsonKey(name: 'option_text') String get optionText;@JsonKey(name: 'display_order') int? get displayOrder;
/// Create a copy of ParticipantQuestionOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantQuestionOptionCopyWith<ParticipantQuestionOption> get copyWith => _$ParticipantQuestionOptionCopyWithImpl<ParticipantQuestionOption>(this as ParticipantQuestionOption, _$identity);

  /// Serializes this ParticipantQuestionOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantQuestionOption&&(identical(other.optionId, optionId) || other.optionId == optionId)&&(identical(other.optionText, optionText) || other.optionText == optionText)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,optionId,optionText,displayOrder);

@override
String toString() {
  return 'ParticipantQuestionOption(optionId: $optionId, optionText: $optionText, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $ParticipantQuestionOptionCopyWith<$Res>  {
  factory $ParticipantQuestionOptionCopyWith(ParticipantQuestionOption value, $Res Function(ParticipantQuestionOption) _then) = _$ParticipantQuestionOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'option_id') int optionId,@JsonKey(name: 'option_text') String optionText,@JsonKey(name: 'display_order') int? displayOrder
});




}
/// @nodoc
class _$ParticipantQuestionOptionCopyWithImpl<$Res>
    implements $ParticipantQuestionOptionCopyWith<$Res> {
  _$ParticipantQuestionOptionCopyWithImpl(this._self, this._then);

  final ParticipantQuestionOption _self;
  final $Res Function(ParticipantQuestionOption) _then;

/// Create a copy of ParticipantQuestionOption
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


/// Adds pattern-matching-related methods to [ParticipantQuestionOption].
extension ParticipantQuestionOptionPatterns on ParticipantQuestionOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantQuestionOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantQuestionOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantQuestionOption value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantQuestionOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantQuestionOption value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantQuestionOption() when $default != null:
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
case _ParticipantQuestionOption() when $default != null:
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
case _ParticipantQuestionOption():
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
case _ParticipantQuestionOption() when $default != null:
return $default(_that.optionId,_that.optionText,_that.displayOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantQuestionOption implements ParticipantQuestionOption {
  const _ParticipantQuestionOption({@JsonKey(name: 'option_id') required this.optionId, @JsonKey(name: 'option_text') required this.optionText, @JsonKey(name: 'display_order') this.displayOrder});
  factory _ParticipantQuestionOption.fromJson(Map<String, dynamic> json) => _$ParticipantQuestionOptionFromJson(json);

@override@JsonKey(name: 'option_id') final  int optionId;
@override@JsonKey(name: 'option_text') final  String optionText;
@override@JsonKey(name: 'display_order') final  int? displayOrder;

/// Create a copy of ParticipantQuestionOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantQuestionOptionCopyWith<_ParticipantQuestionOption> get copyWith => __$ParticipantQuestionOptionCopyWithImpl<_ParticipantQuestionOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantQuestionOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantQuestionOption&&(identical(other.optionId, optionId) || other.optionId == optionId)&&(identical(other.optionText, optionText) || other.optionText == optionText)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,optionId,optionText,displayOrder);

@override
String toString() {
  return 'ParticipantQuestionOption(optionId: $optionId, optionText: $optionText, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class _$ParticipantQuestionOptionCopyWith<$Res> implements $ParticipantQuestionOptionCopyWith<$Res> {
  factory _$ParticipantQuestionOptionCopyWith(_ParticipantQuestionOption value, $Res Function(_ParticipantQuestionOption) _then) = __$ParticipantQuestionOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'option_id') int optionId,@JsonKey(name: 'option_text') String optionText,@JsonKey(name: 'display_order') int? displayOrder
});




}
/// @nodoc
class __$ParticipantQuestionOptionCopyWithImpl<$Res>
    implements _$ParticipantQuestionOptionCopyWith<$Res> {
  __$ParticipantQuestionOptionCopyWithImpl(this._self, this._then);

  final _ParticipantQuestionOption _self;
  final $Res Function(_ParticipantQuestionOption) _then;

/// Create a copy of ParticipantQuestionOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? optionId = null,Object? optionText = null,Object? displayOrder = freezed,}) {
  return _then(_ParticipantQuestionOption(
optionId: null == optionId ? _self.optionId : optionId // ignore: cast_nullable_to_non_nullable
as int,optionText: null == optionText ? _self.optionText : optionText // ignore: cast_nullable_to_non_nullable
as String,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ParticipantSurveyListItem {

@JsonKey(name: 'survey_id') int get surveyId; String get title;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate;@JsonKey(name: 'assignment_status') String get assignmentStatus;@JsonKey(name: 'has_draft') bool get hasDraft;@JsonKey(name: 'assigned_at') DateTime? get assignedAt;@JsonKey(name: 'due_date') DateTime? get dueDate;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'publication_status') String get publicationStatus;
/// Create a copy of ParticipantSurveyListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSurveyListItemCopyWith<ParticipantSurveyListItem> get copyWith => _$ParticipantSurveyListItemCopyWithImpl<ParticipantSurveyListItem>(this as ParticipantSurveyListItem, _$identity);

  /// Serializes this ParticipantSurveyListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSurveyListItem&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.assignmentStatus, assignmentStatus) || other.assignmentStatus == assignmentStatus)&&(identical(other.hasDraft, hasDraft) || other.hasDraft == hasDraft)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,startDate,endDate,assignmentStatus,hasDraft,assignedAt,dueDate,completedAt,publicationStatus);

@override
String toString() {
  return 'ParticipantSurveyListItem(surveyId: $surveyId, title: $title, startDate: $startDate, endDate: $endDate, assignmentStatus: $assignmentStatus, hasDraft: $hasDraft, assignedAt: $assignedAt, dueDate: $dueDate, completedAt: $completedAt, publicationStatus: $publicationStatus)';
}


}

/// @nodoc
abstract mixin class $ParticipantSurveyListItemCopyWith<$Res>  {
  factory $ParticipantSurveyListItemCopyWith(ParticipantSurveyListItem value, $Res Function(ParticipantSurveyListItem) _then) = _$ParticipantSurveyListItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'assignment_status') String assignmentStatus,@JsonKey(name: 'has_draft') bool hasDraft,@JsonKey(name: 'assigned_at') DateTime? assignedAt,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'publication_status') String publicationStatus
});




}
/// @nodoc
class _$ParticipantSurveyListItemCopyWithImpl<$Res>
    implements $ParticipantSurveyListItemCopyWith<$Res> {
  _$ParticipantSurveyListItemCopyWithImpl(this._self, this._then);

  final ParticipantSurveyListItem _self;
  final $Res Function(ParticipantSurveyListItem) _then;

/// Create a copy of ParticipantSurveyListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? startDate = freezed,Object? endDate = freezed,Object? assignmentStatus = null,Object? hasDraft = null,Object? assignedAt = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? publicationStatus = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,assignmentStatus: null == assignmentStatus ? _self.assignmentStatus : assignmentStatus // ignore: cast_nullable_to_non_nullable
as String,hasDraft: null == hasDraft ? _self.hasDraft : hasDraft // ignore: cast_nullable_to_non_nullable
as bool,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publicationStatus: null == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantSurveyListItem].
extension ParticipantSurveyListItemPatterns on ParticipantSurveyListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantSurveyListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantSurveyListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantSurveyListItem value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantSurveyListItem value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'assignment_status')  String assignmentStatus, @JsonKey(name: 'has_draft')  bool hasDraft, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'publication_status')  String publicationStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantSurveyListItem() when $default != null:
return $default(_that.surveyId,_that.title,_that.startDate,_that.endDate,_that.assignmentStatus,_that.hasDraft,_that.assignedAt,_that.dueDate,_that.completedAt,_that.publicationStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'assignment_status')  String assignmentStatus, @JsonKey(name: 'has_draft')  bool hasDraft, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'publication_status')  String publicationStatus)  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyListItem():
return $default(_that.surveyId,_that.title,_that.startDate,_that.endDate,_that.assignmentStatus,_that.hasDraft,_that.assignedAt,_that.dueDate,_that.completedAt,_that.publicationStatus);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'assignment_status')  String assignmentStatus, @JsonKey(name: 'has_draft')  bool hasDraft, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'publication_status')  String publicationStatus)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyListItem() when $default != null:
return $default(_that.surveyId,_that.title,_that.startDate,_that.endDate,_that.assignmentStatus,_that.hasDraft,_that.assignedAt,_that.dueDate,_that.completedAt,_that.publicationStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantSurveyListItem implements ParticipantSurveyListItem {
  const _ParticipantSurveyListItem({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, @JsonKey(name: 'assignment_status') required this.assignmentStatus, @JsonKey(name: 'has_draft') this.hasDraft = false, @JsonKey(name: 'assigned_at') this.assignedAt, @JsonKey(name: 'due_date') this.dueDate, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'publication_status') required this.publicationStatus});
  factory _ParticipantSurveyListItem.fromJson(Map<String, dynamic> json) => _$ParticipantSurveyListItemFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
@override@JsonKey(name: 'assignment_status') final  String assignmentStatus;
@override@JsonKey(name: 'has_draft') final  bool hasDraft;
@override@JsonKey(name: 'assigned_at') final  DateTime? assignedAt;
@override@JsonKey(name: 'due_date') final  DateTime? dueDate;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'publication_status') final  String publicationStatus;

/// Create a copy of ParticipantSurveyListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantSurveyListItemCopyWith<_ParticipantSurveyListItem> get copyWith => __$ParticipantSurveyListItemCopyWithImpl<_ParticipantSurveyListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantSurveyListItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantSurveyListItem&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.assignmentStatus, assignmentStatus) || other.assignmentStatus == assignmentStatus)&&(identical(other.hasDraft, hasDraft) || other.hasDraft == hasDraft)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,startDate,endDate,assignmentStatus,hasDraft,assignedAt,dueDate,completedAt,publicationStatus);

@override
String toString() {
  return 'ParticipantSurveyListItem(surveyId: $surveyId, title: $title, startDate: $startDate, endDate: $endDate, assignmentStatus: $assignmentStatus, hasDraft: $hasDraft, assignedAt: $assignedAt, dueDate: $dueDate, completedAt: $completedAt, publicationStatus: $publicationStatus)';
}


}

/// @nodoc
abstract mixin class _$ParticipantSurveyListItemCopyWith<$Res> implements $ParticipantSurveyListItemCopyWith<$Res> {
  factory _$ParticipantSurveyListItemCopyWith(_ParticipantSurveyListItem value, $Res Function(_ParticipantSurveyListItem) _then) = __$ParticipantSurveyListItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'assignment_status') String assignmentStatus,@JsonKey(name: 'has_draft') bool hasDraft,@JsonKey(name: 'assigned_at') DateTime? assignedAt,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'publication_status') String publicationStatus
});




}
/// @nodoc
class __$ParticipantSurveyListItemCopyWithImpl<$Res>
    implements _$ParticipantSurveyListItemCopyWith<$Res> {
  __$ParticipantSurveyListItemCopyWithImpl(this._self, this._then);

  final _ParticipantSurveyListItem _self;
  final $Res Function(_ParticipantSurveyListItem) _then;

/// Create a copy of ParticipantSurveyListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? startDate = freezed,Object? endDate = freezed,Object? assignmentStatus = null,Object? hasDraft = null,Object? assignedAt = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? publicationStatus = null,}) {
  return _then(_ParticipantSurveyListItem(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,assignmentStatus: null == assignmentStatus ? _self.assignmentStatus : assignmentStatus // ignore: cast_nullable_to_non_nullable
as String,hasDraft: null == hasDraft ? _self.hasDraft : hasDraft // ignore: cast_nullable_to_non_nullable
as bool,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publicationStatus: null == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ParticipantQuestionResponse {

@JsonKey(name: 'question_id') int get questionId; String? get title;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType;@JsonKey(name: 'is_required') bool get isRequired; String? get category;@JsonKey(name: 'response_value') String? get responseValue;
/// Create a copy of ParticipantQuestionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantQuestionResponseCopyWith<ParticipantQuestionResponse> get copyWith => _$ParticipantQuestionResponseCopyWithImpl<ParticipantQuestionResponse>(this as ParticipantQuestionResponse, _$identity);

  /// Serializes this ParticipantQuestionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantQuestionResponse&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&(identical(other.responseValue, responseValue) || other.responseValue == responseValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,category,responseValue);

@override
String toString() {
  return 'ParticipantQuestionResponse(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, responseValue: $responseValue)';
}


}

/// @nodoc
abstract mixin class $ParticipantQuestionResponseCopyWith<$Res>  {
  factory $ParticipantQuestionResponseCopyWith(ParticipantQuestionResponse value, $Res Function(ParticipantQuestionResponse) _then) = _$ParticipantQuestionResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category,@JsonKey(name: 'response_value') String? responseValue
});




}
/// @nodoc
class _$ParticipantQuestionResponseCopyWithImpl<$Res>
    implements $ParticipantQuestionResponseCopyWith<$Res> {
  _$ParticipantQuestionResponseCopyWithImpl(this._self, this._then);

  final ParticipantQuestionResponse _self;
  final $Res Function(ParticipantQuestionResponse) _then;

/// Create a copy of ParticipantQuestionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? responseValue = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,responseValue: freezed == responseValue ? _self.responseValue : responseValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantQuestionResponse].
extension ParticipantQuestionResponsePatterns on ParticipantQuestionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantQuestionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantQuestionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantQuestionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantQuestionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantQuestionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantQuestionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category, @JsonKey(name: 'response_value')  String? responseValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantQuestionResponse() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.responseValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category, @JsonKey(name: 'response_value')  String? responseValue)  $default,) {final _that = this;
switch (_that) {
case _ParticipantQuestionResponse():
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.responseValue);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired,  String? category, @JsonKey(name: 'response_value')  String? responseValue)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantQuestionResponse() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.category,_that.responseValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantQuestionResponse implements ParticipantQuestionResponse {
  const _ParticipantQuestionResponse({@JsonKey(name: 'question_id') required this.questionId, this.title, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, @JsonKey(name: 'is_required') required this.isRequired, this.category, @JsonKey(name: 'response_value') this.responseValue});
  factory _ParticipantQuestionResponse.fromJson(Map<String, dynamic> json) => _$ParticipantQuestionResponseFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override final  String? title;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override@JsonKey(name: 'is_required') final  bool isRequired;
@override final  String? category;
@override@JsonKey(name: 'response_value') final  String? responseValue;

/// Create a copy of ParticipantQuestionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantQuestionResponseCopyWith<_ParticipantQuestionResponse> get copyWith => __$ParticipantQuestionResponseCopyWithImpl<_ParticipantQuestionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantQuestionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantQuestionResponse&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.category, category) || other.category == category)&&(identical(other.responseValue, responseValue) || other.responseValue == responseValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,category,responseValue);

@override
String toString() {
  return 'ParticipantQuestionResponse(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, category: $category, responseValue: $responseValue)';
}


}

/// @nodoc
abstract mixin class _$ParticipantQuestionResponseCopyWith<$Res> implements $ParticipantQuestionResponseCopyWith<$Res> {
  factory _$ParticipantQuestionResponseCopyWith(_ParticipantQuestionResponse value, $Res Function(_ParticipantQuestionResponse) _then) = __$ParticipantQuestionResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired, String? category,@JsonKey(name: 'response_value') String? responseValue
});




}
/// @nodoc
class __$ParticipantQuestionResponseCopyWithImpl<$Res>
    implements _$ParticipantQuestionResponseCopyWith<$Res> {
  __$ParticipantQuestionResponseCopyWithImpl(this._self, this._then);

  final _ParticipantQuestionResponse _self;
  final $Res Function(_ParticipantQuestionResponse) _then;

/// Create a copy of ParticipantQuestionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? category = freezed,Object? responseValue = freezed,}) {
  return _then(_ParticipantQuestionResponse(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,responseValue: freezed == responseValue ? _self.responseValue : responseValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ParticipantSurveyWithResponses {

@JsonKey(name: 'survey_id') int get surveyId; String get title;@JsonKey(name: 'start_date') DateTime? get startDate;@JsonKey(name: 'end_date') DateTime? get endDate;@JsonKey(name: 'publication_status') String get publicationStatus;@JsonKey(name: 'assignment_status') String? get assignmentStatus;@JsonKey(name: 'assigned_at') DateTime? get assignedAt;@JsonKey(name: 'due_date') DateTime? get dueDate;@JsonKey(name: 'completed_at') DateTime? get completedAt; List<ParticipantQuestionResponse> get questions;
/// Create a copy of ParticipantSurveyWithResponses
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSurveyWithResponsesCopyWith<ParticipantSurveyWithResponses> get copyWith => _$ParticipantSurveyWithResponsesCopyWithImpl<ParticipantSurveyWithResponses>(this as ParticipantSurveyWithResponses, _$identity);

  /// Serializes this ParticipantSurveyWithResponses to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSurveyWithResponses&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.assignmentStatus, assignmentStatus) || other.assignmentStatus == assignmentStatus)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,startDate,endDate,publicationStatus,assignmentStatus,assignedAt,dueDate,completedAt,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'ParticipantSurveyWithResponses(surveyId: $surveyId, title: $title, startDate: $startDate, endDate: $endDate, publicationStatus: $publicationStatus, assignmentStatus: $assignmentStatus, assignedAt: $assignedAt, dueDate: $dueDate, completedAt: $completedAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $ParticipantSurveyWithResponsesCopyWith<$Res>  {
  factory $ParticipantSurveyWithResponsesCopyWith(ParticipantSurveyWithResponses value, $Res Function(ParticipantSurveyWithResponses) _then) = _$ParticipantSurveyWithResponsesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'publication_status') String publicationStatus,@JsonKey(name: 'assignment_status') String? assignmentStatus,@JsonKey(name: 'assigned_at') DateTime? assignedAt,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'completed_at') DateTime? completedAt, List<ParticipantQuestionResponse> questions
});




}
/// @nodoc
class _$ParticipantSurveyWithResponsesCopyWithImpl<$Res>
    implements $ParticipantSurveyWithResponsesCopyWith<$Res> {
  _$ParticipantSurveyWithResponsesCopyWithImpl(this._self, this._then);

  final ParticipantSurveyWithResponses _self;
  final $Res Function(ParticipantSurveyWithResponses) _then;

/// Create a copy of ParticipantSurveyWithResponses
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? startDate = freezed,Object? endDate = freezed,Object? publicationStatus = null,Object? assignmentStatus = freezed,Object? assignedAt = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? questions = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,publicationStatus: null == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as String,assignmentStatus: freezed == assignmentStatus ? _self.assignmentStatus : assignmentStatus // ignore: cast_nullable_to_non_nullable
as String?,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<ParticipantQuestionResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantSurveyWithResponses].
extension ParticipantSurveyWithResponsesPatterns on ParticipantSurveyWithResponses {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantSurveyWithResponses value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantSurveyWithResponses() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantSurveyWithResponses value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyWithResponses():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantSurveyWithResponses value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyWithResponses() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'publication_status')  String publicationStatus, @JsonKey(name: 'assignment_status')  String? assignmentStatus, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt,  List<ParticipantQuestionResponse> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantSurveyWithResponses() when $default != null:
return $default(_that.surveyId,_that.title,_that.startDate,_that.endDate,_that.publicationStatus,_that.assignmentStatus,_that.assignedAt,_that.dueDate,_that.completedAt,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'publication_status')  String publicationStatus, @JsonKey(name: 'assignment_status')  String? assignmentStatus, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt,  List<ParticipantQuestionResponse> questions)  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyWithResponses():
return $default(_that.surveyId,_that.title,_that.startDate,_that.endDate,_that.publicationStatus,_that.assignmentStatus,_that.assignedAt,_that.dueDate,_that.completedAt,_that.questions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'start_date')  DateTime? startDate, @JsonKey(name: 'end_date')  DateTime? endDate, @JsonKey(name: 'publication_status')  String publicationStatus, @JsonKey(name: 'assignment_status')  String? assignmentStatus, @JsonKey(name: 'assigned_at')  DateTime? assignedAt, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'completed_at')  DateTime? completedAt,  List<ParticipantQuestionResponse> questions)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyWithResponses() when $default != null:
return $default(_that.surveyId,_that.title,_that.startDate,_that.endDate,_that.publicationStatus,_that.assignmentStatus,_that.assignedAt,_that.dueDate,_that.completedAt,_that.questions);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ParticipantSurveyWithResponses implements ParticipantSurveyWithResponses {
  const _ParticipantSurveyWithResponses({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, @JsonKey(name: 'start_date') this.startDate, @JsonKey(name: 'end_date') this.endDate, @JsonKey(name: 'publication_status') required this.publicationStatus, @JsonKey(name: 'assignment_status') this.assignmentStatus, @JsonKey(name: 'assigned_at') this.assignedAt, @JsonKey(name: 'due_date') this.dueDate, @JsonKey(name: 'completed_at') this.completedAt, required final  List<ParticipantQuestionResponse> questions}): _questions = questions;
  factory _ParticipantSurveyWithResponses.fromJson(Map<String, dynamic> json) => _$ParticipantSurveyWithResponsesFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
@override@JsonKey(name: 'start_date') final  DateTime? startDate;
@override@JsonKey(name: 'end_date') final  DateTime? endDate;
@override@JsonKey(name: 'publication_status') final  String publicationStatus;
@override@JsonKey(name: 'assignment_status') final  String? assignmentStatus;
@override@JsonKey(name: 'assigned_at') final  DateTime? assignedAt;
@override@JsonKey(name: 'due_date') final  DateTime? dueDate;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
 final  List<ParticipantQuestionResponse> _questions;
@override List<ParticipantQuestionResponse> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of ParticipantSurveyWithResponses
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantSurveyWithResponsesCopyWith<_ParticipantSurveyWithResponses> get copyWith => __$ParticipantSurveyWithResponsesCopyWithImpl<_ParticipantSurveyWithResponses>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantSurveyWithResponsesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantSurveyWithResponses&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.assignmentStatus, assignmentStatus) || other.assignmentStatus == assignmentStatus)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,startDate,endDate,publicationStatus,assignmentStatus,assignedAt,dueDate,completedAt,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'ParticipantSurveyWithResponses(surveyId: $surveyId, title: $title, startDate: $startDate, endDate: $endDate, publicationStatus: $publicationStatus, assignmentStatus: $assignmentStatus, assignedAt: $assignedAt, dueDate: $dueDate, completedAt: $completedAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$ParticipantSurveyWithResponsesCopyWith<$Res> implements $ParticipantSurveyWithResponsesCopyWith<$Res> {
  factory _$ParticipantSurveyWithResponsesCopyWith(_ParticipantSurveyWithResponses value, $Res Function(_ParticipantSurveyWithResponses) _then) = __$ParticipantSurveyWithResponsesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'start_date') DateTime? startDate,@JsonKey(name: 'end_date') DateTime? endDate,@JsonKey(name: 'publication_status') String publicationStatus,@JsonKey(name: 'assignment_status') String? assignmentStatus,@JsonKey(name: 'assigned_at') DateTime? assignedAt,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'completed_at') DateTime? completedAt, List<ParticipantQuestionResponse> questions
});




}
/// @nodoc
class __$ParticipantSurveyWithResponsesCopyWithImpl<$Res>
    implements _$ParticipantSurveyWithResponsesCopyWith<$Res> {
  __$ParticipantSurveyWithResponsesCopyWithImpl(this._self, this._then);

  final _ParticipantSurveyWithResponses _self;
  final $Res Function(_ParticipantSurveyWithResponses) _then;

/// Create a copy of ParticipantSurveyWithResponses
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? startDate = freezed,Object? endDate = freezed,Object? publicationStatus = null,Object? assignmentStatus = freezed,Object? assignedAt = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? questions = null,}) {
  return _then(_ParticipantSurveyWithResponses(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,publicationStatus: null == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as String,assignmentStatus: freezed == assignmentStatus ? _self.assignmentStatus : assignmentStatus // ignore: cast_nullable_to_non_nullable
as String?,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<ParticipantQuestionResponse>,
  ));
}


}


/// @nodoc
mixin _$ChartQuestionData {

@JsonKey(name: 'question_id') int get questionId;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType; String? get category;@JsonKey(name: 'response_value') String? get responseValue; Map<String, dynamic>? get aggregate; bool get suppressed;
/// Create a copy of ChartQuestionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChartQuestionDataCopyWith<ChartQuestionData> get copyWith => _$ChartQuestionDataCopyWithImpl<ChartQuestionData>(this as ChartQuestionData, _$identity);

  /// Serializes this ChartQuestionData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartQuestionData&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.category, category) || other.category == category)&&(identical(other.responseValue, responseValue) || other.responseValue == responseValue)&&const DeepCollectionEquality().equals(other.aggregate, aggregate)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,questionContent,responseType,category,responseValue,const DeepCollectionEquality().hash(aggregate),suppressed);

@override
String toString() {
  return 'ChartQuestionData(questionId: $questionId, questionContent: $questionContent, responseType: $responseType, category: $category, responseValue: $responseValue, aggregate: $aggregate, suppressed: $suppressed)';
}


}

/// @nodoc
abstract mixin class $ChartQuestionDataCopyWith<$Res>  {
  factory $ChartQuestionDataCopyWith(ChartQuestionData value, $Res Function(ChartQuestionData) _then) = _$ChartQuestionDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType, String? category,@JsonKey(name: 'response_value') String? responseValue, Map<String, dynamic>? aggregate, bool suppressed
});




}
/// @nodoc
class _$ChartQuestionDataCopyWithImpl<$Res>
    implements $ChartQuestionDataCopyWith<$Res> {
  _$ChartQuestionDataCopyWithImpl(this._self, this._then);

  final ChartQuestionData _self;
  final $Res Function(ChartQuestionData) _then;

/// Create a copy of ChartQuestionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? questionContent = null,Object? responseType = null,Object? category = freezed,Object? responseValue = freezed,Object? aggregate = freezed,Object? suppressed = null,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,responseValue: freezed == responseValue ? _self.responseValue : responseValue // ignore: cast_nullable_to_non_nullable
as String?,aggregate: freezed == aggregate ? _self.aggregate : aggregate // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChartQuestionData].
extension ChartQuestionDataPatterns on ChartQuestionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChartQuestionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChartQuestionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChartQuestionData value)  $default,){
final _that = this;
switch (_that) {
case _ChartQuestionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChartQuestionData value)?  $default,){
final _that = this;
switch (_that) {
case _ChartQuestionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category, @JsonKey(name: 'response_value')  String? responseValue,  Map<String, dynamic>? aggregate,  bool suppressed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChartQuestionData() when $default != null:
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category,_that.responseValue,_that.aggregate,_that.suppressed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category, @JsonKey(name: 'response_value')  String? responseValue,  Map<String, dynamic>? aggregate,  bool suppressed)  $default,) {final _that = this;
switch (_that) {
case _ChartQuestionData():
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category,_that.responseValue,_that.aggregate,_that.suppressed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category, @JsonKey(name: 'response_value')  String? responseValue,  Map<String, dynamic>? aggregate,  bool suppressed)?  $default,) {final _that = this;
switch (_that) {
case _ChartQuestionData() when $default != null:
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category,_that.responseValue,_that.aggregate,_that.suppressed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChartQuestionData implements ChartQuestionData {
  const _ChartQuestionData({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, this.category, @JsonKey(name: 'response_value') this.responseValue, final  Map<String, dynamic>? aggregate, this.suppressed = false}): _aggregate = aggregate;
  factory _ChartQuestionData.fromJson(Map<String, dynamic> json) => _$ChartQuestionDataFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override final  String? category;
@override@JsonKey(name: 'response_value') final  String? responseValue;
 final  Map<String, dynamic>? _aggregate;
@override Map<String, dynamic>? get aggregate {
  final value = _aggregate;
  if (value == null) return null;
  if (_aggregate is EqualUnmodifiableMapView) return _aggregate;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  bool suppressed;

/// Create a copy of ChartQuestionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChartQuestionDataCopyWith<_ChartQuestionData> get copyWith => __$ChartQuestionDataCopyWithImpl<_ChartQuestionData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChartQuestionDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChartQuestionData&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.category, category) || other.category == category)&&(identical(other.responseValue, responseValue) || other.responseValue == responseValue)&&const DeepCollectionEquality().equals(other._aggregate, _aggregate)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,questionContent,responseType,category,responseValue,const DeepCollectionEquality().hash(_aggregate),suppressed);

@override
String toString() {
  return 'ChartQuestionData(questionId: $questionId, questionContent: $questionContent, responseType: $responseType, category: $category, responseValue: $responseValue, aggregate: $aggregate, suppressed: $suppressed)';
}


}

/// @nodoc
abstract mixin class _$ChartQuestionDataCopyWith<$Res> implements $ChartQuestionDataCopyWith<$Res> {
  factory _$ChartQuestionDataCopyWith(_ChartQuestionData value, $Res Function(_ChartQuestionData) _then) = __$ChartQuestionDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType, String? category,@JsonKey(name: 'response_value') String? responseValue, Map<String, dynamic>? aggregate, bool suppressed
});




}
/// @nodoc
class __$ChartQuestionDataCopyWithImpl<$Res>
    implements _$ChartQuestionDataCopyWith<$Res> {
  __$ChartQuestionDataCopyWithImpl(this._self, this._then);

  final _ChartQuestionData _self;
  final $Res Function(_ChartQuestionData) _then;

/// Create a copy of ChartQuestionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? questionContent = null,Object? responseType = null,Object? category = freezed,Object? responseValue = freezed,Object? aggregate = freezed,Object? suppressed = null,}) {
  return _then(_ChartQuestionData(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,responseValue: freezed == responseValue ? _self.responseValue : responseValue // ignore: cast_nullable_to_non_nullable
as String?,aggregate: freezed == aggregate ? _self._aggregate : aggregate // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ParticipantChartDataResponse {

@JsonKey(name: 'survey_id') int get surveyId; String get title;@JsonKey(name: 'total_respondents') int get totalRespondents; List<ChartQuestionData> get questions;
/// Create a copy of ParticipantChartDataResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantChartDataResponseCopyWith<ParticipantChartDataResponse> get copyWith => _$ParticipantChartDataResponseCopyWithImpl<ParticipantChartDataResponse>(this as ParticipantChartDataResponse, _$identity);

  /// Serializes this ParticipantChartDataResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantChartDataResponse&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.totalRespondents, totalRespondents) || other.totalRespondents == totalRespondents)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,totalRespondents,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'ParticipantChartDataResponse(surveyId: $surveyId, title: $title, totalRespondents: $totalRespondents, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $ParticipantChartDataResponseCopyWith<$Res>  {
  factory $ParticipantChartDataResponseCopyWith(ParticipantChartDataResponse value, $Res Function(ParticipantChartDataResponse) _then) = _$ParticipantChartDataResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'total_respondents') int totalRespondents, List<ChartQuestionData> questions
});




}
/// @nodoc
class _$ParticipantChartDataResponseCopyWithImpl<$Res>
    implements $ParticipantChartDataResponseCopyWith<$Res> {
  _$ParticipantChartDataResponseCopyWithImpl(this._self, this._then);

  final ParticipantChartDataResponse _self;
  final $Res Function(ParticipantChartDataResponse) _then;

/// Create a copy of ParticipantChartDataResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? totalRespondents = null,Object? questions = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,totalRespondents: null == totalRespondents ? _self.totalRespondents : totalRespondents // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<ChartQuestionData>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantChartDataResponse].
extension ParticipantChartDataResponsePatterns on ParticipantChartDataResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantChartDataResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantChartDataResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantChartDataResponse value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantChartDataResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantChartDataResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantChartDataResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'total_respondents')  int totalRespondents,  List<ChartQuestionData> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantChartDataResponse() when $default != null:
return $default(_that.surveyId,_that.title,_that.totalRespondents,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'total_respondents')  int totalRespondents,  List<ChartQuestionData> questions)  $default,) {final _that = this;
switch (_that) {
case _ParticipantChartDataResponse():
return $default(_that.surveyId,_that.title,_that.totalRespondents,_that.questions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'total_respondents')  int totalRespondents,  List<ChartQuestionData> questions)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantChartDataResponse() when $default != null:
return $default(_that.surveyId,_that.title,_that.totalRespondents,_that.questions);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ParticipantChartDataResponse implements ParticipantChartDataResponse {
  const _ParticipantChartDataResponse({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, @JsonKey(name: 'total_respondents') required this.totalRespondents, required final  List<ChartQuestionData> questions}): _questions = questions;
  factory _ParticipantChartDataResponse.fromJson(Map<String, dynamic> json) => _$ParticipantChartDataResponseFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
@override@JsonKey(name: 'total_respondents') final  int totalRespondents;
 final  List<ChartQuestionData> _questions;
@override List<ChartQuestionData> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of ParticipantChartDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantChartDataResponseCopyWith<_ParticipantChartDataResponse> get copyWith => __$ParticipantChartDataResponseCopyWithImpl<_ParticipantChartDataResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantChartDataResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantChartDataResponse&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.totalRespondents, totalRespondents) || other.totalRespondents == totalRespondents)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,totalRespondents,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'ParticipantChartDataResponse(surveyId: $surveyId, title: $title, totalRespondents: $totalRespondents, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$ParticipantChartDataResponseCopyWith<$Res> implements $ParticipantChartDataResponseCopyWith<$Res> {
  factory _$ParticipantChartDataResponseCopyWith(_ParticipantChartDataResponse value, $Res Function(_ParticipantChartDataResponse) _then) = __$ParticipantChartDataResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'total_respondents') int totalRespondents, List<ChartQuestionData> questions
});




}
/// @nodoc
class __$ParticipantChartDataResponseCopyWithImpl<$Res>
    implements _$ParticipantChartDataResponseCopyWith<$Res> {
  __$ParticipantChartDataResponseCopyWithImpl(this._self, this._then);

  final _ParticipantChartDataResponse _self;
  final $Res Function(_ParticipantChartDataResponse) _then;

/// Create a copy of ParticipantChartDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? totalRespondents = null,Object? questions = null,}) {
  return _then(_ParticipantChartDataResponse(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,totalRespondents: null == totalRespondents ? _self.totalRespondents : totalRespondents // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<ChartQuestionData>,
  ));
}


}


/// @nodoc
mixin _$ParticipantAnswerOut {

@JsonKey(name: 'question_id') int get questionId;@JsonKey(name: 'response_value') String? get responseValue;
/// Create a copy of ParticipantAnswerOut
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantAnswerOutCopyWith<ParticipantAnswerOut> get copyWith => _$ParticipantAnswerOutCopyWithImpl<ParticipantAnswerOut>(this as ParticipantAnswerOut, _$identity);

  /// Serializes this ParticipantAnswerOut to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantAnswerOut&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.responseValue, responseValue) || other.responseValue == responseValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,responseValue);

@override
String toString() {
  return 'ParticipantAnswerOut(questionId: $questionId, responseValue: $responseValue)';
}


}

/// @nodoc
abstract mixin class $ParticipantAnswerOutCopyWith<$Res>  {
  factory $ParticipantAnswerOutCopyWith(ParticipantAnswerOut value, $Res Function(ParticipantAnswerOut) _then) = _$ParticipantAnswerOutCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'response_value') String? responseValue
});




}
/// @nodoc
class _$ParticipantAnswerOutCopyWithImpl<$Res>
    implements $ParticipantAnswerOutCopyWith<$Res> {
  _$ParticipantAnswerOutCopyWithImpl(this._self, this._then);

  final ParticipantAnswerOut _self;
  final $Res Function(ParticipantAnswerOut) _then;

/// Create a copy of ParticipantAnswerOut
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? responseValue = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,responseValue: freezed == responseValue ? _self.responseValue : responseValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantAnswerOut].
extension ParticipantAnswerOutPatterns on ParticipantAnswerOut {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantAnswerOut value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantAnswerOut() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantAnswerOut value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantAnswerOut():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantAnswerOut value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantAnswerOut() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'response_value')  String? responseValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantAnswerOut() when $default != null:
return $default(_that.questionId,_that.responseValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'response_value')  String? responseValue)  $default,) {final _that = this;
switch (_that) {
case _ParticipantAnswerOut():
return $default(_that.questionId,_that.responseValue);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'response_value')  String? responseValue)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantAnswerOut() when $default != null:
return $default(_that.questionId,_that.responseValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantAnswerOut implements ParticipantAnswerOut {
  const _ParticipantAnswerOut({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'response_value') this.responseValue});
  factory _ParticipantAnswerOut.fromJson(Map<String, dynamic> json) => _$ParticipantAnswerOutFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override@JsonKey(name: 'response_value') final  String? responseValue;

/// Create a copy of ParticipantAnswerOut
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantAnswerOutCopyWith<_ParticipantAnswerOut> get copyWith => __$ParticipantAnswerOutCopyWithImpl<_ParticipantAnswerOut>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantAnswerOutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantAnswerOut&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.responseValue, responseValue) || other.responseValue == responseValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,responseValue);

@override
String toString() {
  return 'ParticipantAnswerOut(questionId: $questionId, responseValue: $responseValue)';
}


}

/// @nodoc
abstract mixin class _$ParticipantAnswerOutCopyWith<$Res> implements $ParticipantAnswerOutCopyWith<$Res> {
  factory _$ParticipantAnswerOutCopyWith(_ParticipantAnswerOut value, $Res Function(_ParticipantAnswerOut) _then) = __$ParticipantAnswerOutCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'response_value') String? responseValue
});




}
/// @nodoc
class __$ParticipantAnswerOutCopyWithImpl<$Res>
    implements _$ParticipantAnswerOutCopyWith<$Res> {
  __$ParticipantAnswerOutCopyWithImpl(this._self, this._then);

  final _ParticipantAnswerOut _self;
  final $Res Function(_ParticipantAnswerOut) _then;

/// Create a copy of ParticipantAnswerOut
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? responseValue = freezed,}) {
  return _then(_ParticipantAnswerOut(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,responseValue: freezed == responseValue ? _self.responseValue : responseValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ParticipantSurveyCompareResponse {

@JsonKey(name: 'survey_id') int get surveyId;@JsonKey(name: 'participant_answers') List<ParticipantAnswerOut> get participantAnswers; Map<String, dynamic> get aggregates;
/// Create a copy of ParticipantSurveyCompareResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSurveyCompareResponseCopyWith<ParticipantSurveyCompareResponse> get copyWith => _$ParticipantSurveyCompareResponseCopyWithImpl<ParticipantSurveyCompareResponse>(this as ParticipantSurveyCompareResponse, _$identity);

  /// Serializes this ParticipantSurveyCompareResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSurveyCompareResponse&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&const DeepCollectionEquality().equals(other.participantAnswers, participantAnswers)&&const DeepCollectionEquality().equals(other.aggregates, aggregates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,const DeepCollectionEquality().hash(participantAnswers),const DeepCollectionEquality().hash(aggregates));

@override
String toString() {
  return 'ParticipantSurveyCompareResponse(surveyId: $surveyId, participantAnswers: $participantAnswers, aggregates: $aggregates)';
}


}

/// @nodoc
abstract mixin class $ParticipantSurveyCompareResponseCopyWith<$Res>  {
  factory $ParticipantSurveyCompareResponseCopyWith(ParticipantSurveyCompareResponse value, $Res Function(ParticipantSurveyCompareResponse) _then) = _$ParticipantSurveyCompareResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId,@JsonKey(name: 'participant_answers') List<ParticipantAnswerOut> participantAnswers, Map<String, dynamic> aggregates
});




}
/// @nodoc
class _$ParticipantSurveyCompareResponseCopyWithImpl<$Res>
    implements $ParticipantSurveyCompareResponseCopyWith<$Res> {
  _$ParticipantSurveyCompareResponseCopyWithImpl(this._self, this._then);

  final ParticipantSurveyCompareResponse _self;
  final $Res Function(ParticipantSurveyCompareResponse) _then;

/// Create a copy of ParticipantSurveyCompareResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? participantAnswers = null,Object? aggregates = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,participantAnswers: null == participantAnswers ? _self.participantAnswers : participantAnswers // ignore: cast_nullable_to_non_nullable
as List<ParticipantAnswerOut>,aggregates: null == aggregates ? _self.aggregates : aggregates // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantSurveyCompareResponse].
extension ParticipantSurveyCompareResponsePatterns on ParticipantSurveyCompareResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantSurveyCompareResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantSurveyCompareResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantSurveyCompareResponse value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyCompareResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantSurveyCompareResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyCompareResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'participant_answers')  List<ParticipantAnswerOut> participantAnswers,  Map<String, dynamic> aggregates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantSurveyCompareResponse() when $default != null:
return $default(_that.surveyId,_that.participantAnswers,_that.aggregates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'participant_answers')  List<ParticipantAnswerOut> participantAnswers,  Map<String, dynamic> aggregates)  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyCompareResponse():
return $default(_that.surveyId,_that.participantAnswers,_that.aggregates);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'participant_answers')  List<ParticipantAnswerOut> participantAnswers,  Map<String, dynamic> aggregates)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyCompareResponse() when $default != null:
return $default(_that.surveyId,_that.participantAnswers,_that.aggregates);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ParticipantSurveyCompareResponse implements ParticipantSurveyCompareResponse {
  const _ParticipantSurveyCompareResponse({@JsonKey(name: 'survey_id') required this.surveyId, @JsonKey(name: 'participant_answers') required final  List<ParticipantAnswerOut> participantAnswers, required final  Map<String, dynamic> aggregates}): _participantAnswers = participantAnswers,_aggregates = aggregates;
  factory _ParticipantSurveyCompareResponse.fromJson(Map<String, dynamic> json) => _$ParticipantSurveyCompareResponseFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
 final  List<ParticipantAnswerOut> _participantAnswers;
@override@JsonKey(name: 'participant_answers') List<ParticipantAnswerOut> get participantAnswers {
  if (_participantAnswers is EqualUnmodifiableListView) return _participantAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantAnswers);
}

 final  Map<String, dynamic> _aggregates;
@override Map<String, dynamic> get aggregates {
  if (_aggregates is EqualUnmodifiableMapView) return _aggregates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_aggregates);
}


/// Create a copy of ParticipantSurveyCompareResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantSurveyCompareResponseCopyWith<_ParticipantSurveyCompareResponse> get copyWith => __$ParticipantSurveyCompareResponseCopyWithImpl<_ParticipantSurveyCompareResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantSurveyCompareResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantSurveyCompareResponse&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&const DeepCollectionEquality().equals(other._participantAnswers, _participantAnswers)&&const DeepCollectionEquality().equals(other._aggregates, _aggregates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,const DeepCollectionEquality().hash(_participantAnswers),const DeepCollectionEquality().hash(_aggregates));

@override
String toString() {
  return 'ParticipantSurveyCompareResponse(surveyId: $surveyId, participantAnswers: $participantAnswers, aggregates: $aggregates)';
}


}

/// @nodoc
abstract mixin class _$ParticipantSurveyCompareResponseCopyWith<$Res> implements $ParticipantSurveyCompareResponseCopyWith<$Res> {
  factory _$ParticipantSurveyCompareResponseCopyWith(_ParticipantSurveyCompareResponse value, $Res Function(_ParticipantSurveyCompareResponse) _then) = __$ParticipantSurveyCompareResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId,@JsonKey(name: 'participant_answers') List<ParticipantAnswerOut> participantAnswers, Map<String, dynamic> aggregates
});




}
/// @nodoc
class __$ParticipantSurveyCompareResponseCopyWithImpl<$Res>
    implements _$ParticipantSurveyCompareResponseCopyWith<$Res> {
  __$ParticipantSurveyCompareResponseCopyWithImpl(this._self, this._then);

  final _ParticipantSurveyCompareResponse _self;
  final $Res Function(_ParticipantSurveyCompareResponse) _then;

/// Create a copy of ParticipantSurveyCompareResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? participantAnswers = null,Object? aggregates = null,}) {
  return _then(_ParticipantSurveyCompareResponse(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,participantAnswers: null == participantAnswers ? _self._participantAnswers : participantAnswers // ignore: cast_nullable_to_non_nullable
as List<ParticipantAnswerOut>,aggregates: null == aggregates ? _self._aggregates : aggregates // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$ParticipantSurveyDraftResponse {

 Map<String, String> get draft;
/// Create a copy of ParticipantSurveyDraftResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSurveyDraftResponseCopyWith<ParticipantSurveyDraftResponse> get copyWith => _$ParticipantSurveyDraftResponseCopyWithImpl<ParticipantSurveyDraftResponse>(this as ParticipantSurveyDraftResponse, _$identity);

  /// Serializes this ParticipantSurveyDraftResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSurveyDraftResponse&&const DeepCollectionEquality().equals(other.draft, draft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(draft));

@override
String toString() {
  return 'ParticipantSurveyDraftResponse(draft: $draft)';
}


}

/// @nodoc
abstract mixin class $ParticipantSurveyDraftResponseCopyWith<$Res>  {
  factory $ParticipantSurveyDraftResponseCopyWith(ParticipantSurveyDraftResponse value, $Res Function(ParticipantSurveyDraftResponse) _then) = _$ParticipantSurveyDraftResponseCopyWithImpl;
@useResult
$Res call({
 Map<String, String> draft
});




}
/// @nodoc
class _$ParticipantSurveyDraftResponseCopyWithImpl<$Res>
    implements $ParticipantSurveyDraftResponseCopyWith<$Res> {
  _$ParticipantSurveyDraftResponseCopyWithImpl(this._self, this._then);

  final ParticipantSurveyDraftResponse _self;
  final $Res Function(ParticipantSurveyDraftResponse) _then;

/// Create a copy of ParticipantSurveyDraftResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draft = null,}) {
  return _then(_self.copyWith(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantSurveyDraftResponse].
extension ParticipantSurveyDraftResponsePatterns on ParticipantSurveyDraftResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantSurveyDraftResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantSurveyDraftResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantSurveyDraftResponse value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyDraftResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantSurveyDraftResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantSurveyDraftResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> draft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantSurveyDraftResponse() when $default != null:
return $default(_that.draft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> draft)  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyDraftResponse():
return $default(_that.draft);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> draft)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantSurveyDraftResponse() when $default != null:
return $default(_that.draft);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantSurveyDraftResponse implements ParticipantSurveyDraftResponse {
  const _ParticipantSurveyDraftResponse({final  Map<String, String> draft = const <String, String>{}}): _draft = draft;
  factory _ParticipantSurveyDraftResponse.fromJson(Map<String, dynamic> json) => _$ParticipantSurveyDraftResponseFromJson(json);

 final  Map<String, String> _draft;
@override@JsonKey() Map<String, String> get draft {
  if (_draft is EqualUnmodifiableMapView) return _draft;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_draft);
}


/// Create a copy of ParticipantSurveyDraftResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantSurveyDraftResponseCopyWith<_ParticipantSurveyDraftResponse> get copyWith => __$ParticipantSurveyDraftResponseCopyWithImpl<_ParticipantSurveyDraftResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantSurveyDraftResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantSurveyDraftResponse&&const DeepCollectionEquality().equals(other._draft, _draft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_draft));

@override
String toString() {
  return 'ParticipantSurveyDraftResponse(draft: $draft)';
}


}

/// @nodoc
abstract mixin class _$ParticipantSurveyDraftResponseCopyWith<$Res> implements $ParticipantSurveyDraftResponseCopyWith<$Res> {
  factory _$ParticipantSurveyDraftResponseCopyWith(_ParticipantSurveyDraftResponse value, $Res Function(_ParticipantSurveyDraftResponse) _then) = __$ParticipantSurveyDraftResponseCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> draft
});




}
/// @nodoc
class __$ParticipantSurveyDraftResponseCopyWithImpl<$Res>
    implements _$ParticipantSurveyDraftResponseCopyWith<$Res> {
  __$ParticipantSurveyDraftResponseCopyWithImpl(this._self, this._then);

  final _ParticipantSurveyDraftResponse _self;
  final $Res Function(_ParticipantSurveyDraftResponse) _then;

/// Create a copy of ParticipantSurveyDraftResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draft = null,}) {
  return _then(_ParticipantSurveyDraftResponse(
draft: null == draft ? _self._draft : draft // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
