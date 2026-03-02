import 'package:bloc/bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/resenea_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/resenea.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/resenea_service.dart';
import 'package:meta/meta.dart';

part 'resenea_event.dart';
part 'resenea_state.dart';

class ReseneaBloc extends Bloc<ReseneaEvent, ReseneaState> {
  final ReseneaService _reseneaService;
  
  ReseneaBloc(this._reseneaService) : super(ReseneaInitial()) {
    on<ReseneaLoadRequested>(_onReseneaLoadRequested);
    on<ReseneaSubmitted>(_onReseneaSubmitted);
  }

  Future<void> _onReseneaLoadRequested(
    ReseneaLoadRequested event,
    Emitter<ReseneaState> emit,
  ) async {
    emit(ResenaLoading());
    try { 
      final response = await _reseneaService.getAllResenea();

      final totalReseneas = response.length;
      final double promedioCalificacion = totalReseneas > 0
          ? response.map((r) => r.calificacionResenea).reduce((a, b) => a + b) / totalReseneas
          : 0.0;

      emit(ReseneaSucces(
        listaResenea: response,
        mediaResena : promedioCalificacion,
        totalReseneas: totalReseneas,
      ));
    } catch (e) {
      emit(ReseneaError(e.toString()));
    }
  }

  Future<void> _onReseneaSubmitted(
    ReseneaSubmitted event,
    Emitter<ReseneaState> emit,
  ) async {
    emit(ResenaLoading());
    try {
      await _reseneaService.crearResenea(event.resenea);
      emit(ReseneaCreateSuccess());
      final response = await _reseneaService.getAllResenea();

      final totalReseneas = response.length;
      final double promedioCalificacion = totalReseneas > 0
          ? response.map((r) => r.calificacionResenea).reduce((a, b) => a + b) /
              totalReseneas
          : 0.0;

      emit(ReseneaSucces(
        listaResenea: response,
        mediaResena: promedioCalificacion,
        totalReseneas: totalReseneas,
      ));
    } catch (e) {
      emit(ReseneaError(e.toString()));
    }
  }
}
