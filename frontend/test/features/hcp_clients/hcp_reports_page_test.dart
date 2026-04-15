import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/impersonation.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/hcp_clients/pages/hcp_reports_page.dart';
import 'package:frontend/src/features/hcp_clients/state/hcp_providers.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart';

import '../../test_helpers.dart';

final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

final _sessionOverride = participantSessionProvider.overrideWith(
  (ref) async => const SessionMeResponse(
    user: SessionUserInfo(
      accountId: 7,
      email: 'hcp@example.com',
      role: 'hcp',
      roleId: 3,
      firstName: 'Hana',
      lastName: 'Care',
    ),
    isImpersonating: false,
    sessionExpiresAt: '2099-01-01T00:00:00Z',
  ),
);

Widget _buildPage({List<Override>? overrides}) {
  return buildTestPage(
    const HcpReportsPage(),
    overrides: [
      ..._messagingOverrides,
      _sessionOverride,
      ...(overrides ?? const []),
    ],
  );
}

Future<void> _selectDropdownItem(
  WidgetTester tester,
  Finder dropdown,
  String itemText,
) async {
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text(itemText).last);
  await tester.pumpAndSettle();
}

Future<void> _selectDropdownItemNoSettle(
  WidgetTester tester,
  Finder dropdown,
  String itemText,
) async {
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text(itemText).last);
  await tester.pump();
}

void main() {
  group('HcpReportsPage coverage', () {
    testWidgets('shows loading while patients are fetched', (tester) async {
      final completer = Completer<List<Map<String, dynamic>>>();

      await tester.pumpWidget(_buildPage(
        overrides: [
          hcpPatientsProvider.overrideWith((ref) => completer.future),
        ],
      ));
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows error state when patients fail to load', (tester) async {
      await tester.pumpWidget(_buildPage(
        overrides: [
          hcpPatientsProvider.overrideWith(
            (ref) => Future<List<Map<String, dynamic>>>.error(Exception('fail')),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Failed to load report data.'), findsOneWidget);
    });

    testWidgets('shows empty state when there are no patients', (tester) async {
      await tester.pumpWidget(_buildPage(
        overrides: [
          hcpPatientsProvider.overrideWith((ref) async => const []),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('No linked patients to report on.'), findsOneWidget);
      expect(find.text('Select a patient and survey to view the report.'), findsOneWidget);
    });

    testWidgets('shows patient picker and no-selection prompt by default',
        (tester) async {
      await tester.pumpWidget(_buildPage(
        overrides: [
          hcpPatientsProvider.overrideWith(
            (ref) async => [
              {'patient_id': 1, 'patient_name': 'Alice'},
            ],
          ),
          hcpPatientSurveysProvider(1).overrideWith((ref) async => const []),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Select a Patient'), findsOneWidget);
      expect(find.text('Select a patient and survey to view the report.'), findsOneWidget);
    });

    testWidgets('shows no surveys after selecting a patient with none',
        (tester) async {
      await tester.pumpWidget(_buildPage(
        overrides: [
          hcpPatientsProvider.overrideWith(
            (ref) async => [
              {'patient_id': 2, 'patient_name': 'No Surveys'},
            ],
          ),
          hcpPatientSurveysProvider(2).overrideWith((ref) async => const []),
        ],
      ));
      await tester.pumpAndSettle();

      await _selectDropdownItem(
        tester,
        find.byType(DropdownButtonFormField<int>).first,
        'No Surveys',
      );

      expect(find.text('This patient has no completed surveys.'), findsOneWidget);
    });

    testWidgets('shows loading message while responses are fetched',
        (tester) async {
      final responseCompleter = Completer<List<Map<String, dynamic>>>();

      await tester.pumpWidget(_buildPage(
        overrides: [
          hcpPatientsProvider.overrideWith(
            (ref) async => [
              {'patient_id': 10, 'patient_name': 'Loading Patient'},
            ],
          ),
          hcpPatientSurveysProvider(10).overrideWith(
            (ref) async => [
              {'survey_id': 11, 'title': 'Baseline Survey'},
            ],
          ),
          hcpPatientResponsesProvider((patientId: 10, surveyId: 11)).overrideWith(
            (ref) => responseCompleter.future,
          ),
        ],
      ));
      await tester.pumpAndSettle();

      await _selectDropdownItem(
        tester,
        find.byType(DropdownButtonFormField<int>).first,
        'Loading Patient',
      );
      await _selectDropdownItemNoSettle(
        tester,
        find.byType(DropdownButtonFormField<int>).last,
        'Baseline Survey',
      );

      await tester.pump();

      expect(find.text('Loading report...'), findsOneWidget);
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows responses error state', (tester) async {
      await tester.pumpWidget(_buildPage(
        overrides: [
          hcpPatientsProvider.overrideWith(
            (ref) async => [
              {'patient_id': 20, 'patient_name': 'Error Patient'},
            ],
          ),
          hcpPatientSurveysProvider(20).overrideWith(
            (ref) async => [
              {'survey_id': 21, 'title': 'Error Survey'},
            ],
          ),
          hcpPatientResponsesProvider((patientId: 20, surveyId: 21)).overrideWith(
            (ref) => Future<List<Map<String, dynamic>>>.error(Exception('x')),
          ),
        ],
      ));
      await tester.pumpAndSettle();

      await _selectDropdownItem(
        tester,
        find.byType(DropdownButtonFormField<int>).first,
        'Error Patient',
      );
      await _selectDropdownItem(
        tester,
        find.byType(DropdownButtonFormField<int>).last,
        'Error Survey',
      );

      expect(find.text('Failed to load report data.'), findsOneWidget);
    });

    testWidgets('shows empty responses state', (tester) async {
      await tester.pumpWidget(_buildPage(
        overrides: [
          hcpPatientsProvider.overrideWith(
            (ref) async => [
              {'patient_id': 30, 'patient_name': 'No Responses'},
            ],
          ),
          hcpPatientSurveysProvider(30).overrideWith(
            (ref) async => [
              {'survey_id': 31, 'title': 'No Response Survey'},
            ],
          ),
          hcpPatientResponsesProvider((patientId: 30, surveyId: 31)).overrideWith(
            (ref) async => const [],
          ),
        ],
      ));
      await tester.pumpAndSettle();

      await _selectDropdownItem(
        tester,
        find.byType(DropdownButtonFormField<int>).first,
        'No Responses',
      );
      await _selectDropdownItem(
        tester,
        find.byType(DropdownButtonFormField<int>).last,
        'No Response Survey',
      );

      expect(find.text('No completed surveys.'), findsOneWidget);
    });

    testWidgets('renders response rows with fallback values and type chips',
        (tester) async {
      await tester.pumpWidget(_buildPage(
        overrides: [
          hcpPatientsProvider.overrideWith(
            (ref) async => [
              {'patient_id': 40, 'patient_name': 'Data Patient'},
            ],
          ),
          hcpPatientSurveysProvider(40).overrideWith(
            (ref) async => [
              {'survey_id': 41, 'survey_title': 'Fallback Survey Title'},
            ],
          ),
          hcpPatientResponsesProvider((patientId: 40, surveyId: 41)).overrideWith(
            (ref) async => [
              {
                'question_content': 'Height?',
                'response_type': 'number',
                'response_value': '180',
              },
              {
                'question_content': 'Do you smoke?',
                'response_type': 'yesno',
                'response_value': 'No',
              },
              {
                'question_content': 'Favorite fruit',
                'response_type': 'single_choice',
                'response_value': 'Apple',
              },
              {
                'question_content': 'Notes',
                'response_type': 'openended',
                'response_value': '—',
              },
              {
                'question_content': 'Unknown type question',
                'response_type': 'mystery',
              },
            ],
          ),
        ],
      ));
      await tester.pumpAndSettle();

      await _selectDropdownItem(
        tester,
        find.byType(DropdownButtonFormField<int>).first,
        'Data Patient',
      );
      await _selectDropdownItem(
        tester,
        find.byType(DropdownButtonFormField<int>).last,
        'Fallback Survey Title',
      );

      expect(find.text('Fallback Survey Title'), findsAtLeast(1));
      expect(find.text('Height?'), findsOneWidget);
      expect(find.text('Do you smoke?'), findsOneWidget);
      expect(find.text('Favorite fruit'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Unknown type question'), findsOneWidget);

      expect(find.text('number'), findsOneWidget);
      expect(find.text('yesno'), findsOneWidget);
      expect(find.text('single_choice'), findsOneWidget);
      expect(find.text('openended'), findsOneWidget);
      expect(find.text('mystery'), findsOneWidget);

      expect(find.text('180'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('—'), findsAtLeast(1));
    });
  });
}
