// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/maintenance_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';

/// Inline (non-overlapping) maintenance banner.
///
/// Shown at the top of every page — public and admin — when maintenance mode
/// is active.  It sits in the normal page flow so it never covers content.
/// Reads from the shared _publicConfigProvider so it shares the same cached
/// fetch as [maintenanceModeProvider].
class MaintenanceBanner extends ConsumerWidget {
  const MaintenanceBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMaintenanceAsync = ref.watch(maintenanceModeProvider);

    // Only render anything if maintenance mode is confirmed on
    return isMaintenanceAsync.when(
      data: (isOn) {
        if (!isOn) return const SizedBox.shrink();
        return _BannerBody();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _BannerBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final completion = ref.watch(maintenanceCompletionProvider).valueOrNull ?? '';

    final message = completion.trim().isEmpty
        ? l10n.maintenanceBannerMessageNoTime
        : l10n.maintenanceBannerMessage(completion.trim());

    return Semantics(
      liveRegion: true,
      label: l10n.maintenanceBannerTitle,
      child: Container(
        width: double.infinity,
        color: const Color(0xFFFFF3CD), // amber-50 warning tone
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExcludeSemantics(
              child: Icon(
                Icons.construction,
                size: 18,
                color: Color(0xFF856404),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTheme.captions.copyWith(
                  color: const Color(0xFF533F03),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
