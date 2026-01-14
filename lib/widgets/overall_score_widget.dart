import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class OverallScoreWidget extends StatefulWidget {
  final int score;
  const OverallScoreWidget({super.key, required this.score});

  @override
  State<OverallScoreWidget> createState() => _OverallScoreWidgetState();
}

class _OverallScoreWidgetState extends State<OverallScoreWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;
  late final Animation<int> _count;

  String getScoreLabel(int s) {
    if (s >= 90) return "Excellent";
    if (s >= 70) return "Great";
    if (s >= 50) return "Good";
    return "Take it easy";
  }

  @override
  void initState() {
    super.initState();

    final s = widget.score.clamp(0, 100);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900), // ring + number timing
    );

    _curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _count = IntTween(begin: 0, end: s).animate(_curve);

    // play once on entry
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.score.clamp(0, 100);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 128,
          height: 128,
          child: AnimatedBuilder(
            animation: _curve,
            builder: (context, _) {
              final t = _curve.value; // 0..1

              return Stack(
                alignment: Alignment.center,
                children: [
                  // ✅ OUTER RING (animated fill)
                  SizedBox(
                    width: 128,
                    height: 128,
                    child: CircularProgressIndicator(
                      value: t,
                      strokeWidth: 8,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(255, 189, 197, 144)
                            .withValues(alpha: 1),
                      ),
                    ),
                  ),

                  // ✅ SCORE ONLY (no inner circle)
                  Text(
                    '${_count.value}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          getScoreLabel(s),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          "Today's Luck",
          style: TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 231, 231, 231),
          ),
        ),
      ],
    );
  }
}
