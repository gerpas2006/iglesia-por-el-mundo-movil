import 'package:flutter/material.dart';

class ResumenDonacionCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color? colorTexto; // Hice el color opcional para manejar un default si quieres

  const ResumenDonacionCard({
    super.key,
    required this.titulo,
    required this.valor,
    this.colorTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130, // Altura fija
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: 26, // Ajustado ligeramente
              fontWeight: FontWeight.bold,
              color: colorTexto ?? const Color(0xFF5C6BC0), // Color por defecto si no se pasa
            ),
          ),
        ],
      ),
    );
  }
}