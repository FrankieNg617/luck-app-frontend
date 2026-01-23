import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class ReadyBackground extends StatefulWidget {
  final Widget? child;

  const ReadyBackground({
    super.key,
    this.child,
  });

  @override
  State<ReadyBackground> createState() => _ReadyBackgroundState();
}

class _ReadyBackgroundState extends State<ReadyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;

  // ✅ precache flag
  bool _bgReady = false;

  // ✅ keep provider so precache uses same key
  late final AssetImage _bgProvider;

  @override
  void initState() {
    super.initState();

    _bgProvider = const AssetImage('assets/backgrounds/ready_background.png');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final rng = math.Random();
    _stars = List.generate(150, (_) => _Star.random(rng));
  }

  // ✅ Preload image BEFORE first visible frame for this widget
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_bgReady) return;

    precacheImage(_bgProvider, context).then((_) {
      if (!mounted) return;
      setState(() => _bgReady = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _seconds() {
    final ms = _controller.lastElapsedDuration?.inMilliseconds ?? 0;
    return ms / 1000.0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // BG image
        Image(
          image: _bgProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        ),

        // Only show animated overlays after the image is ready (prevents stars-only phase)
        if (_bgReady) ...[
          // ================= DOT STAR =================
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final elapsedMs =
                    _controller.lastElapsedDuration?.inMilliseconds ?? 0;
                final seconds = elapsedMs / 1000.0;

                return CustomPaint(
                  painter: _StarPainter(
                    stars: _stars,
                    timeSeconds: seconds,
                  ),
                );
              },
            ),
          ),

          // ================= SHOOTING STAR =================
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final seconds = _seconds();
                return Stack(
                  children: [
                    _ShootingStar(
                      seconds: seconds,
                      timeOffsetSeconds: 0.0,
                      startXFactor: 1.20,
                      startYFactor: 0.15,
                      endXFactor: -0.70,
                      endYFactor: 0.60,
                      arcHeightFactor: 0.07,
                      intensity: 0.65,
                    ),
                  ],
                );
              },
            ),
          ),

          // ================= HINT TEXT =================
          const TypingHintText(
            username: 'Frankie',
          ),
        ],
      ],
    );
  }
}

/* ================= DOT STAR MODEL ================= */

class _Star {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final bool glow;
  final double phase;

  _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.glow,
    required this.phase,
  });

  factory _Star.random(math.Random rng) {
    return _Star(
      x: rng.nextDouble(),
      y: rng.nextDouble() * 0.5,
      radius: 0.6 + rng.nextDouble() * 1.8,
      speed: 0.8 + rng.nextDouble() * 3.0,
      glow: rng.nextDouble() < 0.45,
      phase: rng.nextDouble() * math.pi * 2,
    );
  }
}

/* ================= DOT STAR PAINTER ================= */

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double timeSeconds;

  _StarPainter({
    required this.stars,
    required this.timeSeconds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      final dx = s.x * size.width;
      final dy = s.y * size.height;

      final tw = 0.55 + 0.45 * math.sin(timeSeconds * s.speed + s.phase);
      final opacity = tw.clamp(0.10, 1.0);

      final corePaint =
          Paint()..color = Colors.white.withValues(alpha: opacity);

      canvas.drawCircle(Offset(dx, dy), s.radius, corePaint);

      if (s.glow) {
        final glowPaint = Paint()
          ..color = const Color.fromARGB(255, 165, 120, 241)
              .withValues(alpha: 1.00 * opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

        canvas.drawCircle(Offset(dx, dy), s.radius * 1.8, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}

/* --------------------------- SHOOTING STAR --------------------------- */

class _ShootingStar extends StatelessWidget {
  final double seconds;

  final double periodSeconds;
  final double travelSeconds;

  final double startXFactor;
  final double startYFactor;
  final double endXFactor;
  final double endYFactor;

  final double arcHeightFactor;

  final double length;
  final double thickness;
  final double intensity;

  final double timeOffsetSeconds;

  const _ShootingStar({
    required this.seconds,
    this.timeOffsetSeconds = 0.0,
    this.periodSeconds = 10.0,
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

    final start = Offset(w * startXFactor, h * startYFactor);
    final end = Offset(w * endXFactor, h * endYFactor);

    final x = _lerp(start.dx, end.dx, pe);
    final yBase = _lerp(start.dy, end.dy, pe);

    final arc = math.sin(math.pi * pe) * (h * arcHeightFactor);
    final y = yBase - arc;

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

/* --------------------------- HINT TEXT --------------------------- */

class TypingHintText extends StatefulWidget {
  final String username;
  final Duration initialDelay;

  const TypingHintText({
    super.key,
    required this.username,
    this.initialDelay = const Duration(milliseconds: 800),
  });

  @override
  State<TypingHintText> createState() => _TypingHintTextState();
}

class _TypingHintTextState extends State<TypingHintText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<int> _charCount;
  late Animation<double> _fade;

  late final String _firstText;
  late final String _secondText;

  bool _showSecond = false;

  @override
  void initState() {
    super.initState();

    _firstText = 'Hi ${widget.username}';
    _secondText = 'Tap anywhere to start your journey';

    _controller = AnimationController(vsync: this);

    // safe default
    _charCount = const AlwaysStoppedAnimation<int>(0);
    _fade = const AlwaysStoppedAnimation<double>(0.0);

    Future.delayed(widget.initialDelay, () {
      if (!mounted) return;
      _playTyping();
    });
  }

  void _playTyping() {
    _controller
      ..stop()
      ..reset()
      ..duration = Duration(milliseconds: _firstText.length * 55);

    _charCount = StepTween(
      begin: 0,
      end: _firstText.length,
    ).animate(_controller);

    setState(() {}); // rebuild with new animation

    _controller.forward().then((_) async {
      // pause after typing
      await Future.delayed(const Duration(milliseconds: 2000));
      if (!mounted) return;

      _playFadeIn();
    });
  }

  void _playFadeIn() {
    _controller
      ..stop()
      ..reset()
      ..duration = const Duration(milliseconds: 2000);

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    setState(() {
      _showSecond = true;
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fontSize = (size.width * 0.045).clamp(14.0, 20.0);
    final bottomPadding = (size.height * 0.08).clamp(28.0, 56.0);

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomPadding,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            Widget text;

            if (_showSecond) {
              // 🌫️ fade-in text
              text = Opacity(
                opacity: _fade.value,
                child: Text(
                  _secondText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 230, 230, 230),
                    letterSpacing: 0.4,
                  ),
                ),
              );
            } else {
              // ⌨️ typing text
              final count =
                  _charCount.value.clamp(0, _firstText.length);
              final visible = _firstText.substring(0, count);

              text = Text(
                visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 230, 230, 230),
                  letterSpacing: 0.4,
                ),
              );
            }

            return text;
          },
        ),
      ),
    );
  }
}




