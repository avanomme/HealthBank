// Created with the Assistance of Claude Code
// frontend/lib/src/features/admin/state/health_tracking_admin_providers.dart
/// Riverpod providers for the admin health tracking settings page.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/health_tracking.dart';
import 'package:frontend/src/core/api/services/health_tracking_api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

/// Provider for the HealthTrackingApi service (admin uses same service).
final healthTrackingAdminApiProvider = Provider<HealthTrackingApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return HealthTrackingApi(client.dio);
});

/// All categories for the admin settings page.
final adminTrackingCategoriesProvider =
    FutureProvider<List<TrackingCategory>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingAdminApiProvider);
  return api.getAdminCategories();
});

/// All metrics for the admin settings page (flat list with categoryId).
final adminTrackingMetricsProvider =
    FutureProvider<List<TrackingMetric>>((ref) async {
  ref.watch(sessionKeyProvider);
  final api = ref.watch(healthTrackingAdminApiProvider);
  return api.getAdminMetrics();
});
