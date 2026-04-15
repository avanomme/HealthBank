// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/basics/header_logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_tappable.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/auth/state/impersonation_provider.dart';

/// HealthBank logo with tap navigation.
///
/// Tapping navigates to the user's role-appropriate dashboard,
/// or a custom route if [onTap] is provided.
///
/// For admin users, this always navigates to the admin dashboard
/// and clears any active view-as/impersonation session first.
class HeaderLogo extends ConsumerWidget {
  const HeaderLogo({super.key, this.onTap, this.isCompact = false});

  /// Custom tap handler. If null, navigates to the user's dashboard.
  final VoidCallback? onTap;

  /// Whether to use a smaller font size (for mobile/compact headers).
  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = isCompact ? 16.0 : 28.0;
    final logo = Padding(
      padding: EdgeInsets.only(
        left: isCompact ? 4 : 0,
        right: isCompact ? 8 : 20,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Health',
              style: AppTheme.logo.copyWith(
                fontSize: fontSize,
                color: AppTheme.secondary,
              ),
            ),
            Text(
              'Bank',
              style: AppTheme.logo.copyWith(
                fontSize: fontSize,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );

    final handler =
        onTap ??
        () async {
          final auth = ref.read(authProvider);
          if (!auth.isAuthenticated) {
            context.go(AppRoutes.home);
            return;
          }

          // Admin always goes to admin dashboard, clearing any view-as
          if (auth.user?.role == 'admin') {
            final impersonation = ref.read(impersonationProvider);
            if (impersonation.isImpersonating) {
              final notifier = ref.read(impersonationProvider.notifier);
              await notifier.endImpersonation();
              notifier.clearImpersonationState();
            }
            if (!context.mounted) return;
            // Use pushReplacement so it always triggers a page rebuild,
            // even when already on /admin (context.go is a no-op for same route)
            context.pushReplacement(AppRoutes.admin);
            return;
          }

          // Non-admin: go to their role dashboard
          final target =
              getDashboardRouteForRole(auth.user?.role) ?? AppRoutes.login;
          context.go(target);
        };

    return SelectionContainer.disabled(
      child: AppTappable(
        onTap: handler,
        semanticLabel: context.l10n.semanticLogoNavigate,
        child: logo,
      ),
    );
  }
}
