import 'package:flutter/material.dart';

class ResumenEventoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color? colorValor; // Para personalizar el color del número

  const ResumenEventoCard({
    super.key,
    required this.titulo,
    required this.valor,
    this.colorValor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            valor,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colorValor ?? const Color(0xFF5C6BC0), // Índigo por defecto
            ),
          ),
        ],
      ),
    );
  }
}