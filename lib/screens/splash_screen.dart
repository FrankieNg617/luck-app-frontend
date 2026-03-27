import 'package:flutter/material.dart';
import 'dart:async';
import 'setup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AssetImage _setupBg;

  @override
  void initState() {
    super.initState();
    _setupBg = const AssetImage('assets/backgrounds/setup_bg.png');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareAndNavigate();
    });
  }

  Future<void> _prepareAndNavigate() async {
    await precacheImage(_setupBg, context);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SetupScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/splash/splash_bg.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
