import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/nav_flex.dart';
import 'package:nav_flex/pages/detail_page.dart';
import 'package:nav_flex/pages/home_page.dart';

void main() {
  RouteService.addRoute('homePage', (context) => const HomePage());
  RouteService.addRoute('detailPage', (context) => const DetailsPage());
  NavigationService.addInitialRoute('homePage');
  runApp(const MyApp());
}

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
            const DraggableHistoryButton(),
          ],
        );
      },
    );
  }
}
