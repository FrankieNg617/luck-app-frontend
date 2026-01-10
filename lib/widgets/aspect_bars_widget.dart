import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class AspectBarsWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final aspects = <_Aspect>[
      _Aspect("Career", career, FortuneTheme.gold, Icons.work_outline),
      _Aspect("Study", study, FortuneTheme.sage, Icons.menu_book_outlined),
      _Aspect("Love", love, FortuneTheme.coral, Icons.favorite_border),
      _Aspect("Social", social, FortuneTheme.amber, Icons.people_outline),
      _Aspect("Fortune", fortune, FortuneTheme.goldDark, Icons.paid_outlined),
    ];

    // No card / no outline
    return SizedBox(
      height: 144,
      child: Row(
        children: List.generate(aspects.length, (i) {
          final a = aspects[i];
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _AspectBarItem(aspect: a),
            ),
          );
        }),
      ),
    );
  }
}

class _Aspect {
  final String name;
  final int score;
  final Color color;
  final IconData icon;
  _Aspect(this.name, this.score, this.color, this.icon);
}

class _AspectBarItem extends StatelessWidget {
  final _Aspect aspect;
  const _AspectBarItem({required this.aspect});

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
              final barMax = (available - scoreLabelH - gap).clamp(0.0, double.infinity);
              final barHeight = (score / 100.0) * barMax;

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
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: FortuneTheme.foreground,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: gap),
                  Container(
                    width: 32,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: aspect.color.withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // icon
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: aspect.color.withOpacity(0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(
            aspect.icon,
            size: 16,
            color: FortuneTheme.foreground.withOpacity(0.7),
          ),
        ),

        const SizedBox(height: 6),

        // label (no wrap)
        SizedBox(
          height: 14, // fixed so it can't push layout taller
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              aspect.name,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: FortuneTheme.mutedForeground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
