class ArgumentsService {
  static final Map<String, Object?> _arguments = {};

  /// Lưu trữ dữ liệu argument với key cụ thể
  static void setArguments(String key, Object? value) {
    if (value != null) {
      _arguments[key] = value;
    }
  }

  /// Lấy dữ liệu argument theo key
  static T? getArguments<T>(String key) {
    return _arguments[key] as T?;
  }

  /// Xóa tất cả argument
  static void clearArguments() {
    _arguments.clear();
  }

  /// Xóa argument theo key
  static void removeArgument(String key) {
    _arguments.remove(key);
  }
}
