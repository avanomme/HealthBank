// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/consent.dart
/// Consent form models for consent status and submission
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent.freezed.dart';
part 'consent.g.dart';

/// Response from GET /consent/status
@freezed
sealed class ConsentStatusResponse with _$ConsentStatusResponse {
  const factory ConsentStatusResponse({
    @JsonKey(name: 'has_signed_consent') required bool hasSignedConsent,
    @JsonKey(name: 'consent_version') String? consentVersion,
    @JsonKey(name: 'consent_signed_at') String? consentSignedAt,
    @JsonKey(name: 'current_version') required String currentVersion,
    @JsonKey(name: 'needs_consent') required bool needsConsent,
  }) = _ConsentStatusResponse;

  factory ConsentStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ConsentStatusResponseFromJson(json);
}

/// Request body for POST /consent/submit
@freezed
sealed class ConsentSubmitRequest with _$ConsentSubmitRequest {
  const factory ConsentSubmitRequest({
    @JsonKey(name: 'document_text') required String documentText,
    @JsonKey(name: 'document_language') required String documentLanguage,
    @JsonKey(name: 'signature_name') required String signatureName,
  }) = _ConsentSubmitRequest;

  factory ConsentSubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$ConsentSubmitRequestFromJson(json);
}

/// Response from POST /consent/submit
@freezed
sealed class ConsentSubmitResponse with _$ConsentSubmitResponse {
  const factory ConsentSubmitResponse({
    required bool accepted,
    required String version,
    @JsonKey(name: 'consent_record_id') required int consentRecordId,
  }) = _ConsentSubmitResponse;

  factory ConsentSubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$ConsentSubmitResponseFromJson(json);
}

/// Response from GET /admin/users/{id}/consent (admin viewing consent record)
@freezed
sealed class UserConsentRecordResponse with _$UserConsentRecordResponse {
  const factory UserConsentRecordResponse({
    @JsonKey(name: 'consent_record_id') required int consentRecordId,
    @JsonKey(name: 'account_id') required int accountId,
    @JsonKey(name: 'role_id') required int roleId,
    @JsonKey(name: 'consent_version') required String consentVersion,
    @JsonKey(name: 'document_language') required String documentLanguage,
    @JsonKey(name: 'document_text') required String documentText,
    @JsonKey(name: 'signature_name') String? signatureName,
    @JsonKey(name: 'signed_at') required String signedAt,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'user_agent') String? userAgent,
  }) = _UserConsentRecordResponse;

  factory UserConsentRecordResponse.fromJson(Map<String, dynamic> json) =>
      _$UserConsentRecordResponseFromJson(json);
}
