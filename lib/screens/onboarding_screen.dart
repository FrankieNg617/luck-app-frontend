import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.sendRequest,
    this.onComplete,
  });

  final Future<void> Function() sendRequest;
  final VoidCallback? onComplete;

  @override
  State<OnboardingScreen> createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  static const List<String> _messages = [
    'Reading the stars...',
    'Aligning your planets...',
    'Consulting the cosmos...',
    'Calculating your fortune...',
    'Almost there...',
  ];

  static const Duration _minimumLoadingDuration = Duration(seconds: 5);
  static const Duration _finishAnimationDuration = Duration(milliseconds: 700);
  static const Duration _afterCompleteDelay = Duration(milliseconds: 1500);

  final Random _random = Random();

  late final Stopwatch _starStopwatch;
  late final Stopwatch _loadingStopwatch;
  late final AnimationController _starsController;
  late final AnimationController _fadeController;

  late final List<_StarData> _stars;

  Timer? _progressTimer;
  double _progress = 0;
  String _message = _messages.first;

  bool _requestFinished = false;
  bool _isShowingErrorDialog = false;
  bool _isFinishing = false;

  @override
  void initState() {
    super.initState();

    _starStopwatch = Stopwatch()..start();
    _loadingStopwatch = Stopwatch()..start();

    _stars = List.generate(200, (_) => _StarData.random(_random));

    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _startFakeProgress();
    _runRequest();
  }

  void _startFakeProgress() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted) return;
      if (_isFinishing) return;

      final elapsedMs = _loadingStopwatch.elapsedMilliseconds;
      final minMs = _minimumLoadingDuration.inMilliseconds;
      final timeRatio = (elapsedMs / minMs).clamp(0.0, 1.0);

      setState(() {
        if (_requestFinished) {
          if (timeRatio < 1.0) {
            // Request finished early:
            // fill evenly to 100 by the end of minimumLoadingDuration.
            _progress = 100.0 * timeRatio;
          } else {
            _progress = 100.0;
          }
        } else {
          // Request still running:
          // fill evenly to 90 by the end of minimumLoadingDuration.
          _progress = 90.0 * timeRatio;
        }

        final idx = min((_progress ~/ 22), _messages.length - 1);
        _message = _messages[idx];
      });
    });
  }

  Future<void> _runRequest() async {
    try {
      await widget.sendRequest();

      if (!mounted) return;
      _requestFinished = true;

      final elapsed = _loadingStopwatch.elapsed;

      if (elapsed < _minimumLoadingDuration) {
        final remaining = _minimumLoadingDuration - elapsed;
        await Future.delayed(remaining);

        if (!mounted) return;

        setState(() {
          _progress = 100;
          _message = _messages.last;
        });
      } else {
        if (!mounted) return;
        await _animateToComplete();
      }

      await Future.delayed(_afterCompleteDelay);
      
      if (!mounted) return;
      widget.onComplete?.call();
    } catch (e) {
      if (!mounted || _isShowingErrorDialog) return;

      _progressTimer?.cancel();
      _isShowingErrorDialog = true;

      await _showRequestErrorDialog();
    }
  }

  Future<void> _animateToComplete() async {
    if (_isFinishing) return;

    _isFinishing = true;
    _progressTimer?.cancel();

    final start = _progress;

    final controller = AnimationController(
      vsync: this,
      duration: _finishAnimationDuration,
    );

    final animation = Tween<double>(
      begin: start,
      end: 100,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    void listener() {
      if (!mounted) return;
      setState(() {
        _progress = animation.value;
        _message = _messages.last;
      });
    }

    controller.addListener(listener);
    await controller.forward();
    controller.removeListener(listener);
    controller.dispose();

    if (!mounted) return;
    setState(() {
      _progress = 100;
      _message = _messages.last;
    });
  }

  Future<void> _showRequestErrorDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final shortestSide = min(
          MediaQuery.sizeOf(dialogContext).width,
          MediaQuery.sizeOf(dialogContext).height,
        );

        final titleColor = _hsl(60, 20, 95);
        final bodyColor = _hsl(230, 15, 75);
        final buttonColor = _hsl(270, 60, 65);
        final backgroundColor = _hsl(232, 35, 12);

        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Something went wrong',
            style: TextStyle(
              color: titleColor,
              fontSize: shortestSide * 0.05,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Please reopen the app and try again.',
            style: TextStyle(
              color: bodyColor,
              fontSize: shortestSide * 0.036,
              height: 1.4,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: const Text('Confirm'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _starsController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Color _hsl(double h, double sPercent, double lPercent, [double alpha = 1]) {
    return HSLColor.fromAHSL(
      alpha,
      h,
      sPercent / 100,
      lPercent / 100,
    ).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final shortestSide = min(size.width, size.height);

    final backgroundColor = _hsl(232, 40, 8);
    final foregroundColor = _hsl(60, 20, 95);
    final mutedColor = _hsl(230, 30, 16);
    final mutedForegroundColor = _hsl(230, 15, 55);
    final primaryColor = _hsl(270, 60, 65);
    final accentColor = _hsl(45, 90, 60);
    final starColor = _hsl(45, 100, 85);

    final horizontalPadding = shortestSide * 0.10;
    final messageFontSize = shortestSide * 0.035;
    final percentFontSize = shortestSide * 0.03;
    final progressBarWidth = min(size.width * 0.55, 260.0);
    final progressBarHeight = max(4.0, shortestSide * 0.010);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
        animation: _starsController,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GalaxyOrbitPainter(
                    stars: _stars,
                    color: starColor,
                    timeSeconds: _starStopwatch.elapsedMilliseconds / 1000.0,
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _fadeController,
                      curve: Curves.easeOut,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _message.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: foregroundColor.withValues(alpha: 0.82),
                              fontSize: messageFontSize,
                              letterSpacing: shortestSide * 0.0045,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: shortestSide * 0.05),
                          Container(
                            width: progressBarWidth,
                            height: progressBarHeight,
                            decoration: BoxDecoration(
                              color: mutedColor.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 120),
                                curve: Curves.easeOut,
                                width:
                                    progressBarWidth *
                                    (_progress.clamp(0, 100) / 100),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  gradient: LinearGradient(
                                    colors: [primaryColor, accentColor],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 12,
                                      color: primaryColor.withValues(
                                        alpha: 0.30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: shortestSide * 0.03),
                          Text(
                            '${_progress.round().clamp(0, 100)}%',
                            style: TextStyle(
                              color: mutedForegroundColor,
                              fontSize: percentFontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StarData {
  const _StarData({
    required this.baseX,
    required this.baseY,
    required this.size,
    required this.opacity,
    required this.angularSpeed,
    required this.twinklePhase,
    required this.depth,
  });

  final double baseX;
  final double baseY;
  final double size;
  final double opacity;
  final double angularSpeed;
  final double twinklePhase;
  final double depth;

  factory _StarData.random(Random random) {
    final depth = random.nextDouble();

    return _StarData(
      baseX: random.nextDouble(),
      baseY: random.nextDouble(),
      size: 0.6 + random.nextDouble() * 2.2,
      opacity: 0.25 + random.nextDouble() * 0.55,
      angularSpeed: (random.nextDouble() * 0.18 + 0.04) * (0.5 + depth),
      twinklePhase: random.nextDouble() * pi * 2,
      depth: depth,
    );
  }
}

class _GalaxyOrbitPainter extends CustomPainter {
  const _GalaxyOrbitPainter({
    required this.stars,
    required this.color,
    required this.timeSeconds,
  });

  final List<_StarData> stars;
  final Color color;
  final double timeSeconds;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final star in stars) {
      final startX = star.baseX * size.width;
      final startY = star.baseY * size.height;

      final dx = startX - center.dx;
      final dy = startY - center.dy;

      final distance = sqrt(dx * dx + dy * dy);
      final angle0 = atan2(dy, dx);
      final speed = star.angularSpeed / (1.0 + distance / size.shortestSide);
      final angle = angle0 + timeSeconds * speed;

      final rotatedX = center.dx + cos(angle) * distance;
      final rotatedY = center.dy + sin(angle) * distance;

      final twinkle =
          0.72 + 0.28 * sin((timeSeconds * 2.4) + star.twinklePhase);

      final paint = Paint()
        ..color = color.withValues(
          alpha: (star.opacity * twinkle).clamp(0.0, 1.0),
        );

      canvas.drawCircle(
        Offset(rotatedX, rotatedY),
        star.size * (0.75 + star.depth * 0.65),
        paint,
      );

      if (star.depth > 0.82) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.05 * twinkle);
        canvas.drawCircle(
          Offset(rotatedX, rotatedY),
          star.size * 2.4,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GalaxyOrbitPainter oldDelegate) {
    return oldDelegate.timeSeconds != timeSeconds ||
        oldDelegate.color != color ||
        oldDelegate.stars != stars;
  }
}
