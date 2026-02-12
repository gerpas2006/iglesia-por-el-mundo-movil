part of 'registre_bloc.dart';

@immutable
sealed class RegistreState {}

final class RegistreInitial extends RegistreState {}

final class RegistreLoading extends RegistreState {}

final class RegistreSuccess extends RegistreState {
  final String message;
  
  RegistreSuccess(this.message);
}

final class RegistreError extends RegistreState {
  final String error;
  
  RegistreError(this.error);
}
