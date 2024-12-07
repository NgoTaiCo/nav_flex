import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/nav_flex.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final map = NavigationService.getCurrentRouteSettings(context)?.arguments as Map<String, Object?>?;

    final id = map?['id'];
    final name = map?['name'];

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Column(
        children: [
          Center(
            child: Text('Received ID: $id + $name'),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                NavigationService.push(
                  context: context,
                  routeName: "historyPage",
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
