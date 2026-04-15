// Created with the Assistance of Claude Code
// frontend/lib/src/features/templates/pages/template_list_page.dart
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
import 'package:frontend/src/config/go_router.dart' show AppRoutes;
import '../state/template_providers.dart';
import '../widgets/template_card.dart';
import '../widgets/template_preview_dialog.dart';
import 'template_builder_page.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Template List Page
///
/// Displays a searchable, filterable list of survey templates.
/// Supports selection mode for using templates to create surveys.
class TemplateListPage extends ConsumerStatefulWidget {
  const TemplateListPage({
    super.key,
    this.selectionMode = false,
    this.onTemplateSelected,
  });

  /// Whether the page is in selection mode (for creating surveys from templates)
  final bool selectionMode;

  /// Callback when a template is selected (selection mode only)
  final void Function(Template)? onTemplateSelected;

  @override
  ConsumerState<TemplateListPage> createState() => _TemplateListPageState();
}

class _TemplateListPageState extends ConsumerState<TemplateListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set selection mode from widget prop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(templateSelectionModeProvider.notifier).state =
          widget.selectionMode;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(templateFiltersProvider.notifier).setSearchQuery(query);
  }

  void _onFilterChanged(String filterType, bool? value) {
    if (filterType == 'isPublic') {
      ref.read(templateFiltersProvider.notifier).setIsPublic(value);
    }
  }

  void _clearFilters() {
    ref.read(templateFiltersProvider.notifier).clearAll();
    _searchController.clear();
  }

  Future<void> _navigateToBuilder({int? templateId}) async {
    final result = await Navigator.push<Template>(
      context,
      PageRouteBuilder<Template>(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            TemplateBuilderPage(templateId: templateId),
      ),
    );

    if (result != null) {
      ref.invalidate(templatesProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(templatesProvider);
    final filters = ref.watch(templateFiltersProvider);
    final isSelectionMode = ref.watch(templateSelectionModeProvider);

    // In selection mode, use a simple Scaffold with back button
    if (isSelectionMode) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.templateListSelectTemplate)),
        body: Column(
          children: [
            _buildSearchAndFilters(filters),
            if (_hasActiveFilters(filters)) _buildActiveFiltersChips(filters),
            Expanded(
              child: templatesAsync.when(
                data: (templates) => _buildTemplatesList(templates),
                loading: () => const AppLoadingIndicator(),
                error: (error, stack) => _buildErrorState(error),
              ),
            ),
          ],
        ),
      );
    }

    return ResearcherScaffold(
      currentRoute: '/templates',
      alignment: AppPageAlignment.regular,
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToBuilder(),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.templateListNewTemplate),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textContrast,
      ),
      child: Column(
        children: [
          // Search and filters
          _buildSearchAndFilters(filters),

          // Active filters chips
          if (_hasActiveFilters(filters)) _buildActiveFiltersChips(filters),

          // Templates list
          Expanded(
            child: templatesAsync.when(
              data: (templates) => _buildTemplatesList(templates),
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

  Widget _buildSearchAndFilters(TemplateFilters filters) {
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
                    hintText: context.l10n.templateListSearchPlaceholder,
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

                // Filter dropdown
                Row(
                  children: [
                    // Visibility filter
                    Expanded(
                      child: DropdownButtonFormField<bool?>(
                        initialValue: filters.isPublic,
                        style: metrics.bodyStyle,
                        dropdownColor: context.appColors.surface,
                        decoration: appInputDecoration(
                          context,
                          labelText: context.l10n.templateListVisibility,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(context.l10n.templateListAllTemplates),
                          ),
                          DropdownMenuItem(
                            value: true,
                            child: Text(context.l10n.templateListPublic),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text(context.l10n.templateListPrivate),
                          ),
                        ],
                        onChanged: (value) =>
                            _onFilterChanged('isPublic', value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      },
    );
  }

  bool _hasActiveFilters(TemplateFilters filters) {
    return filters.isPublic != null || filters.searchQuery.isNotEmpty;
  }

  Widget _buildActiveFiltersChips(TemplateFilters filters) {
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
                  context.l10n.templateListFiltersLabel,
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
                              .read(templateFiltersProvider.notifier)
                              .clearFilter('searchQuery'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        ),
                      if (filters.isPublic != null)
                        Chip(
                          label: Text(
                            context.l10n.templateListVisibilityLabel(
                              filters.isPublic!
                                  ? context.l10n.templateListPublic
                                  : context.l10n.templateListPrivate,
                            ),
                          ),
                          onDeleted: () => ref
                              .read(templateFiltersProvider.notifier)
                              .clearFilter('isPublic'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        ),
                    ],
                  ),
                ),
                AppTextButton(
                  label: context.l10n.templateListClearAll,
                  onPressed: _clearFilters,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplatesList(List<Template> templates) {
    final includeFooter = !ref.read(templateSelectionModeProvider);

    if (includeFooter) {
      return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(templatesProvider);
        },
        child: AppFooterScrollView(
          padding: const EdgeInsets.only(top: 16),
          itemCount: templates.isEmpty ? 1 : templates.length,
          footer: Footer(onLinkTap: (route) => context.go(route)),
          itemBuilder: (context, index) {
            if (templates.isEmpty) {
              return _buildEmptyState();
            }

            final template = templates[index];
            return _buildAlignedContent(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildTemplateCard(template),
              ),
            );
          },
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(templatesProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: templates.isEmpty ? 1 : templates.length,
        itemBuilder: (context, index) {
          if (templates.isEmpty) {
            return _buildEmptyState();
          }

          final template = templates[index];
          return _buildAlignedContent(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildTemplateCard(template),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTemplateCard(Template template) {
    final isSelectionMode = ref.watch(templateSelectionModeProvider);

    return TemplateCard(
      template: template,
      selectionMode: isSelectionMode,
      onTap: () {
        if (isSelectionMode) {
          widget.onTemplateSelected?.call(template);
        } else {
          _navigateToBuilder(templateId: template.templateId);
        }
      },
      onEdit: () => _navigateToBuilder(templateId: template.templateId),
      onDuplicate: () => _duplicateTemplate(template),
      onCreateSurvey: () {
        context.go(
          '${AppRoutes.surveyBuilder}?templateId=${template.templateId}',
        );
      },
      onPreview: () => _showPreview(template),
      onDelete: () => _confirmDelete(template),
    );
  }

  Future<void> _showPreview(Template template) async {
    // Fetch full template with questions if not already loaded
    Template templateWithQuestions = template;
    if (template.questions == null) {
      try {
        final api = ref.read(templateApiProvider);
        templateWithQuestions = await api.getTemplate(template.templateId);
      } catch (e) {
        if (mounted) {
          AppToast.showError(
            context,
            message: context.l10n.templateListFailedToLoadTemplate(
              e.toString(),
            ),
          );
        }
        return;
      }
    }

    if (mounted) {
      await showTemplatePreview(context, templateWithQuestions);
    }
  }

  Future<void> _duplicateTemplate(Template template) async {
    try {
      final api = ref.read(templateApiProvider);
      await api.duplicateTemplate(template.templateId);
      ref.invalidate(templatesProvider);
      if (mounted) {
        AppToast.showSuccess(
          context,
          message: context.l10n.templateListDuplicated,
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(
          context,
          message: context.l10n.templateListFailedToDuplicate(e.toString()),
        );
      }
    }
  }

  Future<void> _confirmDelete(Template template) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.templateListDeleteTitle,
      content: context.l10n.templateListDeleteConfirm(template.title),
      confirmLabel: context.l10n.commonDelete,
      cancelLabel: context.l10n.commonCancel,
      isDangerous: true,
    );

    if (confirmed) {
      try {
        final api = ref.read(templateApiProvider);
        await api.deleteTemplate(template.templateId);
        ref.invalidate(templatesProvider);
        if (mounted) {
          AppToast.showSuccess(
            context,
            message: context.l10n.templateListDeleted,
          );
        }
      } catch (e) {
        if (mounted) {
          AppToast.showError(
            context,
            message: context.l10n.templateListFailedToDelete(e.toString()),
          );
        }
      }
    }
  }

  Widget _buildEmptyState() {
    final filters = ref.watch(templateFiltersProvider);
    final hasFilters = _hasActiveFilters(filters);

    return AppEmptyState(
      icon: hasFilters ? Icons.search_off : Icons.description_outlined,
      title: hasFilters
          ? context.l10n.templateListNoMatchFilters
          : context.l10n.templateListNoTemplates,
      action: hasFilters
          ? AppTextButton(
              label: context.l10n.questionBankClearFilters,
              onPressed: _clearFilters,
            )
          : AppFilledButton(
              label: context.l10n.templateListCreateTemplate,
              onPressed: () => _navigateToBuilder(),
            ),
    );
  }

  Widget _buildErrorState(Object error) {
    return AppEmptyState.error(
      title: context.l10n.templateListFailedToLoad,
      subtitle: error.toString(),
      action: AppFilledButton(
        label: context.l10n.commonRetry,
        onPressed: () => ref.invalidate(templatesProvider),
      ),
    );
  }
}
