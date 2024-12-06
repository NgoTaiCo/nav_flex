import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/navigation_service.dart';
import 'package:nav_flex/navigator/custom_navigator_observer.dart';
import 'package:nav_flex/navigator/route_service.dart';

void main() {
  NavigationService.addInitialRoute(RouteManager.getRouteName(AppRoutes.home));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: RouteManager.onGenerateRoute,
      initialRoute: RouteManager.getRouteName(AppRoutes.home),
      navigatorObservers: [CustomNavigatorObserver()],
    );
  }
}
