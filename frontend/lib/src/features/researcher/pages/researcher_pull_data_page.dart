// Created with the Assistance of Claude Code
// frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart
/// Research data view page — displays individual anonymized survey responses
/// and aggregate statistical analysis with charts.
///
/// Two modes:
/// 1. By Survey — select one survey, view overview stats, data table,
///    analysis charts, and export CSV.
/// 2. Data Bank — select multiple surveys, optional date range, view
///    merged data table and export CSV.
///
/// Enforces k-anonymity (minimum 5 respondents) via the backend API.
library;

import 'csv_download_stub.dart'
    if (dart.library.js_interop) 'csv_download_web.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/research.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';
import 'package:frontend/src/core/widgets/data_display/survey_chart_switcher.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:frontend/src/features/researcher/pages/researcher_health_tracking_page.dart';
import 'package:frontend/src/features/researcher/state/research_providers.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

class ResearcherPullDataPage extends ConsumerStatefulWidget {
  const ResearcherPullDataPage({super.key, this.initialSurveyId});

  /// Optional pre-selected survey ID (used in tests).
  final int? initialSurveyId;

  @override
  ConsumerState<ResearcherPullDataPage> createState() =>
      _ResearcherPullDataPageState();
}

enum _ResearchMode { singleSurvey, dataBank, healthTracking }

class _ResearcherPullDataPageState extends ConsumerState<ResearcherPullDataPage>
    with TickerProviderStateMixin {
  int? _selectedSurveyId;
  bool _exporting = false;
  _ResearchMode _mode = _ResearchMode.singleSurvey;
  late TabController _tabController;
  late TabController _dataBankTabController;
  final ScrollController _tableScrollController = ScrollController();
  final ScrollController _crossTableScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedSurveyId = widget.initialSurveyId;
    _tabController = TabController(length: 2, vsync: this);
    _dataBankTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dataBankTabController.dispose();
    _tableScrollController.dispose();
    _crossTableScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final surveysAsync = ref.watch(researchSurveysProvider);

    return ResearcherScaffold(
      currentRoute: '/researcher/data',
      alignment: AppPageAlignment.compact,
      showFooter: false,
      child: switch (_mode) {
        _ResearchMode.healthTracking => _buildHealthTrackingMode(
          l10n,
          surveysAsync,
        ),
        _ResearchMode.dataBank => _buildCrossSurveyNestedScroll(
          l10n,
          surveysAsync,
        ),
        _ResearchMode.singleSurvey =>
          _selectedSurveyId != null
              ? _buildSurveyNestedScroll(l10n, surveysAsync)
              : _buildNoSurveySelected(l10n, surveysAsync),
      },
    );
  }

  /// Top bar shared by all modes: title + toggle + controls.
  List<Widget> _buildTopBarSlivers(
    dynamic l10n,
    AsyncValue<List<ResearchSurvey>> surveysAsync,
  ) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: AppOverflowSafeArea(
            child: Row(
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.researchDataTitle,
                    style: AppTheme.heading3.copyWith(
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                SegmentedButton<_ResearchMode>(
                  segments: [
                    ButtonSegment(
                      value: _ResearchMode.singleSurvey,
                      label: Text(l10n.researchModeSingleSurvey),
                      icon: const Icon(Icons.article_outlined, size: 18),
                    ),
                    ButtonSegment(
                      value: _ResearchMode.dataBank,
                      label: Text(l10n.researchModeCrossSurvey),
                      icon: const Icon(Icons.storage_outlined, size: 18),
                    ),
                    ButtonSegment(
                      value: _ResearchMode.healthTracking,
                      label: Text(l10n.researchModeHealthTracking),
                      icon: const Icon(Icons.monitor_heart_outlined, size: 18),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (selected) {
                    setState(() => _mode = selected.first);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      if (_mode != _ResearchMode.healthTracking)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: _mode == _ResearchMode.dataBank
                ? _buildCrossSurveyControlsRow(l10n, surveysAsync)
                : _buildControlsRow(l10n, surveysAsync),
          ),
        ),
    ];
  }

  /// Health Tracking mode — embeds analytics content in a plain scroll view.
  Widget _buildHealthTrackingMode(
    dynamic l10n,
    AsyncValue<List<ResearchSurvey>> surveysAsync,
  ) {
    return CustomScrollView(
      slivers: [
        ..._buildTopBarSlivers(l10n, surveysAsync),
        const SliverToBoxAdapter(child: ResearcherHealthTrackingContent()),
      ],
    );
  }

  /// Fallback when no survey is selected (single-survey mode).
  Widget _buildNoSurveySelected(
    dynamic l10n,
    AsyncValue<List<ResearchSurvey>> surveysAsync,
  ) {
    return CustomScrollView(
      slivers: [
        ..._buildTopBarSlivers(l10n, surveysAsync),
        SliverFillRemaining(
          child: Center(
            child: Text(
              l10n.researchSelectSurvey,
              style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            ),
          ),
        ),
      ],
    );
  }

  /// Single-survey mode: NestedScrollView with pinned TabBar.
  Widget _buildSurveyNestedScroll(
    dynamic l10n,
    AsyncValue<List<ResearchSurvey>> surveysAsync,
  ) {
    final overviewAsync = ref.watch(surveyOverviewProvider(_selectedSurveyId!));

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        ..._buildTopBarSlivers(l10n, surveysAsync),
        // Overview stat cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 14),
            child: overviewAsync.when(
              data: (overview) => _buildOverviewCards(l10n, overview),
              loading: () => const AppLoadingIndicator(),
              error: (e, _) => Text(
                context.l10n.commonErrorWithDetail(e.toString()),
                style: AppTheme.body,
              ),
            ),
          ),
        ),
        // Pinned TabBar
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: l10n.researchTabDataTable),
                  Tab(text: l10n.researchTabAnalysis),
                ],
                labelColor: AppTheme.primary,
                unselectedLabelColor: context.appColors.textMuted,
                indicatorColor: AppTheme.primary,
              ),
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [_buildDataTableTab(l10n), _buildAnalysisTab(l10n)],
      ),
    );
  }

  /// Data Bank mode: NestedScrollView with pinned TabBar.
  Widget _buildCrossSurveyNestedScroll(
    dynamic l10n,
    AsyncValue<List<ResearchSurvey>> surveysAsync,
  ) {
    final filters = ref.watch(crossSurveyFiltersProvider);

    // Empty state — no fields selected
    if (filters.selectedQuestionIds.isEmpty) {
      return CustomScrollView(
        slivers: [
          ..._buildTopBarSlivers(l10n, surveysAsync),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.storage_outlined,
                    size: 48,
                    color: context.appColors.textMuted.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.researchCrossNoSurveysSelected,
                    style: AppTheme.body.copyWith(
                      color: context.appColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        ..._buildTopBarSlivers(l10n, surveysAsync),
        // Overview stat cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 14),
            child: _buildCrossSurveyOverviewCards(l10n),
          ),
        ),
        // Pinned TabBar
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              TabBar(
                controller: _dataBankTabController,
                tabs: [
                  Tab(text: l10n.researchTabDataTable),
                  Tab(text: l10n.researchDataBankAnalysis),
                ],
                labelColor: AppTheme.primary,
                unselectedLabelColor: context.appColors.textMuted,
                indicatorColor: AppTheme.primary,
              ),
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _dataBankTabController,
        children: [
          _buildCrossSurveyDataTable(l10n),
          _buildDataBankAnalysisTab(l10n),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // SINGLE-SURVEY MODE (unchanged)
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildControlsRow(
    dynamic l10n,
    AsyncValue<List<ResearchSurvey>> surveysAsync,
  ) {
    final filters = ref.watch(researchFiltersProvider);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Survey dropdown
        SizedBox(
          width: 300,
          child: surveysAsync.when(
            data: (surveys) {
              return DropdownMenu<int>(
                key: ValueKey('survey-menu:${surveys.length}'),
                initialSelection: _selectedSurveyId,
                enableFilter: true,
                enableSearch: true,
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                label: Text(l10n.researchSelectSurvey),
                leadingIcon: const Icon(Icons.search, size: 20),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                menuStyle: const MenuStyle(
                  maximumSize: WidgetStatePropertyAll(Size(300, 300)),
                ),
                dropdownMenuEntries: surveys
                    .map(
                      (s) =>
                          DropdownMenuEntry(value: s.surveyId, label: s.title),
                    )
                    .toList(),
                onSelected: (id) {
                  setState(() => _selectedSurveyId = id);
                },
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text(l10n.researchNoSurveys, style: AppTheme.body),
          ),
        ),
        // Category filter
        if (_selectedSurveyId != null)
          SizedBox(width: 200, child: _buildCategoryFilter(l10n)),
        // Response type filter
        if (_selectedSurveyId != null)
          SizedBox(width: 200, child: _buildResponseTypeFilter(l10n)),
        // Export CSV
        if (_selectedSurveyId != null)
          AppFilledButton(
            label: _exporting ? '...' : l10n.researchExportCsv,
            onPressed: _exporting ? null : _exportCsv,
          ),
        // Clear filters
        if (filters.category != null || filters.responseType != null)
          AppTextButton(
            label: l10n.uiClearFilters,
            onPressed: () {
              ref.read(researchFiltersProvider.notifier).clearAll();
            },
          ),
      ],
    );
  }

  Widget _buildCategoryFilter(dynamic l10n) {
    final filters = ref.watch(researchFiltersProvider);
    final responsesAsync = ref.watch(
      individualResponsesProvider(_selectedSurveyId!),
    );

    final categories = responsesAsync.maybeWhen(
      data: (data) {
        final unique = <String>{};
        for (final q in data.questions) {
          final c = q.category?.trim();
          if (c != null && c.isNotEmpty) unique.add(c);
        }
        final list = unique.toList()..sort();
        return list;
      },
      orElse: () => const <String>[],
    );

    final currentCategory = categories.contains(filters.category)
        ? filters.category
        : null;

    return DropdownButtonFormField<String>(
      key: ValueKey(
        'single-cat:${_selectedSurveyId ?? 'none'}:${currentCategory ?? 'none'}:${categories.join('|')}',
      ),
      initialValue: currentCategory,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.researchFilterCategory,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(l10n.researchAllCategories),
        ),
        ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
      ],
      onChanged: (val) {
        ref.read(researchFiltersProvider.notifier).setCategory(val);
      },
    );
  }

  Widget _buildResponseTypeFilter(dynamic l10n) {
    final filters = ref.watch(researchFiltersProvider);
    const types = [
      'number',
      'yesno',
      'openended',
      'single_choice',
      'multi_choice',
      'scale',
    ];
    final currentType = types.contains(filters.responseType)
        ? filters.responseType
        : null;

    return DropdownButtonFormField<String>(
      key: ValueKey('single-type:${currentType ?? 'none'}'),
      initialValue: currentType,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.researchFilterResponseType,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(l10n.researchAllTypes),
        ),
        ...types.map((t) => DropdownMenuItem(value: t, child: Text(t))),
      ],
      onChanged: (val) {
        ref.read(researchFiltersProvider.notifier).setResponseType(val);
      },
    );
  }

  Widget _buildOverviewCards(dynamic l10n, SurveyOverview overview) {
    if (overview.suppressed) {
      return _buildSuppressedMessage(l10n, overview.minResponses);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          AppStatCard(
            label: l10n.researchRespondents,
            value: '${overview.respondentCount}',
            icon: Icons.people_outline,
            color: AppTheme.primary,
          ),
          AppStatCard(
            label: l10n.researchCompletionRate,
            value: '${overview.completionRate.toStringAsFixed(1)}%',
            icon: Icons.check_circle_outline,
            color: AppTheme.success,
          ),
          AppStatCard(
            label: l10n.researchQuestions,
            value: '${overview.questionCount}',
            icon: Icons.quiz_outlined,
            color: AppTheme.info,
          ),
        ];

        if (constraints.maxWidth >= 600) {
          return Row(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                Expanded(child: cards[i]),
                if (i != cards.length - 1) const SizedBox(width: 16),
              ],
            ],
          );
        }

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [for (final c in cards) SizedBox(width: 280, child: c)],
        );
      },
    );
  }

  Widget _buildSuppressedMessage(dynamic l10n, [int minResponses = 5]) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.caution.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.caution),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.caution,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.researchSuppressed(minResponses),
              style: AppTheme.body,
            ),
          ),
        ],
      ),
    );
  }

  // ── Data Table tab ──────────────────────────────────────────────────

  Widget _buildDataTableTab(dynamic l10n) {
    final responsesAsync = ref.watch(
      individualResponsesProvider(_selectedSurveyId!),
    );
    final minResponses = ref
        .watch(surveyOverviewProvider(_selectedSurveyId!))
        .maybeWhen(data: (o) => o.minResponses, orElse: () => 5);

    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey('dataTableTab'),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: responsesAsync.when(
                data: (data) => data.suppressed
                    ? Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: _buildSuppressedMessage(l10n, minResponses),
                      )
                    : data.rows.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          l10n.researchNoData,
                          style: AppTheme.body.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _buildDataTable(l10n, data),
                      ),
                loading: () => const AppLoadingIndicator(),
                error: (e, _) => Text(
                  context.l10n.commonErrorWithDetail(e.toString()),
                  style: AppTheme.body,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataTable(dynamic l10n, IndividualResponseData data) {
    final questions = data.questions;
    final rows = data.rows;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Scrollbar(
          controller: _tableScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _tableScrollController,
            scrollDirection: Axis.horizontal,
            child: Theme(
              data: Theme.of(context).copyWith(
                dataTableTheme: DataTableThemeData(
                  headingRowColor: WidgetStatePropertyAll(
                    context.appColors.surfaceSubtle,
                  ),
                  headingTextStyle: AppTheme.body.copyWith(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: AppTheme.body.copyWith(
                    color: context.appColors.textPrimary,
                  ),
                  dividerThickness: 1,
                ),
              ),
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'ID',
                      style: AppTheme.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                  ),
                  ...questions.map(
                    (q) => DataColumn(
                      label: SizedBox(
                        width: 180,
                        child: Tooltip(
                          message: q.questionContent,
                          child: Text(
                            q.questionContent,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppTheme.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.appColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                rows: rows
                    .map(
                      (row) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              row.anonymousId,
                              style: AppTheme.captions.copyWith(
                                color: context.appColors.textMuted,
                              ),
                            ),
                          ),
                          ...questions.map((q) {
                            final value =
                                row.responses[q.questionId.toString()] ?? '';
                            return DataCell(
                              SizedBox(
                                width: 180,
                                child: Text(
                                  value,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.body.copyWith(
                                    color: context.appColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Analysis tab ────────────────────────────────────────────────────
  // Advanced statistical models (regression, correlation, trend, box plots,
  // percentiles, distribution fit, plotly visualisations) are handled by the
  // dedicated Researcher Analysis page — see Task #20.

  Widget _buildAnalysisTab(dynamic l10n) {
    final aggregatesAsync = ref.watch(
      surveyAggregatesProvider(_selectedSurveyId!),
    );
    final minResponses = ref
        .watch(surveyOverviewProvider(_selectedSurveyId!))
        .maybeWhen(data: (o) => o.minResponses, orElse: () => 5);

    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey('analysisTab'),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: aggregatesAsync.when(
                data: (agg) =>
                    _buildAggregateGrid(l10n, agg.aggregates, minResponses),
                loading: () => const AppLoadingIndicator(),
                error: (e, _) => Text(
                  context.l10n.commonErrorWithDetail(e.toString()),
                  style: AppTheme.body,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Responsive grid for aggregate question charts.
  /// Shows 2 columns on wide screens (>=760px), single column on mobile.
  Widget _buildAggregateGrid(
    dynamic l10n,
    List<QuestionAggregate> items, [
    int minResponses = 5,
  ]) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            l10n.researchNoData,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useGrid = constraints.maxWidth >= 760;

          if (!useGrid) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final q in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildQuestionAnalysis(l10n, q, minResponses),
                  ),
              ],
            );
          }

          // 2-column grid on wide screens
          final rows = <Widget>[];
          for (var i = 0; i < items.length; i += 2) {
            final left = Expanded(
              child: _buildQuestionAnalysis(l10n, items[i], minResponses),
            );
            final right = i + 1 < items.length
                ? Expanded(
                    child: _buildQuestionAnalysis(
                      l10n,
                      items[i + 1],
                      minResponses,
                    ),
                  )
                : const Expanded(child: SizedBox.shrink());

            rows.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [left, const SizedBox(width: 24), right],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rows,
          );
        },
      ),
    );
  }

  Widget _buildQuestionAnalysis(
    dynamic l10n,
    QuestionAggregate q, [
    int minResponses = 5,
  ]) {
    if (q.suppressed) {
      return _buildSuppressedMessage(l10n, minResponses);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            q.questionContent,
            style: AppTheme.heading5.copyWith(
              color: context.appColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.researchResponses(q.responseCount)} · ${q.responseType}',
            style: AppTheme.captions.copyWith(
              color: context.appColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnalysisByType(l10n, q, minResponses),
        ],
      ),
    );
  }

  Widget _buildAnalysisByType(
    dynamic l10n,
    QuestionAggregate q, [
    int minResponses = 5,
  ]) {
    final data = q.data ?? {};

    switch (q.responseType) {
      case 'number':
      case 'scale':
        return _buildNumberScaleAnalysis(l10n, data);
      case 'yesno':
        return _buildYesNoAnalysis(l10n, data);
      case 'single_choice':
      case 'multi_choice':
        return _buildChoiceAnalysis(l10n, data, minResponses);
      case 'openended':
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.info.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.info.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const ExcludeSemantics(
                child: Icon(Icons.info_outline, color: AppTheme.info, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.researchOpenEndedNote,
                  style: AppTheme.body.copyWith(color: AppTheme.info),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNumberScaleAnalysis(dynamic l10n, Map<String, dynamic> data) {
    final mean = (data['mean'] as num?)?.toDouble();
    final median = (data['median'] as num?)?.toDouble();
    final stdDev = (data['std_dev'] as num?)?.toDouble();
    final min = (data['min'] as num?)?.toDouble();
    final max = (data['max'] as num?)?.toDouble();
    final histogram = data['histogram'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stat cards row
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (mean != null)
              SizedBox(
                width: 160,
                child: AppStatCard(
                  label: l10n.researchMean,
                  value: mean.toStringAsFixed(2),
                  icon: Icons.analytics_outlined,
                  color: AppTheme.primary,
                ),
              ),
            if (median != null)
              SizedBox(
                width: 160,
                child: AppStatCard(
                  label: l10n.researchMedian,
                  value: median.toStringAsFixed(2),
                  icon: Icons.linear_scale,
                  color: AppTheme.info,
                ),
              ),
            if (stdDev != null)
              SizedBox(
                width: 160,
                child: AppStatCard(
                  label: l10n.researchStdDev,
                  value: stdDev.toStringAsFixed(2),
                  icon: Icons.show_chart,
                  color: AppTheme.secondary,
                ),
              ),
          ],
        ),
        if (min != null && max != null) ...[
          const SizedBox(height: 12),
          Text(
            '${l10n.researchRange}: ${min.toStringAsFixed(2)} – ${max.toStringAsFixed(2)}',
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          ),
        ],
        if (histogram.isNotEmpty) ...[
          const SizedBox(height: 20),
          SurveyChartSwitcher(
            title: l10n.researchHistogram,
            defaultType: SurveyChartType.bar,
            data: {
              for (final bucket in histogram)
                (bucket['label'] as String? ?? ''):
                    (bucket['count'] as num?)?.toDouble() ?? 0,
            },
          ),
        ],
      ],
    );
  }

  Widget _buildYesNoAnalysis(dynamic l10n, Map<String, dynamic> data) {
    final yesPct = (data['yes_pct'] as num?)?.toDouble() ?? 0.0;
    final noPct = (data['no_pct'] as num?)?.toDouble() ?? 0.0;
    final yesCount = (data['yes_count'] as num?)?.toDouble() ?? 0.0;
    final noCount = (data['no_count'] as num?)?.toDouble() ?? 0.0;

    return SurveyChartSwitcher(
      title: l10n.researchDistribution,
      defaultType: SurveyChartType.pie,
      data: {
        '${l10n.researchYes} ($yesPct%)': yesCount,
        '${l10n.researchNo} ($noPct%)': noCount,
      },
      colors: const [AppTheme.success, AppTheme.error],
    );
  }

  Widget _buildChoiceAnalysis(
    dynamic l10n,
    Map<String, dynamic> data, [
    int minResponses = 5,
  ]) {
    final options = data['options'] as List<dynamic>? ?? [];

    final chartData = <String, double>{};
    for (final opt in options) {
      final label = opt['option'] as String? ?? '';
      final count = (opt['count'] as num?)?.toDouble() ?? 0.0;
      chartData[label] = count;
    }

    if (chartData.isEmpty) {
      return _buildSuppressedMessage(l10n, minResponses);
    }

    return SurveyChartSwitcher(
      title: l10n.researchOptionCounts,
      defaultType: SurveyChartType.bar,
      data: chartData,
    );
  }

  Future<void> _exportCsv() async {
    if (_selectedSurveyId == null) return;
    setState(() => _exporting = true);
    try {
      final csv = await ref.read(csvExportProvider(_selectedSurveyId!).future);
      downloadCsvFile(csv, 'survey_${_selectedSurveyId}_responses.csv');
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, message: 'Export failed: $e');
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  // DATA BANK MODE
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildCrossSurveyControlsRow(
    dynamic l10n,
    AsyncValue<List<ResearchSurvey>> surveysAsync,
  ) {
    final filters = ref.watch(crossSurveyFiltersProvider);
    final hasFilters =
        filters.dateFrom != null ||
        filters.dateTo != null ||
        filters.category != null ||
        filters.responseType != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary action row: + Add Fields, optional survey filter chips,
        // export CSV
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // "+ Add Fields" button
            AppOutlinedButton(
              label: l10n.researchAddFields,
              onPressed: () => _showFieldPickerDialog(l10n),
              icon: Icons.add,
              foregroundColor: AppTheme.primary,
              borderColor: AppTheme.primary,
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Date range + category/type filters + export + clear
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Date from
            SizedBox(
              width: 160,
              child: TextFormField(
                key: ValueKey('cross-date-from-${filters.dateFrom ?? ''}'),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10n.researchCrossDateFrom,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  suffixIcon: filters.dateFrom != null
                      ? IconButton(
                          tooltip: context.l10n.tooltipClearFilter,
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => ref
                              .read(crossSurveyFiltersProvider.notifier)
                              .setDateFrom(null),
                        )
                      : const ExcludeSemantics(
                          child: Icon(Icons.calendar_today, size: 18),
                        ),
                ),
                initialValue: filters.dateFrom ?? '',
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(
                      const Duration(days: 30),
                    ),
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    ref
                        .read(crossSurveyFiltersProvider.notifier)
                        .setDateFrom(
                          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}',
                        );
                  }
                },
              ),
            ),
            // Date to
            SizedBox(
              width: 160,
              child: TextFormField(
                key: ValueKey('cross-date-to-${filters.dateTo ?? ''}'),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10n.researchCrossDateTo,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  suffixIcon: filters.dateTo != null
                      ? IconButton(
                          tooltip: context.l10n.tooltipClearFilter,
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => ref
                              .read(crossSurveyFiltersProvider.notifier)
                              .setDateTo(null),
                        )
                      : const ExcludeSemantics(
                          child: Icon(Icons.calendar_today, size: 18),
                        ),
                ),
                initialValue: filters.dateTo ?? '',
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    ref
                        .read(crossSurveyFiltersProvider.notifier)
                        .setDateTo(
                          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}',
                        );
                  }
                },
              ),
            ),
            // Category filter
            SizedBox(width: 200, child: _buildCrossSurveyCategoryFilter(l10n)),
            // Response type filter
            SizedBox(
              width: 200,
              child: _buildCrossSurveyResponseTypeFilter(l10n),
            ),
            // Export CSV
            AppFilledButton(
              label: _exporting ? '...' : l10n.researchExportCsv,
              onPressed: _exporting ? null : _exportCrossSurveyCsv,
            ),
            // Clear filters
            if (hasFilters)
              AppTextButton(
                label: l10n.uiClearFilters,
                onPressed: () {
                  ref.read(crossSurveyFiltersProvider.notifier).clearAll();
                },
              ),
          ],
        ),
        // Selected fields chips
        if (filters.selectedQuestionIds.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildSelectedFieldChips(l10n, filters),
        ],
      ],
    );
  }

  /// Chips showing currently selected data fields, each dismissible.
  Widget _buildSelectedFieldChips(dynamic l10n, CrossSurveyFilters filters) {
    final questionsAsync = ref.watch(availableQuestionsProvider);

    return questionsAsync.when(
      data: (questions) {
        // Build a lookup from question ID → question content
        final lookup = <int, CrossSurveyQuestion>{};
        for (final q in questions) {
          lookup[q.questionId] = q;
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 80),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  l10n.researchSelectedFields(
                    filters.selectedQuestionIds.length,
                  ),
                  style: AppTheme.captions.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
                ...filters.selectedQuestionIds.map((id) {
                  final q = lookup[id];
                  final label = q?.questionContent ?? 'Field #$id';
                  return Chip(
                    label: Text(label, style: const TextStyle(fontSize: 12)),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      ref
                          .read(crossSurveyFiltersProvider.notifier)
                          .toggleQuestion(id);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.08),
                    side: BorderSide(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                    ),
                  );
                }),
                AppTextButton(
                  label: l10n.commonClear,
                  onPressed: () {
                    ref
                        .read(crossSurveyFiltersProvider.notifier)
                        .clearQuestions();
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// Shows a dialog to pick data fields (questions) from the bank.
  Future<void> _showFieldPickerDialog(dynamic l10n) async {
    final questionsAsync = ref.read(availableQuestionsProvider);
    final questions = questionsAsync.valueOrNull ?? [];
    if (questions.isEmpty) {
      // Trigger a refresh and wait briefly
      ref.invalidate(availableQuestionsProvider);
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _FieldPickerDialog(l10n: l10n, ref: ref),
    );
  }

  Widget _buildCrossSurveyCategoryFilter(dynamic l10n) {
    final filters = ref.watch(crossSurveyFiltersProvider);
    const categories = [
      'demographics',
      'mental_health',
      'physical_health',
      'lifestyle',
      'symptoms',
    ];
    final currentCategory = categories.contains(filters.category)
        ? filters.category
        : null;

    return DropdownButtonFormField<String>(
      key: ValueKey('cross-cat:${currentCategory ?? 'none'}'),
      initialValue: currentCategory,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.researchFilterCategory,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(l10n.researchAllCategories),
        ),
        ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
      ],
      onChanged: (val) {
        ref.read(crossSurveyFiltersProvider.notifier).setCategory(val);
      },
    );
  }

  Widget _buildCrossSurveyResponseTypeFilter(dynamic l10n) {
    final filters = ref.watch(crossSurveyFiltersProvider);
    const types = [
      'number',
      'yesno',
      'openended',
      'single_choice',
      'multi_choice',
      'scale',
    ];
    final currentType = types.contains(filters.responseType)
        ? filters.responseType
        : null;

    return DropdownButtonFormField<String>(
      key: ValueKey('cross-type:${currentType ?? 'none'}'),
      initialValue: currentType,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.researchFilterResponseType,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(l10n.researchAllTypes),
        ),
        ...types.map((t) => DropdownMenuItem(value: t, child: Text(t))),
      ],
      onChanged: (val) {
        ref.read(crossSurveyFiltersProvider.notifier).setResponseType(val);
      },
    );
  }

  Widget _buildCrossSurveyOverviewCards(dynamic l10n) {
    final overviewAsync = ref.watch(crossSurveyOverviewProvider);

    return overviewAsync.when(
      data: (overview) {
        if (overview.suppressed) {
          return _buildSuppressedMessage(l10n, overview.minResponses);
        }

        return AppOverflowSafeArea(
          child: Row(
            children: [
              SizedBox(
                width: 220,
                child: AppStatCard(
                  label: l10n.researchCrossSurveysCount,
                  value: '${overview.surveys.length}',
                  icon: Icons.assignment_outlined,
                  color: AppTheme.secondary,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 220,
                child: AppStatCard(
                  label: l10n.researchCrossTotalRespondents,
                  value: '${overview.totalRespondentCount}',
                  icon: Icons.people_outline,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 220,
                child: AppStatCard(
                  label: l10n.researchCrossTotalQuestions,
                  value: '${overview.totalQuestionCount}',
                  icon: Icons.quiz_outlined,
                  color: AppTheme.info,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 220,
                child: AppStatCard(
                  label: l10n.researchCrossAvgCompletion,
                  value: '${overview.avgCompletionRate.toStringAsFixed(1)}%',
                  icon: Icons.check_circle_outline,
                  color: AppTheme.success,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const AppLoadingIndicator(),
      error: (e, _) => Text(
        context.l10n.commonErrorWithDetail(e.toString()),
        style: AppTheme.body,
      ),
    );
  }

  Widget _buildCrossSurveyDataTable(dynamic l10n) {
    final responsesAsync = ref.watch(crossSurveyResponsesProvider);
    final minResponses = ref
        .watch(crossSurveyOverviewProvider)
        .maybeWhen(data: (o) => o.minResponses, orElse: () => 5);

    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey('crossDataTableTab'),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: responsesAsync.when(
                data: (data) {
                  if (data.suppressed) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: _buildSuppressedMessage(l10n, minResponses),
                    );
                  }

                  final suppressedCount = data.suppressedSurveys.length;

                  if (data.rows.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        l10n.researchNoData,
                        style: AppTheme.body.copyWith(
                          color: context.appColors.textMuted,
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (suppressedCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.caution.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.caution.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: AppTheme.caution,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.researchCrossSuppressedSurveys(
                                    suppressedCount,
                                  ),
                                  style: AppTheme.captions.copyWith(
                                    color: AppTheme.caution,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      _buildCrossSurveyTable(l10n, data),
                    ],
                  );
                },
                loading: () => const AppLoadingIndicator(),
                error: (e, _) => Text(
                  context.l10n.commonErrorWithDetail(e.toString()),
                  style: AppTheme.body,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCrossSurveyTable(dynamic l10n, CrossSurveyResponseData data) {
    final questions = data.questions;
    final rows = data.rows;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Scrollbar(
          controller: _crossTableScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _crossTableScrollController,
            scrollDirection: Axis.horizontal,
            child: Theme(
              data: Theme.of(context).copyWith(
                dataTableTheme: DataTableThemeData(
                  headingRowColor: WidgetStatePropertyAll(
                    context.appColors.surfaceSubtle,
                  ),
                  headingTextStyle: AppTheme.body.copyWith(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: AppTheme.body.copyWith(
                    color: context.appColors.textPrimary,
                  ),
                  dividerThickness: 1,
                ),
              ),
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'ID',
                      style: AppTheme.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                  ),
                  ...questions.map(
                    (q) => DataColumn(
                      label: SizedBox(
                        width: 180,
                        child: Tooltip(
                          message:
                              '${q.surveyTitle}${q.surveyStartDate != null ? ' (${q.surveyStartDate!.substring(0, 10)})' : ''}: ${q.questionContent}',
                          child: Text(
                            '${q.surveyTitle}${q.surveyStartDate != null ? ' (${q.surveyStartDate!.substring(0, 10)})' : ''}\n${q.questionContent}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppTheme.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.appColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                rows: rows.map((row) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          row.anonymousId,
                          style: AppTheme.captions.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                      ),
                      ...questions.map((q) {
                        final value =
                            row.responses[q.questionId.toString()] ?? '';
                        return DataCell(
                          SizedBox(
                            width: 180,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.body.copyWith(
                                color: context.appColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Data Bank Analysis tab ─────────────────────────────────────────

  Widget _buildDataBankAnalysisTab(dynamic l10n) {
    final aggregatesAsync = ref.watch(crossSurveyAggregatesProvider);
    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey('dataBankAnalysisTab'),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: aggregatesAsync.when(
                data: (agg) => _buildAggregateGrid(l10n, agg.aggregates),
                loading: () => const AppLoadingIndicator(),
                error: (e, _) => Text(
                  context.l10n.commonErrorWithDetail(e.toString()),
                  style: AppTheme.body,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportCrossSurveyCsv() async {
    setState(() => _exporting = true);
    try {
      final csv = await ref.read(crossSurveyCsvExportProvider.future);
      downloadCsvFile(csv, 'data_bank_export.csv');
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, message: 'Export failed: $e');
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════
// Sticky TabBar delegate for NestedScrollView pinned header
// ══════════════════════════════════════════════════════════════════════════

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  _StickyTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + 1; // +1 for divider

  @override
  double get maxExtent => _tabBar.preferredSize.height + 1;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        border: Border(bottom: BorderSide(color: context.appColors.divider)),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Column(children: [_tabBar]),
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return _tabBar != oldDelegate._tabBar;
  }
}

// ══════════════════════════════════════════════════════════════════════════
// Field Picker Dialog — lets researchers select specific data fields
// ══════════════════════════════════════════════════════════════════════════

class _FieldPickerDialog extends ConsumerStatefulWidget {
  const _FieldPickerDialog({required this.l10n, required this.ref});

  final dynamic l10n;
  final WidgetRef ref;

  @override
  ConsumerState<_FieldPickerDialog> createState() => _FieldPickerDialogState();
}

class _FieldPickerDialogState extends ConsumerState<_FieldPickerDialog> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final questionsAsync = ref.watch(availableQuestionsProvider);
    final filters = ref.watch(crossSurveyFiltersProvider);
    final selectedIds = filters.selectedQuestionIds;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.dataset_outlined,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.researchAvailableQuestions,
                    style: AppTheme.heading5.copyWith(
                      color: context.appColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: context.l10n.tooltipClose,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Search field
              TextField(
                decoration: InputDecoration(
                  hintText: l10n.researchSearchQuestions,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
              const SizedBox(height: 8),
              // Select all / clear row
              Row(
                children: [
                  AppTextButton(
                    label: l10n.researchSelectAll,
                    onPressed: () {
                      final allIds =
                          questionsAsync.valueOrNull
                              ?.map((q) => q.questionId)
                              .toList() ??
                          [];
                      ref
                          .read(crossSurveyFiltersProvider.notifier)
                          .setQuestions(allIds);
                    },
                  ),
                  AppTextButton(
                    label: l10n.commonClear,
                    onPressed: () {
                      ref
                          .read(crossSurveyFiltersProvider.notifier)
                          .clearQuestions();
                    },
                  ),
                  const Spacer(),
                  if (selectedIds.isNotEmpty)
                    Text(
                      l10n.researchSelectedFields(selectedIds.length),
                      style: AppTheme.captions.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                ],
              ),
              const Divider(height: 1),
              // Questions list grouped by survey
              Expanded(
                child: questionsAsync.when(
                  data: (questions) {
                    // Apply search filter
                    final filtered = _search.isEmpty
                        ? questions
                        : questions.where((q) {
                            final term = _search.toLowerCase();
                            return q.questionContent.toLowerCase().contains(
                                  term,
                                ) ||
                                q.surveyTitle.toLowerCase().contains(term) ||
                                q.responseType.toLowerCase().contains(term);
                          }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.researchNoData,
                          style: AppTheme.body.copyWith(
                            color: context.appColors.textMuted,
                          ),
                        ),
                      );
                    }

                    // Group by survey
                    final grouped = <String, List<CrossSurveyQuestion>>{};
                    for (final q in filtered) {
                      grouped.putIfAbsent(q.surveyTitle, () => []).add(q);
                    }

                    return ListView(
                      children: grouped.entries.map((entry) {
                        return ExpansionTile(
                          title: Text(
                            entry.key,
                            style: AppTheme.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          initiallyExpanded: true,
                          children: entry.value.map((q) {
                            final isSelected = selectedIds.contains(
                              q.questionId,
                            );
                            return CheckboxListTile(
                              value: isSelected,
                              title: Text(
                                q.questionContent,
                                style: AppTheme.body,
                              ),
                              subtitle: Text(
                                q.responseType,
                                style: AppTheme.captions.copyWith(
                                  color: context.appColors.textMuted,
                                ),
                              ),
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (_) {
                                ref
                                    .read(crossSurveyFiltersProvider.notifier)
                                    .toggleQuestion(q.questionId);
                              },
                            );
                          }).toList(),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const AppLoadingIndicator(),
                  error: (e, _) => Text(
                    context.l10n.commonErrorWithDetail(e.toString()),
                    style: AppTheme.body,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Done button
              Align(
                alignment: Alignment.centerRight,
                child: AppFilledButton(
                  label: l10n.commonDone,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
