import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/core/exceptions/app_exceptions.dart';
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
        
      } on AuthenticationException catch (e) {
        // Status 401: No autenticado - Credenciales inválidas
        if (e.statusCode == 401) {
          emit(LoginError("Credenciales inválidas. Verifica tu correo y contraseña"));
        } else {
          emit(LoginError(e.message));
        }
      } on ValidationException catch (e) {
        // Status 422: Error de validación
        if (e.statusCode == 422) {
          emit(LoginError("Los datos ingresados no son válidos"));
        } else {
          emit(LoginError(e.message));
        }
      } on NetworkException catch (e) {
        // Status 0: Sin conexión
        if (e.statusCode == 0) {
          emit(LoginError("Sin conexión a internet. Verifica tu red"));
        } else {
          emit(LoginError(e.message));
        }
      } on TimeoutException catch (e) {
        // Status 408: Timeout
        if (e.statusCode == 408) {
          emit(LoginError("La solicitud tardó demasiado. Intenta de nuevo"));
        } else {
          emit(LoginError(e.message));
        }
      } on ServerException catch (e) {
        // Status 500+: Error del servidor
        if (e.statusCode >= 500) {
          emit(LoginError("Error en el servidor. Intenta más tarde"));
        } else {
          emit(LoginError(e.message));
        }
      } on AppException catch (e) {
        // Cualquier otra excepción personalizada
        emit(LoginError("${e.message} (Status: ${e.statusCode})"));
      } catch (e) {
        emit(LoginError("Error inesperado: ${e.toString()}"));
      }
    });
  }
}