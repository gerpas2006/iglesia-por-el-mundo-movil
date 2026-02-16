import 'package:flutter/material.dart';

class EventoCard extends StatelessWidget {
  final String tag;           // Ej: "Servicio", "Estudio Bíblico"
  final String titulo;        // Ej: "Servicio Dominical"
  final String descripcion;   // Ej: "Servicio de adoración..."
  final String fecha;         // Ej: "domingo, 12 de octubre..."         // Ej: "10:00 hrs"
  final String ubicacion;     // Ej: "Templo Principal"
  final String estado;        // Ej: "Disponible", "Terminada"

  const EventoCard({
    super.key,
    required this.tag,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.ubicacion,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos colores según el estado
    final bool esDisponible = estado.toLowerCase() == 'disponible';
    final Color colorEstado = esDisponible ? const Color(0xFF00C853) : const Color(0xFFFF0000); // Verde o Rojo
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Fila Superior: Tag y Estado ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tag (Píldora blanca con borde gris)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              
              // Badge Estado (Color sólido)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colorEstado,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  estado,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // --- Título y Descripción ---
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            descripcion,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),

          const SizedBox(height: 20),

          // --- Detalles (Iconos) ---
          _buildDetailRow(Icons.calendar_today_outlined, fecha),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.location_on_outlined, ubicacion),
        ],
      ),
    );
  }

  // Widget auxiliar para las filas de detalles (Icono + Texto)
  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[500]),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}