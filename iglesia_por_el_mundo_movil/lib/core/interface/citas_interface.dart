import 'package:iglesia_por_el_mundo_movil/core/models/citas.dart';

abstract class CitasInterface {
  Future<List<CitaResponse>> getAllCitas();
}