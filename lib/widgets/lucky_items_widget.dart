import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class LuckyItemsWidget extends StatefulWidget {
  final String food;
  final List<int> numbers;
  final String colour;
  final String time;

  const LuckyItemsWidget({
    super.key,
    required this.food,
    required this.numbers,
    required this.colour,
    required this.time,
  });

  @override
  State<LuckyItemsWidget> createState() => _LuckyItemsWidgetState();
}

class _LuckyItemsWidgetState extends State<LuckyItemsWidget>
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

    _controller.forward(from: 0.0); // play once per widget creation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, _) {
        final t = _curve.value; // 0..1

        return Transform.translate(
          offset: Offset(0, (1 - t) * 35), // slide up
          child: Opacity(
            opacity: t, // fade in
            child: Container(
              decoration: FortuneTheme.cardDecoration(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Lucky",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Flexible layout: items can grow vertically if text is long
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final half = (constraints.maxWidth - 12) / 2; // 12 = spacing
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: half,
                            child: _LuckyTile(
                              icon: Icons.restaurant,
                              label: 'Food',
                              value: widget.food,
                            ),
                          ),
                          SizedBox(
                            width: half,
                            child: _LuckyTile(
                              icon: Icons.tag,
                              label: 'Numbers',
                              value: widget.numbers.join(', '),
                            ),
                          ),
                          SizedBox(
                            width: half,
                            child: _LuckyTile(
                              icon: Icons.palette_outlined,
                              label: 'Colour',
                              value: widget.colour,
                            ),
                          ),
                          SizedBox(
                            width: half,
                            child: _LuckyTile(
                              icon: Icons.access_time,
                              label: 'Time',
                              value: widget.time,
                            ),
                          ),
                        ],
                      );
                    },
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

class _LuckyTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _LuckyTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ lets text wrap naturally
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: FortuneTheme.gold.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: FortuneTheme.goldDark),
        ),
        const SizedBox(width: 10),

        // ✅ Flexible text (wraps, no fixed height)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 255, 255, 255),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
