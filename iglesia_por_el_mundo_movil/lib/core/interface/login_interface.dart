import 'package:iglesia_por_el_mundo_movil/core/models/login.dart';

abstract class LoginInterface {
  Future<LoginResponse> login(String email, String password);
  Future<Map<String, dynamic>> editarUsuario({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
}