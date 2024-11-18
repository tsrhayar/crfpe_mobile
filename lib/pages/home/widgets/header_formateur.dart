import 'package:crfpe_mobile/pages/absence/gestion_absence_etudiant.dart';
import 'package:crfpe_mobile/pages/absence/gestion_absence_formateur.dart';
import 'package:crfpe_mobile/pages/home/home.dart';
import 'package:crfpe_mobile/pages/login/login.dart';
import 'package:crfpe_mobile/pages/notification/notification.dart';
import 'package:crfpe_mobile/pages/profil/gestion_profil_etudiant.dart';
import 'package:crfpe_mobile/pages/profil/gestion_profil_formateur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderFormateurSection extends StatefulWidget {
  const HeaderFormateurSection({super.key});

  @override
  _HeaderFormateurSectionState createState() => _HeaderFormateurSectionState();
}

class _HeaderFormateurSectionState extends State<HeaderFormateurSection> {
  String role = '';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  // Load the role from SharedPreferences
  void _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role') ?? ''; // Default to empty if not set
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
     await prefs.remove('user_id');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xfff6f8ff),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(7),
            top: Radius.circular(7),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo à gauche
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: SvgPicture.asset(
                'assets/images/logo.svg', // Chemin de votre logo SVG
                width: 40,
                height: 40,
              ),
            ),

            // Titre au centre
            Expanded(
              child: Center(
                child: Text(
                  role == 'FORMATEUR' ? 'CRFPE Formateur' : 'CRFPE Etudiant',
                  style: TextStyle(
                    color: Color(0xFF1869a6),
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // Icônes à droite
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Color.fromARGB(255, 24, 166, 107),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Notificationpage()),
                    );
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      _logout(context);
                    } else if (value == 'profile_formateur') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GestionProfilFormateurpage()),
                      );
                    } else if (value == 'profile_etudiant') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GestionProfilEtudiantpage()),
                      );
                    } else if (value == 'absence_etudiant') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GestionAbsenceEtudiantpage()),
                      );
                    } else if (value == 'absence_formateur') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GestionAbsenceFormateurpage()),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    // Common items
                    List<PopupMenuEntry<String>> menuItems = [
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Déconnexion'),
                      ),
                    ];

                    // Role-based items
                    if (role == 'FORMATEUR') {
                      menuItems.insert(
                          0,
                          PopupMenuItem<String>(
                            value: 'profile_formateur',
                            child: Text('Profil Formateur'),
                          ));
                      menuItems.insert(
                          1,
                          PopupMenuItem<String>(
                            value: 'absence_formateur',
                            child: Text('Absence Formateur'),
                          ));
                    } else if (role == 'APPRENANT') {
                      menuItems.insert(
                          0,
                          PopupMenuItem<String>(
                            value: 'profile_etudiant',
                            child: Text('Profil Etudiant'),
                          ));
                      menuItems.insert(
                          1,
                          PopupMenuItem<String>(
                            value: 'absence_etudiant',
                            child: Text('Absence Etudiant'),
                          ));
                    }

                    return menuItems;
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/avatar.png'), // Chemin de votre photo de profil
                    radius: 20,
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


// import 'package:crfpe_mobile/pages/absence/gestion_absence_etudiant.dart';
// import 'package:crfpe_mobile/pages/absence/gestion_absence_formateur.dart';
// import 'package:crfpe_mobile/pages/home/home.dart';
// import 'package:crfpe_mobile/pages/login/login.dart';
// import 'package:crfpe_mobile/pages/notification/notification.dart';
// import 'package:crfpe_mobile/pages/profil/gestion_profil_etudiant.dart';
// import 'package:crfpe_mobile/pages/profil/gestion_profil_formateur.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HeaderFormateurSection extends StatelessWidget {
//   const HeaderFormateurSection({super.key});

//   Future<void> _logout(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//       (Route<dynamic> route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Color(0xfff6f8ff),
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(7),
//             top: Radius.circular(7),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Logo à gauche
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()),
//                 );
//               },
//               child: SvgPicture.asset(
//                 'assets/images/logo.svg', // Chemin de votre logo SVG
//                 width: 40,
//                 height: 40,
//               ),
//             ),

//             // Titre au centre
//             Expanded(
//               child: Center(
//                 child: Text(
//                   'CRFPE Formateur',
//                   style: TextStyle(
//                     color: Color(
//                         0xFF1869a6), // Couleur du texte modifiée pour mieux contrasté
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ),
//             // Icônes à droite
//             Row(
//               children: [
//                 IconButton(
//                     icon: Icon(Icons.notifications,
//                         color: Color.fromARGB(255, 24, 166,
//                             107)), // Couleur de l'icône modifiée pour mieux contrasté
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Notificationpage()),
//                       );
//                     }),
//                 PopupMenuButton<String>(
//                   onSelected: (value) {
//                     if (value == 'logout') {
//                       _logout(context);
//                     } else if (value == 'profile_formateur') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => GestionProfilFormateurpage()),
//                       );
//                     } else if (value == 'profile_etudiant') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => GestionProfilEtudiantpage()),
//                       );
//                     } else if (value == 'absence_etudiant') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => GestionAbsenceEtudiantpage()),
//                       );
//                     } else if (value == 'absence_formateur') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 GestionAbsenceFormateurpage()),
//                       );
//                     }
//                   },
//                   itemBuilder: (BuildContext context) {
//                     return [
//                        PopupMenuItem<String>(
//                         value: 'profile_formateur',
//                         child: Text('Profil Formateur'),
//                       ),
//                        PopupMenuItem<String>(
//                         value: 'profile_etudiant',
//                         child: Text('Profil Etudiant'),
//                       ), PopupMenuItem<String>(
//                         value: 'absence_formateur',
//                         child: Text('Absence Formateur'),
//                       ), PopupMenuItem<String>(
//                         value: 'absence_etudiant',
//                         child: Text('Absence Etudiant'),
//                       ),
//                       PopupMenuItem<String>(
//                         value: 'logout',
//                         child: Text('Déconnexion'),
//                       ),
//                     ];
//                   },
//                   child: CircleAvatar(
//                     backgroundImage: AssetImage(
//                         'assets/images/avatar.png'), // Chemin de votre photo de profil
//                     radius: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
