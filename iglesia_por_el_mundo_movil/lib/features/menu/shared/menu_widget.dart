import 'package:flutter/material.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(icon: Icons.home, label: "Inicio", index: 0),
            _buildItem(icon: Icons.favorite_border, label: "Donar", index: 1),

            const SizedBox(width: 40), // espacio para FAB

            _buildItem(icon: Icons.calendar_today, label: "Citas", index: 3),
            _buildItem(icon: Icons.menu_book, label: "Orar", index: 4),
            _buildItem(icon: Icons.star_border, label: "Reseñas", index: 5),
          ],
        ),
      ),
    );
  }
}
