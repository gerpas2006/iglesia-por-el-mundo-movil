import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/features/menu/shared/menu_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/oraciones/ui/oraciones_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/ui/reseneas_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/ui/donaciones_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/ui/citas_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/eventos/ui/eventos_list_page.dart';
import 'package:iglesia_por_el_mundo_movil/features/inicio/ui/inicio_page.dart';

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

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomeContent();
      case 1:
        return const MisDonacionesScreen();
      case 2:
        return const MisCitasScreen();
      case 3:
        return const OracionesListPage();
      case 4:
        return const ReseneasListPage();
      case 5:
        return const EventosScreen();
      default:
        return const HomeContent();
    }
  }

  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2D3243),
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 100,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3243),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Próximamente',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _getPage(0), // Inicio
          _getPage(1), // Donar
          _getPage(2), // Citas
          _getPage(3), // Oraciones
          _getPage(4), // Reseñas
          _getPage(5), // Eventos

        ],
      ),

      bottomNavigationBar: MenuWidget(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
