import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/donaciones_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/bloc/donaciones_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/ui/formulario_donacion_page.dart';

class MenuWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MenuWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  Widget _buildItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? const Color(0xFF5C6BC0) : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF5C6BC0) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Barra inferior
        BottomAppBar(
          height: 50,
          elevation: 10,
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildItem(icon: Icons.home_rounded, label: "Inicio", index: 0),
                _buildItem(icon: Icons.event_rounded, label: "Eventos", index: 1),
                const SizedBox(width: 64), // espacio para el botón central
                _buildItem(icon: Icons.menu_book_rounded, label: "Oraciones", index: 2),
                _buildItem(icon: Icons.person_rounded, label: "Perfil", index: 3),
              ],
            ),
          ),
        ),
        // Botón Donar flotando por encima
        Positioned(
          top: -20,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => DonacionesBloc(DonacionesService()),
                    child: const FormularioDonacionPage(),
                  ),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5C6BC0),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x555C6BC0),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.volunteer_activism_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Donar',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5C6BC0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
