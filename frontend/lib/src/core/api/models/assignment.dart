// Created with the Assistance of Claude Code and Codex
// frontend/lib/core/api/models/assignment.dart
/// Assignment models matching backend Pydantic schemas
///
/// Run `dart run build_runner build` to generate .g.dart and .freezed.dart files
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment.freezed.dart';
part 'assignment.g.dart';

/// Assignment status enum matching backend AssignmentStatus
enum AssignmentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('expired')
  expired,
}

/// Assignment create request (single user)
@freezed
sealed class AssignmentCreate with _$AssignmentCreate {
  const factory AssignmentCreate({
    @JsonKey(name: 'account_id') required int accountId,
    @JsonKey(name: 'due_date') DateTime? dueDate,
  }) = _AssignmentCreate;

  factory AssignmentCreate.fromJson(Map<String, dynamic> json) =>
      _$AssignmentCreateFromJson(json);
}

/// Bulk assignment create request (multiple users)
@freezed
sealed class BulkAssignmentCreate with _$BulkAssignmentCreate {
  const factory BulkAssignmentCreate({
    @JsonKey(name: 'account_ids') required List<int> accountIds,
    @JsonKey(name: 'due_date') DateTime? dueDate,
  }) = _BulkAssignmentCreate;

  factory BulkAssignmentCreate.fromJson(Map<String, dynamic> json) =>
      _$BulkAssignmentCreateFromJson(json);
}

/// Bulk assignment response for demographic/all-participant assignment.
@freezed
sealed class BulkAssignmentResult with _$BulkAssignmentResult {
  const factory BulkAssignmentResult({
    required int assigned,
    required int skipped,
    @JsonKey(name: 'total_targeted') required int totalTargeted,
  }) = _BulkAssignmentResult;

  factory BulkAssignmentResult.fromJson(Map<String, dynamic> json) =>
      _$BulkAssignmentResultFromJson(json);
}

/// Assignment update request
@freezed
sealed class AssignmentUpdate with _$AssignmentUpdate {
  const factory AssignmentUpdate({
    @JsonKey(name: 'due_date') DateTime? dueDate,
    String? status,
  }) = _AssignmentUpdate;

  factory AssignmentUpdate.fromJson(Map<String, dynamic> json) =>
      _$AssignmentUpdateFromJson(json);
}

/// Assignment response model matching backend AssignmentResponse
@freezed
sealed class Assignment with _$Assignment {
  const factory Assignment({
    @JsonKey(name: 'assignment_id') required int assignmentId,
    @JsonKey(name: 'survey_id') required int surveyId,
    @JsonKey(name: 'account_id') required int accountId,
    @JsonKey(name: 'assigned_at') DateTime? assignedAt,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    required String status,
  }) = _Assignment;

  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
}

/// My assignment response (for /assignments/me endpoint)
@freezed
sealed class MyAssignment with _$MyAssignment {
  const factory MyAssignment({
    @JsonKey(name: 'assignment_id') required int assignmentId,
    @JsonKey(name: 'survey_id') required int surveyId,
    @JsonKey(name: 'survey_title') String? surveyTitle,
    @JsonKey(name: 'assigned_at') DateTime? assignedAt,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    required String status,
  }) = _MyAssignment;

  factory MyAssignment.fromJson(Map<String, dynamic> json) =>
      _$MyAssignmentFromJson(json);
}
