// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserCreate _$UserCreateFromJson(Map<String, dynamic> json) => _UserCreate(
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  password: json['password'] as String?,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
  isActive: json['is_active'] as bool?,
  sendSetupEmail: json['send_setup_email'] as bool?,
  birthdate: json['birthdate'] as String?,
  gender: json['gender'] as String?,
);

Map<String, dynamic> _$UserCreateToJson(_UserCreate instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'role': _$UserRoleEnumMap[instance.role],
      'is_active': instance.isActive,
      'send_setup_email': instance.sendSetupEmail,
      'birthdate': instance.birthdate,
      'gender': instance.gender,
    };

const _$UserRoleEnumMap = {
  UserRole.participant: 'participant',
  UserRole.researcher: 'researcher',
  UserRole.hcp: 'hcp',
  UserRole.admin: 'admin',
};

_UserUpdate _$UserUpdateFromJson(Map<String, dynamic> json) => _UserUpdate(
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  email: json['email'] as String?,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
  isActive: json['is_active'] as bool?,
);

Map<String, dynamic> _$UserUpdateToJson(_UserUpdate instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role],
      'is_active': instance.isActive,
    };

_CurrentUserUpdate _$CurrentUserUpdateFromJson(Map<String, dynamic> json) =>
    _CurrentUserUpdate(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$CurrentUserUpdateToJson(_CurrentUserUpdate instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'birthdate': instance.birthdate?.toIso8601String(),
      'gender': instance.gender,
    };

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  accountId: (json['account_id'] as num).toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  role: json['role'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  birthdate: json['birthdate'] == null
      ? null
      : DateTime.parse(json['birthdate'] as String),
  gender: json['gender'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  lastLogin: json['last_login'] == null
      ? null
      : DateTime.parse(json['last_login'] as String),
  consentSignedAt: json['consent_signed_at'] == null
      ? null
      : DateTime.parse(json['consent_signed_at'] as String),
  consentVersion: json['consent_version'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'account_id': instance.accountId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'role': instance.role,
  'is_active': instance.isActive,
  'birthdate': instance.birthdate?.toIso8601String(),
  'gender': instance.gender,
  'created_at': instance.createdAt?.toIso8601String(),
  'last_login': instance.lastLogin?.toIso8601String(),
  'consent_signed_at': instance.consentSignedAt?.toIso8601String(),
  'consent_version': instance.consentVersion,
};

_UserListResponse _$UserListResponseFromJson(Map<String, dynamic> json) =>
    _UserListResponse(
      users: (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$UserListResponseToJson(_UserListResponse instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };
