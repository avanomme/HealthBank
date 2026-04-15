// Created with the Assistance of Claude Code
// frontend/lib/src/features/auth/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/features/auth/widgets/login_card.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/widgets/feedback/app_toasts.dart';

/// Login page — shows a maintenance banner when the system is in maintenance
/// mode, and blocks non-admin logins at both the UI and backend level.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final authState = ref.watch(authProvider);
    // Default false while loading — never show banner due to a slow network.
    final maintenanceMode =
        ref.watch(maintenanceModeProvider).valueOrNull ?? false;
    // Default true while loading — avoids hiding the button on a slow network.
    final registrationOpen =
        ref.watch(registrationOpenProvider).valueOrNull ?? true;

    // Show error toast when login fails, with a specific message for maintenance.
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        final msg = next.error == 'maintenance_mode'
            ? l10n.authMaintenanceModeLoginError
            : next.error!;
        AppToast.showError(context, message: msg);
      }
    });

    return BaseScaffold(
      header: const Header(navItems: []),
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      scrollable: false,
      showFooter: false,
      child: Column(
        children: [
          // Centered login card - scrollable for small screens
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LoginCard(
                                onLogin: (email, password) =>
                                    _handleLogin(context, ref, email, password),
                                onForgotPassword: () =>
                                    _handleForgotPassword(context),
                                onRequestAccount: () =>
                                    _handleRequestAccount(context),
                                isLoading: authState.isLoading,
                                showRequestAccount:
                                    registrationOpen && !maintenanceMode,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin(
    BuildContext context,
    WidgetRef ref,
    String email,
    String password,
  ) async {
    final role = await ref.read(authProvider.notifier).login(email, password);
    if (!context.mounted) return;

    final authState = ref.read(authProvider);
    if (authState.mfaRequired) {
      context.go('/two-factor');
      return;
    }

    if (role == 'deactivated') {
      context.go(AppRoutes.deactivatedNotice);
      return;
    }

    if (role != null) {
      final authState = ref.read(authProvider);
      if (authState.mustChangePassword) {
        context.go('/change-password');
        return;
      }

      if (authState.needsProfileCompletion) {
        context.go(AppRoutes.completeProfile);
        return;
      }

      if (!authState.hasSignedConsent) {
        context.go(AppRoutes.consent);
        return;
      }

      context.go(getDashboardRouteForRole(role) ?? AppRoutes.login);
    }
  }

  void _handleForgotPassword(BuildContext context) {
    context.push('/forgot-password');
  }

  void _handleRequestAccount(BuildContext context) {
    context.push('/request-account');
  }
}

