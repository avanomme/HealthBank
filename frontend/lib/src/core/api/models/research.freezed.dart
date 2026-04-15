// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'research.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResearchSurvey {

@JsonKey(name: 'survey_id') int get surveyId; String get title;@JsonKey(name: 'publication_status') String get publicationStatus;@JsonKey(name: 'response_count') int get responseCount;@JsonKey(name: 'question_count') int get questionCount;
/// Create a copy of ResearchSurvey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResearchSurveyCopyWith<ResearchSurvey> get copyWith => _$ResearchSurveyCopyWithImpl<ResearchSurvey>(this as ResearchSurvey, _$identity);

  /// Serializes this ResearchSurvey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResearchSurvey&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.responseCount, responseCount) || other.responseCount == responseCount)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,publicationStatus,responseCount,questionCount);

@override
String toString() {
  return 'ResearchSurvey(surveyId: $surveyId, title: $title, publicationStatus: $publicationStatus, responseCount: $responseCount, questionCount: $questionCount)';
}


}

/// @nodoc
abstract mixin class $ResearchSurveyCopyWith<$Res>  {
  factory $ResearchSurveyCopyWith(ResearchSurvey value, $Res Function(ResearchSurvey) _then) = _$ResearchSurveyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'publication_status') String publicationStatus,@JsonKey(name: 'response_count') int responseCount,@JsonKey(name: 'question_count') int questionCount
});




}
/// @nodoc
class _$ResearchSurveyCopyWithImpl<$Res>
    implements $ResearchSurveyCopyWith<$Res> {
  _$ResearchSurveyCopyWithImpl(this._self, this._then);

  final ResearchSurvey _self;
  final $Res Function(ResearchSurvey) _then;

/// Create a copy of ResearchSurvey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? publicationStatus = null,Object? responseCount = null,Object? questionCount = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,publicationStatus: null == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as String,responseCount: null == responseCount ? _self.responseCount : responseCount // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ResearchSurvey].
extension ResearchSurveyPatterns on ResearchSurvey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResearchSurvey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResearchSurvey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResearchSurvey value)  $default,){
final _that = this;
switch (_that) {
case _ResearchSurvey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResearchSurvey value)?  $default,){
final _that = this;
switch (_that) {
case _ResearchSurvey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'publication_status')  String publicationStatus, @JsonKey(name: 'response_count')  int responseCount, @JsonKey(name: 'question_count')  int questionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResearchSurvey() when $default != null:
return $default(_that.surveyId,_that.title,_that.publicationStatus,_that.responseCount,_that.questionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'publication_status')  String publicationStatus, @JsonKey(name: 'response_count')  int responseCount, @JsonKey(name: 'question_count')  int questionCount)  $default,) {final _that = this;
switch (_that) {
case _ResearchSurvey():
return $default(_that.surveyId,_that.title,_that.publicationStatus,_that.responseCount,_that.questionCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'publication_status')  String publicationStatus, @JsonKey(name: 'response_count')  int responseCount, @JsonKey(name: 'question_count')  int questionCount)?  $default,) {final _that = this;
switch (_that) {
case _ResearchSurvey() when $default != null:
return $default(_that.surveyId,_that.title,_that.publicationStatus,_that.responseCount,_that.questionCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResearchSurvey implements ResearchSurvey {
  const _ResearchSurvey({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, @JsonKey(name: 'publication_status') required this.publicationStatus, @JsonKey(name: 'response_count') required this.responseCount, @JsonKey(name: 'question_count') required this.questionCount});
  factory _ResearchSurvey.fromJson(Map<String, dynamic> json) => _$ResearchSurveyFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
@override@JsonKey(name: 'publication_status') final  String publicationStatus;
@override@JsonKey(name: 'response_count') final  int responseCount;
@override@JsonKey(name: 'question_count') final  int questionCount;

/// Create a copy of ResearchSurvey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResearchSurveyCopyWith<_ResearchSurvey> get copyWith => __$ResearchSurveyCopyWithImpl<_ResearchSurvey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResearchSurveyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResearchSurvey&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.publicationStatus, publicationStatus) || other.publicationStatus == publicationStatus)&&(identical(other.responseCount, responseCount) || other.responseCount == responseCount)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,publicationStatus,responseCount,questionCount);

@override
String toString() {
  return 'ResearchSurvey(surveyId: $surveyId, title: $title, publicationStatus: $publicationStatus, responseCount: $responseCount, questionCount: $questionCount)';
}


}

/// @nodoc
abstract mixin class _$ResearchSurveyCopyWith<$Res> implements $ResearchSurveyCopyWith<$Res> {
  factory _$ResearchSurveyCopyWith(_ResearchSurvey value, $Res Function(_ResearchSurvey) _then) = __$ResearchSurveyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'publication_status') String publicationStatus,@JsonKey(name: 'response_count') int responseCount,@JsonKey(name: 'question_count') int questionCount
});




}
/// @nodoc
class __$ResearchSurveyCopyWithImpl<$Res>
    implements _$ResearchSurveyCopyWith<$Res> {
  __$ResearchSurveyCopyWithImpl(this._self, this._then);

  final _ResearchSurvey _self;
  final $Res Function(_ResearchSurvey) _then;

/// Create a copy of ResearchSurvey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? publicationStatus = null,Object? responseCount = null,Object? questionCount = null,}) {
  return _then(_ResearchSurvey(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,publicationStatus: null == publicationStatus ? _self.publicationStatus : publicationStatus // ignore: cast_nullable_to_non_nullable
as String,responseCount: null == responseCount ? _self.responseCount : responseCount // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SurveyOverview {

@JsonKey(name: 'survey_id') int get surveyId; String get title;@JsonKey(name: 'respondent_count') int get respondentCount;@JsonKey(name: 'completion_rate') double get completionRate;@JsonKey(name: 'question_count') int get questionCount; bool get suppressed;@JsonKey(name: 'min_responses') int get minResponses;
/// Create a copy of SurveyOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyOverviewCopyWith<SurveyOverview> get copyWith => _$SurveyOverviewCopyWithImpl<SurveyOverview>(this as SurveyOverview, _$identity);

  /// Serializes this SurveyOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyOverview&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.respondentCount, respondentCount) || other.respondentCount == respondentCount)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&(identical(other.minResponses, minResponses) || other.minResponses == minResponses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,respondentCount,completionRate,questionCount,suppressed,minResponses);

@override
String toString() {
  return 'SurveyOverview(surveyId: $surveyId, title: $title, respondentCount: $respondentCount, completionRate: $completionRate, questionCount: $questionCount, suppressed: $suppressed, minResponses: $minResponses)';
}


}

/// @nodoc
abstract mixin class $SurveyOverviewCopyWith<$Res>  {
  factory $SurveyOverviewCopyWith(SurveyOverview value, $Res Function(SurveyOverview) _then) = _$SurveyOverviewCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'respondent_count') int respondentCount,@JsonKey(name: 'completion_rate') double completionRate,@JsonKey(name: 'question_count') int questionCount, bool suppressed,@JsonKey(name: 'min_responses') int minResponses
});




}
/// @nodoc
class _$SurveyOverviewCopyWithImpl<$Res>
    implements $SurveyOverviewCopyWith<$Res> {
  _$SurveyOverviewCopyWithImpl(this._self, this._then);

  final SurveyOverview _self;
  final $Res Function(SurveyOverview) _then;

/// Create a copy of SurveyOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? respondentCount = null,Object? completionRate = null,Object? questionCount = null,Object? suppressed = null,Object? minResponses = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,respondentCount: null == respondentCount ? _self.respondentCount : respondentCount // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,minResponses: null == minResponses ? _self.minResponses : minResponses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyOverview].
extension SurveyOverviewPatterns on SurveyOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyOverview value)  $default,){
final _that = this;
switch (_that) {
case _SurveyOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyOverview value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'respondent_count')  int respondentCount, @JsonKey(name: 'completion_rate')  double completionRate, @JsonKey(name: 'question_count')  int questionCount,  bool suppressed, @JsonKey(name: 'min_responses')  int minResponses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyOverview() when $default != null:
return $default(_that.surveyId,_that.title,_that.respondentCount,_that.completionRate,_that.questionCount,_that.suppressed,_that.minResponses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'respondent_count')  int respondentCount, @JsonKey(name: 'completion_rate')  double completionRate, @JsonKey(name: 'question_count')  int questionCount,  bool suppressed, @JsonKey(name: 'min_responses')  int minResponses)  $default,) {final _that = this;
switch (_that) {
case _SurveyOverview():
return $default(_that.surveyId,_that.title,_that.respondentCount,_that.completionRate,_that.questionCount,_that.suppressed,_that.minResponses);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'respondent_count')  int respondentCount, @JsonKey(name: 'completion_rate')  double completionRate, @JsonKey(name: 'question_count')  int questionCount,  bool suppressed, @JsonKey(name: 'min_responses')  int minResponses)?  $default,) {final _that = this;
switch (_that) {
case _SurveyOverview() when $default != null:
return $default(_that.surveyId,_that.title,_that.respondentCount,_that.completionRate,_that.questionCount,_that.suppressed,_that.minResponses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyOverview implements SurveyOverview {
  const _SurveyOverview({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, @JsonKey(name: 'respondent_count') required this.respondentCount, @JsonKey(name: 'completion_rate') required this.completionRate, @JsonKey(name: 'question_count') required this.questionCount, required this.suppressed, @JsonKey(name: 'min_responses') this.minResponses = 5});
  factory _SurveyOverview.fromJson(Map<String, dynamic> json) => _$SurveyOverviewFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
@override@JsonKey(name: 'respondent_count') final  int respondentCount;
@override@JsonKey(name: 'completion_rate') final  double completionRate;
@override@JsonKey(name: 'question_count') final  int questionCount;
@override final  bool suppressed;
@override@JsonKey(name: 'min_responses') final  int minResponses;

/// Create a copy of SurveyOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyOverviewCopyWith<_SurveyOverview> get copyWith => __$SurveyOverviewCopyWithImpl<_SurveyOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyOverview&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.respondentCount, respondentCount) || other.respondentCount == respondentCount)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&(identical(other.minResponses, minResponses) || other.minResponses == minResponses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,respondentCount,completionRate,questionCount,suppressed,minResponses);

@override
String toString() {
  return 'SurveyOverview(surveyId: $surveyId, title: $title, respondentCount: $respondentCount, completionRate: $completionRate, questionCount: $questionCount, suppressed: $suppressed, minResponses: $minResponses)';
}


}

/// @nodoc
abstract mixin class _$SurveyOverviewCopyWith<$Res> implements $SurveyOverviewCopyWith<$Res> {
  factory _$SurveyOverviewCopyWith(_SurveyOverview value, $Res Function(_SurveyOverview) _then) = __$SurveyOverviewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'respondent_count') int respondentCount,@JsonKey(name: 'completion_rate') double completionRate,@JsonKey(name: 'question_count') int questionCount, bool suppressed,@JsonKey(name: 'min_responses') int minResponses
});




}
/// @nodoc
class __$SurveyOverviewCopyWithImpl<$Res>
    implements _$SurveyOverviewCopyWith<$Res> {
  __$SurveyOverviewCopyWithImpl(this._self, this._then);

  final _SurveyOverview _self;
  final $Res Function(_SurveyOverview) _then;

/// Create a copy of SurveyOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? respondentCount = null,Object? completionRate = null,Object? questionCount = null,Object? suppressed = null,Object? minResponses = null,}) {
  return _then(_SurveyOverview(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,respondentCount: null == respondentCount ? _self.respondentCount : respondentCount // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,minResponses: null == minResponses ? _self.minResponses : minResponses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$QuestionAggregate {

@JsonKey(name: 'question_id') int get questionId;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType; String? get category;@JsonKey(name: 'response_count') int get responseCount; bool get suppressed; Map<String, dynamic>? get data;
/// Create a copy of QuestionAggregate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionAggregateCopyWith<QuestionAggregate> get copyWith => _$QuestionAggregateCopyWithImpl<QuestionAggregate>(this as QuestionAggregate, _$identity);

  /// Serializes this QuestionAggregate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionAggregate&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.category, category) || other.category == category)&&(identical(other.responseCount, responseCount) || other.responseCount == responseCount)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,questionContent,responseType,category,responseCount,suppressed,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'QuestionAggregate(questionId: $questionId, questionContent: $questionContent, responseType: $responseType, category: $category, responseCount: $responseCount, suppressed: $suppressed, data: $data)';
}


}

/// @nodoc
abstract mixin class $QuestionAggregateCopyWith<$Res>  {
  factory $QuestionAggregateCopyWith(QuestionAggregate value, $Res Function(QuestionAggregate) _then) = _$QuestionAggregateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType, String? category,@JsonKey(name: 'response_count') int responseCount, bool suppressed, Map<String, dynamic>? data
});




}
/// @nodoc
class _$QuestionAggregateCopyWithImpl<$Res>
    implements $QuestionAggregateCopyWith<$Res> {
  _$QuestionAggregateCopyWithImpl(this._self, this._then);

  final QuestionAggregate _self;
  final $Res Function(QuestionAggregate) _then;

/// Create a copy of QuestionAggregate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? questionContent = null,Object? responseType = null,Object? category = freezed,Object? responseCount = null,Object? suppressed = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,responseCount: null == responseCount ? _self.responseCount : responseCount // ignore: cast_nullable_to_non_nullable
as int,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionAggregate].
extension QuestionAggregatePatterns on QuestionAggregate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionAggregate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionAggregate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionAggregate value)  $default,){
final _that = this;
switch (_that) {
case _QuestionAggregate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionAggregate value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionAggregate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category, @JsonKey(name: 'response_count')  int responseCount,  bool suppressed,  Map<String, dynamic>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionAggregate() when $default != null:
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category,_that.responseCount,_that.suppressed,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category, @JsonKey(name: 'response_count')  int responseCount,  bool suppressed,  Map<String, dynamic>? data)  $default,) {final _that = this;
switch (_that) {
case _QuestionAggregate():
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category,_that.responseCount,_that.suppressed,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category, @JsonKey(name: 'response_count')  int responseCount,  bool suppressed,  Map<String, dynamic>? data)?  $default,) {final _that = this;
switch (_that) {
case _QuestionAggregate() when $default != null:
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category,_that.responseCount,_that.suppressed,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionAggregate implements QuestionAggregate {
  const _QuestionAggregate({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, this.category, @JsonKey(name: 'response_count') required this.responseCount, required this.suppressed, final  Map<String, dynamic>? data}): _data = data;
  factory _QuestionAggregate.fromJson(Map<String, dynamic> json) => _$QuestionAggregateFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override final  String? category;
@override@JsonKey(name: 'response_count') final  int responseCount;
@override final  bool suppressed;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of QuestionAggregate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionAggregateCopyWith<_QuestionAggregate> get copyWith => __$QuestionAggregateCopyWithImpl<_QuestionAggregate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionAggregateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionAggregate&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.category, category) || other.category == category)&&(identical(other.responseCount, responseCount) || other.responseCount == responseCount)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,questionContent,responseType,category,responseCount,suppressed,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'QuestionAggregate(questionId: $questionId, questionContent: $questionContent, responseType: $responseType, category: $category, responseCount: $responseCount, suppressed: $suppressed, data: $data)';
}


}

/// @nodoc
abstract mixin class _$QuestionAggregateCopyWith<$Res> implements $QuestionAggregateCopyWith<$Res> {
  factory _$QuestionAggregateCopyWith(_QuestionAggregate value, $Res Function(_QuestionAggregate) _then) = __$QuestionAggregateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType, String? category,@JsonKey(name: 'response_count') int responseCount, bool suppressed, Map<String, dynamic>? data
});




}
/// @nodoc
class __$QuestionAggregateCopyWithImpl<$Res>
    implements _$QuestionAggregateCopyWith<$Res> {
  __$QuestionAggregateCopyWithImpl(this._self, this._then);

  final _QuestionAggregate _self;
  final $Res Function(_QuestionAggregate) _then;

/// Create a copy of QuestionAggregate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? questionContent = null,Object? responseType = null,Object? category = freezed,Object? responseCount = null,Object? suppressed = null,Object? data = freezed,}) {
  return _then(_QuestionAggregate(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,responseCount: null == responseCount ? _self.responseCount : responseCount // ignore: cast_nullable_to_non_nullable
as int,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$AggregateResponse {

@JsonKey(name: 'survey_id') int get surveyId; String get title;@JsonKey(name: 'total_respondents') int get totalRespondents; List<QuestionAggregate> get aggregates;
/// Create a copy of AggregateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AggregateResponseCopyWith<AggregateResponse> get copyWith => _$AggregateResponseCopyWithImpl<AggregateResponse>(this as AggregateResponse, _$identity);

  /// Serializes this AggregateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AggregateResponse&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.totalRespondents, totalRespondents) || other.totalRespondents == totalRespondents)&&const DeepCollectionEquality().equals(other.aggregates, aggregates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,totalRespondents,const DeepCollectionEquality().hash(aggregates));

@override
String toString() {
  return 'AggregateResponse(surveyId: $surveyId, title: $title, totalRespondents: $totalRespondents, aggregates: $aggregates)';
}


}

/// @nodoc
abstract mixin class $AggregateResponseCopyWith<$Res>  {
  factory $AggregateResponseCopyWith(AggregateResponse value, $Res Function(AggregateResponse) _then) = _$AggregateResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'total_respondents') int totalRespondents, List<QuestionAggregate> aggregates
});




}
/// @nodoc
class _$AggregateResponseCopyWithImpl<$Res>
    implements $AggregateResponseCopyWith<$Res> {
  _$AggregateResponseCopyWithImpl(this._self, this._then);

  final AggregateResponse _self;
  final $Res Function(AggregateResponse) _then;

/// Create a copy of AggregateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? totalRespondents = null,Object? aggregates = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,totalRespondents: null == totalRespondents ? _self.totalRespondents : totalRespondents // ignore: cast_nullable_to_non_nullable
as int,aggregates: null == aggregates ? _self.aggregates : aggregates // ignore: cast_nullable_to_non_nullable
as List<QuestionAggregate>,
  ));
}

}


/// Adds pattern-matching-related methods to [AggregateResponse].
extension AggregateResponsePatterns on AggregateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AggregateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AggregateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AggregateResponse value)  $default,){
final _that = this;
switch (_that) {
case _AggregateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AggregateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AggregateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'total_respondents')  int totalRespondents,  List<QuestionAggregate> aggregates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AggregateResponse() when $default != null:
return $default(_that.surveyId,_that.title,_that.totalRespondents,_that.aggregates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'total_respondents')  int totalRespondents,  List<QuestionAggregate> aggregates)  $default,) {final _that = this;
switch (_that) {
case _AggregateResponse():
return $default(_that.surveyId,_that.title,_that.totalRespondents,_that.aggregates);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'total_respondents')  int totalRespondents,  List<QuestionAggregate> aggregates)?  $default,) {final _that = this;
switch (_that) {
case _AggregateResponse() when $default != null:
return $default(_that.surveyId,_that.title,_that.totalRespondents,_that.aggregates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AggregateResponse implements AggregateResponse {
  const _AggregateResponse({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, @JsonKey(name: 'total_respondents') required this.totalRespondents, required final  List<QuestionAggregate> aggregates}): _aggregates = aggregates;
  factory _AggregateResponse.fromJson(Map<String, dynamic> json) => _$AggregateResponseFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
@override@JsonKey(name: 'total_respondents') final  int totalRespondents;
 final  List<QuestionAggregate> _aggregates;
@override List<QuestionAggregate> get aggregates {
  if (_aggregates is EqualUnmodifiableListView) return _aggregates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aggregates);
}


/// Create a copy of AggregateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AggregateResponseCopyWith<_AggregateResponse> get copyWith => __$AggregateResponseCopyWithImpl<_AggregateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AggregateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AggregateResponse&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.totalRespondents, totalRespondents) || other.totalRespondents == totalRespondents)&&const DeepCollectionEquality().equals(other._aggregates, _aggregates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,totalRespondents,const DeepCollectionEquality().hash(_aggregates));

@override
String toString() {
  return 'AggregateResponse(surveyId: $surveyId, title: $title, totalRespondents: $totalRespondents, aggregates: $aggregates)';
}


}

/// @nodoc
abstract mixin class _$AggregateResponseCopyWith<$Res> implements $AggregateResponseCopyWith<$Res> {
  factory _$AggregateResponseCopyWith(_AggregateResponse value, $Res Function(_AggregateResponse) _then) = __$AggregateResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'total_respondents') int totalRespondents, List<QuestionAggregate> aggregates
});




}
/// @nodoc
class __$AggregateResponseCopyWithImpl<$Res>
    implements _$AggregateResponseCopyWith<$Res> {
  __$AggregateResponseCopyWithImpl(this._self, this._then);

  final _AggregateResponse _self;
  final $Res Function(_AggregateResponse) _then;

/// Create a copy of AggregateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? totalRespondents = null,Object? aggregates = null,}) {
  return _then(_AggregateResponse(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,totalRespondents: null == totalRespondents ? _self.totalRespondents : totalRespondents // ignore: cast_nullable_to_non_nullable
as int,aggregates: null == aggregates ? _self._aggregates : aggregates // ignore: cast_nullable_to_non_nullable
as List<QuestionAggregate>,
  ));
}


}


/// @nodoc
mixin _$ResponseQuestion {

@JsonKey(name: 'question_id') int get questionId;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType; String? get category;
/// Create a copy of ResponseQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResponseQuestionCopyWith<ResponseQuestion> get copyWith => _$ResponseQuestionCopyWithImpl<ResponseQuestion>(this as ResponseQuestion, _$identity);

  /// Serializes this ResponseQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResponseQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,questionContent,responseType,category);

@override
String toString() {
  return 'ResponseQuestion(questionId: $questionId, questionContent: $questionContent, responseType: $responseType, category: $category)';
}


}

/// @nodoc
abstract mixin class $ResponseQuestionCopyWith<$Res>  {
  factory $ResponseQuestionCopyWith(ResponseQuestion value, $Res Function(ResponseQuestion) _then) = _$ResponseQuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType, String? category
});




}
/// @nodoc
class _$ResponseQuestionCopyWithImpl<$Res>
    implements $ResponseQuestionCopyWith<$Res> {
  _$ResponseQuestionCopyWithImpl(this._self, this._then);

  final ResponseQuestion _self;
  final $Res Function(ResponseQuestion) _then;

/// Create a copy of ResponseQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? questionContent = null,Object? responseType = null,Object? category = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResponseQuestion].
extension ResponseQuestionPatterns on ResponseQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResponseQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResponseQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResponseQuestion value)  $default,){
final _that = this;
switch (_that) {
case _ResponseQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResponseQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _ResponseQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResponseQuestion() when $default != null:
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category)  $default,) {final _that = this;
switch (_that) {
case _ResponseQuestion():
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category)?  $default,) {final _that = this;
switch (_that) {
case _ResponseQuestion() when $default != null:
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResponseQuestion implements ResponseQuestion {
  const _ResponseQuestion({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, this.category});
  factory _ResponseQuestion.fromJson(Map<String, dynamic> json) => _$ResponseQuestionFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override final  String? category;

/// Create a copy of ResponseQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResponseQuestionCopyWith<_ResponseQuestion> get copyWith => __$ResponseQuestionCopyWithImpl<_ResponseQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResponseQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResponseQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,questionContent,responseType,category);

@override
String toString() {
  return 'ResponseQuestion(questionId: $questionId, questionContent: $questionContent, responseType: $responseType, category: $category)';
}


}

/// @nodoc
abstract mixin class _$ResponseQuestionCopyWith<$Res> implements $ResponseQuestionCopyWith<$Res> {
  factory _$ResponseQuestionCopyWith(_ResponseQuestion value, $Res Function(_ResponseQuestion) _then) = __$ResponseQuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType, String? category
});




}
/// @nodoc
class __$ResponseQuestionCopyWithImpl<$Res>
    implements _$ResponseQuestionCopyWith<$Res> {
  __$ResponseQuestionCopyWithImpl(this._self, this._then);

  final _ResponseQuestion _self;
  final $Res Function(_ResponseQuestion) _then;

/// Create a copy of ResponseQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? questionContent = null,Object? responseType = null,Object? category = freezed,}) {
  return _then(_ResponseQuestion(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ResponseRow {

@JsonKey(name: 'anonymous_id') String get anonymousId; Map<String, String> get responses;
/// Create a copy of ResponseRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResponseRowCopyWith<ResponseRow> get copyWith => _$ResponseRowCopyWithImpl<ResponseRow>(this as ResponseRow, _$identity);

  /// Serializes this ResponseRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResponseRow&&(identical(other.anonymousId, anonymousId) || other.anonymousId == anonymousId)&&const DeepCollectionEquality().equals(other.responses, responses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anonymousId,const DeepCollectionEquality().hash(responses));

@override
String toString() {
  return 'ResponseRow(anonymousId: $anonymousId, responses: $responses)';
}


}

/// @nodoc
abstract mixin class $ResponseRowCopyWith<$Res>  {
  factory $ResponseRowCopyWith(ResponseRow value, $Res Function(ResponseRow) _then) = _$ResponseRowCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'anonymous_id') String anonymousId, Map<String, String> responses
});




}
/// @nodoc
class _$ResponseRowCopyWithImpl<$Res>
    implements $ResponseRowCopyWith<$Res> {
  _$ResponseRowCopyWithImpl(this._self, this._then);

  final ResponseRow _self;
  final $Res Function(ResponseRow) _then;

/// Create a copy of ResponseRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anonymousId = null,Object? responses = null,}) {
  return _then(_self.copyWith(
anonymousId: null == anonymousId ? _self.anonymousId : anonymousId // ignore: cast_nullable_to_non_nullable
as String,responses: null == responses ? _self.responses : responses // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ResponseRow].
extension ResponseRowPatterns on ResponseRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResponseRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResponseRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResponseRow value)  $default,){
final _that = this;
switch (_that) {
case _ResponseRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResponseRow value)?  $default,){
final _that = this;
switch (_that) {
case _ResponseRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'anonymous_id')  String anonymousId,  Map<String, String> responses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResponseRow() when $default != null:
return $default(_that.anonymousId,_that.responses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'anonymous_id')  String anonymousId,  Map<String, String> responses)  $default,) {final _that = this;
switch (_that) {
case _ResponseRow():
return $default(_that.anonymousId,_that.responses);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'anonymous_id')  String anonymousId,  Map<String, String> responses)?  $default,) {final _that = this;
switch (_that) {
case _ResponseRow() when $default != null:
return $default(_that.anonymousId,_that.responses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResponseRow implements ResponseRow {
  const _ResponseRow({@JsonKey(name: 'anonymous_id') required this.anonymousId, required final  Map<String, String> responses}): _responses = responses;
  factory _ResponseRow.fromJson(Map<String, dynamic> json) => _$ResponseRowFromJson(json);

@override@JsonKey(name: 'anonymous_id') final  String anonymousId;
 final  Map<String, String> _responses;
@override Map<String, String> get responses {
  if (_responses is EqualUnmodifiableMapView) return _responses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_responses);
}


/// Create a copy of ResponseRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResponseRowCopyWith<_ResponseRow> get copyWith => __$ResponseRowCopyWithImpl<_ResponseRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResponseRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResponseRow&&(identical(other.anonymousId, anonymousId) || other.anonymousId == anonymousId)&&const DeepCollectionEquality().equals(other._responses, _responses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anonymousId,const DeepCollectionEquality().hash(_responses));

@override
String toString() {
  return 'ResponseRow(anonymousId: $anonymousId, responses: $responses)';
}


}

/// @nodoc
abstract mixin class _$ResponseRowCopyWith<$Res> implements $ResponseRowCopyWith<$Res> {
  factory _$ResponseRowCopyWith(_ResponseRow value, $Res Function(_ResponseRow) _then) = __$ResponseRowCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'anonymous_id') String anonymousId, Map<String, String> responses
});




}
/// @nodoc
class __$ResponseRowCopyWithImpl<$Res>
    implements _$ResponseRowCopyWith<$Res> {
  __$ResponseRowCopyWithImpl(this._self, this._then);

  final _ResponseRow _self;
  final $Res Function(_ResponseRow) _then;

/// Create a copy of ResponseRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anonymousId = null,Object? responses = null,}) {
  return _then(_ResponseRow(
anonymousId: null == anonymousId ? _self.anonymousId : anonymousId // ignore: cast_nullable_to_non_nullable
as String,responses: null == responses ? _self._responses : responses // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$IndividualResponseData {

@JsonKey(name: 'survey_id') int get surveyId; String get title;@JsonKey(name: 'respondent_count') int get respondentCount; bool get suppressed; String? get reason; List<ResponseQuestion> get questions; List<ResponseRow> get rows;
/// Create a copy of IndividualResponseData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IndividualResponseDataCopyWith<IndividualResponseData> get copyWith => _$IndividualResponseDataCopyWithImpl<IndividualResponseData>(this as IndividualResponseData, _$identity);

  /// Serializes this IndividualResponseData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IndividualResponseData&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.respondentCount, respondentCount) || other.respondentCount == respondentCount)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.questions, questions)&&const DeepCollectionEquality().equals(other.rows, rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,respondentCount,suppressed,reason,const DeepCollectionEquality().hash(questions),const DeepCollectionEquality().hash(rows));

@override
String toString() {
  return 'IndividualResponseData(surveyId: $surveyId, title: $title, respondentCount: $respondentCount, suppressed: $suppressed, reason: $reason, questions: $questions, rows: $rows)';
}


}

/// @nodoc
abstract mixin class $IndividualResponseDataCopyWith<$Res>  {
  factory $IndividualResponseDataCopyWith(IndividualResponseData value, $Res Function(IndividualResponseData) _then) = _$IndividualResponseDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'respondent_count') int respondentCount, bool suppressed, String? reason, List<ResponseQuestion> questions, List<ResponseRow> rows
});




}
/// @nodoc
class _$IndividualResponseDataCopyWithImpl<$Res>
    implements $IndividualResponseDataCopyWith<$Res> {
  _$IndividualResponseDataCopyWithImpl(this._self, this._then);

  final IndividualResponseData _self;
  final $Res Function(IndividualResponseData) _then;

/// Create a copy of IndividualResponseData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? respondentCount = null,Object? suppressed = null,Object? reason = freezed,Object? questions = null,Object? rows = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,respondentCount: null == respondentCount ? _self.respondentCount : respondentCount // ignore: cast_nullable_to_non_nullable
as int,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<ResponseQuestion>,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<ResponseRow>,
  ));
}

}


/// Adds pattern-matching-related methods to [IndividualResponseData].
extension IndividualResponseDataPatterns on IndividualResponseData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IndividualResponseData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IndividualResponseData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IndividualResponseData value)  $default,){
final _that = this;
switch (_that) {
case _IndividualResponseData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IndividualResponseData value)?  $default,){
final _that = this;
switch (_that) {
case _IndividualResponseData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'respondent_count')  int respondentCount,  bool suppressed,  String? reason,  List<ResponseQuestion> questions,  List<ResponseRow> rows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IndividualResponseData() when $default != null:
return $default(_that.surveyId,_that.title,_that.respondentCount,_that.suppressed,_that.reason,_that.questions,_that.rows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'respondent_count')  int respondentCount,  bool suppressed,  String? reason,  List<ResponseQuestion> questions,  List<ResponseRow> rows)  $default,) {final _that = this;
switch (_that) {
case _IndividualResponseData():
return $default(_that.surveyId,_that.title,_that.respondentCount,_that.suppressed,_that.reason,_that.questions,_that.rows);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'respondent_count')  int respondentCount,  bool suppressed,  String? reason,  List<ResponseQuestion> questions,  List<ResponseRow> rows)?  $default,) {final _that = this;
switch (_that) {
case _IndividualResponseData() when $default != null:
return $default(_that.surveyId,_that.title,_that.respondentCount,_that.suppressed,_that.reason,_that.questions,_that.rows);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IndividualResponseData implements IndividualResponseData {
  const _IndividualResponseData({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, @JsonKey(name: 'respondent_count') required this.respondentCount, required this.suppressed, this.reason, required final  List<ResponseQuestion> questions, required final  List<ResponseRow> rows}): _questions = questions,_rows = rows;
  factory _IndividualResponseData.fromJson(Map<String, dynamic> json) => _$IndividualResponseDataFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
@override@JsonKey(name: 'respondent_count') final  int respondentCount;
@override final  bool suppressed;
@override final  String? reason;
 final  List<ResponseQuestion> _questions;
@override List<ResponseQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  List<ResponseRow> _rows;
@override List<ResponseRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}


/// Create a copy of IndividualResponseData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IndividualResponseDataCopyWith<_IndividualResponseData> get copyWith => __$IndividualResponseDataCopyWithImpl<_IndividualResponseData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IndividualResponseDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IndividualResponseData&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.respondentCount, respondentCount) || other.respondentCount == respondentCount)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other._questions, _questions)&&const DeepCollectionEquality().equals(other._rows, _rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,respondentCount,suppressed,reason,const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_rows));

@override
String toString() {
  return 'IndividualResponseData(surveyId: $surveyId, title: $title, respondentCount: $respondentCount, suppressed: $suppressed, reason: $reason, questions: $questions, rows: $rows)';
}


}

/// @nodoc
abstract mixin class _$IndividualResponseDataCopyWith<$Res> implements $IndividualResponseDataCopyWith<$Res> {
  factory _$IndividualResponseDataCopyWith(_IndividualResponseData value, $Res Function(_IndividualResponseData) _then) = __$IndividualResponseDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'respondent_count') int respondentCount, bool suppressed, String? reason, List<ResponseQuestion> questions, List<ResponseRow> rows
});




}
/// @nodoc
class __$IndividualResponseDataCopyWithImpl<$Res>
    implements _$IndividualResponseDataCopyWith<$Res> {
  __$IndividualResponseDataCopyWithImpl(this._self, this._then);

  final _IndividualResponseData _self;
  final $Res Function(_IndividualResponseData) _then;

/// Create a copy of IndividualResponseData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? respondentCount = null,Object? suppressed = null,Object? reason = freezed,Object? questions = null,Object? rows = null,}) {
  return _then(_IndividualResponseData(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,respondentCount: null == respondentCount ? _self.respondentCount : respondentCount // ignore: cast_nullable_to_non_nullable
as int,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<ResponseQuestion>,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<ResponseRow>,
  ));
}


}


/// @nodoc
mixin _$CrossSurveyQuestion {

@JsonKey(name: 'question_id') int get questionId;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType; String? get category;@JsonKey(name: 'survey_id') int get surveyId;@JsonKey(name: 'survey_title') String get surveyTitle;@JsonKey(name: 'survey_start_date') String? get surveyStartDate;
/// Create a copy of CrossSurveyQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrossSurveyQuestionCopyWith<CrossSurveyQuestion> get copyWith => _$CrossSurveyQuestionCopyWithImpl<CrossSurveyQuestion>(this as CrossSurveyQuestion, _$identity);

  /// Serializes this CrossSurveyQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrossSurveyQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.category, category) || other.category == category)&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.surveyTitle, surveyTitle) || other.surveyTitle == surveyTitle)&&(identical(other.surveyStartDate, surveyStartDate) || other.surveyStartDate == surveyStartDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,questionContent,responseType,category,surveyId,surveyTitle,surveyStartDate);

@override
String toString() {
  return 'CrossSurveyQuestion(questionId: $questionId, questionContent: $questionContent, responseType: $responseType, category: $category, surveyId: $surveyId, surveyTitle: $surveyTitle, surveyStartDate: $surveyStartDate)';
}


}

/// @nodoc
abstract mixin class $CrossSurveyQuestionCopyWith<$Res>  {
  factory $CrossSurveyQuestionCopyWith(CrossSurveyQuestion value, $Res Function(CrossSurveyQuestion) _then) = _$CrossSurveyQuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType, String? category,@JsonKey(name: 'survey_id') int surveyId,@JsonKey(name: 'survey_title') String surveyTitle,@JsonKey(name: 'survey_start_date') String? surveyStartDate
});




}
/// @nodoc
class _$CrossSurveyQuestionCopyWithImpl<$Res>
    implements $CrossSurveyQuestionCopyWith<$Res> {
  _$CrossSurveyQuestionCopyWithImpl(this._self, this._then);

  final CrossSurveyQuestion _self;
  final $Res Function(CrossSurveyQuestion) _then;

/// Create a copy of CrossSurveyQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? questionContent = null,Object? responseType = null,Object? category = freezed,Object? surveyId = null,Object? surveyTitle = null,Object? surveyStartDate = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,surveyTitle: null == surveyTitle ? _self.surveyTitle : surveyTitle // ignore: cast_nullable_to_non_nullable
as String,surveyStartDate: freezed == surveyStartDate ? _self.surveyStartDate : surveyStartDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CrossSurveyQuestion].
extension CrossSurveyQuestionPatterns on CrossSurveyQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrossSurveyQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrossSurveyQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrossSurveyQuestion value)  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrossSurveyQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category, @JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'survey_title')  String surveyTitle, @JsonKey(name: 'survey_start_date')  String? surveyStartDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrossSurveyQuestion() when $default != null:
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category,_that.surveyId,_that.surveyTitle,_that.surveyStartDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category, @JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'survey_title')  String surveyTitle, @JsonKey(name: 'survey_start_date')  String? surveyStartDate)  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyQuestion():
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category,_that.surveyId,_that.surveyTitle,_that.surveyStartDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType,  String? category, @JsonKey(name: 'survey_id')  int surveyId, @JsonKey(name: 'survey_title')  String surveyTitle, @JsonKey(name: 'survey_start_date')  String? surveyStartDate)?  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyQuestion() when $default != null:
return $default(_that.questionId,_that.questionContent,_that.responseType,_that.category,_that.surveyId,_that.surveyTitle,_that.surveyStartDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrossSurveyQuestion implements CrossSurveyQuestion {
  const _CrossSurveyQuestion({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, this.category, @JsonKey(name: 'survey_id') required this.surveyId, @JsonKey(name: 'survey_title') required this.surveyTitle, @JsonKey(name: 'survey_start_date') this.surveyStartDate});
  factory _CrossSurveyQuestion.fromJson(Map<String, dynamic> json) => _$CrossSurveyQuestionFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override final  String? category;
@override@JsonKey(name: 'survey_id') final  int surveyId;
@override@JsonKey(name: 'survey_title') final  String surveyTitle;
@override@JsonKey(name: 'survey_start_date') final  String? surveyStartDate;

/// Create a copy of CrossSurveyQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrossSurveyQuestionCopyWith<_CrossSurveyQuestion> get copyWith => __$CrossSurveyQuestionCopyWithImpl<_CrossSurveyQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrossSurveyQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrossSurveyQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.category, category) || other.category == category)&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.surveyTitle, surveyTitle) || other.surveyTitle == surveyTitle)&&(identical(other.surveyStartDate, surveyStartDate) || other.surveyStartDate == surveyStartDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,questionContent,responseType,category,surveyId,surveyTitle,surveyStartDate);

@override
String toString() {
  return 'CrossSurveyQuestion(questionId: $questionId, questionContent: $questionContent, responseType: $responseType, category: $category, surveyId: $surveyId, surveyTitle: $surveyTitle, surveyStartDate: $surveyStartDate)';
}


}

/// @nodoc
abstract mixin class _$CrossSurveyQuestionCopyWith<$Res> implements $CrossSurveyQuestionCopyWith<$Res> {
  factory _$CrossSurveyQuestionCopyWith(_CrossSurveyQuestion value, $Res Function(_CrossSurveyQuestion) _then) = __$CrossSurveyQuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType, String? category,@JsonKey(name: 'survey_id') int surveyId,@JsonKey(name: 'survey_title') String surveyTitle,@JsonKey(name: 'survey_start_date') String? surveyStartDate
});




}
/// @nodoc
class __$CrossSurveyQuestionCopyWithImpl<$Res>
    implements _$CrossSurveyQuestionCopyWith<$Res> {
  __$CrossSurveyQuestionCopyWithImpl(this._self, this._then);

  final _CrossSurveyQuestion _self;
  final $Res Function(_CrossSurveyQuestion) _then;

/// Create a copy of CrossSurveyQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? questionContent = null,Object? responseType = null,Object? category = freezed,Object? surveyId = null,Object? surveyTitle = null,Object? surveyStartDate = freezed,}) {
  return _then(_CrossSurveyQuestion(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,surveyTitle: null == surveyTitle ? _self.surveyTitle : surveyTitle // ignore: cast_nullable_to_non_nullable
as String,surveyStartDate: freezed == surveyStartDate ? _self.surveyStartDate : surveyStartDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CrossSurveyRow {

@JsonKey(name: 'anonymous_id') String get anonymousId; Map<String, String> get responses;
/// Create a copy of CrossSurveyRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrossSurveyRowCopyWith<CrossSurveyRow> get copyWith => _$CrossSurveyRowCopyWithImpl<CrossSurveyRow>(this as CrossSurveyRow, _$identity);

  /// Serializes this CrossSurveyRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrossSurveyRow&&(identical(other.anonymousId, anonymousId) || other.anonymousId == anonymousId)&&const DeepCollectionEquality().equals(other.responses, responses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anonymousId,const DeepCollectionEquality().hash(responses));

@override
String toString() {
  return 'CrossSurveyRow(anonymousId: $anonymousId, responses: $responses)';
}


}

/// @nodoc
abstract mixin class $CrossSurveyRowCopyWith<$Res>  {
  factory $CrossSurveyRowCopyWith(CrossSurveyRow value, $Res Function(CrossSurveyRow) _then) = _$CrossSurveyRowCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'anonymous_id') String anonymousId, Map<String, String> responses
});




}
/// @nodoc
class _$CrossSurveyRowCopyWithImpl<$Res>
    implements $CrossSurveyRowCopyWith<$Res> {
  _$CrossSurveyRowCopyWithImpl(this._self, this._then);

  final CrossSurveyRow _self;
  final $Res Function(CrossSurveyRow) _then;

/// Create a copy of CrossSurveyRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anonymousId = null,Object? responses = null,}) {
  return _then(_self.copyWith(
anonymousId: null == anonymousId ? _self.anonymousId : anonymousId // ignore: cast_nullable_to_non_nullable
as String,responses: null == responses ? _self.responses : responses // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CrossSurveyRow].
extension CrossSurveyRowPatterns on CrossSurveyRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrossSurveyRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrossSurveyRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrossSurveyRow value)  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrossSurveyRow value)?  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'anonymous_id')  String anonymousId,  Map<String, String> responses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrossSurveyRow() when $default != null:
return $default(_that.anonymousId,_that.responses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'anonymous_id')  String anonymousId,  Map<String, String> responses)  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyRow():
return $default(_that.anonymousId,_that.responses);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'anonymous_id')  String anonymousId,  Map<String, String> responses)?  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyRow() when $default != null:
return $default(_that.anonymousId,_that.responses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrossSurveyRow implements CrossSurveyRow {
  const _CrossSurveyRow({@JsonKey(name: 'anonymous_id') required this.anonymousId, required final  Map<String, String> responses}): _responses = responses;
  factory _CrossSurveyRow.fromJson(Map<String, dynamic> json) => _$CrossSurveyRowFromJson(json);

@override@JsonKey(name: 'anonymous_id') final  String anonymousId;
 final  Map<String, String> _responses;
@override Map<String, String> get responses {
  if (_responses is EqualUnmodifiableMapView) return _responses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_responses);
}


/// Create a copy of CrossSurveyRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrossSurveyRowCopyWith<_CrossSurveyRow> get copyWith => __$CrossSurveyRowCopyWithImpl<_CrossSurveyRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrossSurveyRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrossSurveyRow&&(identical(other.anonymousId, anonymousId) || other.anonymousId == anonymousId)&&const DeepCollectionEquality().equals(other._responses, _responses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anonymousId,const DeepCollectionEquality().hash(_responses));

@override
String toString() {
  return 'CrossSurveyRow(anonymousId: $anonymousId, responses: $responses)';
}


}

/// @nodoc
abstract mixin class _$CrossSurveyRowCopyWith<$Res> implements $CrossSurveyRowCopyWith<$Res> {
  factory _$CrossSurveyRowCopyWith(_CrossSurveyRow value, $Res Function(_CrossSurveyRow) _then) = __$CrossSurveyRowCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'anonymous_id') String anonymousId, Map<String, String> responses
});




}
/// @nodoc
class __$CrossSurveyRowCopyWithImpl<$Res>
    implements _$CrossSurveyRowCopyWith<$Res> {
  __$CrossSurveyRowCopyWithImpl(this._self, this._then);

  final _CrossSurveyRow _self;
  final $Res Function(_CrossSurveyRow) _then;

/// Create a copy of CrossSurveyRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anonymousId = null,Object? responses = null,}) {
  return _then(_CrossSurveyRow(
anonymousId: null == anonymousId ? _self.anonymousId : anonymousId // ignore: cast_nullable_to_non_nullable
as String,responses: null == responses ? _self._responses : responses // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$CrossSurveySummary {

@JsonKey(name: 'survey_id') int get surveyId; String get title;@JsonKey(name: 'respondent_count') int get respondentCount;
/// Create a copy of CrossSurveySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrossSurveySummaryCopyWith<CrossSurveySummary> get copyWith => _$CrossSurveySummaryCopyWithImpl<CrossSurveySummary>(this as CrossSurveySummary, _$identity);

  /// Serializes this CrossSurveySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrossSurveySummary&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.respondentCount, respondentCount) || other.respondentCount == respondentCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,respondentCount);

@override
String toString() {
  return 'CrossSurveySummary(surveyId: $surveyId, title: $title, respondentCount: $respondentCount)';
}


}

/// @nodoc
abstract mixin class $CrossSurveySummaryCopyWith<$Res>  {
  factory $CrossSurveySummaryCopyWith(CrossSurveySummary value, $Res Function(CrossSurveySummary) _then) = _$CrossSurveySummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'respondent_count') int respondentCount
});




}
/// @nodoc
class _$CrossSurveySummaryCopyWithImpl<$Res>
    implements $CrossSurveySummaryCopyWith<$Res> {
  _$CrossSurveySummaryCopyWithImpl(this._self, this._then);

  final CrossSurveySummary _self;
  final $Res Function(CrossSurveySummary) _then;

/// Create a copy of CrossSurveySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyId = null,Object? title = null,Object? respondentCount = null,}) {
  return _then(_self.copyWith(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,respondentCount: null == respondentCount ? _self.respondentCount : respondentCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CrossSurveySummary].
extension CrossSurveySummaryPatterns on CrossSurveySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrossSurveySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrossSurveySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrossSurveySummary value)  $default,){
final _that = this;
switch (_that) {
case _CrossSurveySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrossSurveySummary value)?  $default,){
final _that = this;
switch (_that) {
case _CrossSurveySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'respondent_count')  int respondentCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrossSurveySummary() when $default != null:
return $default(_that.surveyId,_that.title,_that.respondentCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'respondent_count')  int respondentCount)  $default,) {final _that = this;
switch (_that) {
case _CrossSurveySummary():
return $default(_that.surveyId,_that.title,_that.respondentCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_id')  int surveyId,  String title, @JsonKey(name: 'respondent_count')  int respondentCount)?  $default,) {final _that = this;
switch (_that) {
case _CrossSurveySummary() when $default != null:
return $default(_that.surveyId,_that.title,_that.respondentCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrossSurveySummary implements CrossSurveySummary {
  const _CrossSurveySummary({@JsonKey(name: 'survey_id') required this.surveyId, required this.title, @JsonKey(name: 'respondent_count') required this.respondentCount});
  factory _CrossSurveySummary.fromJson(Map<String, dynamic> json) => _$CrossSurveySummaryFromJson(json);

@override@JsonKey(name: 'survey_id') final  int surveyId;
@override final  String title;
@override@JsonKey(name: 'respondent_count') final  int respondentCount;

/// Create a copy of CrossSurveySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrossSurveySummaryCopyWith<_CrossSurveySummary> get copyWith => __$CrossSurveySummaryCopyWithImpl<_CrossSurveySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrossSurveySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrossSurveySummary&&(identical(other.surveyId, surveyId) || other.surveyId == surveyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.respondentCount, respondentCount) || other.respondentCount == respondentCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surveyId,title,respondentCount);

@override
String toString() {
  return 'CrossSurveySummary(surveyId: $surveyId, title: $title, respondentCount: $respondentCount)';
}


}

/// @nodoc
abstract mixin class _$CrossSurveySummaryCopyWith<$Res> implements $CrossSurveySummaryCopyWith<$Res> {
  factory _$CrossSurveySummaryCopyWith(_CrossSurveySummary value, $Res Function(_CrossSurveySummary) _then) = __$CrossSurveySummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_id') int surveyId, String title,@JsonKey(name: 'respondent_count') int respondentCount
});




}
/// @nodoc
class __$CrossSurveySummaryCopyWithImpl<$Res>
    implements _$CrossSurveySummaryCopyWith<$Res> {
  __$CrossSurveySummaryCopyWithImpl(this._self, this._then);

  final _CrossSurveySummary _self;
  final $Res Function(_CrossSurveySummary) _then;

/// Create a copy of CrossSurveySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyId = null,Object? title = null,Object? respondentCount = null,}) {
  return _then(_CrossSurveySummary(
surveyId: null == surveyId ? _self.surveyId : surveyId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,respondentCount: null == respondentCount ? _self.respondentCount : respondentCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CrossSurveyOverview {

@JsonKey(name: 'survey_ids') List<int> get surveyIds; List<CrossSurveySummary> get surveys;@JsonKey(name: 'total_respondent_count') int get totalRespondentCount;@JsonKey(name: 'total_question_count') int get totalQuestionCount;@JsonKey(name: 'avg_completion_rate') double get avgCompletionRate; bool get suppressed; String? get reason;@JsonKey(name: 'min_responses') int get minResponses;
/// Create a copy of CrossSurveyOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrossSurveyOverviewCopyWith<CrossSurveyOverview> get copyWith => _$CrossSurveyOverviewCopyWithImpl<CrossSurveyOverview>(this as CrossSurveyOverview, _$identity);

  /// Serializes this CrossSurveyOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrossSurveyOverview&&const DeepCollectionEquality().equals(other.surveyIds, surveyIds)&&const DeepCollectionEquality().equals(other.surveys, surveys)&&(identical(other.totalRespondentCount, totalRespondentCount) || other.totalRespondentCount == totalRespondentCount)&&(identical(other.totalQuestionCount, totalQuestionCount) || other.totalQuestionCount == totalQuestionCount)&&(identical(other.avgCompletionRate, avgCompletionRate) || other.avgCompletionRate == avgCompletionRate)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.minResponses, minResponses) || other.minResponses == minResponses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(surveyIds),const DeepCollectionEquality().hash(surveys),totalRespondentCount,totalQuestionCount,avgCompletionRate,suppressed,reason,minResponses);

@override
String toString() {
  return 'CrossSurveyOverview(surveyIds: $surveyIds, surveys: $surveys, totalRespondentCount: $totalRespondentCount, totalQuestionCount: $totalQuestionCount, avgCompletionRate: $avgCompletionRate, suppressed: $suppressed, reason: $reason, minResponses: $minResponses)';
}


}

/// @nodoc
abstract mixin class $CrossSurveyOverviewCopyWith<$Res>  {
  factory $CrossSurveyOverviewCopyWith(CrossSurveyOverview value, $Res Function(CrossSurveyOverview) _then) = _$CrossSurveyOverviewCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_ids') List<int> surveyIds, List<CrossSurveySummary> surveys,@JsonKey(name: 'total_respondent_count') int totalRespondentCount,@JsonKey(name: 'total_question_count') int totalQuestionCount,@JsonKey(name: 'avg_completion_rate') double avgCompletionRate, bool suppressed, String? reason,@JsonKey(name: 'min_responses') int minResponses
});




}
/// @nodoc
class _$CrossSurveyOverviewCopyWithImpl<$Res>
    implements $CrossSurveyOverviewCopyWith<$Res> {
  _$CrossSurveyOverviewCopyWithImpl(this._self, this._then);

  final CrossSurveyOverview _self;
  final $Res Function(CrossSurveyOverview) _then;

/// Create a copy of CrossSurveyOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyIds = null,Object? surveys = null,Object? totalRespondentCount = null,Object? totalQuestionCount = null,Object? avgCompletionRate = null,Object? suppressed = null,Object? reason = freezed,Object? minResponses = null,}) {
  return _then(_self.copyWith(
surveyIds: null == surveyIds ? _self.surveyIds : surveyIds // ignore: cast_nullable_to_non_nullable
as List<int>,surveys: null == surveys ? _self.surveys : surveys // ignore: cast_nullable_to_non_nullable
as List<CrossSurveySummary>,totalRespondentCount: null == totalRespondentCount ? _self.totalRespondentCount : totalRespondentCount // ignore: cast_nullable_to_non_nullable
as int,totalQuestionCount: null == totalQuestionCount ? _self.totalQuestionCount : totalQuestionCount // ignore: cast_nullable_to_non_nullable
as int,avgCompletionRate: null == avgCompletionRate ? _self.avgCompletionRate : avgCompletionRate // ignore: cast_nullable_to_non_nullable
as double,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,minResponses: null == minResponses ? _self.minResponses : minResponses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CrossSurveyOverview].
extension CrossSurveyOverviewPatterns on CrossSurveyOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrossSurveyOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrossSurveyOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrossSurveyOverview value)  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrossSurveyOverview value)?  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_ids')  List<int> surveyIds,  List<CrossSurveySummary> surveys, @JsonKey(name: 'total_respondent_count')  int totalRespondentCount, @JsonKey(name: 'total_question_count')  int totalQuestionCount, @JsonKey(name: 'avg_completion_rate')  double avgCompletionRate,  bool suppressed,  String? reason, @JsonKey(name: 'min_responses')  int minResponses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrossSurveyOverview() when $default != null:
return $default(_that.surveyIds,_that.surveys,_that.totalRespondentCount,_that.totalQuestionCount,_that.avgCompletionRate,_that.suppressed,_that.reason,_that.minResponses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_ids')  List<int> surveyIds,  List<CrossSurveySummary> surveys, @JsonKey(name: 'total_respondent_count')  int totalRespondentCount, @JsonKey(name: 'total_question_count')  int totalQuestionCount, @JsonKey(name: 'avg_completion_rate')  double avgCompletionRate,  bool suppressed,  String? reason, @JsonKey(name: 'min_responses')  int minResponses)  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyOverview():
return $default(_that.surveyIds,_that.surveys,_that.totalRespondentCount,_that.totalQuestionCount,_that.avgCompletionRate,_that.suppressed,_that.reason,_that.minResponses);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_ids')  List<int> surveyIds,  List<CrossSurveySummary> surveys, @JsonKey(name: 'total_respondent_count')  int totalRespondentCount, @JsonKey(name: 'total_question_count')  int totalQuestionCount, @JsonKey(name: 'avg_completion_rate')  double avgCompletionRate,  bool suppressed,  String? reason, @JsonKey(name: 'min_responses')  int minResponses)?  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyOverview() when $default != null:
return $default(_that.surveyIds,_that.surveys,_that.totalRespondentCount,_that.totalQuestionCount,_that.avgCompletionRate,_that.suppressed,_that.reason,_that.minResponses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrossSurveyOverview implements CrossSurveyOverview {
  const _CrossSurveyOverview({@JsonKey(name: 'survey_ids') required final  List<int> surveyIds, required final  List<CrossSurveySummary> surveys, @JsonKey(name: 'total_respondent_count') required this.totalRespondentCount, @JsonKey(name: 'total_question_count') required this.totalQuestionCount, @JsonKey(name: 'avg_completion_rate') required this.avgCompletionRate, required this.suppressed, this.reason, @JsonKey(name: 'min_responses') this.minResponses = 5}): _surveyIds = surveyIds,_surveys = surveys;
  factory _CrossSurveyOverview.fromJson(Map<String, dynamic> json) => _$CrossSurveyOverviewFromJson(json);

 final  List<int> _surveyIds;
@override@JsonKey(name: 'survey_ids') List<int> get surveyIds {
  if (_surveyIds is EqualUnmodifiableListView) return _surveyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surveyIds);
}

 final  List<CrossSurveySummary> _surveys;
@override List<CrossSurveySummary> get surveys {
  if (_surveys is EqualUnmodifiableListView) return _surveys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surveys);
}

@override@JsonKey(name: 'total_respondent_count') final  int totalRespondentCount;
@override@JsonKey(name: 'total_question_count') final  int totalQuestionCount;
@override@JsonKey(name: 'avg_completion_rate') final  double avgCompletionRate;
@override final  bool suppressed;
@override final  String? reason;
@override@JsonKey(name: 'min_responses') final  int minResponses;

/// Create a copy of CrossSurveyOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrossSurveyOverviewCopyWith<_CrossSurveyOverview> get copyWith => __$CrossSurveyOverviewCopyWithImpl<_CrossSurveyOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrossSurveyOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrossSurveyOverview&&const DeepCollectionEquality().equals(other._surveyIds, _surveyIds)&&const DeepCollectionEquality().equals(other._surveys, _surveys)&&(identical(other.totalRespondentCount, totalRespondentCount) || other.totalRespondentCount == totalRespondentCount)&&(identical(other.totalQuestionCount, totalQuestionCount) || other.totalQuestionCount == totalQuestionCount)&&(identical(other.avgCompletionRate, avgCompletionRate) || other.avgCompletionRate == avgCompletionRate)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.minResponses, minResponses) || other.minResponses == minResponses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_surveyIds),const DeepCollectionEquality().hash(_surveys),totalRespondentCount,totalQuestionCount,avgCompletionRate,suppressed,reason,minResponses);

@override
String toString() {
  return 'CrossSurveyOverview(surveyIds: $surveyIds, surveys: $surveys, totalRespondentCount: $totalRespondentCount, totalQuestionCount: $totalQuestionCount, avgCompletionRate: $avgCompletionRate, suppressed: $suppressed, reason: $reason, minResponses: $minResponses)';
}


}

/// @nodoc
abstract mixin class _$CrossSurveyOverviewCopyWith<$Res> implements $CrossSurveyOverviewCopyWith<$Res> {
  factory _$CrossSurveyOverviewCopyWith(_CrossSurveyOverview value, $Res Function(_CrossSurveyOverview) _then) = __$CrossSurveyOverviewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_ids') List<int> surveyIds, List<CrossSurveySummary> surveys,@JsonKey(name: 'total_respondent_count') int totalRespondentCount,@JsonKey(name: 'total_question_count') int totalQuestionCount,@JsonKey(name: 'avg_completion_rate') double avgCompletionRate, bool suppressed, String? reason,@JsonKey(name: 'min_responses') int minResponses
});




}
/// @nodoc
class __$CrossSurveyOverviewCopyWithImpl<$Res>
    implements _$CrossSurveyOverviewCopyWith<$Res> {
  __$CrossSurveyOverviewCopyWithImpl(this._self, this._then);

  final _CrossSurveyOverview _self;
  final $Res Function(_CrossSurveyOverview) _then;

/// Create a copy of CrossSurveyOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyIds = null,Object? surveys = null,Object? totalRespondentCount = null,Object? totalQuestionCount = null,Object? avgCompletionRate = null,Object? suppressed = null,Object? reason = freezed,Object? minResponses = null,}) {
  return _then(_CrossSurveyOverview(
surveyIds: null == surveyIds ? _self._surveyIds : surveyIds // ignore: cast_nullable_to_non_nullable
as List<int>,surveys: null == surveys ? _self._surveys : surveys // ignore: cast_nullable_to_non_nullable
as List<CrossSurveySummary>,totalRespondentCount: null == totalRespondentCount ? _self.totalRespondentCount : totalRespondentCount // ignore: cast_nullable_to_non_nullable
as int,totalQuestionCount: null == totalQuestionCount ? _self.totalQuestionCount : totalQuestionCount // ignore: cast_nullable_to_non_nullable
as int,avgCompletionRate: null == avgCompletionRate ? _self.avgCompletionRate : avgCompletionRate // ignore: cast_nullable_to_non_nullable
as double,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,minResponses: null == minResponses ? _self.minResponses : minResponses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CrossSurveyAggregateResponse {

@JsonKey(name: 'survey_ids') List<int> get surveyIds;@JsonKey(name: 'total_respondents') int get totalRespondents; List<QuestionAggregate> get aggregates;
/// Create a copy of CrossSurveyAggregateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrossSurveyAggregateResponseCopyWith<CrossSurveyAggregateResponse> get copyWith => _$CrossSurveyAggregateResponseCopyWithImpl<CrossSurveyAggregateResponse>(this as CrossSurveyAggregateResponse, _$identity);

  /// Serializes this CrossSurveyAggregateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrossSurveyAggregateResponse&&const DeepCollectionEquality().equals(other.surveyIds, surveyIds)&&(identical(other.totalRespondents, totalRespondents) || other.totalRespondents == totalRespondents)&&const DeepCollectionEquality().equals(other.aggregates, aggregates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(surveyIds),totalRespondents,const DeepCollectionEquality().hash(aggregates));

@override
String toString() {
  return 'CrossSurveyAggregateResponse(surveyIds: $surveyIds, totalRespondents: $totalRespondents, aggregates: $aggregates)';
}


}

/// @nodoc
abstract mixin class $CrossSurveyAggregateResponseCopyWith<$Res>  {
  factory $CrossSurveyAggregateResponseCopyWith(CrossSurveyAggregateResponse value, $Res Function(CrossSurveyAggregateResponse) _then) = _$CrossSurveyAggregateResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_ids') List<int> surveyIds,@JsonKey(name: 'total_respondents') int totalRespondents, List<QuestionAggregate> aggregates
});




}
/// @nodoc
class _$CrossSurveyAggregateResponseCopyWithImpl<$Res>
    implements $CrossSurveyAggregateResponseCopyWith<$Res> {
  _$CrossSurveyAggregateResponseCopyWithImpl(this._self, this._then);

  final CrossSurveyAggregateResponse _self;
  final $Res Function(CrossSurveyAggregateResponse) _then;

/// Create a copy of CrossSurveyAggregateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyIds = null,Object? totalRespondents = null,Object? aggregates = null,}) {
  return _then(_self.copyWith(
surveyIds: null == surveyIds ? _self.surveyIds : surveyIds // ignore: cast_nullable_to_non_nullable
as List<int>,totalRespondents: null == totalRespondents ? _self.totalRespondents : totalRespondents // ignore: cast_nullable_to_non_nullable
as int,aggregates: null == aggregates ? _self.aggregates : aggregates // ignore: cast_nullable_to_non_nullable
as List<QuestionAggregate>,
  ));
}

}


/// Adds pattern-matching-related methods to [CrossSurveyAggregateResponse].
extension CrossSurveyAggregateResponsePatterns on CrossSurveyAggregateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrossSurveyAggregateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrossSurveyAggregateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrossSurveyAggregateResponse value)  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyAggregateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrossSurveyAggregateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyAggregateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_ids')  List<int> surveyIds, @JsonKey(name: 'total_respondents')  int totalRespondents,  List<QuestionAggregate> aggregates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrossSurveyAggregateResponse() when $default != null:
return $default(_that.surveyIds,_that.totalRespondents,_that.aggregates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_ids')  List<int> surveyIds, @JsonKey(name: 'total_respondents')  int totalRespondents,  List<QuestionAggregate> aggregates)  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyAggregateResponse():
return $default(_that.surveyIds,_that.totalRespondents,_that.aggregates);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_ids')  List<int> surveyIds, @JsonKey(name: 'total_respondents')  int totalRespondents,  List<QuestionAggregate> aggregates)?  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyAggregateResponse() when $default != null:
return $default(_that.surveyIds,_that.totalRespondents,_that.aggregates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrossSurveyAggregateResponse implements CrossSurveyAggregateResponse {
  const _CrossSurveyAggregateResponse({@JsonKey(name: 'survey_ids') required final  List<int> surveyIds, @JsonKey(name: 'total_respondents') required this.totalRespondents, required final  List<QuestionAggregate> aggregates}): _surveyIds = surveyIds,_aggregates = aggregates;
  factory _CrossSurveyAggregateResponse.fromJson(Map<String, dynamic> json) => _$CrossSurveyAggregateResponseFromJson(json);

 final  List<int> _surveyIds;
@override@JsonKey(name: 'survey_ids') List<int> get surveyIds {
  if (_surveyIds is EqualUnmodifiableListView) return _surveyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surveyIds);
}

@override@JsonKey(name: 'total_respondents') final  int totalRespondents;
 final  List<QuestionAggregate> _aggregates;
@override List<QuestionAggregate> get aggregates {
  if (_aggregates is EqualUnmodifiableListView) return _aggregates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aggregates);
}


/// Create a copy of CrossSurveyAggregateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrossSurveyAggregateResponseCopyWith<_CrossSurveyAggregateResponse> get copyWith => __$CrossSurveyAggregateResponseCopyWithImpl<_CrossSurveyAggregateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrossSurveyAggregateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrossSurveyAggregateResponse&&const DeepCollectionEquality().equals(other._surveyIds, _surveyIds)&&(identical(other.totalRespondents, totalRespondents) || other.totalRespondents == totalRespondents)&&const DeepCollectionEquality().equals(other._aggregates, _aggregates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_surveyIds),totalRespondents,const DeepCollectionEquality().hash(_aggregates));

@override
String toString() {
  return 'CrossSurveyAggregateResponse(surveyIds: $surveyIds, totalRespondents: $totalRespondents, aggregates: $aggregates)';
}


}

/// @nodoc
abstract mixin class _$CrossSurveyAggregateResponseCopyWith<$Res> implements $CrossSurveyAggregateResponseCopyWith<$Res> {
  factory _$CrossSurveyAggregateResponseCopyWith(_CrossSurveyAggregateResponse value, $Res Function(_CrossSurveyAggregateResponse) _then) = __$CrossSurveyAggregateResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_ids') List<int> surveyIds,@JsonKey(name: 'total_respondents') int totalRespondents, List<QuestionAggregate> aggregates
});




}
/// @nodoc
class __$CrossSurveyAggregateResponseCopyWithImpl<$Res>
    implements _$CrossSurveyAggregateResponseCopyWith<$Res> {
  __$CrossSurveyAggregateResponseCopyWithImpl(this._self, this._then);

  final _CrossSurveyAggregateResponse _self;
  final $Res Function(_CrossSurveyAggregateResponse) _then;

/// Create a copy of CrossSurveyAggregateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyIds = null,Object? totalRespondents = null,Object? aggregates = null,}) {
  return _then(_CrossSurveyAggregateResponse(
surveyIds: null == surveyIds ? _self._surveyIds : surveyIds // ignore: cast_nullable_to_non_nullable
as List<int>,totalRespondents: null == totalRespondents ? _self.totalRespondents : totalRespondents // ignore: cast_nullable_to_non_nullable
as int,aggregates: null == aggregates ? _self._aggregates : aggregates // ignore: cast_nullable_to_non_nullable
as List<QuestionAggregate>,
  ));
}


}


/// @nodoc
mixin _$CrossSurveyResponseData {

@JsonKey(name: 'survey_ids') List<int> get surveyIds; List<CrossSurveySummary> get surveys;@JsonKey(name: 'total_respondent_count') int get totalRespondentCount;@JsonKey(name: 'date_from') String? get dateFrom;@JsonKey(name: 'date_to') String? get dateTo; bool get suppressed; String? get reason;@JsonKey(name: 'suppressed_surveys') List<int> get suppressedSurveys; List<CrossSurveyQuestion> get questions; List<CrossSurveyRow> get rows;
/// Create a copy of CrossSurveyResponseData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrossSurveyResponseDataCopyWith<CrossSurveyResponseData> get copyWith => _$CrossSurveyResponseDataCopyWithImpl<CrossSurveyResponseData>(this as CrossSurveyResponseData, _$identity);

  /// Serializes this CrossSurveyResponseData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrossSurveyResponseData&&const DeepCollectionEquality().equals(other.surveyIds, surveyIds)&&const DeepCollectionEquality().equals(other.surveys, surveys)&&(identical(other.totalRespondentCount, totalRespondentCount) || other.totalRespondentCount == totalRespondentCount)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.suppressedSurveys, suppressedSurveys)&&const DeepCollectionEquality().equals(other.questions, questions)&&const DeepCollectionEquality().equals(other.rows, rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(surveyIds),const DeepCollectionEquality().hash(surveys),totalRespondentCount,dateFrom,dateTo,suppressed,reason,const DeepCollectionEquality().hash(suppressedSurveys),const DeepCollectionEquality().hash(questions),const DeepCollectionEquality().hash(rows));

@override
String toString() {
  return 'CrossSurveyResponseData(surveyIds: $surveyIds, surveys: $surveys, totalRespondentCount: $totalRespondentCount, dateFrom: $dateFrom, dateTo: $dateTo, suppressed: $suppressed, reason: $reason, suppressedSurveys: $suppressedSurveys, questions: $questions, rows: $rows)';
}


}

/// @nodoc
abstract mixin class $CrossSurveyResponseDataCopyWith<$Res>  {
  factory $CrossSurveyResponseDataCopyWith(CrossSurveyResponseData value, $Res Function(CrossSurveyResponseData) _then) = _$CrossSurveyResponseDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'survey_ids') List<int> surveyIds, List<CrossSurveySummary> surveys,@JsonKey(name: 'total_respondent_count') int totalRespondentCount,@JsonKey(name: 'date_from') String? dateFrom,@JsonKey(name: 'date_to') String? dateTo, bool suppressed, String? reason,@JsonKey(name: 'suppressed_surveys') List<int> suppressedSurveys, List<CrossSurveyQuestion> questions, List<CrossSurveyRow> rows
});




}
/// @nodoc
class _$CrossSurveyResponseDataCopyWithImpl<$Res>
    implements $CrossSurveyResponseDataCopyWith<$Res> {
  _$CrossSurveyResponseDataCopyWithImpl(this._self, this._then);

  final CrossSurveyResponseData _self;
  final $Res Function(CrossSurveyResponseData) _then;

/// Create a copy of CrossSurveyResponseData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surveyIds = null,Object? surveys = null,Object? totalRespondentCount = null,Object? dateFrom = freezed,Object? dateTo = freezed,Object? suppressed = null,Object? reason = freezed,Object? suppressedSurveys = null,Object? questions = null,Object? rows = null,}) {
  return _then(_self.copyWith(
surveyIds: null == surveyIds ? _self.surveyIds : surveyIds // ignore: cast_nullable_to_non_nullable
as List<int>,surveys: null == surveys ? _self.surveys : surveys // ignore: cast_nullable_to_non_nullable
as List<CrossSurveySummary>,totalRespondentCount: null == totalRespondentCount ? _self.totalRespondentCount : totalRespondentCount // ignore: cast_nullable_to_non_nullable
as int,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String?,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,suppressedSurveys: null == suppressedSurveys ? _self.suppressedSurveys : suppressedSurveys // ignore: cast_nullable_to_non_nullable
as List<int>,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<CrossSurveyQuestion>,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<CrossSurveyRow>,
  ));
}

}


/// Adds pattern-matching-related methods to [CrossSurveyResponseData].
extension CrossSurveyResponseDataPatterns on CrossSurveyResponseData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrossSurveyResponseData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrossSurveyResponseData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrossSurveyResponseData value)  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyResponseData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrossSurveyResponseData value)?  $default,){
final _that = this;
switch (_that) {
case _CrossSurveyResponseData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_ids')  List<int> surveyIds,  List<CrossSurveySummary> surveys, @JsonKey(name: 'total_respondent_count')  int totalRespondentCount, @JsonKey(name: 'date_from')  String? dateFrom, @JsonKey(name: 'date_to')  String? dateTo,  bool suppressed,  String? reason, @JsonKey(name: 'suppressed_surveys')  List<int> suppressedSurveys,  List<CrossSurveyQuestion> questions,  List<CrossSurveyRow> rows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrossSurveyResponseData() when $default != null:
return $default(_that.surveyIds,_that.surveys,_that.totalRespondentCount,_that.dateFrom,_that.dateTo,_that.suppressed,_that.reason,_that.suppressedSurveys,_that.questions,_that.rows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'survey_ids')  List<int> surveyIds,  List<CrossSurveySummary> surveys, @JsonKey(name: 'total_respondent_count')  int totalRespondentCount, @JsonKey(name: 'date_from')  String? dateFrom, @JsonKey(name: 'date_to')  String? dateTo,  bool suppressed,  String? reason, @JsonKey(name: 'suppressed_surveys')  List<int> suppressedSurveys,  List<CrossSurveyQuestion> questions,  List<CrossSurveyRow> rows)  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyResponseData():
return $default(_that.surveyIds,_that.surveys,_that.totalRespondentCount,_that.dateFrom,_that.dateTo,_that.suppressed,_that.reason,_that.suppressedSurveys,_that.questions,_that.rows);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'survey_ids')  List<int> surveyIds,  List<CrossSurveySummary> surveys, @JsonKey(name: 'total_respondent_count')  int totalRespondentCount, @JsonKey(name: 'date_from')  String? dateFrom, @JsonKey(name: 'date_to')  String? dateTo,  bool suppressed,  String? reason, @JsonKey(name: 'suppressed_surveys')  List<int> suppressedSurveys,  List<CrossSurveyQuestion> questions,  List<CrossSurveyRow> rows)?  $default,) {final _that = this;
switch (_that) {
case _CrossSurveyResponseData() when $default != null:
return $default(_that.surveyIds,_that.surveys,_that.totalRespondentCount,_that.dateFrom,_that.dateTo,_that.suppressed,_that.reason,_that.suppressedSurveys,_that.questions,_that.rows);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrossSurveyResponseData implements CrossSurveyResponseData {
  const _CrossSurveyResponseData({@JsonKey(name: 'survey_ids') required final  List<int> surveyIds, required final  List<CrossSurveySummary> surveys, @JsonKey(name: 'total_respondent_count') required this.totalRespondentCount, @JsonKey(name: 'date_from') this.dateFrom, @JsonKey(name: 'date_to') this.dateTo, required this.suppressed, this.reason, @JsonKey(name: 'suppressed_surveys') final  List<int> suppressedSurveys = const [], required final  List<CrossSurveyQuestion> questions, required final  List<CrossSurveyRow> rows}): _surveyIds = surveyIds,_surveys = surveys,_suppressedSurveys = suppressedSurveys,_questions = questions,_rows = rows;
  factory _CrossSurveyResponseData.fromJson(Map<String, dynamic> json) => _$CrossSurveyResponseDataFromJson(json);

 final  List<int> _surveyIds;
@override@JsonKey(name: 'survey_ids') List<int> get surveyIds {
  if (_surveyIds is EqualUnmodifiableListView) return _surveyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surveyIds);
}

 final  List<CrossSurveySummary> _surveys;
@override List<CrossSurveySummary> get surveys {
  if (_surveys is EqualUnmodifiableListView) return _surveys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surveys);
}

@override@JsonKey(name: 'total_respondent_count') final  int totalRespondentCount;
@override@JsonKey(name: 'date_from') final  String? dateFrom;
@override@JsonKey(name: 'date_to') final  String? dateTo;
@override final  bool suppressed;
@override final  String? reason;
 final  List<int> _suppressedSurveys;
@override@JsonKey(name: 'suppressed_surveys') List<int> get suppressedSurveys {
  if (_suppressedSurveys is EqualUnmodifiableListView) return _suppressedSurveys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suppressedSurveys);
}

 final  List<CrossSurveyQuestion> _questions;
@override List<CrossSurveyQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  List<CrossSurveyRow> _rows;
@override List<CrossSurveyRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}


/// Create a copy of CrossSurveyResponseData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrossSurveyResponseDataCopyWith<_CrossSurveyResponseData> get copyWith => __$CrossSurveyResponseDataCopyWithImpl<_CrossSurveyResponseData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrossSurveyResponseDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrossSurveyResponseData&&const DeepCollectionEquality().equals(other._surveyIds, _surveyIds)&&const DeepCollectionEquality().equals(other._surveys, _surveys)&&(identical(other.totalRespondentCount, totalRespondentCount) || other.totalRespondentCount == totalRespondentCount)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.suppressed, suppressed) || other.suppressed == suppressed)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other._suppressedSurveys, _suppressedSurveys)&&const DeepCollectionEquality().equals(other._questions, _questions)&&const DeepCollectionEquality().equals(other._rows, _rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_surveyIds),const DeepCollectionEquality().hash(_surveys),totalRespondentCount,dateFrom,dateTo,suppressed,reason,const DeepCollectionEquality().hash(_suppressedSurveys),const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_rows));

@override
String toString() {
  return 'CrossSurveyResponseData(surveyIds: $surveyIds, surveys: $surveys, totalRespondentCount: $totalRespondentCount, dateFrom: $dateFrom, dateTo: $dateTo, suppressed: $suppressed, reason: $reason, suppressedSurveys: $suppressedSurveys, questions: $questions, rows: $rows)';
}


}

/// @nodoc
abstract mixin class _$CrossSurveyResponseDataCopyWith<$Res> implements $CrossSurveyResponseDataCopyWith<$Res> {
  factory _$CrossSurveyResponseDataCopyWith(_CrossSurveyResponseData value, $Res Function(_CrossSurveyResponseData) _then) = __$CrossSurveyResponseDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'survey_ids') List<int> surveyIds, List<CrossSurveySummary> surveys,@JsonKey(name: 'total_respondent_count') int totalRespondentCount,@JsonKey(name: 'date_from') String? dateFrom,@JsonKey(name: 'date_to') String? dateTo, bool suppressed, String? reason,@JsonKey(name: 'suppressed_surveys') List<int> suppressedSurveys, List<CrossSurveyQuestion> questions, List<CrossSurveyRow> rows
});




}
/// @nodoc
class __$CrossSurveyResponseDataCopyWithImpl<$Res>
    implements _$CrossSurveyResponseDataCopyWith<$Res> {
  __$CrossSurveyResponseDataCopyWithImpl(this._self, this._then);

  final _CrossSurveyResponseData _self;
  final $Res Function(_CrossSurveyResponseData) _then;

/// Create a copy of CrossSurveyResponseData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surveyIds = null,Object? surveys = null,Object? totalRespondentCount = null,Object? dateFrom = freezed,Object? dateTo = freezed,Object? suppressed = null,Object? reason = freezed,Object? suppressedSurveys = null,Object? questions = null,Object? rows = null,}) {
  return _then(_CrossSurveyResponseData(
surveyIds: null == surveyIds ? _self._surveyIds : surveyIds // ignore: cast_nullable_to_non_nullable
as List<int>,surveys: null == surveys ? _self._surveys : surveys // ignore: cast_nullable_to_non_nullable
as List<CrossSurveySummary>,totalRespondentCount: null == totalRespondentCount ? _self.totalRespondentCount : totalRespondentCount // ignore: cast_nullable_to_non_nullable
as int,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String?,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,suppressedSurveys: null == suppressedSurveys ? _self._suppressedSurveys : suppressedSurveys // ignore: cast_nullable_to_non_nullable
as List<int>,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<CrossSurveyQuestion>,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<CrossSurveyRow>,
  ));
}


}

// dart format on
