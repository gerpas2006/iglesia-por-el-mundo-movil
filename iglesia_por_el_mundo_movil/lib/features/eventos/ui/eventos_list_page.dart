import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/eventos.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/eventos_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/eventos/bloc/eventos_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/eventos/share/eventos_card.dart';
import 'package:iglesia_por_el_mundo_movil/features/eventos/share/resumen_evento_widget.dart';

class EventosScreen extends StatelessWidget {
  const EventosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventosBloc(EventosService())..add(EventosSubmitted()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Eventos',
            style: TextStyle(
              color: Color(0xFF2D3243),
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<EventosBloc, EventosState>(
          builder: (context, state) {
            if (state is EventosInitial) {
              return const Center(
                child: Text('Cargando eventos...'),
              );
            }

            if (state is EventosLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is EventosSucces) {
              return FutureBuilder<List<EventoResponse>>(
                future: state.listaEventos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No hay eventos disponibles'),
                    );
                  }

                  final eventos = snapshot.data!;
                  final totalEventos = eventos.length;
                  
                  // Calcular eventos próximos (usando fecha, por ejemplo eventos futuros)
                  final eventosProximos = eventos.where((evento) {
                    // Asumiendo que hay eventos disponibles o pendientes
                    return evento.fechaEvento != null;
                  }).length;

                  return SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título y Subtítulo
                          const Text(
                            "Eventos de la Iglesia",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Descubre y regístrate en nuestros eventos",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Tarjetas de Resumen
                          Row(
                            children: [
                              Expanded(
                                child: ResumenEventoCard(
                                  titulo: "Total Eventos",
                                  valor: "$totalEventos",
                                  colorValor: const Color(0xFF5C6BC0),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ResumenEventoCard(
                                  titulo: "Eventos Próximos",
                                  valor: "$eventosProximos",
                                  colorValor: const Color(0xFF00C853),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Lista de Eventos
                          ...eventos.map((evento) {
                            // Formatear fecha
                            String fechaFormateada = "Fecha no disponible";
                            if (evento.fechaEvento != null) {
                              final fecha = evento.fechaEvento!;
                              fechaFormateada = "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";
                            }
                            
                            // Determinar estado basado en el valor numérico
                            String estadoTexto = "Terminada";
                            if (evento.estado == 1) {
                              estadoTexto = "Disponible";
                            } else if (evento.estado == 2) {
                              estadoTexto = "En curso";
                            }
                            
                            return EventoCard(
                              tag: evento.tipoEvento?.nombreEvento ?? "Evento",
                              titulo: evento.nombreEvento ?? "Sin título",
                              descripcion: evento.descripcionEvento ?? "Sin descripción",
                              fecha: fechaFormateada,
                              ubicacion: evento.ubicacion ?? "Ubicación no disponible",
                              estado: estadoTexto,
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is EventosError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('Estado desconocido'),
            );
          },
        ),
      ),
    );
  }
}
