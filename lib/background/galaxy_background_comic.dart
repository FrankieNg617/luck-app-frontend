import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GalaxyBackgroundComic extends StatefulWidget {
  final Widget child;

  /// Seed for deterministic star placement (like stable background).
  final int seed;

  /// Turn off animation if needed.
  final bool animate;

  final double dotStarSpeed;
  final double sparkleStarSpeed;

  const GalaxyBackgroundComic({
    super.key,
    required this.child,
    this.seed = 20260111,
    this.animate = true,
    this.dotStarSpeed = 2.0,
    this.sparkleStarSpeed = 0.5,
  });

  @override
  State<GalaxyBackgroundComic> createState() => _GalaxyBackgroundComicState();
}

class _GalaxyBackgroundComicState extends State<GalaxyBackgroundComic>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_DotStar> _dotStars;

  @override
  void initState() {
    super.initState();

    // Twinkle + float timing driver
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    if (widget.animate) {
      _controller.repeat();
    } else {
      _controller.value = 0.35;
    }

    final rng = math.Random(widget.seed);
    _dotStars = List.generate(40, (i) => _DotStar.random(rng, i));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _dotTwinkle(double phase, double speed) {
    // 0..1 -> twinkle factor around ~[0.6..1.0]
    final t = _controller.value * math.pi * 2 * speed * widget.dotStarSpeed;
    return (0.80 + 0.20 * math.sin(t + phase));
  }

  double _floatY(double phase) {
    // subtle vertical drift like animate-float
    final t = _controller.value * math.pi * 2;
    return math.sin(t + phase) * 6.0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // fixed inset-0 background
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final ms = _controller.lastElapsedDuration?.inMilliseconds ?? 0;
                final seconds = ms / 1000.0;

                return Stack(
                  children: [
                    const _BaseGradient(),

                    // Nebula layers
                    const _NebulaLayerPrimary(),
                    const _NebulaLayerSecondary(),
                    
                    // Swirl SVG equivalent (two paths) with float
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _SwirlPainter(
                          floatY: _floatY(0.0),
                          floatY2: _floatY(-1.2),
                        ),
                      ),
                    ),

                    // Large stylized stars (twinkle)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _LargeStarsPainter(
                          seconds: seconds,
                          sparkleSpeed: widget.sparkleStarSpeed,
                        ),
                      ),
                    ),

                    // Small dot stars (twinkle + glow)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DotStarsPainter(
                          stars: _dotStars,
                          twinkleFn: _dotTwinkle,
                        ),
                      ),
                    ),

                    // Comic-style planet/moon accent (top-right)
                    //const _PlanetAccent(),

                    // Shooting star accent
                    _ShootingStar(floatY: _floatY(0.7)),
                  ],
                );
              },
            ),
          ),
        ),

        // your content on top
        widget.child,
      ],
    );
  }
}

/* --------------------------- BASE GRADIENT --------------------------- */

class _BaseGradient extends StatelessWidget {
  const _BaseGradient();

  @override
  Widget build(BuildContext context) {
    // bg-gradient-to-b from hsl(260,30%,8%) via hsl(270,40%,12%) to hsl(250,35%,6%)
    // Approximated by close RGB values.
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0814),
            Color(0xFF120A22),
            Color(0xFF090C1A),
          ],
          stops: [0.0, 0.0, 0.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

/* --------------------------- NEBULA LAYERS --------------------------- */

class _NebulaLayerPrimary extends StatelessWidget {
  final double opacity;

  /// 0.0 = sharper boundary, 1.0 = very soft boundary
  final double edgeSoftness;

  /// Optional extra blur applied to the whole nebula layer.
  /// 0 = none, 10~40 subtle, 60~120 strong.
  final double blurSigma;

  const _NebulaLayerPrimary({
    this.opacity = 0.40,
    this.edgeSoftness = 0.75,
    this.blurSigma = 0,
  });

  @override
  Widget build(BuildContext context) {
    Widget layer = CustomPaint(
      painter: _NebulaPainterPrimary(edgeSoftness: edgeSoftness),
    );

    if (blurSigma > 0) {
      layer = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: layer,
      );
    }

    return Positioned.fill(
      child: Opacity(opacity: opacity, child: layer),
    );
  }
}

class _NebulaPainterPrimary extends CustomPainter {
  final double edgeSoftness;

  /// 0.0 = sharp edge, 1.0 = very soft edge
  const _NebulaPainterPrimary({required this.edgeSoftness});

  @override
  void paint(Canvas canvas, Size size) {
    _paintRadial(
      canvas,
      size,
      center: Offset(size.width * 0.20, size.height * 0.20),
      radiusX: size.width * 0.20,
      radiusY: size.height * 0.20,
      color: const Color(0xFF6C1B8C),
      stop: 0.50,
    );

    _paintRadial(
      canvas,
      size,
      center: Offset(size.width * 0.80, size.height * 0.30),
      radiusX: size.width * 0.10,
      radiusY: size.height * 0.10,
      color: const Color(0xFF1F63B8),
      stop: 0.45,
    );

    _paintRadial(
      canvas,
      size,
      center: Offset(size.width * 0.60, size.height * 0.80),
      radiusX: size.width * 0.10,
      radiusY: size.height * 0.10,
      color: const Color(0xFF7A1F4F),
      stop: 0.50,
    );

    _paintRadial(
      canvas,
      size,
      center: Offset(size.width * 0.10, size.height * 0.70),
      radiusX: size.width * 0.50,
      radiusY: size.height * 0.30,
      color: const Color(0xFF1E6A77),
      stop: 0.40,
    );
  }

  void _paintRadial(
    Canvas canvas,
    Size size, {
    required Offset center,
    required double radiusX,
    required double radiusY,
    required Color color,
    required double stop,
  }) {
    final rect = Rect.fromCenter(center: center, width: radiusX, height: radiusY);

    // edgeSoftness controls when fade starts:
    // 0.0 -> fade starts early (hard edge look)
    // 1.0 -> fade starts late (very soft boundary)
    final fadeStart = (stop * (1.0 - edgeSoftness)).clamp(0.0, stop);

    // Use 3-stop gradient: solid -> solid -> fade out
    final shader = ui.Gradient.radial(
      center,
      (math.max(radiusX, radiusY)) / 2,
      [
        color.withValues(alpha: 1.0),
        color.withValues(alpha: 1.0),
        color.withValues(alpha: 0.0),
      ],
      [0.0, fadeStart, stop],
    );

    final paint = Paint()..shader = shader;

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.drawOval(rect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NebulaPainterPrimary oldDelegate) {
    return oldDelegate.edgeSoftness != edgeSoftness;
  }
}


class _NebulaLayerSecondary extends StatelessWidget {
  final double opacity;
  final double edgeSoftness;
  final double blurSigma;

  const _NebulaLayerSecondary({
    this.opacity = 0.50,
    this.edgeSoftness = 0.4,
    this.blurSigma = 45,
  });

  @override
  Widget build(BuildContext context) {
    Widget layer = CustomPaint(
      painter: _NebulaPainterSecondary(edgeSoftness: edgeSoftness),
    );

    if (blurSigma > 0) {
      layer = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: layer,
      );
    }

    return Positioned.fill(
      child: Opacity(opacity: opacity, child: layer),
    );
  }
}

class _NebulaPainterSecondary extends CustomPainter {
  final double edgeSoftness;

  const _NebulaPainterSecondary({required this.edgeSoftness});

  @override
  void paint(Canvas canvas, Size size) {
    _paintCircle(
      canvas,
      size,
      center: Offset(size.width * 0.70, size.height * 0.60),
      radius: 100,
      color: const Color(0xFF8D49D9),
      stop: 0.60,
    );

    _paintCircle(
      canvas,
      size,
      center: Offset(size.width * 0.30, size.height * 0.40),
      radius: 100,
      color: const Color(0xFF9B3D8C),
      stop: 0.55,
    );
  }

  void _paintCircle(
    Canvas canvas,
    Size size, {
    required Offset center,
    required double radius,
    required Color color,
    required double stop,
  }) {
    final fadeStart = (stop * (1.0 - edgeSoftness)).clamp(0.0, stop);

    final shader = ui.Gradient.radial(
      center,
      radius,
      [
        color.withValues(alpha: 1.0),
        color.withValues(alpha: 1.0),
        color.withValues(alpha: 0.0),
      ],
      [0.0, fadeStart, stop],
    );

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _NebulaPainterSecondary oldDelegate) {
    return oldDelegate.edgeSoftness != edgeSoftness;
  }
}


/* --------------------------- SWIRL PATHS (SVG) --------------------------- */

class _SwirlPainter extends CustomPainter {
  final double floatY;
  final double floatY2;

  _SwirlPainter({required this.floatY, required this.floatY2});

  @override
  void paint(Canvas canvas, Size size) {
    // TSX viewBox 0 0 400 800; scale to screen
    final sx = size.width / 400.0;
    final sy = size.height / 800.0;

    // gradients like swirlGradient1/2 :contentReference[oaicite:3]{index=3}
    final grad1 = ui.Gradient.linear(
      Offset(0, 0),
      Offset(size.width, size.height),
      [
        const Color(0xFFA879F0).withValues(alpha: 1.0),
        const Color(0xFFD657A7).withValues(alpha: 1.0),
      ],
    );

    final grad2 = ui.Gradient.linear(
      Offset(0, size.height),
      Offset(size.width, 0),
      [
        const Color(0xFF3B82F6).withValues(alpha: 1.0),
        const Color(0xFFB06BEA).withValues(alpha: 1.0),
      ],
    );

    final p1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..shader = grad1
      ..color = Colors.white.withValues(alpha: 0.20);

    final p2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..shader = grad2
      ..color = Colors.white.withValues(alpha: 0.20);

    // Path 1 (approx cubic conversion from SVG Q/T string)
    // d="M200,400 Q100,300 150,200 T200,100 Q250,150 300,100 T350,200 ..."
    // We'll use quadratic segments. :contentReference[oaicite:4]{index=4}
    Path path1 = Path();
    path1.moveTo(200, 400);
    path1.quadraticBezierTo(100, 300, 150, 200);
    path1.quadraticBezierTo(200, 100, 200, 100);
    path1.quadraticBezierTo(250, 150, 300, 100);
    path1.quadraticBezierTo(350, 50, 350, 200);
    path1.quadraticBezierTo(400, 300, 350, 400);
    path1.quadraticBezierTo(300, 500, 300, 500);
    path1.quadraticBezierTo(250, 550, 200, 500);
    path1.quadraticBezierTo(150, 450, 150, 400);
    path1.quadraticBezierTo(100, 350, 150, 300);
    path1.quadraticBezierTo(200, 250, 200, 250);

    // Path 2
    // d="M100,600 Q150,500 100,400 T150,300 Q200,350 250,300 ..."
    Path path2 = Path();
    path2.moveTo(100, 600);
    path2.quadraticBezierTo(150, 500, 100, 400);
    path2.quadraticBezierTo(50, 300, 150, 300);
    path2.quadraticBezierTo(200, 350, 250, 300);
    path2.quadraticBezierTo(300, 250, 300, 400);
    path2.quadraticBezierTo(350, 500, 300, 600);
    path2.quadraticBezierTo(250, 700, 250, 700);
    path2.quadraticBezierTo(200, 750, 150, 700);
    path2.quadraticBezierTo(100, 650, 100, 600);

    canvas.save();
    canvas.translate(0, floatY);
    canvas.scale(sx, sy);
    canvas.drawPath(path1, p1);
    canvas.restore();

    canvas.save();
    canvas.translate(0, floatY2);
    canvas.scale(sx, sy);
    canvas.drawPath(path2, p2);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SwirlPainter oldDelegate) {
    return oldDelegate.floatY != floatY || oldDelegate.floatY2 != floatY2;
  }
}

/* --------------------------- LARGE STARS (SVG ICONS) --------------------------- */

class _LargeStarsPainter extends CustomPainter {
  final double seconds;
  final double sparkleSpeed;

  _LargeStarsPainter({required this.seconds, required this.sparkleSpeed});

  double _tw(double delayPhase) {
    final t = seconds * sparkleSpeed * 2 * math.pi;
    return (0.20 + 0.80 * math.sin(t + delayPhase));
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Positions from TSX:
    // top 15% left 10% (w-8), top 25% right 15% (w-6), top 45% left 5% (w-5),
    // top 60% right 8% (w-7), top 80% left 20% (w-4), top 10% right 35% (w-5)
    // :contentReference[oaicite:5]{index=5}

    _drawStar(
      canvas,
      center: Offset(size.width * 0.10, size.height * 0.15),
      size: 16,
      color: const Color(0xFFFFF1C2), // starlight-ish
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
      center: Offset(size.width * 0.20, size.height * 0.80),
      size: 8,
      color: const Color(0xFFFF9ED3),
      alpha: 0.45 + 0.30 * _tw(-1.5),
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
    // 8-point “comic” star similar to the SVG path in TSX
    // path: M12 0 L14.5 8.5 L23 11 ...
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: alpha.clamp(0.0, 1.0));

    final outer = size;
    final inner = size * 0.42;
    final points = <Offset>[];

    for (int i = 0; i < 8; i++) {
      final ang = (math.pi / 4) * i - math.pi / 2;
      final r = (i % 2 == 0) ? outer : inner;
      points.add(Offset(center.dx + math.cos(ang) * r, center.dy + math.sin(ang) * r));
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();

    // mild glow
    // final glow = Paint()
    //   ..color = Colors.white.withValues(alpha: alpha * 0.18)
    //   ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // canvas.drawPath(path, glow);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LargeStarsPainter oldDelegate) {
    return oldDelegate.seconds != seconds ||
        oldDelegate.sparkleSpeed != sparkleSpeed;
  }
}

/* --------------------------- SMALL DOT STARS --------------------------- */

class _DotStar {
  final double x; // 0..1
  final double y; // 0..1
  final double r; // px
  final double opacity; // base
  final double delayPhase;
  final double speed;

  _DotStar({
    required this.x,
    required this.y,
    required this.r,
    required this.opacity,
    required this.delayPhase,
    required this.speed,
  });

  factory _DotStar.random(math.Random rng, int i) {
    // TSX: width/height random 1..4, opacity 0.2..0.8, delay 0..4s :contentReference[oaicite:6]{index=6}
    final r = 0.5 + rng.nextDouble() * 1.5; // circle radius (so 1..4px diameter-ish)
    return _DotStar(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      r: r,
      opacity: 0.2 + rng.nextDouble() * 0.6,
      delayPhase: rng.nextDouble() * math.pi * 2,
      speed: 0.7 + rng.nextDouble() * 1.3,
    );
  }
}

class _DotStarsPainter extends CustomPainter {
  final List<_DotStar> stars;
  final double Function(double phase, double speed) twinkleFn;

  _DotStarsPainter({required this.stars, required this.twinkleFn});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      final a = (s.opacity * twinkleFn(s.delayPhase, s.speed)).clamp(0.0, 1.0);

      final center = Offset(size.width * s.x, size.height * s.y);

      final paint = Paint()..color = Colors.white.withValues(alpha: a);
      canvas.drawCircle(center, s.r, paint);

      // TSX boxShadow: '0 0 4px 1px rgba(255,255,255,0.3)' :contentReference[oaicite:7]{index=7}
      final glow = Paint()
        ..color = Colors.white.withValues(alpha: 0.20 * a)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(center, s.r * 2.0, glow);
    }
  }

  @override
  bool shouldRepaint(covariant _DotStarsPainter oldDelegate) => true;
}

/* --------------------------- PLANET ACCENT --------------------------- */

class _PlanetAccent extends StatelessWidget {
  const _PlanetAccent();

  @override
  Widget build(BuildContext context) {
    // TSX: top 5% right 5% w-16 h-16, opacity 0.30 with radial gradient + glow :contentReference[oaicite:8]{index=8}
    return Positioned(
      top: 40,
      right: 20,
      child: Opacity(
        opacity: 0.30,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              center: Alignment(-0.4, -0.4), // ~at 30% 30%
              colors: [
                Color(0xFFB487E6),
                Color(0xFF4B2B62),
                Color(0xFF1D1426),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                spreadRadius: 5,
                color: const Color(0xFF7A2DBA).withValues(alpha: 0.30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* --------------------------- SHOOTING STAR --------------------------- */

class _ShootingStar extends StatelessWidget {
  final double floatY;
  const _ShootingStar({required this.floatY});

  @override
  Widget build(BuildContext context) {
    // TSX: top 30% left 60% width 20 (w-20) height 0.5, rotate(-30deg),
    // gradient: transparent -> hsl(50,80%,75%) -> transparent, opacity 0.40 :contentReference[oaicite:9]{index=9}
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.30 + floatY,
      left: MediaQuery.of(context).size.width * 0.60,
      child: Transform.rotate(
        angle: -30 * math.pi / 180,
        child: Opacity(
          opacity: 0.40,
          child: Container(
            width: 80,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  const Color(0xFFFFF0B3).withValues(alpha: 1.0),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
