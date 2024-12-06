import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/argument_service.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final List<String> _history = [];
  static bool isPopUntilActive = false;

  static void addInitialRoute(String routeName) {
    if (_history.isEmpty) {
      _history.add(routeName);
    }
  }

  static Future<T?>? push<T>(Widget page, {Map<String, Object?>? arguments}) {
    String routeName = ModalRoute.of(navigatorKey.currentContext!)?.settings.name ?? 'Unknown';
    if (arguments != null) {
      arguments.forEach((key, value) {
        ArgumentsService.setArguments(key, value);
      });
    }
    _history.add(routeName);
    return navigatorKey.currentState?.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?>? pushNamed<T>(String routeName, {Map<String, Object?>? arguments}) {
    if (arguments != null) {
      arguments.forEach((key, value) {
        ArgumentsService.setArguments(key, value);
      });
    }
    _history.add(routeName);
    return navigatorKey.currentState?.pushNamed<T>(routeName);
  }

  static void pop<T>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop<T>(result);
      removeLastRoute();
    }
  }

  static Future<T?>? replace<T, TO>(Widget page, {Map<String, Object?>? arguments}) {
    String routeName = ModalRoute.of(navigatorKey.currentContext!)?.settings.name ?? 'Unknown';
    if (arguments != null) {
      arguments.forEach((key, value) {
        ArgumentsService.setArguments(key, value);
      });
    }
    _history.removeLast();
    _history.add(routeName);
    return navigatorKey.currentState?.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?>? replaceNamed<T, TO>(String routeName, {Map<String, Object?>? arguments}) {
    if (arguments != null) {
      arguments.forEach((key, value) {
        ArgumentsService.setArguments(key, value);
      });
    }
    _history.removeLast();
    _history.add(routeName);
    return navigatorKey.currentState?.pushReplacementNamed<T, TO>(routeName);
  }

  static List<String> get history => List.unmodifiable(_history);

  static void popUntil(String routeName) {
    int targetIndex = _history.indexOf(routeName);
    if (targetIndex == -1) return;

    isPopUntilActive = true;

    navigatorKey.currentState?.popUntil((route) {
      bool shouldPop = route.settings.name == routeName;
      if (shouldPop) {
        _history.removeRange(targetIndex + 1, _history.length);
      }
      return shouldPop;
    });

    isPopUntilActive = false;
  }

  static void removeLastRoute() {
    if (isPopUntilActive) return;
    if (_history.isNotEmpty) {
      _history.removeLast();
    }
  }
}
