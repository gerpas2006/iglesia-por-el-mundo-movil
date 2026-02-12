import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/registre_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/registre.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class RegistreService implements RegistreInterface {
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  Future<RegistreResponse> registrer(
    String name,
    String email,
    String password,
  ) async {
    var url = Uri.parse('$_baseUrl/register');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      final registreResponse = RegistreResponse.fromJson(jsonResponse);
      
      // Guardar el token automáticamente
      await _tokenService.saveToken(registreResponse.token);
      
      return registreResponse;
    } else {
      throw Exception('Failed to register user. Status: ${response.statusCode}. Response: ${response.body}');
    }
  }
}
