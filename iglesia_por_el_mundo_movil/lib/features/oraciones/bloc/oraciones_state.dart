part of 'oraciones_bloc.dart';

@immutable
sealed class OracionesState {}

final class OracionesInitial extends OracionesState {}

final class OracionesLoading extends OracionesState {}

final class OracionesSucces extends OracionesState {
  final List<OracionResponse> oraciones;
  OracionesSucces(this.oraciones);

  int get totalOraciones => oraciones.length;
}

final class OracionesError extends OracionesState{
  final String error;
  OracionesError(this.error);
}



