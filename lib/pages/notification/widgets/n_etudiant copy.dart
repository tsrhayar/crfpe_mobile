import 'package:flutter/material.dart';

class N_EtudiantSection extends StatelessWidget {
  const N_EtudiantSection({super.key});

  get notification from herehttps:
  //preprod.solaris-crfpe.fr/api/getNotifications
  authToken = prefs.getString('token');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre de la section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Notifications',
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
    'title': 'Nouveau devoir en ligne',
    'content': 'Un nouveau devoir de mathématiques a été publié sur la plateforme d\'apprentissage. Date limite de soumission : 5 août 2024.',
    'time': '09:00',
  },
  {
    'title': 'Changement d\'horaire de cours',
    'content': 'Le cours de français du mardi est désormais prévu de 10h00 à 11h30. Veuillez vérifier votre emploi du temps mis à jour.',
    'time': '11:15',
  },
  {
    'title': 'Réunion des parents',
    'content': 'Une réunion des parents est prévue le 15 août 2024 à 18h00. Veuillez confirmer votre présence auprès du secrétariat.',
    'time': '13:30',
  },
  {
    'title': 'Résultats des examens',
    'content': 'Les résultats des examens de fin d\'année sont disponibles. Vous pouvez consulter vos résultats en ligne dès maintenant.',
    'time': '17:45',
  },
];

