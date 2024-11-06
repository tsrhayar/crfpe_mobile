import 'package:flutter/material.dart';

class DocumentSection extends StatelessWidget {
  const DocumentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Première section "Mes Actions de Formation"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mes Actions de Formation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1869a6),
                  ),
                ),
                SizedBox(height: 16.0),
                _buildNewsCard(
                  title: 'Monday, 15th                           View details',
                  content: 'La prochaine réunion des parents d\'élèves se tiendra le vendredi 25 août à 18h00 dans la salle de conférence.',
                  time: '12:30',
                  index: 0,
                ),
              
              ],
            ),
          ),
          // Deuxième section "Mes Actions de Formation"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mes Evaluations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1869a6),
                  ),
                ),
                SizedBox(height: 16.0),
                _buildNewsCard(
                  title: 'Seminar, August 5th              Mark as completed',
                  content: 'Un séminaire sur les nouvelles technologies se tiendra le samedi 5 août à 9h00 dans l\'amphithéâtre.',
                  time: '09:00',
                  index: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String content,
    required String time,
    required int index,
  }) {
    Color cardColor = index % 2 == 0 ? Color(0xFF1869a6) :Color.fromARGB(255, 94, 88, 88); // Alternating colors

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: cardColor, // Background color of the card
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
            Text(
              'Heure: $time',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
