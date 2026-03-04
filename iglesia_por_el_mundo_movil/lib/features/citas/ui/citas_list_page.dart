import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/citas_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/bloc/citas_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/shared/resumen_cita_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/shared/solicitud_cita_card.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/ui/formulario_cita_page.dart';

class MisCitasScreen extends StatelessWidget {
  final void Function(int)? onNavigate;
  const MisCitasScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CitasBloc(CitasService())..add(CitasSubmitted()),
      child: _CitasView(onNavigate: onNavigate),
    );
  }
}

class _CitasView extends StatelessWidget {
  final void Function(int)? onNavigate;
  const _CitasView({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF8F9FE),
      child: BlocBuilder<CitasBloc, CitasState>(
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
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: citas.isEmpty ? 3 : citas.length + 2,
                    itemBuilder: (context, index) {
                      // Botón nueva solicitud
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (context) => CitasBloc(CitasService()),
                                      child: const FormularioCitaPage(),
                                    ),
                                  ),
                                );
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
                        );
                      }
                      // Tarjetas resumen
                      if (index == 1) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ResumenCitaCard(
                                    titulo: "Total",
                                    valor: totalCitas.toString(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ResumenCitaCard(
                                    titulo: "Aceptadas",
                                    valor: citasAceptadas.toString(),
                                    colorValor: const Color(0xFF00C853),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ResumenCitaCard(
                                    titulo: "Pendientes",
                                    valor: citasPendientes.toString(),
                                    colorValor: const Color(0xFFFF9800),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      // Estado vacío
                      if (citas.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Column(
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'No hay citas registradas',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final cita = citas[index - 2];
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
                        cita: cita,
                      );
                    },
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