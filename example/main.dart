import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/nav_flex.dart';

/// A navigation system with route guards and custom transitions.
///
/// - Demonstrates navigation with dynamic route registration.
/// - Includes features like access control, custom transitions,
///   and route history tracking.
///
/// ### Features:
/// - Dynamic route addition with optional guards.
/// - Animated route transitions (slide, fade, etc.).
/// - Route history tracking and navigation based on history.
///
/// ### Entry Points:
/// - `HomePage`: Starting point with a button to navigate to `DetailsPage`.
/// - `DetailsPage`: Displays arguments and a button to navigate to `HistoryPage`.
/// - `HistoryPage`: Displays navigation history, allowing the user to return to any previous route.
void main() {
  // Register initial routes
  RouteService.addRoute('homePage', (context) => const HomePage());
  RouteService.addRoute('detailPage', (context) => const DetailsPage());

  // Set the initial route
  NavigationService.addInitialRoute('homePage');

  runApp(const MyApp());
}

/// The root widget of the application.
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

/// The home page of the app, offering navigation to the details page.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NavigationService.push(
              context: context,
              routeName: "detailPage",
              arguments: {'id': 42, 'name': "John"},
              transitionsBuilder: TransitionFactory.slideTransition(),
            );
          },
          child: const Text('Go to Details'),
        ),
      ),
    );
  }
}

/// The details page, showing received arguments and navigating to the history page.
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool> checkAdminAccess() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return false; // Access denied for simulation
    }

    // Dynamically add 'historyPage' route with a guard
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

    // Extract arguments passed to this route
    final map = NavigationService.getCurrentRouteSettings(context)?.arguments as Map<String, Object?>?;
    final id = map?['id'];
    final name = map?['name'];

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Column(
        children: [
          Center(
            child: Text('Received ID: $id, Name: $name'),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                NavigationService.push(
                  context: context,
                  routeName: "historyPage",
                  transitionsBuilder: TransitionFactory.slideTransition(),
                );
              },
              child: const Text('Show History'),
            ),
          ),
          Text(NavigationService.history.toString()),
        ],
      ),
    );
  }
}

/// The history page, showing navigation history with options to return to previous routes.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.builder(
        itemCount: NavigationService.history.length,
        itemBuilder: (context, index) {
          String routeName = NavigationService.history[index];
          return ListTile(
            title: Text(routeName),
            onTap: () {
              NavigationService.popUntil(routeName);
            },
          );
        },
      ),
    );
  }
}
