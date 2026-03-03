import 'package:bloc/bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/token_service.dart';
import 'package:meta/meta.dart';

part 'perfil_event.dart';
part 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  final TokenService _tokenService;

  PerfilBloc({TokenService? tokenService})
      : _tokenService = tokenService ?? TokenService(),
        super(PerfilInitial()) {
    on<LoadPerfilData>(_onLoadPerfilData);
  }

  Future<void> _onLoadPerfilData(
    LoadPerfilData event,
    Emitter<PerfilState> emit,
  ) async {
    emit(PerfilLoading());
    try {
      final name = await _tokenService.getUserName();
      final email = await _tokenService.getUserEmail();
      final role = await _tokenService.getUserRole();
      final memberSince = await _tokenService.getMemberSince();

      emit(PerfilLoaded(
        name: name ?? '',
        email: email ?? '',
        role: role ?? '',
        memberSince: memberSince ?? '',
      ));
    } catch (e) {
      emit(PerfilError(e.toString()));
    }
  }
}
