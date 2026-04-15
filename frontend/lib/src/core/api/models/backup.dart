// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/backup.dart
/// Backup models matching backend backup endpoints.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup.freezed.dart';
part 'backup.g.dart';

/// Single backup file metadata
@freezed
sealed class BackupInfo with _$BackupInfo {
  const factory BackupInfo({
    required String filename,
    @JsonKey(name: 'backup_type') required String backupType,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'size_bytes') required int sizeBytes,
    @JsonKey(name: 'size_human') required String sizeHuman,
  }) = _BackupInfo;

  factory BackupInfo.fromJson(Map<String, dynamic> json) =>
      _$BackupInfoFromJson(json);
}

/// Result of a restore operation
@freezed
sealed class RestoreResult with _$RestoreResult {
  const factory RestoreResult({
    @JsonKey(name: 'pre_backup_filename') required String preBackupFilename,
    @JsonKey(name: 'pre_backup_size_human') required String preBackupSizeHuman,
    @JsonKey(name: 'restored_file') required String restoredFile,
    @JsonKey(name: 'migrations_run') required int migrationsRun,
    required String message,
  }) = _RestoreResult;

  factory RestoreResult.fromJson(Map<String, dynamic> json) =>
      _$RestoreResultFromJson(json);
}
