import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/config/navigation.dart';

void main() {
  group('NavigationConfig', () {
    test('parses known role strings', () {
      expect(NavigationConfig.parseRole('admin'), UserRole.admin);
      expect(NavigationConfig.parseRole('researcher'), UserRole.researcher);
      expect(NavigationConfig.parseRole('hcp'), UserRole.hcp);
      expect(
        NavigationConfig.parseRole('healthcare professional'),
        UserRole.hcp,
      );
    });

    test('defaults unknown role strings to participant', () {
      expect(NavigationConfig.parseRole('unknown'), UserRole.participant);
      expect(NavigationConfig.parseRole(null), isNull);
    });

    test('returns nav items for participant role', () {
      final items = NavigationConfig.getNavItems(UserRole.participant);
      expect(items.map((item) => item.label), containsAll(['Dashboard', 'My Surveys', 'Results']));
    });

    test('returns empty nav for admin role', () {
      expect(NavigationConfig.getNavItems(UserRole.admin), isEmpty);
    });

    test('returns role dashboard routes', () {
      expect(NavigationConfig.getDashboardRoute(UserRole.participant), '/participant/dashboard');
      expect(NavigationConfig.getDashboardRoute(UserRole.hcp), '/hcp/dashboard');
    });
  });
}
