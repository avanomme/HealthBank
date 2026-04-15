// Created with the Assistance of Claude Code
// frontend/lib/src/features/auth/pages/logout_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Logout confirmation page matching Figma design
///
/// Features:
/// - Header with logo only (no nav items)
/// - Centered card with logout confirmation message
/// - "Return" button to go back to login page
/// - Language selector at bottom right
/// - Automatically clears session on load
class LogoutPage extends ConsumerStatefulWidget {
  const LogoutPage({super.key});

  @override
  ConsumerState<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends ConsumerState<LogoutPage> {
  bool _isLoggingOut = true;

  @override
  void initState() {
    super.initState();
    _performLogout();
  }

  Future<void> _performLogout() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) {
      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: const Header(navItems: []),
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      scrollable: false,
      showFooter: false,
      child: Column(
        children: [
          // Centered logout card
          Expanded(child: Center(child: _buildLogoutCard(context))),
        ],
      ),
    );
  }

  Widget _buildLogoutCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final cardPadding = isMobile ? 24.0 : 40.0;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        constraints: const BoxConstraints(maxWidth: 450),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Semantics(
              header: true,
              child: Text(
                _isLoggingOut
                    ? context.l10n.authLoggingOut
                    : context.l10n.authLogoutTitle,
                style: AppTheme.heading2.copyWith(color: AppTheme.primary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Message
            if (_isLoggingOut)
              const AppLoadingIndicator()
            else ...[
              Text(
                context.l10n.authLogoutMessage,
                style: AppTheme.body.copyWith(color: context.appColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Return button
              AppFilledButton(
                label: context.l10n.authLogoutReturn,
                onPressed: () => context.go('/login'),
              ),

              const SizedBox(height: 8),

              // home button
              AppFilledButton(
                label: context.l10n.navHome,
                onPressed: () => context.go('/'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
