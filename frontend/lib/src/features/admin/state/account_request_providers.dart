// Created with the Assistance of Claude Code
// frontend/lib/features/admin/state/account_request_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

/// Provider for the AdminApi service
final adminApiProvider = Provider<AdminApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return AdminApi(client.dio);
});

/// Current filter tab for account requests
final accountRequestStatusFilter = StateProvider<String>((ref) => 'pending');

/// Provider for fetching account requests filtered by status.
/// autoDispose ensures fresh data is fetched every time the page is opened.
final accountRequestsProvider =
    FutureProvider.autoDispose<List<AccountRequestResponse>>((ref) async {
  final api = ref.watch(adminApiProvider);
  final status = ref.watch(accountRequestStatusFilter);
  return api.getAccountRequests(status: status);
});

/// Provider for the pending account request count (used for sidebar badge).
/// Polls every 30 seconds so the badge updates without a full page reload.
final accountRequestCountProvider = StreamProvider.autoDispose<int>((ref) async* {
  final api = ref.watch(adminApiProvider);

  Future<int> fetch() async {
    final response = await api.getAccountRequestCount();
    return response.count;
  }

  yield await fetch();

  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    yield await fetch();
  }
});

// ---------------------------------------------------------------------------
// Deletion Request Providers
// ---------------------------------------------------------------------------

/// Current filter tab for deletion requests
final deletionRequestStatusFilter = StateProvider<String>((ref) => 'pending');

/// Provider for fetching user-submitted deletion requests filtered by status.
final deletionRequestsProvider =
    FutureProvider.autoDispose<List<DeletionRequestResponse>>((ref) async {
  final api = ref.watch(adminApiProvider);
  final status = ref.watch(deletionRequestStatusFilter);
  return api.getDeletionRequests(status: status);
});

/// Provider for the pending deletion request count (sidebar badge + dashboard).
final deletionRequestCountProvider = StreamProvider.autoDispose<int>((ref) async* {
  final api = ref.watch(adminApiProvider);

  Future<int> fetch() async {
    final response = await api.getDeletionRequestCount();
    return response.count;
  }

  yield await fetch();

  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    yield await fetch();
  }
});

/// Provider for admin dashboard statistics.
/// Uses Dio directly because Retrofit can't handle Map<String, dynamic> return types.
final adminDashboardStatsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final client = ref.watch(apiClientProvider);
  final resp = await client.dio.get<Map<String, dynamic>>('/admin/dashboard/stats');
  return resp.data ?? {};
});
