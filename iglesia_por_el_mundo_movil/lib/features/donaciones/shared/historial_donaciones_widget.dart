import 'package:flutter/material.dart';

class HistorialDonacionCard extends StatelessWidget {
  final String tipo;   // Ej: "Diezmo", "Ofrenda"
  final double monto;
  final String fecha;
  final String metodo; // Ej: "Tarjeta", "Efectivo"

  const HistorialDonacionCard({
    super.key,
    required this.tipo,
    required this.monto,
    required this.fecha,
    required this.metodo,
  });

  @override
  Widget build(BuildContext context) {
    // Color verde principal usado en el diseño
    const Color greenColor = Color(0xFF00C853);

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Espacio entre tarjetas
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: greenColor, width: 1.5),
      ),
      child: Column(
        children: [
          // --- Fila Superior: Tipo, Estado y Monto ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Badge Tipo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tipo,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Badge Estado (Fijo como 'Completada' según diseño)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: greenColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Completada",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Monto
              Text(
                "\$${monto.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: greenColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),

          // --- Fila Fecha ---
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                fecha,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),

          // --- Fila Método de Pago ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Método de Pago",
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.credit_card, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    metodo,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}