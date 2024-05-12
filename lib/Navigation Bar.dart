import 'package:flutter/material.dart';

class MyBottomNavBar extends StatelessWidget {
  final String currentScreen;

  const MyBottomNavBar({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      unselectedLabelStyle: TextStyle(color: Colors.grey.shade800),
      items: [
        BottomNavigationBarItem(icon: Icon(currentScreen == 'home' ? Icons.home : Icons.home_outlined, color: currentScreen == 'home' ? Colors.white : Colors.grey), label: "Home", backgroundColor: Colors.red.shade800),
        BottomNavigationBarItem(icon: Icon(currentScreen == 'merit' ? Icons.calculate_rounded : Icons.calculate_outlined, color: currentScreen == 'merit' ? Colors.white : Colors.grey), label: "Merit", backgroundColor: Colors.red.shade800),
        BottomNavigationBarItem(icon: Icon(currentScreen == 'sports' ? Icons.sports_cricket : Icons.sports_cricket_outlined, color: currentScreen == 'sports' ? Colors.white : Colors.grey), label: "Sports"),
        BottomNavigationBarItem(icon: Icon(currentScreen == 'about' ? Icons.account_balance : Icons.account_balance_outlined, color: currentScreen == 'about' ? Colors.white : Colors.grey), label: "About"),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, "/");
            break;
          case 1:
            Navigator.pushNamed(context, "/merit");
            break;
          case 2:
            Navigator.pushNamed(context, "/sports");
            break;
          case 3:
            Navigator.pushNamed(context, "/about");
            break;
          default:
        }
      },
    );
  }
}