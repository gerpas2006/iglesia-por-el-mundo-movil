import 'package:bloc/bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/citas_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/citas_editar_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/citas.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_citas.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/citas_service.dart';
import 'package:meta/meta.dart';

part 'citas_event.dart';
part 'citas_state.dart';

class CitasBloc extends Bloc<CitasEvent, CitasState> {
  final CitasService _citasService;

  CitasBloc(CitasService citasService)
      : _citasService = citasService,
        super(CitasInitial()) {
    on<CitasSubmitted>(_onGetAllCitas);
    on<CitasListarTipoCita>(_onListarTipoCita);
    on<CitasCrearCita>(_onCrearCita);
    on<CitasEditarCita>(_onEditarCita);
  }

  Future<void> _onGetAllCitas(
      CitasSubmitted event, Emitter<CitasState> emit) async {
    emit(CitasLoading());
    try {
      var response = _citasService.getAllCitas();
      emit(CitasSucces(response));
    } catch (e) {
      emit(CitasError(e.toString()));
    }
  }

  Future<void> _onListarTipoCita(
      CitasListarTipoCita event, Emitter<CitasState> emit) async {
    emit(TipoCitaListLoading());
    try {
      var response = await _citasService.listarTipoCita();
      emit(TipoCitaListSuccess(response));
    } catch (e) {
      emit(CitasError(e.toString()));
    }
  }

  Future<void> _onCrearCita(
      CitasCrearCita event, Emitter<CitasState> emit) async {
    emit(CitasLoading());
    try {
      var response = await _citasService.crearCita(event.cita);
      emit(CitaCreada(response));
    } catch (e) {
      emit(CitasError(e.toString()));
    }
  }

  Future<void> _onEditarCita(
      CitasEditarCita event, Emitter<CitasState> emit) async {
    emit(CitasLoading());
    try {
      var response = await _citasService.editarCita(event.cita);
      emit(CitaCreada(response));
    } catch (e) {
      emit(CitasError(e.toString()));
    }
  }
}
