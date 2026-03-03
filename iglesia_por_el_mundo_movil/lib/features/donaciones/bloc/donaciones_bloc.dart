import 'package:bloc/bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/donaciones_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/donaciones.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_donacion.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/donaciones_service.dart';
import 'package:meta/meta.dart';

part 'donaciones_event.dart';
part 'donaciones_state.dart';

class DonacionesBloc extends Bloc<DonacionesEvent, DonacionesState> {
  DonacionesBloc(DonacionesService donacionesService) : super(DonacionesInitial()) {
    on<DonacionesLoadRequested>((event, emit) async{

      emit(DonacionesLoading());
      try{
        var response = await donacionesService.obtenerDonaciones();
        var listaTipoDonacion = await donacionesService.listarTipoDonacion();
        emit(DonacionesSuccess(listaDonaciones: response, tiposDonacion: listaTipoDonacion));
      } catch (e) {
        emit(DonacionesError(e.toString()));
      }
    });

    on<LoadTiposDonacion>((event, emit) async {
      try {
        var listaTipoDonacion = await donacionesService.listarTipoDonacion();
        emit(DonacionesSuccess(listaDonaciones: [], tiposDonacion: listaTipoDonacion));
      } catch (e) {
        emit(DonacionesError(e.toString()));
      }
    });

    on<DonacionCreateRequested>((event, emit) async {
      emit(DonacionesLoading());
      try {
        var response = await donacionesService.crearDonacion(event.donacion);
        emit(DonacionCreada(response));
      } catch (e) {
        emit(DonacionesError(e.toString()));
      }
    });
  }
}
