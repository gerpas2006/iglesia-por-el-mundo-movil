part of 'perfil_bloc.dart';

@immutable
sealed class PerfilState {}

final class PerfilInitial extends PerfilState {}

final class PerfilLoading extends PerfilState {}

final class PerfilLoaded extends PerfilState {
  final String name;
  final String email;
  final String role;
  final String memberSince;

  PerfilLoaded({
    required this.name,
    required this.email,
    required this.role,
    required this.memberSince,
  });
}

final class PerfilError extends PerfilState {
  final String error;
  PerfilError(this.error);
}
