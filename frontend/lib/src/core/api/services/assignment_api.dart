// Created with the Assistance of Claude Code and Codex
// frontend/lib/core/api/services/assignment_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'assignment_api.g.dart';

/// Assignment API service using Retrofit with typed models
///
/// Run `dart run build_runner build` to generate assignment_api.g.dart
@RestApi()
abstract class AssignmentApi {
  factory AssignmentApi(Dio dio, {String? baseUrl}) = _AssignmentApi;

  /// Get my assignments (for current user)
  @GET('/assignments/me')
  Future<List<MyAssignment>> getMyAssignments({
    @Query('status') String? status,
  });

  /// Update an assignment
  @PUT('/assignments/{id}')
  Future<Assignment> updateAssignment(
    @Path('id') int id,
    @Body() AssignmentUpdate assignment,
  );

  /// Delete an assignment
  @DELETE('/assignments/{id}')
  Future<void> deleteAssignment(@Path('id') int id);

  /// Assign a published survey to one or more participants
  @POST('/surveys/{surveyId}/assign')
  Future<void> assignSurvey(
    @Path('surveyId') int surveyId,
    @Body() AssignmentCreate body,
  );

  /// Bulk-assign a published survey by demographic filters
  @POST('/surveys/{surveyId}/assign')
  Future<BulkAssignmentResult> assignSurveyBulk(
    @Path('surveyId') int surveyId,
    @Body() Map<String, dynamic> body,
  );

  /// List all assignments for a specific survey
  @GET('/surveys/{surveyId}/assignments')
  Future<List<Assignment>> getSurveyAssignments(
    @Path('surveyId') int surveyId, {
    @Query('status') String? status,
  });
}
