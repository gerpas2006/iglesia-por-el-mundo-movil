import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/registre_service.dart';

part 'registre_event.dart';
part 'registre_state.dart';

class RegistreBloc extends Bloc<RegistreEvent, RegistreState> {
  RegistreBloc(RegistreService registreService) : super(RegistreInitial()) {
    on<RegistreSubmitted>((event, emit) async {
      emit(RegistreLoading());
      try {
        var response = await registreService.registrer(
          event.name,
          event.email,
          event.password,
        );
        emit(RegistreSuccess('Cuenta Creada con exito'));
      } catch (e) {
        emit(RegistreError(e.toString()));
      }
    });
  }
}
