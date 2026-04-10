import 'package:flutter/material.dart';
import '../../ui/fortune_style.dart';

class DosDontsWidget extends StatefulWidget {
  final List<String> dos;
  final List<String> donts;

  const DosDontsWidget({
    super.key,
    required this.dos,
    required this.donts,
  });

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
  void didUpdateWidget(covariant DosDontsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hasChanged =
        oldWidget.dos.join('|') != widget.dos.join('|') ||
        oldWidget.donts.join('|') != widget.donts.join('|');

    if (hasChanged) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _responsiveIconSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardW = (w - 24) / 2;
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
            child: Container(
              decoration: FortuneTheme.cardDecoration(),
              padding: const EdgeInsets.all(14),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _DoDontSection(
                        title: 'Suggest',
                        icon: Icons.check_circle,
                        iconColor: FortuneTheme.sage,
                        iconSize: iconSize,
                        items: widget.dos,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Container(
                        width: 1,
                        height: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: const Color.fromARGB(255, 179, 164, 164)
                              .withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _DoDontSection(
                        title: 'Avoid',
                        icon: Icons.cancel,
                        iconColor: FortuneTheme.coral,
                        iconSize: iconSize,
                        items: widget.donts,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DoDontSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final List<String> items;

  const _DoDontSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Icon(
              icon,
              size: iconSize,
              color: iconColor.withValues(alpha: 0.95),
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
        const SizedBox(height: 12),
        ...items.map(
          (x) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
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
    );
  }
}