// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/widgets/admin_view_as_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/features/auth/auth_state.dart';

/// Height of the admin view-as banner
const double kAdminViewAsBannerHeight = 48.0;

/// Banner displayed when an admin is viewing a role's pages via "View As".
///
/// Shows a yellow banner at the top of the screen with:
/// - "Viewing as [Role]" message
/// - "Back to Admin" button
///
/// This is completely independent from the impersonation banner —
/// no backend ViewingAsUserID changes, no session modifications.
/// The admin's own session/token is used on all pages.
class AdminViewAsBanner extends ConsumerWidget {
  const AdminViewAsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impersonation = ref.watch(impersonationProvider);
    final isAdmin = ref.watch(isSystemAdminProvider);
    final viewingAsRole = impersonation.previewRole;

    if (!impersonation.isRolePreview || !isAdmin) return const SizedBox.shrink();

    return Container(
      height: kAdminViewAsBannerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.caution,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              Icons.visibility,
              color: context.appColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                context.l10n.adminViewingAsRole(_roleName(context, viewingAsRole ?? '')),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 12),

            AppFilledButton(
              label: context.l10n.adminBackToAdmin,
              onPressed: () {
                ref.read(impersonationProvider.notifier).clearImpersonationState();
                appRouter.go(AppRoutes.admin);
              },
              backgroundColor: AppTheme.primary,
              textColor: AppTheme.textContrast,
            ),
          ],
        ),
      ),
    );
  }

  String _roleName(BuildContext context, String role) {
    switch (role) {
      case 'participant':
        return context.l10n.roleParticipant;
      case 'researcher':
        return context.l10n.roleResearcher;
      case 'hcp':
        return context.l10n.roleHcp;
      default:
        return role;
    }
  }
}
