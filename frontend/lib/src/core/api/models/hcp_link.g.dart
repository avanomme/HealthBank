// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hcp_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HcpLink _$HcpLinkFromJson(Map<String, dynamic> json) => _HcpLink(
  linkId: (json['link_id'] as num).toInt(),
  hcpId: (json['hcp_id'] as num).toInt(),
  patientId: (json['patient_id'] as num).toInt(),
  hcpName: json['hcp_name'] as String?,
  patientName: json['patient_name'] as String?,
  status: json['status'] as String,
  requestedBy: json['requested_by'] as String,
  requestedAt: DateTime.parse(json['requested_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  consentRevoked: json['consent_revoked'] as bool? ?? false,
);

Map<String, dynamic> _$HcpLinkToJson(_HcpLink instance) => <String, dynamic>{
  'link_id': instance.linkId,
  'hcp_id': instance.hcpId,
  'patient_id': instance.patientId,
  'hcp_name': instance.hcpName,
  'patient_name': instance.patientName,
  'status': instance.status,
  'requested_by': instance.requestedBy,
  'requested_at': instance.requestedAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'consent_revoked': instance.consentRevoked,
};
