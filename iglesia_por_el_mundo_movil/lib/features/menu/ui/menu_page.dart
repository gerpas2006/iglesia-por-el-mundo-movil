import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/features/menu/shared/menu_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/oraciones/ui/oraciones_list_page.dart';
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

  void _onFabPressed() {
    setState(() {
      _currentIndex = 2; // índice del botón central
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildPlaceholderPage('Inicio', Icons.home);
      case 1:
        return _buildPlaceholderPage('Donar', Icons.favorite);
      case 2:
        return _buildPlaceholderPage('Ministerios', Icons.work);
      case 3:
        return _buildPlaceholderPage('Citas', Icons.calendar_today);
      case 4:
        return const OracionesListPage();
      case 5:
        return const ReseneasListPage();
      default:
        return _buildPlaceholderPage('Inicio', Icons.home);
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
              color: const Color(0xFF6366F1).withOpacity(0.3),
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
          _getPage(2), // Ministerios (FAB)
          _getPage(3), // Citas
          _getPage(4), // Oraciones
          _getPage(5), // Reseñas
        ],
      ),

      bottomNavigationBar: MenuWidget(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.work, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
