import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/donaciones_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/bloc/donaciones_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/shared/historial_donaciones_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/shared/resumen_donaciones_widget.dart';

class MisDonacionesScreen extends StatelessWidget {
  final void Function(int)? onNavigate;
  const MisDonacionesScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DonacionesBloc(DonacionesService())
        ..add(DonacionesLoadRequested()),
      child: _DonacionesView(onNavigate: onNavigate),
    );
  }
}

class _DonacionesView extends StatelessWidget {
  final void Function(int)? onNavigate;
  const _DonacionesView({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF8F9FE),
      child: BlocBuilder<DonacionesBloc, DonacionesState>(
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
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                itemCount: donaciones.isEmpty ? 2 : donaciones.length + 1,
                itemBuilder: (context, index) {
                  // Tarjetas resumen
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      ),
                    );
                  }
                  // Estado vacío
                  if (donaciones.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            Icon(Icons.volunteer_activism_outlined, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay donaciones registradas',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final donacion = donaciones[index - 1];
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
                    donacion: donacion,
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}