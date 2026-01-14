import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class DosDontsWidget extends StatefulWidget {
  final List<String> dos;
  final List<String> donts;

  const DosDontsWidget({super.key, required this.dos, required this.donts});

  @override
  State<DosDontsWidget> createState() => _DosDontsWidgetState();
}

class _DosDontsWidgetState extends State<DosDontsWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _responsiveIconSize(BuildContext context) {
    // Approx card width: (screen - gap) / 2
    final w = MediaQuery.of(context).size.width;
    final cardW = (w - 12) / 2;

    // Responsive icon size based on card width
    return (cardW * 0.12).clamp(16.0, 26.0);
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = _responsiveIconSize(context);

    return AnimatedBuilder(
      animation: _curve,
      builder: (context, _) {
        final t = _curve.value;

        return Transform.translate(
          offset: Offset(0, (1 - t) * 35),
          child: Opacity(
            opacity: t,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _DoDontCard(
                      title: 'Suggest',
                      iconAsset: 'assets/icons/dos.png',
                      iconSize: iconSize,
                      items: widget.dos,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DoDontCard(
                      title: 'Avoid',
                      iconAsset: 'assets/icons/donts.png',
                      iconSize: iconSize * 1.12,
                      items: widget.donts,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DoDontCard extends StatelessWidget {
  final String title;
  final String iconAsset;
  final double iconSize;
  final List<String> items;

  const _DoDontCard({
    required this.title,
    required this.iconAsset,
    required this.iconSize,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: double.infinity),
      decoration: FortuneTheme.cardDecoration(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                iconAsset,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ...items.map(
            (x) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      x,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 255, 255, 255),
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
