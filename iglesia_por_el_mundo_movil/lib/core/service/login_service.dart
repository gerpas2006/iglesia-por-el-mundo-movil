import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iglesia_por_el_mundo_movil/core/config/app_config.dart';
import 'package:iglesia_por_el_mundo_movil/core/interface/login_interface.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/login.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';

class LoginService implements LoginInterface {
  final String _baseUrl = AppConfig.baseUrl;
  final TokenService _tokenService = TokenService();

  @override
  Future<LoginResponse> login(String email, String password) async {
    var url = Uri.parse('$_baseUrl/login');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(jsonResponse);

      // Guardar el token automáticamente
      await _tokenService.saveToken(loginResponse.token);

      return loginResponse;
    } else {
      throw Exception(
        'Failed to login. Status: ${response.statusCode}. Response: ${response.body}',
      );
    }
  }
}