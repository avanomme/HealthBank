// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditEvent _$AuditEventFromJson(Map<String, dynamic> json) => _AuditEvent(
  auditEventId: (json['audit_event_id'] as num).toInt(),
  createdAt: json['created_at'] as String,
  requestId: json['request_id'] as String?,
  actorType: json['actor_type'] as String,
  actorAccountId: (json['actor_account_id'] as num?)?.toInt(),
  actorEmail: json['actor_email'] as String?,
  actorName: json['actor_name'] as String?,
  ipAddress: json['ip_address'] as String?,
  userAgent: json['user_agent'] as String?,
  httpMethod: json['http_method'] as String?,
  path: json['path'] as String?,
  action: json['action'] as String,
  resourceType: json['resource_type'] as String,
  resourceId: json['resource_id'] as String?,
  status: json['status'] as String,
  httpStatusCode: (json['http_status_code'] as num?)?.toInt(),
  errorCode: json['error_code'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AuditEventToJson(_AuditEvent instance) =>
    <String, dynamic>{
      'audit_event_id': instance.auditEventId,
      'created_at': instance.createdAt,
      'request_id': instance.requestId,
      'actor_type': instance.actorType,
      'actor_account_id': instance.actorAccountId,
      'actor_email': instance.actorEmail,
      'actor_name': instance.actorName,
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'http_method': instance.httpMethod,
      'path': instance.path,
      'action': instance.action,
      'resource_type': instance.resourceType,
      'resource_id': instance.resourceId,
      'status': instance.status,
      'http_status_code': instance.httpStatusCode,
      'error_code': instance.errorCode,
      'metadata': instance.metadata,
    };

_AuditLogResponse _$AuditLogResponseFromJson(Map<String, dynamic> json) =>
    _AuditLogResponse(
      events: (json['events'] as List<dynamic>)
          .map((e) => AuditEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$AuditLogResponseToJson(_AuditLogResponse instance) =>
    <String, dynamic>{
      'events': instance.events.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };
