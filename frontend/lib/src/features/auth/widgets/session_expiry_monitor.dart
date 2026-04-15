// Created with the Assistance of Claude Code
// frontend/lib/src/features/auth/widgets/session_expiry_monitor.dart

/// SessionExpiryMonitor
///
/// WCAG 2.2.1 — Timing Adjustable:
/// Warns the user 5 minutes before their session expires and gives them
/// the option to stay logged in or log out.  If no action is taken the
/// session cookie expires naturally and the app performs an automatic logout.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';

class SessionExpiryMonitor extends ConsumerStatefulWidget {
  const SessionExpiryMonitor({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<SessionExpiryMonitor> createState() =>
      _SessionExpiryMonitorState();
}

class _SessionExpiryMonitorState extends ConsumerState<SessionExpiryMonitor> {
  Timer? _warningTimer;
  Timer? _logoutTimer;
  bool _dialogShowing = false;
  String? _monitoredExpiresAt;

  @override
  void dispose() {
    _warningTimer?.cancel();
    _logoutTimer?.cancel();
    super.dispose();
  }

  void _scheduleTimers(String expiresAt) {
    if (_monitoredExpiresAt == expiresAt) return; // already scheduled for this expiry
    _monitoredExpiresAt = expiresAt;
    _warningTimer?.cancel();
    _logoutTimer?.cancel();

    final expiry = DateTime.tryParse(expiresAt)?.toLocal();
    if (expiry == null) return;

    final now = DateTime.now();
    final logoutIn = expiry.difference(now);
    if (logoutIn <= Duration.zero) return; // already expired — let server reject next request

    final warningIn = expiry.subtract(const Duration(minutes: 5)).difference(now);

    if (warningIn > Duration.zero) {
      _warningTimer = Timer(warningIn, _showWarningDialog);
    } else {
      // Less than 5 minutes left — show warning immediately after current frame
      WidgetsBinding.instance.addPostFrameCallback((_) => _showWarningDialog());
    }

    _logoutTimer = Timer(logoutIn, () {
      if (mounted && !_dialogShowing) {
        ref.read(authProvider.notifier).logout();
      }
    });
  }

  void _cancelTimers() {
    _warningTimer?.cancel();
    _logoutTimer?.cancel();
    _monitoredExpiresAt = null;
  }

  Future<void> _showWarningDialog() async {
    if (!mounted || _dialogShowing) return;
    _dialogShowing = true;
    _warningTimer?.cancel();

    final l10n = context.l10n;

    final extend = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.sessionExpiryTitle),
        content: Text(l10n.sessionExpiryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.sessionExpiryLogout),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.sessionExpiryExtend),
          ),
        ],
      ),
    );

    _dialogShowing = false;
    if (!mounted) return;

    if (extend == true) {
      try {
        // GET /sessions/me refreshes the server-side session cookie,
        // then restoreSession() updates AuthState with the new expiresAt.
        await ref.read(authApiProvider).getSessionInfo();
        final role = await ref.read(authProvider.notifier).restoreSession();
        if (role != null && mounted) {
          AppToast.showSuccess(context, message: l10n.sessionExpiryExtended);
        }
        // _scheduleTimers() will be called again from build() once AuthState
        // is updated with the new expiresAt from restoreSession().
      } catch (_) {
        // Extension failed — natural expiry will trigger logout via _logoutTimer
      }
    } else {
      _logoutTimer?.cancel();
      await ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    if (auth.isAuthenticated && auth.user != null) {
      _scheduleTimers(auth.user!.expiresAt);
    } else {
      _cancelTimers();
    }

    return widget.child;
  }
}
