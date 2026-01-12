import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class OverallScoreWidget extends StatelessWidget {
  final int score;
  const OverallScoreWidget({super.key, required this.score});

  String getScoreLabel(int s) {
    if (s >= 90) return "Excellent";
    if (s >= 70) return "Great";
    if (s >= 50) return "Good";
    return "Take it easy";
  }

  @override
  Widget build(BuildContext context) {
    final s = score.clamp(0, 100);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 189, 197, 144).withValues(alpha: 1.0), // Color of outter circle
                shape: BoxShape.circle,
                boxShadow: FortuneTheme.shadowGoldGlow,
              ),
              child: Center(
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 24, 19, 48), // Color of inner circle
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text(
                        '$s',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 255, 255, 255), // Color of overall score
                        ),
                      ),                   
                  ),
                ),
              ),
            ),
            const Positioned(
              top: -6,
              right: -6,
              child: Icon(Icons.auto_awesome, color: Color.fromARGB(255, 80, 64, 26), size: 22),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          getScoreLabel(s),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color.fromARGB(255, 255, 255, 255), // Color of Great/Good
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "Today's Luck",
          style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 231, 231, 231)),
        ),
      ],
    );
  }
}
