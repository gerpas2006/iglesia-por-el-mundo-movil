import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/exceptions/app_exceptions.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/registre_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/registre.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/error_handler.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class RegistreService implements RegistreInterface {
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  Future<RegistreResponse> registrer(
    String name,
    String email,
    String password,
  ) async {
    try {
      var url = Uri.parse('$_baseUrl/register');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonResponse = jsonDecode(response.body);
        final registreResponse = RegistreResponse.fromJson(jsonResponse);
        
        // Guardar el token automáticamente
        await _tokenService.saveToken(registreResponse.token);
        
        return registreResponse;
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 422) {
          throw ValidationException(
            message: 'Datos de registro inválidos. Verifica tu información',
            errors: null,
          );
        } else if (response.statusCode == 409) {
          throw ValidationException(
            message: 'El correo electrónico ya está registrado',
            errors: null,
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error al registrar usuario. Intenta más tarde',
          );
        } else {
          throw ErrorHandler.handleHttpException(
            response,
            statusCode: response.statusCode,
          );
        }
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ErrorHandler.handleHttpException(e);
    }
  }
}
