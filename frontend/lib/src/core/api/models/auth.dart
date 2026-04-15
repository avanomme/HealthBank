// Created with the Assistance of Claude Code
// frontend/lib/core/api/models/auth.dart
/// Authentication models for login/logout API
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

/// Login request model
@freezed
sealed class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Login response model matching backend login response (cookie-only auth)
@freezed
sealed class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'expires_at') required String expiresAt,
    @JsonKey(name: 'account_id') required int accountId,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? email,
    String? role,
    @JsonKey(name: 'must_change_password') @Default(false) bool mustChangePassword,
    @JsonKey(name: 'has_signed_consent') @Default(true) bool hasSignedConsent,
    @JsonKey(name: 'needs_profile_completion') @Default(false) bool needsProfileCompletion,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// Extension for LoginResponse to get full name
extension LoginResponseExtension on LoginResponse {
  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    return '$first $last'.trim();
  }
}

/// Password reset request (step 1: send email)
@freezed
sealed class PasswordResetEmailRequest with _$PasswordResetEmailRequest {
  const factory PasswordResetEmailRequest({
    required String email,
  }) = _PasswordResetEmailRequest;

  factory PasswordResetEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetEmailRequestFromJson(json);
}

/// Password reset confirm (step 2: set new password with token)
@freezed
sealed class PasswordResetConfirmRequest with _$PasswordResetConfirmRequest {
  const factory PasswordResetConfirmRequest({
    required String token,
    @JsonKey(name: 'new_password') required String newPassword,
  }) = _PasswordResetConfirmRequest;

  factory PasswordResetConfirmRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetConfirmRequestFromJson(json);
}

/// Change password request model
@freezed
sealed class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    @JsonKey(name: 'old_password') required String currentPassword,
    @JsonKey(name: 'new_password') required String newPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}

/// Profile completion request (participant birthdate + gender)
@freezed
sealed class ProfileCompleteRequest with _$ProfileCompleteRequest {
  const factory ProfileCompleteRequest({
    required String birthdate,
    required String gender,
  }) = _ProfileCompleteRequest;

  factory ProfileCompleteRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileCompleteRequestFromJson(json);
}

/// Generic message response from backend
@freezed
sealed class MessageResponse with _$MessageResponse {
  const factory MessageResponse({
    required String message,
  }) = _MessageResponse;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
}


/// Verify 2FA during login using challenge token + TOTP code
@freezed
sealed class Verify2FARequest with _$Verify2FARequest {
  const factory Verify2FARequest({
    @JsonKey(name: 'challenge_token') required String challengeToken,
    required String code,
  }) = _Verify2FARequest;

  factory Verify2FARequest.fromJson(Map<String, dynamic> json) =>
      _$Verify2FARequestFromJson(json);
}