// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupInfo _$BackupInfoFromJson(Map<String, dynamic> json) => _BackupInfo(
  filename: json['filename'] as String,
  backupType: json['backup_type'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  sizeBytes: (json['size_bytes'] as num).toInt(),
  sizeHuman: json['size_human'] as String,
);

Map<String, dynamic> _$BackupInfoToJson(_BackupInfo instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'backup_type': instance.backupType,
      'created_at': instance.createdAt.toIso8601String(),
      'size_bytes': instance.sizeBytes,
      'size_human': instance.sizeHuman,
    };

_RestoreResult _$RestoreResultFromJson(Map<String, dynamic> json) =>
    _RestoreResult(
      preBackupFilename: json['pre_backup_filename'] as String,
      preBackupSizeHuman: json['pre_backup_size_human'] as String,
      restoredFile: json['restored_file'] as String,
      migrationsRun: (json['migrations_run'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$RestoreResultToJson(_RestoreResult instance) =>
    <String, dynamic>{
      'pre_backup_filename': instance.preBackupFilename,
      'pre_backup_size_human': instance.preBackupSizeHuman,
      'restored_file': instance.restoredFile,
      'migrations_run': instance.migrationsRun,
      'message': instance.message,
    };
