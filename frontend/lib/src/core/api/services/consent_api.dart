// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/services/consent_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'consent_api.g.dart';

/// Consent API service for checking and submitting consent forms
///
/// Run `dart run build_runner build` to generate consent_api.g.dart
@RestApi()
abstract class ConsentApi {
  factory ConsentApi(Dio dio, {String? baseUrl}) = _ConsentApi;

  /// Check if current user has signed the required consent version
  @GET('/consent/status')
  Future<ConsentStatusResponse> getConsentStatus();

  /// Submit signed consent form
  @POST('/consent/submit')
  Future<ConsentSubmitResponse> submitConsent(
      @Body() ConsentSubmitRequest request);
}
