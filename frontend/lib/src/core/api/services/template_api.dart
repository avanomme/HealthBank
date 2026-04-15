// Created with the Assistance of Claude Code
// frontend/lib/core/api/services/template_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'template_api.g.dart';

/// Template API service using Retrofit with typed models
///
/// Run `dart run build_runner build` to generate template_api.g.dart
@RestApi()
abstract class TemplateApi {
  factory TemplateApi(Dio dio, {String? baseUrl}) = _TemplateApi;

  /// Create a new template
  @POST('/templates')
  Future<Template> createTemplate(@Body() TemplateCreate template);

  /// List all templates
  @GET('/templates')
  Future<List<Template>> listTemplates({
    @Query('is_public') bool? isPublic,
    @Query('creator_id') int? creatorId,
  });

  /// Get a single template by ID
  @GET('/templates/{id}')
  Future<Template> getTemplate(@Path('id') int id);

  /// Update a template
  @PUT('/templates/{id}')
  Future<Template> updateTemplate(
    @Path('id') int id,
    @Body() TemplateUpdate template,
  );

  /// Delete a template
  @DELETE('/templates/{id}')
  Future<void> deleteTemplate(@Path('id') int id);

  /// Duplicate a template
  @POST('/templates/{id}/duplicate')
  Future<Template> duplicateTemplate(@Path('id') int id);
}
