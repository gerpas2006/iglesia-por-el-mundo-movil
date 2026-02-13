part of 'inicio_bloc.dart';

@immutable
sealed class InicioState {}

final class InicioInitial extends InicioState {}

final class InicioLoading extends InicioState {}

final class InicioSucces extends InicioState {
  List<EventoResponse> listaEventos;
  OracionResponse? getRandomOracion;
  InicioSucces({required this.getRandomOracion,required this.listaEventos});
}

final class InicioError extends InicioState {
  final String error;
  InicioError(this.error);
}
