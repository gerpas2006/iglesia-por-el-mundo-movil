import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/resenea_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/bloc/resenea_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/shared/tarjeta_contenido_resenea.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/shared/tarjetas_numero_reseneas_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/ui/formulario_resenea_page.dart';

class ReseneasListPage extends StatelessWidget {
  final void Function(int)? onNavigate;
  const ReseneasListPage({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReseneaBloc(ReseneaService())..add(ReseneaLoadRequested()),
      child: ColoredBox(
        color: const Color(0xFFF8F9FE),
        child: BlocBuilder<ReseneaBloc, ReseneaState>(
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
                        context.read<ReseneaBloc>().add(ReseneaLoadRequested());
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
              final totalReseneas = state.totalReseneas;
              final promedioCalificacion = state.mediaResena.toStringAsFixed(2);

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ReseneaBloc>().add(ReseneaLoadRequested());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: reseneas.isEmpty ? 3 : reseneas.length + 2,
                  itemBuilder: (context, index) {
                    // Botón nueva reseña
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ReseneaBloc>(),
                                      child: const FormularioReseneaPage(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add, size: 20),
                              label: const Text(
                                "Nueva Reseña",
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
                                child: TarjetasNumeroReseneasWidget(
                                  title: "Calificación Promedio",
                                  value: promedioCalificacion,
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
                        ),
                      );
                    }
                    // Si no hay reseñas, mostrar estado vacío
                    if (reseneas.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              Icon(Icons.rate_review_outlined, size: 60, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No hay reseñas aún',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final resenea = reseneas[index - 2];
                    return TarjetaContenidoResenea(
                      title: resenea.tituloReseneas,
                      description: resenea.comentarioResenea,
                      rating: resenea.calificacionResenea.toDouble(),
                      date: DateTime.parse(resenea.fechaResenea)
                          .toLocal(), // Convertir a hora local si es necesario
                      userName: resenea.user?.name ?? 'Anónimo',
                    );
                  },
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
