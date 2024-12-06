import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/argument_service.dart';
import 'package:nav_flex/navigator/navigation_service.dart';
import 'package:nav_flex/navigator/route_service.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int? id = ArgumentsService.getArguments<int>("id"); // Lấy argument đầu tiên

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
                NavigationService.pushNamed(
                  RouteManager.getRouteName(AppRoutes.history),
                  arguments: {'id': 42},
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
