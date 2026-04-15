// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/header_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/state/locale_provider.dart';

/// Authenticated user actions: notifications + profile dropdown.
///
/// Shows mail icon (with badge) and profile menu with
/// profile, settings, language, and logout options.
class HeaderAuthActions extends ConsumerWidget {
  const HeaderAuthActions({
    super.key,
    this.onNotificationsTap,
    this.hasNotifications = false,
    this.isCompact = false,
  });

  final VoidCallback? onNotificationsTap;
  final bool hasNotifications;
  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notifications
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.mail_outline),
              onPressed: onNotificationsTap,
              tooltip: context.l10n.authNotifications,
              color: AppTheme.primary,
              iconSize: isCompact ? 22 : 24,
            ),
            if (hasNotifications)
              Positioned(
                right: 8,
                top: 8,
                child: Semantics(
                  label: context.l10n.headerUnreadNotifications,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: isCompact ? 4 : 8),

        // Profile dropdown
        PopupMenuButton<String>(
          offset: const Offset(0, 48),
          tooltip: context.l10n.authProfile,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.account_circle_outlined,
                  color: AppTheme.primary,
                  size: isCompact ? 24 : 28,
                ),
              ),
              if (!isCompact) const SizedBox(width: 4),
              if (!isCompact)
                const ExcludeSemantics(
                  child: Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                ),
            ],
          ),
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const ExcludeSemantics(child: Icon(Icons.person_outline, size: 20)),
                  const SizedBox(width: 8),
                  Text(
                    ctx.l10n.authProfile,
                    style: Theme.of(ctx).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  const ExcludeSemantics(child: Icon(Icons.settings_outlined, size: 20)),
                  const SizedBox(width: 8),
                  Text(
                    ctx.l10n.authSettings,
                    style: Theme.of(ctx).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            ...SupportedLocales.all.map((locale) {
              final isSelected =
                  locale.languageCode == currentLocale.languageCode;
              return PopupMenuItem<String>(
                value: 'lang_${locale.languageCode}',
                child: Row(
                  children: [
                    const ExcludeSemantics(child: Icon(Icons.language, size: 20)),
                    const SizedBox(width: 8),
                    Text(
                      SupportedLocales.getDisplayName(locale),
                      style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    if (isSelected) ...[
                      const Spacer(),
                      const ExcludeSemantics(
                        child: Icon(Icons.check, size: 16, color: AppTheme.primary),
                      ),
                    ],
                  ],
                ),
              );
            }),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const ExcludeSemantics(child: Icon(Icons.logout, size: 20, color: AppTheme.error)),
                  const SizedBox(width: 8),
                  Text(
                    ctx.l10n.authLogout,
                    style: Theme.of(
                      ctx,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.error),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'profile') {
              context.go(AppRoutes.profile);
              return;
            }
            if (value == 'settings') {
              context.go(AppRoutes.settings);
              return;
            }
            if (value == 'logout') {
              context.go(AppRoutes.logout);
              return;
            }
            if (value.startsWith('lang_')) {
              final langCode = value.substring(5);
              final locale = SupportedLocales.all.firstWhere(
                (l) => l.languageCode == langCode,
                orElse: () => SupportedLocales.english,
              );
              ref.read(localeProvider.notifier).setLocale(locale);
            }
          },
        ),
      ],
    );
  }
}

/// Public (unauthenticated) actions: language selector + login button.
class HeaderPublicActions extends ConsumerWidget {
  const HeaderPublicActions({super.key, this.isCompact = false});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Language dropdown
        PopupMenuButton<String>(
          tooltip: context.l10n.adminLanguage,
          offset: const Offset(0, 48),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.language,
                  color: AppTheme.primary,
                  size: isCompact ? 22 : 24,
                ),
              ),
              if (!isCompact) ...[
                const SizedBox(width: 6),
                Text(
                  currentLocale.languageCode.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                const ExcludeSemantics(
                  child: Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                ),
              ],
            ],
          ),
          itemBuilder: (ctx) => SupportedLocales.all.map((locale) {
            final isSelected =
                locale.languageCode == currentLocale.languageCode;
            return PopupMenuItem<String>(
              value: 'lang_${locale.languageCode}',
              child: Row(
                children: [
                  const ExcludeSemantics(child: Icon(Icons.language, size: 20)),
                  const SizedBox(width: 8),
                  Text(
                    SupportedLocales.getDisplayName(locale),
                    style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  if (isSelected) ...[
                    const Spacer(),
                    const ExcludeSemantics(
                      child: Icon(Icons.check, size: 16, color: AppTheme.primary),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          onSelected: (value) {
            if (value.startsWith('lang_')) {
              final langCode = value.substring(5);
              final locale = SupportedLocales.all.firstWhere(
                (l) => l.languageCode == langCode,
                orElse: () => SupportedLocales.english,
              );
              ref.read(localeProvider.notifier).setLocale(locale);
            }
          },
        ),

        SizedBox(width: isCompact ? 4 : 12),

        // Login button
        if (isCompact)
          IconButton(
            tooltip: context.l10n.authLoginTitle,
            onPressed: () => context.go(AppRoutes.login),
            icon: const Icon(Icons.login),
            color: AppTheme.primary,
            iconSize: 22,
          )
        else
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: Text(
              context.l10n.authLoginTitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}
