// home_page.dart
import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/nav_flex.dart';

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
