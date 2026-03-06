import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/exceptions/app_exceptions.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/oraciones_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/error_handler.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class OracionesService implements OracionesInterface {
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  @override
  Future<List<OracionResponse>> getAllOraciones() async {
    try {
      final token = await _tokenService.getToken();
      var url = Uri.parse('$_baseUrl/oraciones');

      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        
        List<OracionResponse> listaOraciones = [];
        if (jsonData is List) {
          listaOraciones = jsonData
              .map((oracion) => OracionResponse.fromJson(oracion))
              .toList();
        }
        
        return listaOraciones;
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'No autenticado. Debes iniciar sesión para ver las oraciones',
          );
        } else if (response.statusCode == 403) {
          throw AuthorizationException(
            message: 'No tienes permisos para ver las oraciones',
          );
        } else if (response.statusCode == 404) {
          throw NotFoundException(
            message: 'No se encontraron oraciones',
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error en el servidor al obtener oraciones',
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

  @override
  Future<OracionResponse?> getRandomOracion() async {
    try {
      final todasLasOraciones = await getAllOraciones();
      
      if (todasLasOraciones.isEmpty) {
        return null;
      }
      
      final random = Random();
      final indiceAleatorio = random.nextInt(todasLasOraciones.length);
      
      return todasLasOraciones[indiceAleatorio];
    } on AppException {
      rethrow;
    } catch (e) {
      throw ErrorHandler.handleHttpException(e);
    }
  }
}