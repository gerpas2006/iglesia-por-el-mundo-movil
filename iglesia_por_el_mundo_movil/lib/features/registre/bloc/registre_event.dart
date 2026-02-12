part of 'registre_bloc.dart';

@immutable
sealed class RegistreEvent {}

final class RegistreSubmitted extends RegistreEvent {
  final String name;
  final String email;
  final String password;
  RegistreSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });
}
