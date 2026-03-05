part of 'eventos_bloc.dart';

@immutable
sealed class EventosState {}

final class EventosInitial extends EventosState {}

final class EventosLoading extends EventosState {}

final class EventosSucces extends EventosState {
  final List<EventoResponse> listaEventos;
  EventosSucces(this.listaEventos);
}

final class EventosError extends EventosState {
  final String error;
  EventosError(this.error);
}