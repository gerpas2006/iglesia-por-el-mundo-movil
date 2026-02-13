part of 'donaciones_bloc.dart';

@immutable
sealed class DonacionesState {}

final class DonacionesInitial extends DonacionesState {}

final class DonacionesLoading extends DonacionesState {}

final class DonacionesSuccess extends DonacionesState {
  final List<DonacionResponse> listaDonaciones;

  DonacionesSuccess(this.listaDonaciones);
}

final class DonacionesError extends DonacionesState {
  final String mensaje;

  DonacionesError(this.mensaje);
}
