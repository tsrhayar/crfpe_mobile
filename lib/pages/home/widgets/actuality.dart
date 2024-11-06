import 'package:flutter/material.dart';

class ActualitySection extends StatelessWidget {
  const ActualitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre de la section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Actualité Solaris ..',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1869a6),
            ),
          ),
        ),
        // Liste des actualités
        ListView(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
        // Premier bloc d'actualité
_buildNewsCard(
  title: 'Réunion des Parents d\'Élèves',
  content: 'La prochaine réunion des parents d\'élèves se tiendra le vendredi 25 août à 18h00 dans la salle de conférence.',
  time: '12:30',
),
// Deuxième bloc d'actualité
_buildNewsCard(
  title: 'Excursion à la Ferme Pédagogique',
  content: 'Les élèves de la classe de CE1 visiteront la ferme pédagogique le mardi 12 septembre. N\'oubliez pas de signer l\'autorisation de sortie.',
  time: '14:45',
),
// Ajoutez d'autres blocs d'actualité ici
_buildNewsCard(
  title: 'Atelier de Théâtre',
  content: 'Un atelier de théâtre sera organisé pour les élèves de CM2 tous les mercredis à partir de 15h00 dans l\'amphithéâtre.',
  time: '15:00',
),
_buildNewsCard(
  title: 'Vente de Gâteaux',
  content: 'La vente de gâteaux organisée par l\'association des parents d\'élèves aura lieu le lundi 4 septembre dans la cour de l\'école.',
  time: '16:00',
),
_buildNewsCard(
  title: 'Journée Sportive',
  content: 'La journée sportive annuelle se déroulera le jeudi 21 septembre. Tous les élèves doivent porter des vêtements de sport.',
  time: '17:00',
),
_buildNewsCard(
  title: 'Club de Lecture',
  content: 'Le club de lecture reprend ses activités ce vendredi. Rendez-vous à la bibliothèque à 16h00 pour découvrir le livre du mois.',
  time: '18:00',
),
_buildNewsCard(
  title: 'Séance de Cinéma',
  content: 'Une séance de cinéma est organisée pour les élèves de la maternelle le mercredi 6 septembre à 10h00 dans la salle polyvalente.',
  time: '19:00',
),
_buildNewsCard(
  title: 'Collecte de Jouets',
  content: 'Une collecte de jouets pour les enfants défavorisés aura lieu du 1er au 15 octobre. Vous pouvez déposer vos dons à l\'entrée de l\'école.',
  time: '20:00',
),
_buildNewsCard(
  title: 'Concours de Dessin',
  content: 'Participez au concours de dessin sur le thème "Mon école idéale". Les œuvres doivent être remises avant le 10 septembre.',
  time: '21:00',
),
_buildNewsCard(
  title: 'Chorale de l\'École',
  content: 'La chorale de l\'école se produira lors de la fête de Noël. Les répétitions commencent le mardi 19 septembre à 17h00.',
  time: '22:00',
),
_buildNewsCard(
  title: 'Cours de Danse',
  content: 'Des cours de danse classique sont proposés aux élèves de CP tous les jeudis à 14h00 dans le gymnase.',
  time: '23:00',
),
_buildNewsCard(
  title: 'Conférence sur le Développement Durable',
  content: 'Une conférence sur le développement durable sera présentée par un expert le lundi 18 septembre à 10h00 dans l\'amphithéâtre.',
  time: '00:00',
),
_buildNewsCard(
  title: 'Sortie au Musée',
  content: 'Les élèves de CM1 visiteront le musée des sciences le vendredi 22 septembre. Préparez un pique-nique pour la sortie.',
  time: '01:00',
),
_buildNewsCard(
  title: 'Révision pour les Examens',
  content: 'Des sessions de révision pour les examens de fin d\'année sont organisées tous les samedis matin à partir de 9h00 en salle 101.',
  time: '02:00',
),
_buildNewsCard(
  title: 'Atelier de Peinture',
  content: 'Un atelier de peinture pour les élèves de CE2 aura lieu le jeudi 14 septembre à 15h00 dans la salle d\'art.',
  time: '03:00',
),
_buildNewsCard(
  title: 'Rencontre avec un Auteur',
  content: 'L\'auteur de littérature jeunesse, Mme Dupont, viendra rencontrer les élèves de CM2 le mercredi 27 septembre à 11h00.',
  time: '04:00',
),

          ],
        ),
      ],
    );
  }

  Widget _buildNewsCard(
      {String title = '', String content = '', String time = ''}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Color(0xFF1869a6), // Background color of the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
        ],
      ),
    );
  }
}
