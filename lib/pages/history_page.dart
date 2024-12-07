import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/nav_flex.dart';

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
