import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/donaciones.dart';

class HistorialDonacionCard extends StatelessWidget {
  final String tipo;
  final double monto;
  final String fecha;
  final String metodo;
  final DonacionResponse donacion;

  const HistorialDonacionCard({
    super.key,
    required this.tipo,
    required this.monto,
    required this.fecha,
    required this.metodo,
    required this.donacion,
  });

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFF5C6BC0);
    const Color completedColor = Color(0xFF00C853);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título e icono
                Row(
                  children: [
                    const Icon(Icons.volunteer_activism, color: borderColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      tipo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Badge estado + monto
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: completedColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Completada',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '\$${monto.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: completedColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),

                // Fecha y método en dos columnas
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha', style: _labelStyle()),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(fecha, style: _valueStyle()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Método de Pago', style: _labelStyle()),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.credit_card, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(metodo, style: _valueStyle()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pie de tarjeta
          GestureDetector(
            onTap: () => _mostrarDetalles(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_red_eye_outlined, size: 18, color: Colors.grey[800]),
                  const SizedBox(width: 8),
                  Text(
                    'Ver Detalles',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalles(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Título
              Row(
                children: [
                  const Icon(Icons.volunteer_activism, color: Color(0xFF5C6BC0), size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      donacion.tipoDonacion?.nombreDonacion ?? 'Donación',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3243),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (donacion.tipoDonacion?.descripcionDonacion != null) ...
                [
                  Text(
                    donacion.tipoDonacion!.descripcionDonacion!,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                ],

              const Divider(),
              const SizedBox(height: 12),

              _fila('Donante', '${donacion.nombreDonante ?? '-'} ${donacion.apellidoDonante ?? ''}'.trim(), Icons.person_outline),
              _fila('Monto', '\$${donacion.donacion?.toStringAsFixed(2) ?? '0.00'}', Icons.attach_money, valueColor: const Color(0xFF00C853)),
              _fila('Método de pago', donacion.metodo ?? '-', Icons.credit_card_outlined),
              _fila('Fecha de donación', fecha, Icons.calendar_today_outlined),
              if (donacion.mensaje != null && donacion.mensaje!.isNotEmpty)
                _fila('Mensaje', donacion.mensaje!, Icons.message_outlined),
              _fila('Registrado el', donacion.createdAt != null
                  ? '${donacion.createdAt!.day}/${donacion.createdAt!.month}/${donacion.createdAt!.year}'
                  : '-', Icons.access_time_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fila(String label, String value, IconData icon, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF5C6BC0)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: valueColor ?? const Color(0xFF37474F))),
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