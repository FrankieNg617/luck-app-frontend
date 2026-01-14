import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class AspectBarsWidget extends StatefulWidget {
  final int career;
  final int study;
  final int love;
  final int social;
  final int fortune;

  const AspectBarsWidget({
    super.key,
    required this.career,
    required this.study,
    required this.love,
    required this.social,
    required this.fortune,
  });

  @override
  State<AspectBarsWidget> createState() => _AspectBarsWidgetState();
}

class _AspectBarsWidgetState extends State<AspectBarsWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);

    // ✅ Plays once whenever this page/widget is created (i.e. navigated to)
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspects = <_Aspect>[
      _Aspect("Career", widget.career, FortuneTheme.gold, 'assets/icons/briefcase.png',
          iconScale: 1.00),
      _Aspect("Study", widget.study, FortuneTheme.sage, 'assets/icons/book.png',
          iconScale: 1.00),
      _Aspect("Love", widget.love, FortuneTheme.coral, 'assets/icons/love.png',
          iconScale: 1.00),
      _Aspect("Social", widget.social, FortuneTheme.amber, 'assets/icons/social2.png',
          iconScale: 1.00),
      _Aspect("Fortune", widget.fortune, FortuneTheme.goldDark,
          'assets/icons/fortune2.png',
          iconScale: 1.00),
    ];

    // How much lower you want the whole group to sit
    const double drop = 22;

    return SizedBox(
      // Increase container height so we can move content down without compressing it
      height: 144 + drop,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: drop, // 👈 pushes everything down visually
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _curve,
              builder: (context, _) {
                // ✅ responsive sizing based on available width
                return LayoutBuilder(
                  builder: (context, constraints) {
                    // Rough per-cell width (Expanded will share width evenly)
                    final cellW = constraints.maxWidth / aspects.length;

                    // Base size: 22% of cell width, clamped for safety
                    final baseIconSize = (cellW * 0.62).clamp(16.0, 30.0);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(aspects.length, (i) {
                        final a = aspects[i];
                        final iconSize =
                            (baseIconSize * a.iconScale).clamp(14.0, 34.0);

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: _AspectBarItem(
                              aspect: a,
                              anim: _curve.value, // ✅ 0..1
                              iconSize: iconSize, // ✅ responsive
                            ),
                          ),
                        );
                      }),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Aspect {
  final String name;
  final int score;
  final Color color;
  final String iconAsset;

  /// Optional multiplier so each aspect can be slightly different.
  final double iconScale;

  _Aspect(
    this.name,
    this.score,
    this.color,
    this.iconAsset, {
    this.iconScale = 1.0,
  });
}

class _AspectBarItem extends StatelessWidget {
  final _Aspect aspect;

  /// 0..1 animation progress for bar growth
  final double anim;

  /// responsive icon size
  final double iconSize;

  const _AspectBarItem({
    required this.aspect,
    required this.anim,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final score = aspect.score.clamp(0, 100);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        // ✅ Flexible top area: consumes remaining height safely
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              // available height for score + bar
              final available = c.maxHeight;

              // reserve a tiny space for the score label
              const scoreLabelH = 16.0;
              const gap = 6.0;

              // bar gets the rest
              final barMax =
                  (available - scoreLabelH - gap).clamp(0.0, double.infinity);

              // ✅ Animate from 0 -> (score/100)*barMax
              final targetFactor = score / 100.0;
              final barHeight = barMax * targetFactor * anim;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: scoreLabelH,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$score',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: gap),
                  Container(
                    width: 32,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: aspect.color.withValues(alpha: 0.90),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // ✅ responsive icon (no background circle)
        Image.asset(
          aspect.iconAsset,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 6),

        // label (no wrap)
        SizedBox(
          height: 14,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              aspect.name,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 206, 203, 203),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
