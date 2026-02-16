part of 'resenea_bloc.dart';

@immutable
sealed class ReseneaEvent {}

final class ReseneaLoadRequested extends ReseneaEvent {}

final class ReseneaSubmitted extends ReseneaEvent{
  final ReseneaDTO resenea;
  ReseneaSubmitted(this.resenea);
}
