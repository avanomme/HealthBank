// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/core/widgets/layout/base_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/state/cookie_consent_provider.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/widgets/basics/footer.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/widgets/basics/cookie_banner.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Base scaffold providing consistent structure for all non-admin pages.
///
/// Features:
/// - Fixed header at top (always visible, full-width)
/// - Scrollable content area (configurable, max-width constrained)
/// - Footer always spans full page width (not constrained by maxWidth)
///
/// For admin pages, use AdminScaffold instead which has a sidebar.
///
/// Usage:
/// ```dart
/// // Scrollable content (default)
/// BaseScaffold(
///   header: Header(navItems: [...], currentRoute: '/dashboard'),
///   alignment: AppPageAlignment.regular,
///   child: YourPageContent(),
/// )
///
/// // Full-width (e.g. data tables that need all available space)
/// BaseScaffold(
///   header: ResearcherHeader(...),
///   alignment: AppPageAlignment.compact,
///   child: YourWideContent(),
/// )
///
/// // Non-scrollable (for pages with internal ListView/scroll)
/// BaseScaffold(
///   header: Header(...),
///   bodyBehavior: AppPageBodyBehavior.edgeToEdge,
///   scrollable: false,
///   showFooter: false,
///   child: YourListPage(),
/// )
/// ```
class BaseScaffold extends ConsumerStatefulWidget {
  const BaseScaffold({
    super.key,
    required this.child,
    this.header,
    this.showHeader = true,
    this.showFooter = true,
    this.alignment = AppPageAlignment.regular,
    this.bodyBehavior = AppPageBodyBehavior.padded,
    this.padding,
    this.scrollable = true,
    this.floatingActionButton,
    this.maxWidth,
  });

  /// The main page content
  final Widget child;

  /// Custom header widget (uses default Header if null and showHeader is true)
  final PreferredSizeWidget? header;

  /// Whether to show the header
  final bool showHeader;

  /// Whether to show the footer
  final bool showFooter;

  /// Semantic alignment category for page-shell spacing.
  final AppPageAlignment alignment;

  /// Whether the scaffold should apply the resolved shell padding directly.
  final AppPageBodyBehavior bodyBehavior;

  /// Rare raw padding override for special cases that cannot use a semantic category.
  final EdgeInsets? padding;

  /// Whether to wrap content in SingleChildScrollView (default: true)
  /// Set to false for pages that manage their own scrolling (e.g., list pages)
  final bool scrollable;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Rare max-width override for special cases that cannot use a semantic category.
  final double? maxWidth;

  @override
  ConsumerState<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends ConsumerState<BaseScaffold> {
  static const double _cookieBannerClearanceHeight = 200;

  // Must live in State, not in build(). A GlobalKey created inside build() is
  // a new object on every rebuild → KeyedSubtree sees a different key each
  // time → remounts the entire content subtree → all TextFields lose focus.
  final GlobalKey _mainContentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final mainContentKey = _mainContentKey;
    final cookieBannerVisible = !ref.watch(cookieConsentProvider);
    final cookieBannerClearance = cookieBannerVisible
        ? _cookieBannerClearanceHeight
        : 0.0;
    final alignmentSpec = context.pageAlignmentTheme.resolve(widget.alignment);
    final resolvedPadding = widget.padding ?? alignmentSpec.bodyPadding;
    final resolvedMaxWidth = widget.maxWidth ?? alignmentSpec.maxContentWidth;

    Widget shellBody(Widget child) {
      if (widget.bodyBehavior == AppPageBodyBehavior.edgeToEdge) {
        return child;
      }

      return Padding(
        padding: resolvedPadding,
        child: Semantics(
          container: true,
          label: 'Main content',
          child: KeyedSubtree(
            key: mainContentKey,
            child: AppPageAlignedContent(
              alignment: widget.alignment,
              maxWidth: resolvedMaxWidth,
              child: child,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      body: SafeArea(
        top: false, // Top safe area handled by _AppShell in main.dart
        bottom:
            false, // Footer owns the bottom inset so its background extends edge-to-edge
        child: Stack(
          children: [
            _SkipToContentLink(
              onActivate: () {
                final targetContext = mainContentKey.currentContext;
                if (targetContext == null) return;
                Scrollable.ensureVisible(
                  targetContext,
                  duration: Duration.zero,
                  alignmentPolicy:
                      ScrollPositionAlignmentPolicy.keepVisibleAtStart,
                );
              },
            ),
            AppPageAlignmentScope(
              alignment: widget.alignment,
              spec: alignmentSpec,
              child: Column(
                children: [
                  if (widget.showHeader)
                    Semantics(
                      container: true,
                      label: 'Site header',
                      child: widget.header ?? const _DefaultHeader(),
                    ),
                  if (widget.scrollable)
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(child: shellBody(widget.child)),
                          // WCAG 2.4.11: keep focused elements above the cookie banner
                          if (cookieBannerVisible)
                            SliverToBoxAdapter(
                              child: SizedBox(height: cookieBannerClearance),
                            ),
                          if (widget.showFooter)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                children: [
                                  // Spacer pushes footer to screen bottom when
                                  // content is shorter than the viewport.
                                  // When content overflows, SliverFillRemaining
                                  // shrinks to zero and the footer scrolls
                                  // naturally at the end of the list.
                                  const Spacer(),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Semantics(
                                      container: true,
                                      label: 'Footer',
                                      child: Footer(
                                        onLinkTap: (route) => context.go(route),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                  else ...[
                    Expanded(child: shellBody(widget.child)),
                    if (widget.showFooter)
                      Semantics(
                        container: true,
                        label: 'Footer',
                        child: Footer(onLinkTap: (route) => context.go(route)),
                      ),
                  ],
                ],
              ),
            ),
            const CookieBanner(),
          ],
        ),
      ),
    );
  }
}

/// Default header when no custom header is provided
class _DefaultHeader extends StatelessWidget implements PreferredSizeWidget {
  const _DefaultHeader();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return const Header(navItems: []);
  }
}

class _SkipToContentLink extends StatefulWidget {
  const _SkipToContentLink({required this.onActivate});

  final VoidCallback onActivate;

  @override
  State<_SkipToContentLink> createState() => _SkipToContentLinkState();
}

class _SkipToContentLinkState extends State<_SkipToContentLink> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 12,
      top: 12,
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: _hasFocus ? 1 : 0,
          child: IgnorePointer(
            ignoring: !_hasFocus,
            child: TextButton(
              onPressed: widget.onActivate,
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.textContrast,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              child: Text(context.l10n.accessibilitySkipToMain),
            ),
          ),
        ),
      ),
    );
  }
}
