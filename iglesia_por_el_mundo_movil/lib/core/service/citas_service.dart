import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/citas_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/citas.dart';
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
}