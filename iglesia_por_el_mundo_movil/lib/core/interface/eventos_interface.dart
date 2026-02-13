import 'package:iglesia_por_el_mundo_movil/core/models/eventos.dart';

abstract class EventosInterface {
  Future<List<EventoResponse>> getAllEventos();
}