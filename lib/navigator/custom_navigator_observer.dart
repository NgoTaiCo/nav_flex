import 'package:flutter/material.dart';
import 'package:nav_flex/navigator/navigation_service.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    // Kiểm tra nếu popUntil đang hoạt động, không xóa route
    if (!NavigationService.isPopUntilActive) {
      NavigationService.removeLastRoute();
    }
  }
}
