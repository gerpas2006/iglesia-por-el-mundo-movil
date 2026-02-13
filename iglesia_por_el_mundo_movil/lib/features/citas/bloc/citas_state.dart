part of 'citas_bloc.dart';

@immutable
sealed class CitasState {}

final class CitasInitial extends CitasState {}

final class CitasLoading extends CitasState {}

final class CitasSucces extends CitasState {
  Future<List<CitaResponse>> listaCitas;
  CitasSucces(this.listaCitas);
}

final class CitasError extends CitasState {
  final String error;
  CitasError(this.error);
}
