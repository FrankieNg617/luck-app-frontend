import 'package:flutter/material.dart';
import 'package:luck_app/screens/ready_screen.dart';
import 'ui/fortune_style.dart';

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
      home: const ReadyScreen(),
    );
  }
}
