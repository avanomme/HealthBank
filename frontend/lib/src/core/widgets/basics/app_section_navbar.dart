// Created with the Assistance of ChatGPT

/// AppSectionNavbar
///
/// Description:
/// - A reusable section navigation sidebar with collapsible groups.
/// - Supports heading-level links and child-level links.
/// - Highlights the active destination based on parent page state.
/// - Handles in-page destination callbacks only (no route navigation).
///
/// Usage Example:
/// ```dart
/// AppSectionNavbar(
///   activeDestinationId: 'overview',
///   sections: [
///     AppSectionNavbarSection(
///       id: 's1',
///       label: 'Overview',
///       destinationId: 'overview',
///       children: [
///         AppSectionNavbarItem(
///           label: 'Metric A',
///           destinationId: 'metric-a',
///         ),
///       ],
///     ),
///   ],
///   onDestinationTap: (id) {},
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_icon.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';

class AppSectionNavbarItem {
  const AppSectionNavbarItem({
    required this.label,
    required this.destinationId,
  });

  final String label;
  final String destinationId;
}

class AppSectionNavbarSection {
  const AppSectionNavbarSection({
    required this.id,
    required this.label,
    required this.destinationId,
    this.children = const [],
    this.initiallyExpanded = true,
  });

  final String id;
  final String label;
  final String destinationId;
  final List<AppSectionNavbarItem> children;
  final bool initiallyExpanded;
}

class AppSectionNavbar extends StatefulWidget {
  const AppSectionNavbar({
    super.key,
    required this.sections,
    required this.onDestinationTap,
    this.activeDestinationId,
  });

  final List<AppSectionNavbarSection> sections;
  final ValueChanged<String> onDestinationTap;
  final String? activeDestinationId;

  @override
  State<AppSectionNavbar> createState() => _AppSectionNavbarState();
}

class _AppSectionNavbarState extends State<AppSectionNavbar> {
  late Set<String> _expandedSectionIds;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _expandedSectionIds = {
      for (final section in widget.sections)
        if (section.initiallyExpanded) section.id,
    };
  }

  @override
  void didUpdateWidget(covariant AppSectionNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_hasSameSectionStructure(oldWidget.sections, widget.sections)) {
      _expandedSectionIds = {
        for (final section in widget.sections)
          if (section.initiallyExpanded ||
              _expandedSectionIds.contains(section.id))
            section.id,
      };
    }

    final activeId = widget.activeDestinationId;
    if (activeId == null) return;

    for (final section in widget.sections) {
      final sectionHasActiveChild = section.children.any(
        (child) => child.destinationId == activeId,
      );
      if (sectionHasActiveChild && !_expandedSectionIds.contains(section.id)) {
        _expandedSectionIds = {..._expandedSectionIds, section.id};
        break;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _hasSameSectionStructure(
    List<AppSectionNavbarSection> oldSections,
    List<AppSectionNavbarSection> newSections,
  ) {
    if (identical(oldSections, newSections)) return true;
    if (oldSections.length != newSections.length) return false;

    for (var index = 0; index < oldSections.length; index++) {
      final oldSection = oldSections[index];
      final newSection = newSections[index];
      if (oldSection.id != newSection.id) return false;
      if (oldSection.children.length != newSection.children.length) {
        return false;
      }

      for (
        var childIndex = 0;
        childIndex < oldSection.children.length;
        childIndex++
      ) {
        if (oldSection.children[childIndex].destinationId !=
            newSection.children[childIndex].destinationId) {
          return false;
        }
      }
    }

    return true;
  }

  void _toggleSection(String sectionId) {
    if (_isSectionForcedExpanded(sectionId)) {
      return;
    }

    setState(() {
      if (_expandedSectionIds.contains(sectionId)) {
        _expandedSectionIds.remove(sectionId);
      } else {
        _expandedSectionIds.add(sectionId);
      }
    });
  }

  bool _isSectionForcedExpanded(String sectionId) {
    final activeId = widget.activeDestinationId;
    if (activeId == null) return false;

    AppSectionNavbarSection? section;
    for (final item in widget.sections) {
      if (item.id == sectionId) {
        section = item;
        break;
      }
    }
    if (section == null) return false;

    return section.children.any((child) => child.destinationId == activeId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final section in widget.sections) ...[
                _buildSectionHeading(section),
                _buildSectionChildren(section),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeading(AppSectionNavbarSection section) {
    final activeId = widget.activeDestinationId;
    final isActiveSection = activeId == section.destinationId;
    final hasActiveChild = section.children.any(
      (child) => child.destinationId == activeId,
    );
    final isHighlighted = isActiveSection || hasActiveChild;
    final canCollapse = !hasActiveChild;
    final isExpanded = _expandedSectionIds.contains(section.id);

    return Container(
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppTheme.primary.withValues(alpha: 0.12)
            : AppTheme.primary.withValues(alpha: 0.08),
        border: Border(bottom: BorderSide(color: context.appColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _HoverableDestination(
              active: isHighlighted,
              baseColor: isHighlighted
                  ? AppTheme.primary.withValues(alpha: 0.12)
                  : AppTheme.primary.withValues(alpha: 0.08),
              hoverColor: isHighlighted
                  ? AppTheme.primary.withValues(alpha: 0.16)
                  : context.appColors.divider.withValues(alpha: 0.55),
              onTap: () => widget.onDestinationTap(section.destinationId),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: AppText(
                  section.label,
                  variant: AppTextVariant.headlineSmall,
                  color: isHighlighted
                      ? AppTheme.primary
                      : context.appColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: canCollapse
                ? (isExpanded
                    ? context.l10n.tooltipCollapseSidebar
                    : context.l10n.tooltipExpandSidebar)
                : null,
            onPressed: canCollapse ? () => _toggleSection(section.id) : null,
            visualDensity: VisualDensity.compact,
            icon: AppIcon(
              isExpanded ? Icons.expand_more : Icons.chevron_right,
              size: 16,
              color: canCollapse
                  ? context.appColors.textMuted
                  : context.appColors.textMuted.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionChildren(AppSectionNavbarSection section) {
    final isExpanded = _expandedSectionIds.contains(section.id);

    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        child: ConstrainedBox(
          constraints: isExpanded
              ? const BoxConstraints()
              : const BoxConstraints(maxHeight: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final child in section.children) _buildChildItem(child),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildItem(AppSectionNavbarItem item) {
    final isActive = widget.activeDestinationId == item.destinationId;

    return _HoverableDestination(
      active: isActive,
      baseColor: isActive
          ? AppTheme.primary.withValues(alpha: 0.12)
          : context.appColors.surface,
      hoverColor: isActive
          ? AppTheme.primary.withValues(alpha: 0.16)
          : context.appColors.divider.withValues(alpha: 0.45),
      onTap: () => widget.onDestinationTap(item.destinationId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.appColors.divider)),
        ),
        child: AppText(
          item.label,
          variant: AppTextVariant.bodyMedium,
          color: isActive ? AppTheme.primary : context.appColors.textMuted,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _HoverableDestination extends StatefulWidget {
  const _HoverableDestination({
    required this.child,
    required this.onTap,
    required this.baseColor,
    required this.hoverColor,
    required this.active,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color baseColor;
  final Color hoverColor;
  final bool active;

  @override
  State<_HoverableDestination> createState() => _HoverableDestinationState();
}

class _HoverableDestinationState extends State<_HoverableDestination> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovered && !widget.active
        ? widget.hoverColor
        : widget.baseColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}
