// route_manager.dart
import 'package:flutter/material.dart';
import 'package:nav_flex/pages/detail_page.dart';
import 'package:nav_flex/pages/history_page.dart';
import 'package:nav_flex/pages/home_page.dart';

enum AppRoutes { home, details, history }

class RouteManager {
  static Map<String, WidgetBuilder> get routes => {
        getRouteName(AppRoutes.home): (_) => const HomePage(),
        getRouteName(AppRoutes.details): (_) => const DetailsPage(),
        getRouteName(AppRoutes.history): (_) => const HistoryPage(),
      };

  static String getRouteName(AppRoutes route) {
    return route.toString().split('.').last;
  }

  static Widget getWidgetForRoute(AppRoutes route) {
    switch (route) {
      case AppRoutes.home:
        return const HomePage();
      case AppRoutes.details:
        return const DetailsPage();
      case AppRoutes.history:
        return const HistoryPage();
      default:
        return const HomePage(); // Default case to prevent errors
    }
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final routeBuilder = routes[routeName];

    if (routeBuilder != null) {
      return MaterialPageRoute(builder: routeBuilder, settings: settings);
    }
    return null;
  }
}
