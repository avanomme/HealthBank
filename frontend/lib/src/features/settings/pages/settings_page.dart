// generated with help from chatGPT
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/src/config/go_router.dart' show AppRoutes;
import 'package:frontend/src/core/theme/chrome_style_provider.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_filled_button.dart';
import 'package:frontend/src/core/widgets/buttons/app_outlined_button.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show authApiProvider, authProvider;
import 'package:frontend/src/features/auth/state/impersonation_provider.dart'
    show currentUserRoleProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

import 'package:frontend/src/core/api/api.dart'; // TwoFactorAPI + models

/// User settings page for managing 2FA, appearance, language, and account actions.
///
/// Accessible by all authenticated roles. Wrapped in a [RoleAwareScaffold].
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _busy = false;
  AppAppearance? _draftAppearance;

  TwoFactorAPI _twoFactorApi() {
    final client = ref.read(apiClientProvider);
    return TwoFactorAPI(client.dio);
  }

  Future<void> _disable2fa() async {
    setState(() {
      _busy = true;
    });

    try {
      final api = _twoFactorApi();
      final res = await api.twoFactorDisable();

      if (!mounted) return;
      setState(() => _busy = false);

      final message = (res.message.isNotEmpty)
          ? res.message
          : context.l10n.settings2faDisabledSuccess;
      AppToast.showSuccess(context, message: message);
    } catch (e) {
      if (!mounted) return;
      String msg = context.l10n.settingsDisable2faFailed;
      if (e is DioException && e.error is ApiException) {
        msg = (e.error as ApiException).message;
      }
      setState(() {
        _busy = false;
      });
      AppToast.showError(context, message: msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoleAwareScaffold(
      currentRoute: '/settings',
      showFooter: false,
      child: Center(child: _buildCard(context)),
    );
  }

  Widget _buildCard(BuildContext context) {
    final appearance = ref.watch(appAppearanceProvider);
    final draftAppearance = _draftAppearance ?? appearance;
    final hasPendingAppearanceChanges = draftAppearance != appearance;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final cardPadding = isMobile ? 24.0 : 40.0;

    return Container(
      constraints: const BoxConstraints(maxWidth: 720),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            child: Text(
              context.l10n.settingsTitle,
              style: AppTheme.heading2.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.settingsManageAccountSubtitle,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Semantics(
              header: true,
              child: Text(
                context.l10n.settingsAppearanceSectionTitle,
                style: AppTheme.heading3.copyWith(
                  color: context.appColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _AppearanceSettingsSection(
            appearance: draftAppearance,
            hasPendingChanges: hasPendingAppearanceChanges,
            onApply: hasPendingAppearanceChanges
                ? () async {
                    await ref
                        .read(appAppearanceProvider.notifier)
                        .setAppearance(draftAppearance);
                    if (!context.mounted) return;
                    setState(() {
                      _draftAppearance = null;
                    });
                    AppToast.showSuccess(
                      context,
                      message: context.l10n.settingsAppearanceUpdated,
                    );
                  }
                : null,
            onReset: hasPendingAppearanceChanges
                ? () {
                    setState(() {
                      _draftAppearance = appearance;
                    });
                  }
                : null,
            onPresetSelected: (preset) {
              setState(() {
                _draftAppearance = AppTheme.appearanceForPreset(preset);
              });
            },
          ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Semantics(
              header: true,
              child: Text(
                context.l10n.settingsSecuritySectionTitle,
                style: AppTheme.heading3.copyWith(
                  color: context.appColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          if (_busy) ...[
            const AppLoadingIndicator(),
            const SizedBox(height: 16),
          ],

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.appColors.divider),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(context.l10n.auth2faTitle),
                  subtitle: Text(context.l10n.settings2faListSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _busy
                      ? null
                      : () => context.push('/two-factor?returnTo=/settings'),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    context.l10n.settingsDisable2faTitle,
                    style: AppTheme.body.copyWith(
                      color: AppTheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(context.l10n.settingsDisable2faSubtitle),
                  trailing: _busy
                      ? const AppLoadingIndicator.inline(size: 18)
                      : const Icon(Icons.lock_open),
                  onTap: _busy
                      ? null
                      : () async {
                          final ok = await AppConfirmDialog.show(
                            context,
                            title: context.l10n.settingsDisable2faDialogTitle,
                            content: context.l10n.settingsDisable2faDialogBody,
                            confirmLabel:
                                context.l10n.settingsDisable2faDialogConfirm,
                            cancelLabel:
                                context.l10n.settingsDisable2faDialogCancel,
                            isDangerous: true,
                          );

                          if (ok) {
                            await _disable2fa();
                          }
                        },
                ),
                if (ref.watch(currentUserRoleProvider) != 'admin') ...[
                  const Divider(height: 1),
                  ListTile(
                    title: Text(
                      context.l10n.settingsDeleteAccountTitle,
                      style: AppTheme.body.copyWith(
                        color: AppTheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(context.l10n.settingsDeleteAccountSubtitle),
                    trailing: _busy
                        ? const AppLoadingIndicator.inline(size: 18)
                        : const Icon(Icons.delete_forever),
                    onTap: _busy
                        ? null
                        : () async {
                            final l10n = context.l10n;
                            final confirmed = await AppConfirmDialog.show(
                              context,
                              title: l10n.settingsDeleteAccountDialogTitle,
                              content: l10n.settingsDeleteAccountDialogBody,
                              confirmLabel: l10n.settingsDeleteAccountConfirm,
                              cancelLabel: l10n.settingsDeleteAccountCancel,
                              isDangerous: true,
                            );
                            if (!confirmed) return;
                            setState(() => _busy = true);
                            try {
                              await ref
                                  .read(authApiProvider)
                                  .requestAccountDeletion();
                              await ref.read(authProvider.notifier).logout();
                              if (!context.mounted) return;
                              context.go(AppRoutes.login);
                            } catch (_) {
                              if (!context.mounted) return;
                              setState(() {
                                _busy = false;
                              });
                              AppToast.showError(
                                context,
                                message: l10n.settingsDeleteAccountFailed,
                              );
                            }
                          },
                  ),
                ],
                const Divider(height: 1),
                ListTile(
                  title: Text(context.l10n.changePasswordTitle),
                  subtitle: Text(context.l10n.settingsChangePasswordSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _busy ? null : () => context.push(AppRoutes.changePassword),
                ),
                const Divider(height: 1),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AppearanceSettingsSection extends StatelessWidget {
  const _AppearanceSettingsSection({
    required this.appearance,
    required this.hasPendingChanges,
    required this.onApply,
    required this.onReset,
    required this.onPresetSelected,
  });

  final AppAppearance appearance;
  final bool hasPendingChanges;
  final VoidCallback? onApply;
  final VoidCallback? onReset;
  final ValueChanged<AppThemePreset> onPresetSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.settingsAppearanceSubtitle,
            style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppThemePreset.values
                .map(
                  (preset) => SizedBox(
                    width: 150,
                    child: _AppearanceStyleCard(
                      preset: preset,
                      isSelected:
                          AppTheme.presetForAppearance(appearance) == preset,
                      onTap: () => onPresetSelected(preset),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (hasPendingChanges)
                Expanded(
                  child: AppOutlinedButton(
                    label: context.l10n.settingsAppearanceReset,
                    onPressed: onReset,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    foregroundColor: context.appColors.textMuted,
                    borderColor: context.appColors.divider,
                    textStyle: AppTheme.captions.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (hasPendingChanges) const SizedBox(width: 8),
              Expanded(
                child: AppFilledButton(
                  label: hasPendingChanges ? context.l10n.settingsAppearanceApply : context.l10n.settingsAppearanceApplied,
                  onPressed: onApply,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  textStyle: AppTheme.captions.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppearanceStyleCard extends StatelessWidget {
  const _AppearanceStyleCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final AppThemePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final previewAppearance = AppTheme.appearanceForPreset(preset);

    final previewTop = _previewChromeTop(previewAppearance);
    final previewMid = _previewChromeBackground(previewAppearance);
    final previewBottom = _previewChromeBottom(previewAppearance);
    final previewBorder = _previewChromeBorder(previewAppearance);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          border: Border.all(
            color: isSelected ? AppTheme.primary : context.appColors.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: previewAppearance.chromeStyle == ChromeStyle.flat
                    ? null
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          previewTop,
                          previewMid,
                          previewBottom,
                        ],
                      ),
                color: previewAppearance.chromeStyle == ChromeStyle.flat
                    ? previewMid
                    : null,
                border: Border.all(color: previewBorder),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: previewBottom,
                    border: Border(
                      top: BorderSide(color: previewBorder),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _presetLabel(context, preset),
              style: AppTheme.captions.copyWith(
                color: context.appColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _presetDescription(context, preset),
              style: AppTheme.captions.copyWith(
                color: context.appColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _presetLabel(BuildContext context, AppThemePreset preset) {
    switch (preset) {
      case AppThemePreset.classicCream:
        return context.l10n.themePresetClassicCream;
      case AppThemePreset.classicGrey:
        return context.l10n.themePresetClassicGrey;
      case AppThemePreset.modern:
        return context.l10n.themePresetModern;
      case AppThemePreset.dark:
        return context.l10n.themePresetDark;
    }
  }

  String _presetDescription(BuildContext context, AppThemePreset preset) {
    switch (preset) {
      case AppThemePreset.classicCream:
        return context.l10n.themePresetClassicCreamDesc;
      case AppThemePreset.classicGrey:
        return context.l10n.themePresetClassicGreyDesc;
      case AppThemePreset.modern:
        return context.l10n.themePresetModernDesc;
      case AppThemePreset.dark:
        return context.l10n.themePresetDarkDesc;
    }
  }

  Color _previewChromeTop(AppAppearance appearance) {
    switch ((appearance.chromeStyle, appearance.themeMode)) {
      case (ChromeStyle.classic, AppThemeMode.light):
        return const Color(0xFFFCFAF4);
      case (ChromeStyle.classic, AppThemeMode.dark):
        return const Color(0xFF342D24);
      case (ChromeStyle.modern, AppThemeMode.light):
        return const Color(0xFFFBFCFE);
      case (ChromeStyle.modern, AppThemeMode.dark):
        return const Color(0xFF293445);
      case (ChromeStyle.flat, AppThemeMode.light):
        return const Color(0xFFF5F7FA);
      case (ChromeStyle.flat, AppThemeMode.dark):
        return const Color(0xFF151B24);
    }
  }

  Color _previewChromeBackground(AppAppearance appearance) {
    switch ((appearance.chromeStyle, appearance.themeMode)) {
      case (ChromeStyle.classic, AppThemeMode.light):
        return const Color(0xFFF5F0E6);
      case (ChromeStyle.classic, AppThemeMode.dark):
        return const Color(0xFF241F18);
      case (ChromeStyle.modern, AppThemeMode.light):
        return const Color(0xFFF2F4F7);
      case (ChromeStyle.modern, AppThemeMode.dark):
        return const Color(0xFF1B2330);
      case (ChromeStyle.flat, AppThemeMode.light):
        return const Color(0xFFF5F7FA);
      case (ChromeStyle.flat, AppThemeMode.dark):
        return const Color(0xFF151B24);
    }
  }

  Color _previewChromeBottom(AppAppearance appearance) {
    switch ((appearance.chromeStyle, appearance.themeMode)) {
      case (ChromeStyle.classic, AppThemeMode.light):
        return const Color(0xFFEAE1D2);
      case (ChromeStyle.classic, AppThemeMode.dark):
        return const Color(0xFF17120D);
      case (ChromeStyle.modern, AppThemeMode.light):
        return const Color(0xFFE0E6EF);
      case (ChromeStyle.modern, AppThemeMode.dark):
        return const Color(0xFF111923);
      case (ChromeStyle.flat, AppThemeMode.light):
        return const Color(0xFFF5F7FA);
      case (ChromeStyle.flat, AppThemeMode.dark):
        return const Color(0xFF151B24);
    }
  }

  Color _previewChromeBorder(AppAppearance appearance) {
    switch ((appearance.chromeStyle, appearance.themeMode)) {
      case (ChromeStyle.classic, AppThemeMode.light):
        return const Color(0xFFD7CCBA);
      case (ChromeStyle.classic, AppThemeMode.dark):
        return const Color(0xFF4D4337);
      case (ChromeStyle.modern, AppThemeMode.light):
        return const Color(0xFFC7D1DD);
      case (ChromeStyle.modern, AppThemeMode.dark):
        return const Color(0xFF364355);
      case (ChromeStyle.flat, AppThemeMode.light):
        return const Color(0xFFD9E0E8);
      case (ChromeStyle.flat, AppThemeMode.dark):
        return const Color(0xFF2D3846);
    }
  }
}