// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/impersonation.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'impersonation.freezed.dart';
part 'impersonation.g.dart';

// =============================================================================
// Impersonation Models
// =============================================================================

/// Basic user information for impersonation responses
@freezed
sealed class ImpersonatedUserInfo with _$ImpersonatedUserInfo {
  const factory ImpersonatedUserInfo({
    @JsonKey(name: 'account_id') required int accountId,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    required String email,
    required String role,
  }) = _ImpersonatedUserInfo;

  factory ImpersonatedUserInfo.fromJson(Map<String, dynamic> json) =>
      _$ImpersonatedUserInfoFromJson(json);
}

/// Response for successful impersonation
@freezed
sealed class ImpersonateResponse with _$ImpersonateResponse {
  @JsonSerializable(explicitToJson: true)
  const factory ImpersonateResponse({
    required String message,
    @JsonKey(name: 'session_token') required String sessionToken,
    @JsonKey(name: 'expires_at') required String expiresAt,
    @JsonKey(name: 'is_impersonating') required bool isImpersonating,
    @JsonKey(name: 'impersonated_user') required ImpersonatedUserInfo impersonatedUser,
    @JsonKey(name: 'admin_account_id') required int adminAccountId,
  }) = _ImpersonateResponse;

  factory ImpersonateResponse.fromJson(Map<String, dynamic> json) =>
      _$ImpersonateResponseFromJson(json);
}

/// Response for ending impersonation
@freezed
sealed class EndImpersonationResponse with _$EndImpersonationResponse {
  const factory EndImpersonationResponse({
    required String message,
    @JsonKey(name: 'admin_account_id') required int adminAccountId,
  }) = _EndImpersonationResponse;

  factory EndImpersonationResponse.fromJson(Map<String, dynamic> json) =>
      _$EndImpersonationResponseFromJson(json);
}

// =============================================================================
// Session Info Models (for /sessions/me endpoint)
// =============================================================================

/// User information from session
@freezed
sealed class SessionUserInfo with _$SessionUserInfo {
  const factory SessionUserInfo({
    @JsonKey(name: 'account_id') required int accountId,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    required String email,
    required String role,
    @JsonKey(name: 'role_id') required int roleId,
    @JsonKey(name: 'birthdate') String? birthdate,
    @JsonKey(name: 'gender') String? gender,
  }) = _SessionUserInfo;

  factory SessionUserInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionUserInfoFromJson(json);
}

/// Information about the admin who initiated impersonation
@freezed
sealed class ImpersonationInfo with _$ImpersonationInfo {
  const factory ImpersonationInfo({
    @JsonKey(name: 'admin_account_id') required int adminAccountId,
    @JsonKey(name: 'admin_first_name') String? adminFirstName,
    @JsonKey(name: 'admin_last_name') String? adminLastName,
    @JsonKey(name: 'admin_email') required String adminEmail,
  }) = _ImpersonationInfo;

  factory ImpersonationInfo.fromJson(Map<String, dynamic> json) =>
      _$ImpersonationInfoFromJson(json);
}

/// Response from /sessions/me endpoint
@freezed
sealed class SessionMeResponse with _$SessionMeResponse {
  @JsonSerializable(explicitToJson: true)
  const factory SessionMeResponse({
    required SessionUserInfo user,
    @JsonKey(name: 'is_impersonating') required bool isImpersonating,
    @JsonKey(name: 'impersonation_info') ImpersonationInfo? impersonationInfo,
    @JsonKey(name: 'viewing_as') ViewingAsUserInfo? viewingAs,
    @JsonKey(name: 'session_expires_at') required String sessionExpiresAt,
    @JsonKey(name: 'has_signed_consent') @Default(true) bool hasSignedConsent,
    @JsonKey(name: 'needs_profile_completion') @Default(false) bool needsProfileCompletion,
    @JsonKey(name: 'must_change_password') @Default(false) bool mustChangePassword,
  }) = _SessionMeResponse;

  factory SessionMeResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionMeResponseFromJson(json);
}

// =============================================================================
// View-As Models (New Approach - No Token Switching)
// =============================================================================

/// Information about the user being viewed as
@freezed
sealed class ViewingAsUserInfo with _$ViewingAsUserInfo {
  const factory ViewingAsUserInfo({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    required String email,
    required String role,
    @JsonKey(name: 'role_id') required int roleId,
    @JsonKey(name: 'birthdate') String? birthdate,
    @JsonKey(name: 'gender') String? gender,
  }) = _ViewingAsUserInfo;

  factory ViewingAsUserInfo.fromJson(Map<String, dynamic> json) =>
      _$ViewingAsUserInfoFromJson(json);
}

/// Response for starting view-as mode
@freezed
sealed class ViewAsResponse with _$ViewAsResponse {
  @JsonSerializable(explicitToJson: true)
  const factory ViewAsResponse({
    required String message,
    @JsonKey(name: 'is_viewing_as') required bool isViewingAs,
    @JsonKey(name: 'viewed_user') required ViewingAsUserInfo viewedUser,
  }) = _ViewAsResponse;

  factory ViewAsResponse.fromJson(Map<String, dynamic> json) =>
      _$ViewAsResponseFromJson(json);
}

/// Response for ending view-as mode
@freezed
sealed class EndViewAsResponse with _$EndViewAsResponse {
  const factory EndViewAsResponse({
    required String message,
  }) = _EndViewAsResponse;

  factory EndViewAsResponse.fromJson(Map<String, dynamic> json) =>
      _$EndViewAsResponseFromJson(json);
}
