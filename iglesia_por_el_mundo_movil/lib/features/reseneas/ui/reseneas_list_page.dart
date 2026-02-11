import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/shared/boton_nueva_resenea.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/shared/tarjeta_contenido_resenea.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/shared/tarjetas_numero_reseneas_widget.dart';

class ReseneasListPage extends StatelessWidget {
  const ReseneasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reseñas de la Iglesia")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Botón
            BotonNuevaResenea(onPressed: () {
              // Acción al presionar
            }),
            const SizedBox(height: 16),

            // Tarjetas resumen
            Column(
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: TarjetasNumeroReseneasWidget(title: "Calificación Promedio", value: "4.8", color: Colors.orange),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TarjetasNumeroReseneasWidget(title: "Total de Reseñas", value: "4"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(
                      child: TarjetasNumeroReseneasWidget(title: "Mis Reseñas", value: "2", color: Colors.green),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TarjetasNumeroReseneasWidget(title: "Pendientes", value: "1", color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lista de reseñas
            Expanded(
              child: ListView(
                children: [
                  TarjetaContenidoResenea(
                    title: "Excelente comunidad",
                    description: "Me siento muy bendecido de formar parte de esta iglesia. La comunidad es cálida y acogedora.",
                    rating: 5,
                    status: "Aprobada",
                    date: DateTime(2025, 10, 1),
                  ),
                  TarjetaContenidoResenea(
                    title: "Gran enseñanza",
                    description: "La enseñanza es profunda y muy práctica.",
                    rating: 5,
                    status: "Pendiente",
                    date: DateTime(2025, 10, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
