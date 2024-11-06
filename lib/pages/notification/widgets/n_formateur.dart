import 'package:flutter/material.dart';

class N_FormateurSection extends StatelessWidget {
  const N_FormateurSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre de la section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Actualités',
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
                : Color.fromARGB(255, 0, 70, 140); // Bleu
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
                // Spacer(),
                // Text(
                //   'semestre',
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.white, // Text color
                //   ),
                // ),
                // SizedBox(width: 8),
                // DropdownButton<int>(
                //   value: 1,
                //   items: [
                //     DropdownMenuItem(
                //       child: Text('1'),
                //       value: 1,
                //     ),
                //     DropdownMenuItem(
                //       child: Text('2'),
                //       value: 2,
                //     ),
                //   ],
                //   onChanged: (value) {},
                //   dropdownColor: Color.fromARGB(255, 0, 0, 0),
                //   style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                // ),
                // IconButton(
                //   icon: Icon(Icons.visibility, color: Colors.white),
                //   onPressed: () {},
                // ),
                // IconButton(
                //   icon: Icon(Icons.download, color: Colors.white),
                //   onPressed: () {},
                // ),
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
    'title': 'Nouvelle Formation Disponible',
    'content': 'Une nouvelle formation sur "L\'Intelligence Artificielle pour les Éducateurs" sera disponible à partir du 1er septembre 2024. Inscrivez-vous dès maintenant pour réserver votre place.',
    'time': '09:00',
  },
  {
    'title': 'Mise à jour des Ressources Pédagogiques',
    'content': 'Les ressources pédagogiques pour le module "Programmation Web Avancée" ont été mises à jour. Accédez aux nouveaux matériaux et supports sur notre plateforme.',
    'time': '11:30',
  },
  {
    'title': 'Atelier de Développement Professionnel',
    'content': 'Nous organiserons un atelier sur "Techniques d\'Enseignement Actives" le 15 septembre 2024. Ce sera une excellente opportunité pour améliorer vos compétences pédagogiques.',
    'time': '14:00',
  },
  {
    'title': 'Conférence sur les Méthodes Innovantes',
    'content': 'Une conférence sur les méthodes d\'enseignement innovantes aura lieu le 30 septembre 2024. Découvrez les dernières tendances et approches pédagogiques avec des experts du domaine.',
    'time': '16:30',
  },
];
