part of 'citas_bloc.dart';

@immutable
sealed class CitasEvent {}

final class CitasSubmitted extends CitasEvent {}

final class CitasListarTipoCita extends CitasEvent {}

final class CitasCrearCita extends CitasEvent {
  final CitasDto cita;
  CitasCrearCita(this.cita);
}

final class CitasEditarCita extends CitasEvent {
  final CitasEditarDto cita;
  CitasEditarCita(this.cita);
}
