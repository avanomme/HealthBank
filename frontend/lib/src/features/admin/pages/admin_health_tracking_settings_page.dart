// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/pages/admin_health_tracking_settings_page.dart
/// Admin page for managing health tracking categories and metrics.
///
/// Admins can:
/// - View all categories and their metrics
/// - Drag-and-drop reorder categories and metrics
/// - Toggle categories and metrics active / inactive (stays in place)
/// - Soft-delete (remove) categories and metrics (moves to Removed section)
/// - Restore removed categories and metrics
/// - Add / edit categories and metrics
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/app_loading_indicator.dart';
import 'package:frontend/src/features/admin/state/health_tracking_admin_providers.dart';
import 'package:frontend/src/features/admin/widgets/admin_scaffold.dart';

/// Admin page for managing health-tracking categories and metrics.
///
/// Supports CRUD, drag-to-reorder, soft-delete/restore, and active toggling.
class AdminHealthTrackingSettingsPage extends ConsumerStatefulWidget {
  const AdminHealthTrackingSettingsPage({super.key});

  @override
  ConsumerState<AdminHealthTrackingSettingsPage> createState() =>
      _AdminHealthTrackingSettingsPageState();
}

class _AdminHealthTrackingSettingsPageState
    extends ConsumerState<AdminHealthTrackingSettingsPage> {
  final Set<int> _expandedCategories = {};

  // Local ordered copies — initialised from providers, updated optimistically
  // for toggle/delete/restore.  _pendingRefresh=true tells the build to
  // re-sync from providers once new server data arrives (used after create/edit).
  List<TrackingCategory>? _localCategories;
  Map<int, List<TrackingMetric>>? _localMetrics;
  bool _initialized = false;
  bool _pendingRefresh = false;

  // Populate local state from provider data.
  // Runs on first load OR whenever _pendingRefresh is true (after a create/edit
  // that required a server round-trip to get the new item's ID).
  void _syncFromProviders(
    List<TrackingCategory> categories,
    List<TrackingMetric> allMetrics,
  ) {
    if (_initialized && !_pendingRefresh) return;
    _initialized = true;
    _pendingRefresh = false;
    _localCategories = List.of(categories)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    _localMetrics = {};
    for (final cat in categories) {
      _localMetrics![cat.categoryId] =
          allMetrics.where((m) => m.categoryId == cat.categoryId).toList()
            ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    }
  }

  // Request a full re-sync from the server on the next provider refresh.
  // Use this after create/edit (where the server assigns new IDs).
  void _scheduleRefresh() => _pendingRefresh = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categoriesAsync = ref.watch(adminTrackingCategoriesProvider);
    final metricsAsync = ref.watch(adminTrackingMetricsProvider);

    // Sync local state once both providers have FRESH data.
    // During a reload after invalidate(), hasValue is still true (cached),
    // but we must wait for the new data — otherwise we'd sync stale values
    // and clear _pendingRefresh before the new category/metric arrives.
    final isRefreshing = categoriesAsync.isLoading ||
        metricsAsync.isLoading ||
        categoriesAsync.isRefreshing ||
        metricsAsync.isRefreshing;
    if (categoriesAsync.hasValue && metricsAsync.hasValue && !isRefreshing) {
      _syncFromProviders(
        categoriesAsync.valueOrNull ?? [],
        metricsAsync.valueOrNull ?? [],
      );
    }

    return AdminScaffold(
      currentRoute: '/admin/health-tracking',
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ──────────────────────────────────────────────
          Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.adminHealthTrackingTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AppOutlinedButton(
                  label: l10n.adminHealthTrackingAddCategory,
                  icon: Icons.add,
                  onPressed: () => _showCategoryDialog(context),
                  foregroundColor: AppTheme.primary,
                  borderColor: AppTheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.adminHealthTrackingSubtitle,
              style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            ),
            const SizedBox(height: 24),
            Divider(color: context.appColors.divider),
            const SizedBox(height: 20),

            // ── Categories + metrics list ───────────────────────────────
            Row(
              children: [
                const ExcludeSemantics(
                  child: Icon(Icons.category_outlined, size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.adminHealthTrackingCategoriesSection,
                  style: AppTheme.heading5.copyWith(
                    color: context.appColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (categoriesAsync.isLoading || metricsAsync.isLoading)
              const AppLoadingIndicator()
            else if (categoriesAsync.hasError)
              Text(
                context.l10n.commonErrorWithDetail(
                  categoriesAsync.error.toString(),
                ),
                style: AppTheme.body.copyWith(color: AppTheme.error),
              )
            else if (metricsAsync.hasError)
              Text(
                context.l10n.commonErrorWithDetail(
                  metricsAsync.error.toString(),
                ),
                style: AppTheme.body.copyWith(color: AppTheme.error),
              )
            else
              _CategoryList(
                categories: _localCategories ?? [],
                metricsByCategory: _localMetrics ?? {},
                expandedCategories: _expandedCategories,
                onToggleExpand: (id) => setState(
                  () => _expandedCategories.contains(id)
                      ? _expandedCategories.remove(id)
                      : _expandedCategories.add(id),
                ),
                onCategoryReorder: _onCategoryReorder,
                onMetricReorder: _onMetricReorder,
                onEditCategory: (cat) =>
                    _showCategoryDialog(context, category: cat),
                onToggleCategory: _toggleCategory,
                onDeleteCategory: _deleteCategory,
                onRestoreCategory: _restoreCategory,
                onAddMetric: (categoryId) =>
                    _showMetricDialog(context, categoryId: categoryId),
                onEditMetric: (metric) =>
                    _showMetricDialog(context, metric: metric),
                onToggleMetric: _toggleMetric,
                onDeleteMetric: _deleteMetric,
                onRestoreMetric: _restoreMetric,
              ),

            const SizedBox(height: 40),
          ],
      ),
    );
  }

  // ── Reorder ────────────────────────────────────────────────────────────────

  Future<void> _onCategoryReorder(int oldIndex, int newIndex) async {
    final cats = _localCategories;
    if (cats == null) return;

    final nonDeleted = cats.where((c) => !c.isDeleted).toList();
    if (newIndex > oldIndex) newIndex -= 1;
    final moved = nonDeleted.removeAt(oldIndex);
    nonDeleted.insert(newIndex, moved);

    // Rebuild the full list preserving deleted items at the back.
    final deleted = cats.where((c) => c.isDeleted).toList();
    final reordered = [...nonDeleted, ...deleted];
    setState(() => _localCategories = reordered);

    final api = ref.read(healthTrackingAdminApiProvider);
    try {
      await api.reorderCategories(
        nonDeleted
            .asMap()
            .entries
            .map(
              (e) => CategoryOrderItem(
                categoryId: e.value.categoryId,
                displayOrder: e.key,
              ),
            )
            .toList(),
      );
    } catch (_) {
      // Revert optimistic reorder and re-fetch from server.
      _scheduleRefresh();
      ref.invalidate(adminTrackingCategoriesProvider);
    }
  }

  Future<void> _onMetricReorder(
    int categoryId,
    int oldIndex,
    int newIndex,
  ) async {
    final metrics = _localMetrics?[categoryId];
    if (metrics == null) return;

    final nonDeleted = metrics.where((m) => !m.isDeleted).toList();
    if (newIndex > oldIndex) newIndex -= 1;
    final moved = nonDeleted.removeAt(oldIndex);
    nonDeleted.insert(newIndex, moved);

    final deleted = metrics.where((m) => m.isDeleted).toList();
    setState(() => _localMetrics![categoryId] = [...nonDeleted, ...deleted]);

    final api = ref.read(healthTrackingAdminApiProvider);
    try {
      await api.reorderMetrics(
        nonDeleted
            .asMap()
            .entries
            .map(
              (e) => MetricOrderItem(
                metricId: e.value.metricId,
                displayOrder: e.key,
              ),
            )
            .toList(),
      );
    } catch (_) {
      _scheduleRefresh();
      ref.invalidate(adminTrackingMetricsProvider);
    }
  }

  // ── Toggle ─────────────────────────────────────────────────────────────────

  Future<void> _toggleCategory(TrackingCategory category) async {
    // Flip the local state immediately — no wait, no re-fetch.
    // If the API call fails we revert; if it succeeds the optimistic
    // state already matches what the server now holds.
    final snapshot = _localCategories;
    if (snapshot != null) {
      setState(() {
        _localCategories = snapshot
            .map(
              (c) => c.categoryId == category.categoryId
                  ? c.copyWith(isActive: !c.isActive)
                  : c,
            )
            .toList();
      });
    }

    try {
      await ref
          .read(healthTrackingAdminApiProvider)
          .toggleCategory(category.categoryId);
    } catch (e) {
      if (snapshot != null) setState(() => _localCategories = snapshot);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.adminHealthTrackingSaveError(e.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<void> _toggleMetric(TrackingMetric metric) async {
    final catId = metric.categoryId;
    final snapshot = _localMetrics?[catId];
    if (snapshot != null) {
      setState(() {
        _localMetrics![catId] = snapshot
            .map(
              (m) => m.metricId == metric.metricId
                  ? m.copyWith(isActive: !m.isActive)
                  : m,
            )
            .toList();
      });
    }

    try {
      await ref
          .read(healthTrackingAdminApiProvider)
          .toggleMetric(metric.metricId);
    } catch (e) {
      if (snapshot != null) setState(() => _localMetrics![catId] = snapshot);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.adminHealthTrackingSaveError(e.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteCategory(TrackingCategory category) async {
    final l10n = context.l10n;
    final confirmed = await _showDeleteConfirm(
      title: l10n.adminHealthTrackingDeleteCategoryTitle,
      message: l10n.adminHealthTrackingDeleteCategoryMessage(
        category.displayName,
      ),
    );
    if (!confirmed || !mounted) return;

    // Optimistic: mark as deleted immediately — moves to Removed section.
    final snapshot = _localCategories;
    if (snapshot != null) {
      setState(() {
        _localCategories = snapshot
            .map(
              (c) => c.categoryId == category.categoryId
                  ? c.copyWith(isDeleted: true, isActive: false)
                  : c,
            )
            .toList();
      });
    }

    try {
      await ref
          .read(healthTrackingAdminApiProvider)
          .deleteCategory(category.categoryId);
    } catch (e) {
      if (snapshot != null) setState(() => _localCategories = snapshot);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.adminHealthTrackingSaveError(e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> _deleteMetric(TrackingMetric metric) async {
    final l10n = context.l10n;
    final confirmed = await _showDeleteConfirm(
      title: l10n.adminHealthTrackingDeleteMetricTitle,
      message: l10n.adminHealthTrackingDeleteMetricMessage(metric.displayName),
    );
    if (!confirmed || !mounted) return;

    // Optimistic: mark as deleted immediately — moves to Removed section.
    final catId = metric.categoryId;
    final snapshot = _localMetrics?[catId];
    if (snapshot != null) {
      setState(() {
        _localMetrics![catId] = snapshot
            .map(
              (m) => m.metricId == metric.metricId
                  ? m.copyWith(isDeleted: true, isActive: false)
                  : m,
            )
            .toList();
      });
    }

    try {
      await ref
          .read(healthTrackingAdminApiProvider)
          .deleteMetric(metric.metricId);
    } catch (e) {
      if (snapshot != null) setState(() => _localMetrics![catId] = snapshot);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.adminHealthTrackingSaveError(e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> _restoreCategory(TrackingCategory category) async {
    // Optimistic: undelete immediately — moves back to main list.
    final snapshot = _localCategories;
    if (snapshot != null) {
      setState(() {
        _localCategories = snapshot
            .map(
              (c) => c.categoryId == category.categoryId
                  ? c.copyWith(isDeleted: false, isActive: true)
                  : c,
            )
            .toList();
      });
    }

    try {
      await ref
          .read(healthTrackingAdminApiProvider)
          .restoreCategory(category.categoryId);
    } catch (e) {
      if (snapshot != null) setState(() => _localCategories = snapshot);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.adminHealthTrackingSaveError(e.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<void> _restoreMetric(TrackingMetric metric) async {
    final catId = metric.categoryId;
    final snapshot = _localMetrics?[catId];
    // Optimistic: undelete immediately — moves back to draggable list.
    if (snapshot != null) {
      setState(() {
        _localMetrics![catId] = snapshot
            .map(
              (m) => m.metricId == metric.metricId
                  ? m.copyWith(isDeleted: false, isActive: true)
                  : m,
            )
            .toList();
      });
    }

    try {
      await ref
          .read(healthTrackingAdminApiProvider)
          .restoreMetric(metric.metricId);
    } catch (e) {
      if (snapshot != null) setState(() => _localMetrics![catId] = snapshot);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.adminHealthTrackingSaveError(e.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<bool> _showDeleteConfirm({
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _showCategoryDialog(
    BuildContext context, {
    TrackingCategory? category,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _CategoryDialog(
        category: category,
        onSave: (body) async {
          final api = ref.read(healthTrackingAdminApiProvider);
          if (category == null) {
            await api.createCategory(body);
          } else {
            await api.updateCategory(category.categoryId, body);
          }
          // Schedule re-sync so the next provider refresh picks up new data.
          _scheduleRefresh();
          ref.invalidate(adminTrackingCategoriesProvider);
        },
      ),
    );
  }

  Future<void> _showMetricDialog(
    BuildContext context, {
    int? categoryId,
    TrackingMetric? metric,
  }) async {
    final categories =
        ref.read(adminTrackingCategoriesProvider).valueOrNull ?? [];
    await showDialog<void>(
      context: context,
      builder: (_) => _MetricDialog(
        metric: metric,
        initialCategoryId: categoryId ?? metric?.categoryId,
        categories: categories,
        onSave: (body) async {
          final api = ref.read(healthTrackingAdminApiProvider);
          if (metric == null) {
            await api.createMetric(body);
          } else {
            await api.updateMetric(metric.metricId, body);
          }
          _scheduleRefresh();
          ref.invalidate(adminTrackingMetricsProvider);
        },
      ),
    );
  }
}

// ── Category list ─────────────────────────────────────────────────────────────

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.categories,
    required this.metricsByCategory,
    required this.expandedCategories,
    required this.onToggleExpand,
    required this.onCategoryReorder,
    required this.onMetricReorder,
    required this.onEditCategory,
    required this.onToggleCategory,
    required this.onDeleteCategory,
    required this.onRestoreCategory,
    required this.onAddMetric,
    required this.onEditMetric,
    required this.onToggleMetric,
    required this.onDeleteMetric,
    required this.onRestoreMetric,
  });

  final List<TrackingCategory> categories;
  final Map<int, List<TrackingMetric>> metricsByCategory;
  final Set<int> expandedCategories;
  final void Function(int categoryId) onToggleExpand;
  final void Function(int oldIndex, int newIndex) onCategoryReorder;
  final void Function(int categoryId, int oldIndex, int newIndex)
  onMetricReorder;
  final void Function(TrackingCategory) onEditCategory;
  final void Function(TrackingCategory) onToggleCategory;
  final void Function(TrackingCategory) onDeleteCategory;
  final void Function(TrackingCategory) onRestoreCategory;
  final void Function(int categoryId) onAddMetric;
  final void Function(TrackingMetric) onEditMetric;
  final void Function(TrackingMetric) onToggleMetric;
  final void Function(TrackingMetric) onDeleteMetric;
  final void Function(TrackingMetric) onRestoreMetric;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (categories.isEmpty) {
      return Text(
        l10n.adminHealthTrackingNoCategories,
        style: AppTheme.body.copyWith(color: context.appColors.textMuted),
      );
    }

    // Split into non-deleted (orderable) and deleted (restored from bottom).
    final liveCategories = categories.where((c) => !c.isDeleted).toList();
    final deletedCategories = categories.where((c) => c.isDeleted).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Drag-and-drop category list ───────────────────────────
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorder: onCategoryReorder,
          itemCount: liveCategories.length,
          itemBuilder: (context, index) {
            final cat = liveCategories[index];
            final metrics = metricsByCategory[cat.categoryId] ?? [];
            return _CategoryTile(
              key: ValueKey(cat.categoryId),
              category: cat,
              metrics: metrics,
              dragIndex: index,
              isExpanded: expandedCategories.contains(cat.categoryId),
              onToggleExpand: () => onToggleExpand(cat.categoryId),
              onMetricReorder: (old, nw) =>
                  onMetricReorder(cat.categoryId, old, nw),
              onEditCategory: () => onEditCategory(cat),
              onToggleCategory: () => onToggleCategory(cat),
              onDeleteCategory: () => onDeleteCategory(cat),
              onAddMetric: () => onAddMetric(cat.categoryId),
              onEditMetric: onEditMetric,
              onToggleMetric: onToggleMetric,
              onDeleteMetric: onDeleteMetric,
              onRestoreMetric: onRestoreMetric,
            );
          },
        ),

        // ── Removed categories section ────────────────────────────
        if (deletedCategories.isNotEmpty) ...[
          const SizedBox(height: 8),
          _RemovedCategoriesSection(
            categories: deletedCategories,
            metricsByCategory: metricsByCategory,
            onRestoreCategory: onRestoreCategory,
            onRestoreMetric: onRestoreMetric,
          ),
        ],
      ],
    );
  }
}

// ── Category tile (accordion + drag handle) ───────────────────────────────────

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    super.key,
    required this.category,
    required this.metrics,
    required this.dragIndex,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onMetricReorder,
    required this.onEditCategory,
    required this.onToggleCategory,
    required this.onDeleteCategory,
    required this.onAddMetric,
    required this.onEditMetric,
    required this.onToggleMetric,
    required this.onDeleteMetric,
    required this.onRestoreMetric,
  });

  final TrackingCategory category;
  final List<TrackingMetric> metrics;
  final int dragIndex;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final void Function(int oldIndex, int newIndex) onMetricReorder;
  final VoidCallback onEditCategory;
  final VoidCallback onToggleCategory;
  final VoidCallback onDeleteCategory;
  final VoidCallback onAddMetric;
  final void Function(TrackingMetric) onEditMetric;
  final void Function(TrackingMetric) onToggleMetric;
  final void Function(TrackingMetric) onDeleteMetric;
  final void Function(TrackingMetric) onRestoreMetric;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final liveMetrics = metrics.where((m) => !m.isDeleted).toList();
    final deletedMetrics = metrics.where((m) => m.isDeleted).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: category.isActive
            ? context.appColors.surfaceRaised
            : context.appColors.surfaceRaised.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: category.isActive
              ? context.appColors.divider
              : context.appColors.divider.withValues(alpha: 0.5),
        ),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Drag handle
                ReorderableDragStartListener(
                  index: dragIndex,
                  child: Tooltip(
                    message: l10n.adminHealthTrackingDragToReorder,
                    child: Icon(
                      Icons.drag_handle,
                      size: 20,
                      color: context.appColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 4),

                // Expand/collapse tap target
                Expanded(
                  child: InkWell(
                    onTap: onToggleExpand,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          ExcludeSemantics(
                            child: Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: context.appColors.textMuted,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.displayName,
                                  style: AppTheme.heading5.copyWith(
                                    color: category.isActive
                                        ? context.appColors.textPrimary
                                        : context.appColors.textMuted,
                                  ),
                                ),
                                if (category.description != null &&
                                    category.description!.isNotEmpty)
                                  Text(
                                    category.description!,
                                    style: AppTheme.captions.copyWith(
                                      color: context.appColors.textMuted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Active/Inactive toggle switch
                Tooltip(
                  message: l10n.adminHealthTrackingToggleCategoryActive,
                  child: Switch(
                    value: category.isActive,
                    onChanged: (_) => onToggleCategory(),
                    activeThumbColor: AppTheme.success,
                  ),
                ),

                // Edit button
                Tooltip(
                  message: l10n.adminHealthTrackingEditCategory,
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: onEditCategory,
                  ),
                ),

                // Delete (soft-delete) button
                Tooltip(
                  message: l10n.commonDelete,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppTheme.error,
                    ),
                    onPressed: onDeleteCategory,
                  ),
                ),

                // Add metric button
                Tooltip(
                  message: l10n.adminHealthTrackingAddMetric,
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    onPressed: onAddMetric,
                  ),
                ),
              ],
            ),
          ),

          // ── Metrics list (collapsible) ───────────────────────
          if (isExpanded) ...[
            Divider(color: context.appColors.divider, height: 1),
            if (liveMetrics.isEmpty && deletedMetrics.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.adminHealthTrackingNoMetrics,
                  style: AppTheme.body.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              )
            else ...[
              // ── Drag-and-drop metric list ──────────────────
              if (liveMetrics.isNotEmpty)
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorder: onMetricReorder,
                  itemCount: liveMetrics.length,
                  proxyDecorator: (child, index, animation) => child,
                  itemBuilder: (context, index) {
                    final m = liveMetrics[index];
                    return _MetricRow(
                      key: ValueKey(m.metricId),
                      metric: m,
                      dragIndex: index,
                      onEdit: () => onEditMetric(m),
                      onToggle: () => onToggleMetric(m),
                      onDelete: () => onDeleteMetric(m),
                    );
                  },
                ),

              // ── Removed metrics section ────────────────────
              if (deletedMetrics.isNotEmpty) ...[
                Divider(color: context.appColors.divider, height: 1),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    leading: ExcludeSemantics(
                      child: Icon(
                        Icons.delete_sweep_outlined,
                        size: 16,
                        color: context.appColors.textMuted,
                      ),
                    ),
                    title: Text(
                      l10n.adminHealthTrackingRemovedMetrics(
                        deletedMetrics.length,
                      ),
                      style: AppTheme.captions.copyWith(
                        color: context.appColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      for (final m in deletedMetrics)
                        _RemovedMetricRow(
                          metric: m,
                          onRestore: () => onRestoreMetric(m),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

// ── Metric row (with drag handle) ─────────────────────────────────────────────

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    super.key,
    required this.metric,
    required this.dragIndex,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final TrackingMetric metric;
  final int dragIndex;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subtitle = [
      _MetricDialogState._typeLabel(context, metric.metricType),
      if (metric.unit != null) metric.unit!,
      _MetricDialogState._freqLabel(context, metric.frequency),
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          // Drag handle
          ReorderableDragStartListener(
            index: dragIndex,
            child: Tooltip(
              message: l10n.adminHealthTrackingDragToReorder,
              child: Icon(
                Icons.drag_handle,
                size: 18,
                color: context.appColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Active/inactive toggle
          Tooltip(
            message: metric.isActive
                ? l10n.adminHealthTrackingInactiveLabel
                : l10n.adminHealthTrackingActiveLabel,
            child: Switch(
              value: metric.isActive,
              onChanged: (_) => onToggle(),
              activeThumbColor: AppTheme.success,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.displayName,
                  style: AppTheme.body.copyWith(
                    color: metric.isActive
                        ? context.appColors.textPrimary
                        : context.appColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTheme.captions.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
                if (metric.isBaseline)
                  Text(
                    context.l10n.adminHealthTrackingBaselineBadge,
                    style: AppTheme.captions.copyWith(color: AppTheme.info),
                  ),
              ],
            ),
          ),
          // Edit button
          Tooltip(
            message: l10n.adminHealthTrackingEditMetric,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: onEdit,
            ),
          ),
          // Delete (soft-delete) button
          Tooltip(
            message: l10n.commonDelete,
            child: IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size: 18,
                color: AppTheme.error,
              ),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Removed categories section ────────────────────────────────────────────────

class _RemovedCategoriesSection extends StatelessWidget {
  const _RemovedCategoriesSection({
    required this.categories,
    required this.metricsByCategory,
    required this.onRestoreCategory,
    required this.onRestoreMetric,
  });

  final List<TrackingCategory> categories;
  final Map<int, List<TrackingMetric>> metricsByCategory;
  final void Function(TrackingCategory) onRestoreCategory;
  final void Function(TrackingMetric) onRestoreMetric;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: ExcludeSemantics(
            child: Icon(
              Icons.delete_sweep_outlined,
              size: 18,
              color: context.appColors.textMuted,
            ),
          ),
          title: Text(
            l10n.adminHealthTrackingRemovedCategories(categories.length),
            style: AppTheme.body.copyWith(
              color: context.appColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Divider(color: context.appColors.divider, height: 1),
            for (final cat in categories) ...[
              _RemovedCategoryRow(
                category: cat,
                metrics: metricsByCategory[cat.categoryId] ?? [],
                onRestore: () => onRestoreCategory(cat),
                onRestoreMetric: onRestoreMetric,
              ),
              Divider(color: context.appColors.divider, height: 1, indent: 16),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Removed category row ──────────────────────────────────────────────────────

class _RemovedCategoryRow extends StatelessWidget {
  const _RemovedCategoryRow({
    required this.category,
    required this.metrics,
    required this.onRestore,
    required this.onRestoreMetric,
  });

  final TrackingCategory category;
  final List<TrackingMetric> metrics;
  final VoidCallback onRestore;
  final void Function(TrackingMetric) onRestoreMetric;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final deletedMetrics = metrics.where((m) => m.isDeleted).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    category.displayName,
                    style: AppTheme.body.copyWith(
                      color: context.appColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: l10n.adminHealthTrackingRestore,
                child: IconButton(
                  icon: const Icon(
                    Icons.restore,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  onPressed: onRestore,
                ),
              ),
            ],
          ),
          if (deletedMetrics.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final m in deletedMetrics)
                    _RemovedMetricRow(
                      metric: m,
                      onRestore: () => onRestoreMetric(m),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Removed metric row ────────────────────────────────────────────────────────

class _RemovedMetricRow extends StatelessWidget {
  const _RemovedMetricRow({required this.metric, required this.onRestore});

  final TrackingMetric metric;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subtitle = [
      _MetricDialogState._typeLabel(context, metric.metricType),
      if (metric.unit != null) metric.unit!,
      _MetricDialogState._freqLabel(context, metric.frequency),
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Opacity(
              opacity: 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.displayName,
                    style: AppTheme.body.copyWith(
                      color: context.appColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.captions.copyWith(
                      color: context.appColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Tooltip(
            message: l10n.adminHealthTrackingRestore,
            child: IconButton(
              icon: const Icon(
                Icons.restore,
                size: 18,
                color: AppTheme.primary,
              ),
              onPressed: onRestore,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared helper ─────────────────────────────────────────────────────────────

/// Converts a display name to a snake_case key, e.g. "Mental Health" → "mental_health".
String _toSnakeCase(String name) => name
    .trim()
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
    .replaceAll(RegExp(r'\s+'), '_');

// ── Category dialog ───────────────────────────────────────────────────────────

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog({required this.onSave, this.category});

  final TrackingCategory? category;
  final Future<void> Function(Map<String, dynamic> body) onSave;

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  bool _isActive = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category?.displayName ?? '');
    _descCtrl = TextEditingController(text: widget.category?.description ?? '');
    _isActive = widget.category?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEdit = widget.category != null;

    return AlertDialog(
      title: Text(
        isEdit
            ? l10n.adminHealthTrackingEditCategory
            : l10n.adminHealthTrackingAddCategory,
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.adminHealthTrackingNameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? '*' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: InputDecoration(
                  labelText: l10n.adminHealthTrackingDescriptionLabel,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    l10n.adminHealthTrackingActiveLabel,
                    style: AppTheme.body,
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                    activeThumbColor: AppTheme.success,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.commonSave),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final name = _nameCtrl.text.trim();
      await widget.onSave({
        'category_key': widget.category?.categoryKey ?? _toSnakeCase(name),
        'display_name': name,
        'description': _descCtrl.text.trim(),
        'is_active': _isActive,
      });
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.adminHealthTrackingSaveError(e.toString()),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ── Metric dialog ─────────────────────────────────────────────────────────────

class _MetricDialog extends StatefulWidget {
  const _MetricDialog({
    required this.categories,
    required this.onSave,
    this.metric,
    this.initialCategoryId,
  });

  final TrackingMetric? metric;
  final int? initialCategoryId;
  final List<TrackingCategory> categories;
  final Future<void> Function(Map<String, dynamic> body) onSave;

  @override
  State<_MetricDialog> createState() => _MetricDialogState();
}

class _MetricDialogState extends State<_MetricDialog> {
  static const _metricTypes = [
    'number',
    'scale',
    'yesno',
    'single_choice',
    'text',
  ];
  static const _frequencies = ['daily', 'weekly', 'monthly', 'any'];

  static String _typeLabel(BuildContext context, String type) {
    final l10n = context.l10n;
    return switch (type) {
      'number' => l10n.adminHealthTrackingTypeNumber,
      'scale' => l10n.adminHealthTrackingTypeScale,
      'yesno' => l10n.adminHealthTrackingTypeYesno,
      'single_choice' => l10n.adminHealthTrackingTypeSingleChoice,
      'text' => l10n.adminHealthTrackingTypeText,
      _ => type,
    };
  }

  static String _freqLabel(BuildContext context, String freq) {
    final l10n = context.l10n;
    return switch (freq) {
      'daily' => l10n.adminHealthTrackingFreqDaily,
      'weekly' => l10n.adminHealthTrackingFreqWeekly,
      'monthly' => l10n.adminHealthTrackingFreqMonthly,
      'any' => l10n.adminHealthTrackingFreqAny,
      _ => freq,
    };
  }

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _unitCtrl;
  late final TextEditingController _scaleMinCtrl;
  late final TextEditingController _scaleMaxCtrl;
  late String _type;
  late String _frequency;
  late bool _isActive;
  late bool _isBaseline;
  late int? _categoryId;
  late List<TextEditingController> _choiceControllers;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.metric;
    _nameCtrl = TextEditingController(text: m?.displayName ?? '');
    _descCtrl = TextEditingController(text: m?.description ?? '');
    _unitCtrl = TextEditingController(text: m?.unit ?? '');
    _scaleMinCtrl = TextEditingController(text: m?.scaleMin?.toString() ?? '');
    _scaleMaxCtrl = TextEditingController(text: m?.scaleMax?.toString() ?? '');
    _type = m?.metricType ?? 'number';
    _frequency = m?.frequency ?? 'daily';
    _isActive = m?.isActive ?? true;
    _isBaseline = m?.isBaseline ?? false;
    _categoryId = widget.initialCategoryId ?? m?.categoryId;
    _choiceControllers = (m?.choiceOptions ?? [])
        .map((o) => TextEditingController(text: o))
        .toList();
    if (_type == 'single_choice' && _choiceControllers.isEmpty) {
      _choiceControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _unitCtrl.dispose();
    _scaleMinCtrl.dispose();
    _scaleMaxCtrl.dispose();
    for (final c in _choiceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEdit = widget.metric != null;

    return AlertDialog(
      title: Text(
        isEdit
            ? l10n.adminHealthTrackingEditMetric
            : l10n.adminHealthTrackingAddMetric,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category selector
                DropdownButtonFormField<int>(
                  initialValue: _categoryId,
                  decoration: InputDecoration(
                    labelText: l10n.healthTrackingCategory,
                    border: const OutlineInputBorder(),
                  ),
                  items: widget.categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.categoryId,
                          child: Text(c.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _categoryId = v),
                  validator: (v) => v == null ? '*' : null,
                ),
                const SizedBox(height: 12),

                // Name
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.adminHealthTrackingNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? '*' : null,
                ),
                const SizedBox(height: 12),

                // Description
                TextFormField(
                  controller: _descCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.adminHealthTrackingDescriptionLabel,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),

                // Type + frequency row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _type,
                        decoration: InputDecoration(
                          labelText: l10n.adminHealthTrackingTypeLabel,
                          border: const OutlineInputBorder(),
                        ),
                        items: _metricTypes
                            .map(
                              (t) => DropdownMenuItem(value: t, child: Text(_typeLabel(context, t))),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _type = v;
                              if (_type == 'single_choice' &&
                                  _choiceControllers.isEmpty) {
                                _choiceControllers.add(TextEditingController());
                              }
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _frequency,
                        decoration: InputDecoration(
                          labelText: l10n.adminHealthTrackingFrequencyLabel,
                          border: const OutlineInputBorder(),
                        ),
                        items: _frequencies
                            .map(
                              (f) => DropdownMenuItem(value: f, child: Text(_freqLabel(context, f))),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _frequency = v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Unit (for number/scale)
                if (_type == 'number' || _type == 'scale') ...[
                  TextFormField(
                    controller: _unitCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.adminHealthTrackingUnitLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Scale min/max (for scale type)
                if (_type == 'scale') ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _scaleMinCtrl,
                          decoration: InputDecoration(
                            labelText: l10n.adminHealthTrackingScaleMinLabel,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _scaleMaxCtrl,
                          decoration: InputDecoration(
                            labelText: l10n.adminHealthTrackingScaleMaxLabel,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Choice options (for single_choice)
                if (_type == 'single_choice') ...[
                  Text(
                    l10n.adminHealthTrackingChoiceOptionsLabel,
                    style: AppTheme.body.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  for (int i = 0; i < _choiceControllers.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _choiceControllers[i],
                              decoration: InputDecoration(
                                labelText: context.l10n.adminHealthTrackingChoiceOptionLabel(i + 1),
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? '*' : null,
                            ),
                          ),
                          if (_choiceControllers.length > 1) ...[
                            const SizedBox(width: 4),
                            Tooltip(
                              message: context.l10n.commonDelete,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _choiceControllers[i].dispose();
                                    _choiceControllers.removeAt(i);
                                  });
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  AppTextButton(
                    label: l10n.adminHealthTrackingAddOption,
                    onPressed: () => setState(() {
                      _choiceControllers.add(TextEditingController());
                    }),
                  ),
                  const SizedBox(height: 12),
                ],

                // Active + baseline toggles
                Row(
                  children: [
                    Text(
                      l10n.adminHealthTrackingActiveLabel,
                      style: AppTheme.body,
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                      activeThumbColor: AppTheme.success,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        l10n.adminHealthTrackingBaselineLabel,
                        style: AppTheme.captions.copyWith(
                          color: context.appColors.textMuted,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isBaseline,
                      onChanged: (v) => setState(() => _isBaseline = v),
                      activeThumbColor: AppTheme.info,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.commonSave),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final name = _nameCtrl.text.trim();
      final body = <String, dynamic>{
        'category_id': _categoryId,
        'metric_key': widget.metric?.metricKey ?? _toSnakeCase(name),
        'display_name': name,
        'description': _descCtrl.text.trim(),
        'metric_type': _type,
        'frequency': _frequency,
        'is_active': _isActive,
        'is_baseline': _isBaseline,
        if (_unitCtrl.text.isNotEmpty) 'unit': _unitCtrl.text.trim(),
        if (_scaleMinCtrl.text.isNotEmpty)
          'scale_min': int.tryParse(_scaleMinCtrl.text),
        if (_scaleMaxCtrl.text.isNotEmpty)
          'scale_max': int.tryParse(_scaleMaxCtrl.text),
        if (_type == 'single_choice')
          'choice_options': _choiceControllers
              .map((c) => c.text.trim())
              .where((s) => s.isNotEmpty)
              .toList(),
      };
      await widget.onSave(body);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.adminHealthTrackingSaveError(e.toString()),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
