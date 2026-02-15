import 'package:flutter/material.dart';
import 'package:luck_app/overlays/iris_overlay.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        const IrisOverlay(),
      ],
    );
  }
}
