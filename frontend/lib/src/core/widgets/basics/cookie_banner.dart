import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/state/cookie_consent_provider.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_long_button.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

/// Floating cookie consent banner shown once until the user accepts.
///
/// Reads [cookieConsentProvider] and renders nothing when consent has already
/// been granted. Calls [CookieConsentNotifier.accept] on button press.
class CookieBanner extends ConsumerWidget {
  const CookieBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasConsent = ref.watch(cookieConsentProvider);
    if (hasConsent) return const SizedBox.shrink();

    final l10n = context.l10n;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: context.appColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    l10n.cookieTitle,
                    variant: AppTextVariant.bodyLarge,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    l10n.cookieBody,
                    variant: AppTextVariant.bodySmall,
                    color: context.appColors.textMuted,
                  ),
                  const SizedBox(height: 16),
                  AppLongButton(
                    label: l10n.cookieAccept,
                    onPressed: () =>
                        ref.read(cookieConsentProvider.notifier).accept(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}