import 'dart:async';
import 'dart:io';
import 'package:iglesia_por_el_mundo_movil/core/exceptions/app_exceptions.dart';
import 'package:http/http.dart' as http;

/// Manejador centralizado de errores para la aplicación
class ErrorHandler {
  /// Maneja excepciones de HTTP y las convierte en excepciones personalizadas
  static AppException handleHttpException(dynamic error, {int? statusCode}) {
    // Si ya es una AppException, retornarla como está
    if (error is AppException) {
      return error;
    }

    // Manejar excepciones de timeout
    if (error is TimeoutException) {
      return TimeoutException();
    }

    // Manejar excepciones de socket (sin conexión)
    if (error is SocketException) {
      return NetworkException();
    }

    // Manejar excepciones HTTP
    if (error is http.Response) {
      return _handleHttpResponse(error);
    }

    // Manejar por código de estado si se proporciona
    if (statusCode != null) {
      return _handleStatusCode(statusCode, error.toString());
    }

    // Error desconocido
    return UnknownException(
      message: 'Error desconocido: ${error.toString()}',
    );
  }

  /// Maneja respuestas HTTP según el código de estado
  static AppException _handleHttpResponse(http.Response response) {
    return _handleStatusCode(response.statusCode, response.body);
  }

  /// Maneja códigos de estado HTTP
  static AppException _handleStatusCode(int statusCode, String body) {
    switch (statusCode) {
      case 401:
        return AuthenticationException();
      case 403:
        return AuthorizationException();
      case 404:
        return NotFoundException();
      case 405:
        return MethodNotAllowedException();
      case 422:
        return ValidationException(
          errors: null,
          message: 'Error de validación: $body',
        );
      case 500:
        return ServerException();
      case 503:
        return ServerException(
          message: 'Servicio no disponible. Intenta más tarde',
        );
      default:
        if (statusCode >= 500) {
          return ServerException(
            message: 'Error del servidor (Status: $statusCode)',
          );
        } else if (statusCode >= 400) {
          return ServerException(
            message: 'Error en la solicitud (Status: $statusCode): $body',
          );
        }
        return UnknownException(
          message: 'Error desconocido (Status: $statusCode)',
        );
    }
  }

  /// Retorna un mensaje amigable para el usuario
  static String getUserFriendlyMessage(AppException exception) {
    return exception.message;
  }

  /// Retorna el código de estado HTTP
  static int getStatusCode(AppException exception) {
    return exception.statusCode;
  }
}
