part of 'nav_flex.dart';

class RouteService {
  // Map để lưu trữ các route mà người dùng thêm vào
  static final Map<String, WidgetBuilder> _customRoutes = {};

  // Map để lưu trữ middleware cho các route
  static final Map<String, NavigationGuard> _routeGuards = {};

  // Trả về các routes đã đăng ký (dynamically thêm từ bên ngoài)
  static Map<String, WidgetBuilder> get routes => _customRoutes;

  // Hàm để người dùng có thể đăng ký route mới
  static void addRoute(String routeName, WidgetBuilder builder, {NavigationGuard? guard}) {
    _customRoutes[routeName] = builder;
    if (guard != null) {
      _routeGuards[routeName] = guard;
    }
  }

  // Trả về Widget tương ứng với route
  static Widget getWidgetForRoute(String routeName, BuildContext context) {
    final builder = _customRoutes[routeName];
    if (builder != null) {
      return builder(context); // Thêm BuildContext khi gọi builder
    }
    return const Scaffold(
      body: Center(child: Text('Page not found')),
    ); // Trường hợp không tìm thấy route
  }

  // Kiểm tra middleware trước khi điều hướng
  static Future<bool> checkGuard(String routeName) async {
    final guard = _routeGuards[routeName];
    if (guard != null) {
      return await guard();
    }
    return true; // Nếu không có guard, cho phép điều hướng
  }

  // Xử lý điều hướng theo route
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final routeBuilder = _customRoutes[routeName];

    if (routeBuilder != null) {
      return MaterialPageRoute(builder: routeBuilder, settings: settings);
    }
    return null;
  }
}

// Định nghĩa NavigationGuard
typedef NavigationGuard = Future<bool> Function();
