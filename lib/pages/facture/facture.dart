import 'package:crfpe_mobile/pages/communication/communication.dart';
import 'package:crfpe_mobile/pages/home/widgets/header_formateur.dart';
import 'package:crfpe_mobile/pages/facture/widgets/f_formateur.dart';
import 'package:crfpe_mobile/pages/agenda/agenda.dart';
import 'package:crfpe_mobile/pages/evaluation/evaluation.dart';
import 'package:crfpe_mobile/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:crfpe_mobile/widgets/bottom_navigation_bar.dart'; // Import the new widget


class Facturationpage extends StatefulWidget {
  const Facturationpage({Key? key}) : super(key: key);

  @override
  _FacturationpageState createState() => _FacturationpageState();
}

class _FacturationpageState extends State<Facturationpage> {
  int _selectedIndex = 3; // Index initial pour l'élément "Agenda"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 249),
      body: CustomScrollView(
        slivers: [
          // SliverPersistentHeader pour le header fixe
          // SliverPersistentHeader(
          //   pinned: true,
          //   delegate: CustomSliverPersistentHeader(
          //     minHeight: 80,
          //     maxHeight: 120,
          //     child: Container(
          //       color: const Color(0xfff6f8ff),
          //       child: const HeaderFormateurSection(),
          //     ),
          //   ),
          // ),
              SliverPersistentHeader(
            pinned: true,
            delegate: CustomSliverPersistentHeader(
              minHeight: 80,
              maxHeight: 120,
              child: Container(
                color: const Color(0xfff6f8ff),
                child: const HeaderFormateurSection(),
              ),
            ),
          ),
          // SliverList pour afficher la liste des événements
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Container(
          //       padding: const EdgeInsets.all(16),
          //       color: Colors.white, // Fond blanc pour l'actualité
          //       child: F_FormateurSection(),
          //     ),
          //   ]),
          // ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white, // Fond blanc pour l'actualité
                child: F_FormateurSection(),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // Pass the tap handler
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
