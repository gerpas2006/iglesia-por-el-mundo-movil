import 'package:bloc/bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/citas.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/citas_service.dart';
import 'package:meta/meta.dart';

part 'citas_event.dart';
part 'citas_state.dart';

class CitasBloc extends Bloc<CitasEvent, CitasState> {
  CitasBloc(CitasService citas_service) : super(CitasInitial()) {
    on<CitasEvent>((event, emit) async{
      emit(CitasLoading());
      try{
        var response = citas_service.getAllCitas();
        emit(CitasSucces(response));
      }catch (e){
        emit(CitasError(e.toString()));
      }
    });
  }
}
