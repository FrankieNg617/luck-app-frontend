import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class ScorePreviewWidget extends StatelessWidget {
  final int overallScore;
  final int career;
  final int study;
  final int love;
  final int social;
  final int fortune;

  /// Clicking the ">" button goes to Luck screen
  final VoidCallback onOpenLuck;

  const ScorePreviewWidget({
    super.key,
    required this.overallScore,
    required this.career,
    required this.study,
    required this.love,
    required this.social,
    required this.fortune,
    required this.onOpenLuck,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: FortuneTheme.cardDecoration(),
      padding: const EdgeInsets.all(14),
      child: Stack(
        children: [
          // top-right ">" button
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onOpenLuck,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LEFT: overall score preview
              SizedBox(
                width: 150,
                child: _OverallScorePreview(score: overallScore),
              ),

              const SizedBox(width: 14),

              // RIGHT: aspects (no icons, no anim)
              Expanded(
                child: _AspectBarsPreview(
                  career: career,
                  study: study,
                  love: love,
                  social: social,
                  fortune: fortune,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ------------------ LEFT: Overall Score (Preview) ------------------ */

class _OverallScorePreview extends StatelessWidget {
  final int score;
  const _OverallScorePreview({required this.score});

  @override
  Widget build(BuildContext context) {
    final s = score.clamp(0, 100);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$s',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Today's Luck",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 231, 231, 231),
          ),
        ),
      ],
    );
  }
}


/* ------------------ RIGHT: Aspect Bars (No Icons, No Anim) ------------------ */

class _AspectBarsPreview extends StatelessWidget {
  final int career;
  final int study;
  final int love;
  final int social;
  final int fortune;

  const _AspectBarsPreview({
    required this.career,
    required this.study,
    required this.love,
    required this.social,
    required this.fortune,
  });

  @override
  Widget build(BuildContext context) {
    final aspects = <_AspectPreview>[
      _AspectPreview("Career", career, FortuneTheme.gold),
      _AspectPreview("Study", study, FortuneTheme.sage),
      _AspectPreview("Love", love, FortuneTheme.coral),
      _AspectPreview("Social", social, FortuneTheme.amber),
      _AspectPreview("Fortune", fortune, FortuneTheme.goldDark),
    ];

    // Keep similar height feel to your Luck screen aspect widget
    return SizedBox(
      height: 144,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(aspects.length, (i) {
          final a = aspects[i];
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _AspectBarItemPreview(aspect: a),
            ),
          );
        }),
      ),
    );
  }
}

class _AspectPreview {
  final String name;
  final int score;
  final Color color;
  _AspectPreview(this.name, this.score, this.color);
}

class _AspectBarItemPreview extends StatelessWidget {
  final _AspectPreview aspect;
  const _AspectBarItemPreview({required this.aspect});

  @override
  Widget build(BuildContext context) {
    final score = aspect.score.clamp(0, 100);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              final available = c.maxHeight;
              const scoreLabelH = 16.0;
              const gap = 6.0;

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
                    width: 28,
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

        SizedBox(
          height: 14,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              aspect.name,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 13,
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
