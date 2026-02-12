import 'package:bloc/bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/oraciones_service.dart';
import 'package:meta/meta.dart';

part 'oraciones_event.dart';
part 'oraciones_state.dart';

class OracionesBloc extends Bloc<OracionesEvent, OracionesState> {
  OracionesBloc(OracionesService oracionesService) : super(OracionesInitial()) {
    on<OracionesEvent>((event, emit) async{
      // TODO: implement event handler
      emit(OracionesLoading());
      try{
        var response = await oracionesService.getAllOraciones();
        emit(OracionesSucces(response));
      }catch (e){
        emit(OracionesError(e.toString()));
      }
    });
  }
}
