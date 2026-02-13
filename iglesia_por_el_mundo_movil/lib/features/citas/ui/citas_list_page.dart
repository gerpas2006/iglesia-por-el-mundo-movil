import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/citas_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/bloc/citas_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/chared/resumen_cita_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/chared/solicitud_cita_card.dart';

class MisCitasScreen extends StatelessWidget {
  const MisCitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CitasBloc(CitasService())..add(CitasSubmitted()),
      child: const _CitasView(),
    );
  }
}

class _CitasView extends StatelessWidget {
  const _CitasView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mis Solicitudes de Citas',
          style: TextStyle(
            color: Color(0xFF2D3243),
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: () {
              context.read<CitasBloc>().add(CitasSubmitted());
            },
          ),
        ],
      ),
      body: BlocBuilder<CitasBloc, CitasState>(
        builder: (context, state) {
          if (state is CitasLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CitasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar las citas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.error,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<CitasBloc>().add(CitasSubmitted());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is CitasSucces) {
            return FutureBuilder(
              future: state.listaCitas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final citas = snapshot.data ?? [];
                
                // Calcular estadísticas
                final totalCitas = citas.length;
                final citasAceptadas = citas.where((c) => c.estado?.toLowerCase() == 'aprobada' || c.estado?.toLowerCase() == 'aceptada').length;
                final citasPendientes = citas.where((c) => c.estado?.toLowerCase() == 'pendiente').length;

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<CitasBloc>().add(CitasSubmitted());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Botón Nueva Solicitud
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navegar a formulario de nueva cita
                            },
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text(
                              "Nueva Solicitud",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5C6BC0),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tarjetas de Resumen
                        Row(
                          children: [
                            Expanded(
                              child: ResumenCitaCard(
                                titulo: "Total de Solicitudes",
                                valor: totalCitas.toString(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ResumenCitaCard(
                                titulo: "Aceptadas",
                                valor: citasAceptadas.toString(),
                                colorValor: const Color(0xFF00C853),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ResumenCitaCard(
                                titulo: "Pendientes",
                                valor: citasPendientes.toString(),
                                colorValor: const Color(0xFFFF9800),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Sección Lista de Solicitudes
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Mis Solicitudes",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF37474F),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Historial de todas tus solicitudes",
                                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                              ),
                              const SizedBox(height: 20),

                              // Lista de citas
                              if (citas.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No hay citas registradas',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                ...citas.map((cita) {
                                  final nombreCita = cita.tipoCita?.nombreCita ?? 'Cita';
                                  final estado = cita.estado ?? 'Desconocido';
                                  final fechaCita = cita.fechaYHoraCita != null
                                      ? '${cita.fechaYHoraCita!.day}/${cita.fechaYHoraCita!.month}/${cita.fechaYHoraCita!.year}'
                                      : 'Sin fecha';
                                  final horaCita = cita.fechaYHoraCita != null
                                      ? '${cita.fechaYHoraCita!.hour.toString().padLeft(2, '0')}:${cita.fechaYHoraCita!.minute.toString().padLeft(2, '0')}'
                                      : '--:--';
                                  final fechaSolicitud = cita.createdAt != null
                                      ? '${cita.createdAt!.day} ${_getMonthAbbreviation(cita.createdAt!.month)}'
                                      : 'Sin fecha';

                                  return SolicitudCitaCard(
                                    nombreCita: nombreCita,
                                    estado: estado,
                                    fechaCita: fechaCita,
                                    horaCita: horaCita,
                                    fechaSolicitud: fechaSolicitud,
                                  );
                                }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return months[month - 1];
  }
}