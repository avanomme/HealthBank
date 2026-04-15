// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssignmentCreate _$AssignmentCreateFromJson(Map<String, dynamic> json) =>
    _AssignmentCreate(
      accountId: (json['account_id'] as num).toInt(),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
    );

Map<String, dynamic> _$AssignmentCreateToJson(_AssignmentCreate instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'due_date': instance.dueDate?.toIso8601String(),
    };

_BulkAssignmentCreate _$BulkAssignmentCreateFromJson(
  Map<String, dynamic> json,
) => _BulkAssignmentCreate(
  accountIds: (json['account_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
);

Map<String, dynamic> _$BulkAssignmentCreateToJson(
  _BulkAssignmentCreate instance,
) => <String, dynamic>{
  'account_ids': instance.accountIds,
  'due_date': instance.dueDate?.toIso8601String(),
};

_BulkAssignmentResult _$BulkAssignmentResultFromJson(
  Map<String, dynamic> json,
) => _BulkAssignmentResult(
  assigned: (json['assigned'] as num).toInt(),
  skipped: (json['skipped'] as num).toInt(),
  totalTargeted: (json['total_targeted'] as num).toInt(),
);

Map<String, dynamic> _$BulkAssignmentResultToJson(
  _BulkAssignmentResult instance,
) => <String, dynamic>{
  'assigned': instance.assigned,
  'skipped': instance.skipped,
  'total_targeted': instance.totalTargeted,
};

_AssignmentUpdate _$AssignmentUpdateFromJson(Map<String, dynamic> json) =>
    _AssignmentUpdate(
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AssignmentUpdateToJson(_AssignmentUpdate instance) =>
    <String, dynamic>{
      'due_date': instance.dueDate?.toIso8601String(),
      'status': instance.status,
    };

_Assignment _$AssignmentFromJson(Map<String, dynamic> json) => _Assignment(
  assignmentId: (json['assignment_id'] as num).toInt(),
  surveyId: (json['survey_id'] as num).toInt(),
  accountId: (json['account_id'] as num).toInt(),
  assignedAt: json['assigned_at'] == null
      ? null
      : DateTime.parse(json['assigned_at'] as String),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$AssignmentToJson(_Assignment instance) =>
    <String, dynamic>{
      'assignment_id': instance.assignmentId,
      'survey_id': instance.surveyId,
      'account_id': instance.accountId,
      'assigned_at': instance.assignedAt?.toIso8601String(),
      'due_date': instance.dueDate?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'status': instance.status,
    };

_MyAssignment _$MyAssignmentFromJson(Map<String, dynamic> json) =>
    _MyAssignment(
      assignmentId: (json['assignment_id'] as num).toInt(),
      surveyId: (json['survey_id'] as num).toInt(),
      surveyTitle: json['survey_title'] as String?,
      assignedAt: json['assigned_at'] == null
          ? null
          : DateTime.parse(json['assigned_at'] as String),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$MyAssignmentToJson(_MyAssignment instance) =>
    <String, dynamic>{
      'assignment_id': instance.assignmentId,
      'survey_id': instance.surveyId,
      'survey_title': instance.surveyTitle,
      'assigned_at': instance.assignedAt?.toIso8601String(),
      'due_date': instance.dueDate?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'status': instance.status,
    };
