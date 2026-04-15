// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TemplateQuestionLinkCreate {

@JsonKey(name: 'question_id') int get questionId;@JsonKey(name: 'is_required') bool get isRequired;
/// Create a copy of TemplateQuestionLinkCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateQuestionLinkCreateCopyWith<TemplateQuestionLinkCreate> get copyWith => _$TemplateQuestionLinkCreateCopyWithImpl<TemplateQuestionLinkCreate>(this as TemplateQuestionLinkCreate, _$identity);

  /// Serializes this TemplateQuestionLinkCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateQuestionLinkCreate&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,isRequired);

@override
String toString() {
  return 'TemplateQuestionLinkCreate(questionId: $questionId, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class $TemplateQuestionLinkCreateCopyWith<$Res>  {
  factory $TemplateQuestionLinkCreateCopyWith(TemplateQuestionLinkCreate value, $Res Function(TemplateQuestionLinkCreate) _then) = _$TemplateQuestionLinkCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'is_required') bool isRequired
});




}
/// @nodoc
class _$TemplateQuestionLinkCreateCopyWithImpl<$Res>
    implements $TemplateQuestionLinkCreateCopyWith<$Res> {
  _$TemplateQuestionLinkCreateCopyWithImpl(this._self, this._then);

  final TemplateQuestionLinkCreate _self;
  final $Res Function(TemplateQuestionLinkCreate) _then;

/// Create a copy of TemplateQuestionLinkCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? isRequired = null,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateQuestionLinkCreate].
extension TemplateQuestionLinkCreatePatterns on TemplateQuestionLinkCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateQuestionLinkCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateQuestionLinkCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateQuestionLinkCreate value)  $default,){
final _that = this;
switch (_that) {
case _TemplateQuestionLinkCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateQuestionLinkCreate value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateQuestionLinkCreate() when $default != null:
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
case _TemplateQuestionLinkCreate() when $default != null:
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
case _TemplateQuestionLinkCreate():
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
case _TemplateQuestionLinkCreate() when $default != null:
return $default(_that.questionId,_that.isRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateQuestionLinkCreate implements TemplateQuestionLinkCreate {
  const _TemplateQuestionLinkCreate({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'is_required') this.isRequired = false});
  factory _TemplateQuestionLinkCreate.fromJson(Map<String, dynamic> json) => _$TemplateQuestionLinkCreateFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override@JsonKey(name: 'is_required') final  bool isRequired;

/// Create a copy of TemplateQuestionLinkCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateQuestionLinkCreateCopyWith<_TemplateQuestionLinkCreate> get copyWith => __$TemplateQuestionLinkCreateCopyWithImpl<_TemplateQuestionLinkCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateQuestionLinkCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateQuestionLinkCreate&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,isRequired);

@override
String toString() {
  return 'TemplateQuestionLinkCreate(questionId: $questionId, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class _$TemplateQuestionLinkCreateCopyWith<$Res> implements $TemplateQuestionLinkCreateCopyWith<$Res> {
  factory _$TemplateQuestionLinkCreateCopyWith(_TemplateQuestionLinkCreate value, $Res Function(_TemplateQuestionLinkCreate) _then) = __$TemplateQuestionLinkCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId,@JsonKey(name: 'is_required') bool isRequired
});




}
/// @nodoc
class __$TemplateQuestionLinkCreateCopyWithImpl<$Res>
    implements _$TemplateQuestionLinkCreateCopyWith<$Res> {
  __$TemplateQuestionLinkCreateCopyWithImpl(this._self, this._then);

  final _TemplateQuestionLinkCreate _self;
  final $Res Function(_TemplateQuestionLinkCreate) _then;

/// Create a copy of TemplateQuestionLinkCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? isRequired = null,}) {
  return _then(_TemplateQuestionLinkCreate(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TemplateCreate {

 String get title; String? get description;@JsonKey(name: 'is_public') bool get isPublic;@JsonKey(name: 'question_ids') List<int>? get questionIds; List<TemplateQuestionLinkCreate>? get questions;
/// Create a copy of TemplateCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateCreateCopyWith<TemplateCreate> get copyWith => _$TemplateCreateCopyWithImpl<TemplateCreate>(this as TemplateCreate, _$identity);

  /// Serializes this TemplateCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other.questionIds, questionIds)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,isPublic,const DeepCollectionEquality().hash(questionIds),const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'TemplateCreate(title: $title, description: $description, isPublic: $isPublic, questionIds: $questionIds, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $TemplateCreateCopyWith<$Res>  {
  factory $TemplateCreateCopyWith(TemplateCreate value, $Res Function(TemplateCreate) _then) = _$TemplateCreateCopyWithImpl;
@useResult
$Res call({
 String title, String? description,@JsonKey(name: 'is_public') bool isPublic,@JsonKey(name: 'question_ids') List<int>? questionIds, List<TemplateQuestionLinkCreate>? questions
});




}
/// @nodoc
class _$TemplateCreateCopyWithImpl<$Res>
    implements $TemplateCreateCopyWith<$Res> {
  _$TemplateCreateCopyWithImpl(this._self, this._then);

  final TemplateCreate _self;
  final $Res Function(TemplateCreate) _then;

/// Create a copy of TemplateCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? isPublic = null,Object? questionIds = freezed,Object? questions = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,questionIds: freezed == questionIds ? _self.questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,questions: freezed == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<TemplateQuestionLinkCreate>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateCreate].
extension TemplateCreatePatterns on TemplateCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateCreate value)  $default,){
final _that = this;
switch (_that) {
case _TemplateCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateCreate value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(name: 'is_public')  bool isPublic, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<TemplateQuestionLinkCreate>? questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateCreate() when $default != null:
return $default(_that.title,_that.description,_that.isPublic,_that.questionIds,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(name: 'is_public')  bool isPublic, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<TemplateQuestionLinkCreate>? questions)  $default,) {final _that = this;
switch (_that) {
case _TemplateCreate():
return $default(_that.title,_that.description,_that.isPublic,_that.questionIds,_that.questions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description, @JsonKey(name: 'is_public')  bool isPublic, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<TemplateQuestionLinkCreate>? questions)?  $default,) {final _that = this;
switch (_that) {
case _TemplateCreate() when $default != null:
return $default(_that.title,_that.description,_that.isPublic,_that.questionIds,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateCreate implements TemplateCreate {
  const _TemplateCreate({required this.title, this.description, @JsonKey(name: 'is_public') this.isPublic = false, @JsonKey(name: 'question_ids') final  List<int>? questionIds, final  List<TemplateQuestionLinkCreate>? questions}): _questionIds = questionIds,_questions = questions;
  factory _TemplateCreate.fromJson(Map<String, dynamic> json) => _$TemplateCreateFromJson(json);

@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'is_public') final  bool isPublic;
 final  List<int>? _questionIds;
@override@JsonKey(name: 'question_ids') List<int>? get questionIds {
  final value = _questionIds;
  if (value == null) return null;
  if (_questionIds is EqualUnmodifiableListView) return _questionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<TemplateQuestionLinkCreate>? _questions;
@override List<TemplateQuestionLinkCreate>? get questions {
  final value = _questions;
  if (value == null) return null;
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TemplateCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateCreateCopyWith<_TemplateCreate> get copyWith => __$TemplateCreateCopyWithImpl<_TemplateCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other._questionIds, _questionIds)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,isPublic,const DeepCollectionEquality().hash(_questionIds),const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'TemplateCreate(title: $title, description: $description, isPublic: $isPublic, questionIds: $questionIds, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$TemplateCreateCopyWith<$Res> implements $TemplateCreateCopyWith<$Res> {
  factory _$TemplateCreateCopyWith(_TemplateCreate value, $Res Function(_TemplateCreate) _then) = __$TemplateCreateCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description,@JsonKey(name: 'is_public') bool isPublic,@JsonKey(name: 'question_ids') List<int>? questionIds, List<TemplateQuestionLinkCreate>? questions
});




}
/// @nodoc
class __$TemplateCreateCopyWithImpl<$Res>
    implements _$TemplateCreateCopyWith<$Res> {
  __$TemplateCreateCopyWithImpl(this._self, this._then);

  final _TemplateCreate _self;
  final $Res Function(_TemplateCreate) _then;

/// Create a copy of TemplateCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? isPublic = null,Object? questionIds = freezed,Object? questions = freezed,}) {
  return _then(_TemplateCreate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,questionIds: freezed == questionIds ? _self._questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,questions: freezed == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<TemplateQuestionLinkCreate>?,
  ));
}


}


/// @nodoc
mixin _$TemplateUpdate {

 String? get title; String? get description;@JsonKey(name: 'is_public') bool? get isPublic;@JsonKey(name: 'question_ids') List<int>? get questionIds; List<TemplateQuestionLinkCreate>? get questions;
/// Create a copy of TemplateUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateUpdateCopyWith<TemplateUpdate> get copyWith => _$TemplateUpdateCopyWithImpl<TemplateUpdate>(this as TemplateUpdate, _$identity);

  /// Serializes this TemplateUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateUpdate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other.questionIds, questionIds)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,isPublic,const DeepCollectionEquality().hash(questionIds),const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'TemplateUpdate(title: $title, description: $description, isPublic: $isPublic, questionIds: $questionIds, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $TemplateUpdateCopyWith<$Res>  {
  factory $TemplateUpdateCopyWith(TemplateUpdate value, $Res Function(TemplateUpdate) _then) = _$TemplateUpdateCopyWithImpl;
@useResult
$Res call({
 String? title, String? description,@JsonKey(name: 'is_public') bool? isPublic,@JsonKey(name: 'question_ids') List<int>? questionIds, List<TemplateQuestionLinkCreate>? questions
});




}
/// @nodoc
class _$TemplateUpdateCopyWithImpl<$Res>
    implements $TemplateUpdateCopyWith<$Res> {
  _$TemplateUpdateCopyWithImpl(this._self, this._then);

  final TemplateUpdate _self;
  final $Res Function(TemplateUpdate) _then;

/// Create a copy of TemplateUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? isPublic = freezed,Object? questionIds = freezed,Object? questions = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isPublic: freezed == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool?,questionIds: freezed == questionIds ? _self.questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,questions: freezed == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<TemplateQuestionLinkCreate>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateUpdate].
extension TemplateUpdatePatterns on TemplateUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateUpdate value)  $default,){
final _that = this;
switch (_that) {
case _TemplateUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description, @JsonKey(name: 'is_public')  bool? isPublic, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<TemplateQuestionLinkCreate>? questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateUpdate() when $default != null:
return $default(_that.title,_that.description,_that.isPublic,_that.questionIds,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description, @JsonKey(name: 'is_public')  bool? isPublic, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<TemplateQuestionLinkCreate>? questions)  $default,) {final _that = this;
switch (_that) {
case _TemplateUpdate():
return $default(_that.title,_that.description,_that.isPublic,_that.questionIds,_that.questions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description, @JsonKey(name: 'is_public')  bool? isPublic, @JsonKey(name: 'question_ids')  List<int>? questionIds,  List<TemplateQuestionLinkCreate>? questions)?  $default,) {final _that = this;
switch (_that) {
case _TemplateUpdate() when $default != null:
return $default(_that.title,_that.description,_that.isPublic,_that.questionIds,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateUpdate implements TemplateUpdate {
  const _TemplateUpdate({this.title, this.description, @JsonKey(name: 'is_public') this.isPublic, @JsonKey(name: 'question_ids') final  List<int>? questionIds, final  List<TemplateQuestionLinkCreate>? questions}): _questionIds = questionIds,_questions = questions;
  factory _TemplateUpdate.fromJson(Map<String, dynamic> json) => _$TemplateUpdateFromJson(json);

@override final  String? title;
@override final  String? description;
@override@JsonKey(name: 'is_public') final  bool? isPublic;
 final  List<int>? _questionIds;
@override@JsonKey(name: 'question_ids') List<int>? get questionIds {
  final value = _questionIds;
  if (value == null) return null;
  if (_questionIds is EqualUnmodifiableListView) return _questionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<TemplateQuestionLinkCreate>? _questions;
@override List<TemplateQuestionLinkCreate>? get questions {
  final value = _questions;
  if (value == null) return null;
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TemplateUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateUpdateCopyWith<_TemplateUpdate> get copyWith => __$TemplateUpdateCopyWithImpl<_TemplateUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateUpdate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other._questionIds, _questionIds)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,isPublic,const DeepCollectionEquality().hash(_questionIds),const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'TemplateUpdate(title: $title, description: $description, isPublic: $isPublic, questionIds: $questionIds, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$TemplateUpdateCopyWith<$Res> implements $TemplateUpdateCopyWith<$Res> {
  factory _$TemplateUpdateCopyWith(_TemplateUpdate value, $Res Function(_TemplateUpdate) _then) = __$TemplateUpdateCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description,@JsonKey(name: 'is_public') bool? isPublic,@JsonKey(name: 'question_ids') List<int>? questionIds, List<TemplateQuestionLinkCreate>? questions
});




}
/// @nodoc
class __$TemplateUpdateCopyWithImpl<$Res>
    implements _$TemplateUpdateCopyWith<$Res> {
  __$TemplateUpdateCopyWithImpl(this._self, this._then);

  final _TemplateUpdate _self;
  final $Res Function(_TemplateUpdate) _then;

/// Create a copy of TemplateUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? isPublic = freezed,Object? questionIds = freezed,Object? questions = freezed,}) {
  return _then(_TemplateUpdate(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isPublic: freezed == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool?,questionIds: freezed == questionIds ? _self._questionIds : questionIds // ignore: cast_nullable_to_non_nullable
as List<int>?,questions: freezed == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<TemplateQuestionLinkCreate>?,
  ));
}


}


/// @nodoc
mixin _$QuestionInTemplate {

@JsonKey(name: 'question_id') int get questionId; String? get title;@JsonKey(name: 'question_content') String get questionContent;@JsonKey(name: 'response_type') String get responseType;@JsonKey(name: 'is_required') bool get isRequired;@JsonKey(name: 'display_order') int get displayOrder; List<QuestionOption>? get options;
/// Create a copy of QuestionInTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionInTemplateCopyWith<QuestionInTemplate> get copyWith => _$QuestionInTemplateCopyWithImpl<QuestionInTemplate>(this as QuestionInTemplate, _$identity);

  /// Serializes this QuestionInTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionInTemplate&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,displayOrder,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'QuestionInTemplate(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, displayOrder: $displayOrder, options: $options)';
}


}

/// @nodoc
abstract mixin class $QuestionInTemplateCopyWith<$Res>  {
  factory $QuestionInTemplateCopyWith(QuestionInTemplate value, $Res Function(QuestionInTemplate) _then) = _$QuestionInTemplateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired,@JsonKey(name: 'display_order') int displayOrder, List<QuestionOption>? options
});




}
/// @nodoc
class _$QuestionInTemplateCopyWithImpl<$Res>
    implements $QuestionInTemplateCopyWith<$Res> {
  _$QuestionInTemplateCopyWithImpl(this._self, this._then);

  final QuestionInTemplate _self;
  final $Res Function(QuestionInTemplate) _then;

/// Create a copy of QuestionInTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? displayOrder = null,Object? options = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOption>?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionInTemplate].
extension QuestionInTemplatePatterns on QuestionInTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionInTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionInTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionInTemplate value)  $default,){
final _that = this;
switch (_that) {
case _QuestionInTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionInTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionInTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired, @JsonKey(name: 'display_order')  int displayOrder,  List<QuestionOption>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionInTemplate() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.displayOrder,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired, @JsonKey(name: 'display_order')  int displayOrder,  List<QuestionOption>? options)  $default,) {final _that = this;
switch (_that) {
case _QuestionInTemplate():
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.displayOrder,_that.options);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  int questionId,  String? title, @JsonKey(name: 'question_content')  String questionContent, @JsonKey(name: 'response_type')  String responseType, @JsonKey(name: 'is_required')  bool isRequired, @JsonKey(name: 'display_order')  int displayOrder,  List<QuestionOption>? options)?  $default,) {final _that = this;
switch (_that) {
case _QuestionInTemplate() when $default != null:
return $default(_that.questionId,_that.title,_that.questionContent,_that.responseType,_that.isRequired,_that.displayOrder,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionInTemplate implements QuestionInTemplate {
  const _QuestionInTemplate({@JsonKey(name: 'question_id') required this.questionId, this.title, @JsonKey(name: 'question_content') required this.questionContent, @JsonKey(name: 'response_type') required this.responseType, @JsonKey(name: 'is_required') required this.isRequired, @JsonKey(name: 'display_order') required this.displayOrder, final  List<QuestionOption>? options}): _options = options;
  factory _QuestionInTemplate.fromJson(Map<String, dynamic> json) => _$QuestionInTemplateFromJson(json);

@override@JsonKey(name: 'question_id') final  int questionId;
@override final  String? title;
@override@JsonKey(name: 'question_content') final  String questionContent;
@override@JsonKey(name: 'response_type') final  String responseType;
@override@JsonKey(name: 'is_required') final  bool isRequired;
@override@JsonKey(name: 'display_order') final  int displayOrder;
 final  List<QuestionOption>? _options;
@override List<QuestionOption>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of QuestionInTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionInTemplateCopyWith<_QuestionInTemplate> get copyWith => __$QuestionInTemplateCopyWithImpl<_QuestionInTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionInTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionInTemplate&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.questionContent, questionContent) || other.questionContent == questionContent)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,title,questionContent,responseType,isRequired,displayOrder,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'QuestionInTemplate(questionId: $questionId, title: $title, questionContent: $questionContent, responseType: $responseType, isRequired: $isRequired, displayOrder: $displayOrder, options: $options)';
}


}

/// @nodoc
abstract mixin class _$QuestionInTemplateCopyWith<$Res> implements $QuestionInTemplateCopyWith<$Res> {
  factory _$QuestionInTemplateCopyWith(_QuestionInTemplate value, $Res Function(_QuestionInTemplate) _then) = __$QuestionInTemplateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') int questionId, String? title,@JsonKey(name: 'question_content') String questionContent,@JsonKey(name: 'response_type') String responseType,@JsonKey(name: 'is_required') bool isRequired,@JsonKey(name: 'display_order') int displayOrder, List<QuestionOption>? options
});




}
/// @nodoc
class __$QuestionInTemplateCopyWithImpl<$Res>
    implements _$QuestionInTemplateCopyWith<$Res> {
  __$QuestionInTemplateCopyWithImpl(this._self, this._then);

  final _QuestionInTemplate _self;
  final $Res Function(_QuestionInTemplate) _then;

/// Create a copy of QuestionInTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? title = freezed,Object? questionContent = null,Object? responseType = null,Object? isRequired = null,Object? displayOrder = null,Object? options = freezed,}) {
  return _then(_QuestionInTemplate(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,questionContent: null == questionContent ? _self.questionContent : questionContent // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOption>?,
  ));
}


}


/// @nodoc
mixin _$Template {

@JsonKey(name: 'template_id') int get templateId; String get title; String? get description;@JsonKey(name: 'is_public') bool get isPublic; List<QuestionInTemplate>? get questions;@JsonKey(name: 'question_count') int? get questionCount;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateCopyWith<Template> get copyWith => _$TemplateCopyWithImpl<Template>(this as Template, _$identity);

  /// Serializes this Template to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Template&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,title,description,isPublic,const DeepCollectionEquality().hash(questions),questionCount,createdAt,updatedAt);

@override
String toString() {
  return 'Template(templateId: $templateId, title: $title, description: $description, isPublic: $isPublic, questions: $questions, questionCount: $questionCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TemplateCopyWith<$Res>  {
  factory $TemplateCopyWith(Template value, $Res Function(Template) _then) = _$TemplateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'template_id') int templateId, String title, String? description,@JsonKey(name: 'is_public') bool isPublic, List<QuestionInTemplate>? questions,@JsonKey(name: 'question_count') int? questionCount,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$TemplateCopyWithImpl<$Res>
    implements $TemplateCopyWith<$Res> {
  _$TemplateCopyWithImpl(this._self, this._then);

  final Template _self;
  final $Res Function(Template) _then;

/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templateId = null,Object? title = null,Object? description = freezed,Object? isPublic = null,Object? questions = freezed,Object? questionCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,questions: freezed == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionInTemplate>?,questionCount: freezed == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Template].
extension TemplatePatterns on Template {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Template value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Template() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Template value)  $default,){
final _that = this;
switch (_that) {
case _Template():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Template value)?  $default,){
final _that = this;
switch (_that) {
case _Template() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'template_id')  int templateId,  String title,  String? description, @JsonKey(name: 'is_public')  bool isPublic,  List<QuestionInTemplate>? questions, @JsonKey(name: 'question_count')  int? questionCount, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Template() when $default != null:
return $default(_that.templateId,_that.title,_that.description,_that.isPublic,_that.questions,_that.questionCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'template_id')  int templateId,  String title,  String? description, @JsonKey(name: 'is_public')  bool isPublic,  List<QuestionInTemplate>? questions, @JsonKey(name: 'question_count')  int? questionCount, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Template():
return $default(_that.templateId,_that.title,_that.description,_that.isPublic,_that.questions,_that.questionCount,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'template_id')  int templateId,  String title,  String? description, @JsonKey(name: 'is_public')  bool isPublic,  List<QuestionInTemplate>? questions, @JsonKey(name: 'question_count')  int? questionCount, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Template() when $default != null:
return $default(_that.templateId,_that.title,_that.description,_that.isPublic,_that.questions,_that.questionCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Template implements Template {
  const _Template({@JsonKey(name: 'template_id') required this.templateId, required this.title, this.description, @JsonKey(name: 'is_public') required this.isPublic, final  List<QuestionInTemplate>? questions, @JsonKey(name: 'question_count') this.questionCount, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): _questions = questions;
  factory _Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);

@override@JsonKey(name: 'template_id') final  int templateId;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'is_public') final  bool isPublic;
 final  List<QuestionInTemplate>? _questions;
@override List<QuestionInTemplate>? get questions {
  final value = _questions;
  if (value == null) return null;
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'question_count') final  int? questionCount;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateCopyWith<_Template> get copyWith => __$TemplateCopyWithImpl<_Template>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Template&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,title,description,isPublic,const DeepCollectionEquality().hash(_questions),questionCount,createdAt,updatedAt);

@override
String toString() {
  return 'Template(templateId: $templateId, title: $title, description: $description, isPublic: $isPublic, questions: $questions, questionCount: $questionCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TemplateCopyWith<$Res> implements $TemplateCopyWith<$Res> {
  factory _$TemplateCopyWith(_Template value, $Res Function(_Template) _then) = __$TemplateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'template_id') int templateId, String title, String? description,@JsonKey(name: 'is_public') bool isPublic, List<QuestionInTemplate>? questions,@JsonKey(name: 'question_count') int? questionCount,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$TemplateCopyWithImpl<$Res>
    implements _$TemplateCopyWith<$Res> {
  __$TemplateCopyWithImpl(this._self, this._then);

  final _Template _self;
  final $Res Function(_Template) _then;

/// Create a copy of Template
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templateId = null,Object? title = null,Object? description = freezed,Object? isPublic = null,Object? questions = freezed,Object? questionCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Template(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,questions: freezed == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionInTemplate>?,questionCount: freezed == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
