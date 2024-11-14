import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActualitySection extends StatefulWidget {
  const ActualitySection({super.key});

  @override
  _ActualitySectionState createState() => _ActualitySectionState();
}

class _ActualitySectionState extends State<ActualitySection> {
  bool _isLoading = true; // Initial loading state
  List<dynamic> _newsList = []; // To store the fetched news data
  String _errorMessage = ''; // To store error messages

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Call the fetch function when the widget is initialized
  }

  // Fetch news data from the API
  Future<void> _fetchNews() async {
    try {
      final response = await http.get(
          Uri.parse('https://preprod.solaris-crfpe.fr/api/news/indexJson'));

      if (response.statusCode == 200) {
        setState(() {
          _newsList = json.decode(response.body); // Decode the JSON response
          _isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load news data. Please try again later.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre de la section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Actualité Solaris ...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1869a6),
            ),
          ),
        ),
        // Display loading indicator or error message
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(), // Spinner de chargement
          )
        else if (_errorMessage.isNotEmpty)
          Center(
            child: Text(
              _errorMessage, // Display error message
              style: TextStyle(color: Colors.red),
            ),
          )
        else
          // Display the news list
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _newsList.length,
            itemBuilder: (context, index) {
              var newsItem = _newsList[index];
              return _buildNewsCard(
                title: newsItem['title'] ?? 'No title',
                content: newsItem['text'] ?? 'No content',
                time: newsItem['time'] ?? '',
              );
            },
          ),
      ],
    );
  }

  // Widget to build individual news cards
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
                // Display the time aligned to the right and in a smaller font
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '$time',
                    style: TextStyle(
                      fontSize: 12, // Make the time smaller
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Title of the news
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
                SizedBox(height: 8),
                // Content of the news
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
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

// import 'package:flutter/material.dart';

// class ActualitySection extends StatefulWidget {
//   const ActualitySection({super.key});

//   @override
//   _ActualitySectionState createState() => _ActualitySectionState();
// }

// class _ActualitySectionState extends State<ActualitySection> {
//   bool _isLoading = true; // Define the loading state

//   @override
//   void initState() {
//     super.initState();

//     // Simulate data loading
//     Future.delayed(Duration(seconds: 3), () {
//       setState(() {
//         _isLoading = false; // Set loading to false after 3 seconds
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Titre de la section
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'Actualité Solaris ...',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1869a6),
//             ),
//           ),
//         ),
//         // Liste des actualités
//         if (_isLoading)
//           Center(
//             child: CircularProgressIndicator(), // Spinner de chargement
//           )
//         else
//           ListView(
//             padding: const EdgeInsets.all(16.0),
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             children: [
//               // Premier bloc d'actualité
//               _buildNewsCard(
//                 title: 'Réunion des Parents d\'Élèves',
//                 content:
//                     'La prochaine réunion des parents d\'élèves se tiendra le vendredi 25 août à 18h00 dans la salle de conférence.',
//                 time: '12:30',
//               ),
//               // Deuxième bloc d'actualité
//               _buildNewsCard(
//                 title: 'Excursion à la Ferme Pédagogique',
//                 content:
//                     'Les élèves de la classe de CE1 visiteront la ferme pédagogique le mardi 12 septembre. N\'oubliez pas de signer l\'autorisation de sortie.',
//                 time: '14:45',
//               ),
//               // Ajoutez d'autres blocs d'actualité ici
//               _buildNewsCard(
//                 title: 'Atelier de Théâtre',
//                 content:
//                     'Un atelier de théâtre sera organisé pour les élèves de CM2 tous les mercredis à partir de 15h00 dans l\'amphithéâtre.',
//                 time: '15:00',
//               ),
//               _buildNewsCard(
//                 title: 'Vente de Gâteaux',
//                 content:
//                     'La vente de gâteaux organisée par l\'association des parents d\'élèves aura lieu le lundi 4 septembre dans la cour de l\'école.',
//                 time: '16:00',
//               ),
//               _buildNewsCard(
//                 title: 'Journée Sportive',
//                 content:
//                     'La journée sportive annuelle se déroulera le jeudi 21 septembre. Tous les élèves doivent porter des vêtements de sport.',
//                 time: '17:00',
//               ),
//               _buildNewsCard(
//                 title: 'Club de Lecture',
//                 content:
//                     'Le club de lecture reprend ses activités ce vendredi. Rendez-vous à la bibliothèque à 16h00 pour découvrir le livre du mois.',
//                 time: '18:00',
//               ),
//             ],
//           ),
//       ],
//     );
//   }

//   // Example function to build news cards
//   Widget _buildNewsCard({String title = '', String content = '', String time = ''}) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16.0),
//       color: Color(0xFF1869a6), // Background color of the card
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white, // Text color
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   content,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white, // Text color
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Heure: $time',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white, // Text color
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
