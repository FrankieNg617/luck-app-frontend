import 'package:flutter/material.dart';

class EyepieceVignette extends StatelessWidget {
  const EyepieceVignette({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [
            Color(0x00000000),
            Color(0xFF000000),
            Color(0xFF000000),
          ],
          stops: [0.6, 0.6, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}
