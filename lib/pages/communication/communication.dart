// import 'package:crfpe_mobile/pages/home/widgets/header_etudiant.dart';
import 'package:crfpe_mobile/pages/home/widgets/header.dart';
import 'package:crfpe_mobile/pages/communication/widgets/c_etudiant.dart';
import 'package:crfpe_mobile/pages/Facture/facture.dart';
import 'package:crfpe_mobile/pages/agenda/agenda.dart';
import 'package:crfpe_mobile/pages/evaluation/evaluation.dart';
import 'package:crfpe_mobile/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:crfpe_mobile/widgets/bottom_navigation_bar.dart'; // Import the new widget


class Communicationpage extends StatefulWidget {
  const Communicationpage({Key? key}) : super(key: key);

  @override
  _CommunicationpageState createState() => _CommunicationpageState();
}

class _CommunicationpageState extends State<Communicationpage> {
  int _selectedIndex = 4; // Index initial pour l'élément "Agenda"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 249),
      body: CustomScrollView(
        slivers: [
          // SliverPersistentHeader pour le header fixe
          SliverPersistentHeader(
            pinned: true,
            delegate: CustomSliverPersistentHeader(
              minHeight: 80,
              maxHeight: 120,
              child: Container(
                color: const Color(0xfff6f8ff),
                child: const HeaderSection(),
              ),
            ),
          ),
          //     SliverPersistentHeader(
          //   pinned: true,
          //   delegate: CustomSliverPersistentHeader(
          //     minHeight: 80,
          //     maxHeight: 120,
          //     child: Container(
          //       color: const Color(0xfff6f8ff),
          //       child: const HeaderEtudiantSection(),
          //     ),
          //   ),
          // ),
          // SliverList pour afficher la liste des événements
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white, // Fond blanc pour l'actualité
                child: C_EtudiantSection(),
              ),
            ]),
          ),
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Container(
          //       padding: const EdgeInsets.all(16),
          //       color: Colors.white, // Fond blanc pour l'actualité
          //       child: F_EtudiantSection(),
          //     ),
          //   ]),
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // Pass the tap handler
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      color: const Color(0xfff6f8ff),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Color(0xFF1869a6),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: Colors.grey.withOpacity(0.7),
            type: BottomNavigationBarType.fixed,
            items:  [
              BottomNavigationBarItem(
                label: 'Absent 4',
                icon: Icon(
                  Icons.person_off_rounded,
                  size: 50,
                ),
              ),
              BottomNavigationBarItem(
                label: "Doc",
                icon: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.insert_drive_file_rounded,
                    size: 30,
                    
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "Agenda",
                icon: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    size: 30,
                    color:  Colors.grey,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "Facture",
                icon: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
               
                  ),
                  child: Icon(
                    Icons.request_quote_rounded,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "Contact",
                icon: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    // color: Colors.grey.withOpacity(0.2),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.message_rounded,
                    size: 30,
                    color: Color(0xFF1869a6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navigation vers l'écran Agenda si l'élément "Agenda" est sélectionné
      // Optionnel : Naviguer vers la page AgendaSection
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
     if (index == 1) {
      // Navigation vers l'écran Agenda si l'élément "Agenda" est sélectionné
      // Optionnel : Naviguer vers la page AgendaSection
      Navigator.push(
        context,
          // MaterialPageRoute(builder: (context) => const EvaluationPage()),
          MaterialPageRoute(builder: (context) => const AgendaPage()),
      );
    }
     if (index == 2) { // old index 2
      // Navigation vers l'écran Agenda si l'élément "Agenda" est sélectionné
      // Optionnel : Naviguer vers la page AgendaSection
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AgendaPage()),
      );
    }
    if (index == 3) {
      // Navigation vers l'écran Agenda si l'élément "Agenda" est sélectionné
      // Optionnel : Naviguer vers la page AgendaSection
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Facturationpage()),
      );
    }
     if (index == 4) {
      // Navigation vers l'écran Agenda si l'élément "Agenda" est sélectionné
      // Optionnel : Naviguer vers la page AgendaSection
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Communicationpage()),
      );
    }
  }
}

class CustomSliverPersistentHeader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  CustomSliverPersistentHeader({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant CustomSliverPersistentHeader oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
