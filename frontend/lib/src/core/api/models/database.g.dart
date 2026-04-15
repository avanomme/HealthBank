// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ColumnInfo _$ColumnInfoFromJson(Map<String, dynamic> json) => _ColumnInfo(
  name: json['name'] as String,
  type: json['type'] as String,
  isPrimaryKey: json['is_primary_key'] as bool? ?? false,
  isForeignKey: json['is_foreign_key'] as bool? ?? false,
  isNullable: json['is_nullable'] as bool? ?? true,
  foreignKeyRef: json['foreign_key_ref'] as String?,
);

Map<String, dynamic> _$ColumnInfoToJson(_ColumnInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'is_primary_key': instance.isPrimaryKey,
      'is_foreign_key': instance.isForeignKey,
      'is_nullable': instance.isNullable,
      'foreign_key_ref': instance.foreignKeyRef,
    };

_TableSchema _$TableSchemaFromJson(Map<String, dynamic> json) => _TableSchema(
  name: json['name'] as String,
  description: json['description'] as String,
  columns: (json['columns'] as List<dynamic>)
      .map((e) => ColumnInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  rowCount: (json['row_count'] as num).toInt(),
);

Map<String, dynamic> _$TableSchemaToJson(_TableSchema instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'columns': instance.columns.map((e) => e.toJson()).toList(),
      'row_count': instance.rowCount,
    };

_TableData _$TableDataFromJson(Map<String, dynamic> json) => _TableData(
  name: json['name'] as String,
  columns: (json['columns'] as List<dynamic>).map((e) => e as String).toList(),
  rows: (json['rows'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$TableDataToJson(_TableData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'columns': instance.columns,
      'rows': instance.rows,
      'total': instance.total,
    };

_TableListResponse _$TableListResponseFromJson(Map<String, dynamic> json) =>
    _TableListResponse(
      tables: (json['tables'] as List<dynamic>)
          .map((e) => TableSchema.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TableListResponseToJson(_TableListResponse instance) =>
    <String, dynamic>{
      'tables': instance.tables.map((e) => e.toJson()).toList(),
    };

_TableDetailResponse _$TableDetailResponseFromJson(Map<String, dynamic> json) =>
    _TableDetailResponse(
      schemaInfo: TableSchema.fromJson(
        json['schema_info'] as Map<String, dynamic>,
      ),
      data: TableData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TableDetailResponseToJson(
  _TableDetailResponse instance,
) => <String, dynamic>{
  'schema_info': instance.schemaInfo.toJson(),
  'data': instance.data.toJson(),
};

_PasswordResetRequest _$PasswordResetRequestFromJson(
  Map<String, dynamic> json,
) => _PasswordResetRequest(newPassword: json['new_password'] as String);

Map<String, dynamic> _$PasswordResetRequestToJson(
  _PasswordResetRequest instance,
) => <String, dynamic>{'new_password': instance.newPassword};

_PasswordResetResponse _$PasswordResetResponseFromJson(
  Map<String, dynamic> json,
) => _PasswordResetResponse(
  message: json['message'] as String,
  userId: (json['user_id'] as num).toInt(),
);

Map<String, dynamic> _$PasswordResetResponseToJson(
  _PasswordResetResponse instance,
) => <String, dynamic>{'message': instance.message, 'user_id': instance.userId};

_SendResetEmailRequest _$SendResetEmailRequestFromJson(
  Map<String, dynamic> json,
) => _SendResetEmailRequest(
  temporaryPassword: json['temporary_password'] as String,
  emailOverride: json['email_override'] as String?,
);

Map<String, dynamic> _$SendResetEmailRequestToJson(
  _SendResetEmailRequest instance,
) => <String, dynamic>{
  'temporary_password': instance.temporaryPassword,
  'email_override': instance.emailOverride,
};

_SendResetEmailResponse _$SendResetEmailResponseFromJson(
  Map<String, dynamic> json,
) => _SendResetEmailResponse(
  message: json['message'] as String,
  sentTo: json['sent_to'] as String,
  userId: (json['user_id'] as num).toInt(),
);

Map<String, dynamic> _$SendResetEmailResponseToJson(
  _SendResetEmailResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'sent_to': instance.sentTo,
  'user_id': instance.userId,
};
