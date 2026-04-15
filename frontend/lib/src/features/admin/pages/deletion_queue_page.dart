// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/pages/deletion_queue_page.dart
//
// Deletion requests are now managed inside the Account Requests page.
// This page redirects there so existing deep links continue to work.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/config/go_router.dart';

/// Redirects to Account Requests (/admin/messages) — deletion requests are
/// managed there under the "Deletion Requests" tab.
class DeletionQueuePage extends StatelessWidget {
  const DeletionQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect on first frame so the router history is clean.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go(AppRoutes.adminMessages);
    });
    return const SizedBox.shrink();
  }
}
