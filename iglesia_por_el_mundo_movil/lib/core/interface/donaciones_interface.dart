import 'package:iglesia_por_el_mundo_movil/core/models/donaciones.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';

abstract class DonacionesInterface {
  Future<List<DonacionResponse>> obtenerDonaciones();

}