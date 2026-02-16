import 'package:flutter/material.dart';

class SolicitudCitaCard extends StatelessWidget {
  final String nombreCita;      // Ej: "Consejería", "Bautizo"
  final String estado;          // Ej: "Aprobada", "Pendiente"
  final String fechaCita;       // Ej: "15 oct 2025"
  final String horaCita;        // Ej: "15:00"
  final String fechaSolicitud;  // Ej: "3 oct"

  const SolicitudCitaCard({
    super.key,
    required this.nombreCita,
    required this.estado,
    required this.fechaCita,
    required this.horaCita,
    required this.fechaSolicitud,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos colores según el estado
    final isAprobada = estado.toLowerCase() == 'aprobada' || estado.toLowerCase() == 'aceptada';
    final colorEstado = isAprobada ? const Color(0xFF00C853) : const Color(0xFFFF9800); // Verde o Naranja
    final colorBorde = const Color(0xFFAB47BC); // Morado claro (Purple 400)

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorBorde, width: 1.5), // Borde morado característico
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Título e Icono
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: colorBorde, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      nombreCita,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 2. Badge de Estado
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorEstado, 
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    estado,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),

                // 3. Fechas (Row con dos columnas)
                Row(
                  children: [
                    // Columna 1: Fecha Solicitada
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fecha Solicitada", style: _labelStyle()),
                          const SizedBox(height: 4),
                          Text(fechaCita, style: _valueStyle()),
                          Text(horaCita, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                    // Columna 2: Fecha de Solicitud (creación)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fecha de Solicitud", style: _labelStyle()),
                          const SizedBox(height: 4),
                          Text(fechaSolicitud, style: _valueStyle()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Botón inferior "Ver Detalles"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6), // Gris muy claro de fondo
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.remove_red_eye_outlined, size: 18, color: Color(0xFF37474F)),
                const SizedBox(width: 8),
                Text(
                  "Ver Detalles",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() => TextStyle(fontSize: 11, color: Colors.grey[500]);
  TextStyle _valueStyle() => const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF37474F));
}