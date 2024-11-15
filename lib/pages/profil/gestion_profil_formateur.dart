import 'package:flutter/material.dart';
import 'package:crfpe_mobile/pages/communication/communication.dart';
import 'package:crfpe_mobile/pages/home/widgets/header_formateur.dart';
import 'package:crfpe_mobile/pages/profil/widgets/g_formateur.dart';
import 'package:crfpe_mobile/pages/Facture/facture.dart';
import 'package:crfpe_mobile/pages/agenda/agenda.dart';
import 'package:crfpe_mobile/pages/evaluation/evaluation.dart';
import 'package:crfpe_mobile/pages/home/home.dart';
import 'package:crfpe_mobile/widgets/bottom_navigation_bar.dart'; // Import the new widget

class GestionProfilFormateurpage extends StatefulWidget {
  const GestionProfilFormateurpage({Key? key}) : super(key: key);

  @override
  _GestionProfilFormateurpageState createState() =>
      _GestionProfilFormateurpageState();
}

class _GestionProfilFormateurpageState
    extends State<GestionProfilFormateurpage> {
  int _selectedIndex = 4; // Index initial pour l'élément "Contact"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 249),
      body: CustomScrollView(
        slivers: [
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
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: const G_FormateurSection(),
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
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EvaluationPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AgendaPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Facturationpage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Communicationpage()),
        );
        break;
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant CustomSliverPersistentHeader oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
