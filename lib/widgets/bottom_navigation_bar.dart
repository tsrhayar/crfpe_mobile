import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavigationBarWidget({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure selectedIndex is within bounds
    final int validIndex =
        (selectedIndex >= 0 && selectedIndex < _bottomNavItems.length)
            ? selectedIndex
            : 0;

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
            currentIndex: validIndex,
            onTap: onItemTapped,
            selectedItemColor: const Color(0xFF1869a6),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: const Color(0xFF1869a6),
            // unselectedItemColor: Colors.grey.withOpacity(0.7),
            type: BottomNavigationBarType.fixed,
            items: _bottomNavItems,
          ),
        ),
      ),
    );
  }

  // BottomNavigationBar items with only "Absent" and "Agenda"
  static final List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(
      label: 'Actualité',
      icon: _navIcon(Icons.newspaper),
    ),
    BottomNavigationBarItem(
      label: "Agenda",
      icon: _navIcon(Icons.calendar_month_rounded),
    ),
  ];

  // Helper method to create navigation icons
  static Widget _navIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 30,
      ),
    );
  }
}
