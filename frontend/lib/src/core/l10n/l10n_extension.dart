// Created with the Assistance of Claude Code
// frontend/lib/src/core/l10n/l10n_extension.dart
import 'package:flutter/widgets.dart';
import 'package:frontend/src/core/l10n/generated/app_localizations.dart';

/// Extension on BuildContext for easy access to localized strings.
///
/// This provides a clean, concise syntax for accessing translations
/// anywhere in the widget tree without needing to declare a local variable.
///
/// ## Usage
///
/// ```dart
/// // Instead of:
/// final l10n = AppLocalizations.of(context);
/// Text(l10n.authLoginButton)
///
/// // Simply use:
/// Text(context.l10n.authLoginButton)
/// ```
///
/// ## Examples
///
/// ```dart
/// // Simple string
/// Text(context.l10n.commonSubmit)
///
/// // String with parameters
/// Text(context.l10n.participantWelcomeMessage('John'))
///
/// // Pluralized string
/// Text(context.l10n.participantNewMessages(5))
/// ```
///
/// ## Notes
///
/// - This extension requires the widget to be in a tree that has
///   MaterialApp (or CupertinoApp) with localizationsDelegates configured
/// - The l10n getter is non-nullable, so it will throw if localization
///   is not properly configured
extension LocalizationExtension on BuildContext {
  /// Get the AppLocalizations instance for this context.
  ///
  /// Provides access to all localized strings defined in the ARB files.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
