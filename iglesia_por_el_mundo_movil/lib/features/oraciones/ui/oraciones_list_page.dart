import 'package:flutter/material.dart';

class OracionesListPage extends StatelessWidget {
  const OracionesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Oraciones Diarias',
          style: TextStyle(
            color: Color(0xFF2D3243),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Encuentra inspiración y guía en estas oraciones",
            style: TextStyle(fontSize: 15, color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),

          // Contador de oraciones
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.church, color: Colors.white, size: 32),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total de Oraciones',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Lista de oraciones
          _OracionCard(
            category: "Familia",
            title: "Oración por la Familia",
            date: "6 de octubre de 2025",
            body: "Padre Celestial, te pedimos por nuestras familias. Que tu amor y paz reinen en nuestros hogares. Protege a cada miembro, guía a los padres con sabiduría y llena a los hijos de tu gracia. Que seamos testimonios...",
            verse: "Josué 24:15 - 'Yo y mi casa serviremos al Señor'",
            categoryColor: Colors.blue,
          ),
          const SizedBox(height: 16),
          _OracionCard(
            category: "Salud",
            title: "Oración por Sanidad",
            date: "5 de octubre de 2025",
            body: "Señor, ponemos en tus manos la salud de aquellos que sufren. Trae consuelo a sus corazones y restaura sus fuerzas según tu voluntad...",
            verse: "Salmos 103:3 - 'Él es quien perdona todas tus iniquidades, El que sana todas tus dolencias'",
            categoryColor: Colors.green,
          ),
          const SizedBox(height: 16),
          _OracionCard(
            category: "Protección",
            title: "Oración por Protección",
            date: "4 de octubre de 2025",
            body: "Señor, cubre a tus hijos con tu manto de protección. Guárdalos de todo mal y peligro. Que tu presencia los acompañe en cada paso que den...",
            verse: "Salmos 91:11 - 'Pues a sus ángeles mandará acerca de ti, que te guarden en todos tus caminos'",
            categoryColor: Colors.orange,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _OracionCard extends StatelessWidget {
  final String category;
  final String title;
  final String date;
  final String body;
  final String verse;
  final Color categoryColor;

  const _OracionCard({
    required this.category,
    required this.title,
    required this.date,
    required this.body,
    required this.verse,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3243),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    verse,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6366F1),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}