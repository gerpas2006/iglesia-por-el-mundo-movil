import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/login_service.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginService loginService) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async{
      emit(LoginLoading());
      try{
        var response = await loginService.login(event.email, event.password);
        
        // Verificar el rol del usuario
        if (response.user.role == 'user') {
          emit(LoginSucces("Bienvenido ${response.user.name}"));
        } else {
          emit(LoginError("No tienes permisos para acceder a esta aplicación"));
        }
        
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    });
  }
}