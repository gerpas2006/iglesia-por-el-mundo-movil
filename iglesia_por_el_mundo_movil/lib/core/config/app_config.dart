import 'dart:io' show Platform;

class AppConfig {
  static const String _baseUrlAndroid = 'http://10.0.2.2:8000/api';
  static const String _baseUrlIos = 'http://127.0.0.1:8000/api';
  static const String _baseUrlDesktop = 'http://127.0.0.1:8000/api';

  /// Obtiene la URL base según la plataforma
  static String get baseUrl {
    if (Platform.isAndroid) {
      return _baseUrlAndroid;
    } else if (Platform.isIOS) {
      return _baseUrlIos;
    } else {
      // Windows, macOS, Linux
      return _baseUrlDesktop;
    }
  }

  /// Si necesitas cambiar la URL en producción
  static const String productionBaseUrl = 'https://api.tudominio.com/api';
}
