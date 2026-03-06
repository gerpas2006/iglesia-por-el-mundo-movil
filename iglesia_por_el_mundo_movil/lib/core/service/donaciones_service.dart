import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/donaciones_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/exceptions/app_exceptions.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/donaciones_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/donaciones.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_donacion.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/error_handler.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class DonacionesService implements DonacionesInterface {
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();
  @override
  Future<List<DonacionResponse>> obtenerDonaciones() async{
    try {
      final token = await _tokenService.getToken();
      var url = Uri.parse('$_baseUrl/donaciones');
      
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

        List<DonacionResponse> listaDonaciones = [];
        if (jsonData is List) {
          listaDonaciones = jsonData
              .map((donacion) => DonacionResponse.fromJson(donacion))
              .toList();
        }

        return listaDonaciones;
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'No autenticado. Debes iniciar sesión para ver las donaciones',
          );
        } else if (response.statusCode == 403) {
          throw AuthorizationException(
            message: 'No tienes permisos para ver las donaciones',
          );
        } else if (response.statusCode == 404) {
          throw NotFoundException(
            message: 'No se encontraron donaciones',
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error en el servidor al obtener donaciones',
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
  Future<DonacionResponse> crearDonacion(DonacionesDto donacion) async {
    try {
      final token = await _tokenService.getToken();
      final userId = await _tokenService.getUserId();
      
      var url = Uri.parse('$_baseUrl/donaciones');
      
      // Crear un DTO con el user_id incluido
      final dtoConUserId = DonacionesDto(
        nombre_donante: donacion.nombre_donante,
        apellido_donante: donacion.apellido_donante,
        donacion: donacion.donacion,
        mensaje: donacion.mensaje,
        metodoPago: donacion.metodoPago,
        tipo_donacion_id: donacion.tipo_donacion_id,
        user_id: userId,
      );
      
      final dtoJson = dtoConUserId.toJson();
      
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dtoJson),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        
        var data = jsonData;
        if (jsonData is Map && jsonData['data'] != null) {
          data = jsonData['data'];
        }
        
        return DonacionResponse.fromJson(data as Map<String, dynamic>);
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'Sesión expirada. Vuelve a iniciar sesión',
          );
        } else if (response.statusCode == 422) {
          throw ValidationException(
            message: 'Datos de la donación inválidos. Verifica la información',
            errors: null,
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error al crear la donación. Intenta más tarde',
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
  Future<List<TipoDonacionResponse>> listarTipoDonacion() async{
    try {
      final token = await _tokenService.getToken();
      var url = Uri.parse('$_baseUrl/tipoDonaciones');
      
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
        
        List<TipoDonacionResponse> listaTipos = [];
        
        if (jsonData is List) {
          listaTipos = jsonData
              .map((tipo) => TipoDonacionResponse.fromJson(tipo as Map<String, dynamic>))
              .toList();
        }
        
        return listaTipos;
      } else {
        // Manejo de errores basado en statusCode
        if (response.statusCode == 401) {
          throw AuthenticationException(
            message: 'Sesión expirada. Vuelve a iniciar sesión',
          );
        } else if (response.statusCode == 404) {
          throw NotFoundException(
            message: 'No se encontraron tipos de donaciones',
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            message: 'Error al obtener tipos de donaciones',
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