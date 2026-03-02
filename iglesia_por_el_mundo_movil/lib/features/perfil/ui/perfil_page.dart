import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/features/perfil/shared/informacion_usuario_widget.dart';

class PerfilPage extends StatelessWidget {
  final void Function(int)? onNavigate;
  const PerfilPage({Key? key, this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF8F9FE),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
            children: [
              const InformacionUsuarioWidget(
                name: 'Juan Pérez',
                role: 'Miembro',
                email: 'wq@gmail.com',
                phone: '+1 (555) 987-6543',
                memberSince: 'Marzo 2024',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
  }
}