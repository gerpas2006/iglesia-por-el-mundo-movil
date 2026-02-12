
import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/oracione.dart';

class TarjetaContenidoOracionesWidget extends StatelessWidget {
  final OracionResponse oracion;

  const TarjetaContenidoOracionesWidget({required this.oracion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera con tipo de oración
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.church,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        oracion.nombreOracion,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (oracion.tipoOracion != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          oracion.tipoOracion!.nombreOracion,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contenido de la oración
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  oracion.textoOracion,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF2D3243),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Autor
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      oracion.autor,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}