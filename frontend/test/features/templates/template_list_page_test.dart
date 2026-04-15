import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/researcher/widgets/researcher_scaffold.dart';
import 'package:frontend/src/features/templates/pages/template_builder_page.dart';
import 'package:frontend/src/features/templates/pages/template_list_page.dart';
import 'package:frontend/src/features/templates/state/template_providers.dart';

import '../../test_helpers.dart';

class _TestTemplateBuilderNotifier extends TemplateBuilderNotifier {
  _TestTemplateBuilderNotifier(super.ref) {
    state = const TemplateBuilderState();
  }

  int resetCalls = 0;
  int? lastLoadedTemplateId;

  @override
  void reset() {
    resetCalls++;
  }

  @override
  Future<void> loadTemplate(int templateId) async {
    lastLoadedTemplateId = templateId;
    state = TemplateBuilderState(
      templateId: templateId,
      title: 'Loaded from list',
      isLoading: false,
    );
  }
}

class _TestTemplateFiltersNotifier extends TemplateFiltersNotifier {
  _TestTemplateFiltersNotifier([TemplateFilters initial = const TemplateFilters()])
      : super() {
    state = initial;
  }
}

final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

Template _template(int id, String title, {bool isPublic = false, String? description}) {
  return Template(
    templateId: id,
    title: title,
    isPublic: isPublic,
    description: description,
    questionCount: 2,
    questions: const [],
  );
}

void main() {
  group('TemplateListPage', () {
    testWidgets('renders list in normal mode with researcher scaffold', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const TemplateListPage(),
          overrides: [
            ..._messagingOverrides,
            templatesProvider.overrideWith(
              (ref) async => [_template(1, 'Template Alpha', isPublic: true)],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ResearcherScaffold), findsOneWidget);
      expect(find.text('Template Alpha'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('renders simple scaffold in selection mode and hides researcher scaffold', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestPage(
          const TemplateListPage(selectionMode: true),
          overrides: [
            ..._messagingOverrides,
            templatesProvider.overrideWith(
              (ref) async => [_template(1, 'Selection Template')],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(ResearcherScaffold), findsNothing);
      expect(find.text('Selection Template'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('selection mode taps call onTemplateSelected callback', (tester) async {
      Template? selected;

      await tester.pumpWidget(
        buildTestPage(
          TemplateListPage(
            selectionMode: true,
            onTemplateSelected: (template) {
              selected = template;
            },
          ),
          overrides: [
            ..._messagingOverrides,
            templatesProvider.overrideWith(
              (ref) async => [_template(8, 'Pick Me')],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pick Me'));
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.templateId, 8);
    });

    testWidgets('shows loading indicator while templates are loading', (tester) async {
      final completer = Completer<List<Template>>();

      await tester.pumpWidget(
        buildTestPage(
          const TemplateListPage(),
          overrides: [
            ..._messagingOverrides,
            templatesProvider.overrideWith(
              (ref) => completer.future,
            ),
          ],
        ),
      );

      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows error state when provider fails', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const TemplateListPage(),
          overrides: [
            ..._messagingOverrides,
            templatesProvider.overrideWith(
              (ref) async => throw Exception('boom'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load templates'), findsOneWidget);
      expect(find.textContaining('boom'), findsOneWidget);
      expect(find.widgetWithText(AppFilledButton, 'Retry'), findsOneWidget);
    });

    testWidgets('shows empty state action for no templates and no filters', (tester) async {
      await tester.pumpWidget(
        buildTestPage(
          const TemplateListPage(),
          overrides: [
            ..._messagingOverrides,
            templatesProvider.overrideWith((ref) async => <Template>[]),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
      expect(find.widgetWithText(AppFilledButton, 'Create Template'), findsOneWidget);
    });

    testWidgets('shows filtered empty state and can clear filters', (tester) async {
      late _TestTemplateFiltersNotifier filtersNotifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateListPage(),
          overrides: [
            ..._messagingOverrides,
            templatesProvider.overrideWith((ref) async => <Template>[]),
            templateFiltersProvider.overrideWith((ref) {
              filtersNotifier = _TestTemplateFiltersNotifier(
                const TemplateFilters(isPublic: true, searchQuery: 'alpha'),
              );
              return filtersNotifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.widgetWithText(AppTextButton, 'Clear All'), findsOneWidget);

      await tester.tap(find.widgetWithText(AppTextButton, 'Clear All'));
      await tester.pumpAndSettle();

      expect(filtersNotifier.state.isPublic, isNull);
      expect(filtersNotifier.state.searchQuery, isEmpty);
    });

    testWidgets('search field updates template filter query', (tester) async {
      late _TestTemplateFiltersNotifier filtersNotifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateListPage(),
          overrides: [
            ..._messagingOverrides,
            templatesProvider.overrideWith((ref) async => <Template>[]),
            templateFiltersProvider.overrideWith((ref) {
              filtersNotifier = _TestTemplateFiltersNotifier();
              return filtersNotifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'heart');
      await tester.pump();

      expect(filtersNotifier.state.searchQuery, 'heart');
    });

    testWidgets('tapping template in normal mode navigates to builder page', (tester) async {
      late _TestTemplateBuilderNotifier builderNotifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateListPage(),
          overrides: [
            ..._messagingOverrides,
            templatesProvider.overrideWith(
              (ref) async => [_template(42, 'Editable Template')],
            ),
            templateBuilderProvider.overrideWith((ref) {
              builderNotifier = _TestTemplateBuilderNotifier(ref);
              return builderNotifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Editable Template'));
      await tester.pumpAndSettle();

      expect(find.byType(TemplateBuilderPage), findsOneWidget);
      expect(builderNotifier.lastLoadedTemplateId, 42);
    });
  });
}
