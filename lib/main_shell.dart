import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/zodiac_screen.dart';
import '../screens/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // Keep pages alive (no re-build / no scroll reset)
  final List<Widget> _pages = const [
    HomeScreen(),
    ZodiacScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    final iconSize = (h * 0.02).clamp(22.0, 30.0);

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        backgroundColor: const Color.fromARGB(255, 39, 9, 65),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withValues(alpha: 0.4),

        elevation: 0,
        iconSize: iconSize,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
