import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  /// Optional middle layer (e.g. blinking stars)
  final Widget? midLayer;

  /// Foreground content (UI widgets later)
  final Widget? child;

  const HomeBackground({
    super.key,
    this.midLayer,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ================= BASE SKY =================
        Image.asset(
          'assets/backgrounds/sky.png',
          fit: BoxFit.cover,
        ),

        // ================= MID LAYER (STARS) =================
        if (midLayer != null) midLayer!,

        // ================= FOREGROUND =================
        Image.asset(
          'assets/backgrounds/foreground.png',
          fit: BoxFit.cover,
        ),

        // ================= UI CONTENT =================
        if (child != null) child!,
      ],
    );
  }
}
