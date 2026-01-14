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
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Flexible layout: items can grow vertically if text is long
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final half = (constraints.maxWidth - 12) / 2; // 12 = spacing
                      
                       // ✅ responsive base size derived from tile width
                      double baseIcon = (half * 0.14).clamp(14.0, 26.0);

                      // Optional per-item tuning relative to base
                      final foodIcon = (baseIcon * 1.20).clamp(14.0, 28.0);
                      final numberIcon = (baseIcon * 1.05).clamp(14.0, 26.0);
                      final colourIcon = (baseIcon * 1.00).clamp(14.0, 26.0);
                      final timeIcon = (baseIcon * 1.10).clamp(14.0, 28.0);
                      
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: half,
                            child: _LuckyTile(
                              iconAsset: 'assets/icons/food2.png',
                              label: 'Food',
                              value: widget.food,
                              iconSize: foodIcon,
                            ),
                          ),
                          SizedBox(
                            width: half,
                            child: _LuckyTile(
                              iconAsset: 'assets/icons/number.png',
                              label: 'Numbers',
                              value: widget.numbers.join(', '),
                              iconSize: numberIcon,
                            ),
                          ),
                          SizedBox(
                            width: half,
                            child: _LuckyTile(
                              iconAsset: 'assets/icons/colour.png',
                              label: 'Colour',
                              value: widget.colour,
                              iconSize: colourIcon,
                            ),
                          ),
                          SizedBox(
                            width: half,
                            child: _LuckyTile(
                              iconAsset: 'assets/icons/time2.png',
                              label: 'Time',
                              value: widget.time,
                              iconSize: timeIcon,
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
  final String iconAsset;
  final String label;
  final String value;
  final double iconSize;

  const _LuckyTile({
    required this.iconAsset,
    required this.label,
    required this.value,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: iconSize, // keeps alignment stable
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              iconAsset,
              width: iconSize,
              height: iconSize,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
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

