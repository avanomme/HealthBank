// Created with the Assistance of Claude Code
// frontend/lib/core/api/services/question_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'question_api.g.dart';

/// Question Bank API service using Retrofit with typed models
///
/// Run `dart run build_runner build` to generate question_api.g.dart
@RestApi()
abstract class QuestionApi {
  factory QuestionApi(Dio dio, {String? baseUrl}) = _QuestionApi;

  /// List all question categories
  @GET('/questions/categories')
  Future<List<QuestionCategory>> listCategories();

  /// Create a new question
  @POST('/questions')
  Future<Question> createQuestion(@Body() QuestionCreate question);

  /// List all questions
  @GET('/questions')
  Future<List<Question>> listQuestions({
    @Query('response_type') String? responseType,
    @Query('category') String? category,
    @Query('is_active') bool? isActive,
  });

  /// Get a single question by ID
  @GET('/questions/{id}')
  Future<Question> getQuestion(@Path('id') int id);

  /// Update a question
  @PUT('/questions/{id}')
  Future<Question> updateQuestion(
    @Path('id') int id,
    @Body() QuestionUpdate question,
  );

  /// Delete a question
  @DELETE('/questions/{id}')
  Future<void> deleteQuestion(@Path('id') int id);
}
