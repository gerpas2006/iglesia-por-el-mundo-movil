part of 'citas_bloc.dart';

@immutable
sealed class CitasState {}

final class CitasInitial extends CitasState {}

final class CitasLoading extends CitasState {}

final class CitasSucces extends CitasState {
  final Future<List<CitaResponse>> listaCitas;
  CitasSucces(this.listaCitas);
}

final class CitasError extends CitasState {
  final String error;
  CitasError(this.error);
}

final class TipoCitaListLoading extends CitasState {}

final class TipoCitaListSuccess extends CitasState {
  final List<TipoCitaResponse> listaTipoCitas;
  TipoCitaListSuccess(this.listaTipoCitas);
}

final class CitaCreada extends CitasState {
  final CitaResponse cita;
  CitaCreada(this.cita);
}
