part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSucces extends LoginState {
  final String message;
  LoginSucces(this.message);
}

final class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}
