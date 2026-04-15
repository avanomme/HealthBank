// Created with the Assistance of Claude Code
// frontend/test/core/api/models/api_models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/api.dart';

void main() {
  group('Auth Models', () {
    group('LoginRequest', () {
      test('creates instance with required fields', () {
        const request = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(request.email, 'test@example.com');
        expect(request.password, 'password123');
      });

      test('serializes to JSON correctly', () {
        const request = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
        );

        final json = request.toJson();

        expect(json['email'], 'test@example.com');
        expect(json['password'], 'password123');
      });

      test('deserializes from JSON correctly', () {
        final json = {
          'email': 'test@example.com',
          'password': 'password123',
        };

        final request = LoginRequest.fromJson(json);

        expect(request.email, 'test@example.com');
        expect(request.password, 'password123');
      });

      test('equality works correctly', () {
        const request1 = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
        );
        const request2 = LoginRequest(
          email: 'test@example.com',
          password: 'password123',
        );
        const request3 = LoginRequest(
          email: 'other@example.com',
          password: 'password123',
        );

        expect(request1, equals(request2));
        expect(request1, isNot(equals(request3)));
      });
    });

    group('LoginResponse', () {
      test('creates instance with required fields', () {
        const response = LoginResponse(
          expiresAt: '2025-01-01T00:00:00Z',
          accountId: 1,
        );

        expect(response.expiresAt, '2025-01-01T00:00:00Z');
        expect(response.accountId, 1);
      });

      test('creates instance with all fields', () {
        const response = LoginResponse(
          expiresAt: '2025-01-01T00:00:00Z',
          accountId: 1,
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          role: 'participant',
        );

        expect(response.firstName, 'John');
        expect(response.lastName, 'Doe');
        expect(response.email, 'john@example.com');
        expect(response.role, 'participant');
      });

      test('deserializes from JSON with snake_case keys', () {
        final json = {
          'expires_at': '2025-01-01T00:00:00Z',
          'account_id': 1,
          'first_name': 'John',
          'last_name': 'Doe',
          'email': 'john@example.com',
          'role': 'admin',
        };

        final response = LoginResponse.fromJson(json);

        expect(response.accountId, 1);
        expect(response.firstName, 'John');
        expect(response.lastName, 'Doe');
        expect(response.role, 'admin');
      });

      test('fullName extension returns combined name', () {
        const response = LoginResponse(
          expiresAt: '2025-01-01',
          accountId: 1,
          firstName: 'John',
          lastName: 'Doe',
        );

        expect(response.fullName, 'John Doe');
      });

      test('fullName extension handles null first name', () {
        const response = LoginResponse(
          expiresAt: '2025-01-01',
          accountId: 1,
          lastName: 'Doe',
        );

        expect(response.fullName, 'Doe');
      });

      test('fullName extension handles null last name', () {
        const response = LoginResponse(
          expiresAt: '2025-01-01',
          accountId: 1,
          firstName: 'John',
        );

        expect(response.fullName, 'John');
      });

      test('fullName extension handles both names null', () {
        const response = LoginResponse(
          expiresAt: '2025-01-01',
          accountId: 1,
        );

        expect(response.fullName, '');
      });
    });
  });

  group('Survey Models', () {
    group('PublicationStatus', () {
      test('has correct values', () {
        expect(PublicationStatus.values, hasLength(3));
        expect(PublicationStatus.values, contains(PublicationStatus.draft));
        expect(PublicationStatus.values, contains(PublicationStatus.published));
        expect(PublicationStatus.values, contains(PublicationStatus.closed));
      });
    });

    group('SurveyStatus', () {
      test('has correct values', () {
        expect(SurveyStatus.values, hasLength(4));
        expect(SurveyStatus.values, contains(SurveyStatus.inProgress));
        expect(SurveyStatus.values, contains(SurveyStatus.complete));
        expect(SurveyStatus.values, contains(SurveyStatus.notStarted));
        expect(SurveyStatus.values, contains(SurveyStatus.cancelled));
      });
    });

    group('SurveyCreate', () {
      test('creates instance with required title', () {
        const survey = SurveyCreate(title: 'Test Survey');

        expect(survey.title, 'Test Survey');
        expect(survey.description, null);
        expect(survey.publicationStatus, null);
        expect(survey.questionIds, null);
      });

      test('creates instance with all fields', () {
        final survey = SurveyCreate(
          title: 'Test Survey',
          description: 'A test description',
          publicationStatus: PublicationStatus.draft,
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 12, 31),
          questionIds: [1, 2, 3],
        );

        expect(survey.title, 'Test Survey');
        expect(survey.description, 'A test description');
        expect(survey.publicationStatus, PublicationStatus.draft);
        expect(survey.questionIds, [1, 2, 3]);
      });

      test('serializes to JSON correctly', () {
        const survey = SurveyCreate(
          title: 'Test Survey',
          description: 'Description',
          questionIds: [1, 2],
        );

        final json = survey.toJson();

        expect(json['title'], 'Test Survey');
        expect(json['description'], 'Description');
        expect(json['question_ids'], [1, 2]);
      });
    });

    group('SurveyUpdate', () {
      test('creates instance with no fields', () {
        const update = SurveyUpdate();

        expect(update.title, null);
        expect(update.description, null);
      });

      test('creates instance with partial update', () {
        const update = SurveyUpdate(title: 'New Title');

        expect(update.title, 'New Title');
        expect(update.description, null);
      });

      test('creates instance with all fields', () {
        const update = SurveyUpdate(
          title: 'Updated Title',
          description: 'Updated Description',
          publicationStatus: PublicationStatus.published,
          questionIds: [4, 5, 6],
        );

        expect(update.title, 'Updated Title');
        expect(update.description, 'Updated Description');
        expect(update.publicationStatus, PublicationStatus.published);
        expect(update.questionIds, [4, 5, 6]);
      });
    });

    group('Survey', () {
      test('creates instance with required fields', () {
        const survey = Survey(
          surveyId: 1,
          title: 'Test Survey',
          status: 'not-started',
          publicationStatus: 'draft',
        );

        expect(survey.surveyId, 1);
        expect(survey.title, 'Test Survey');
        expect(survey.status, 'not-started');
        expect(survey.publicationStatus, 'draft');
      });

      test('deserializes from JSON with snake_case keys', () {
        final json = {
          'survey_id': 1,
          'title': 'Test Survey',
          'description': 'A survey',
          'status': 'in-progress',
          'publication_status': 'published',
          'question_count': 5,
        };

        final survey = Survey.fromJson(json);

        expect(survey.surveyId, 1);
        expect(survey.title, 'Test Survey');
        expect(survey.description, 'A survey');
        expect(survey.status, 'in-progress');
        expect(survey.publicationStatus, 'published');
        expect(survey.questionCount, 5);
      });

      test('deserializes with questions', () {
        final json = {
          'survey_id': 1,
          'title': 'Test Survey',
          'status': 'draft',
          'publication_status': 'draft',
          'questions': [
            {
              'question_id': 1,
              'question_content': 'How are you?',
              'response_type': 'openended',
              'is_required': true,
            },
          ],
        };

        final survey = Survey.fromJson(json);

        expect(survey.questions, hasLength(1));
        expect(survey.questions![0].questionId, 1);
        expect(survey.questions![0].questionContent, 'How are you?');
      });
    });

    group('QuestionInSurvey', () {
      test('creates instance with required fields', () {
        const question = QuestionInSurvey(
          questionId: 1,
          questionContent: 'What is your name?',
          responseType: 'openended',
          isRequired: true,
        );

        expect(question.questionId, 1);
        expect(question.questionContent, 'What is your name?');
        expect(question.responseType, 'openended');
        expect(question.isRequired, true);
      });

      test('deserializes with options', () {
        final json = {
          'question_id': 1,
          'question_content': 'Pick one',
          'response_type': 'single_choice',
          'is_required': false,
          'options': [
            {'option_id': 1, 'option_text': 'Option A'},
            {'option_id': 2, 'option_text': 'Option B'},
          ],
        };

        final question = QuestionInSurvey.fromJson(json);

        expect(question.options, hasLength(2));
        expect(question.options![0].optionText, 'Option A');
        expect(question.options![1].optionText, 'Option B');
      });
    });

    group('QuestionOption', () {
      test('creates instance with required fields', () {
        const option = QuestionOption(
          optionId: 1,
          optionText: 'Yes',
        );

        expect(option.optionId, 1);
        expect(option.optionText, 'Yes');
        expect(option.displayOrder, null);
      });

      test('creates instance with display order', () {
        const option = QuestionOption(
          optionId: 1,
          optionText: 'Yes',
          displayOrder: 0,
        );

        expect(option.displayOrder, 0);
      });
    });

    group('SurveyFromTemplateCreate', () {
      test('creates instance with no overrides', () {
        const create = SurveyFromTemplateCreate();

        expect(create.title, null);
        expect(create.description, null);
      });

      test('creates instance with overrides', () {
        const create = SurveyFromTemplateCreate(
          title: 'Custom Title',
          description: 'Custom Description',
        );

        expect(create.title, 'Custom Title');
        expect(create.description, 'Custom Description');
      });
    });
  });

  group('Template Models', () {
    group('TemplateCreate', () {
      test('creates instance with required title', () {
        const template = TemplateCreate(title: 'Test Template');

        expect(template.title, 'Test Template');
        expect(template.description, null);
        expect(template.isPublic, false); // default value
        expect(template.questionIds, null);
      });

      test('creates instance with all fields', () {
        const template = TemplateCreate(
          title: 'Public Template',
          description: 'A public template',
          isPublic: true,
          questionIds: [1, 2, 3],
        );

        expect(template.title, 'Public Template');
        expect(template.description, 'A public template');
        expect(template.isPublic, true);
        expect(template.questionIds, [1, 2, 3]);
      });

      test('serializes to JSON with snake_case keys', () {
        const template = TemplateCreate(
          title: 'Test',
          isPublic: true,
          questionIds: [1],
        );

        final json = template.toJson();

        expect(json['title'], 'Test');
        expect(json['is_public'], true);
        expect(json['question_ids'], [1]);
      });
    });

    group('TemplateUpdate', () {
      test('creates instance with no fields', () {
        const update = TemplateUpdate();

        expect(update.title, null);
        expect(update.description, null);
        expect(update.isPublic, null);
      });

      test('creates instance with partial update', () {
        const update = TemplateUpdate(
          title: 'Updated Title',
          isPublic: true,
        );

        expect(update.title, 'Updated Title');
        expect(update.isPublic, true);
        expect(update.description, null);
      });
    });

    group('Template', () {
      test('creates instance with required fields', () {
        const template = Template(
          templateId: 1,
          title: 'Test Template',
          isPublic: false,
        );

        expect(template.templateId, 1);
        expect(template.title, 'Test Template');
        expect(template.isPublic, false);
      });

      test('deserializes from JSON with snake_case keys', () {
        final json = {
          'template_id': 1,
          'title': 'Test Template',
          'description': 'A description',
          'is_public': true,
          'question_count': 10,
        };

        final template = Template.fromJson(json);

        expect(template.templateId, 1);
        expect(template.title, 'Test Template');
        expect(template.description, 'A description');
        expect(template.isPublic, true);
        expect(template.questionCount, 10);
      });

      test('deserializes with questions', () {
        final json = {
          'template_id': 1,
          'title': 'Test Template',
          'is_public': false,
          'questions': [
            {
              'question_id': 1,
              'question_content': 'Question 1',
              'response_type': 'yesno',
              'is_required': true,
              'display_order': 0,
            },
          ],
        };

        final template = Template.fromJson(json);

        expect(template.questions, hasLength(1));
        expect(template.questions![0].questionId, 1);
        expect(template.questions![0].displayOrder, 0);
      });
    });

    group('QuestionInTemplate', () {
      test('creates instance with required fields', () {
        const question = QuestionInTemplate(
          questionId: 1,
          questionContent: 'Test question',
          responseType: 'number',
          isRequired: false,
          displayOrder: 0,
        );

        expect(question.questionId, 1);
        expect(question.questionContent, 'Test question');
        expect(question.responseType, 'number');
        expect(question.isRequired, false);
        expect(question.displayOrder, 0);
      });
    });
  });

  group('Question Models', () {
    group('QuestionResponseType', () {
      test('has correct values', () {
        expect(QuestionResponseType.values, hasLength(6));
        expect(QuestionResponseType.values, contains(QuestionResponseType.number));
        expect(QuestionResponseType.values, contains(QuestionResponseType.yesno));
        expect(QuestionResponseType.values, contains(QuestionResponseType.openended));
        expect(QuestionResponseType.values, contains(QuestionResponseType.singleChoice));
        expect(QuestionResponseType.values, contains(QuestionResponseType.multiChoice));
        expect(QuestionResponseType.values, contains(QuestionResponseType.scale));
      });
    });

    group('QuestionCreate', () {
      test('creates instance with required fields', () {
        const question = QuestionCreate(
          questionContent: 'How old are you?',
          responseType: 'number',
        );

        expect(question.questionContent, 'How old are you?');
        expect(question.responseType, 'number');
        expect(question.isRequired, false); // default value
      });

      test('creates instance with all fields', () {
        const question = QuestionCreate(
          title: 'Age Question',
          questionContent: 'How old are you?',
          responseType: 'number',
          isRequired: true,
          category: 'demographics',
          options: [
            QuestionOptionCreate(optionText: '18-25'),
            QuestionOptionCreate(optionText: '26-35'),
          ],
        );

        expect(question.title, 'Age Question');
        expect(question.isRequired, true);
        expect(question.category, 'demographics');
        expect(question.options, hasLength(2));
      });

      test('serializes to JSON with snake_case keys', () {
        const question = QuestionCreate(
          questionContent: 'Test',
          responseType: 'yesno',
          isRequired: true,
        );

        final json = question.toJson();

        expect(json['question_content'], 'Test');
        expect(json['response_type'], 'yesno');
        expect(json['is_required'], true);
      });
    });

    group('QuestionUpdate', () {
      test('creates instance with no fields', () {
        const update = QuestionUpdate();

        expect(update.questionContent, null);
        expect(update.responseType, null);
        expect(update.isRequired, null);
      });

      test('creates instance with partial update', () {
        const update = QuestionUpdate(
          questionContent: 'Updated content',
          isActive: false,
        );

        expect(update.questionContent, 'Updated content');
        expect(update.isActive, false);
      });
    });

    group('Question', () {
      test('creates instance with required fields', () {
        const question = Question(
          questionId: 1,
          questionContent: 'Test question?',
          responseType: 'openended',
          isRequired: false,
        );

        expect(question.questionId, 1);
        expect(question.questionContent, 'Test question?');
        expect(question.responseType, 'openended');
        expect(question.isRequired, false);
      });

      test('deserializes from JSON with snake_case keys', () {
        final json = {
          'question_id': 1,
          'title': 'Favorite Color',
          'question_content': 'What is your favorite color?',
          'response_type': 'single_choice',
          'is_required': true,
          'category': 'preferences',
          'is_active': true,
        };

        final question = Question.fromJson(json);

        expect(question.questionId, 1);
        expect(question.title, 'Favorite Color');
        expect(question.questionContent, 'What is your favorite color?');
        expect(question.responseType, 'single_choice');
        expect(question.isRequired, true);
        expect(question.category, 'preferences');
        expect(question.isActive, true);
      });

      test('deserializes with options', () {
        final json = {
          'question_id': 1,
          'question_content': 'Pick one',
          'response_type': 'single_choice',
          'is_required': false,
          'options': [
            {'option_id': 1, 'option_text': 'Red', 'display_order': 0},
            {'option_id': 2, 'option_text': 'Blue', 'display_order': 1},
          ],
        };

        final question = Question.fromJson(json);

        expect(question.options, hasLength(2));
        expect(question.options![0].optionText, 'Red');
        expect(question.options![0].displayOrder, 0);
        expect(question.options![1].optionText, 'Blue');
      });
    });

    group('QuestionOptionCreate', () {
      test('creates instance with required fields', () {
        const option = QuestionOptionCreate(optionText: 'Yes');

        expect(option.optionText, 'Yes');
        expect(option.displayOrder, null);
      });

      test('creates instance with display order', () {
        const option = QuestionOptionCreate(
          optionText: 'Yes',
          displayOrder: 0,
        );

        expect(option.optionText, 'Yes');
        expect(option.displayOrder, 0);
      });

      test('serializes to JSON with snake_case keys', () {
        const option = QuestionOptionCreate(
          optionText: 'Option A',
          displayOrder: 1,
        );

        final json = option.toJson();

        expect(json['option_text'], 'Option A');
        expect(json['display_order'], 1);
      });
    });

    group('QuestionOptionResponse', () {
      test('deserializes from JSON', () {
        final json = {
          'option_id': 1,
          'option_text': 'Yes',
          'display_order': 0,
        };

        final option = QuestionOptionResponse.fromJson(json);

        expect(option.optionId, 1);
        expect(option.optionText, 'Yes');
        expect(option.displayOrder, 0);
      });
    });

    group('QuestionCategory', () {
      test('creates instance with required fields', () {
        const category = QuestionCategory(
          categoryId: 1,
          categoryKey: 'demographics',
          displayOrder: 0,
        );

        expect(category.categoryId, 1);
        expect(category.categoryKey, 'demographics');
        expect(category.displayOrder, 0);
      });

      test('deserializes from JSON with snake_case keys', () {
        final json = {
          'category_id': 2,
          'category_key': 'health',
          'display_order': 1,
        };

        final category = QuestionCategory.fromJson(json);

        expect(category.categoryId, 2);
        expect(category.categoryKey, 'health');
        expect(category.displayOrder, 1);
      });
    });
  });
}
