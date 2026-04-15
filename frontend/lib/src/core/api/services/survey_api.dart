// Created with the Assistance of Claude Code
// frontend/lib/core/api/services/survey_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'survey_api.g.dart';

/// Survey API service using Retrofit with typed models
///
/// Run `dart run build_runner build` to generate survey_api.g.dart
@RestApi()
abstract class SurveyApi {
  factory SurveyApi(Dio dio, {String? baseUrl}) = _SurveyApi;

  /// Create a new survey
  @POST('/surveys')
  Future<Survey> createSurvey(@Body() SurveyCreate survey);

  /// Create survey from template
  @POST('/surveys/from-template/{templateId}')
  Future<Survey> createFromTemplate(
    @Path('templateId') int templateId,
    @Body() SurveyFromTemplateCreate? overrides,
  );

  /// List all surveys
  @GET('/surveys')
  Future<List<Survey>> listSurveys({
    @Query('publication_status') String? publicationStatus,
    @Query('creator_id') int? creatorId,
  });

  /// Get a single survey by ID
  @GET('/surveys/{id}')
  Future<Survey> getSurvey(
    @Path('id') int id, {
    @Query('language') String? language,
  });

  /// Update a survey
  @PUT('/surveys/{id}')
  Future<Survey> updateSurvey(
    @Path('id') int id,
    @Body() SurveyUpdate survey,
  );

  /// Delete a survey
  @DELETE('/surveys/{id}')
  Future<void> deleteSurvey(@Path('id') int id);

  /// Publish a survey (draft -> published)
  @PATCH('/surveys/{id}/publish')
  Future<Survey> publishSurvey(@Path('id') int id);

  /// Close a survey (published -> closed)
  @PATCH('/surveys/{id}/close')
  Future<Survey> closeSurvey(@Path('id') int id);

  /// Assign survey to a single user
  @POST('/surveys/{id}/assign')
  Future<Assignment> assignSurvey(
    @Path('id') int id,
    @Body() AssignmentCreate assignment,
  );

  /// Assign survey to multiple users
  @POST('/surveys/{id}/assign')
  Future<List<Assignment>> bulkAssignSurvey(
    @Path('id') int id,
    @Body() BulkAssignmentCreate assignment,
  );

  /// List assignments for a survey
  @GET('/surveys/{id}/assignments')
  Future<List<Assignment>> getSurveyAssignments(
    @Path('id') int id, {
    @Query('status') String? status,
  });
}
