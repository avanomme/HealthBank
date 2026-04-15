// Created with the Assistance of Claude Code
// frontend/lib/src/features/researcher/pages/researcher_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
//import 'package:frontend/src/core/widgets/basics/footer.dart';
import 'package:frontend/src/core/widgets/basics/app_section_navbar.dart';
import 'package:frontend/src/core/widgets/data_display/app_graph_renderer.dart';
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/core/widgets/layout/page_shell.dart';
import 'package:frontend/src/features/researcher/researcher.dart';
import 'package:frontend/src/features/surveys/state/survey_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/features/researcher/state/researcher_dashboard_providers.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';

/// Researcher dashboard page.
///
/// Purpose:
/// - Render the desktop-first researcher dashboard composition from design.
/// - Provide section-based page navigation via [AppSectionNavbar].
///
/// Data and scope notes:
/// - Graph/chart content is placeholder-only and rendered by [AppGraphRenderer].
/// - This page temporarily contains UI composition only.
class ResearcherDashboardPage extends ConsumerStatefulWidget {
  const ResearcherDashboardPage({super.key});

  @override
  ConsumerState<ResearcherDashboardPage> createState() =>
      _ResearcherDashboardPageState();
}

abstract final class _DashboardDestinationIds {
  static const String overviewSection = 'researcher-dashboard-overview-section';
  static const String overviewGraphOne =
      'researcher-dashboard-overview-graph-one';
  static const String overviewGraphTwo =
      'researcher-dashboard-overview-graph-two';
  static const String overviewChartOne =
      'researcher-dashboard-overview-chart-one';
  static const String overviewChartTwo =
      'researcher-dashboard-overview-chart-two';
  static const String insightsSection = 'researcher-dashboard-insights-section';
  static const String insightsChartOne =
      'researcher-dashboard-insights-chart-one';
  static const String insightsChartTwo =
      'researcher-dashboard-insights-chart-two';

  static const List<String> ordered = [
    overviewSection,
    overviewGraphOne,
    overviewGraphTwo,
    overviewChartOne,
    overviewChartTwo,
    insightsSection,
    insightsChartOne,
    insightsChartTwo,
  ];
}

class _ResearcherDashboardPageState
    extends ConsumerState<ResearcherDashboardPage> {
  late final Map<String, GlobalKey> _targetKeys = {
    for (final destination in _DashboardDestinationIds.ordered)
      destination: GlobalKey(),
  };

  final ScrollController _contentScrollController = ScrollController();
  final GlobalKey _mainContentLayoutKey = GlobalKey();
  final GlobalKey _footerLayoutKey = GlobalKey();
  String? _activeDestinationId;
  bool _isScrollingToDestination = false;
  double _mainContentExtent = 0;
  double _footerExtent = 0;
  double _sidebarFooterOverlap = 0;
  bool _hasPendingMetricsRefresh = false;
  bool _sidebarVisible = true;
  bool? _wasMobile;

  String get _resolvedUserName {
    final user = ref.read(authProvider).user;
    if (user != null) {
      final fullName = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
      if (fullName.isNotEmpty) return fullName;
      if (user.email != null && user.email!.isNotEmpty) return user.email!;
    }
    return 'Researcher';
  }

  @override
  void initState() {
    super.initState();
    _contentScrollController.addListener(_handleScrollChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshActiveDestination();
    });
  }

  @override
  void dispose() {
    _contentScrollController
      ..removeListener(_handleScrollChanged)
      ..dispose();
    super.dispose();
  }

  void _handleScrollChanged() {
    _refreshActiveDestination();
    //_refreshSidebarFooterOverlap();
  }

  void _toggleSidebar() {
    setState(() {
      _sidebarVisible = !_sidebarVisible;
    });
  }

  void _refreshActiveDestination() {
    if (!_contentScrollController.hasClients) return;
    if (_isScrollingToDestination) return;

    final resolvedDestination = _resolveActiveDestination(
      _contentScrollController.position.pixels,
    );
    if (resolvedDestination == _activeDestinationId) {
      return;
    }

    setState(() {
      _activeDestinationId = resolvedDestination;
    });
  }

  String _resolveActiveDestination(double scrollPixels) {
    const viewportAnchor = 120.0;
    String? active;

    for (final destination in _DashboardDestinationIds.ordered) {
      final offset = _offsetForDestination(destination);
      if (offset == null) continue;

      if (offset <= scrollPixels + viewportAnchor) {
        active = destination;
      } else {
        break;
      }
    }

    if (active == null) {
      return _DashboardDestinationIds.ordered.first;
    }

    return active;
  }

  double? _offsetForDestination(String destinationId) {
    if (!_contentScrollController.hasClients) return null;

    final targetContext = _targetKeys[destinationId]?.currentContext;
    if (targetContext == null) return null;

    final renderObject = targetContext.findRenderObject();
    if (renderObject == null) return null;

    final viewport = RenderAbstractViewport.of(renderObject);
    return viewport.getOffsetToReveal(renderObject, 0.0).offset;
  }

  Future<void> _onDestinationTap(String destinationId) async {
    final targetOffset = _offsetForDestination(destinationId);
    if (targetOffset == null || !_contentScrollController.hasClients) return;

    setState(() {
      _activeDestinationId = destinationId;
      _isScrollingToDestination = true;
    });

    await _contentScrollController.animateTo(
      targetOffset.clamp(
        _contentScrollController.position.minScrollExtent,
        _contentScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Re-enable scroll-based resolution after animation completes
    if (mounted) {
      setState(() {
        _isScrollingToDestination = false;
      });
    }
  }

  void _scheduleLayoutMetricsRefresh() {
    if (_hasPendingMetricsRefresh) return;

    _hasPendingMetricsRefresh = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hasPendingMetricsRefresh = false;
      if (!mounted) return;

      _refreshLayoutMetrics();
      _refreshActiveDestination();
      _refreshSidebarFooterOverlap();
    });
  }

  void _refreshLayoutMetrics() {
    _mainContentExtent =
        _mainContentLayoutKey.currentContext?.size?.height ?? 0;
    _footerExtent = _footerLayoutKey.currentContext?.size?.height ?? 0;
  }

  void _refreshSidebarFooterOverlap() {
    if (!_contentScrollController.hasClients) return;

    final availableWidth =
        context.size?.width ?? MediaQuery.sizeOf(context).width;
    final isWideLayout = availableWidth >= Breakpoints.desktop;
    final nextOverlap = isWideLayout ? _footerVisibleHeight() : 0.0;

    if ((nextOverlap - _sidebarFooterOverlap).abs() < 0.5) {
      return;
    }

    setState(() {
      _sidebarFooterOverlap = nextOverlap;
    });
  }

  double _footerVisibleHeight() {
    if (_mainContentExtent <= 0 || _footerExtent <= 0) return 0;
    if (!_contentScrollController.hasClients) return 0;

    final position = _contentScrollController.position;
    return (position.pixels + position.viewportDimension - _mainContentExtent)
        .clamp(0.0, _footerExtent)
        .toDouble();
  }

  List<AppSectionNavbarSection> _sidebarSections(AppLocalizations l10n) {
    return [
      AppSectionNavbarSection(
        id: 'section-overview',
        label: l10n.researcherDashboardSectionTitle1,
        destinationId: _DashboardDestinationIds.overviewSection,
        initiallyExpanded: true,
        children: [
          AppSectionNavbarItem(
            label: l10n.researcherDashboardGraphTitle1,
            destinationId: _DashboardDestinationIds.overviewGraphOne,
          ),
          AppSectionNavbarItem(
            label: l10n.researcherDashboardGraphTitle2,
            destinationId: _DashboardDestinationIds.overviewGraphTwo,
          ),
          AppSectionNavbarItem(
            label: l10n.researcherDashboardChartTitle1,
            destinationId: _DashboardDestinationIds.overviewChartOne,
          ),
          //AppSectionNavbarItem(
          //  label: l10n.researcherDashboardChartTitle2,
          //  destinationId: _DashboardDestinationIds.overviewChartTwo,
          //),
        ],
      ),
      /*
      AppSectionNavbarSection(
        id: 'section-insights',
        label: l10n.researcherDashboardSectionTitle2,
        destinationId: _DashboardDestinationIds.insightsSection,
        initiallyExpanded: true,
        children: [
          AppSectionNavbarItem(
            label: l10n.researcherDashboardChartTitle3,
            destinationId: _DashboardDestinationIds.insightsChartOne,
          ),
          AppSectionNavbarItem(
            label: l10n.researcherDashboardChartTitle4,
            destinationId: _DashboardDestinationIds.insightsChartTwo,
          ),
        ],
      ),*/
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ResearcherScaffold(
      currentRoute: '/researcher/dashboard',
      alignment: AppPageAlignment.sidebarCompact,
      bodyBehavior: AppPageBodyBehavior.edgeToEdge,
      scrollable: false,
      showFooter: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _scheduleLayoutMetricsRefresh();

          final width = constraints.maxWidth;
          final alignmentSpec = context.resolvePageAlignment();
          final contentPadding = alignmentSpec.horizontalPadding;
          final isMobile = Breakpoints.isMobile(width);
          final sectionGap = contentPadding * 0.8;

          if (_wasMobile != isMobile) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {
                _wasMobile = isMobile;
                _sidebarVisible = !isMobile;
              });
            });
          }

          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _sidebarVisible ? 240 : 40,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: _sidebarVisible
                    ? OverflowBox(
                        alignment: Alignment.centerLeft,
                        maxWidth: 240,
                        minWidth: 240,
                        child: ResearcherDashboardSidebar(
                          sections: _sidebarSections(l10n),
                          activeDestinationId: _activeDestinationId,
                          onDestinationTap: _onDestinationTap,
                          onCollapse: _toggleSidebar,
                          userName: _resolvedUserName,
                        ),
                      )
                    : Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: IconButton(
                            icon: const Icon(Icons.chevron_right_rounded),
                            iconSize: 24,
                            color: AppTheme.primary,
                            tooltip: context.l10n.tooltipExpandSidebar,
                            onPressed: _toggleSidebar,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _contentScrollController,
                  child: Padding(
                    key: _mainContentLayoutKey,
                    padding: alignmentSpec.bodyPadding,
                    child: _DashboardMainContent(
                      l10n: l10n,
                      basePadding: contentPadding,
                      sectionGap: sectionGap,
                      targetKeys: _targetKeys,
                      onActiveSurveysTap: () {
                        ref.read(surveyFiltersProvider.notifier).setPublicationStatus('published');
                        context.go('/surveys');
                      },
                      onCompletedSurveysTap: () {
                        ref.read(surveyFiltersProvider.notifier).setPublicationStatus('closed');
                        context.go('/surveys');
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },

        /*
        builder: (context, constraints) {
          _scheduleLayoutMetricsRefresh();

          final width = constraints.maxWidth;
          final contentPadding = Breakpoints.isMobile(width) ? 16.0 : 24.0;
          final isWide = width >= Breakpoints.desktop;
          final sectionGap = contentPadding * 0.8;
          const sidebarWidth = 240.0;
          final maxSidebarInset = _contentScrollController.hasClients
              ? (_contentScrollController.position.viewportDimension - 1)
                    .clamp(0.0, double.infinity)
                    .toDouble()
              : double.infinity;
          final sidebarBottomInset = _sidebarFooterOverlap
              .clamp(0.0, maxSidebarInset)
              .toDouble();

          if (isWide) {
            return Stack(
              children: [
                SingleChildScrollView(
                  controller: _contentScrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        key: _mainContentLayoutKey,
                        padding: EdgeInsets.fromLTRB(
                          sidebarWidth + contentPadding,
                          contentPadding,
                          contentPadding,
                          contentPadding,
                        ),
                        child: _DashboardMainContent(
                          l10n: l10n,
                          basePadding: contentPadding,
                          sectionGap: sectionGap,
                          targetKeys: _targetKeys,
                        ),
                      ),
                      //KeyedSubtree(
                      //  key: _footerLayoutKey,
                      //  child: Footer(onLinkTap: (route) => context.go(route)),
                      //),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: sidebarBottomInset,
                  child: SizedBox(
                    width: sidebarWidth,
                    child: AppSectionNavbar(
                      sections: _sidebarSections(l10n),
                      activeDestinationId: _activeDestinationId,
                      onDestinationTap: _onDestinationTap,
                    ),
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            controller: _contentScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  key: _mainContentLayoutKey,
                  padding: EdgeInsets.all(contentPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppSectionNavbar(
                        sections: _sidebarSections(l10n),
                        activeDestinationId: _activeDestinationId,
                        onDestinationTap: _onDestinationTap,
                      ),
                      SizedBox(height: sectionGap),
                      _DashboardMainContent(
                        l10n: l10n,
                        basePadding: contentPadding,
                        sectionGap: sectionGap,
                        targetKeys: _targetKeys,
                        onActiveSurveysTap: () {
                          ref.read(surveyFiltersProvider.notifier).setPublicationStatus('published');
                          context.go('/surveys');
                        },
                      ),
                    ],
                  ),
                ),
                //KeyedSubtree(
                //  key: _footerLayoutKey,
                //  child: Footer(onLinkTap: (route) => context.go(route)),
                //),
              ],
            ),
          );
        },
        */
      ),
    );
  }
}

class _DashboardMainContent extends StatelessWidget {
  const _DashboardMainContent({
    required this.l10n,
    required this.basePadding,
    required this.sectionGap,
    required this.targetKeys,
    this.onActiveSurveysTap,
    this.onCompletedSurveysTap,
  });

  final AppLocalizations l10n;
  final double basePadding;
  final double sectionGap;
  final Map<String, GlobalKey> targetKeys;
  final VoidCallback? onActiveSurveysTap;
  final VoidCallback? onCompletedSurveysTap;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final summaryAsync = ref.watch(researcherDashboardSummaryProvider);

        return summaryAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.only(top: 24),
            child: AppLoadingIndicator(),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(context.l10n.commonErrorWithDetail(e.toString())),
          ),
          data: (summary) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── OVERVIEW ───────────────────────────────────────────────
                KeyedSubtree(
                  key: targetKeys[_DashboardDestinationIds.overviewSection],
                  child: AppText(
                    l10n.researcherDashboardSectionTitle1,
                    variant: AppTextVariant.headlineMedium,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: sectionGap),

                if (summary.suppressed)
                  _SuppressedBanner(
                    text: summary.reason ?? l10n.researchSuppressed(summary.minResponses),
                  ),

                _kpiRow(context, summary, onActiveTap: onActiveSurveysTap, onCompletedTap: onCompletedSurveysTap),
                SizedBox(height: sectionGap),

                // Top surveys by responses (bar) + Status distribution (pie)
                _buildChartsRow(context, summary),

                SizedBox(height: sectionGap),

                // “Recent surveys” list
                KeyedSubtree(
                  key: targetKeys[_DashboardDestinationIds.overviewChartOne],
                  child: _SurveyListCard(
                    title: l10n.researcherDashboardChartTitle1,
                    surveys: summary.surveys,
                    onOpenData: () => context.go('/researcher/data'),
                  ),
                ),

                SizedBox(height: sectionGap * 1.2),

                // ── INSIGHTS ───────────────────────────────────────────────
                /*
                KeyedSubtree(
                  key: targetKeys[_DashboardDestinationIds.insightsSection],
                  child: AppText(
                    l10n.researcherDashboardSectionTitle2,
                    variant: AppTextVariant.headlineMedium,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: sectionGap),
                */

                // Lightweight “insights” cards using existing placeholders
                /*
                _buildTwoCardRow(
                  context,
                  leftTitle: l10n.researcherDashboardChartTitle3,
                  rightTitle: l10n.researcherDashboardChartTitle4,
                  leftKey: targetKeys[_DashboardDestinationIds.insightsChartOne],
                  rightKey: targetKeys[_DashboardDestinationIds.insightsChartTwo],
                  cardHeight: 150,
                ),
                */
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildChartsRow(BuildContext context, DashboardSummary summary) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barChart = KeyedSubtree(
          key: targetKeys[_DashboardDestinationIds.overviewGraphOne],
          child: AppBarChart(
            title: l10n.researcherDashboardGraphTitle1,
            data: {
              for (final s in summary.topSurveysByResponses)
                s.title: s.responseCount.toDouble(),
            },
          ),
        );
        final pieChart = KeyedSubtree(
          key: targetKeys[_DashboardDestinationIds.overviewGraphTwo],
          child: AppPieChart(
            title: l10n.researcherDashboardGraphTitle2,
            data: {
              for (final entry in summary.statusBuckets.entries)
                '${_localizedBucket(entry.key, l10n)} (${entry.value})': entry.value.toDouble(),
            },
            colors: [
              AppTheme.primary,
              AppTheme.success,
              context.appColors.textMuted,
            ],
          ),
        );

        if (constraints.maxWidth >= 760) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: barChart),
              SizedBox(width: basePadding * 0.65),
              Expanded(child: pieChart),
            ],
          );
        }

        return Column(
          children: [
            barChart,
            SizedBox(height: sectionGap),
            pieChart,
          ],
        );
      },
    );
  }

  Widget _kpiRow(BuildContext context, DashboardSummary summary, {VoidCallback? onActiveTap, VoidCallback? onCompletedTap}) {
    // If suppressed, still show survey counts (those aren’t k-anon sensitive),
    // but respondent totals might be suppressed depending on your backend logic.
    final totalRespondentsValue = summary.suppressed
        ? '—'
        : '${summary.totalRespondents}';

    final completionValue = summary.suppressed
        ? '—'
        : '${summary.avgCompletionRate.toStringAsFixed(1)}%';

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        final cards = [
          AppStatCard(
            label: l10n.researcherDashboardKpiActiveSurveys,
            value: '${summary.activeCount}',
            icon: Icons.play_circle_outline,
            color: AppTheme.primary,
            onTap: onActiveTap,
          ),
          AppStatCard(
            label: l10n.researcherDashboardKpiCompletedSurveys,
            value: '${summary.completedCount}',
            icon: Icons.check_circle_outline,
            color: AppTheme.success,
            onTap: onCompletedTap,
          ),
          AppStatCard(
            label: l10n.researcherDashboardKpiTotalRespondents,
            value: totalRespondentsValue,
            icon: Icons.people_outline,
            color: AppTheme.info,
          ),
          AppStatCard(
            label: l10n.researcherDashboardKpiAvgCompletion,
            value: completionValue,
            icon: Icons.analytics_outlined,
            color: AppTheme.secondary,
          ),
        ];

        if (wide) {
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
          spacing: 16,
          runSpacing: 16,
          children: [for (final c in cards) SizedBox(width: 320, child: c)],
        );
      },
    );
  }


  // Kept from your original file (same as before)
}

/// Translates a statusBuckets key ('Active'/'Completed'/'Other') to a
/// locale-aware label for use in charts and summaries.
String _localizedBucket(String key, AppLocalizations l10n) {
  switch (key) {
    case 'Active':
      return l10n.statusActive;
    case 'Completed':
      return l10n.statusCompleted;
    default:
      return key; // 'Other' and any future bucket — fall through as-is
  }
}

class _SuppressedBanner extends StatelessWidget {
  const _SuppressedBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppInfoBanner(
        icon: Icons.warning_amber_rounded,
        message: text,
        color: AppTheme.caution,
        backgroundAlpha: 0.08,
        borderAlpha: 0.4,
        radius: 12,
        padding: const EdgeInsets.all(16),
        textStyle: AppTheme.body,
      ),
    );
  }
}

class _SurveyListCard extends StatelessWidget {
  const _SurveyListCard({
    required this.title,
    required this.surveys,
    required this.onOpenData,
  });

  final String title;
  final List<ResearchSurvey> surveys;
  final VoidCallback onOpenData;

  @override
  Widget build(BuildContext context) {
    final sorted = [...surveys]
      ..sort((a, b) => b.surveyId.compareTo(a.surveyId));
    final top = sorted.take(8).toList();

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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.heading5.copyWith(
                    color: context.appColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onOpenData,
                icon: const Icon(Icons.open_in_new, size: 18),
                label: Text(context.l10n.navData),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final s in top) ...[
            _SurveyRow(s: s),
            Divider(height: 16, color: context.appColors.divider),
          ],
          if (top.isEmpty)
            Text(
              context.l10n.researchNoSurveys,
              style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            ),
        ],
      ),
    );
  }
}

class _SurveyRow extends StatelessWidget {
  const _SurveyRow({required this.s});

  final ResearchSurvey s;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            s.title,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.body.copyWith(
              fontWeight: FontWeight.w600,
              color: context.appColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            s.publicationStatus,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.captions.copyWith(
              color: context.appColors.textMuted,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            '${s.responseCount} resp',
            textAlign: TextAlign.right,
            style: AppTheme.captions.copyWith(
              color: context.appColors.textMuted,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: Text(
            '${s.questionCount} q',
            textAlign: TextAlign.right,
            style: AppTheme.captions.copyWith(
              color: context.appColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
