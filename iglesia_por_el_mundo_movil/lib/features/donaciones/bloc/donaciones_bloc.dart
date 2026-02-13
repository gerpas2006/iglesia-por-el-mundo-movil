import 'package:bloc/bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/donaciones.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/donaciones_service.dart';
import 'package:meta/meta.dart';

part 'donaciones_event.dart';
part 'donaciones_state.dart';

class DonacionesBloc extends Bloc<DonacionesEvent, DonacionesState> {
  DonacionesBloc(DonacionesService donacionesService) : super(DonacionesInitial()) {
    on<DonacionesEvent>((event, emit) async{

      emit(DonacionesLoading());
      try{
        var response = await donacionesService.obtenerDonaciones();
        emit(DonacionesSuccess(response));
      } catch (e) {
        emit(DonacionesError(e.toString()));
      }
    });
  }
}
