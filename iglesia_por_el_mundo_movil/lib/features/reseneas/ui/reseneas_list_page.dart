import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/resenea_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/bloc/resenea_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/shared/boton_nueva_resenea.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/shared/tarjeta_contenido_resenea.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/shared/tarjetas_numero_reseneas_widget.dart';

class ReseneasListPage extends StatelessWidget {
  const ReseneasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReseneaBloc(ReseneaService())..add(ReseneaSubmitted()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Reseñas de la Iglesia")),
        body: BlocBuilder<ReseneaBloc, ReseneaState>(
          builder: (context, state) {
            if (state is ResenaLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReseneaError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar las reseñas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(state.error),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ReseneaBloc>().add(ReseneaSubmitted());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (state is ReseneaSucces) {
              final reseneas = state.listaResenea;
              
              // Calcular estadísticas
              final totalReseneas = state.totalReseneas;
              final promedioCalificacion = state.mediaResena.toStringAsFixed(2);

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Botón
                    BotonNuevaResenea(onPressed: () {
                      // Acción al presionar - navegar a formulario de nueva reseña
                    }),
                    const SizedBox(height: 16),

                    // Tarjetas resumen
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TarjetasNumeroReseneasWidget(
                                title: "Calificación Promedio",
                                value: promedioCalificacion.toString(),
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TarjetasNumeroReseneasWidget(
                                title: "Total de Reseñas",
                                value: totalReseneas.toString(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TarjetasNumeroReseneasWidget(
                                title: "Mis Reseñas",
                                value: totalReseneas.toString(),
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: TarjetasNumeroReseneasWidget(
                                title: "Pendientes",
                                value: "0",
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Lista de reseñas
                    Expanded(
                      child: reseneas.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.rate_review_outlined, size: 60, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    'No hay reseñas aún',
                                    style: TextStyle(fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                context.read<ReseneaBloc>().add(ReseneaSubmitted());
                              },
                              child: ListView.builder(
                                itemCount: reseneas.length,
                                itemBuilder: (context, index) {
                                  final resenea = reseneas[index];
                                  return TarjetaContenidoResenea(
                                    title: resenea.tituloReseneas,
                                    description: resenea.comentarioResenea,
                                    rating: resenea.calificacionResenea.toDouble(),
                                    status: "Aprobada", // Puedes ajustar según tu lógica
                                    date: DateTime.parse(resenea.fechaResenea),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
