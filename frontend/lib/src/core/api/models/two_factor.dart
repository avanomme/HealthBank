/// Two-factor authentication (2FA) models
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_factor.freezed.dart';
part 'two_factor.g.dart';

/// Response from POST /2fa/enroll
///
/// Backend returns a provisioning URI used to generate a QR code.
@freezed
sealed class TwoFactorEnrollResponse with _$TwoFactorEnrollResponse {
  const factory TwoFactorEnrollResponse({
    // If your backend uses a different key name, change the JsonKey to match.
    // Common options: "provisioning_uri", "uri", "otpauth_uri"
    @JsonKey(name: 'provisioning_uri') required String provisioningUri,
  }) = _TwoFactorEnrollResponse;

  factory TwoFactorEnrollResponse.fromJson(Map<String, dynamic> json) =>
      _$TwoFactorEnrollResponseFromJson(json);
}

// Response from POST /2fa/confirm
//
// backend returns a message with value "2FA enabled" on success
@freezed
sealed class TwoFactorConfirmResponse with _$TwoFactorConfirmResponse {
  const factory TwoFactorConfirmResponse({
    // If your backend uses a different key name, change the JsonKey to match.
    // Common options: "provisioning_uri", "uri", "otpauth_uri"
    @JsonKey(name: 'message') required String message,
  }) = _TwoFactorConfirmResponse;

  factory TwoFactorConfirmResponse.fromJson(Map<String, dynamic> json) =>
      _$TwoFactorConfirmResponseFromJson(json);
}

// Response from POST /2fa/disable
//
// backend returns a message with value "2FA enabled" on success
@freezed
sealed class TwoFactorDisableResponse with _$TwoFactorDisableResponse {
  const factory TwoFactorDisableResponse({
    // If your backend uses a different key name, change the JsonKey to match.
    // Common options: "provisioning_uri", "uri", "otpauth_uri"
    @JsonKey(name: 'message') required String message,
  }) = _TwoFactorDisableResponse;

  factory TwoFactorDisableResponse.fromJson(Map<String, dynamic> json) =>
      _$TwoFactorDisableResponseFromJson(json);
}

/// Request body for POST /2fa/confirm
@freezed
sealed class TwoFactorConfirmRequest with _$TwoFactorConfirmRequest {
  const factory TwoFactorConfirmRequest({
    // Change key name if backend expects "totp" or "token" etc.
    @JsonKey(name: 'code') required String code,
  }) = _TwoFactorConfirmRequest;

  factory TwoFactorConfirmRequest.fromJson(Map<String, dynamic> json) =>
      _$TwoFactorConfirmRequestFromJson(json);
}