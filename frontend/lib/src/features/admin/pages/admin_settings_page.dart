// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/pages/admin_settings_page.dart
//
// Admin Settings page — lets admins change system-wide operational settings.
// All settings are persisted in the SystemSettings DB table and cached on
// the backend (30 s TTL), so changes take effect almost immediately without
// a redeploy.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/api/models/models.dart';
import 'package:frontend/src/core/widgets/widgets.dart';
import 'package:frontend/src/features/admin/widgets/widgets.dart';
import 'package:frontend/src/features/admin/state/settings_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class AdminSettingsPage extends ConsumerWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settingsAsync = ref.watch(systemSettingsProvider);

    return AdminScaffold(
      currentRoute: '/admin/settings',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.adminSettingsTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          settingsAsync.when(
            loading: () => const Center(child: AppLoadingIndicator()),
            error: (e, _) => AppEmptyState.error(
              title: l10n.adminSettingsSaveError,
              centered: false,
              action: AppOutlinedButton(
                label: l10n.commonRetry,
                onPressed: () => ref.invalidate(systemSettingsProvider),
              ),
            ),
            data: (settings) => _SettingsForm(settings: settings),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Form
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.settings});
  final SystemSettings settings;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for numeric fields
  late TextEditingController _kController;
  late TextEditingController _maxAttemptsController;
  late TextEditingController _lockoutController;

  // Bool fields
  late bool _registrationOpen;
  late bool _maintenanceMode;
  late bool _consentRequired;
  late TextEditingController _maintenanceCompletionController;

  // Defaults (from the server response) used by "Reset to Default"
  int get _defaultK =>
      (widget.settings.defaults['k_anonymity_threshold'] as num?)?.toInt() ?? 1;
  int get _defaultAttempts =>
      (widget.settings.defaults['max_login_attempts'] as num?)?.toInt() ?? 10;
  int get _defaultLockout =>
      (widget.settings.defaults['lockout_duration_minutes'] as num?)?.toInt() ??
      30;

  @override
  void initState() {
    super.initState();
    _kController = TextEditingController(
      text: widget.settings.kAnonymityThreshold.toString(),
    );
    _maxAttemptsController = TextEditingController(
      text: widget.settings.maxLoginAttempts.toString(),
    );
    _lockoutController = TextEditingController(
      text: widget.settings.lockoutDurationMinutes.toString(),
    );
    _maintenanceCompletionController = TextEditingController(
      text: widget.settings.maintenanceCompletion,
    );
    _registrationOpen = widget.settings.registrationOpen;
    _maintenanceMode = widget.settings.maintenanceMode;
    _consentRequired = widget.settings.consentRequired;
  }

  @override
  void dispose() {
    _kController.dispose();
    _maxAttemptsController.dispose();
    _lockoutController.dispose();
    _maintenanceCompletionController.dispose();
    super.dispose();
  }

  SystemSettings _buildSettings() => SystemSettings(
    kAnonymityThreshold: int.tryParse(_kController.text.trim()) ?? _defaultK,
    registrationOpen: _registrationOpen,
    maintenanceMode: _maintenanceMode,
    maintenanceCompletion: _maintenanceCompletionController.text.trim(),
    maxLoginAttempts:
        int.tryParse(_maxAttemptsController.text.trim()) ?? _defaultAttempts,
    lockoutDurationMinutes:
        int.tryParse(_lockoutController.text.trim()) ?? _defaultLockout,
    consentRequired: _consentRequired,
  );

  Future<void> _saveWithFeedback(SystemSettings settings) async {
    await ref.read(systemSettingsNotifierProvider.notifier).save(settings);
    final saveState = ref.read(systemSettingsNotifierProvider);
    if (!mounted) return;
    saveState.when(
      data: (_) => AppToast.showSuccess(
        context,
        message: context.l10n.adminSettingsSaveSuccess,
      ),
      error: (e, _) => AppToast.showError(
        context,
        message: context.l10n.adminSettingsSaveError,
      ),
      loading: () {},
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await _saveWithFeedback(_buildSettings());
  }

  /// Auto-save called immediately when a toggle changes — no Save button needed
  /// for boolean settings so the effect is instant and obvious.
  Future<void> _onToggleChanged(void Function() mutateState) async {
    setState(mutateState);
    await _saveWithFeedback(_buildSettings());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final saveState = ref.watch(systemSettingsNotifierProvider);
    final isSaving = saveState is AsyncLoading;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Data Privacy ────────────────────────────────────────────────
            _SettingsSection(title: l10n.adminSettingsSectionPrivacy),
            _NumericSettingCard(
              label: l10n.adminSettingsKLabel,
              description: l10n.adminSettingsKDescription,
              fieldLabel: l10n.adminSettingsKFieldLabel,
              hint: l10n.adminSettingsKHint,
              controller: _kController,
              defaultVal: _defaultK,
              minValue: 1,
              allowZero: false,
              onReset: () =>
                  setState(() => _kController.text = _defaultK.toString()),
            ),
            const SizedBox(height: 12),

            // ── System ──────────────────────────────────────────────────────
            _SettingsSection(title: l10n.adminSettingsSectionSystem),
            _ToggleSettingCard(
              label: l10n.adminSettingsRegistrationLabel,
              description: l10n.adminSettingsRegistrationDescription,
              value: _registrationOpen,
              onChanged: (v) => _onToggleChanged(() => _registrationOpen = v),
            ),
            const SizedBox(height: 12),
            _ToggleSettingCard(
              label: l10n.adminSettingsMaintenanceLabel,
              description: l10n.adminSettingsMaintenanceDescription,
              value: _maintenanceMode,
              onChanged: (v) => _onToggleChanged(() => _maintenanceMode = v),
              warningColor: true,
            ),
            const SizedBox(height: 12),
            _TextSettingCard(
              label: l10n.adminSettingsMaintenanceCompletionLabel,
              description: l10n.adminSettingsMaintenanceCompletionDescription,
              controller: _maintenanceCompletionController,
              hintText: l10n.adminSettingsMaintenanceCompletionHint,
              maxLength: 200,
              maxLines: 1,
            ),
            const SizedBox(height: 12),
            _ToggleSettingCard(
              label: l10n.adminSettingsConsentRequiredLabel,
              description: l10n.adminSettingsConsentRequiredDescription,
              value: _consentRequired,
              onChanged: (v) => _onToggleChanged(() => _consentRequired = v),
            ),
            const SizedBox(height: 12),

            // ── Login Security ───────────────────────────────────────────────
            _SettingsSection(title: l10n.adminSettingsSectionSecurity),
            _NumericSettingCard(
              label: l10n.adminSettingsMaxAttemptsLabel,
              description: l10n.adminSettingsMaxAttemptsDescription,
              fieldLabel: l10n.adminSettingsMaxAttemptsFieldLabel,
              hint: l10n.adminSettingsMaxAttemptsHint,
              controller: _maxAttemptsController,
              defaultVal: _defaultAttempts,
              minValue: 0,
              allowZero: true,
              onReset: () => setState(
                () => _maxAttemptsController.text = _defaultAttempts.toString(),
              ),
            ),
            const SizedBox(height: 12),
            _NumericSettingCard(
              label: l10n.adminSettingsLockoutLabel,
              description: l10n.adminSettingsLockoutDescription,
              fieldLabel: l10n.adminSettingsLockoutFieldLabel,
              hint: l10n.adminSettingsLockoutHint,
              controller: _lockoutController,
              defaultVal: _defaultLockout,
              minValue: 1,
              allowZero: false,
              onReset: () => setState(
                () => _lockoutController.text = _defaultLockout.toString(),
              ),
            ),
            const SizedBox(height: 24),

            // ── Save row ─────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isSaving) ...[
                  const AppLoadingIndicator.inline(),
                  const SizedBox(width: 12),
                  AppText(
                    l10n.adminSettingsSaving,
                    variant: AppTextVariant.bodyMedium,
                    color: context.appColors.textMuted,
                  ),
                ] else
                  AppFilledButton(
                    label: l10n.adminSettingsSaveButton,
                    onPressed: _save,
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable section header widget
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            variant: AppTextVariant.bodyLarge,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 4),
          Divider(color: context.appColors.divider, height: 1),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable numeric setting card
// ─────────────────────────────────────────────────────────────────────────────

class _NumericSettingCard extends StatelessWidget {
  const _NumericSettingCard({
    required this.label,
    required this.description,
    required this.fieldLabel,
    required this.hint,
    required this.controller,
    required this.defaultVal,
    required this.minValue,
    required this.allowZero,
    required this.onReset,
  });

  final String label;
  final String description;
  final String fieldLabel;
  final String hint;
  final TextEditingController controller;
  final int defaultVal;
  final int minValue;
  final bool allowZero;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            label: label,
            defaultVal: defaultVal.toString(),
            onReset: onReset,
          ),
          const SizedBox(height: 6),
          AppText(
            description,
            variant: AppTextVariant.bodySmall,
            color: context.appColors.textMuted,
          ),
          const SizedBox(height: 12),
          Semantics(
            label: fieldLabel,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: fieldLabel,
                hintText: hint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              validator: (v) {
                final n = int.tryParse(v?.trim() ?? '');
                if (n == null) {
                  return l10n.adminSettingsValidationPositive;
                }
                if (!allowZero && n < 1) {
                  return l10n.adminSettingsValidationPositive;
                }
                if (allowZero && n < 0) {
                  return l10n.adminSettingsValidationNonNegative;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable toggle setting card
// ─────────────────────────────────────────────────────────────────────────────

class _ToggleSettingCard extends StatelessWidget {
  const _ToggleSettingCard({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    this.warningColor = false,
  });

  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool warningColor;

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  variant: AppTextVariant.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: warningColor && value ? AppTheme.error : null,
                ),
                const SizedBox(height: 4),
                AppText(
                  description,
                  variant: AppTextVariant.bodySmall,
                  color: context.appColors.textMuted,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Semantics(
            label: label,
            toggled: value,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: warningColor ? AppTheme.white : AppTheme.white,
              activeTrackColor: warningColor
                  ? AppTheme.error
                  : AppTheme.primary,
              inactiveThumbColor: AppTheme.white,
              inactiveTrackColor: const Color(0xFFBDBDBD),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextSettingCard extends StatelessWidget {
  const _TextSettingCard({
    required this.label,
    required this.description,
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.maxLines = 2,
  });

  final String label;
  final String description;
  final TextEditingController controller;
  final String hintText;
  final int? maxLength;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            variant: AppTextVariant.bodyMedium,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 4),
          AppText(
            description,
            variant: AppTextVariant.bodySmall,
            color: context.appColors.textMuted,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card header with label + reset badge
// ─────────────────────────────────────────────────────────────────────────────

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.label,
    required this.defaultVal,
    required this.onReset,
  });

  final String label;
  final String defaultVal;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: AppText(
            label,
            variant: AppTextVariant.bodyMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
        Tooltip(
          message: l10n.adminSettingsResetToDefault,
          child: InkWell(
            onTap: onReset,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: AppText(
                l10n.adminSettingsDefaultBadge(defaultVal),
                variant: AppTextVariant.bodySmall,
                color: context.appColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card container (shared styling)
// ─────────────────────────────────────────────────────────────────────────────

class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
      ),
      child: child,
    );
  }
}
