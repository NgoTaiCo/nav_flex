part of 'nav_flex.dart';

/// The `NavigationService` class is a utility to manage navigation operations
/// and maintain a history of visited routes. This service decouples navigation
/// logic from the `BuildContext` and provides additional features like custom
/// transitions and route guards.
///
/// ### Features:
/// - Maintains a navigation history stack for better control.
/// - Supports navigation with custom page transitions.
/// - Ensures navigation rules using route guards.
/// - Provides methods for replacing, pushing, and popping routes.
///
/// ### Example:
/// ```dart
/// // Registering the navigator key in the MaterialApp widget.
/// MaterialApp(
///   navigatorKey: NavigationService.navigatorKey,
///   ...
/// );
///
/// // Navigating to a route with a custom transition.
/// NavigationService.push(
///   routeName: '/details',
///   context: context,
///   transitionsBuilder: (context, animation, secondaryAnimation, child) {
///     return FadeTransition(opacity: animation, child: child);
///   },
/// );
/// ```
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final List<String> history = [];
  static bool isPopUntilActive = false;

  /// Adds the initial route to the history.
  /// This is useful when the app starts to ensure the history has a base route.
  static void addInitialRoute(String routeName) {
    if (history.isEmpty) {
      history.add(routeName);
    }
  }

  /// Pushes a new route onto the navigation stack with custom transitions.
  ///
  /// - **Parameters:**
  ///   - `routeName`: The name of the route to navigate to.
  ///   - `arguments`: Optional arguments to pass to the route.
  ///   - `transitionsBuilder`: A custom transition effect for the route.
  ///   - `context`: The `BuildContext` for navigation.
  ///
  /// - **Returns:** A `Future` that completes with the result of the pushed route.
  static Future<T?>? push<T>({
    required String routeName,
    Map<String, Object?>? arguments,
    required RouteTransitionsBuilder transitionsBuilder,
    required BuildContext context,
  }) async {
    final canNavigate = await RouteService.checkGuard(routeName);
    if (!canNavigate || !context.mounted) {
      return null;
    }

    Widget page = RouteService.getWidgetForRoute(routeName, context);

    history.add(routeName);

    return navigatorKey.currentState?.push<T>(
      CustomPageRoute(
        page: page,
        transitionsBuilder: transitionsBuilder,
        name: routeName,
        arguments: arguments,
      ),
    );
  }

  /// Pops the top route off the navigation stack.
  ///
  /// - **Parameters:**
  ///   - `result`: Optional result to return to the previous route.
  static void pop<T>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop<T>(result);
      removeLastRoute();
    }
  }

  /// Replaces the current route with a new one.
  ///
  /// - **Parameters:**
  ///   - `routeName`: The name of the route to navigate to.
  ///   - `arguments`: Optional arguments to pass to the route.
  ///   - `transitionsBuilder`: A custom transition effect for the route.
  ///   - `context`: The `BuildContext` for navigation.
  ///
  /// - **Returns:** A `Future` that completes with the result of the replaced route.
  static Future<T?>? replace<T, TO>({
    required String routeName,
    Map<String, Object?>? arguments,
    required RouteTransitionsBuilder transitionsBuilder,
    required BuildContext context,
  }) async {
    final canNavigate = await RouteService.checkGuard(routeName);
    if (!canNavigate || !context.mounted) {
      return null;
    }

    Widget page = RouteService.getWidgetForRoute(routeName, context);

    history.removeLast();
    history.add(routeName);

    return navigatorKey.currentState?.pushReplacement<T, TO>(
      CustomPageRoute(
        page: page,
        transitionsBuilder: transitionsBuilder,
        name: routeName,
        arguments: arguments,
      ),
    );
  }

  /// Removes the last route from the history stack.
  static void removeLastRoute() {
    if (isPopUntilActive) return;
    if (history.isNotEmpty) {
      history.removeLast();
    }
  }

  /// Pops routes until the specified route is at the top of the stack.
  ///
  /// - **Parameters:**
  ///   - `routeName`: The name of the route to pop to.
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

  /// Gets the current route settings from the context.
  ///
  /// - **Returns:** The current `RouteSettings` object or `null` if unavailable.
  static RouteSettings? getCurrentRouteSettings(BuildContext context) {
    return ModalRoute.of(context)?.settings;
  }
}

/// A custom implementation of `PageRouteBuilder` to allow
/// custom transitions for route animations.
///
/// ### Parameters:
/// - `page`: The widget to display for the route.
/// - `transitionsBuilder`: A custom animation for transitioning to the route.
/// - `name`: The name of the route.
/// - `arguments`: Optional arguments for the route.
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  @override
  final RouteTransitionsBuilder transitionsBuilder;
  final String name;
  final Map<String, Object?>? arguments;

  CustomPageRoute({
    required this.page,
    required this.transitionsBuilder,
    required this.name,
    this.arguments,
  }) : super(
          settings: RouteSettings(name: name, arguments: arguments),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: transitionsBuilder,
        );
}
