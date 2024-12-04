import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ActualitySection extends StatefulWidget {
  const ActualitySection({super.key});

  @override
  _ActualitySectionState createState() => _ActualitySectionState();
}

class _ActualitySectionState extends State<ActualitySection> {
  bool _isLoading = true; // État de chargement initial
  List<dynamic> _newsList = []; // Stockage des actualités récupérées
  String _errorMessage = ''; // Message d'erreur

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Récupération des actualités au démarrage
  }

  // Fonction pour récupérer les actualités depuis l'API
  Future<void> _fetchNews() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      // Récupération de l'user_id depuis les préférences
      String? userId = prefs.getString('user_id');
      if (userId != null) {
        final response = await http.get(
          // Uri.parse('https://preprod.solaris-crfpe.fr/api/news/indexJson')
          Uri.parse('https://solaris-crfpe.fr/api/news/indexJson')
              .replace(queryParameters: {'user_id': userId}),
        );

        if (response.statusCode == 200) {
          setState(() {
            _newsList = List<dynamic>.from(json.decode(response.body));
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage =
                'Échec du chargement des actualités. Veuillez réessayer plus tard.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Merci de vous réauthentifier.';
          _isLoading = false;
        });
      }
    } catch (e) {
      // prefs.remove('token');
      setState(() {
        _errorMessage = 'Erreur : $e';
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
            'Actualité Solaris',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1869a6),
            ),
          ),
        ),
        // Affichage du chargement ou des messages d'erreur
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(), // Indicateur de chargement
          )
        else if (_errorMessage.isNotEmpty)
          Center(
            child: Text(
              _errorMessage, // Affichage du message d'erreur
              style: const TextStyle(color: Colors.red),
            ),
          )
        else if (_newsList.isEmpty)
          const Center(
            child: Text(
              'Aucune actualité disponible pour le moment.', // Message si la liste est vide
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          )
        else
          // Affichage de la liste des actualités
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _newsList.length,
            itemBuilder: (context, index) {
              var newsItem = _newsList[index];
              return NewsCard(
                title: newsItem['title'] ?? 'Pas de titre',
                content: newsItem['text'] ?? 'Pas de contenu',
                time: newsItem['time'] ?? '',
              );
            },
          ),
      ],
    );
  }
}

class NewsCard extends StatefulWidget {
  final String title;
  final String content;
  final String time;

  const NewsCard({
    Key? key,
    this.title = '',
    this.content = '',
    this.time = '',
  }) : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isExpanded = false; // État pour afficher/masquer le contenu
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: const Color(0xFF1869a6), // Couleur de fond de la carte
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et heure sur la même ligne
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Couleur du texte
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Contenu avec bouton pour afficher/masquer
            Text(
              isExpanded
                  ? widget.content
                  : widget.content.split('').take(35).join('') + '...',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            // Aligner le texte à droite
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded; // Basculer l'état
                    });
                  },
                  child: Text(
                    isExpanded ? 'Afficher moins' : 'Afficher la suite',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16.0),
//       color: const Color(0xFF1869a6), // Couleur de fond de la carte
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Titre et heure sur la même ligne
//             Row(
//               children: [
//                 Expanded(
//                   flex: 7,
//                   child: Text(
//                     widget.title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white, // Couleur du texte
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 3,
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       widget.time,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Contenu avec bouton pour afficher/masquer
//             Text(
//               isExpanded
//                   ? widget.content
//                   : widget.content.split('').take(70).join('') + '...',
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 5),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isExpanded = !isExpanded; // Basculer l'état
//                 });
//               },
//               child: Text(
//                 isExpanded ? 'Afficher moins' : 'Afficher la suite',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ActualitySection extends StatefulWidget {
//   const ActualitySection({super.key});

//   @override
//   _ActualitySectionState createState() => _ActualitySectionState();
// }

// class _ActualitySectionState extends State<ActualitySection> {
//   bool _isLoading = true; // Initial loading state
//   List<dynamic> _newsList = []; // To store the fetched news data
//   String _errorMessage = ''; // To store error messages

//   @override
//   void initState() {
//     super.initState();
//     _fetchNews(); // Call the fetch function when the widget is initialized
//   }

//   // Fetch news data from the API
//   Future<void> _fetchNews() async {
//     try {
//       // Get the user_id from shared preferences
//       final prefs = await SharedPreferences.getInstance();
//       String? userId = prefs.getString('user_id'); // Retrieve the user_id
//       print('userId: $userId');
//       if (userId != null) {
//         // Include user_id as a query parameter
//         final response = await http.get(
//           Uri.parse('https://preprod.solaris-crfpe.fr/api/news/indexJson')
//               .replace(
//             queryParameters: {
//               'user_id': userId
//             }, // Add user_id as query parameter
//           ),
//         );

//         if (response.statusCode == 200) {
//           setState(() {
//             _newsList = List<dynamic>.from(
//                 json.decode(response.body)); // Decode and store the news data
//             _isLoading = false; // Set loading to false after data is fetched
//           });
//         } else {
//           setState(() {
//             _errorMessage = 'Failed to load news data. Please try again later.';
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'Merci de vous réauthentifier à nouveau.';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: $e'; // Catch and display error
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Titre de la section
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'Actualité Solaris',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1869a6),
//             ),
//           ),
//         ),
//         // Display loading indicator or error message
//         if (_isLoading)
//           Center(
//             child: CircularProgressIndicator(), // Spinner de chargement
//           )
//         else if (_errorMessage.isNotEmpty)
//           Center(
//             child: Text(
//               _errorMessage, // Display error message
//               style: TextStyle(color: Colors.red),
//             ),
//           )
//         else if (_newsList.isEmpty)
//           Center(
//             child: Text(
//               'Aucune actualité disponible pour le moment.', // Empty list message
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//           )
//         else
//           // Display the news list
//           ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: _newsList.length,
//             itemBuilder: (context, index) {
//               var newsItem = _newsList[index];
//               return _buildNewsCard(
//                 title: newsItem['title'] ?? 'No title',
//                 content: newsItem['text'] ?? 'No content',
//                 time: newsItem['time'] ?? '',
//               );
//             },
//           ),
//       ],
//     );
//   }

//   Widget _buildNewsCard(
//       {String title = '', String content = '', String time = ''}) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16.0),
//       color: const Color(0xFF1869a6), // Background color of the card
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title and time on the same line
//             Row(
//               children: [
//                 // Title with 70% width
//                 Expanded(
//                   flex: 7,
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white, // Text color
//                     ),
//                     // overflow: TextOverflow.ellipsis, // Handle long titles
//                   ),
//                 ),
//                 // Time with 30% width
//                 Expanded(
//                   flex: 3,
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       time,
//                       style: const TextStyle(
//                         fontSize: 12, // Smaller font size
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Content of the news
//             Text(
//               content,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.white, // Text color
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
