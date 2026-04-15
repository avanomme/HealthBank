// Created with the Assistance of Claude Code and ChatGPT
// frontend/lib/src/features/surveys/pages/survey_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/footer.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:frontend/src/features/templates/pages/template_list_page.dart';
import 'package:go_router/go_router.dart';
import '../state/survey_providers.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Survey list page for researcher survey management.
class SurveyListPage extends ConsumerStatefulWidget {
  const SurveyListPage({super.key});

  @override
  ConsumerState<SurveyListPage> createState() => _SurveyListPageState();
}

class _SurveyListPageState extends ConsumerState<SurveyListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(surveyFiltersProvider.notifier).setSearchQuery(query);
  }

  void _onFilterChanged(String? status) {
    ref.read(surveyFiltersProvider.notifier).setPublicationStatus(status);
  }

  void _clearFilters() {
    ref.read(surveyFiltersProvider.notifier).clearAll();
    _searchController.clear();
    setState(() {});
  }

  void _navigateToBuilder({int? surveyId}) {
    if (surveyId != null) {
      context.push('/surveys/$surveyId/edit');
    } else {
      context.push(AppRoutes.surveyBuilder);
    }
  }

  Future<void> _navigateToBuilderFromTemplate() async {
    final template = await Navigator.of(context).push<Template>(
      PageRouteBuilder<Template>(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            TemplateListPage(
          selectionMode: true,
          onTemplateSelected: (template) {
            Navigator.of(context).pop(template);
          },
        ),
      ),
    );

    if (!mounted || template == null) return;

    context.push('${AppRoutes.surveyBuilder}?templateId=${template.templateId}');
  }

  void _navigateToStatus(int surveyId) {
    context.push(AppRoutes.surveyStatusPath(surveyId));
  }

  @override
  Widget build(BuildContext context) {
    final surveysAsync = ref.watch(surveysProvider);
    final filters = ref.watch(surveyFiltersProvider);

    return ResearcherScaffold(
      currentRoute: AppRoutes.surveys,
      alignment: AppPageAlignment.regular,
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      showFooter: false,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'newSurveyFromTemplateFab',
            onPressed: _navigateToBuilderFromTemplate,
            icon: const Icon(Icons.description_outlined),
            label: Text(context.l10n.surveyBuilderStartFromTemplate),
            backgroundColor: AppTheme.secondary,
            foregroundColor: AppTheme.textContrast,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'newSurveyFab',
            onPressed: () => _navigateToBuilder(),
            icon: const Icon(Icons.add),
            label: Text(context.l10n.surveyListNewSurvey),
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.textContrast,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSearchAndFilters(filters),
          if (_hasActiveFilters(filters)) _buildActiveFiltersChips(filters),
          Expanded(
            child: surveysAsync.when(
              data: (surveys) => _buildSurveysList(surveys),
              loading: () => const AppLoadingIndicator(),
              error: (error, _) => _buildErrorState(error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlignedContent(Widget child) {
    return AppPageAlignedContent(child: child);
  }

  Widget _buildSearchAndFilters(SurveyFilters filters) {
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
              TextField(
                controller: _searchController,
                style: metrics.bodyStyle,
                decoration: appInputDecoration(
                  context,
                  labelText: context.l10n.commonSearch,
                  hintText: context.l10n.surveyListSearchPlaceholder,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          tooltip: context.l10n.tooltipClearSearch,
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (query) {
                  _onSearchChanged(query);
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      initialValue: filters.publicationStatus,
                      style: metrics.bodyStyle,
                      dropdownColor: context.appColors.surface,
                      decoration: appInputDecoration(
                        context,
                        labelText: context.l10n.surveyListStatus,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(context.l10n.surveyListAllSurveys),
                        ),
                        DropdownMenuItem(
                          value: 'draft',
                          child: Text(context.l10n.surveyListDrafts),
                        ),
                        DropdownMenuItem(
                          value: 'published',
                          child: Text(context.l10n.surveyListPublished),
                        ),
                        DropdownMenuItem(
                          value: 'closed',
                          child: Text(context.l10n.surveyListClosed),
                        ),
                      ],
                      onChanged: _onFilterChanged,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasActiveFilters(SurveyFilters filters) {
    return filters.publicationStatus != null || filters.searchQuery.isNotEmpty;
  }

  Widget _buildActiveFiltersChips(SurveyFilters filters) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildAlignedContent(
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < Breakpoints.tablet;

            final chips = Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (filters.searchQuery.isNotEmpty)
                  Chip(
                    label: Text(
                      context.l10n.uiSearchLabel(filters.searchQuery),
                    ),
                    onDeleted: () => ref
                        .read(surveyFiltersProvider.notifier)
                        .clearFilter('searchQuery'),
                    deleteIcon: const Icon(Icons.close, size: 18),
                  ),
                if (filters.publicationStatus != null)
                  Chip(
                    label: Text(
                      context.l10n.surveyListStatusLabel(
                        _formatStatus(filters.publicationStatus!),
                      ),
                    ),
                    onDeleted: () => ref
                        .read(surveyFiltersProvider.notifier)
                        .clearFilter('publicationStatus'),
                    deleteIcon: const Icon(Icons.close, size: 18),
                  ),
              ],
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isCompact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.surveyListFiltersLabel,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        chips,
                        Align(
                          alignment: Alignment.centerRight,
                          child: AppTextButton(
                            label: context.l10n.surveyListClearAll,
                            onPressed: _clearFilters,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Text(
                          context.l10n.surveyListFiltersLabel,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: chips),
                        AppTextButton(
                          label: context.l10n.surveyListClearAll,
                          onPressed: _clearFilters,
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'draft':
        return context.l10n.surveyStatusDraft;
      case 'published':
        return context.l10n.surveyStatusPublished;
      case 'closed':
        return context.l10n.surveyStatusClosed;
      default:
        return status;
    }
  }

  Widget _buildSurveysList(List<Survey> surveys) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(surveysProvider);
      },
      child: AppFooterScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 16),
        itemCount: surveys.isEmpty ? 1 : surveys.length,
        footer: Footer(onLinkTap: (route) => context.go(route)),
        itemBuilder: (context, index) {
          if (surveys.isEmpty) {
            return _buildEmptyState();
          }

          final survey = surveys[index];
          return _buildAlignedContent(
            Padding(
              padding: EdgeInsets.fromLTRB(16, index == 0 ? 0 : 0, 16, 12),
              child: _buildSurveyCard(survey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSurveyCard(Survey survey) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _navigateToStatus(survey.surveyId),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          survey.title,
                          style: AppTheme.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        if (survey.description != null &&
                            survey.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              survey.description!,
                              style: AppTheme.captions.copyWith(
                                color: context.appColors.textMuted,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusBadge(survey.publicationStatus),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoItem(
                    icon: Icons.quiz_outlined,
                    label: context.l10n.surveyListQuestionCount(
                      survey.questionCount ?? survey.questions?.length ?? 0,
                    ),
                  ),
                  if (survey.startDate != null || survey.endDate != null)
                    _buildInfoItem(
                      icon: Icons.calendar_today,
                      label: _formatDateRange(survey.startDate, survey.endDate),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: context.appColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTheme.captions.copyWith(color: context.appColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'draft':
        color = context.appColors.textMuted;
        label = context.l10n.surveyStatusDraft;
        break;
      case 'published':
        color = AppTheme.secondary;
        label = context.l10n.surveyStatusPublished;
        break;
      case 'closed':
        color = AppTheme.error;
        label = context.l10n.surveyStatusClosed;
        break;
      default:
        color = context.appColors.textMuted;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTheme.captions.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null && end == null) return '';

    String formatDate(DateTime d) => '${d.month}/${d.day}/${d.year}';

    if (start != null && end != null) {
      return '${formatDate(start)} - ${formatDate(end)}';
    } else if (start != null) {
      return context.l10n.surveyListDateFrom(formatDate(start));
    } else {
      return context.l10n.surveyListDateUntil(formatDate(end!));
    }
  }

  Widget _buildEmptyState() {
    final filters = ref.watch(surveyFiltersProvider);
    final hasFilters = _hasActiveFilters(filters);

    return AppEmptyState(
      icon: hasFilters ? Icons.search_off : Icons.assignment_outlined,
      title: hasFilters
          ? context.l10n.surveyListNoMatchFilters
          : context.l10n.surveyListNoSurveys,
      action: hasFilters
          ? AppTextButton(
              label: context.l10n.uiClearFilters,
              onPressed: _clearFilters,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppFilledButton(
                  label: context.l10n.surveyListCreateSurvey,
                  onPressed: () => _navigateToBuilder(),
                ),
                const SizedBox(height: 8),
                AppOutlinedButton(
                  label: context.l10n.surveyBuilderStartFromTemplate,
                  onPressed: _navigateToBuilderFromTemplate,
                ),
              ],
            ),
    );
  }

  Widget _buildErrorState(Object error) {
    return AppEmptyState.error(
      title: context.l10n.surveyListFailedToLoad,
      subtitle: error.toString(),
      action: AppFilledButton(
        label: context.l10n.commonRetry,
        onPressed: () => ref.invalidate(surveysProvider),
      ),
    );
  }
}
