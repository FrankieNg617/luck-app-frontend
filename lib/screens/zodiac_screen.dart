import 'package:flutter/material.dart';
import '../background/home_background.dart';

class ZodiacScreen extends StatelessWidget {
  const ZodiacScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBackground(
        child: SafeArea(
          child: Center(
            child: Text(
              'Zodiac Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
