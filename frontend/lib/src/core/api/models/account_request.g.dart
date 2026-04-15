// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountRequestCreate _$AccountRequestCreateFromJson(
  Map<String, dynamic> json,
) => _AccountRequestCreate(
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  roleId: (json['role_id'] as num).toInt(),
  birthdate: json['birthdate'] as String?,
  gender: json['gender'] as String?,
  genderOther: json['gender_other'] as String?,
);

Map<String, dynamic> _$AccountRequestCreateToJson(
  _AccountRequestCreate instance,
) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'role_id': instance.roleId,
  'birthdate': instance.birthdate,
  'gender': instance.gender,
  'gender_other': instance.genderOther,
};

_AccountRequestResponse _$AccountRequestResponseFromJson(
  Map<String, dynamic> json,
) => _AccountRequestResponse(
  requestId: (json['request_id'] as num).toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  roleId: (json['role_id'] as num).toInt(),
  birthdate: json['birthdate'] as String?,
  gender: json['gender'] as String?,
  genderOther: json['gender_other'] as String?,
  status: json['status'] as String,
  adminNotes: json['admin_notes'] as String?,
  reviewedBy: (json['reviewed_by'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  reviewedAt: json['reviewed_at'] as String?,
);

Map<String, dynamic> _$AccountRequestResponseToJson(
  _AccountRequestResponse instance,
) => <String, dynamic>{
  'request_id': instance.requestId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'role_id': instance.roleId,
  'birthdate': instance.birthdate,
  'gender': instance.gender,
  'gender_other': instance.genderOther,
  'status': instance.status,
  'admin_notes': instance.adminNotes,
  'reviewed_by': instance.reviewedBy,
  'created_at': instance.createdAt,
  'reviewed_at': instance.reviewedAt,
};

_AccountRequestCountResponse _$AccountRequestCountResponseFromJson(
  Map<String, dynamic> json,
) => _AccountRequestCountResponse(count: (json['count'] as num).toInt());

Map<String, dynamic> _$AccountRequestCountResponseToJson(
  _AccountRequestCountResponse instance,
) => <String, dynamic>{'count': instance.count};

_AccountRequestRejectBody _$AccountRequestRejectBodyFromJson(
  Map<String, dynamic> json,
) => _AccountRequestRejectBody(adminNotes: json['admin_notes'] as String?);

Map<String, dynamic> _$AccountRequestRejectBodyToJson(
  _AccountRequestRejectBody instance,
) => <String, dynamic>{'admin_notes': instance.adminNotes};

_DeletionRequestResponse _$DeletionRequestResponseFromJson(
  Map<String, dynamic> json,
) => _DeletionRequestResponse(
  requestId: (json['request_id'] as num).toInt(),
  accountId: (json['account_id'] as num).toInt(),
  fullName: json['full_name'] as String?,
  email: json['email'] as String,
  status: json['status'] as String,
  adminNotes: json['admin_notes'] as String?,
  reviewedBy: (json['reviewed_by'] as num?)?.toInt(),
  requestedAt: json['requested_at'] as String,
  reviewedAt: json['reviewed_at'] as String?,
);

Map<String, dynamic> _$DeletionRequestResponseToJson(
  _DeletionRequestResponse instance,
) => <String, dynamic>{
  'request_id': instance.requestId,
  'account_id': instance.accountId,
  'full_name': instance.fullName,
  'email': instance.email,
  'status': instance.status,
  'admin_notes': instance.adminNotes,
  'reviewed_by': instance.reviewedBy,
  'requested_at': instance.requestedAt,
  'reviewed_at': instance.reviewedAt,
};

_DeletionRequestCountResponse _$DeletionRequestCountResponseFromJson(
  Map<String, dynamic> json,
) => _DeletionRequestCountResponse(count: (json['count'] as num).toInt());

Map<String, dynamic> _$DeletionRequestCountResponseToJson(
  _DeletionRequestCountResponse instance,
) => <String, dynamic>{'count': instance.count};
