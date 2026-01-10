import 'package:flutter/material.dart';
import 'ui/fortune_style.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FortuneApp());
}

class FortuneApp extends StatelessWidget {
  const FortuneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Luck',
      theme: FortuneTheme.lightTheme(),
      home: const HomeScreen(),
    );
  }
}
