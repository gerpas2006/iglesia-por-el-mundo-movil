import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/citas.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/citas_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/bloc/citas_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/ui/formulario_editar_cita_page.dart';

class SolicitudCitaCard extends StatelessWidget {
  final String nombreCita;
  final String estado;
  final String fechaCita;
  final String horaCita;
  final String fechaSolicitud;
  final CitaResponse cita;

  const SolicitudCitaCard({
    super.key,
    required this.nombreCita,
    required this.estado,
    required this.fechaCita,
    required this.horaCita,
    required this.fechaSolicitud,
    required this.cita,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos colores según el estado
    final isAprobada = _isCitaAprobada(estado);
    final isRechazada = _isCitaRechazada(estado);
    final colorEstado = isRechazada
        ? const Color(0xFFE53935)
        : (isAprobada ? const Color(0xFF00C853) : const Color(0xFFFF9800));
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
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() => TextStyle(fontSize: 11, color: Colors.grey[500]);
  TextStyle _valueStyle() => const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF37474F));

  void _mostrarDetalles(BuildContext context) {
    final isAprobada = _isCitaAprobada(estado);
    final isRechazada = _isCitaRechazada(estado);
    final isNoEditable = isAprobada || isRechazada;
    final colorEstado = isRechazada
      ? const Color(0xFFE53935)
      : (isAprobada ? const Color(0xFF00C853) : const Color(0xFFFF9800));

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
                  const Icon(Icons.calendar_today, color: Color(0xFFAB47BC), size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      cita.tipoCita?.nombreCita ?? 'Cita',
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
              if (cita.tipoCita?.descripcionCita != null) ...[  
                Text(
                  cita.tipoCita!.descripcionCita!,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
              ],

              const Divider(),
              const SizedBox(height: 12),

              _fila('Estado', estado, Icons.info_outline, valueColor: colorEstado),
              _fila('Solicitante', cita.nombreCompleto.isNotEmpty ? cita.nombreCompleto : '-', Icons.person_outline),
              _fila('Fecha y hora de cita', '$fechaCita  $horaCita', Icons.calendar_today_outlined),
              _fila('Fecha de solicitud', fechaSolicitud, Icons.access_time_outlined),
              if (cita.contacto != null && cita.contacto!.isNotEmpty)
                _fila('Contacto', cita.contacto!, Icons.phone_outlined),
              if (cita.mensaje != null && cita.mensaje!.isNotEmpty)
                _fila('Mensaje', cita.mensaje!, Icons.message_outlined),
              
              const SizedBox(height: 24),
              
              // Botones de Cerrar y Editar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Cerrar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5C6BC0),
                        side: const BorderSide(color: Color(0xFF5C6BC0)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                        onPressed: isNoEditable
                          ? null
                          : () {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) => CitasBloc(CitasService()),
                                    child: FormularioEditarCitaPage(cita: cita),
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.edit),
                      label: Text(isNoEditable ? 'No editable' : 'Editar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C6BC0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              if (isNoEditable) ...[
                const SizedBox(height: 10),
                Text(
                  isRechazada
                      ? 'Las citas rechazadas no se pueden editar.'
                      : 'Las citas aprobadas no se pueden editar.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _isCitaAprobada(String estado) {
    final estadoNormalizado = estado.toLowerCase().trim();
    return estadoNormalizado == 'aprobada' || estadoNormalizado == 'aceptada';
  }

  bool _isCitaRechazada(String estado) {
    final estadoNormalizado = estado.toLowerCase().trim();
    return estadoNormalizado == 'rechazada';
  }

  Widget _fila(String label, String value, IconData icon, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFFAB47BC)),
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
}