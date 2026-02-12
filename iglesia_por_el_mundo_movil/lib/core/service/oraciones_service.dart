import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/oraciones_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class OracionesService implements OracionesInterface {
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  @override
  Future<List<OracionResponse>> getAllOraciones() async {
    // Obtener el token del usuario autenticado
    final token = await _tokenService.getToken();

    var url = Uri.parse('$_baseUrl/oraciones');

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
        
        // Parsear el array de oraciones
        List<OracionResponse> listaOraciones = [];
        if (jsonData is List) {
          listaOraciones = jsonData
              .map((oracion) => OracionResponse.fromJson(oracion))
              .toList();
        }
        
        return listaOraciones;
      } else {
        throw Exception(
            'Error al obtener oraciones.');
      }
    } catch (e) {
      throw Exception('Error al obtener oraciones: $e');
    }
  }
}