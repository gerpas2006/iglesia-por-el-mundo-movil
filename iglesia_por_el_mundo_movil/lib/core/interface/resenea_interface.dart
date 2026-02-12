import 'package:iglesia_por_el_mundo_movil/core/models/resenea.dart';

abstract class ReseneaInterface {
  Future<List<ReseneaResponse>> getAllResenea();
}