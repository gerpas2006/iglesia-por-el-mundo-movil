import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/oraciones_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/oraciones/bloc/oraciones_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/oraciones/shared/tarjeta_contenido_oraciones_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/oraciones/shared/tarjeta_numero_oraciones.dart';

class OracionesListPage extends StatelessWidget {
  const OracionesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OracionesBloc(OracionesService())
        ..add(RegistreSubmitted()), // Cargar oraciones al iniciar
      child: const _OracionesListView(),
    );
  }
}

class _OracionesListView extends StatelessWidget {
  const _OracionesListView();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF8F9FE),
      child: BlocBuilder<OracionesBloc, OracionesState>(
        builder: (context, state) {
          if (state is OracionesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is OracionesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<OracionesBloc>().add(RegistreSubmitted());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is OracionesSucces) {
            // Mostrar lista de oraciones
            final oraciones = state.oraciones;

            if (oraciones.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.church,
                        size: 64,
                        color: Color(0xFF6366F1),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hay oraciones disponibles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3243),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Aún no hay oraciones registradas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              itemCount: oraciones.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 30),
                        Text(
                          "Oraciones",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3243),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Encuentra inspiración y guía en estas oraciones",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (index == 1) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: TarjetaNumeroOraciones(
                      totalOraciones: state.totalOraciones,
                    ),
                  );
                }
                final oracion = oraciones[index - 2];
                return TarjetaContenidoOracionesWidget(oracion: oracion);
              },
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                "Encuentra inspiración y guía en estas oraciones",
                style: TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),

              // Contador de oraciones
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.church, color: Colors.white, size: 32),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cargando oraciones...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}