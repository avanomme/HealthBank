// Created with the Assistance of Codex

/// AppToast
///
/// Description:
/// - A theme-aware overlay toast widget for transient messaging.
/// - `AppToast` provides semantic variants (success, info, caution, error, custom)
///   through named constructors and static show helpers.
///
/// Features:
/// - Optional leading icon with required text content.
/// - Optional close button for early dismissal.
/// - Responsive positioning and animation based on breakpoints.
///
/// Usage Example:
/// ```dart
/// AppToast.showSuccess(
///   context,
///   message: 'Profile updated successfully.',
/// );
/// ```
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppToast extends StatelessWidget {
  const AppToast._({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.borderColor,
    this.showClose = true,
    this.onClose,
  });

  /// Toast message content.
  final String message;

  /// Background color for the toast container.
  final Color backgroundColor;

  /// Text color for the message.
  final Color textColor;

  /// Optional leading icon.
  final Widget? icon;

  /// Optional border color override.
  final Color? borderColor;

  /// Whether to show the close button.
  final bool showClose;

  /// Optional close callback.
  final VoidCallback? onClose;

  /// Success variant toast.
  factory AppToast.success({
    Key? key,
    required String message,
    Widget? icon,
    bool showClose = true,
    VoidCallback? onClose,
  }) {
    return AppToast._(
      key: key,
      message: message,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.textContrast,
      icon: icon ?? const Icon(Icons.check_circle_outline),
      showClose: showClose,
      onClose: onClose,
    );
  }

  /// Info variant toast.
  factory AppToast.info({
    Key? key,
    required String message,
    Widget? icon,
    bool showClose = true,
    VoidCallback? onClose,
  }) {
    return AppToast._(
      key: key,
      message: message,
      backgroundColor: AppTheme.info,
      textColor: AppTheme.textContrast,
      icon: icon ?? const Icon(Icons.info_outline),
      showClose: showClose,
      onClose: onClose,
    );
  }

  /// Caution variant toast.
  factory AppToast.caution({
    Key? key,
    required String message,
    Widget? icon,
    bool showClose = true,
    VoidCallback? onClose,
  }) {
    return AppToast._(
      key: key,
      message: message,
      backgroundColor: AppTheme.caution,
      textColor: AppTheme.textPrimary,
      icon: icon ?? const Icon(Icons.warning_amber_outlined),
      showClose: showClose,
      onClose: onClose,
    );
  }

  /// Error variant toast.
  factory AppToast.error({
    Key? key,
    required String message,
    Widget? icon,
    bool showClose = true,
    VoidCallback? onClose,
  }) {
    return AppToast._(
      key: key,
      message: message,
      backgroundColor: AppTheme.error,
      textColor: AppTheme.textContrast,
      icon: icon ?? const Icon(Icons.error_outline),
      showClose: showClose,
      onClose: onClose,
    );
  }

  /// Custom variant toast.
  factory AppToast.custom({
    Key? key,
    required String message,
    required Color backgroundColor,
    Widget? icon,
    Color? textColor,
    Color? borderColor,
    bool showClose = true,
    VoidCallback? onClose,
  }) {
    return AppToast._(
      key: key,
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor ?? AppTheme.textContrast,
      icon: icon,
      borderColor: borderColor,
      showClose: showClose,
      onClose: onClose,
    );
  }

  /// Shows a success toast via overlay.
  static void showSuccess(
    BuildContext context, {
    required String message,
    Widget? icon,
    bool showClose = true,
    Duration duration = const Duration(seconds: 4),
  }) {
    _ToastOverlay.show(
      context,
      duration: duration,
      builder: (close) => AppToast.success(
        message: message,
        icon: icon,
        showClose: showClose,
        onClose: close,
      ),
    );
  }

  /// Shows an info toast via overlay.
  static void showInfo(
    BuildContext context, {
    required String message,
    Widget? icon,
    bool showClose = true,
    Duration duration = const Duration(seconds: 4),
  }) {
    _ToastOverlay.show(
      context,
      duration: duration,
      builder: (close) => AppToast.info(
        message: message,
        icon: icon,
        showClose: showClose,
        onClose: close,
      ),
    );
  }

  /// Shows a caution toast via overlay.
  static void showCaution(
    BuildContext context, {
    required String message,
    Widget? icon,
    bool showClose = true,
    Duration duration = const Duration(seconds: 4),
  }) {
    _ToastOverlay.show(
      context,
      duration: duration,
      builder: (close) => AppToast.caution(
        message: message,
        icon: icon,
        showClose: showClose,
        onClose: close,
      ),
    );
  }

  /// Shows an error toast via overlay.
  static void showError(
    BuildContext context, {
    required String message,
    Widget? icon,
    bool showClose = true,
    Duration duration = const Duration(seconds: 4),
  }) {
    _ToastOverlay.show(
      context,
      duration: duration,
      builder: (close) => AppToast.error(
        message: message,
        icon: icon,
        showClose: showClose,
        onClose: close,
      ),
    );
  }

  /// Shows a custom toast via overlay.
  static void showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    Widget? icon,
    Color? textColor,
    Color? borderColor,
    bool showClose = true,
    Duration duration = const Duration(seconds: 4),
  }) {
    _ToastOverlay.show(
      context,
      duration: duration,
      builder: (close) => AppToast.custom(
        message: message,
        backgroundColor: backgroundColor,
        icon: icon,
        textColor: textColor,
        borderColor: borderColor,
        showClose: showClose,
        onClose: close,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: message,
        child: _ToastCard(
          message: message,
          icon: icon,
          backgroundColor: backgroundColor,
          textColor: textColor,
          borderColor: borderColor,
          showClose: showClose,
          onClose: onClose,
        ),
      ),
    );
  }
}

class _ToastOverlay {
  static void show(
    BuildContext context, {
    required Widget Function(VoidCallback close) builder,
    Duration duration = const Duration(seconds: 4),
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) => _ToastPresenter(
        duration: duration,
        builder: builder,
        onDismissed: () => entry.remove(),
      ),
    );

    Overlay.of(context).insert(entry);
  }
}

class _ToastPresenter extends StatefulWidget {
  const _ToastPresenter({
    required this.builder,
    required this.duration,
    required this.onDismissed,
  });

  final Widget Function(VoidCallback close) builder;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_ToastPresenter> createState() => _ToastPresenterState();
}

class _ToastPresenterState extends State<_ToastPresenter>
    with SingleTickerProviderStateMixin {
  static const _enterDuration = Duration(milliseconds: 250);
  static const _exitDuration = Duration(milliseconds: 200);

  late final AnimationController _controller;
  late Animation<Offset> _offset;
  Timer? _timer;
  bool _isMobile = false;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _enterDuration,
      reverseDuration: _exitDuration,
    );
    _scheduleAutoDismiss();
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;
    _isMobile = Breakpoints.isMobile(width);
    final begin = _isMobile ? const Offset(0, -1) : const Offset(1, 0);
    _offset = Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleAutoDismiss() {
    _timer?.cancel();
    _timer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (_isDismissing) return;
    _isDismissing = true;
    _timer?.cancel();
    _controller.reverse().whenComplete(() {
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalMargin = Breakpoints.responsiveHorizontalMargin(width);
    final verticalPadding = Breakpoints.responsivePadding(width);
    final alignment = _isMobile ? Alignment.topCenter : Alignment.bottomRight;

    final padding = _isMobile
        ? EdgeInsets.only(
            top: verticalPadding,
            left: horizontalMargin,
            right: horizontalMargin,
          )
        : EdgeInsets.only(right: horizontalMargin, bottom: verticalPadding);

    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: padding,
          child: SlideTransition(
            position: _offset,
            child: Material(
              color: Colors.transparent,
              child: widget.builder(_dismiss),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.borderColor,
    this.showClose = true,
    this.onClose,
  });

  final String message;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon;
  final Color? borderColor;
  final bool showClose;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bp = breakpointForWidth(width);
    final textTheme = AppTheme.textThemeForBreakpoint(bp);

    final basePadding = Breakpoints.responsivePadding(width);
    final horizontalPadding = basePadding * 0.8;
    final verticalPadding = basePadding * 0.6;
    final gap = basePadding * 0.4;
    final borderRadius = BorderRadius.circular(basePadding * 0.6);
    final borderWidth = math.max(1.0, basePadding * 0.08);

    final resolvedTextStyle = (textTheme.bodyMedium ?? AppTheme.body).copyWith(
      color: textColor,
    );

    final iconSize = (resolvedTextStyle.fontSize ?? 16) * 1.25;
    final maxWidth = Breakpoints.isMobile(width)
        ? double.infinity
        : Breakpoints.maxContent;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: borderWidth),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                IconTheme(
                  data: IconThemeData(color: textColor, size: iconSize),
                  child: icon!,
                ),
              if (icon != null) SizedBox(width: gap),
              Flexible(child: Text(message, style: resolvedTextStyle)),
              if (showClose) SizedBox(width: gap),
              if (showClose)
                IconButton(
                  onPressed: onClose,
                  tooltip: context.l10n.tooltipDismissNotification,
                  icon: const Icon(Icons.close),
                  color: textColor,
                  disabledColor: textColor,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
