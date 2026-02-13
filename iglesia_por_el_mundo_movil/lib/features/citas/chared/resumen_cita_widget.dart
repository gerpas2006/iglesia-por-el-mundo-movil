import 'package:flutter/material.dart';

class ResumenCitaCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color? colorValor; // Para cambiar el color del número (Verde, Naranja, Negro)

  const ResumenCitaCard({
    super.key,
    required this.titulo,
    required this.valor,
    this.colorValor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Altura ajustada
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
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
              fontSize: 28,
              fontWeight: FontWeight.bold,
              // Si no se pasa color, usa negro/gris oscuro por defecto
              color: colorValor ?? const Color(0xFF2C3E50), 
            ),
          ),
        ],
      ),
    );
  }
}