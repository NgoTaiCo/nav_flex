# Flutter Navigation System with Custom Route Handling

This package demonstrates a custom navigation system for Flutter applications using a dynamic route registration system. It allows for custom transitions, route guards (middleware for route access control), and a draggable history button to view and navigate through the route history.

## Features

- **Custom Route Handling**: Dynamically register routes and define custom transitions.
- **Navigation Guards**: Set up guards (middleware) to control access to specific routes.
- **History Tracking**: Keep track of navigation history and navigate back to previous routes.
- **Draggable History Button**: A floating draggable button that displays the route history.
- **Custom Transitions**: Support for custom transition animations when navigating between routes.

## Project Structure

- **`main.dart`**: Contains the main app configuration and navigation setup.
- **`NavigationService.dart`**: Handles the navigation logic, including route pushing, popping, and managing route history.
- **`CustomNavigatorObserver.dart`**: Custom observer for the `Navigator` to monitor and update the navigation history.
- **`DraggableHistoryButton.dart`**: A draggable floating button to show the route history and allow quick navigation.

## Setup

1. **Add Routes**:
   Routes can be dynamically added using `RouteService.addRoute`. Each route must have a unique name and a corresponding widget builder. Optionally, a guard function can be provided to control access.

   ```dart
   RouteService.addRoute(
     '/profile',
     (context) => ProfilePage(),
     guard: () async {
       return await AuthService.isAuthenticated();
     },
   );
   ```

2. **Set initial route**:
    When create new navigation service, it should have the initial route for the root route

    ```dart
    NavigationService.addInitialRoute('homePage');
    ```

3. **Set root widget**
    Create the root widget with initial route
    - navigator key for Global interaction
    - onGenerateRoute for the route generation
    - initialRoute is for setup the root route
    - navigatorObservers is for custom observer


    ```dart
    class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        onGenerateRoute: RouteService.onGenerateRoute,
        initialRoute: 'homePage',
        navigatorObservers: [CustomNavigatorObserver()],
        );
    }
    }
    ```

4. **Setup DraggableHistoryButton**
    Create a custom overlay widget for control the route stack

    ```dart
    class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        onGenerateRoute: RouteService.onGenerateRoute,
        initialRoute: 'homePage',
        navigatorObservers: [CustomNavigatorObserver()],
        builder: (context, child) {
            return Stack(
            children: [
                if (child != null) child,
                const DraggableHistoryButton(), // Floating history button
            ],
            );
        },
        );
    }
    }
    ```

## Navigation Guards
   You can add guards to routes for access control. For example, the DetailsPage adds a guard to the HistoryPage route simulate access control:
   ```dart
    RouteService.addRoute(
    'historyPage',
    (context) => const HistoryPage(),
    guard: () async {
            final hasAccess = await checkAdminAccess();
            if (!hasAccess) {
            print("Access Denied to Admin Page");
            }
            return hasAccess;
        },
    );
   ```
