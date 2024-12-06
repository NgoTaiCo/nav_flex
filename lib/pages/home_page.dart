// home_page.dart
import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/navigation_service.dart';
import 'package:nav_flex/navigator/route_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NavigationService.pushNamed(
              RouteManager.getRouteName(AppRoutes.details),
              arguments: {'id': 42},
            );
          },
          child: const Text('Go to Details'),
        ),
      ),
    );
  }
}