part of 'donaciones_bloc.dart';

@immutable
sealed class DonacionesEvent {}

final class DonacionesLoadRequested extends DonacionesEvent {}
