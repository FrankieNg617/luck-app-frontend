import 'dart:math' as math;
import 'package:flutter/material.dart';

class HomeBackground extends StatefulWidget {
  final Widget child;

  const HomeBackground({
    super.key,
    required this.child,
  });

  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_DotStar> _dotStars;

  static const int _seed = 20260111;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();

    final rng = math.Random(_seed);
    _dotStars = List.generate(40, (i) => _DotStar.random(rng));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _dotTwinkle(double phase, double speed) {
    final t = _controller.value * math.pi * 2 * speed;
    return 0.80 + 0.20 * math.sin(t + phase);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ================= BACKGROUND IMAGE =================
        Image.asset(
          'assets/backgrounds/home_background.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),

        // ================= STARS =================
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final ms =
                  _controller.lastElapsedDuration?.inMilliseconds ?? 0;
              final seconds = ms / 1000.0;

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Large comic stars
                  CustomPaint(
                    painter: _LargeStarsPainter(
                      seconds: seconds,
                      sparkleSpeed: 0.5,
                    ),
                  ),

                  // Small dot stars
                  CustomPaint(
                    painter: _DotStarsPainter(
                      stars: _dotStars,
                      twinkleFn: _dotTwinkle,
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // ================= UI =================
        widget.child,
      ],
    );
  }
}

/* --------------------------- LARGE STARS --------------------------- */

class _LargeStarsPainter extends CustomPainter {
  final double seconds;
  final double sparkleSpeed;

  _LargeStarsPainter({
    required this.seconds,
    required this.sparkleSpeed,
  });

  double _tw(double phase) {
    final t = seconds * sparkleSpeed * 2 * math.pi;
    return 0.20 + 0.80 * math.sin(t + phase);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawStar(
      canvas,
      center: Offset(size.width * 0.10, size.height * 0.15),
      size: 16,
      color: const Color(0xFFFFF1C2),
      alpha: 0.55 + 0.25 * _tw(0.0),
    );

    _drawStar(
      canvas,
      center: Offset(size.width * 0.85, size.height * 0.25),
      size: 12,
      color: const Color(0xFFCFA9FF),
      alpha: 0.45 + 0.30 * _tw(-1.0),
    );

    _drawStar(
      canvas,
      center: Offset(size.width * 0.05, size.height * 0.45),
      size: 10,
      color: const Color(0xFFA9D5FF),
      alpha: 0.40 + 0.30 * _tw(-2.0),
    );

    _drawStar(
      canvas,
      center: Offset(size.width * 0.92, size.height * 0.60),
      size: 14,
      color: const Color(0xFFFFF1C2),
      alpha: 0.55 + 0.25 * _tw(-0.5),
    );

    _drawStar(
      canvas,
      center: Offset(size.width * 0.65, size.height * 0.10),
      size: 10,
      color: const Color(0xFFA9D5FF),
      alpha: 0.40 + 0.30 * _tw(-2.5),
    );
  }

  void _drawStar(
    Canvas canvas, {
    required Offset center,
    required double size,
    required Color color,
    required double alpha,
  }) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: alpha.clamp(0.0, 1.0));

    final outer = size;
    final inner = size * 0.42;

    final path = Path();
    for (int i = 0; i < 8; i++) {
      final ang = (math.pi / 4) * i - math.pi / 2;
      final r = (i.isEven) ? outer : inner;
      final x = center.dx + math.cos(ang) * r;
      final y = center.dy + math.sin(ang) * r;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LargeStarsPainter oldDelegate) =>
      oldDelegate.seconds != seconds;
}

/* --------------------------- DOT STARS --------------------------- */

class _DotStar {
  final double x;
  final double y;
  final double r;
  final double opacity;
  final double phase;
  final double speed;

  _DotStar({
    required this.x,
    required this.y,
    required this.r,
    required this.opacity,
    required this.phase,
    required this.speed,
  });

  factory _DotStar.random(math.Random rng) {
    return _DotStar(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      r: 0.6 + rng.nextDouble() * 1.5,
      opacity: 0.2 + rng.nextDouble() * 0.6,
      phase: rng.nextDouble() * math.pi * 2,
      speed: 0.7 + rng.nextDouble() * 1.3,
    );
  }
}

class _DotStarsPainter extends CustomPainter {
  final List<_DotStar> stars;
  final double Function(double phase, double speed) twinkleFn;

  _DotStarsPainter({
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

      final glow = Paint()
        ..color = Colors.white.withValues(alpha: 0.20 * a)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(center, s.r * 2.0, glow);
    }
  }

  @override
  bool shouldRepaint(covariant _DotStarsPainter oldDelegate) => true;
}
