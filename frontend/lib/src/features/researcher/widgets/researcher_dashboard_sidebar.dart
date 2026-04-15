// Created with the Assistance of Claude Code
// frontend/lib/src/features/researcher/widgets/researcher_dashboard_sidebar.dart
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_section_navbar.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

/// Researcher dashboard sidebar matching the Admin sidebar aesthetic.
///
/// Uses the same visual style (hover effects, active highlight, consistent
/// header) while keeping scroll-to-section navigation for the dashboard.
class ResearcherDashboardSidebar extends StatelessWidget {
  const ResearcherDashboardSidebar({
    super.key,
    required this.sections,
    required this.activeDestinationId,
    required this.onDestinationTap,
    this.userName = 'Researcher',
    this.width = 240,
    this.onCollapse,
  });

  final List<AppSectionNavbarSection> sections;
  final String? activeDestinationId;
  final Future<void> Function(String destinationId) onDestinationTap;
  final String userName;
  final VoidCallback? onCollapse;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          gradient: AppTheme.chromeSidebarGradient,
          border: Border(
            top: BorderSide(color: AppTheme.chromeHighlight, width: 1),
            right: BorderSide(color: AppTheme.chromeBorder, width: 1),
          ),
          boxShadow: AppTheme.chromeSidebarShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — matches admin sidebar style
            _buildHeader(context),
            Divider(color: context.appColors.divider, height: 1),

            // Navigation items — admin-style hover/active
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final section in sections)
                      _SidebarSection(
                        section: section,
                        activeDestinationId: activeDestinationId,
                        onDestinationTap: onDestinationTap,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.adminLoggedInAsLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onCollapse != null)
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              iconSize: 24,
              color: AppTheme.primary,
              tooltip: context.l10n.tooltipCollapseSidebar,
              onPressed: onCollapse,
            ),
        ],
      ),
    );
  }
}

/// A collapsible section with heading + children, styled like admin items.
class _SidebarSection extends StatelessWidget {
  const _SidebarSection({
    required this.section,
    required this.activeDestinationId,
    required this.onDestinationTap,
  });

  final AppSectionNavbarSection section;
  final String? activeDestinationId;
  final Future<void> Function(String destinationId) onDestinationTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading
        _SidebarItem(
          label: section.label,
          isActive: activeDestinationId == section.destinationId,
          isBold: true,
          onTap: () => onDestinationTap(section.destinationId),
        ),
        // Sub-items
        for (final child in section.children)
          _SidebarItem(
            label: child.label,
            isActive: activeDestinationId == child.destinationId,
            indent: true,
            onTap: () => onDestinationTap(child.destinationId),
          ),
      ],
    );
  }
}

/// Individual sidebar item matching admin sidebar aesthetic.
///
/// Features: hover background, active primary fill with white text,
/// bold for section headings, indented for children.
class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isBold = false,
    this.indent = false,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isBold;
  final bool indent;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isFlat = AppTheme.chromeStyle == ChromeStyle.flat;
    final usesMinimalActiveState = isFlat;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.only(
            left: widget.indent ? 28 : 18,
            right: 18,
            top: 14,
            bottom: 14,
          ),
          decoration: BoxDecoration(
            gradient: usesMinimalActiveState
                ? null
                : widget.isActive
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primary,
                          AppTheme.primaryHover,
                        ],
                      )
                    : AppTheme.chromeItemGradient(hovered: _isHovered),
            color: usesMinimalActiveState
                ? widget.isActive
                    ? AppTheme.primary.withValues(
                        alpha: isFlat
                            ? (isDark ? 0.14 : 0.07)
                            : (isDark ? 0.20 : 0.10),
                      )
                    : _isHovered
                        ? AppTheme.primary.withValues(
                            alpha: isDark ? 0.12 : 0.08,
                          )
                        : Colors.transparent
                : null,
            border: usesMinimalActiveState
                ? Border(
                    left: BorderSide(
                      color: widget.isActive
                          ? AppTheme.primary
                          : Colors.transparent,
                      width: 3,
                    ),
                  )
                : Border.all(
                    color: widget.isActive
                        ? AppTheme.primaryHover
                        : AppTheme.chromeBorder,
                  ),
            boxShadow: usesMinimalActiveState
                ? null
                : AppTheme.chromeItemShadows(
                    active: widget.isActive,
                    hovered: _isHovered,
                  ),
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: widget.isActive
                  ? (usesMinimalActiveState
                      ? AppTheme.primary
                      : AppTheme.textContrast)
                  : context.appColors.textPrimary,
              fontWeight: widget.isActive
                  ? FontWeight.w600
                  : (widget.isBold ? FontWeight.w600 : FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
