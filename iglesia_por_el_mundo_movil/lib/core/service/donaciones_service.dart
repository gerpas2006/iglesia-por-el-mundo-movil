import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/donaciones_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/donaciones_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/donaciones.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_donacion.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class DonacionesService implements DonacionesInterface {
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();
  @override
  Future<List<DonacionResponse>> obtenerDonaciones() async{
    final token = await _tokenService.getToken();
    var url = Uri.parse('$_baseUrl/donaciones');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);

        // Parsear el array de donaciones
        List<DonacionResponse> listaDonaciones = [];
        if (jsonData is List) {
          listaDonaciones = jsonData
              .map((donacion) => DonacionResponse.fromJson(donacion))
              .toList();
        }

        return listaDonaciones;
      } else {
        throw Exception('Error al obtener donaciones.');
      }
    } catch (e) {
      throw Exception('Error al obtener donaciones: $e');
    }
  }

  @override
  Future<DonacionResponse> crearDonacion(DonacionesDto donacion) async {
    final token = await _tokenService.getToken();
    final userId = await _tokenService.getUserId();
    
    var url = Uri.parse('$_baseUrl/donaciones');
    try {
      // Crear un DTO con el user_id incluido
      final dtoConUserId = DonacionesDto(
        nombre_donante: donacion.nombre_donante,
        apellido_donante: donacion.apellido_donante,
        donacion: donacion.donacion,
        mensaje: donacion.mensaje,
        metodoPago: donacion.metodoPago,
        tipo_donacion_id: donacion.tipo_donacion_id,
        user_id: userId, // Agregar el user_id
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
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        
        // El API podría retornar directamente el objeto o dentro de 'data'
        var data = jsonData;
        if (jsonData is Map && jsonData['data'] != null) {
          data = jsonData['data'];
        }
        
        return DonacionResponse.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception('Error al crear donación. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear donación: $e');
    }
  }

  @override
  Future<List<TipoDonacionResponse>> listarTipoDonacion() async{
    final token = await _tokenService.getToken();
    var url = Uri.parse('$_baseUrl/tipoDonaciones');
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        
        List<TipoDonacionResponse> listaTipos = [];
        
        // El API retorna directamente un array
        if (jsonData is List) {
          listaTipos = jsonData
              .map((tipo) => TipoDonacionResponse.fromJson(tipo as Map<String, dynamic>))
              .toList();
        }
        
        return listaTipos;
      } else {
        throw Exception('Error al obtener tipos de donación. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener tipos de donación: $e');
    }
  }
}