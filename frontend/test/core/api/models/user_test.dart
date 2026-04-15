import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/user.dart';

void main() {
  group('UserRoleExtension', () {
    test('returns expected display names', () {
      expect(UserRole.participant.displayName, 'Participant');
      expect(UserRole.researcher.displayName, 'Researcher');
      expect(UserRole.hcp.displayName, 'Healthcare Professional');
      expect(UserRole.admin.displayName, 'Admin');
    });
  });

  group('User models', () {
    test('UserCreate serializes and deserializes', () {
      const model = UserCreate(
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        password: 'secret',
        role: UserRole.researcher,
        isActive: true,
      );

      final json = model.toJson();
      expect(json['first_name'], 'Ada');
      expect(json['role'], 'researcher');

      final parsed = UserCreate.fromJson(json);
      expect(parsed, model);
    });

    test('UserUpdate serializes optional fields', () {
      const model = UserUpdate(
        firstName: 'Grace',
        role: UserRole.hcp,
        isActive: false,
      );

      final json = model.toJson();
      expect(json['first_name'], 'Grace');
      expect(json['role'], 'hcp');
      expect(json['is_active'], isFalse);

      final parsed = UserUpdate.fromJson(json);
      expect(parsed, model);
    });

    test('CurrentUserUpdate round-trips birthdate and profile fields', () {
      final model = CurrentUserUpdate(
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        birthdate: DateTime.parse('1990-01-02T00:00:00.000'),
        gender: 'female',
      );

      final parsed = CurrentUserUpdate.fromJson(model.toJson());
      expect(parsed, model);
    });

    test('User helper extensions expose full name and role enum', () {
      const user = User(
        accountId: 1,
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        role: 'researcher',
      );

      expect(user.fullName, 'Ada Lovelace');
      expect(user.roleEnum, UserRole.researcher);
      expect(user.copyWith(role: 'unknown').roleEnum, UserRole.participant);
      expect(user.copyWith(role: null).roleEnum, isNull);
    });

    test('UserListResponse round-trips user arrays', () {
      final model = UserListResponse(
        users: [
          User(
            accountId: 1,
            firstName: 'Ada',
            lastName: 'Lovelace',
            email: 'ada@example.com',
            role: 'participant',
            createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
          ),
        ],
        total: 1,
      );

      final parsed = UserListResponse.fromJson(model.toJson());
      expect(parsed, model);
    });
  });
}
