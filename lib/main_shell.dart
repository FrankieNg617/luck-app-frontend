import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import '../screens/home_screen.dart';
import '../screens/zodiac_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/love_calculator_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _index = 0;

  // Keep pages alive (no re-build / no scroll reset)
  final List<Widget> _pages = const [
    HomeScreen(),
    ZodiacScreen(),
    LoveCalculatorScreen(),
    ProfileScreen(),
  ];

  // Navigation bar colors per page
  final List<Color> _navColors = const [
    Color.fromARGB(255, 29, 15, 59), // Home
    Colors.black, // Zodiac
    Colors.black, // Love Cal
    Color.fromARGB(255, 31, 12, 49), // Profile
  ];

  late final AnimationController _popCtrl;

  @override
  void initState() {
    super.initState();
    _popCtrl = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 1.0, // stable
      duration: const Duration(milliseconds: 600), // fallback only
    );
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    super.dispose();
  }

  // ✅ iOS-like spring pop
  void _runSpringPop() {
    _popCtrl.stop();

    // 0 = fully "popped" (bigger), 1 = settled (normal)
    _popCtrl.value = 0.0;

    // iOS-ish spring feel:
    // - lower stiffness => softer
    // - higher damping => less bounce
    const spring = SpringDescription(mass: 1.0, stiffness: 100.0, damping: 7.0);

    // Animate value from 0 -> 1 with spring physics
    final sim = SpringSimulation(spring, 0.0, 1.0, 8.0);
    _popCtrl.animateWith(sim);
  }

  void _onTap(int i) {
    if (i == _index) {
      // Optional: re-pop when tapping the same tab
      _runSpringPop();
      return;
    }

    setState(() => _index = i);
    _runSpringPop();
  }

  @override
  Widget build(BuildContext context) {
    final navColor = _navColors[_index];
    final h = MediaQuery.of(context).size.height;
    final iconSize = (h * 0.02).clamp(22.0, 30.0);

    // Pop amount (bigger when controller is near 0, settle at 1)
    // maxPop: how much it scales up at the "pop" moment
    const maxPop = 0.005;
    final scaleAnim = _popCtrl.drive(
      Tween<double>(begin: 1.0 + maxPop, end: 1.0),
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: _popCtrl,
        builder: (context, _) {
          return IndexedStack(
            index: _index,
            children: List.generate(_pages.length, (i) {
              final active = i == _index;

              return Transform.scale(
                scale: active ? scaleAnim.value : 1.0,
                alignment: Alignment.center,
                child: _pages[i],
              );
            }),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: navColor,
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
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
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
