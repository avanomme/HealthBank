// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SystemSettings _$SystemSettingsFromJson(Map<String, dynamic> json) =>
    _SystemSettings(
      kAnonymityThreshold: (json['k_anonymity_threshold'] as num).toInt(),
      registrationOpen: json['registration_open'] as bool,
      maintenanceMode: json['maintenance_mode'] as bool,
      maintenanceMessage: json['maintenance_message'] as String? ?? '',
      maintenanceCompletion: json['maintenance_completion'] as String? ?? '',
      maxLoginAttempts: (json['max_login_attempts'] as num).toInt(),
      lockoutDurationMinutes: (json['lockout_duration_minutes'] as num).toInt(),
      consentRequired: json['consent_required'] as bool? ?? true,
      defaults: json['defaults'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$SystemSettingsToJson(_SystemSettings instance) =>
    <String, dynamic>{
      'k_anonymity_threshold': instance.kAnonymityThreshold,
      'registration_open': instance.registrationOpen,
      'maintenance_mode': instance.maintenanceMode,
      'maintenance_message': instance.maintenanceMessage,
      'maintenance_completion': instance.maintenanceCompletion,
      'max_login_attempts': instance.maxLoginAttempts,
      'lockout_duration_minutes': instance.lockoutDurationMinutes,
      'consent_required': instance.consentRequired,
      'defaults': instance.defaults,
    };
