// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/audit_log.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

/// Single audit event
@freezed
sealed class AuditEvent with _$AuditEvent {
  const factory AuditEvent({
    @JsonKey(name: 'audit_event_id') required int auditEventId,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'request_id') String? requestId,
    @JsonKey(name: 'actor_type') required String actorType,
    @JsonKey(name: 'actor_account_id') int? actorAccountId,
    @JsonKey(name: 'actor_email') String? actorEmail,
    @JsonKey(name: 'actor_name') String? actorName,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'user_agent') String? userAgent,
    @JsonKey(name: 'http_method') String? httpMethod,
    String? path,
    required String action,
    @JsonKey(name: 'resource_type') required String resourceType,
    @JsonKey(name: 'resource_id') String? resourceId,
    required String status,
    @JsonKey(name: 'http_status_code') int? httpStatusCode,
    @JsonKey(name: 'error_code') String? errorCode,
    Map<String, dynamic>? metadata,
  }) = _AuditEvent;

  factory AuditEvent.fromJson(Map<String, dynamic> json) =>
      _$AuditEventFromJson(json);
}

/// Response for audit log listing
@freezed
sealed class AuditLogResponse with _$AuditLogResponse {
  @JsonSerializable(explicitToJson: true)
  const factory AuditLogResponse({
    required List<AuditEvent> events,
    required int total,
    required int limit,
    required int offset,
  }) = _AuditLogResponse;

  factory AuditLogResponse.fromJson(Map<String, dynamic> json) =>
      _$AuditLogResponseFromJson(json);
}
