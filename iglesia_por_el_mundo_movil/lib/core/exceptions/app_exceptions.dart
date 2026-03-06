/// Excepciones personalizadas para la aplicación

/// Excepción base de la aplicación
abstract class AppException implements Exception {
  final String message;
  final int statusCode;
  final String? errorCode;

  AppException({
    required this.message,
    required this.statusCode,
    this.errorCode,
  });

  @override
  String toString() => 'AppException: $message (Status: $statusCode)';
}

/// Excepción de recurso no encontrado (404)
class NotFoundException extends AppException {
  NotFoundException({
    String message = 'Recurso no encontrado',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 404,
    errorCode: errorCode,
  );
}

/// Excepción de error de validación (422)
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException({
    String message = 'Error de validación',
    required this.errors,
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 422,
    errorCode: errorCode,
  );
}

/// Excepción de autenticación no válida (401)
class AuthenticationException extends AppException {
  AuthenticationException({
    String message = 'No autenticado. Debes estar autenticado para acceder a este recurso',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 401,
    errorCode: errorCode,
  );
}

/// Excepción de autorización (403)
class AuthorizationException extends AppException {
  AuthorizationException({
    String message = 'No autorizado. No tienes permisos para realizar esta acción',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 403,
    errorCode: errorCode,
  );
}

/// Excepción de ruta no encontrada (404)
class RouteNotFoundException extends AppException {
  RouteNotFoundException({
    String message = 'Ruta no encontrada. El endpoint solicitado no existe',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 404,
    errorCode: errorCode,
  );
}

/// Excepción de método no permitido (405)
class MethodNotAllowedException extends AppException {
  MethodNotAllowedException({
    String message = 'Método no permitido. El método HTTP utilizado no está permitido',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 405,
    errorCode: errorCode,
  );
}

/// Excepción de error de base de datos (500)
class DatabaseException extends AppException {
  DatabaseException({
    String message = 'Error de base de datos. Ocurrió un error al procesar tu solicitud',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 500,
    errorCode: errorCode,
  );
}

/// Excepción de error en el servidor (500)
class ServerException extends AppException {
  ServerException({
    String message = 'Error interno del servidor',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 500,
    errorCode: errorCode,
  );
}

/// Excepción de error de red
class NetworkException extends AppException {
  NetworkException({
    String message = 'Error de conexión. Verifica tu conexión a internet',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 0,
    errorCode: errorCode,
  );
}

/// Excepción de timeout
class TimeoutException extends AppException {
  TimeoutException({
    String message = 'Tiempo de espera agotado. La solicitud tardó demasiado',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 408,
    errorCode: errorCode,
  );
}

/// Excepción de error desconocido
class UnknownException extends AppException {
  UnknownException({
    String message = 'Error desconocido',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 500,
    errorCode: errorCode,
  );
}
