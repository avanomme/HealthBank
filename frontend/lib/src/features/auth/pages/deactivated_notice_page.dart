import 'package:flutter/material.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class DeactivatedNoticePage extends StatelessWidget {
  const DeactivatedNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Header(
        navItems: [],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: _DeactivatedNoticeContent(),
        ),
      ),
    );
  }
}

class _DeactivatedNoticeContent extends StatelessWidget {
  const _DeactivatedNoticeContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const ExcludeSemantics(child: Icon(Icons.block, color: AppTheme.error, size: 64)),
        const SizedBox(height: 32),
        Semantics(
          header: true,
          child: Text(
            context.l10n.deactivatedNoticeTitle,
            style: AppTheme.heading3.copyWith(color: AppTheme.error),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.deactivatedNoticeMessage,
          style: AppTheme.body,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: Text(context.l10n.deactivatedNoticeReturnToLogin),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.textContrast,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: AppTheme.body.copyWith(fontWeight: FontWeight.bold),
          ),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}
