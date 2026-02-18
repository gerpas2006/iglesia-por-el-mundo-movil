import 'package:iglesia_por_el_mundo_movil/core/dto/resenea_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/resenea.dart';

abstract class ReseneaInterface {
  Future<List<ReseneaResponse>> getAllResenea();
  Future<ReseneaResponse> crearResenea(ReseneaDTO resenea);
}