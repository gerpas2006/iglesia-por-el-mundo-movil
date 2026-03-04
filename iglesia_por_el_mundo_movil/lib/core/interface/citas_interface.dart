import 'package:iglesia_por_el_mundo_movil/core/dto/citas_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/citas_editar_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/citas.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_citas.dart';

abstract class CitasInterface {
  Future<List<CitaResponse>> getAllCitas();
  Future<CitaResponse> crearCita(CitasDto cita);
  Future<List<TipoCitaResponse>> listarTipoCita();
  Future<CitaResponse> editarCita(CitasEditarDto cita);
}