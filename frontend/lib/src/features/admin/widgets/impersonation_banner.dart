// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/widgets/impersonation_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/app_toasts.dart';
import 'package:frontend/src/features/auth/auth_state.dart';
import 'package:frontend/src/config/go_router.dart';

/// Height of the impersonation banner
const double kImpersonationBannerHeight = 48.0;

/// Banner displayed when an admin is impersonating a user.
///
/// Shows a yellow warning banner at the top of the screen with:
/// - "Viewing as [User Name] ([Email])" message
/// - "Back to Admin Dashboard" button
///
/// The banner automatically hides when not impersonating.
class ImpersonationBanner extends ConsumerWidget {
  const ImpersonationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impersonationState = ref.watch(impersonationProvider);

    // Don't show banner if not impersonating
    if (!impersonationState.isImpersonating) {
      return const SizedBox.shrink();
    }

    final userName = impersonationState.currentUserName;
    final userEmail = impersonationState.currentUser?.email ?? '';

    return Container(
      height: kImpersonationBannerHeight,
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
            // Warning icon
            Icon(
              Icons.visibility,
              color: context.appColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),

            // Message
            Expanded(
              child: Text(
                context.l10n.adminViewingAsUser(userName, userEmail),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 12),

            // Back to Admin button
            _BackToAdminButton(
              isLoading: impersonationState.isLoading,
              onPressed: () => _handleEndImpersonation(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEndImpersonation(
      BuildContext context, WidgetRef ref) async {
    debugPrint('ImpersonationBanner: Starting end view-as...');

    final notifier = ref.read(impersonationProvider.notifier);
    final success = await notifier.endImpersonation();

    debugPrint('ImpersonationBanner: endImpersonation returned success=$success, context.mounted=${context.mounted}');

    if (success) {
      debugPrint('ImpersonationBanner: Navigating to /admin/users');

      // Clear impersonation state first
      notifier.clearImpersonationState();

      // Navigate using appRouter directly (context may not have GoRouter)
      appRouter.go(AppRoutes.adminUsers);

      // Show success message if context still valid
      if (context.mounted) {
        AppToast.showSuccess(context, message: context.l10n.adminReturnedToDashboard);
      }
    } else if (context.mounted) {
      // Show error message
      final error = ref.read(impersonationProvider).error;
      debugPrint('ImpersonationBanner: Error - $error');
      AppToast.showError(context, message: error ?? context.l10n.adminEndViewAsError);
    } else {
      debugPrint('ImpersonationBanner: Context not mounted after async call');
    }
  }
}

/// Button to return to admin dashboard
class _BackToAdminButton extends StatelessWidget {
  const _BackToAdminButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppFilledButton(
      label: isLoading ? context.l10n.adminReturning : context.l10n.adminBackToAdmin,
      onPressed: isLoading ? null : onPressed,
      backgroundColor: AppTheme.primary,
      textColor: AppTheme.textContrast,
    );
  }
}

/// Animated version of the impersonation banner with slide animation
class AnimatedImpersonationBanner extends ConsumerWidget {
  const AnimatedImpersonationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impersonationState = ref.watch(impersonationProvider);
    final isVisible = impersonationState.isImpersonating;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      offset: isVisible ? Offset.zero : const Offset(0, -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isVisible ? 1.0 : 0.0,
        child: const ImpersonationBanner(),
      ),
    );
  }
}

/// A wrapper widget that adds the impersonation banner above its child
///
/// Use this at the top level of your scaffold to show the banner on all pages.
class ImpersonationBannerWrapper extends ConsumerWidget {
  const ImpersonationBannerWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impersonationState = ref.watch(impersonationProvider);
    final isImpersonating = impersonationState.isImpersonating;

    return Column(
      children: [
        // Animated banner
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isImpersonating ? kImpersonationBannerHeight : 0,
          child: isImpersonating
              ? const ImpersonationBanner()
              : const SizedBox.shrink(),
        ),

        // Main content
        Expanded(child: child),
      ],
    );
  }
}
