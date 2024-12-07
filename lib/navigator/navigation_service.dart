part of 'nav_flex.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final List<String> history = [];
  static bool isPopUntilActive = false;

  // Thêm route ban đầu vào history
  static void addInitialRoute(String routeName) {
    if (history.isEmpty) {
      history.add(routeName);
    }
  }

  // Hàm push route mới
  static Future<T?>? push<T>({
    required String routeName,
    Map<String, Object?>? arguments,
    required RouteTransitionsBuilder transitionsBuilder,
    required BuildContext context,
  }) {
    Widget page = RouteService.getWidgetForRoute(routeName, context);

    history.add(routeName);

    return navigatorKey.currentState?.push<T>(
      CustomPageRoute(
        page: page,
        transitionsBuilder: transitionsBuilder,
        name: routeName,
        arguments: arguments,
      ),
    );
  }

  // Hàm pop route
  static void pop<T>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop<T>(result);
      removeLastRoute();
    }
  }

  // Hàm thay thế route hiện tại
  static Future<T?>? replace<T, TO>({
    required String routeName,
    Map<String, Object?>? arguments,
    required RouteTransitionsBuilder transitionsBuilder,
    required BuildContext context,
  }) {
    Widget page = RouteService.getWidgetForRoute(routeName, context);

    history.removeLast();
    history.add(routeName);

    return navigatorKey.currentState?.pushReplacement<T, TO>(
      CustomPageRoute(
        page: page,
        transitionsBuilder: transitionsBuilder,
        name: routeName,
        arguments: arguments,
      ),
    );
  }

  // Xóa route cuối cùng trong history
  static void removeLastRoute() {
    if (isPopUntilActive) return;
    if (history.isNotEmpty) {
      history.removeLast();
    }
  }

  // Pop đến một route cụ thể
  static void popUntil(String routeName) {
    int targetIndex = history.indexOf(routeName);
    if (targetIndex == -1) return;

    isPopUntilActive = true;

    navigatorKey.currentState?.popUntil((route) {
      bool shouldPop = route.settings.name == routeName;
      if (shouldPop) {
        history.removeRange(targetIndex + 1, history.length);
      }
      return shouldPop;
    });

    isPopUntilActive = false;
  }

  static RouteSettings? getCurrentRouteSettings(BuildContext context) {
    return ModalRoute.of(context)?.settings;
  }
}

// Lớp CustomPageRoute để thực hiện việc tạo page route với transition
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  @override
  final RouteTransitionsBuilder transitionsBuilder;
  final String name;
  final Map<String, Object?>? arguments;

  CustomPageRoute({
    required this.page,
    required this.transitionsBuilder,
    required this.name,
    this.arguments,
  }) : super(
          settings: RouteSettings(name: name, arguments: arguments), // Set the name here
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: transitionsBuilder,
        );
}
