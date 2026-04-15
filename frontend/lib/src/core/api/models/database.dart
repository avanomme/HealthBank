// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/database.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'database.freezed.dart';
part 'database.g.dart';

/// Column information for a database table
@freezed
sealed class ColumnInfo with _$ColumnInfo {
  const factory ColumnInfo({
    required String name,
    required String type,
    @JsonKey(name: 'is_primary_key') @Default(false) bool isPrimaryKey,
    @JsonKey(name: 'is_foreign_key') @Default(false) bool isForeignKey,
    @JsonKey(name: 'is_nullable') @Default(true) bool isNullable,
    @JsonKey(name: 'foreign_key_ref') String? foreignKeyRef,
  }) = _ColumnInfo;

  factory ColumnInfo.fromJson(Map<String, dynamic> json) =>
      _$ColumnInfoFromJson(json);
}

/// Table schema information
@freezed
sealed class TableSchema with _$TableSchema {
  @JsonSerializable(explicitToJson: true)
  const factory TableSchema({
    required String name,
    required String description,
    required List<ColumnInfo> columns,
    @JsonKey(name: 'row_count') required int rowCount,
  }) = _TableSchema;

  factory TableSchema.fromJson(Map<String, dynamic> json) =>
      _$TableSchemaFromJson(json);
}

/// Table data response
@freezed
sealed class TableData with _$TableData {
  const factory TableData({
    required String name,
    required List<String> columns,
    required List<Map<String, dynamic>> rows,
    required int total,
  }) = _TableData;

  factory TableData.fromJson(Map<String, dynamic> json) =>
      _$TableDataFromJson(json);
}

/// Response containing list of tables
@freezed
sealed class TableListResponse with _$TableListResponse {
  @JsonSerializable(explicitToJson: true)
  const factory TableListResponse({
    required List<TableSchema> tables,
  }) = _TableListResponse;

  factory TableListResponse.fromJson(Map<String, dynamic> json) =>
      _$TableListResponseFromJson(json);
}

/// Response containing table schema and data
@freezed
sealed class TableDetailResponse with _$TableDetailResponse {
  @JsonSerializable(explicitToJson: true)
  const factory TableDetailResponse({
    @JsonKey(name: 'schema_info') required TableSchema schemaInfo,
    required TableData data,
  }) = _TableDetailResponse;

  factory TableDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$TableDetailResponseFromJson(json);
}

// =============================================================================
// Password Reset Models
// =============================================================================

/// Request body for password reset
@freezed
sealed class PasswordResetRequest with _$PasswordResetRequest {
  const factory PasswordResetRequest({
    @JsonKey(name: 'new_password') required String newPassword,
  }) = _PasswordResetRequest;

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);
}

/// Response for successful password reset
@freezed
sealed class PasswordResetResponse with _$PasswordResetResponse {
  const factory PasswordResetResponse({
    required String message,
    @JsonKey(name: 'user_id') required int userId,
  }) = _PasswordResetResponse;

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetResponseFromJson(json);
}

/// Request body for sending password reset email
@freezed
sealed class SendResetEmailRequest with _$SendResetEmailRequest {
  const factory SendResetEmailRequest({
    @JsonKey(name: 'temporary_password') required String temporaryPassword,
    @JsonKey(name: 'email_override') String? emailOverride,
  }) = _SendResetEmailRequest;

  factory SendResetEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$SendResetEmailRequestFromJson(json);
}

/// Response for password reset email
@freezed
sealed class SendResetEmailResponse with _$SendResetEmailResponse {
  const factory SendResetEmailResponse({
    required String message,
    @JsonKey(name: 'sent_to') required String sentTo,
    @JsonKey(name: 'user_id') required int userId,
  }) = _SendResetEmailResponse;

  factory SendResetEmailResponse.fromJson(Map<String, dynamic> json) =>
      _$SendResetEmailResponseFromJson(json);
}
