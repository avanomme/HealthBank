// Created with the Assistance of Claude Code
// frontend/lib/core/api/api.dart
/// HealthBank API Client
///
/// This module provides type-safe API access using Retrofit + Dio.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:frontend/src/core/api/api.dart';
///
/// // Get the API client singleton
/// final client = ApiClient();
///
/// // Create typed API services
/// final surveyApi = SurveyApi(client.dio);
/// final questionApi = QuestionApi(client.dio);
/// final templateApi = TemplateApi(client.dio);
/// final assignmentApi = AssignmentApi(client.dio);
///
/// // Make typed API calls
/// final surveys = await surveyApi.listSurveys();
/// final survey = await surveyApi.getSurvey(1);
/// ```
///
/// ## Code Generation
///
/// After modifying models or services, run:
/// ```bash
/// cd frontend
/// dart run build_runner build --delete-conflicting-outputs
/// ```
library;


export 'api_client.dart';
export 'models/models.dart';
export 'services/services.dart';
