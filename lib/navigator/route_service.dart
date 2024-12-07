part of 'nav_flex.dart';

class RouteService {
  // Map để lưu trữ các route mà người dùng thêm vào
  static final Map<String, WidgetBuilder> _customRoutes = {};

  // Trả về các routes đã đăng ký (dynamically thêm từ bên ngoài)
  static Map<String, WidgetBuilder> get routes => _customRoutes;

  // Hàm để người dùng có thể đăng ký route mới
  static void addRoute(String routeName, WidgetBuilder builder) {
    _customRoutes[routeName] = builder;
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
