part of 'resenea_bloc.dart';

@immutable
sealed class ReseneaState {}

final class ReseneaInitial extends ReseneaState {}

final class ResenaLoading extends ReseneaState {}

final class ReseneaSucces extends ReseneaState {
  final List<ReseneaResponse> listaResenea;
  final int totalReseneas;
  final double mediaResena;
  ReseneaSucces({
    required this.listaResenea,
    required this.totalReseneas,
    required this.mediaResena,
  });
}

final class ReseneaCreateSuccess extends ReseneaState {}

final class ReseneaError extends ReseneaState {
  final String error;
  ReseneaError(this.error);
}