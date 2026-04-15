// Created with the Assistance of Claude Code
// frontend/lib/src/features/participant/widgets/welcome_banner.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Welcome banner widget displaying personalized greeting
///
/// Matches the Figma design: "Welcome, UserFirstName. How are you today?"
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    super.key,
    required this.firstName,
  });

  /// User's first name for personalized greeting
  final String firstName;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        context.l10n.participantWelcomeGreeting(firstName),
        style: AppTheme.heading3.copyWith(
          color: AppTheme.primary,
        ),
      ),
    );
  }
}
