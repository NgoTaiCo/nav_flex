import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/argument_service.dart';
import 'package:nav_flex/navigator/navigation_service.dart';
import 'package:nav_flex/navigator/route_service.dart';
import 'package:nav_flex/navigator/transition_factory.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int? id = ArgumentsService.getArguments<int>("id");

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Column(
        children: [
          Center(
            child: Text('Received ID: $id'),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                NavigationService.push(
                  RouteManager.getWidgetForRoute(AppRoutes.history),
                  arguments: {'id': 42},
                  transitionsBuilder: TransitionFactory.slideTransition(),
                );
              },
              child: const Text('Show History'),
            ),
          ),
          Text("${NavigationService.history.toString()}"),
        ],
      ),
    );
  }
}
