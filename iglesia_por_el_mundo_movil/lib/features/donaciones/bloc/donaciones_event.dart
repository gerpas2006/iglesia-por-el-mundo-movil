part of 'donaciones_bloc.dart';

@immutable
sealed class DonacionesEvent {}

final class DonacionesLoadRequested extends DonacionesEvent {}

final class LoadTiposDonacion extends DonacionesEvent {}

final class DonacionCreateRequested extends DonacionesEvent {
  final DonacionesDto donacion;

  DonacionCreateRequested(this.donacion);
}
