// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      expiresAt: json['expires_at'] as String,
      accountId: (json['account_id'] as num).toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      mustChangePassword: json['must_change_password'] as bool? ?? false,
      hasSignedConsent: json['has_signed_consent'] as bool? ?? true,
      needsProfileCompletion:
          json['needs_profile_completion'] as bool? ?? false,
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'expires_at': instance.expiresAt,
      'account_id': instance.accountId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'role': instance.role,
      'must_change_password': instance.mustChangePassword,
      'has_signed_consent': instance.hasSignedConsent,
      'needs_profile_completion': instance.needsProfileCompletion,
    };

_PasswordResetEmailRequest _$PasswordResetEmailRequestFromJson(
  Map<String, dynamic> json,
) => _PasswordResetEmailRequest(email: json['email'] as String);

Map<String, dynamic> _$PasswordResetEmailRequestToJson(
  _PasswordResetEmailRequest instance,
) => <String, dynamic>{'email': instance.email};

_PasswordResetConfirmRequest _$PasswordResetConfirmRequestFromJson(
  Map<String, dynamic> json,
) => _PasswordResetConfirmRequest(
  token: json['token'] as String,
  newPassword: json['new_password'] as String,
);

Map<String, dynamic> _$PasswordResetConfirmRequestToJson(
  _PasswordResetConfirmRequest instance,
) => <String, dynamic>{
  'token': instance.token,
  'new_password': instance.newPassword,
};

_ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => _ChangePasswordRequest(
  currentPassword: json['old_password'] as String,
  newPassword: json['new_password'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  _ChangePasswordRequest instance,
) => <String, dynamic>{
  'old_password': instance.currentPassword,
  'new_password': instance.newPassword,
};

_ProfileCompleteRequest _$ProfileCompleteRequestFromJson(
  Map<String, dynamic> json,
) => _ProfileCompleteRequest(
  birthdate: json['birthdate'] as String,
  gender: json['gender'] as String,
);

Map<String, dynamic> _$ProfileCompleteRequestToJson(
  _ProfileCompleteRequest instance,
) => <String, dynamic>{
  'birthdate': instance.birthdate,
  'gender': instance.gender,
};

_MessageResponse _$MessageResponseFromJson(Map<String, dynamic> json) =>
    _MessageResponse(message: json['message'] as String);

Map<String, dynamic> _$MessageResponseToJson(_MessageResponse instance) =>
    <String, dynamic>{'message': instance.message};

_Verify2FARequest _$Verify2FARequestFromJson(Map<String, dynamic> json) =>
    _Verify2FARequest(
      challengeToken: json['challenge_token'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$Verify2FARequestToJson(_Verify2FARequest instance) =>
    <String, dynamic>{
      'challenge_token': instance.challengeToken,
      'code': instance.code,
    };
