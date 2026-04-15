import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/models.dart';
import 'package:frontend/src/features/admin/pages/messages_page.dart';
import 'package:frontend/src/features/admin/state/account_request_providers.dart';

import '../../../test_helpers.dart';

AccountRequestResponse _accountRequest({
  required int id,
  required String status,
  int roleId = 1,
  String? gender,
  String? genderOther,
  String? birthdate,
  String? adminNotes,
}) {
  return AccountRequestResponse(
    requestId: id,
    firstName: 'First$id',
    lastName: 'Last$id',
    email: 'user$id@example.com',
    roleId: roleId,
    status: status,
    gender: gender,
    genderOther: genderOther,
    birthdate: birthdate,
    adminNotes: adminNotes,
    createdAt: '2026-03-23',
  );
}

DeletionRequestResponse _deletionRequest({
  required int id,
  required String status,
  String? fullName,
  String? adminNotes,
}) {
  return DeletionRequestResponse(
    requestId: id,
    accountId: id + 100,
    fullName: fullName,
    email: 'delete$id@example.com',
    status: status,
    requestedAt: '2026-03-23',
    adminNotes: adminNotes,
  );
}

Widget _buildPage({
  List<AccountRequestResponse>? accountRequests,
  List<DeletionRequestResponse>? deletionRequests,
  Future<List<AccountRequestResponse>> Function()? accountFuture,
  Future<List<DeletionRequestResponse>> Function()? deletionFuture,
  String accountStatus = 'pending',
  String deletionStatus = 'pending',
}) {
  final accountCompleter = Completer<List<AccountRequestResponse>>();
  final deletionCompleter = Completer<List<DeletionRequestResponse>>();

  return buildTestPage(
    const MessagesPage(),
    overrides: [
      accountRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
      deletionRequestCountProvider.overrideWith((ref) => Stream<int>.value(0)),
      accountRequestStatusFilter.overrideWith((ref) => accountStatus),
      deletionRequestStatusFilter.overrideWith((ref) => deletionStatus),
      accountRequestsProvider.overrideWith(
        (ref) => accountFuture != null
            ? accountFuture()
            : Future.value(accountRequests ?? const <AccountRequestResponse>[]),
      ),
      deletionRequestsProvider.overrideWith(
        (ref) => deletionFuture != null
            ? deletionFuture()
            : Future.value(deletionRequests ?? const <DeletionRequestResponse>[]),
      ),
      // Keep these completers alive for loading state tests.
      if (accountFuture == null && accountRequests == null)
        accountRequestsProvider.overrideWith((ref) => accountCompleter.future),
      if (deletionFuture == null && deletionRequests == null)
        deletionRequestsProvider.overrideWith((ref) => deletionCompleter.future),
    ],
  );
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1800, 1200);
  tester.view.devicePixelRatio = 1.0;
}

void _resetViewport(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

Future<void> _switchToDeletionTab(WidgetTester tester) async {
  final tab = find.text('Deletion Requests');
  await tester.ensureVisible(tab);
  await tester.tap(tab);
  await tester.pumpAndSettle();
}

void main() {
  group('MessagesPage', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets('shows new account requests tab by default', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          accountRequests: [
            _accountRequest(
              id: 1,
              status: 'pending',
              roleId: 1,
              birthdate: '2000-01-01',
              gender: 'Other',
              genderOther: 'Non-binary',
              adminNotes: 'Needs manual review',
            ),
          ],
          deletionRequests: const [],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MessagesPage), findsOneWidget);
      expect(find.text('First1 Last1'), findsOneWidget);
      expect(find.text('user1@example.com'), findsOneWidget);
      expect(find.textContaining('Other (Non-binary)'), findsOneWidget);
      expect(find.text('Needs manual review'), findsOneWidget);
      expect(find.text('Participant'), findsOneWidget);
    });

    testWidgets('switches to deletion requests tab', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          accountRequests: const [],
          deletionRequests: [
            _deletionRequest(
              id: 20,
              status: 'pending',
              fullName: 'Delete Me',
              adminNotes: 'Requested by user',
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await _switchToDeletionTab(tester);

      expect(find.text('Delete Me'), findsOneWidget);
      expect(find.text('delete20@example.com'), findsOneWidget);
      expect(find.text('Requested by user'), findsOneWidget);
      expect(find.text('pending'), findsOneWidget);
    });

    testWidgets('shows loading indicator for account requests', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      final completer = Completer<List<AccountRequestResponse>>();
      await tester.pumpWidget(
        _buildPage(
          accountFuture: () => completer.future,
          deletionRequests: const [],
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows account requests empty state', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          accountRequests: const [],
          deletionRequests: const [],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('shows account requests error state', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          accountFuture: () => Future<List<AccountRequestResponse>>.error(
            Exception('network failed'),
          ),
          deletionRequests: const [],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Error loading'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('hides account action buttons when status is not pending',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          accountStatus: 'approved',
          accountRequests: [
            _accountRequest(id: 2, status: 'approved', roleId: 2),
          ],
          deletionRequests: const [],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('First2 Last2'), findsOneWidget);
      expect(find.text('Researcher'), findsOneWidget);
      expect(find.text('Approve'), findsNothing);
      expect(find.text('Reject'), findsNothing);
    });

    testWidgets('shows unknown role label for unsupported role id',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          accountRequests: [
            _accountRequest(id: 3, status: 'pending', roleId: 99),
          ],
          deletionRequests: const [],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unknown'), findsOneWidget);
    });

    testWidgets('shows deletion requests empty state', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          accountRequests: const [],
          deletionRequests: const [],
        ),
      );
      await tester.pumpAndSettle();

      await _switchToDeletionTab(tester);

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('shows deletion requests error state', (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          accountRequests: const [],
          deletionFuture: () => Future<List<DeletionRequestResponse>>.error(
            Exception('delete fetch failed'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _switchToDeletionTab(tester);

      expect(find.textContaining('Error loading'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows deletion card fallback name and hides actions for approved',
        (tester) async {
      _setDesktopViewport(tester);
      addTearDown(() => _resetViewport(tester));

      await tester.pumpWidget(
        _buildPage(
          accountRequests: const [],
          deletionStatus: 'approved',
          deletionRequests: [
            _deletionRequest(
              id: 30,
              status: 'approved',
              fullName: null,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await _switchToDeletionTab(tester);

      expect(find.text('—'), findsOneWidget);
      expect(find.text('approved'), findsOneWidget);
      expect(find.text('Approve'), findsNothing);
      expect(find.text('Reject'), findsNothing);
    });
  });
}
