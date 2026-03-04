import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/citas_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/citas_editar_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/citas_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/citas.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_citas.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class CitasService implements CitasInterface{

  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();
  @override
  Future<List<CitaResponse>> getAllCitas() async {
    final token = await _tokenService.getToken();
    final url = Uri.parse('$_baseUrl/citas');
    try{
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if(response.statusCode>=200 && response.statusCode<=300){
      var jsonData = json.decode(response.body);

        // Parsear el array de donaciones
        List<CitaResponse> listaCitas = [];
        if (jsonData is List) {
          listaCitas = jsonData
              .map((citas) => CitaResponse.fromJson(citas))
              .toList();
        }

        return listaCitas;
      } else {
        throw Exception('Error al obtener citas.');
      }
    } catch (e) {
      throw Exception('Error al obtener ciats: $e');
    }
  }

  @override
  Future<CitaResponse> crearCita(CitasDto cita) async {
    final token = await _tokenService.getToken();
    var url = Uri.parse('$_baseUrl/citas');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(cita.toJson()),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        return CitaResponse.fromJson(jsonData);
      } else {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception('Error al crear cita: $errorMessage (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error al crear cita: $e');
    }
  }

  @override
  Future<List<TipoCitaResponse>> listarTipoCita() async {
    final token = await _tokenService.getToken();
    var url = Uri.parse('$_baseUrl/tipoCita');
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

        // Parsear el array de tipo citas
        List<TipoCitaResponse> listaTipoCitas = [];
        if (jsonData is List) {
          listaTipoCitas = jsonData
              .map((tipoCita) => TipoCitaResponse.fromJson(tipoCita))
              .toList();
        }

        return listaTipoCitas;
      } else {
        throw Exception('Error al obtener tipo de citas.');
      }
    } catch (e) {
      throw Exception('Error al obtener tipo de citas: $e');
    }
  }
  
  @override
  Future<CitaResponse> editarCita(CitasEditarDto cita) async {
    final token = await _tokenService.getToken();
    var url = Uri.parse('$_baseUrl/citas/${cita.id}');
    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }, 
        body: json.encode(cita.toJson()),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonData = json.decode(response.body);
        return CitaResponse.fromJson(jsonData);
      } else {
        // Intentar extraer el mensaje de error del servidor
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception('Error al editar cita: $errorMessage (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error al editar cita: $e');
    }
  }

  String _extractErrorMessage(String responseBody) {
    try {
      final json = jsonDecode(responseBody);
      if (json is Map) {
        // Intentar obtener message, error, o errors
        if (json.containsKey('message')) return json['message'];
        if (json.containsKey('error')) return json['error'];
        if (json.containsKey('errors')) return json['errors'].toString();
      }
    } catch (_) {}
    return responseBody;
  }
}