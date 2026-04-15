// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/models/settings.dart
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
sealed class SystemSettings with _$SystemSettings {
  const factory SystemSettings({
    @JsonKey(name: 'k_anonymity_threshold') required int kAnonymityThreshold,
    @JsonKey(name: 'registration_open') required bool registrationOpen,
    @JsonKey(name: 'maintenance_mode') required bool maintenanceMode,
    @JsonKey(name: 'maintenance_message') @Default('') String maintenanceMessage,
    @JsonKey(name: 'maintenance_completion') @Default('') String maintenanceCompletion,
    @JsonKey(name: 'max_login_attempts') required int maxLoginAttempts,
    @JsonKey(name: 'lockout_duration_minutes') required int lockoutDurationMinutes,
    @JsonKey(name: 'consent_required') @Default(true) bool consentRequired,
    @Default({}) Map<String, dynamic> defaults,
  }) = _SystemSettings;

  factory SystemSettings.fromJson(Map<String, dynamic> json) =>
      _$SystemSettingsFromJson(json);
}
