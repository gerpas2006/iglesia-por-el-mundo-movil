import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/donaciones_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/donaciones.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';
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
}