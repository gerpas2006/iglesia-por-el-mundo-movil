import 'package:iglesia_por_el_mundo_movil/core/dto/donaciones_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/donaciones.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_donacion.dart';

abstract class DonacionesInterface {
  Future<List<DonacionResponse>> obtenerDonaciones();
  Future<DonacionResponse> crearDonacion(DonacionesDto donacion);
  Future<List<TipoDonacionResponse>> listarTipoDonacion();

}