import 'package:flutter/material.dart';

class F_EtudiantSection extends StatelessWidget {
  const F_EtudiantSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre de la section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Liste des Factures',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1869a6),
            ),
          ),
        ),
        // Liste des actualités
        ListView.builder(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: newsData.length,
          itemBuilder: (context, index) {
            final news = newsData[index];
            final color = index % 2 == 0
                ? Color.fromARGB(255, 94, 88, 88) // Gris
                : Color(0xFF1869a6); // Bleu
            return _buildNewsCard(
              title: news['title']!,
              content: news['content']!,
              time: news['time']!,
              color: color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String content,
    required String time,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: color, // Background color of the card
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Text color
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Heure: $time',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white, // Text color
                  ),
                ),
                Spacer(),
                Text(
                  'semestre',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white, // Text color
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<int>(
                  value: 1,
                  items: [
                    DropdownMenuItem(
                      child: Text('1'),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text('2'),
                      value: 2,
                    ),
                  ],
                  onChanged: (value) {},
                  dropdownColor: Color.fromARGB(255, 0, 0, 0),
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                IconButton(
                  icon: Icon(Icons.visibility, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.download, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const List<Map<String, String>> newsData = [
  {
    'title': 'Facture de scolarité',
    'content': 'Votre facture de scolarité pour le mois de juillet 2024 est disponible. Montant dû : 450€. Date limite de paiement : 25 août 2024.',
    'time': '12:30',
  },
  {
    'title': 'Frais de bibliothèque',
    'content': 'Des frais de retard pour la bibliothèque ont été ajoutés à votre compte. Montant dû : 15€. Date limite de paiement : 12 septembre 2024.',
    'time': '14:45',
  },
  {
    'title': 'Frais d\'excursion',
    'content': 'Les frais pour l\'excursion pédagogique de la classe de CE1 ont été facturés. Montant dû : 30€. Date limite de paiement : 10 octobre 2024.',
    'time': '15:00',
  },
  {
    'title': 'Atelier de théâtre',
    'content': 'Les frais d\'inscription pour l\'atelier de théâtre de CM2 sont maintenant disponibles. Montant dû : 50€. Date limite de paiement : 20 septembre 2024.',
    'time': '16:00',
  },
];
