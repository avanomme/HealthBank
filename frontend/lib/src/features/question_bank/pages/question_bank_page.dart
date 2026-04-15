// Created with the Assistance of Claude Code
// frontend/lib/src/features/question_bank/pages/question_bank_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/widgets/basics/footer.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:go_router/go_router.dart';
import '../state/question_providers.dart';
import '../widgets/question_bank_card.dart';
import '../widgets/question_bank_form_dialog.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Question Bank Browser Page
///
/// Displays a searchable, filterable list of questions from the question bank.
/// Supports selection mode for adding questions to surveys.
class QuestionBankPage extends ConsumerStatefulWidget {
  const QuestionBankPage({
    super.key,
    this.selectionMode = false,
    this.onQuestionsSelected,
  });

  /// Whether the page is in selection mode (for adding to surveys)
  final bool selectionMode;

  /// Callback when questions are selected (selection mode only)
  final void Function(List<Question>)? onQuestionsSelected;

  @override
  ConsumerState<QuestionBankPage> createState() => _QuestionBankPageState();
}

class _QuestionBankPageState extends ConsumerState<QuestionBankPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sync selection-mode provider and reset transient selection state.
    // Cleanup on navigation away is not safe from dispose/deactivate due to
    // Riverpod lifecycle constraints, so we reset at entry instead.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(selectionModeProvider.notifier).state = widget.selectionMode;
      // Always start with a clean selection (entering or leaving selection mode).
      ref.read(selectedQuestionIdsProvider.notifier).clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(questionFiltersProvider.notifier).setSearchQuery(query);
  }

  void _onFilterChanged(String filterType, String? value) {
    final notifier = ref.read(questionFiltersProvider.notifier);
    if (filterType == 'responseType') {
      notifier.setResponseType(value);
    } else if (filterType == 'category') {
      notifier.setCategory(value);
    }
  }

  void _clearFilters() {
    ref.read(questionFiltersProvider.notifier).clearAll();
    _searchController.clear();
  }

  void _closeSelectionMode() {
    ref.read(selectionModeProvider.notifier).state = false;
    ref.read(selectedQuestionIdsProvider.notifier).clear();
  }

  void _onConfirmSelection() {
    final selectedIds = ref.read(selectedQuestionIdsProvider);
    final questionsAsync = ref.read(questionsProvider);

    questionsAsync.whenData((questions) {
      final selectedQuestions = questions
          .where((q) => selectedIds.contains(q.questionId))
          .toList();

      _closeSelectionMode();
      widget.onQuestionsSelected?.call(selectedQuestions);
    });
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider);
    final filters = ref.watch(questionFiltersProvider);
    final isSelectionMode = ref.watch(selectionModeProvider);
    final selectedIds = ref.watch(selectedQuestionIdsProvider);

    // In selection mode, use a simple Scaffold with back button and confirm action
    if (isSelectionMode) {
      return PopScope(
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) _closeSelectionMode();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.questionBankSelectQuestions),
            leading: IconButton(
              tooltip: context.l10n.tooltipGoBack,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _closeSelectionMode();
                Navigator.of(context).maybePop();
              },
            ),
          ),
          body: Column(
            children: [
              _buildSearchAndFilters(filters),
              if (_hasActiveFilters(filters)) _buildActiveFiltersChips(filters),
              Expanded(
                child: questionsAsync.when(
                  data: (questions) =>
                      _buildQuestionsList(questions, selectedIds),
                  loading: () => const AppLoadingIndicator(),
                  error: (error, stack) => _buildErrorState(error),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AppFilledButton(
                label: selectedIds.isNotEmpty
                    ? context.l10n.questionBankAddCount(selectedIds.length)
                    : context.l10n.questionBankSelectQuestions,
                onPressed: selectedIds.isNotEmpty ? _onConfirmSelection : null,
              ),
            ),
          ),
        ),
      );
    }

    return ResearcherScaffold(
      currentRoute: '/questions',
      alignment: AppPageAlignment.regular,
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => QuestionBankFormDialog.show(context),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.questionBankNewQuestion),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textContrast,
      ),
      child: Column(
        children: [
          // Search and filters
          _buildSearchAndFilters(filters),

          // Active filters chips
          if (_hasActiveFilters(filters)) _buildActiveFiltersChips(filters),

          // Questions list
          Expanded(
            child: questionsAsync.when(
              data: (questions) => _buildQuestionsList(questions, selectedIds),
              loading: () => const AppLoadingIndicator(),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlignedContent(Widget child) {
    return AppPageAlignedContent(child: child);
  }

  Widget _buildSearchAndFilters(QuestionFilters filters) {
    return Builder(
      builder: (context) {
        final metrics = appFormMetrics(context);

        return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.appColors.surfaceRaised,
          boxShadow: context.appColors.cardShadow,
        ),
        child: _buildAlignedContent(
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  style: metrics.bodyStyle,
                  decoration: appInputDecoration(
                    context,
                    labelText: context.l10n.commonSearch,
                    hintText: context.l10n.questionBankSearchPlaceholder,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: context.l10n.tooltipClearSearch,
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                  ),
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 12),

                // Filter dropdowns
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stackFilters = constraints.maxWidth < 520;

                    if (stackFilters) {
                      return Column(
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: filters.responseType,
                            isExpanded: true,
                            style: metrics.bodyStyle,
                            dropdownColor: context.appColors.surface,
                            decoration: appInputDecoration(
                              context,
                              labelText: context.l10n.questionBankFilterType,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(context.l10n.questionBankAllTypes),
                              ),
                              ...responseTypes.map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    localizedResponseTypeLabels(
                                          context.l10n,
                                        )[type] ??
                                        type,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                _onFilterChanged('responseType', value),
                          ),
                          const SizedBox(height: 12),
                          _buildCategoryDropdown(context, filters),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: filters.responseType,
                            isExpanded: true,
                            style: metrics.bodyStyle,
                            dropdownColor: context.appColors.surface,
                            decoration: appInputDecoration(
                              context,
                              labelText: context.l10n.questionBankFilterType,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(context.l10n.questionBankAllTypes),
                              ),
                              ...responseTypes.map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    localizedResponseTypeLabels(
                                          context.l10n,
                                        )[type] ??
                                        type,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                _onFilterChanged('responseType', value),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildCategoryDropdown(context, filters)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
      },
    );
  }

  /// Build the category dropdown with data from API
  Widget _buildCategoryDropdown(BuildContext context, QuestionFilters filters) {
    final categoriesAsync = ref.watch(questionCategoriesProvider);

    return categoriesAsync.when(
      data: (categories) => _buildCategoryField(
        context,
        filters: filters,
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(context.l10n.questionBankAllCategories),
          ),
          ...categories.map(
            (cat) => DropdownMenuItem(
              value: cat.categoryKey,
              child: Text(_getCategoryLabel(context, cat.categoryKey)),
            ),
          ),
        ],
        onChanged: (value) => _onFilterChanged('category', value),
      ),
      loading: () => _buildCategoryField(
        context,
        filters: filters,
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(context.l10n.questionBankAllCategories),
          ),
        ],
      ),
      error: (_, __) => _buildCategoryField(
        context,
        filters: filters,
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(context.l10n.questionBankAllCategories),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryField(
    BuildContext context, {
    required QuestionFilters filters,
    required List<DropdownMenuItem<String?>> items,
    ValueChanged<String?>? onChanged,
  }) {
    final metrics = appFormMetrics(context);
    return DropdownButtonFormField<String?>(
      initialValue: onChanged == null ? null : filters.category,
      isExpanded: true,
      style: metrics.bodyStyle,
      dropdownColor: context.appColors.surface,
      decoration: appInputDecoration(
        context,
        labelText: context.l10n.questionBankFilterCategory,
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  /// Get localized label for a category key
  String _getCategoryLabel(BuildContext context, String categoryKey) {
    switch (categoryKey) {
      case 'demographics':
        return context.l10n.questionBankCategoryDemographics;
      case 'mental_health':
        return context.l10n.questionBankCategoryMentalHealth;
      case 'physical_health':
        return context.l10n.questionBankCategoryPhysicalHealth;
      case 'lifestyle':
        return context.l10n.questionBankCategoryLifestyle;
      case 'symptoms':
        return context.l10n.questionBankCategorySymptoms;
      default:
        // Fallback: capitalize and replace underscores
        return categoryKey
            .split('_')
            .map(
              (w) =>
                  w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
            )
            .join(' ');
    }
  }

  bool _hasActiveFilters(QuestionFilters filters) {
    return filters.responseType != null ||
        filters.category != null ||
        filters.searchQuery.isNotEmpty;
  }

  Widget _buildActiveFiltersChips(QuestionFilters filters) {
    return Builder(
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: _buildAlignedContent(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  context.l10n.questionBankFiltersLabel,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (filters.searchQuery.isNotEmpty)
                        Chip(
                          label: Text(
                            context.l10n.questionBankSearchLabel(
                              filters.searchQuery,
                            ),
                          ),
                          onDeleted: () => ref
                              .read(questionFiltersProvider.notifier)
                              .clearFilter('searchQuery'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        ),
                      if (filters.responseType != null)
                        Chip(
                          label: Text(
                            context.l10n.questionBankTypeLabel(
                              localizedResponseTypeLabels(
                                    context.l10n,
                                  )[filters.responseType] ??
                                  filters.responseType!,
                            ),
                          ),
                          onDeleted: () => ref
                              .read(questionFiltersProvider.notifier)
                              .clearFilter('responseType'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        ),
                      if (filters.category != null)
                        Chip(
                          label: Text(
                            context.l10n.questionBankCategoryLabel(
                              filters.category!,
                            ),
                          ),
                          onDeleted: () => ref
                              .read(questionFiltersProvider.notifier)
                              .clearFilter('category'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        ),
                    ],
                  ),
                ),
                AppTextButton(
                  label: context.l10n.questionBankClearAll,
                  onPressed: _clearFilters,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionsList(List<Question> questions, Set<int> selectedIds) {
    final includeFooter = !ref.read(selectionModeProvider);

    if (includeFooter) {
      return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(questionsProvider);
        },
        child: AppFooterScrollView(
          padding: const EdgeInsets.only(top: 16),
          itemCount: questions.isEmpty ? 1 : questions.length,
          footer: Footer(onLinkTap: (route) => context.go(route)),
          itemBuilder: (context, index) {
            if (questions.isEmpty) {
              return _buildEmptyState();
            }

            final question = questions[index];
            final isSelected = selectedIds.contains(question.questionId);
            return _buildAlignedContent(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildQuestionCard(question, isSelected),
              ),
            );
          },
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(questionsProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: questions.isEmpty ? 1 : questions.length,
        itemBuilder: (context, index) {
          if (questions.isEmpty) {
            return _buildEmptyState();
          }

          final question = questions[index];
          final isSelected = selectedIds.contains(question.questionId);
          return _buildAlignedContent(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildQuestionCard(question, isSelected),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(Question question, bool isSelected) {
    final isSelectionMode = ref.watch(selectionModeProvider);

    return QuestionBankCard(
      question: question,
      isSelected: isSelected,
      selectionMode: isSelectionMode,
      onTap: () {
        // View question details - open in edit mode for now
        QuestionBankFormDialog.show(context, question: question);
      },
      onSelectionChanged: (_) {
        ref
            .read(selectedQuestionIdsProvider.notifier)
            .toggle(question.questionId);
      },
      onEdit: () {
        QuestionBankFormDialog.show(context, question: question);
      },
      onDuplicate: () async {
        // Duplicate question by creating new with same content
        final api = ref.read(questionApiProvider);
        try {
          await api.createQuestion(
            QuestionCreate(
              title: question.title != null ? '${question.title} (Copy)' : null,
              questionContent: question.questionContent,
              responseType: question.responseType,
              isRequired: question.isRequired,
              category: question.category,
              options: question.options
                  ?.map(
                    (o) => QuestionOptionCreate(
                      optionText: o.optionText,
                      displayOrder: o.displayOrder,
                    ),
                  )
                  .toList(),
            ),
          );
          ref.invalidate(questionsProvider);
          if (mounted) {
            AppToast.showSuccess(
              context,
              message: context.l10n.questionBankQuestionDuplicated,
            );
          }
        } catch (e) {
          if (mounted) {
            AppToast.showError(
              context,
              message: context.l10n.questionBankFailedToDuplicate(e.toString()),
            );
          }
        }
      },
      onDelete: () => _confirmDelete(question),
    );
  }

  Future<void> _confirmDelete(Question question) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmDialog.show(
      context,
      title: l10n.questionBankDeleteTitle,
      content: l10n.questionBankDeleteConfirm(
        question.title ?? question.questionContent,
      ),
      confirmLabel: l10n.commonDelete,
      isDangerous: true,
    );

    if (confirmed) {
      try {
        final api = ref.read(questionApiProvider);
        await api.deleteQuestion(question.questionId);
        ref.invalidate(questionsProvider);
        if (mounted) {
          AppToast.showSuccess(context, message: l10n.questionBankDeleted);
        }
      } catch (e) {
        if (mounted) {
          AppToast.showError(context, message: l10n.questionBankFailedToDelete(e.toString()));
        }
      }
    }
  }

  Widget _buildEmptyState() {
    final filters = ref.watch(questionFiltersProvider);
    final hasFilters = _hasActiveFilters(filters);

    return AppEmptyState(
      icon: hasFilters ? Icons.search_off : Icons.quiz_outlined,
      title: hasFilters
          ? context.l10n.questionBankNoMatchFilters
          : context.l10n.questionBankNoQuestions,
      action: hasFilters
          ? AppTextButton(label: context.l10n.questionBankClearFilters, onPressed: _clearFilters)
          : AppFilledButton(
              label: context.l10n.questionBankAddQuestion,
              onPressed: () => QuestionBankFormDialog.show(context),
            ),
    );
  }

  Widget _buildErrorState(Object error) {
    return AppEmptyState.error(
      title: context.l10n.questionBankFailedToLoad,
      subtitle: error.toString(),
      action: AppFilledButton(
        label: context.l10n.commonRetry,
        onPressed: () => ref.invalidate(questionsProvider),
      ),
    );
  }
}
