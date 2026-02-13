import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/eventos_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/eventos.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class EventosService implements EventosInterface{
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();
  
  @override
  Future<List<EventoResponse>> getAllEventos() async {
    var token = await _tokenService.getToken();
    var url = Uri.parse('$_baseUrl/eventos');
    try{
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
        List<EventoResponse> listaEventos = [];
        if (jsonData is List) {
          listaEventos = jsonData
              .map((oracion) => EventoResponse.fromJson(oracion))
              .toList();
        }
        
        return listaEventos;
      } else {
        throw Exception(
            'Error al obtener eventos.');
      }
    } catch (e) {
      throw Exception('Error al obtener eventos: $e');
    }
  }
}