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
      duration: const Duration(milliseconds: 700), // speed
    );

    _curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // ✅ play once per widget creation (home screen directed)
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ IntrinsicHeight forces Row children to share the same height
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, _) {
        final t = _curve.value;

        return Transform.translate(
          offset: Offset(0, (1 - t) * 35), // slide up
          child: Opacity(
            opacity: t, // fade in
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ stretch to tallest
                children: [
                  Expanded(
                    child: _DoDontCard(
                      title: 'Suggest',
                      icon: Icons.thumb_up_outlined,
                      tint: const Color.fromARGB(255, 71, 136, 94),
                      items: widget.dos,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DoDontCard(
                      title: 'Avoid',
                      icon: Icons.thumb_down_outlined,
                      tint: const Color.fromARGB(255, 228, 92, 47),
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
  final IconData icon;
  final Color tint;
  final List<String> items;

  const _DoDontCard({
    required this.title,
    required this.icon,
    required this.tint,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ Make sure the card is willing to fill available height
      constraints: const BoxConstraints(minHeight: double.infinity),
      decoration: FortuneTheme.cardDecoration(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: tint),
              ),
              const SizedBox(width: 8),
              const Text(
                ' ',
                style: TextStyle(fontSize: 0),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // list
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
                    decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
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
