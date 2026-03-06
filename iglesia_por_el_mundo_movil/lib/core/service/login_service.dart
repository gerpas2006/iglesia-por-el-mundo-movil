import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/exceptions/app_exceptions.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/login_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/login.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/error_handler.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class LoginService implements LoginInterface {
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      var url = Uri.parse('$_baseUrl/login');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonResponse = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonResponse);

        // Guardar el token automáticamente
        await _tokenService.saveToken(loginResponse.token);

        // Guardar los datos del usuario
        final meses = [
          'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
          'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ];
        final creado = loginResponse.user.createdAt;
        final memberSince = '${meses[creado.month - 1]} ${creado.year}';

        await _tokenService.saveUserData(
          id: loginResponse.user.id,
          name: loginResponse.user.name,
          email: loginResponse.user.email,
          role: loginResponse.user.role,
          memberSince: memberSince,
        );

        return loginResponse;
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'Credenciales incorrectas. Verifica tu correo y contraseña',
          );
        } else if (response.statusCode == 422) {
          throw ValidationException(
            message: 'Datos de login inválidos',
            errors: null,
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error en el servidor. Intenta más tarde',
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

  Future<Map<String, dynamic>> editarUsuario({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final token = await _tokenService.getToken();
      final userId = await _tokenService.getUserId();

      if (token == null) {
        throw AuthenticationException(
          message: 'No se encontró token. Debes estar autenticado para realizar esta acción',
        );
      }

      if (userId == null) {
        throw ServerException(
          message: 'No se encontró ID de usuario',
        );
      }

      var url = Uri.parse('$_baseUrl/usuarios/$userId');
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonResponse = jsonDecode(response.body);

        // Actualizar datos locales
        final role = await _tokenService.getUserRole();
        final memberSince = await _tokenService.getMemberSince();

        await _tokenService.saveUserData(
          id: userId,
          name: name,
          email: email,
          role: role ?? '',
          memberSince: memberSince ?? '',
        );

        return jsonResponse;
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'Sesión expirada. Vuelve a iniciar sesión',
          );
        } else if (response.statusCode == 422) {
          throw ValidationException(
            message: 'Los datos ingresados no son válidos',
            errors: null,
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error al actualizar usuario. Intenta más tarde',
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