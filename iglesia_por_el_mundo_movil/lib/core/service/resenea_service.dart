import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/resenea_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/exceptions/app_exceptions.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/resenea_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/resenea.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/error_handler.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class ReseneaService implements ReseneaInterface {
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  @override
  Future<List<ReseneaResponse>> getAllResenea() async {
    try {
      final token = await _tokenService.getToken();
      var url = Uri.parse('$_baseUrl/reseneas');

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

        List<ReseneaResponse> listaResenea = [];
        if (jsonData is List) {
          listaResenea =
              jsonData.map((r) => ReseneaResponse.fromJson(r)).toList();
        } else if (jsonData is Map && jsonData['data'] is List) {
          listaResenea = (jsonData['data'] as List)
              .map((r) => ReseneaResponse.fromJson(r))
              .toList();
        }
        return listaResenea;
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'No autenticado. Debes iniciar sesión para ver las reseñas',
          );
        } else if (response.statusCode == 403) {
          throw AuthorizationException(
            message: 'No tienes permisos para ver las reseñas',
          );
        } else if (response.statusCode == 404) {
          throw NotFoundException(
            message: 'No se encontraron reseñas',
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error en el servidor al obtener reseñas',
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
  Future<ReseneaResponse> crearResenea(ReseneaDTO resenea) async {
    try {
      final token = await _tokenService.getToken();
      var url = Uri.parse('$_baseUrl/reseneas');

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(resenea.toJson()),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        final data = jsonData['data'] ?? jsonData;
        return ReseneaResponse.fromJson(data as Map<String, dynamic>);
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'Sesión expirada. Vuelve a iniciar sesión',
          );
        } else if (response.statusCode == 422) {
          throw ValidationException(
            message: 'Datos de la reseña inválidos. Verifica la información',
            errors: null,
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error al crear la reseña. Intenta más tarde',
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