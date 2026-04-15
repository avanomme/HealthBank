// Created with the Assistance of Claude Code
// frontend/lib/core/api/models/user.dart
/// User models matching backend Pydantic schemas
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User role enum matching backend UserRole
enum UserRole {
  @JsonValue('participant')
  participant,
  @JsonValue('researcher')
  researcher,
  @JsonValue('hcp')
  hcp,
  @JsonValue('admin')
  admin,
}

/// Extension for UserRole display names
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.participant:
        return 'Participant';
      case UserRole.researcher:
        return 'Researcher';
      case UserRole.hcp:
        return 'Healthcare Professional';
      case UserRole.admin:
        return 'Admin';
    }
  }
}

/// User create request model matching backend UserCreate
@freezed
sealed class UserCreate with _$UserCreate {
  const factory UserCreate({
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    String? password,
    UserRole? role,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'send_setup_email') bool? sendSetupEmail,
    String? birthdate,
    String? gender,
  }) = _UserCreate;

  factory UserCreate.fromJson(Map<String, dynamic> json) =>
      _$UserCreateFromJson(json);
}

/// User update request model matching backend UserUpdate
@freezed
sealed class UserUpdate with _$UserUpdate {
  const factory UserUpdate({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? email,
    UserRole? role,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _UserUpdate;

  factory UserUpdate.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateFromJson(json);
}

/// Current user self-update request model matching backend CurrentUserUpdate
@freezed
sealed class CurrentUserUpdate with _$CurrentUserUpdate {
  const factory CurrentUserUpdate({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? email,
    DateTime? birthdate,
    String? gender,
  }) = _CurrentUserUpdate;

  factory CurrentUserUpdate.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserUpdateFromJson(json);
}

/// User response model matching backend UserResponse
@freezed
sealed class User with _$User {
  const factory User({
    @JsonKey(name: 'account_id') required int accountId,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    String? role,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    DateTime? birthdate,
    String? gender,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
    @JsonKey(name: 'consent_signed_at') DateTime? consentSignedAt,
    @JsonKey(name: 'consent_version') String? consentVersion,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Extension for User helper methods
extension UserExtension on User {
  String get fullName => '$firstName $lastName';

  UserRole? get roleEnum {
    if (role == null) return null;
    try {
      return UserRole.values.firstWhere(
        (r) => r.name == role,
        orElse: () => UserRole.participant,
      );
    } catch (_) {
      return null;
    }
  }
}

/// User list response model matching backend UserListResponse
@freezed
sealed class UserListResponse with _$UserListResponse {
  @JsonSerializable(explicitToJson: true)
  const factory UserListResponse({
    required List<User> users,
    required int total,
  }) = _UserListResponse;

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      _$UserListResponseFromJson(json);
}
