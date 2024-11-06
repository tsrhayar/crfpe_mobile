import 'package:crfpe_mobile/pages/absence/gestion_absence_etudiant.dart';
import 'package:crfpe_mobile/pages/absence/gestion_absence_formateur.dart';
import 'package:crfpe_mobile/pages/profil/gestion_profil_etudiant.dart';
import 'package:crfpe_mobile/pages/profil/gestion_profil_formateur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crfpe_mobile/pages/home/home.dart';
import 'package:crfpe_mobile/pages/login/login.dart';
import 'package:crfpe_mobile/pages/notification/notification.dart';

class HeaderEtudiantSection extends StatelessWidget {
  const HeaderEtudiantSection({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

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
              offset: Offset(0, 3),
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
                'assets/images/logo.svg',
                width: 40,
                height: 40,
              ),
            ),

            // Titre au centre
            Expanded(
              child: Center(
                child: Text(
                  'CRFPE Etudiant',
                  style: TextStyle(
                    color: Color(0xFF1869a6),
                    fontSize: 20,
                    fontWeight: FontWeight.bold, // Ajouter un poids de police pour plus de contraste
                  ),
                ),
              ),
            ),

            // Icônes à droite
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Color.fromARGB(255, 24, 166, 107),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notificationpage()),
                    );
                  },
                ),
                SizedBox(width: 8), // Ajouter un espace entre les icônes
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      _logout(context);
                    }  else if (value == 'profile_formateur') {
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
                    return [
                      PopupMenuItem<String>(
                        value: 'profile_formateur',
                        child: Text('Profil Formateur'),
                      ),
                       PopupMenuItem<String>(
                        value: 'profile_etudiant',
                        child: Text('Profil Etudiant'),
                      ), PopupMenuItem<String>(
                        value: 'absence_formateur',
                        child: Text('Absence Formateur'),
                      ), PopupMenuItem<String>(
                        value: 'absence_etudiant',
                        child: Text('Absence Etudiant'),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Déconnexion'),
                      ),
                    ];
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.png'),
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
