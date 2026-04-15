// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/account_request.dart
/// Account request models for the request account flow
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_request.freezed.dart';
part 'account_request.g.dart';

/// Request body for submitting a new account request (public endpoint)
@freezed
sealed class AccountRequestCreate with _$AccountRequestCreate {
  const factory AccountRequestCreate({
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    @JsonKey(name: 'role_id') required int roleId,
    String? birthdate,
    String? gender,
    @JsonKey(name: 'gender_other') String? genderOther,
  }) = _AccountRequestCreate;

  factory AccountRequestCreate.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestCreateFromJson(json);
}

/// Account request response from admin list endpoint
@freezed
sealed class AccountRequestResponse with _$AccountRequestResponse {
  const factory AccountRequestResponse({
    @JsonKey(name: 'request_id') required int requestId,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    @JsonKey(name: 'role_id') required int roleId,
    String? birthdate,
    String? gender,
    @JsonKey(name: 'gender_other') String? genderOther,
    required String status,
    @JsonKey(name: 'admin_notes') String? adminNotes,
    @JsonKey(name: 'reviewed_by') int? reviewedBy,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'reviewed_at') String? reviewedAt,
  }) = _AccountRequestResponse;

  factory AccountRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestResponseFromJson(json);
}

/// Count response for pending account requests
@freezed
sealed class AccountRequestCountResponse with _$AccountRequestCountResponse {
  const factory AccountRequestCountResponse({
    required int count,
  }) = _AccountRequestCountResponse;

  factory AccountRequestCountResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestCountResponseFromJson(json);
}

/// Request body for rejecting an account request
@freezed
sealed class AccountRequestRejectBody with _$AccountRequestRejectBody {
  const factory AccountRequestRejectBody({
    @JsonKey(name: 'admin_notes') String? adminNotes,
  }) = _AccountRequestRejectBody;

  factory AccountRequestRejectBody.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestRejectBodyFromJson(json);
}

/// A user-submitted deletion request (admin view)
@freezed
sealed class DeletionRequestResponse with _$DeletionRequestResponse {
  const factory DeletionRequestResponse({
    @JsonKey(name: 'request_id') required int requestId,
    @JsonKey(name: 'account_id') required int accountId,
    @JsonKey(name: 'full_name') String? fullName,
    required String email,
    required String status,
    @JsonKey(name: 'admin_notes') String? adminNotes,
    @JsonKey(name: 'reviewed_by') int? reviewedBy,
    @JsonKey(name: 'requested_at') required String requestedAt,
    @JsonKey(name: 'reviewed_at') String? reviewedAt,
  }) = _DeletionRequestResponse;

  factory DeletionRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$DeletionRequestResponseFromJson(json);
}

/// Count response for pending deletion requests
@freezed
sealed class DeletionRequestCountResponse with _$DeletionRequestCountResponse {
  const factory DeletionRequestCountResponse({
    required int count,
  }) = _DeletionRequestCountResponse;

  factory DeletionRequestCountResponse.fromJson(Map<String, dynamic> json) =>
      _$DeletionRequestCountResponseFromJson(json);
}
