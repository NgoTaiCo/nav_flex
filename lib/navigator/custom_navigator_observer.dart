part of 'nav_flex.dart';

/// The `CustomNavigatorObserver` class extends `NavigatorObserver`
/// to handle navigation events such as `didPop` and manage route history.
///
/// ### Features:
/// - Automatically tracks and updates the navigation history when a route is popped.
/// - Prevents history modification during `popUntil` operations.
///
/// ### Example:
/// ```dart
/// MaterialApp(
///   navigatorObservers: [CustomNavigatorObserver()],
/// );
/// ```
class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    // Prevent history updates during popUntil operations.
    if (!NavigationService.isPopUntilActive) {
      NavigationService.removeLastRoute();
    }
  }
}
