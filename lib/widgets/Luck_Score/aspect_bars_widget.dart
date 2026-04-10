import 'package:flutter/material.dart';
import '../../ui/fortune_style.dart';

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

    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant AspectBarsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hasScoreChanged =
        oldWidget.career != widget.career ||
        oldWidget.study != widget.study ||
        oldWidget.love != widget.love ||
        oldWidget.social != widget.social ||
        oldWidget.fortune != widget.fortune;

    if (hasScoreChanged) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspects = <_Aspect>[
      _Aspect(
        "Career",
        widget.career,
        FortuneTheme.gold,
        Icons.work,
        iconScale: 1.00,
      ),
      _Aspect(
        "Study",
        widget.study,
        FortuneTheme.sage,
        Icons.menu_book,
        iconScale: 1.00,
      ),
      _Aspect(
        "Love",
        widget.love,
        FortuneTheme.coral,
        Icons.favorite,
        iconScale: 1.00,
      ),
      _Aspect(
        "Social",
        widget.social,
        FortuneTheme.amber,
        Icons.people,
        iconScale: 1.00,
      ),
      _Aspect(
        "Fortune",
        widget.fortune,
        FortuneTheme.goldDark,
        Icons.money_rounded,
        iconScale: 1.00,
      ),
    ];

    const double drop = 22;

    return SizedBox(
      height: 144 + drop,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: drop,
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _curve,
              builder: (context, _) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final cellW = constraints.maxWidth / aspects.length;
                    final baseIconSize = (cellW * 0.62).clamp(16.0, 30.0);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(aspects.length, (i) {
                        final a = aspects[i];
                        final iconSize = (baseIconSize * a.iconScale).clamp(
                          14.0,
                          34.0,
                        );

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: _AspectBarItem(
                              aspect: a,
                              anim: _curve.value,
                              iconSize: iconSize,
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
  final IconData icon;
  final double iconScale;

  _Aspect(this.name, this.score, this.color, this.icon, {this.iconScale = 1.0});
}

class _AspectBarItem extends StatelessWidget {
  final _Aspect aspect;
  final double anim;
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
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              final available = c.maxHeight;
              const scoreLabelH = 16.0;
              const gap = 6.0;

              final barMax = (available - scoreLabelH - gap).clamp(
                0.0,
                double.infinity,
              );

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
        Icon(
          aspect.icon,
          size: iconSize,
          color: aspect.color.withValues(alpha: 0.95),
        ),
        const SizedBox(height: 6),
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
