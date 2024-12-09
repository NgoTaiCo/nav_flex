import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav_flex/navigator/nav_flex.dart';

void main() {
  // Setup the necessary dependencies before running the tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RouteService Tests', () {
    testWidgets('addRoute and getWidgetForRoute should work', (WidgetTester tester) async {
      RouteService.addRoute('testRoute', (context) => const Text('Test Page'));

      await tester.pumpWidget(MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        home: const Scaffold(),
      ));

      final routeWidget = RouteService.getWidgetForRoute('testRoute', tester.element(find.byType(Scaffold)));
      expect(routeWidget, isA<Text>());
    });

    testWidgets('checkGuard should return true by default', (WidgetTester tester) async {
      final canNavigate = await RouteService.checkGuard('testRoute');
      expect(canNavigate, true);
    });
  });
}
