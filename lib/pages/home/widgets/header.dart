import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:crfpe_mobile/pages/absence/gestion_absence_etudiant.dart';
import 'package:crfpe_mobile/pages/absence/gestion_absence_formateur.dart';
import 'package:crfpe_mobile/pages/home/home.dart';
import 'package:crfpe_mobile/pages/login/login.dart';
import 'package:crfpe_mobile/pages/profil/gestion_profil_etudiant.dart';
import 'package:crfpe_mobile/pages/profil/gestion_profil_formateur.dart';
import 'package:crfpe_mobile/pages/notification/notification.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<String> _getUserFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_fullname') ?? 'Nom Inconnu';
  }

  Future<String> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role') ?? 'APPRENANT';
  }

  Future<int> _getNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token') ?? '';
    // final url = 'https://preprod.solaris-crfpe.fr/api/getNotifications';
    final url = 'https://solaris-crfpe.fr/api/getNotifications';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        // Assuming the response body contains a JSON with a notifications list
        final data = jsonDecode(response.body);
        final notifications = data['data'] as List<dynamic>;

        // Filter notifications where 'read_at' is null
        final unreadNotifications = notifications.where((notification) {
          return notification['read_at'] == null;
        }).toList();

        return unreadNotifications
            .length; // Return the count of unread notifications
      } else {
        debugPrint(
            'Failed to fetch notifications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // prefs.remove('token');
      // MaterialPageRoute(builder: (context) => HomePage());
      debugPrint('Error fetching notifications: $e');
    }
    return 0; // Default to 0 if there's an error or no notifications
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff6f8ff),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(7),
            top: Radius.circular(7),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 40,
                height: 40,
              ),
            ),

            // Title
            const Expanded(
              child: Center(
                child: Text(
                  'CRFPE Solaris',
                  style: TextStyle(
                    color: Color(0xFF1869a6),
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            // Icons
            Row(
              children: [
                // Notifications Icon
                FutureBuilder<int>(
                  future: _getNotificationCount(),
                  builder: (context, snapshot) {
                    int notificationCount = snapshot.data ?? 0;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Color(0xFF1869a6),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Notificationpage()),
                            );
                          },
                        ),
                        if (notificationCount > 0)
                          Positioned(
                            right: 4,
                            top: 2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                '$notificationCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // User Profile Menu
                FutureBuilder<List<String>>(
                  future: Future.wait([_getUserRole(), _getUserFullName()]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    String userRole = snapshot.data![0];
                    String userFullName = snapshot.data![1];

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
                        List<PopupMenuItem<String>> menuItems = [
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: const Text('Déconnexion'),
                          ),
                        ];
                        menuItems.insert(
                          0,
                          PopupMenuItem<String>(
                            value: 'role_item',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userFullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  userRole,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        return menuItems;
                      },
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatar.png'),
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
//     await prefs.remove('role');
//     await prefs.remove('user_id');
//     await prefs.remove('user_fullname');

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//       (Route<dynamic> route) => false,
//     );
//   }

//   Future<String> _getUserFullName() async {
//     final prefs = await SharedPreferences.getInstance();
//     // Assuming the full name is saved under the 'user_fullname' key
//     return prefs.getString('user_fullname') ??
//         'Nom Inconnu'; // Default if no full name is set
//   }

//   Future<String> _getUserRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     // Assuming the role is saved under the 'role' key
//     return prefs.getString('role') ??
//         'APPRENANT'; // Default to APPRENANT if no role is set
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
//               offset: Offset(0, 3), // Shadow position
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Logo on the left
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()),
//                 );
//               },
//               child: SvgPicture.asset(
//                 'assets/images/logo.svg', // Path to your SVG logo
//                 width: 40,
//                 height: 40,
//               ),
//             ),

//             // Title in the center
//             Expanded(
//               child: Center(
//                 child: Text(
//                   'CRFPE Solaris',
//                   style: TextStyle(
//                     color: Color(
//                         0xFF1869a6), // Text color modified for better contrast
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ),
//             // Icons on the right
//             Row(
//               children: [
//                 Padding(
//                  padding: EdgeInsets.only(right: 10.0), // Add 5px margin for Tooltip
//                   child: Tooltip(
//                     message: 'Notifications',
//                     child: Stack(
//                       clipBehavior: Clip
//                           .none, // To allow the badge to overflow if necessary
//                       children: [
//                         IconButton(
//                           icon: Icon(
//                             Icons.notifications,
//                             color: Color(0xFF1869a6), // Icon color for contrast
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Notificationpage()),
//                             );
//                           },
//                         ),
//                         Positioned(
//                           right: 4,
//                           top: 2,
//                           child: Container(
//                             padding: EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                             constraints: BoxConstraints(
//                               minWidth: 20,
//                               minHeight: 20,
//                             ),
//                             child: Text(
//                               '2', 
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 FutureBuilder<List<String>>(
//                   future: Future.wait([_getUserRole(), _getUserFullName()]),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return CircularProgressIndicator(); // Loading state
//                     }

//                     // Once both futures have completed, you can access the results
//                     String userRole = snapshot.data![0];
//                     String userFullName = snapshot.data![1];

//                     return PopupMenuButton<String>(
//                       onSelected: (value) {
//                         if (value == 'logout') {
//                           _logout(context);
//                         } else if (value == 'profile_formateur' &&
//                             userRole == 'FORMATEUR') {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     GestionProfilFormateurpage()),
//                           );
//                         } else if (value == 'profile_etudiant' &&
//                             userRole == 'APPRENANT') {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     GestionProfilEtudiantpage()),
//                           );
//                         } else if (value == 'absence_etudiant' &&
//                             userRole == 'APPRENANT') {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     GestionAbsenceEtudiantpage()),
//                           );
//                         } else if (value == 'absence_formateur' &&
//                             userRole == 'FORMATEUR') {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     GestionAbsenceFormateurpage()),
//                           );
//                         }
//                       },
//                       itemBuilder: (BuildContext context) {
//                         // Show different options based on the role
//                         List<PopupMenuItem<String>> menuItems = [
//                           PopupMenuItem<String>(
//                             value: 'logout',
//                             child: Text('Déconnexion'),
//                           ),
//                         ];

//                         // Add role-based menu item if the role is 'FORMATEUR' or 'APPRENANT'
//                         if (userRole == 'FORMATEUR' && false) {
//                           menuItems.insert(
//                             0,
//                             PopupMenuItem<String>(
//                               value: 'profile_formateur',
//                               child: Text('Profil Formateur'),
//                             ),
//                           );
//                           menuItems.insert(
//                             1,
//                             PopupMenuItem<String>(
//                               value: 'absence_formateur',
//                               child: Text('Absence Formateur'),
//                             ),
//                           );
//                         } else if (userRole == 'APPRENANT' && false) {
//                           menuItems.insert(
//                             0,
//                             PopupMenuItem<String>(
//                               value: 'profile_etudiant',
//                               child: Text('Profil Etudiant'),
//                             ),
//                           );
//                           menuItems.insert(
//                             1,
//                             PopupMenuItem<String>(
//                               value: 'absence_etudiant',
//                               child: Text('Absence Etudiant'),
//                             ),
//                           );
//                         }

//                         // Optionally add a role-based item here
//                         menuItems.insert(
//                           0,
//                           PopupMenuItem<String>(
//                             value: 'role_item',
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '$userFullName', // Displaying the user's full name
//                                   style: TextStyle(
//                                     fontWeight: FontWeight
//                                         .bold, // Bold text for the full name
//                                     fontSize:
//                                         16, // Larger text size for the full name
//                                   ),
//                                 ),
//                                 Text(
//                                   '$userRole', // Displaying the user's role
//                                   style: TextStyle(
//                                     fontSize:
//                                         12, // Smaller font size for the role
//                                     color:
//                                         Colors.grey, // Muted color for the role
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );

//                         return menuItems;
//                       },
//                       child: CircleAvatar(
//                         backgroundImage: AssetImage(
//                             'assets/images/avatar.png'), // Path to your avatar image
//                         radius: 20,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
