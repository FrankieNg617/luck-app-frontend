import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProfileBackground extends StatefulWidget {
  const ProfileBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ProfileBackground> createState() => _ProfileBackgroundState();
}

class _ProfileBackgroundState extends State<ProfileBackground>
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
    _dotStars = List.generate(120, (_) => _DotStar.random(rng));
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
        // ======= PURPLE WAVES BACKGROUND (no texture) =======
        CustomPaint(
          painter: _ProfileBgPainter(),
        ),

        // ======= DOT STARS (same as love cal) =======
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _DotStarsPainter(
                  stars: _dotStars,
                  twinkleFn: _dotTwinkle,
                ),
              );
            },
          ),
        ),

        // ======= UI =======
        widget.child,
      ],
    );
  }
}

/* --------------------------- BACKGROUND PAINTER --------------------------- */

class _ProfileBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final base = Paint()
      ..isAntiAlias = true
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF5B238B),
          Color(0xFF3A0F63),
          Color(0xFF160024),
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, base);

    void drawBand(
      Path path,
      List<Color> colors,
      Alignment begin,
      Alignment end, {
      required double alpha,
    }) {
      final paint = Paint()
        ..isAntiAlias = true
        ..shader = LinearGradient(
          begin: begin,
          end: end,
          colors: colors.map((c) => c.withValues(alpha: alpha)).toList(),
        ).createShader(rect);

      canvas.drawPath(path, paint);
    }

    // Band 1 (top)
    final band1 = Path()
      ..moveTo(-size.width * 0.15, size.height * 0.06)
      ..cubicTo(
        size.width * 0.10,
        size.height * 0.00,
        size.width * 0.55,
        size.height * 0.18,
        size.width * 1.15,
        size.height * 0.10,
      )
      ..lineTo(size.width * 1.15, size.height * 0.22)
      ..cubicTo(
        size.width * 0.55,
        size.height * 0.30,
        size.width * 0.10,
        size.height * 0.12,
        -size.width * 0.15,
        size.height * 0.18,
      )
      ..close();

    drawBand(
      band1,
      const [Color(0xFF6B2CA0), Color(0xFF4A1675), Color(0xFF2A083F)],
      Alignment.topLeft,
      Alignment.centerRight,
      alpha: 0.22,
    );

    // Band 2 (middle)
    final band2 = Path()
      ..moveTo(-size.width * 0.25, size.height * 0.32)
      ..cubicTo(
        size.width * 0.05,
        size.height * 0.20,
        size.width * 0.55,
        size.height * 0.54,
        size.width * 1.25,
        size.height * 0.38,
      )
      ..lineTo(size.width * 1.25, size.height * 0.62)
      ..cubicTo(
        size.width * 0.55,
        size.height * 0.78,
        size.width * 0.05,
        size.height * 0.48,
        -size.width * 0.25,
        size.height * 0.60,
      )
      ..close();

    drawBand(
      band2,
      const [Color(0xFF612091), Color(0xFF3C0F64), Color(0xFF1D0330)],
      Alignment.centerLeft,
      Alignment.centerRight,
      alpha: 0.28,
    );

    // Band 3 (bottom)
    final band3 = Path()
      ..moveTo(-size.width * 0.30, size.height * 0.68)
      ..cubicTo(
        size.width * 0.10,
        size.height * 0.54,
        size.width * 0.65,
        size.height * 1.02,
        size.width * 1.30,
        size.height * 0.80,
      )
      ..lineTo(size.width * 1.30, size.height * 1.05)
      ..cubicTo(
        size.width * 0.70,
        size.height * 1.18,
        size.width * 0.10,
        size.height * 0.98,
        -size.width * 0.30,
        size.height * 1.10,
      )
      ..close();

    drawBand(
      band3,
      const [Color(0xFF54157F), Color(0xFF2B0843), Color(0xFF12001F)],
      Alignment.centerLeft,
      Alignment.bottomRight,
      alpha: 0.26,
    );

    // Bottom-right oval highlight
    final oval = Rect.fromCenter(
      center: Offset(size.width * 0.80, size.height * 0.93),
      width: size.width * 0.62,
      height: size.height * 0.20,
    );

    final ovalPaint = Paint()
      ..isAntiAlias = true
      ..shader = RadialGradient(
        center: const Alignment(0.35, 0.15),
        radius: 1.0,
        colors: [
          const Color(0xFF7B3BB4).withValues(alpha: 0.20),
          const Color(0xFF3A0F63).withValues(alpha: 0.00),
        ],
        stops: const [0.0, 1.0],
      ).createShader(oval);

    canvas.drawOval(oval, ovalPaint);

    // Subtle vignette
    final vignette = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.15, -0.10),
        radius: 1.15,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.18),
        ],
        stops: const [0.60, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, vignette);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* --------------------------- DOT STARS (same logic) --------------------------- */

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
      final a = (s.opacity * twinkleFn(s.phase, s.speed)).clamp(0.0, 1.0);
      final center = Offset(size.width * s.x, size.height * s.y);

      final paint = Paint()..color = Colors.white.withValues(alpha: a);
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