// Created with the Assistance of Codex
/// Riverpod providers for the participant dashboard data layer.
///
/// Provider chain: apiClientProvider → auth/assignment/user APIs → dashboard data.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart'
    show sessionKeyProvider;
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;
import 'package:frontend/src/features/messaging/state/messaging_providers.dart'
    show messagingUnreadCountProvider;

/// Lightweight profile model for participant-facing views.
class ParticipantProfile {
  const ParticipantProfile({
    required this.accountId,
    required this.email,
    this.firstName,
    this.lastName,
  });

  final int accountId;
  final String email;
  final String? firstName;
  final String? lastName;

  /// Best-effort display name with fallbacks.
  String get displayName {
    final parts = [firstName, lastName]
        .where((part) => part != null && part.trim().isNotEmpty)
        .map((part) => part!.trim())
        .toList();
    return parts.isNotEmpty ? parts.join(' ') : email;
  }
}

/// Provider for AuthApi service.
final participantAuthApiProvider = Provider<AuthApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthApi(client.dio);
});

/// Provider for AssignmentApi service.
final participantAssignmentApiProvider = Provider<AssignmentApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return AssignmentApi(client.dio);
});

/// Provider for UserApi service.
final participantUserApiProvider = Provider<UserApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return UserApi(client.dio);
});

/// Provider for SurveyApi service (optional for task enrichment).
final participantSurveyApiProvider = Provider<SurveyApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return SurveyApi(client.dio);
});

/// Provider for current session data.
final participantSessionProvider = FutureProvider<SessionMeResponse>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(participantAuthApiProvider);
  return api.getSessionInfo();
});

/// Provider for participant profile details with name fallback via UserApi.
final participantProfileProvider = FutureProvider<ParticipantProfile>((ref) async {
  final session = await ref.watch(participantSessionProvider.future);
  final viewingAs = session.viewingAs;

  final accountId = viewingAs?.userId ?? session.user.accountId;
  final email = viewingAs?.email ?? session.user.email;
  var firstName = viewingAs?.firstName ?? session.user.firstName;
  var lastName = viewingAs?.lastName ?? session.user.lastName;

  if ((firstName == null || lastName == null) && accountId > 0) {
    final api = ref.watch(participantUserApiProvider);
    final user = await api.getUser(accountId);
    firstName = user.firstName;
    lastName = user.lastName;
  }

  return ParticipantProfile(
    accountId: accountId,
    email: email,
    firstName: firstName,
    lastName: lastName,
  );
});

/// Provider for participant assignments.
final participantAssignmentsProvider =
    FutureProvider<List<MyAssignment>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(participantAssignmentApiProvider);
  return api.getMyAssignments();
});

/// Provider for HcpLinkApi service.
final hcpLinkApiProvider = Provider<HcpLinkApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return HcpLinkApi(client.dio);
});

/// Provider for current user's HCP links.
final hcpLinksProvider = FutureProvider<List<HcpLink>>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  final api = ref.watch(hcpLinkApiProvider);
  return api.getMyLinks();
});

/// Provider for consent status — true if user's consent is current (no action needed).
final participantConsentStatusProvider = FutureProvider.autoDispose<bool>((ref) async {
  ref.watch(sessionKeyProvider); // re-fetch when session changes
  try {
    final client = ref.watch(apiClientProvider);
    final consentApi = ConsentApi(client.dio);
    final status = await consentApi.getConsentStatus();
    return !status.needsConsent;
  } catch (_) {
    return true; // assume OK if unable to check
  }
});

/// Provider for whether the participant profile is complete (has first+last name).
final participantProfileCompleteProvider = Provider<bool>((ref) {
  final profileAsync = ref.watch(participantProfileProvider);
  return profileAsync.maybeWhen(
    data: (profile) =>
        profile.firstName != null &&
        profile.firstName!.trim().isNotEmpty &&
        profile.lastName != null &&
        profile.lastName!.trim().isNotEmpty,
    orElse: () => true, // assume complete while loading
  );
});

/// Provider for unread notification counts (HCP link requests + profile/consent alerts + messaging).
final participantNotificationCountProvider = Provider<int>((ref) {
  final linksAsync = ref.watch(hcpLinksProvider);
  final profileComplete = ref.watch(participantProfileCompleteProvider);
  final consentAsync = ref.watch(participantConsentStatusProvider);
  final unreadMessages = ref.watch(messagingUnreadCountProvider);

  int count = 0;
  if (!profileComplete) count++;
  consentAsync.whenData((isCurrent) {
    if (!isCurrent) count++;
  });
  linksAsync.whenData((links) {
    count += links
        .where((l) => l.status == 'pending' && l.requestedBy == 'hcp')
        .length;
  });
  count += unreadMessages;
  return count;
});
