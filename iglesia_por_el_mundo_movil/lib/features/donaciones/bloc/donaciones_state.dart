part of 'donaciones_bloc.dart';

@immutable
sealed class DonacionesState {}

final class DonacionesInitial extends DonacionesState {}

final class DonacionesLoading extends DonacionesState {}

final class DonacionesSuccess extends DonacionesState {
  final List<DonacionResponse> listaDonaciones;
  final List<TipoDonacionResponse>? tiposDonacion;

  DonacionesSuccess({required this.listaDonaciones,required this.tiposDonacion});
}

final class DonacionCreada extends DonacionesState {
  final DonacionResponse donacion;

  DonacionCreada(this.donacion);
}

final class DonacionesError extends DonacionesState {
  final String mensaje;

  DonacionesError(this.mensaje);
}
