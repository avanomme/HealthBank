import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/messaging/state/messaging_providers.dart';
import 'package:frontend/src/features/question_bank/pages/question_bank_page.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart';
import 'package:frontend/src/features/templates/pages/template_builder_page.dart';
import 'package:frontend/src/features/templates/state/template_providers.dart';

import '../../test_helpers.dart';

class _TestTemplateBuilderNotifier extends TemplateBuilderNotifier {
  _TestTemplateBuilderNotifier(
    super.ref, {
    this.initialState = const TemplateBuilderState(),
    this.skipReset = true,
    this.saveResult,
  }) {
    state = initialState;
  }

  final TemplateBuilderState initialState;
  final bool skipReset;
  final Template? saveResult;

  int resetCalls = 0;
  int saveCalls = 0;
  int? lastLoadedTemplateId;

  @override
  void reset() {
    resetCalls++;
    if (!skipReset) {
      super.reset();
    }
  }

  @override
  Future<void> loadTemplate(int templateId) async {
    lastLoadedTemplateId = templateId;
    state = TemplateBuilderState(
      templateId: templateId,
      title: 'Loaded Template',
      description: 'Loaded description',
      isPublic: true,
      questions: const [
        TemplateQuestionItem(
          questionId: 7,
          title: 'Loaded Question',
          questionContent: 'Loaded content',
          responseType: 'openended',
          isRequired: false,
        ),
      ],
    );
  }

  @override
  Future<Template?> save() async {
    saveCalls++;
    return saveResult;
  }
}

final _messagingOverrides = [
  incomingFriendRequestsProvider.overrideWith((ref) => Future.value([])),
  conversationsProvider.overrideWith((ref) async => []),
];

Question _question(
  int id,
  String questionContent, {
  String? title,
  String responseType = 'openended',
}) {
  return Question(
    questionId: id,
    title: title,
    questionContent: questionContent,
    responseType: responseType,
    isRequired: false,
  );
}

Template _template({int id = 1, String title = 'Saved Template'}) {
  return Template(
    templateId: id,
    title: title,
    isPublic: false,
    description: 'saved description',
    questions: const [],
  );
}

void main() {
  group('TemplateBuilderPage widget behavior', () {
    testWidgets('create mode initializes by calling reset', (tester) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(ref, skipReset: true);
              return notifier;
            }),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(notifier.resetCalls, 1);
      expect(notifier.lastLoadedTemplateId, isNull);
    });

    testWidgets('edit mode initializes by loading template id', (tester) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateBuilderPage(templateId: 42),
          overrides: [
            ..._messagingOverrides,
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(notifier.lastLoadedTemplateId, 42);
      expect(find.text('Loaded Template'), findsOneWidget);
      expect(find.byType(ReorderableListView), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading and no questions', (
      tester,
    ) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(
                ref,
                initialState: const TemplateBuilderState(isLoading: true),
              );
              return notifier;
            }),
          ],
        ),
      );

      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      expect(notifier.saveCalls, 0);
    });

    testWidgets('does not save when form is invalid', (tester) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppFilledButton).first);
      await tester.pumpAndSettle();

      expect(notifier.saveCalls, 0);
      expect(find.textContaining('required'), findsWidgets);
    });

    testWidgets('saves when form is valid', (tester) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(
                ref,
                saveResult: _template(),
              );
              return notifier;
            }),
          ],
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'My Template');
      await tester.pump();

      await tester.tap(find.byType(AppFilledButton).first);
      await tester.pumpAndSettle();

      expect(notifier.saveCalls, 1);
    });

    testWidgets('error banner can be dismissed', (tester) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(
                ref,
                initialState: const TemplateBuilderState(
                  errorMessage: 'Something went wrong',
                ),
              );
              return notifier;
            }),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsNothing);
      expect(notifier.state.errorMessage, isNull);
    });

    testWidgets('remove icon removes a question tile', (tester) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(
                ref,
                initialState: const TemplateBuilderState(
                  questions: [
                    TemplateQuestionItem(
                      questionId: 1,
                      title: 'Question A',
                      questionContent: 'Question A content',
                      responseType: 'openended',
                      isRequired: false,
                    ),
                    TemplateQuestionItem(
                      questionId: 2,
                      title: 'Question B',
                      questionContent: 'Question B content',
                      responseType: 'yesno',
                      isRequired: false,
                    ),
                  ],
                ),
              );
              return notifier;
            }),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Question A'), findsOneWidget);
      expect(notifier.state.questions.length, 2);

      await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
      await tester.pumpAndSettle();

      expect(find.text('Question A'), findsNothing);
      expect(notifier.state.questions.length, 1);
      expect(notifier.state.questions.single.questionId, 2);
    });

    testWidgets('reorder callback updates question order', (tester) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(
                ref,
                initialState: const TemplateBuilderState(
                  questions: [
                    TemplateQuestionItem(
                      questionId: 10,
                      title: 'First Question',
                      questionContent: 'First content',
                      responseType: 'openended',
                      isRequired: false,
                    ),
                    TemplateQuestionItem(
                      questionId: 11,
                      title: 'Second Question',
                      questionContent: 'Second content',
                      responseType: 'openended',
                      isRequired: false,
                    ),
                  ],
                ),
              );
              return notifier;
            }),
          ],
        ),
      );

      await tester.pumpAndSettle();

      final listView = tester.widget<ReorderableListView>(
        find.byType(ReorderableListView),
      );
      listView.onReorder(0, 2);
      await tester.pumpAndSettle();

      expect(notifier.state.questions.first.questionId, 11);
      expect(notifier.state.questions.last.questionId, 10);
    });

    testWidgets('add questions flow merges selected questions and skips duplicates', (
      tester,
    ) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          const TemplateBuilderPage(),
          overrides: [
            ..._messagingOverrides,
            questionsProvider.overrideWith((ref) async => [
              _question(1, 'Existing content', title: 'Existing question'),
              _question(2, 'Second from bank content', title: 'Second from bank'),
            ]),
            questionCategoriesProvider.overrideWith((ref) async => const []),
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(
                ref,
                initialState: const TemplateBuilderState(
                  questions: [
                    TemplateQuestionItem(
                      questionId: 1,
                      title: 'Existing question',
                      questionContent: 'Existing content',
                      responseType: 'openended',
                      isRequired: false,
                    ),
                  ],
                ),
              );
              return notifier;
            }),
          ],
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(AppFilledButton, 'Add Questions'));
      await tester.pumpAndSettle();

      expect(find.byType(QuestionBankPage), findsOneWidget);

      final qbContext = tester.element(find.byType(QuestionBankPage));
      Navigator.of(qbContext).pop([
        _question(1, 'Existing content', title: 'Existing question'),
        _question(2, 'Second from bank content', title: 'Second from bank'),
      ]);
      await tester.pumpAndSettle();

      expect(find.byType(QuestionBankPage), findsNothing);
      expect(notifier.state.questions.length, 2);
      expect(notifier.state.questions.map((q) => q.questionId).toList(), [1, 2]);
    });

    testWidgets('back button pops the current route', (tester) async {
      late _TestTemplateBuilderNotifier notifier;

      await tester.pumpWidget(
        buildTestPage(
          Navigator(
            initialRoute: '/builder',
            onGenerateRoute: (settings) {
              if (settings.name == '/builder') {
                return MaterialPageRoute<void>(
                  builder: (_) => const TemplateBuilderPage(),
                  settings: settings,
                );
              }

              return MaterialPageRoute<void>(
                builder: (_) => const Scaffold(
                  body: Center(child: Text('Root Page')),
                ),
                settings: settings,
              );
            },
          ),
          overrides: [
            ..._messagingOverrides,
            templateBuilderProvider.overrideWith((ref) {
              notifier = _TestTemplateBuilderNotifier(ref);
              return notifier;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TemplateBuilderPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Root Page'), findsOneWidget);
      expect(notifier.resetCalls, 1);
    });
  });
}
