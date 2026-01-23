import 'package:flutter/material.dart';
import 'package:luck_app/screens/ready_screen.dart';
import 'ui/fortune_style.dart';
import 'app_shell.dart';

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

      // ✅ Navigator lives here
      home: const ReadyScreen(),

      // ✅ AppShell wraps ALL routes and NEVER rebuilds
      builder: (context, child) {
        return AppShell(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

