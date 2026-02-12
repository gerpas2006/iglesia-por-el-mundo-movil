import 'package:iglesia_por_el_mundo_movil/core/models/registre.dart';

abstract class RegistreInterface {
  Future<RegistreResponse> registrer(String name, String email, String password);
}