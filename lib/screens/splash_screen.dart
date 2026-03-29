import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:async';
import 'setup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AssetImage _setupBg;
  late final AssetImage _splashBg;

  @override
  void initState() {
    super.initState();
    _setupBg = const AssetImage('assets/backgrounds/setup_bg.png');
    _splashBg = const AssetImage('assets/splash/splash_bg.png');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await precacheImage(_splashBg, context);
      FlutterNativeSplash.remove();
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
      backgroundColor: const Color(0xFF1A0F2E),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: _splashBg,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
