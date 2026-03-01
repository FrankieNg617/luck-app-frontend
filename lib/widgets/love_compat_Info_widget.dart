import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../data/love_compat_data.dart';

class LoveCompatInfoWidget extends StatefulWidget {
  const LoveCompatInfoWidget({
    super.key,
    required this.yourSign,
    required this.partnerSign,
  });

  final String yourSign;
  final String partnerSign;

  @override
  State<LoveCompatInfoWidget> createState() => _LoveCompatInfoWidgetState();
}

class _LoveCompatInfoWidgetState extends State<LoveCompatInfoWidget>
    with SingleTickerProviderStateMixin {
  LoveCompatEntry? _entry;

  int _getScore() {
    return (_entry?.score ?? 0);
  }

  String _getDetail() {
    return (_entry?.detail ?? '');
  }

  String _headlineForScore(int score) {
    if (score >= 95) return 'An extraordinary connection';
    if (score >= 85) return 'A powerful match';
    if (score >= 75) return 'A promising bond';
    if (score >= 65) return 'A balanced connection';
    if (score >= 50) return 'A relationship with potential';
    if (score >= 35) return 'A challenging match';
    return 'A relationship that needs effort';
  }

  late final AnimationController _countCtrl;
  late Animation<double> _countAnim;

  int _targetScore = 0;

  void _refreshEntry() {
    _entry = getLoveCompat(widget.yourSign, widget.partnerSign);
    _targetScore = _getScore();
  }

  void _restartCountAnimation() {
    _countAnim = Tween<double>(
      begin: 0,
      end: _targetScore.toDouble(),
    ).animate(
      CurvedAnimation(parent: _countCtrl, curve: Curves.easeOutCubic),
    );

    _countCtrl
      ..stop()
      ..value = 0
      ..forward();
  }

  @override
  void initState() {
    super.initState();

    _refreshEntry();

    _countCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _restartCountAnimation();
  }

  @override
  void didUpdateWidget(covariant LoveCompatInfoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.yourSign != widget.yourSign ||
        oldWidget.partnerSign != widget.partnerSign) {
      _refreshEntry();
      _restartCountAnimation();
    }
  }

  @override
  void dispose() {
    _countCtrl.dispose();
    super.dispose();
  }

  LinearGradient _gradientForScore(int score) {
    if (score >= 85) {
      return const LinearGradient(
        colors: [Color(0xFFFFD27C), Color(0xFFE4547B)],
      );
    }
    if (score >= 60) {
      return const LinearGradient(
        colors: [Color(0xFFBFA9FF), Color(0xFFE4547B)],
      );
    }
    return const LinearGradient(
      colors: [Color(0xFF8FD3FF), Color(0xFFBFA9FF)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    final scale = (math.min(w, h) / 390.0).clamp(0.55, 2.25);

    final cardWidth = (w * 0.95).clamp(280.0, 520.0);

    final pad = (18.0 * scale).clamp(14.0, 26.0);
    final vGapL = (16.0 * scale).clamp(10.0, 18.0);
    final vGapM = (12.0 * scale).clamp(8.0, 14.0);
    final vGapS = (8.0 * scale).clamp(6.0, 12.0);

    final headingSize = (18.0 * scale).clamp(16.0, 24.0);
    final labelSize = (12.0 * scale).clamp(11.0, 14.0);

    final scoreSize = (30.0 * scale).clamp(34.0, 56.0);

    final dividerInset = (2.0 * scale);
    final dividerThickness = (1.0 * scale).clamp(1.0, 1.5);

    final barH = (10.0 * scale).clamp(8.0, 12.0);
    final barRadius = 999.0;

    final targetScore = _targetScore;
    final detail = _getDetail();
    final headline = _headlineForScore(targetScore);

    final gradient = _gradientForScore(targetScore);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: cardWidth),
        child: Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 28, 38, 67),
            borderRadius: BorderRadius.circular(18.0 * scale),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
          child: AnimatedBuilder(
            animation: _countAnim,
            builder: (context, _) {
              final shownScore = _countAnim.value.round().clamp(0, 100);
              final fillFraction = shownScore / 100.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    style: TextStyle(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: vGapM),

                  Text(
                    'Your score',
                    style: TextStyle(
                      fontSize: labelSize,
                      letterSpacing: 2.2,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.60),
                    ),
                  ),
                  SizedBox(height: vGapS),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _GradientScoreText(
                        score: shownScore,
                        scoreSize: scoreSize,
                        scale: scale,
                        gradient: gradient,
                      ),
                      SizedBox(width: (14.0 * scale).clamp(10.0, 18.0)),
                      Expanded(
                        child: _ScoreBar(
                          height: barH,
                          radius: barRadius,
                          fraction: fillFraction,
                          background: Colors.white.withValues(alpha: 0.14),
                          fill: const Color(0xFFE4547B).withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: vGapL),
                  _InsetDivider(inset: dividerInset, thickness: dividerThickness),
                  SizedBox(height: vGapL),

                  Text(
                    'Score Detail',
                    style: TextStyle(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: vGapM),

                  Text(
                    detail,
                    style: TextStyle(
                      fontSize: (15.0 * scale).clamp(12.0, 18.0),
                      height: 1.45,
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GradientScoreText extends StatelessWidget {
  const _GradientScoreText({
    required this.score,
    required this.scoreSize,
    required this.scale,
    required this.gradient,
  });

  final int score;
  final double scoreSize;
  final double scale;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    final percentSize = (scoreSize * 0.58).clamp(14.0, 24.0);

    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$score',
            style: TextStyle(
              fontSize: scoreSize,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          SizedBox(width: (4.0 * scale).clamp(2.0, 6.0)),
          Padding(
            padding: EdgeInsets.only(top: scoreSize * 0.18),
            child: Text(
              '%',
              style: TextStyle(
                fontSize: percentSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.height,
    required this.radius,
    required this.fraction,
    required this.background,
    required this.fill,
  });

  final double height;
  final double radius;
  final double fraction;
  final Color background;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final f = fraction.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(decoration: BoxDecoration(color: background)),
            ),
            FractionallySizedBox(
              widthFactor: f,
              heightFactor: 1.0,
              alignment: Alignment.centerLeft,
              child: DecoratedBox(decoration: BoxDecoration(color: fill)),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsetDivider extends StatelessWidget {
  const _InsetDivider({required this.inset, required this.thickness});

  final double inset;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: inset),
      child: Container(
        height: thickness,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}