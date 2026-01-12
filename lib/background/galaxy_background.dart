import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GalaxyBackground extends StatelessWidget {
  final Widget child;
  const GalaxyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _SpaceGradient(),
        const _StarFieldLayer(),
        const _Vignette(),
        child,
      ],
    );
  }
}

/* -------------------- SPACE GRADIENT -------------------- */

class _SpaceGradient extends StatelessWidget {
  const _SpaceGradient();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.2, -0.3),
          radius: 1.2,
          colors: [
            Color(0xFF1B0B2E), // deep purple
            Color(0xFF090A1A), // navy
            Color(0xFF04040A), // near black
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

/* -------------------- STAR FIELD -------------------- */

class _StarFieldLayer extends StatefulWidget {
  const _StarFieldLayer();

  @override
  State<_StarFieldLayer> createState() => _StarFieldLayerState();
}

class _StarFieldLayerState extends State<_StarFieldLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const int _starCount = 260;
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(42);
    _stars = List.generate(_starCount, (_) => _Star.random(rng));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _StarPainter(_stars, driftT: _controller.value),
          );
        },
      ),
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double r;
  final double alpha;
  final double twinklePhase;
  final double twinkleSpeed;

  _Star({
    required this.x,
    required this.y,
    required this.r,
    required this.alpha,
    required this.twinklePhase,
    required this.twinkleSpeed,
  });

  factory _Star.random(math.Random rng) {
    final base = rng.nextDouble();
    final r = 0.6 + math.pow(base, 3) * 1.8;

    return _Star(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      r: r.toDouble(),
      alpha: 0.25 + rng.nextDouble() * 0.65,
      twinklePhase: rng.nextDouble() * math.pi * 2,
      twinkleSpeed: 0.6 + rng.nextDouble() * 1.8,
    );
  }
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double driftT;

  _StarPainter(this.stars, {required this.driftT});

  @override
  void paint(Canvas canvas, Size size) {
    final dx = (driftT - 0.5) * 18;
    final dy = (driftT - 0.5) * 10;

    for (final s in stars) {
      final px = s.x * size.width + dx;
      final py = s.y * size.height + dy;

      final twinkle =
          0.75 + 0.25 * math.sin(s.twinklePhase + driftT * math.pi * 2 * s.twinkleSpeed);
      final a = (s.alpha * twinkle).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: a);

      canvas.drawCircle(Offset(px, py), s.r, paint);

      if (s.r > 1.8) {
        final glow = Paint()
          ..color = Colors.white.withValues(alpha: a * 0.22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

        canvas.drawCircle(Offset(px, py), s.r * 2.2, glow);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) {
    return oldDelegate.driftT != driftT;
  }
}

/* -------------------- VIGNETTE -------------------- */

class _Vignette extends StatelessWidget {
  const _Vignette();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, 0),
            radius: 1.2,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.25),
              Colors.black.withValues(alpha: 0.55),
            ],
            stops: const [0.55, 0.85, 1.0],
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
