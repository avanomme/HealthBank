// Created with the Assistance of Codex
/// AppSearchBar
///
/// Description:
/// - A theme-aware search input with leading search icon and conditional clear
///   action.
/// - `AppSearchBar` is a **form widget** designed for reusable text filtering
///   and query entry.
///
/// Features:
/// - Supports external or internal `TextEditingController`.
/// - Emits query updates through `onChanged` and `onSubmitted`.
/// - Shows a clear button only when the field has text.
/// - Uses shared form decoration for consistent visual style.
/// - No required-form validation behavior is enforced.
///
/// Usage Example:
/// ```dart
/// AppSearchBar(
///   hintText: 'Search records',
///   onChanged: (query) => runSearch(query),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  TextEditingController? _internalController;

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    _controller.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(covariant AppSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onValueChanged);
      _internalController?.removeListener(_onValueChanged);

      if (widget.controller == null && _internalController == null) {
        _internalController = TextEditingController();
      }

      _controller.addListener(_onValueChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onValueChanged);
    _internalController?.dispose();
    super.dispose();
  }

  void _onValueChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = appFormMetrics(context);
    final canClear = _controller.text.isNotEmpty;

    return appFieldSemantics(
      label: widget.hintText ?? context.l10n.commonSearch,
      enabled: true,
      textField: true,
      value: _controller.text.isEmpty ? null : _controller.text,
      hintText: widget.hintText ?? context.l10n.commonSearch,
      child: TextField(
        controller: _controller,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        style: metrics.bodyStyle,
        decoration: appInputDecoration(
          context,
          hintText: widget.hintText ?? context.l10n.commonSearch,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: canClear
              ? IconButton(
                  tooltip: context.l10n.tooltipClearSearch,
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
        ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
