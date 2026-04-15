import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/models/research.dart';
import 'package:frontend/src/features/researcher/state/research_providers.dart';

class DashboardSummary {
  DashboardSummary({
    required this.activeCount,
    required this.completedCount,
    required this.otherCount,
    required this.totalSurveys,
    required this.totalRespondents,
    required this.avgCompletionRate,
    required this.suppressed,
    required this.reason,
    required this.minResponses,
    required this.surveys,
    required this.topSurveysByResponses,
    required this.statusBuckets,
  });

  final int activeCount;
  final int completedCount;
  final int otherCount;
  final int totalSurveys;

  final int totalRespondents;
  final double avgCompletionRate;
  final bool suppressed;
  final String? reason;
  final int minResponses;

  final List<ResearchSurvey> surveys;
  final List<ResearchSurvey> topSurveysByResponses;

  /// Labels -> counts (e.g. Active/Completed/Other)
  final Map<String, int> statusBuckets;
}

/// Defensive status parsing because your research endpoint currently exposes
/// `publication_status` but your app also has a separate survey `status`.
/// We bucket whatever string we get into Active/Completed/Other.
enum _SurveyBucket { active, completed, other }

_SurveyBucket _bucketFromStatusString(String raw) {
  final s = raw.trim().toLowerCase();

  // If your DB is returning "status" values:
  if (s == 'in-progress' || s == 'not-started') return _SurveyBucket.active;
  if (s == 'complete' || s == 'cancelled') return _SurveyBucket.completed;

  // If your DB is returning CRUD publication_status values:
  if (s == 'published' || s == 'draft') return _SurveyBucket.active;
  if (s == 'closed') return _SurveyBucket.completed;

  return _SurveyBucket.other;
}

final researcherDashboardSummaryProvider =
    FutureProvider<DashboardSummary>((ref) async {
  final surveys = await ref.watch(researchSurveysProvider.future);

  // Cross-survey overview with no filters = global rollup
  final overview = await ref.watch(crossSurveyOverviewProvider.future);

  int active = 0;
  int completed = 0;
  int other = 0;

  for (final s in surveys) {
    final bucket = _bucketFromStatusString(s.publicationStatus);
    switch (bucket) {
      case _SurveyBucket.active:
        active++;
        break;
      case _SurveyBucket.completed:
        completed++;
        break;
      case _SurveyBucket.other:
        other++;
        break;
    }
  }

  final sortedByResponses = [...surveys]
    ..sort((a, b) => b.responseCount.compareTo(a.responseCount));

  final top = sortedByResponses.take(6).toList();

  return DashboardSummary(
    activeCount: active,
    completedCount: completed,
    otherCount: other,
    totalSurveys: surveys.length,
    totalRespondents: overview.totalRespondentCount,
    avgCompletionRate: overview.avgCompletionRate,
    suppressed: overview.suppressed,
    reason: overview.reason,
    minResponses: overview.minResponses,
    surveys: surveys,
    topSurveysByResponses: top,
    statusBuckets: {
      'Active': active,
      'Completed': completed,
      'Other': other,
    },
  );
});