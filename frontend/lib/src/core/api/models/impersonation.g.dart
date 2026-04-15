// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'impersonation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImpersonatedUserInfo _$ImpersonatedUserInfoFromJson(
  Map<String, dynamic> json,
) => _ImpersonatedUserInfo(
  accountId: (json['account_id'] as num).toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  email: json['email'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$ImpersonatedUserInfoToJson(
  _ImpersonatedUserInfo instance,
) => <String, dynamic>{
  'account_id': instance.accountId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'role': instance.role,
};

_ImpersonateResponse _$ImpersonateResponseFromJson(Map<String, dynamic> json) =>
    _ImpersonateResponse(
      message: json['message'] as String,
      sessionToken: json['session_token'] as String,
      expiresAt: json['expires_at'] as String,
      isImpersonating: json['is_impersonating'] as bool,
      impersonatedUser: ImpersonatedUserInfo.fromJson(
        json['impersonated_user'] as Map<String, dynamic>,
      ),
      adminAccountId: (json['admin_account_id'] as num).toInt(),
    );

Map<String, dynamic> _$ImpersonateResponseToJson(
  _ImpersonateResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'session_token': instance.sessionToken,
  'expires_at': instance.expiresAt,
  'is_impersonating': instance.isImpersonating,
  'impersonated_user': instance.impersonatedUser.toJson(),
  'admin_account_id': instance.adminAccountId,
};

_EndImpersonationResponse _$EndImpersonationResponseFromJson(
  Map<String, dynamic> json,
) => _EndImpersonationResponse(
  message: json['message'] as String,
  adminAccountId: (json['admin_account_id'] as num).toInt(),
);

Map<String, dynamic> _$EndImpersonationResponseToJson(
  _EndImpersonationResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'admin_account_id': instance.adminAccountId,
};

_SessionUserInfo _$SessionUserInfoFromJson(Map<String, dynamic> json) =>
    _SessionUserInfo(
      accountId: (json['account_id'] as num).toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      role: json['role'] as String,
      roleId: (json['role_id'] as num).toInt(),
      birthdate: json['birthdate'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$SessionUserInfoToJson(_SessionUserInfo instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'role': instance.role,
      'role_id': instance.roleId,
      'birthdate': instance.birthdate,
      'gender': instance.gender,
    };

_ImpersonationInfo _$ImpersonationInfoFromJson(Map<String, dynamic> json) =>
    _ImpersonationInfo(
      adminAccountId: (json['admin_account_id'] as num).toInt(),
      adminFirstName: json['admin_first_name'] as String?,
      adminLastName: json['admin_last_name'] as String?,
      adminEmail: json['admin_email'] as String,
    );

Map<String, dynamic> _$ImpersonationInfoToJson(_ImpersonationInfo instance) =>
    <String, dynamic>{
      'admin_account_id': instance.adminAccountId,
      'admin_first_name': instance.adminFirstName,
      'admin_last_name': instance.adminLastName,
      'admin_email': instance.adminEmail,
    };

_SessionMeResponse _$SessionMeResponseFromJson(
  Map<String, dynamic> json,
) => _SessionMeResponse(
  user: SessionUserInfo.fromJson(json['user'] as Map<String, dynamic>),
  isImpersonating: json['is_impersonating'] as bool,
  impersonationInfo: json['impersonation_info'] == null
      ? null
      : ImpersonationInfo.fromJson(
          json['impersonation_info'] as Map<String, dynamic>,
        ),
  viewingAs: json['viewing_as'] == null
      ? null
      : ViewingAsUserInfo.fromJson(json['viewing_as'] as Map<String, dynamic>),
  sessionExpiresAt: json['session_expires_at'] as String,
  hasSignedConsent: json['has_signed_consent'] as bool? ?? true,
  needsProfileCompletion: json['needs_profile_completion'] as bool? ?? false,
  mustChangePassword: json['must_change_password'] as bool? ?? false,
);

Map<String, dynamic> _$SessionMeResponseToJson(_SessionMeResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'is_impersonating': instance.isImpersonating,
      'impersonation_info': instance.impersonationInfo?.toJson(),
      'viewing_as': instance.viewingAs?.toJson(),
      'session_expires_at': instance.sessionExpiresAt,
      'has_signed_consent': instance.hasSignedConsent,
      'needs_profile_completion': instance.needsProfileCompletion,
      'must_change_password': instance.mustChangePassword,
    };

_ViewingAsUserInfo _$ViewingAsUserInfoFromJson(Map<String, dynamic> json) =>
    _ViewingAsUserInfo(
      userId: (json['user_id'] as num).toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      role: json['role'] as String,
      roleId: (json['role_id'] as num).toInt(),
      birthdate: json['birthdate'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$ViewingAsUserInfoToJson(_ViewingAsUserInfo instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'role': instance.role,
      'role_id': instance.roleId,
      'birthdate': instance.birthdate,
      'gender': instance.gender,
    };

_ViewAsResponse _$ViewAsResponseFromJson(Map<String, dynamic> json) =>
    _ViewAsResponse(
      message: json['message'] as String,
      isViewingAs: json['is_viewing_as'] as bool,
      viewedUser: ViewingAsUserInfo.fromJson(
        json['viewed_user'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ViewAsResponseToJson(_ViewAsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'is_viewing_as': instance.isViewingAs,
      'viewed_user': instance.viewedUser.toJson(),
    };

_EndViewAsResponse _$EndViewAsResponseFromJson(Map<String, dynamic> json) =>
    _EndViewAsResponse(message: json['message'] as String);

Map<String, dynamic> _$EndViewAsResponseToJson(_EndViewAsResponse instance) =>
    <String, dynamic>{'message': instance.message};
