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
      duration: const Duration(seconds: 9),
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
    return math.sin(t + phase) * 20.0;
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
                          floatY: _floatY(0.9),
                          floatY2: _floatY(-0.9),
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
                    _ShootingStar(
                      seconds: seconds,
                      timeOffsetSeconds: 0.0,
                      startXFactor: -0.55,
                      startYFactor: 1.15,
                      endXFactor: 0.90,
                      endYFactor: 0.70,
                      arcHeightFactor: 0.07,
                      intensity: 0.65,
                    ),
                    _ShootingStar(
                      seconds: seconds,
                      timeOffsetSeconds: 7.5,
                      startXFactor: -0.60,
                      startYFactor: 1.18,
                      endXFactor: 0.88,
                      endYFactor: 0.50,
                      arcHeightFactor: 0.08,
                      intensity: 0.65,
                    ),
                    _ShootingStar(
                      seconds: seconds,
                      timeOffsetSeconds: 12.5,
                      startXFactor: -0.02,
                      startYFactor: 1.25,
                      endXFactor: 0.95,
                      endYFactor: 0.30,
                      arcHeightFactor: 0.08,
                      intensity: 0.65,
                    )
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

class NebulaBlobSpec {
  final Offset center;          // in normalized (0..1, 0..1)
  final double widthFactor;     // relative to screen width (e.g. 0.60)
  final double heightFactor;    // relative to screen height (e.g. 0.35)
  final double rotationRad;     // rotate the blob
  final Color color;

  /// 0.0 sharp edge → 1.0 soft edge
  final double edgeSoftness;

  /// 0.0 smooth ellipse → 1.0 very wobbly blob
  final double irregularity;

  /// 0.0 no wobble detail → higher = more bumps around edge
  final int lobes;

  /// opacity baked into color (avoid Opacity widget)
  final double alpha;

  const NebulaBlobSpec({
    required this.center,
    required this.widthFactor,
    required this.heightFactor,
    required this.rotationRad,
    required this.color,
    this.edgeSoftness = 0.85,
    this.irregularity = 0.0,
    this.lobes = 6,
    this.alpha = 0.35,
  });
}

class NebulaPainter extends CustomPainter {
  final List<NebulaBlobSpec> blobs;

  /// Optional whole-layer blur (avoid Opacity widget)
  final double blurSigma;

  const NebulaPainter({
    required this.blobs,
    this.blurSigma = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (blurSigma > 0) {
      canvas.saveLayer(
        Offset.zero & size,
        Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
      );
    }

    for (final b in blobs) {
      final center = Offset(size.width * b.center.dx, size.height * b.center.dy);
      final w = size.width * b.widthFactor;
      final h = size.height * b.heightFactor;

      // Edge softness: where fade starts
      final stop = 1.0;
      final fadeStart = (stop * (1.0 - b.edgeSoftness)).clamp(0.0, stop);

      final shader = ui.Gradient.radial(
        center,
        math.max(w, h) * 0.6, // radius large enough to cover shape
        [
          b.color.withValues(alpha: b.alpha),
          b.color.withValues(alpha: b.alpha),
          b.color.withValues(alpha: 0.0),
        ],
        [0.0, fadeStart, stop],
      );

      final paint = Paint()..shader = shader;

      // Draw either ellipse or organic blob
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(b.rotationRad);
      canvas.translate(-center.dx, -center.dy);

      final path = _buildBlobPath(center, w, h, b.irregularity, b.lobes);
      canvas.drawPath(path, paint);

      canvas.restore();
    }

    if (blurSigma > 0) {
      canvas.restore();
    }
  }

  Path _buildBlobPath(
    Offset center,
    double width,
    double height,
    double irregularity,
    int lobes,
  ) {
    // If irregularity is 0, it's a perfect ellipse.
    if (irregularity <= 0.0001) {
      return Path()..addOval(Rect.fromCenter(center: center, width: width, height: height));
    }

    // Organic blob: radius varies around an ellipse
    final a = width / 2;
    final b = height / 2;

    // points count controls smoothness of blob edge
    const int points = 96;

    final path = Path();
    for (int i = 0; i <= points; i++) {
      final t = (i / points) * math.pi * 2;

      // base ellipse radius in direction t
      // (parametric ellipse point)
      final ex = math.cos(t) * a;
      final ey = math.sin(t) * b;

      // wobble factor: sin waves around the circumference
      final wobble =
          1.0 + irregularity * 0.25 * math.sin(lobes * t) + irregularity * 0.15 * math.sin((lobes + 3) * t + 1.7);

      final x = center.dx + ex * wobble;
      final y = center.dy + ey * wobble;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant NebulaPainter oldDelegate) {
    return oldDelegate.blobs != blobs || oldDelegate.blurSigma != blurSigma;
  }
}

class _NebulaLayerPrimary extends StatelessWidget {
  const _NebulaLayerPrimary();

  @override
  Widget build(BuildContext context) {
    // Adjust these freely: widthFactor/heightFactor/rotation/irregularity
    final blobs = <NebulaBlobSpec>[
      NebulaBlobSpec(
        center: const Offset(0.30, 0.42),
        widthFactor: 0.55,
        heightFactor: 0.15,          // ellipse
        rotationRad: -0.05,
        color: const Color(0xFF6C1B8C),
        alpha: 0.75,
        edgeSoftness: 0.88,
        irregularity: 0.95,          // organic edge
        lobes: 7,
      ),
      NebulaBlobSpec(
        center: const Offset(0.82, 0.20),
        widthFactor: 0.55,
        heightFactor: 0.09,
        rotationRad: 0.05,
        color: const Color(0xFF1F63B8),
        alpha: 0.40,
        edgeSoftness: 0.85,
        irregularity: 0.55,
        lobes: 6,
      ),
      NebulaBlobSpec(
        center: const Offset(0.75, 0.86),
        widthFactor: 0.25,
        heightFactor: 0.07,
        rotationRad: 0.30,
        color: const Color(0xFF7A1F4F),
        alpha: 0.85,
        edgeSoftness: 0.30,
        irregularity: 0.92,
        lobes: 8,
      ),
    ];

    return Positioned.fill(
      child: CustomPaint(
        painter: NebulaPainter(
          blobs: blobs,
          blurSigma: 20, // blur the whole nebula layer (no Opacity widget)
        ),
      ),
    );
  }
}

class _NebulaLayerSecondary extends StatelessWidget {
  const _NebulaLayerSecondary();

  @override
  Widget build(BuildContext context) {
    final blobs = <NebulaBlobSpec>[
      NebulaBlobSpec(
        center: const Offset(0.70, 0.55),
        widthFactor: 0.45,
        heightFactor: 0.28,
        rotationRad: -0.55,
        color: const Color(0xFF8D49D9),
        alpha: 0.37,
        edgeSoftness: 0.32,
        irregularity: 0.70,
        lobes: 5,
      ),
      NebulaBlobSpec(
        center: const Offset(0.10, 0.65),
        widthFactor: 0.38,
        heightFactor: 0.05,
        rotationRad: 50.0,
        color: const ui.Color.fromARGB(255, 27, 160, 162),
        alpha: 0.60,
        edgeSoftness: 0.32,
        irregularity: 0.8,
        lobes: 0,
      ),
    ];

    return Positioned.fill(
      child: CustomPaint(
        painter: NebulaPainter(
          blobs: blobs,
          blurSigma: 28,
        ),
      ),
    );
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
    return Positioned(
      top: 40,
      right: 20,
      child: SizedBox(
        width: 64,
        height: 64,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.4, -0.4), // highlight at top-left
              colors: [
                const Color(0xFFB487E6).withValues(alpha: 0.55),
                const Color(0xFF4B2B62).withValues(alpha: 0.25),
                const Color(0xFF1D1426).withValues(alpha: 0.00), // ✅ transparent edge
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

/* --------------------------- SHOOTING STAR --------------------------- */

class _ShootingStar extends StatelessWidget {
  final double seconds;

  /// Loop timing
  final double periodSeconds;
  final double travelSeconds;

  /// Start & end positions (relative to screen)
  /// These are allowed to be outside 0..1
  final double startXFactor;
  final double startYFactor;
  final double endXFactor;
  final double endYFactor;

  /// Ellipse feel (arc height as fraction of screen height)
  final double arcHeightFactor;

  /// Visuals
  final double length;
  final double thickness;
  final double intensity;

  // Time off for different shooting stars
  final double timeOffsetSeconds;

  const _ShootingStar({
    required this.seconds,
    this.timeOffsetSeconds = 0.0,
    this.periodSeconds = 20.0,
    this.travelSeconds = 6.0,
    this.startXFactor = -0.55, 
    this.startYFactor = 1.15,
    this.endXFactor = 0.90,   
    this.endYFactor = 0.70,
    this.arcHeightFactor = 0.07,
    this.length = 130,
    this.thickness = 2.2,
    this.intensity = 0.65,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final t = (seconds + timeOffsetSeconds) % periodSeconds;
    if (t > travelSeconds) return const SizedBox.shrink();

    final p = (t / travelSeconds).clamp(0.0, 1.0);
    final pe = _easeInOutCubic(p);
    final fade = _fade(pe);

    // ✅ Start & end (fully controllable)
    final start = Offset(w * startXFactor, h * startYFactor);
    final end = Offset(w * endXFactor, h * endYFactor);

    // Linear interpolation
    final x = _lerp(start.dx, end.dx, pe);
    final yBase = _lerp(start.dy, end.dy, pe);

    // Elliptical arc (sine bump)
    final arc = math.sin(math.pi * pe) * (h * arcHeightFactor);
    final y = yBase - arc;

    // Tangent for rotation
    final dx = (end.dx - start.dx);
    final dyLinear = (end.dy - start.dy);
    final dyArc = -(math.pi * math.cos(math.pi * pe)) * (h * arcHeightFactor);
    final dy = dyLinear + dyArc;

    final angle = math.atan2(dy, dx);

    return Positioned(
      left: x,
      top: y,
      child: Transform.rotate(
        angle: angle,
        alignment: Alignment.centerLeft,
        child: IgnorePointer(
          child: _MeteorStreak(
            length: length,
            thickness: thickness,
            alpha: (intensity * fade).clamp(0.0, 1.0),
          ),
        ),
      ),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  double _easeInOutCubic(double x) {
    if (x < 0.5) return 4 * x * x * x;
    final t = -2 * x + 2;
    return 1 - (t * t * t) / 2;
  }

  double _fade(double p) {
    if (p < 0.12) return p / 0.12;
    if (p > 0.88) return (1.0 - p) / 0.12;
    return 1.0;
  }
}

class _MeteorStreak extends StatelessWidget {
  final double length;
  final double thickness;
  final double alpha;

  const _MeteorStreak({
    required this.length,
    required this.thickness,
    required this.alpha,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: length,
      height: thickness,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            const Color(0xFFFFF0B3).withValues(alpha: alpha),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}




