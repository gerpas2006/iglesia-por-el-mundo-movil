import 'package:flutter/material.dart';

class TarjetaNumeroOraciones extends StatelessWidget {
  final int totalOraciones;

  const TarjetaNumeroOraciones({super.key, required this.totalOraciones});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3000,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Oraciones Disponibles',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalOraciones',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}