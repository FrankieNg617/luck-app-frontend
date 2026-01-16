import 'dart:math';
import 'package:flutter/material.dart';

class NightSkyBalconyBackground extends StatefulWidget {
  const NightSkyBalconyBackground({super.key});

  @override
  State<NightSkyBalconyBackground> createState() =>
      _NightSkyBalconyBackgroundState();
}

class _NightSkyBalconyBackgroundState extends State<NightSkyBalconyBackground>
    with TickerProviderStateMixin {
  late final AnimationController _rotationCtrl;
  late final AnimationController _twinkleCtrl;

  // Pre-generate stars so they don't “jump” each frame.
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();

    _rotationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 140), // slow rotation
    )..repeat();

    _twinkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();

    _stars = _generateStars(
      count: 220,
      seed: 42,
      // Only generate stars for the “sky” portion (leave bottom for balcony).
      // We still generate full-screen, but painter will fade near bottom.
    );
  }

  @override
  void dispose() {
    _rotationCtrl.dispose();
    _twinkleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final merged = Listenable.merge([_rotationCtrl, _twinkleCtrl]);

    return AnimatedBuilder(
      animation: merged,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _NightSkyBalconyPainter(
            stars: _stars,
            rotationT: _rotationCtrl.value,
            twinkleT: _twinkleCtrl.value,
          ),
        );
      },
    );
  }
}

class _NightSkyBalconyPainter extends CustomPainter {
  _NightSkyBalconyPainter({
    required this.stars,
    required this.rotationT,
    required this.twinkleT,
  });

  final List<_Star> stars;
  final double rotationT; // 0..1
  final double twinkleT; // 0..1

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // --- Background gradient (night sky) ---
    final skyRect = Rect.fromLTWH(0, 0, w, h);
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF050615),
          Color(0xFF070A22),
          Color(0xFF0B1030),
          Color(0xFF0B1233),
        ],
        stops: [0.0, 0.45, 0.8, 1.0],
      ).createShader(skyRect);
    canvas.drawRect(skyRect, bgPaint);

    // --- Rotating starfield (rotate around center, slightly above mid for nicer look) ---
    final center = Offset(w * 0.5, h * 0.45);
    final angle = rotationT * 2 * pi * 0.05; // tiny portion of a full turn per cycle
    // If you want a bit faster, increase 0.05 -> 0.1

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);

    _drawStars(canvas, size);

    canvas.restore();

    // --- Balcony + telescope silhouette ---
    _drawBalconyAndTelescope(canvas, size);

    // --- Soft vignette (makes edges nicer) ---
    final vignette = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.2),
        radius: 1.1,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.35),
        ],
        stops: const [0.65, 1.0],
      ).createShader(skyRect);
    canvas.drawRect(skyRect, vignette);
  }

  void _drawStars(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Balcony occupies bottom ~26% of screen.
    final balconyTopY = h * 0.74;

    // Twinkle time in radians
    final t = twinkleT * 2 * pi;

    for (final s in stars) {
      final px = s.x * w;
      final py = s.y * h;

      // Fade stars near the balcony area so they don't overlap visually.
      final fade = (1.0 - ((py - balconyTopY) / (h - balconyTopY)).clamp(0.0, 1.0));
      final skyFade = py < balconyTopY ? 1.0 : fade * 0.15;

      // Twinkle: sin wave per-star with unique phase and speed.
      final tw = 0.5 + 0.5 * sin(t * s.twinkleSpeed + s.phase);
      // Map to a subtle alpha range.
      final alpha = (0.25 + tw * 0.75) * s.baseAlpha * skyFade;

      final paint = Paint()
        ..color = s.color.withValues(alpha: alpha.clamp(0.0, 1.0));

      // A tiny glow for bigger stars
      if (s.radius > 1.6) {
        final glowPaint = Paint()
          ..color = s.color.withValues(alpha: (alpha * 0.35).clamp(0.0, 1.0))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(Offset(px, py), s.radius * 2.2, glowPaint);
      }

      canvas.drawCircle(Offset(px, py), s.radius, paint);
    }
  }

  void _drawBalconyAndTelescope(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final balconyTop = h * 0.74;
    final floorTop = h * 0.82;

    final dark = const Color.fromARGB(255, 64, 64, 144);
    final darker = const Color(0xFF030308);

    // Balcony base (floor)
    final floorRect = Rect.fromLTWH(0, floorTop, w, h - floorTop);
    canvas.drawRect(floorRect, Paint()..color = darker);

    // Balcony wall / railing plate
    final wallRect = Rect.fromLTWH(0, balconyTop, w, floorTop - balconyTop);
    canvas.drawRect(wallRect, Paint()..color = dark);

    // Railing top bar
    final barH = max(2.0, h * 0.008);
    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.06, balconyTop + h * 0.03, w * 0.88, barH),
      Radius.circular(barH),
    );
    canvas.drawRRect(barRect, Paint()..color = Colors.black.withValues(alpha: 0.85));

    // Railing posts
    final postW = max(2.0, w * 0.008);
    final postH = (floorTop - balconyTop) * 0.55;
    final postTopY = balconyTop + h * 0.03 + barH;
    final postCount = 10;
    final left = w * 0.08;
    final right = w * 0.92;
    final spacing = (right - left) / (postCount - 1);

    final postPaint = Paint()..color = Colors.black.withValues(alpha: 0.75);
    for (int i = 0; i < postCount; i++) {
      final x = left + spacing * i;
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - postW / 2, postTopY, postW, postH),
        Radius.circular(postW),
      );
      canvas.drawRRect(r, postPaint);
    }

    // Telescope silhouette (simple but recognizable)
    final scopeBase = Offset(w * 0.72, floorTop - h * 0.02);
    final scopeScale = min(w, h);

    final tubeLen = scopeScale * 0.18;
    final tubeW = scopeScale * 0.03;

    // Tripod legs
    final legPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.9)
      ..strokeWidth = max(2.0, scopeScale * 0.006)
      ..strokeCap = StrokeCap.round;

    final apex = Offset(scopeBase.dx - scopeScale * 0.02, floorTop - scopeScale * 0.16);
    canvas.drawLine(apex, Offset(scopeBase.dx - scopeScale * 0.10, scopeBase.dy), legPaint);
    canvas.drawLine(apex, Offset(scopeBase.dx + scopeScale * 0.04, scopeBase.dy), legPaint);
    canvas.drawLine(apex, Offset(scopeBase.dx - scopeScale * 0.03, scopeBase.dy), legPaint);

    // Telescope tube (rotated rounded rect)
    final tubeAngle = -pi / 8; // pointing up-left a bit
    canvas.save();
    canvas.translate(apex.dx, apex.dy);
    canvas.rotate(tubeAngle);
    final tubeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, -tubeW / 2, tubeLen, tubeW),
      Radius.circular(tubeW / 2),
    );
    final tubePaint = Paint()..color = Colors.black.withValues(alpha: 0.92);
    canvas.drawRRect(tubeRect, tubePaint);

    // Eyepiece / front rim
    final rimPaint = Paint()..color = Colors.black.withValues(alpha: 0.98);
    canvas.drawCircle(Offset(tubeLen, 0), tubeW * 0.55, rimPaint);
    canvas.drawCircle(Offset(tubeLen, 0), tubeW * 0.35, Paint()..color = darker);

    // Small finder scope
    final fsLen = tubeLen * 0.35;
    final fsW = tubeW * 0.45;
    final fsRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tubeLen * 0.25, -tubeW * 0.9, fsLen, fsW),
      Radius.circular(fsW / 2),
    );
    canvas.drawRRect(fsRect, Paint()..color = Colors.black.withValues(alpha: 0.85));

    canvas.restore();

    // A subtle highlight on balcony top edge (moonlight vibe)
    final highlight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withValues(alpha: 0.10),
          Colors.white.withValues(alpha: 0.02),
          Colors.white.withValues(alpha: 0.10),
        ],
      ).createShader(Rect.fromLTWH(0, balconyTop, w, barH * 2));
    canvas.drawRect(Rect.fromLTWH(0, balconyTop, w, max(1.0, h * 0.006)), highlight);
  }

  @override
  bool shouldRepaint(covariant _NightSkyBalconyPainter oldDelegate) {
    // repaint every tick
    return oldDelegate.rotationT != rotationT ||
        oldDelegate.twinkleT != twinkleT ||
        oldDelegate.stars != stars;
  }
}

class _Star {
  _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.baseAlpha,
    required this.twinkleSpeed,
    required this.phase,
    required this.color,
  });

  final double x; // 0..1
  final double y; // 0..1
  final double radius;
  final double baseAlpha; // 0..1
  final double twinkleSpeed; // multiplier
  final double phase; // 0..2pi
  final Color color;
}

List<_Star> _generateStars({required int count, required int seed}) {
  final rnd = Random(seed);

  Color starColor() {
    // Slightly varied whites/blues for a nicer sky
    final roll = rnd.nextDouble();
    if (roll < 0.70) return const Color(0xFFFFFFFF);
    if (roll < 0.88) return const Color(0xFFBFD7FF); // cool blue
    return const Color(0xFFFFF2C6); // warm tint
  }

  return List.generate(count, (_) {
    final x = rnd.nextDouble();
    // Bias stars toward upper area a bit
    final yRaw = rnd.nextDouble();
    final y = pow(yRaw, 0.75).toDouble(); // more stars toward top

    final r = 0.6 + rnd.nextDouble() * 1.9; // 0.6..2.5
    final baseAlpha = 0.35 + rnd.nextDouble() * 0.65; // 0.35..1.0
    final twinkleSpeed = 0.7 + rnd.nextDouble() * 1.6; // 0.7..2.3
    final phase = rnd.nextDouble() * 2 * pi;

    return _Star(
      x: x,
      y: y,
      radius: r,
      baseAlpha: baseAlpha,
      twinkleSpeed: twinkleSpeed,
      phase: phase,
      color: starColor(),
    );
  });
}