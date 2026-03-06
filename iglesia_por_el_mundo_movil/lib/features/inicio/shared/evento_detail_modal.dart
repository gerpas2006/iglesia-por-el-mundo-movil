import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/eventos.dart';

void showEventoDetailModal(BuildContext context, EventoResponse evento) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EventoDetailModal(evento: evento),
  );
}

class EventoDetailModal extends StatelessWidget {
  final EventoResponse evento;

  const EventoDetailModal({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    // Formatear fecha
    String fechaFormateada = "Fecha no disponible";
    if (evento.fechaEvento != null) {
      final fecha = evento.fechaEvento!;
      final meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
      fechaFormateada = "${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}";
    }

    // Determinar estado
    String estadoTexto = "---";
    Color estadoColor = Colors.grey;
    if (evento.estado == true) {
      estadoTexto = "Disponible";
      estadoColor = Colors.green;
    } else if (evento.estado == false) {
      estadoTexto = "En curso";
      estadoColor = Colors.orange;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              // Barra superior
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tipo de evento
              if (evento.tipoEvento?.nombreEvento != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    evento.tipoEvento!.nombreEvento!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // Título del evento
              Text(
                evento.nombreEvento ?? "Sin título",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 20),

              // Estado
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: estadoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: estadoColor, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      evento.estado == true ? Icons.check_circle : Icons.info,
                      color: estadoColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Estado: $estadoTexto",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: estadoColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Fecha
              _buildDetailItem(
                icon: Icons.calendar_today,
                title: "Fecha",
                content: fechaFormateada,
              ),
              const SizedBox(height: 16),

              // Ubicación
              if (evento.ubicacion != null)
                _buildDetailItem(
                  icon: Icons.location_on,
                  title: "Ubicación",
                  content: evento.ubicacion!,
                ),
              const SizedBox(height: 24),

              // Descripción
              if (evento.descripcionEvento != null && evento.descripcionEvento!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Descripción",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      evento.descripcionEvento!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),

              // Botón de cerrar
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C6BC0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cerrar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF5C6BC0),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
