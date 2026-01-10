import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class OverallScoreWidget extends StatelessWidget {
  final int score;
  const OverallScoreWidget({super.key, required this.score});

  String getScoreLabel(int s) {
    if (s >= 90) return "Excellent";
    if (s >= 75) return "Great";
    if (s >= 60) return "Good";
    if (s >= 40) return "Fair";
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
                gradient: FortuneTheme.gradientGold,
                shape: BoxShape.circle,
                boxShadow: FortuneTheme.shadowGoldGlow,
              ),
              child: Center(
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDFCFB),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (rect) => FortuneTheme.gradientGold.createShader(rect),
                      child: Text(
                        '$s',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              top: -6,
              right: -6,
              child: Icon(Icons.auto_awesome, color: FortuneTheme.gold, size: 22),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          getScoreLabel(s),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: FortuneTheme.foreground,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "Today's Luck",
          style: TextStyle(fontSize: 12, color: FortuneTheme.mutedForeground),
        ),
      ],
    );
  }
}
