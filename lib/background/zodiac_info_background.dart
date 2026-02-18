import 'dart:math' as math;
import 'package:flutter/material.dart';

class ZodiacInfoBackground extends StatefulWidget {
  final Widget child;

  const ZodiacInfoBackground({
    super.key,
    required this.child,
  });

  @override
  State<ZodiacInfoBackground> createState() => _ZodiacInfoBackgroundState();
}

class _ZodiacInfoBackgroundState extends State<ZodiacInfoBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_ZodiacDotStar> _stars;

  static const int _seed = 20260217;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final rng = math.Random(_seed);

    _stars = List.generate(
      180, // more stars for deep space look
      (_) => _ZodiacDotStar.random(rng),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _twinkle(double phase, double speed) {
    final t = _controller.value * math.pi * 2 * speed;
    return 0.75 + 0.25 * math.sin(t + phase);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(
          color: Color.fromARGB(255, 16, 15, 52),
        ),

        // ===== SMALL DOT STARS =====
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                painter: _ZodiacDotStarsPainter(
                  stars: _stars,
                  twinkleFn: _twinkle,
                ),
              );
            },
          ),
        ),

        // ===== UI =====
        widget.child,
      ],
    );
  }
}

/* ----------------------- DOT STAR MODEL ----------------------- */

class _ZodiacDotStar {
  final double x;
  final double y;
  final double r;
  final double opacity;
  final double phase;
  final double speed;

  _ZodiacDotStar({
    required this.x,
    required this.y,
    required this.r,
    required this.opacity,
    required this.phase,
    required this.speed,
  });

  factory _ZodiacDotStar.random(math.Random rng) {
    return _ZodiacDotStar(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      r: 0.5 + rng.nextDouble() * 1.2,
      opacity: 0.2 + rng.nextDouble() * 0.5,
      phase: rng.nextDouble() * math.pi * 2,
      speed: 0.6 + rng.nextDouble() * 1.4,
    );
  }
}

/* ----------------------- DOT STAR PAINTER ----------------------- */

class _ZodiacDotStarsPainter extends CustomPainter {
  final List<_ZodiacDotStar> stars;
  final double Function(double phase, double speed) twinkleFn;

  _ZodiacDotStarsPainter({
    required this.stars,
    required this.twinkleFn,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      final a =
          (s.opacity * twinkleFn(s.phase, s.speed)).clamp(0.0, 1.0);

      final center = Offset(size.width * s.x, size.height * s.y);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: a);

      canvas.drawCircle(center, s.r, paint);

      // subtle glow
      final glow = Paint()
        ..color = Colors.white.withValues(alpha: 0.15 * a)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(center, s.r * 1.8, glow);
    }
  }

  @override
  bool shouldRepaint(covariant _ZodiacDotStarsPainter oldDelegate) => true;
}
