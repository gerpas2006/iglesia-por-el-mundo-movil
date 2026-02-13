import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';

abstract class OracionesInterface {
  Future<List<OracionResponse>> getAllOraciones();
  Future<OracionResponse?> getRandomOracion();
}