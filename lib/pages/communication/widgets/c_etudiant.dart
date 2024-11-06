import 'package:crfpe_mobile/pages/communication/widgets/c_sms_etudiant.dart';
import 'package:flutter/material.dart';

class C_EtudiantSection extends StatelessWidget {
  const C_EtudiantSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre de la section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Communication',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1869a6),
            ),
          ),
        ),
        // Liste des messages
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: messagesData.length,
          itemBuilder: (context, index) {
            final message = messagesData[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => C_Sms_EtudiantSection(
                      sender: message['sender']!,
                      isAdministrator: message['type'] == 'administrator',
                    ),
                  ),
                );
              },
              child: _buildMessageCard(
                sender: message['sender']!,
                content: message['content']!,
                time: message['time']!,
                isHighlighted: index == 0,
                isAdministrator: message['type'] == 'administrator',
              ),
            );
          },
        ),
        // Numéro d'urgence
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'En cas d\'urgence, veuillez contacter le numéro suivant: 123-456-7890',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard({
    required String sender,
    required String content,
    required String time,
    required bool isHighlighted,
    required bool isAdministrator,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: isHighlighted ? Color(0xFF1869a6) : Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: AssetImage('assets/images/avatar.png'),
        ),
        title: Text(
          sender,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isHighlighted ? Colors.white : isAdministrator ? Color(0xFF1869a6) : Colors.black,
          ),
        ),
        subtitle: Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: isHighlighted ? Colors.white : Colors.black,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 14,
            color: isHighlighted ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

const List<Map<String, String>> messagesData = [
  {
    'sender': 'Administrateur 1',
    'content': 'Bonjour, veuillez soumettre vos projets avant la date limite.',
    'time': '09:00',
    'type': 'administrator',
  },
  {
    'sender': 'Formateur 1',
    'content': 'Salut, n\'oubliez pas notre réunion de demain.',
    'time': '11:30',
    'type': 'formateur',
  },
  {
    'sender': 'Administrateur 2',
    'content': 'Les résultats des examens sont publiés.',
    'time': '14:00',
    'type': 'administrator',
  },
  {
    'sender': 'Formateur 2',
    'content': 'Merci de me faire savoir si vous avez des questions.',
    'time': '16:30',
    'type': 'formateur',
  },
];
