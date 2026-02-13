import 'package:bloc/bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/eventos.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/eventos_service.dart';
import 'package:meta/meta.dart';

part 'eventos_event.dart';
part 'eventos_state.dart';

class EventosBloc extends Bloc<EventosEvent, EventosState> {
  EventosBloc(EventosService eventos_service) : super(EventosInitial()) {
    on<EventosEvent>((event, emit) async{
      emit(EventosLoading());
      try{
        var response = eventos_service.getAllEventos();
        emit(EventosSucces(response));
      }catch (e){
        emit(EventosError(e.toString()));
      }
      
    });
  }
}
