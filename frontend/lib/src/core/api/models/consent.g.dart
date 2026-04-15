// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsentStatusResponse _$ConsentStatusResponseFromJson(
  Map<String, dynamic> json,
) => _ConsentStatusResponse(
  hasSignedConsent: json['has_signed_consent'] as bool,
  consentVersion: json['consent_version'] as String?,
  consentSignedAt: json['consent_signed_at'] as String?,
  currentVersion: json['current_version'] as String,
  needsConsent: json['needs_consent'] as bool,
);

Map<String, dynamic> _$ConsentStatusResponseToJson(
  _ConsentStatusResponse instance,
) => <String, dynamic>{
  'has_signed_consent': instance.hasSignedConsent,
  'consent_version': instance.consentVersion,
  'consent_signed_at': instance.consentSignedAt,
  'current_version': instance.currentVersion,
  'needs_consent': instance.needsConsent,
};

_ConsentSubmitRequest _$ConsentSubmitRequestFromJson(
  Map<String, dynamic> json,
) => _ConsentSubmitRequest(
  documentText: json['document_text'] as String,
  documentLanguage: json['document_language'] as String,
  signatureName: json['signature_name'] as String,
);

Map<String, dynamic> _$ConsentSubmitRequestToJson(
  _ConsentSubmitRequest instance,
) => <String, dynamic>{
  'document_text': instance.documentText,
  'document_language': instance.documentLanguage,
  'signature_name': instance.signatureName,
};

_ConsentSubmitResponse _$ConsentSubmitResponseFromJson(
  Map<String, dynamic> json,
) => _ConsentSubmitResponse(
  accepted: json['accepted'] as bool,
  version: json['version'] as String,
  consentRecordId: (json['consent_record_id'] as num).toInt(),
);

Map<String, dynamic> _$ConsentSubmitResponseToJson(
  _ConsentSubmitResponse instance,
) => <String, dynamic>{
  'accepted': instance.accepted,
  'version': instance.version,
  'consent_record_id': instance.consentRecordId,
};

_UserConsentRecordResponse _$UserConsentRecordResponseFromJson(
  Map<String, dynamic> json,
) => _UserConsentRecordResponse(
  consentRecordId: (json['consent_record_id'] as num).toInt(),
  accountId: (json['account_id'] as num).toInt(),
  roleId: (json['role_id'] as num).toInt(),
  consentVersion: json['consent_version'] as String,
  documentLanguage: json['document_language'] as String,
  documentText: json['document_text'] as String,
  signatureName: json['signature_name'] as String?,
  signedAt: json['signed_at'] as String,
  ipAddress: json['ip_address'] as String?,
  userAgent: json['user_agent'] as String?,
);

Map<String, dynamic> _$UserConsentRecordResponseToJson(
  _UserConsentRecordResponse instance,
) => <String, dynamic>{
  'consent_record_id': instance.consentRecordId,
  'account_id': instance.accountId,
  'role_id': instance.roleId,
  'consent_version': instance.consentVersion,
  'document_language': instance.documentLanguage,
  'document_text': instance.documentText,
  'signature_name': instance.signatureName,
  'signed_at': instance.signedAt,
  'ip_address': instance.ipAddress,
  'user_agent': instance.userAgent,
};
