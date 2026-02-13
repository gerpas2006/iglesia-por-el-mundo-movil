import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/eventos.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/eventos_service.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/oraciones_service.dart';
import 'package:meta/meta.dart';

part 'inicio_event.dart';
part 'inicio_state.dart';

class InicioBloc extends Bloc<InicioEvent, InicioState> {
  final EventosService _eventosService;
  final OracionesService _oracionesService;

  InicioBloc(this._eventosService, this._oracionesService) : super(InicioInitial()) {
    on<IncioSubmmited>((event, emit) async {
      emit(InicioLoading());
      try {
        var listaEventos = await _eventosService.getAllEventos();
        var oracionRandom = await _oracionesService.getRandomOracion();
        emit(InicioSucces(
          getRandomOracion: oracionRandom,
          listaEventos: listaEventos,
        ));
      } catch (e) {
        emit(InicioError(e.toString()));
      }
    });
  }
}
