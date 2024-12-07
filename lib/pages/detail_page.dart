import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/nav_flex.dart';
import 'package:nav_flex/pages/history_page.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool> checkAdminAccess() async {
      // Giả lập kiểm tra quyền (có thể thay bằng API call)
      await Future.delayed(const Duration(milliseconds: 300));
      return false; // Không cho phép truy cập
    }

    RouteService.addRoute(
      'historyPage',
      (context) => const HistoryPage(),
      guard: () async {
        // Kiểm tra quyền truy cập
        final hasAccess = await checkAdminAccess();
        if (!hasAccess) {
          print("Access Denied to Admin Page");
        }
        return hasAccess; // Trả về true nếu cho phép điều hướng
      },
    );

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
