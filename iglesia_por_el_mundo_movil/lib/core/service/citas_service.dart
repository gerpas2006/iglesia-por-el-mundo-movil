import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/citas_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/citas_editar_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/exceptions/app_exceptions.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/citas_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/citas.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_citas.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/error_handler.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class CitasService implements CitasInterface{

  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();
  @override
  Future<List<CitaResponse>> getAllCitas() async {
    try {
      final token = await _tokenService.getToken();
      final url = Uri.parse('$_baseUrl/citas');
      
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
      
      if(response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);

        List<CitaResponse> listaCitas = [];
        if (jsonData is List) {
          listaCitas = jsonData
              .map((cita) => CitaResponse.fromJson(cita))
              .toList();
        }

        return listaCitas;
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'No autenticado. Debes iniciar sesión para ver las citas',
          );
        } else if (response.statusCode == 403) {
          throw AuthorizationException(
            message: 'No tienes permisos para ver las citas',
          );
        } else if (response.statusCode == 404) {
          throw NotFoundException(
            message: 'No se encontraron citas',
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error en el servidor al obtener citas',
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
  Future<CitaResponse> crearCita(CitasDto cita) async {
    try {
      final token = await _tokenService.getToken();
      var url = Uri.parse('$_baseUrl/citas');
      
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(cita.toJson()),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        return CitaResponse.fromJson(jsonData);
      } else {
        throw ErrorHandler.handleHttpException(
          response,
          statusCode: response.statusCode,
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ErrorHandler.handleHttpException(e);
    }
  }

  @override
  Future<List<TipoCitaResponse>> listarTipoCita() async {
    try {
      final token = await _tokenService.getToken();
      var url = Uri.parse('$_baseUrl/tipoCita');
      
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

        List<TipoCitaResponse> listaTipoCitas = [];
        if (jsonData is List) {
          listaTipoCitas = jsonData
              .map((tipoCita) => TipoCitaResponse.fromJson(tipoCita))
              .toList();
        }

        return listaTipoCitas;
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'Sesión expirada. Vuelve a iniciar sesión',
          );
        } else if (response.statusCode == 404) {
          throw NotFoundException(
            message: 'No se encontraron tipos de citas',
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error al obtener tipos de citas',
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
  Future<CitaResponse> editarCita(CitasEditarDto cita) async {
    try {
      final token = await _tokenService.getToken();
      var url = Uri.parse('$_baseUrl/citas/${cita.id}');
      
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }, 
        body: json.encode(cita.toJson()),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        return CitaResponse.fromJson(jsonData);
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'Sesión expirada. Vuelve a iniciar sesión',
          );
        } else if (response.statusCode == 422) {
          throw ValidationException(
            message: 'Datos de la cita inválidos. Verifica la información',
            errors: null,
          );
        } else if (response.statusCode == 404) {
          throw NotFoundException(
            message: 'La cita no fue encontrada',
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error al editar la cita. Intenta más tarde',
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