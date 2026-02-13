import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/donaciones_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/bloc/donaciones_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/shared/historial_donaciones_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/shared/resumen_donaciones_widget.dart';

class MisDonacionesScreen extends StatelessWidget {
  const MisDonacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DonacionesBloc(DonacionesService())
        ..add(DonacionesLoadRequested()),
      child: const _DonacionesView(),
    );
  }
}

class _DonacionesView extends StatelessWidget {
  const _DonacionesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mis Donaciones',
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
              context.read<DonacionesBloc>().add(DonacionesLoadRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<DonacionesBloc, DonacionesState>(
        builder: (context, state) {
          if (state is DonacionesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DonacionesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar las donaciones',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.mensaje,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<DonacionesBloc>().add(DonacionesLoadRequested());
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

          if (state is DonacionesSuccess) {
            final donaciones = state.listaDonaciones;
            
            // Calcular estadísticas
            final totalDonado = donaciones.fold<double>(
              0, 
              (sum, donacion) => sum + (donacion.donacion ?? 0)
            );
            final totalDonaciones = donaciones.length;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DonacionesBloc>().add(DonacionesLoadRequested());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Botón Nueva Donación
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Navegar a formulario de nueva donación
                        },
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text(
                          "Nueva Donación",
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
                          child: ResumenDonacionCard(
                            titulo: "Total Donado",
                            valor: "\$${totalDonado.toStringAsFixed(2)}",
                            colorTexto: const Color(0xFF5C6BC0),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ResumenDonacionCard(
                            titulo: "Total de Donaciones",
                            valor: totalDonaciones.toString(),
                            colorTexto: const Color(0xFF5C6BC0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sección Historial
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Historial de Donaciones",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF37474F),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Todas tus contribuciones registradas",
                            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 20),

                          // Lista de donaciones
                          if (donaciones.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.volunteer_activism_outlined,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No hay donaciones registradas',
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
                            ...donaciones.map((donacion) {
                              final tipoDonacion = donacion.tipoDonacion?.nombreDonacion ?? 'Donación';
                              final monto = donacion.donacion ?? 0.0;
                              final fecha = donacion.fechaDonacion != null
                                  ? '${donacion.fechaDonacion!.day}/${donacion.fechaDonacion!.month}/${donacion.fechaDonacion!.year}'
                                  : 'Fecha no disponible';
                              final metodo = donacion.metodo ?? 'No especificado';

                              return HistorialDonacionCard(
                                tipo: tipoDonacion,
                                monto: monto,
                                fecha: fecha,
                                metodo: metodo,
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}