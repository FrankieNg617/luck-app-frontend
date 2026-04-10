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
  late final Animation<double> _curve;
  late Animation<int> _count;

  String getScoreLabel(int s) {
    if (s >= 90) return "Excellent";
    if (s >= 70) return "Great";
    if (s >= 50) return "Good";
    return "Take it easy";
  }

  int get _clampedScore => widget.score.clamp(0, 100);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _count = IntTween(begin: 0, end: _clampedScore).animate(_curve);

    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant OverallScoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldScore = oldWidget.score.clamp(0, 100);
    final newScore = widget.score.clamp(0, 100);

    if (oldScore != newScore) {
      _count = IntTween(begin: 0, end: newScore).animate(_curve);

      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _clampedScore;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 128,
          height: 128,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final animatedScore = _count.value;
              final animatedRingValue = s == 0
                  ? 0.0
                  : (_curve.value * (s / 100)).clamp(0.0, 1.0);

              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 128,
                    height: 128,
                    child: CircularProgressIndicator(
                      value: animatedRingValue,
                      strokeWidth: 8,
                      backgroundColor: const Color.fromARGB(
                        255,
                        60,
                        60,
                        60,
                      ).withValues(alpha: 0.35),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(
                          255,
                          189,
                          197,
                          144,
                        ).withValues(alpha: 1),
                      ),
                    ),
                  ),
                  Text(
                    '$animatedScore',
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
