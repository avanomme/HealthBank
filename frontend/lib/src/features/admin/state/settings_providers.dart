// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/state/settings_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/models.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart'
    show adminApiProvider;
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show publicConfigProvider;

/// Fetches the current system settings from the backend.
final systemSettingsProvider =
    FutureProvider.autoDispose<SystemSettings>((ref) async {
  final api = ref.watch(adminApiProvider);
  return api.getSettings();
});

/// Tracks the async state of a settings save operation.
class SystemSettingsNotifier extends StateNotifier<AsyncValue<void>> {
  SystemSettingsNotifier(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> save(SystemSettings settings) async {
    state = const AsyncLoading();
    try {
      final api = _ref.read(adminApiProvider);
      await api.updateSettings({
        'k_anonymity_threshold':    settings.kAnonymityThreshold,
        'registration_open':        settings.registrationOpen,
        'maintenance_mode':         settings.maintenanceMode,
        'maintenance_message':      settings.maintenanceMessage,
        'maintenance_completion':   settings.maintenanceCompletion,
        'max_login_attempts':       settings.maxLoginAttempts,
        'lockout_duration_minutes': settings.lockoutDurationMinutes,
        'consent_required':         settings.consentRequired,
      });
      _ref.invalidate(systemSettingsProvider);
      _ref.invalidate(publicConfigProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final systemSettingsNotifierProvider = StateNotifierProvider.autoDispose<
    SystemSettingsNotifier, AsyncValue<void>>(
  (ref) => SystemSettingsNotifier(ref),
);
