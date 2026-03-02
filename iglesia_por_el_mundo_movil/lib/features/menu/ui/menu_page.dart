import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/features/menu/shared/menu_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/oraciones/ui/oraciones_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/eventos/ui/eventos_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/inicio/ui/inicio_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/perfil/ui/perfil_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/perfil/shared/perfil_header_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/perfil/shared/navegacion_superior_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/ui/donaciones_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/ui/citas_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/ui/reseneas_list_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_currentIndex >= 3)
            ColoredBox(
              color: const Color(0xFFF8F9FE),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const PerfilHeaderWidget(),
                  const SizedBox(height: 8),
                  NavegacionSuperiorWidget(onNavigate: _onItemTapped),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
          const HomeContent(),                                    // 0 - Inicio
          const EventosScreen(),                                   // 1 - Eventos
          const OracionesListPage(),                               // 2 - Oraciones
          PerfilPage(onNavigate: _onItemTapped),                   // 3 - Perfil
          MisDonacionesScreen(onNavigate: _onItemTapped),          // 4 - Donaciones
          MisCitasScreen(onNavigate: _onItemTapped),               // 5 - Citas
          ReseneasListPage(onNavigate: _onItemTapped),             // 6 - Reseñas
            ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuWidget(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
