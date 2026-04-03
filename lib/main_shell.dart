import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import '../screens/home_screen.dart';
import '../screens/zodiac_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/love_calculator_screen.dart';
import '../store/home_data_store.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.homeDataStore,
  });

  final HomeDataStore homeDataStore;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _index = 0;

  late final List<Widget> _pages = [
    HomeScreen(homeDataStore: widget.homeDataStore),
    const ZodiacScreen(),
    const LoveCalculatorScreen(),
    const ProfileScreen(),
  ];

  final List<Color> _navColors = const [
    Color.fromARGB(255, 29, 15, 59),
    Colors.black,
    Color.fromARGB(255, 19, 17, 67),
    Color.fromARGB(255, 31, 12, 49),
  ];

  late final AnimationController _popCtrl;

  @override
  void initState() {
    super.initState();
    _popCtrl = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 1.0,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    super.dispose();
  }

  void _runSpringPop() {
    _popCtrl.stop();
    _popCtrl.value = 0.0;

    const spring = SpringDescription(
      mass: 1.0,
      stiffness: 100.0,
      damping: 7.0,
    );

    final sim = SpringSimulation(spring, 0.0, 1.0, 8.0);
    _popCtrl.animateWith(sim);
  }

  void _onTap(int i) {
    if (i == _index) {
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