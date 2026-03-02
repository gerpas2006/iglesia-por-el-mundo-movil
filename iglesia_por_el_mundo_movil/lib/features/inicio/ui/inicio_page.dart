import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/eventos_service.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/oraciones_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/inicio/bloc/inicio_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/inicio/shared/oracion_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/inicio/shared/proximos_eventos.dart';
import 'package:iglesia_por_el_mundo_movil/features/menu/shared/menu_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/ui/donaciones_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/ui/citas_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/oraciones/ui/oraciones_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/ui/reseneas_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/eventos/ui/eventos_list_page.dart';


class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(),
    const MisDonacionesScreen(),
    const MisCitasScreen(),
    const OracionesListPage(),
    const ReseneasListPage(),
    const EventosScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: MenuWidget(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InicioBloc(EventosService(), OracionesService())
        ..add(IncioSubmmited()),
      child: BlocBuilder<InicioBloc, InicioState>(
        builder: (context, state) {
          if (state is InicioLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is InicioError) {
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

          if (state is InicioSucces) {
            final oracion = state.getRandomOracion;
            final eventos = state.listaEventos;
            
            // Filtrar solo eventos disponibles (estado == 1)
            final eventosDisponibles = eventos.where((e) => e.estado == 1).toList();
            
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    // 2. Oración aleatoria del día
                    DailyVerseCard(
                      texto: oracion?.textoOracion ?? "Todo lo puedo en Cristo que me fortalece.",
                      referencia: oracion?.autor ?? "Filipenses 4:13",
                    ),

                    const SizedBox(height: 30),

                    // 3. Eventos disponibles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Eventos Disponibles",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                            if (homeState != null) {
                              homeState._onItemTapped(5);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen(initialIndex: 5)),
                              );
                            }
                          },
                          child: const Text("Ver todos"),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    // Lista de eventos disponibles
                    if (eventosDisponibles.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'No hay eventos disponibles',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...eventosDisponibles.take(3).map((evento) {
                        // Formatear fecha
                        String mes = "---";
                        String dia = "--";
                        
                        if (evento.fechaEvento != null) {
                          final fecha = evento.fechaEvento!;
                          final meses = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];
                          mes = meses[fecha.month - 1];
                          dia = fecha.day.toString();
                        }
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: NextEventCard(
                            mes: mes,
                            dia: dia,
                            etiqueta: evento.tipoEvento?.nombreEvento ?? "Evento",
                            titulo: evento.nombreEvento ?? "Sin título",
                            hora: evento.ubicacion ?? "Ubicación no disponible",
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Text('Cargando...'),
          );
        },
      ),
    );
  }
}