part of 'nav_flex.dart';

/// The `RouteService` class is responsible for managing dynamic routes and
/// navigation guards in the application.
///
/// ### Features:
/// - Allows dynamic registration of routes.
/// - Supports navigation guards for route-level access control.
/// - Provides utility methods for handling navigation dynamically.
///
/// ### Key Components:
/// - **Dynamic Routes Management**: Add or retrieve custom routes on the fly.
/// - **Navigation Guards**: Validate conditions before allowing navigation to a route.
/// - **Route Generation**: Handles route creation using `onGenerateRoute`.

class RouteService {
  /// A map storing the dynamically added routes, where the key is the route name
  /// and the value is the `WidgetBuilder` for the route.
  static final Map<String, WidgetBuilder> _customRoutes = {};

  /// A map storing middleware (guards) for specific routes.
  /// Guards ensure that certain conditions are met before navigation.
  static final Map<String, NavigationGuard> _routeGuards = {};

  /// Retrieves all registered dynamic routes.
  /// Useful for debugging or accessing route definitions programmatically.
  static Map<String, WidgetBuilder> get routes => _customRoutes;

  /// Registers a new route dynamically.
  ///
  /// - **Parameters:**
  ///   - `routeName`: The name of the route to register.
  ///   - `builder`: A `WidgetBuilder` that defines the widget for this route.
  ///   - `guard`: An optional `NavigationGuard` to validate navigation.
  ///
  /// ### Example:
  /// ```dart
  /// RouteService.addRoute(
  ///   '/profile',
  ///   (context) => ProfilePage(),
  ///   guard: () async {
  ///     return await AuthService.isAuthenticated();
  ///   },
  /// );
  /// ```
  static void addRoute(String routeName, WidgetBuilder builder, {NavigationGuard? guard}) {
    _customRoutes[routeName] = builder;
    if (guard != null) {
      _routeGuards[routeName] = guard;
    }
  }

  /// Retrieves the widget corresponding to a registered route.
  ///
  /// - **Parameters:**
  ///   - `routeName`: The name of the route to fetch.
  ///   - `context`: The `BuildContext` for the widget builder.
  ///
  /// - **Returns:** A `Widget` corresponding to the route, or a default "Page Not Found" widget
  ///   if the route is not found.
  ///
  /// ### Example:
  /// ```dart
  /// final widget = RouteService.getWidgetForRoute('/details', context);
  /// ```
  static Widget getWidgetForRoute(String routeName, BuildContext context) {
    final builder = _customRoutes[routeName];
    if (builder != null) {
      return builder(context);
    }
    return const Scaffold(
      body: Center(child: Text('Page not found')),
    );
  }

  /// Checks the guard (if any) associated with a route before navigation.
  ///
  /// - **Parameters:**
  ///   - `routeName`: The name of the route to validate.
  ///
  /// - **Returns:** A `Future<bool>` indicating whether navigation is allowed.
  ///
  /// ### Example:
  /// ```dart
  /// final canNavigate = await RouteService.checkGuard('/profile');
  /// if (canNavigate) {
  ///   Navigator.pushNamed(context, '/profile');
  /// }
  /// ```
  static Future<bool> checkGuard(String routeName) async {
    final guard = _routeGuards[routeName];
    if (guard != null) {
      return await guard();
    }
    return true;
  }

  /// Handles navigation by dynamically generating a route.
  ///
  /// - **Parameters:**
  ///   - `settings`: A `RouteSettings` object containing the name and arguments of the route.
  ///
  /// - **Returns:** A `Route<dynamic>?` for navigation, or `null` if the route is not found.
  ///
  /// ### Example:
  /// ```dart
  /// MaterialApp(
  ///   onGenerateRoute: RouteService.onGenerateRoute,
  ///   ...
  /// );
  /// ```
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final routeBuilder = _customRoutes[routeName];

    if (routeBuilder != null) {
      return MaterialPageRoute(builder: routeBuilder, settings: settings);
    }
    return null;
  }
}

/// A type definition for `NavigationGuard`.
/// Guards are asynchronous functions that return a `bool`, indicating
/// whether navigation should proceed.
///
/// ### Example:
/// ```dart
/// NavigationGuard guard = () async {
///   return await AuthService.isAuthenticated();
/// };
/// ```
typedef NavigationGuard = Future<bool> Function();
