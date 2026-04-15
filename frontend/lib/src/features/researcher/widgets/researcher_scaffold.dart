// Created with the Assistance of Claude Code
// frontend/lib/src/features/researcher/widgets/researcher_scaffold.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'researcher_header.dart';

/// Scaffold for all researcher pages with pre-configured header navigation.
///
/// Combines BaseScaffold with ResearcherHeader for consistent researcher UI.
/// Includes Dashboard, Surveys, Templates, and Question Bank navigation.
///
/// Usage:
/// ```dart
/// // Simple list page
/// ResearcherScaffold(
///   currentRoute: '/surveys',
///   alignment: AppPageAlignment.regular,
///   child: YourListWidget(),
/// )
///
/// // Page with FAB
/// ResearcherScaffold(
///   currentRoute: '/surveys',
///   floatingActionButton: FloatingActionButton(...),
///   child: YourContent(),
/// )
///
/// // Scrollable content page
/// ResearcherScaffold(
///   currentRoute: '/templates',
///   scrollable: true,
///   child: YourScrollableContent(),
/// )
/// ```
class ResearcherScaffold extends StatelessWidget {
  const ResearcherScaffold({
    super.key,
    required this.currentRoute,
    required this.child,
    this.scrollable = false,
    this.showFooter = false,
    this.alignment = AppPageAlignment.regular,
    this.bodyBehavior = AppPageBodyBehavior.padded,
    this.padding,
    this.floatingActionButton,
    this.hasNotifications = false,
    this.onNotificationsTap,
    this.onProfileTap,
    this.onMenuTap,
    this.userName,
    this.maxWidth,
  });

  /// Current route for highlighting active nav item
  final String currentRoute;

  /// Main page content
  final Widget child;

  /// Whether content should scroll (default: false for list pages)
  final bool scrollable;

  /// Whether to show footer (default: false for list pages)
  final bool showFooter;

  /// Semantic alignment category for the researcher page shell.
  final AppPageAlignment alignment;

  /// Whether the scaffold should apply the resolved shell padding directly.
  final AppPageBodyBehavior bodyBehavior;

  /// Rare raw padding override for exceptional layouts.
  final EdgeInsets? padding;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Whether there are unread notifications
  final bool hasNotifications;

  /// Callback when notifications icon is tapped
  final VoidCallback? onNotificationsTap;

  /// Callback when profile icon is tapped
  final VoidCallback? onProfileTap;

  final VoidCallback? onMenuTap;

  /// User name for profile dropdown
  final String? userName;

  /// Rare max-width override for exceptional layouts.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: ResearcherHeader(
        currentRoute: currentRoute,
        hasNotifications: hasNotifications,
        onNotificationsTap: onNotificationsTap,
        onProfileTap: onProfileTap,
        onMenuTap: onMenuTap,
        userName: userName,
      ),
      alignment: alignment,
      bodyBehavior: bodyBehavior,
      scrollable: scrollable,
      showFooter: showFooter,
      padding: padding,
      floatingActionButton: floatingActionButton,
      maxWidth: maxWidth,
      child: child,
    );
  }
}
