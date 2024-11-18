import 'package:crfpe_mobile/pages/absence/gestion_absence_etudiant.dart';
import 'package:crfpe_mobile/pages/absence/gestion_absence_formateur.dart';
import 'package:crfpe_mobile/pages/home/home.dart';
import 'package:crfpe_mobile/pages/login/login.dart';
import 'package:crfpe_mobile/pages/profil/gestion_profil_etudiant.dart';
import 'package:crfpe_mobile/pages/profil/gestion_profil_formateur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crfpe_mobile/pages/notification/notification.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

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

  Future<String> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    // Assuming the role is saved under the 'role' key
    return prefs.getString('role') ?? 'APPRENANT'; // Default to APPRENANT if no role is set
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
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo on the left
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: SvgPicture.asset(
                'assets/images/logo.svg', // Path to your SVG logo
                width: 40,
                height: 40,
              ),
            ),

            // Title in the center
            Expanded(
              child: Center(
                child: Text(
                  'CRFPE Solaris',
                  style: TextStyle(
                    color: Color(0xFF1869a6), // Text color modified for better contrast
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // Icons on the right
            Row(
              children: [
                Tooltip(
                  message: 'Notifications',
                  child: IconButton(
                    icon: Icon(Icons.notifications,
                        color: Color(0xFF1869a6)), // Icon color for contrast
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notificationpage()),
                      );
                    },
                  ),
                ),
                FutureBuilder<String>(
                  future: _getUserRole(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(); // Loading state
                    }

                    String userRole = snapshot.data!;

                    return PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'logout') {
                          _logout(context);
                        } else if (value == 'profile_formateur' &&
                            userRole == 'FORMATEUR') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GestionProfilFormateurpage()),
                          );
                        } else if (value == 'profile_etudiant' &&
                            userRole == 'APPRENANT') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GestionProfilEtudiantpage()),
                          );
                        } else if (value == 'absence_etudiant' &&
                            userRole == 'APPRENANT') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GestionAbsenceEtudiantpage()),
                          );
                        } else if (value == 'absence_formateur' &&
                            userRole == 'FORMATEUR') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GestionAbsenceFormateurpage()),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        // Show different options based on the role
                        List<PopupMenuItem<String>> menuItems = [
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: Text('Déconnexion'),
                          ),
                        ];

                        if (userRole == 'FORMATEUR') {
                          menuItems.insert(
                            0,
                            PopupMenuItem<String>(
                              value: 'profile_formateur',
                              child: Text('Profil Formateur'),
                            ),
                          );
                          menuItems.insert(
                            1,
                            PopupMenuItem<String>(
                              value: 'absence_formateur',
                              child: Text('Absence Formateur'),
                            ),
                          );
                        } else if (userRole == 'APPRENANT') {
                          menuItems.insert(
                            0,
                            PopupMenuItem<String>(
                              value: 'profile_etudiant',
                              child: Text('Profil Etudiant'),
                            ),
                          );
                          menuItems.insert(
                            1,
                            PopupMenuItem<String>(
                              value: 'absence_etudiant',
                              child: Text('Absence Etudiant'),
                            ),
                          );
                        }

                        return menuItems;
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/avatar.png'), // Path to your avatar image
                        radius: 20,
                      ),
                    );
                  },
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
// import 'package:crfpe_mobile/pages/profil/gestion_profil_etudiant.dart';
// import 'package:crfpe_mobile/pages/profil/gestion_profil_formateur.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:crfpe_mobile/pages/notification/notification.dart';

// class HeaderSection extends StatelessWidget {
//   const HeaderSection({super.key});

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
//                   'CRFPE Solaris',
//                   style: TextStyle(
//                     color: Color(0xFF1869a6), // Couleur du texte modifiée pour mieux contrasté
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ),
//             // Icônes à droite
//             Row(
//               children: [
//                 Tooltip(
//                   message: 'Notifications',
//                   child: IconButton(
//                     icon: Icon(Icons.notifications,
//                         color: Color(0xFF1869a6)), // Couleur de l'icône modifiée pour mieux contrasté
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Notificationpage()),
//                       );
//                     },
//                   ),
//                 ),
//                 PopupMenuButton<String>(
//                   onSelected: (value) {
//                     if (value == 'logout') {
//                       _logout(context);
//                     }else if (value == 'profile_formateur') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => GestionProfilFormateurpage()),
//                       );
//                     }else if (value == 'profile_etudiant') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => GestionProfilEtudiantpage()),
//                       );
//                     }
//                     else if (value == 'absence_etudiant') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => GestionAbsenceEtudiantpage()),
//                       );
//                     }else if (value == 'absence_formateur') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => GestionAbsenceFormateurpage()),
//                       );
//                     }
//                   },
//                   itemBuilder: (BuildContext context) {
//                     return [
//                         PopupMenuItem<String>(
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
//                       'assets/images/avatar.png'), // Chemin de votre photo de profil
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

