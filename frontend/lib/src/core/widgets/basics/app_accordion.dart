// Created with the Assistance of ChatGPT

/// AppAccordion
///
/// Description:
/// - A theme-aware expandable panel for showing/hiding content.
/// - `AppAccordion` is a **basic widget** designed to be reused across the app.
///
/// Features:
/// - Collapsed title uses Heading 4; expanded body uses Body text.
/// - Optional leading icon with configurable (theme-derived) color.
/// - Expand/collapse animation for smooth transitions.
///
/// Usage Example:
/// ```dart
/// AppAccordion(
///   title: 'Details',
///   body: 'Additional context goes here.',
///   leadingIcon: const Icon(Icons.info_outline),
/// );
/// ```
library;


import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

class AppAccordion extends StatefulWidget {
  const AppAccordion({
    super.key,
    required this.title,
    required this.body,
    this.leadingIcon,
    this.iconColor,
    this.initiallyExpanded = false,
    this.onChanged,
  });

  /// Accordion header title.
  final String title;

  /// Accordion body content.
  final String body;

  /// Optional leading icon displayed before the title.
  final Widget? leadingIcon;

  /// Optional icon color override (use AppTheme colors).
  final Color? iconColor;

  /// Whether the accordion starts expanded.
  final bool initiallyExpanded;

  /// Callback invoked when expansion state changes.
  final ValueChanged<bool>? onChanged;

  @override
  State<AppAccordion> createState() => _AppAccordionState();
}

class _AppAccordionState extends State<AppAccordion> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(covariant AppAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _expanded = widget.initiallyExpanded;
    }
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
    widget.onChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);
    final headingStyle = textTheme.headlineMedium ?? AppTheme.heading4;
    final bodyStyle = textTheme.bodyMedium ?? AppTheme.body;
    final resolvedIconColor = widget.iconColor ?? AppTheme.primary;
    final basePadding = Breakpoints.responsivePadding(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _toggle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: basePadding * 0.4),
            child: Row(
              children: [
                if (widget.leadingIcon != null)
                  IconTheme(
                    data: IconThemeData(color: resolvedIconColor),
                    child: widget.leadingIcon!,
                  ),
                if (widget.leadingIcon != null) SizedBox(width: basePadding * 0.4),
                Expanded(
                  child: Text(
                    widget.title,
                    style: headingStyle,
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: ExcludeSemantics(child: Icon(Icons.expand_more, color: resolvedIconColor)),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              constraints: _expanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 0),
              child: Padding(
                padding: EdgeInsets.only(bottom: basePadding * 0.4),
                child: Text(
                  widget.body,
                  style: bodyStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
