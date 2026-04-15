// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/data_display/data_table_cell.dart
/// Reusable table cell widgets for consistent data table styling.
///
/// Usage:
/// ```dart
/// DataTableCell.text('John Doe'),
/// DataTableCell.badge('Admin', color: AppTheme.error),
/// DataTableCell.status(isActive: true),
/// DataTableCell.date(DateTime.now()),
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';

/// Alignment options for table cell content
enum CellAlignment {
  start,
  center,
  end,
}

/// A reusable table cell widget with consistent styling.
///
/// Provides factory constructors for common cell types:
/// - [DataTableCell.text] - Plain text cell
/// - [DataTableCell.badge] - Colored badge/chip cell
/// - [DataTableCell.status] - Active/inactive status indicator
/// - [DataTableCell.date] - Formatted date cell
/// - [DataTableCell.actions] - Action buttons cell
/// - [DataTableCell.avatar] - Avatar with text cell
class DataTableCell extends StatelessWidget {
  const DataTableCell({
    super.key,
    required this.child,
    this.flex = 1,
    this.alignment = CellAlignment.start,
    this.padding,
  });

  final Widget child;
  final int flex;
  final CellAlignment alignment;
  final EdgeInsets? padding;

  /// Creates a text cell with optional styling.
  ///
  /// Use [muted] for secondary text, or provide [textColor] for custom colors.
  /// Use [fontWeight] or [textStyle] for additional styling.
  factory DataTableCell.text(
    String text, {
    Key? key,
    int flex = 1,
    bool muted = false,
    Color? textColor,
    FontWeight? fontWeight,
    TextStyle? textStyle,
    CellAlignment alignment = CellAlignment.start,
    TextOverflow overflow = TextOverflow.ellipsis,
    bool softWrap = false,
    BuildContext? context,
  }) {
    final baseStyle = textStyle ?? AppTheme.body;
    final colors = context?.appColors;
    final resolvedColor = textColor ??
        (muted
            ? (colors?.textMuted ?? AppTheme.textMuted)
            : (colors?.textPrimary ?? AppTheme.textPrimary));

    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Text(
        text,
        style: baseStyle.copyWith(
          color: resolvedColor,
          fontWeight: fontWeight,
        ),
        overflow: overflow,
        softWrap: softWrap,
      ),
    );
  }

  /// Creates a badge/chip cell with colored background.
  factory DataTableCell.badge(
    String text, {
    Key? key,
    int flex = 1,
    required Color color,
    CellAlignment alignment = CellAlignment.start,
  }) {
    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              text,
              style: AppTheme.captions.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates an active/inactive status cell with dot indicator.
  ///
  /// Custom colors can be provided via [activeColor] and [inactiveColor].
  factory DataTableCell.status({
    Key? key,
    required bool isActive,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
    String? activeText,
    String? inactiveText,
    Color? activeColor,
    Color? inactiveColor,
  }) {
    final dotColor = isActive
        ? (activeColor ?? AppTheme.success)
        : (inactiveColor ?? AppTheme.error);

    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? (activeText ?? 'Active') : (inactiveText ?? 'Inactive'),
            style: AppTheme.captions,
          ),
        ],
      ),
    );
  }

  /// Creates a date cell with relative or absolute formatting.
  factory DataTableCell.date(
    DateTime? date, {
    Key? key,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
    String nullText = 'Never',
    bool relative = true,
  }) {
    String text;
    if (date == null) {
      text = nullText;
    } else if (relative) {
      text = _formatRelativeDate(date);
    } else {
      text = '${date.month}/${date.day}/${date.year}';
    }

    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Builder(
        builder: (ctx) => Text(
          text,
          style: AppTheme.captions.copyWith(color: ctx.appColors.textMuted),
        ),
      ),
    );
  }

  /// Creates an action buttons cell.
  factory DataTableCell.actions({
    Key? key,
    required List<Widget> children,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
  }) {
    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  /// Creates a cell with avatar and text.
  factory DataTableCell.avatar({
    Key? key,
    required String text,
    required String initial,
    required Color color,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
  }) {
    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Text(
              initial.toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: AppTheme.body,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a toggle/switch cell.
  ///
  /// Use [onChanged] to handle value changes. Set to null to make read-only.
  factory DataTableCell.toggle({
    Key? key,
    required bool value,
    required ValueChanged<bool>? onChanged,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
    Color? activeColor,
  }) {
    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: activeColor ?? AppTheme.success,
        activeTrackColor:
            (activeColor ?? AppTheme.success).withValues(alpha: 0.3),
      ),
    );
  }

  /// Creates an icon cell with optional tooltip and tap handler.
  factory DataTableCell.icon({
    Key? key,
    required IconData icon,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
    Color? color,
    double size = 20,
    String? tooltip,
    VoidCallback? onTap,
  }) {
    Widget iconWidget =
        Icon(icon, size: size, color: color);
    if (tooltip != null) {
      iconWidget = Tooltip(message: tooltip, child: iconWidget);
    }
    if (onTap != null) {
      iconWidget = InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: iconWidget,
      );
    }
    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: iconWidget,
    );
  }

  /// Creates a monospace text cell for code, paths, or timestamps.
  factory DataTableCell.monospace(
    String text, {
    Key? key,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
    Color? textColor,
    double fontSize = 12,
    bool softWrap = false,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) {
    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Builder(
        builder: (ctx) => Text(
          text,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: fontSize,
            color: textColor ?? ctx.appColors.textMuted,
          ),
          overflow: overflow,
          softWrap: softWrap,
        ),
      ),
    );
  }

  /// Creates a stacked two-line cell with primary and secondary text.
  ///
  /// Useful for displaying a name with an email underneath, etc.
  factory DataTableCell.multiLine({
    Key? key,
    required String primary,
    String? secondary,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
    FontWeight primaryWeight = FontWeight.w500,
    bool secondaryMuted = true,
  }) {
    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            primary,
            style: AppTheme.body.copyWith(fontWeight: primaryWeight),
            overflow: TextOverflow.ellipsis,
          ),
          if (secondary != null)
            Builder(
              builder: (ctx) => Text(
                secondary,
                style: AppTheme.captions.copyWith(
                  color: secondaryMuted
                      ? ctx.appColors.textMuted
                      : ctx.appColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  /// Creates a custom cell with any widget.
  factory DataTableCell.custom({
    Key? key,
    required Widget child,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
    EdgeInsets? padding,
  }) {
    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      padding: padding,
      child: child,
    );
  }

  /// Creates a raw/database value cell.
  ///
  /// Displays null values as styled 'NULL', truncates long strings,
  /// and uses monospace font. Ideal for database viewers and raw data display.
  factory DataTableCell.rawValue(
    dynamic value, {
    Key? key,
    int flex = 1,
    CellAlignment alignment = CellAlignment.start,
    int maxLength = 50,
    String nullText = 'NULL',
  }) {
    if (value == null) {
      return DataTableCell(
        key: key,
        flex: flex,
        alignment: alignment,
        child: Builder(
          builder: (ctx) => Text(
            nullText,
            style: AppTheme.captions.copyWith(
              fontFamily: 'monospace',
              fontStyle: FontStyle.italic,
              color: ctx.appColors.textMuted,
            ),
          ),
        ),
      );
    }

    final str = value.toString();
    final display = str.length > maxLength
        ? '${str.substring(0, maxLength - 3)}...'
        : str;

    return DataTableCell(
      key: key,
      flex: flex,
      alignment: alignment,
      child: Builder(
        builder: (ctx) => Text(
          display,
          style: AppTheme.captions.copyWith(
            fontFamily: 'monospace',
            color: ctx.appColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static String _formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    // Use absolute values — negative diffs can occur when the backend
    // sends UTC timestamps that are parsed without timezone info.
    final minutes = diff.inMinutes.abs();
    final hours = diff.inHours.abs();
    final days = diff.inDays.abs();

    if (minutes < 60) {
      return '${minutes}m ago';
    } else if (hours < 24) {
      return '${hours}h ago';
    } else if (days < 7) {
      return '${days}d ago';
    } else {
      final local = date.toLocal();
      return '${local.month}/${local.day}/${local.year}';
    }
  }

  MainAxisAlignment _getMainAxisAlignment() {
    switch (alignment) {
      case CellAlignment.start:
        return MainAxisAlignment.start;
      case CellAlignment.center:
        return MainAxisAlignment.center;
      case CellAlignment.end:
        return MainAxisAlignment.end;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Extra space on the left so the first column doesn't hug the table border.
      padding: padding ?? const EdgeInsets.fromLTRB(16, 6, 8, 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: _getMainAxisAlignment(),
        children: [
          Flexible(child: child),
        ],
      ),
    );
  }
}
