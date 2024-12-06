import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/argument_service.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final List<String> history = [];
  static bool isPopUntilActive = false;

  static void addInitialRoute(String routeName) {
    if (history.isEmpty) {
      history.add(routeName);
    }
  }

  static Future<T?>? push<T>(Widget page,
      {Map<String, Object?>? arguments, required RouteTransitionsBuilder transitionsBuilder}) {
    String routeName = ModalRoute.of(navigatorKey.currentContext!)?.settings.name ?? 'Unknown';
    if (arguments != null) {
      arguments.forEach((key, value) {
        ArgumentsService.setArguments(key, value);
      });
    }
    history.add(routeName);

    return navigatorKey.currentState?.push<T>(
      CustomPageRoute(
        page: page,
        transitionsBuilder: transitionsBuilder,
      ),
    );
  }

  static void pop<T>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop<T>(result);
      removeLastRoute();
    }
  }

  static Future<T?>? replace<T, TO>(Widget page,
      {Map<String, Object?>? arguments, required RouteTransitionsBuilder transitionsBuilder}) {
    String routeName = ModalRoute.of(navigatorKey.currentContext!)?.settings.name ?? 'Unknown';
    if (arguments != null) {
      arguments.forEach((key, value) {
        ArgumentsService.setArguments(key, value);
      });
    }
    history.removeLast();
    history.add(routeName);

    return navigatorKey.currentState?.pushReplacement<T, TO>(
      CustomPageRoute(
        page: page,
        transitionsBuilder: transitionsBuilder,
      ),
    );
  }

  static void removeLastRoute() {
    if (isPopUntilActive) return;
    if (history.isNotEmpty) {
      history.removeLast();
    }
  }

  static void popUntil(String routeName) {
    int targetIndex = history.indexOf(routeName);
    if (targetIndex == -1) return;

    isPopUntilActive = true;

    navigatorKey.currentState?.popUntil((route) {
      bool shouldPop = route.settings.name == routeName;
      if (shouldPop) {
        history.removeRange(targetIndex + 1, history.length);
      }
      return shouldPop;
    });

    isPopUntilActive = false;
  }
}

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  @override
  final RouteTransitionsBuilder transitionsBuilder;

  CustomPageRoute({
    required this.page,
    required this.transitionsBuilder, // Pass the custom transition builder
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: transitionsBuilder, // Use the builder here
        );
}
