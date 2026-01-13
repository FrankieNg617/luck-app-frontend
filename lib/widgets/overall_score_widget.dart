import 'dart:math' as math;
import 'package:flutter/material.dart';

class OverallScoreWidget extends StatefulWidget {
  final int score;
  const OverallScoreWidget({super.key, required this.score});

  @override
  State<OverallScoreWidget> createState() => _OverallScoreWidgetState();
}

class _OverallScoreWidgetState extends State<OverallScoreWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _count;
  late final Animation<double> _curve;

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
      duration: const Duration(milliseconds: 1500), // ✅ speed of flip/count
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _count = IntTween(begin: 0, end: s).animate(_curve);

    // ✅ plays once when widget is created (home screen entered)
    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant OverallScoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the page is not recreated but score changes, update target without replaying from 0.
    final oldS = oldWidget.score.clamp(0, 100);
    final newS = widget.score.clamp(0, 100);
    if (oldS != newS) {
      // Snap to new end without a "re-enter" animation.
      // If you want it to animate to new value, tell me.
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Simple 3D flip amount that peaks mid-animation.
  double _flipAngle(double t) {
    // t is 0..1. Make it rotate forward then back (flip feel).
    // Peak at mid: sin(pi*t) gives 0->1->0
    final peak = math.sin(math.pi * t);
    return peak * 0.55; // radians (~31deg). Increase for stronger flip.
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.score.clamp(0, 100);

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
                color: const Color.fromARGB(255, 189, 197, 144)
                    .withValues(alpha: 1.0), // outer circle
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 24, 19, 48), // inner circle
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final t = _curve.value; // 0..1
                        final angle = _flipAngle(t);

                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002) // perspective
                            ..rotateX(angle),
                          child: Text(
                            '${_count.value}',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
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
