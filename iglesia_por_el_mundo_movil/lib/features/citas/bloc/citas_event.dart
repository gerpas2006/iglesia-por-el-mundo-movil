part of 'citas_bloc.dart';

@immutable
sealed class CitasEvent {}

final class CitasSubmitted extends CitasEvent {}
