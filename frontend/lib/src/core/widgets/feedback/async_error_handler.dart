// Created with the Assistance of Claude Code
// frontend/lib/src/core/widgets/feedback/async_error_handler.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/app_outlined_button.dart';
import 'package:frontend/src/core/widgets/feedback/app_loading_indicator.dart';

/// Standardized handler for [AsyncValue] states.
///
/// Provides consistent loading, error, and data rendering across all pages.
///
/// Usage:
/// ```dart
/// AsyncValueWidget<List<Survey>>(
///   value: ref.watch(surveysProvider),
///   data: (surveys) => SurveyList(surveys: surveys),
///   onRetry: () => ref.invalidate(surveysProvider),
/// )
/// ```
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loadingMessage,
    this.errorMessage,
  });

  /// The async value to render.
  final AsyncValue<T> value;

  /// Builder for the data state.
  final Widget Function(T data) data;

  /// Optional retry callback — shows a retry button on error.
  final VoidCallback? onRetry;

  /// Optional loading message (shown below spinner).
  final String? loadingMessage;

  /// Optional custom error message (overrides the default).
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLoadingIndicator(centered: false),
              if (loadingMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  loadingMessage!,
                  style: AppTheme.body.copyWith(color: context.appColors.textMuted),
                ),
              ],
            ],
          ),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ExcludeSemantics(child: Icon(Icons.error_outline, color: AppTheme.error, size: 48)),
              const SizedBox(height: 12),
              Text(
                errorMessage ?? 'Something went wrong',
                style: AppTheme.body.copyWith(color: context.appColors.textMuted),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                AppOutlinedButton(
                  label: 'Retry',
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
