import 'package:flutter/material.dart';

class NavegacionSuperiorWidget extends StatelessWidget {
  final void Function(int)? onNavigate;
  const NavegacionSuperiorWidget({Key? key, this.onNavigate}) : super(key: key);

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF5C6BC0).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF5C6BC0), size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5C6BC0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.person_outline,
            label: 'Perfil',
            onTap: () => onNavigate?.call(3),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.volunteer_activism_outlined,
            label: 'Donaciones',
            onTap: () => onNavigate?.call(4),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: 'Citas',
            onTap: () => onNavigate?.call(5),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.star_border_outlined,
            label: 'Reseñas',
            onTap: () => onNavigate?.call(6),
          ),
        ],
      ),
    );
  }
}
