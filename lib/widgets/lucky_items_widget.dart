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
            child: LayoutBuilder(
              builder: (context, constraints) {
                const gap = 12.0;

                // This is just to compute responsive icon sizes
                final half = (constraints.maxWidth - gap) / 2;

                // ✅ responsive base size derived from tile width
                final baseIcon = (half * 0.14).clamp(14.0, 26.0);

                // Optional per-item tuning relative to base
                final foodIcon = (baseIcon * 1.20).clamp(14.0, 28.0);
                final numberIcon = (baseIcon * 1.05).clamp(14.0, 26.0);
                final colourIcon = (baseIcon * 1.00).clamp(14.0, 26.0);
                final timeIcon = (baseIcon * 1.10).clamp(14.0, 28.0);

                return Column(
                  children: [
                    // ===== Row 1: Food | Numbers (equal height) =====
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _LuckyBox(
                              iconAsset: 'assets/icons/food2.png',
                              category: 'Food',
                              value: widget.food,
                              iconSize: foodIcon,
                            ),
                          ),
                          const SizedBox(width: gap),
                          Expanded(
                            child: _LuckyBox(
                              iconAsset: 'assets/icons/number.png',
                              category: 'Numbers',
                              value: widget.numbers.join(', '),
                              iconSize: numberIcon,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: gap),

                    // ===== Row 2: Colour | Time (equal height) =====
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _LuckyBox(
                              iconAsset: 'assets/icons/colour.png',
                              category: 'Colour',
                              value: widget.colour,
                              iconSize: colourIcon,
                            ),
                          ),
                          const SizedBox(width: gap),
                          Expanded(
                            child: _LuckyBox(
                              iconAsset: 'assets/icons/time2.png',
                              category: 'Time',
                              value: widget.time,
                              iconSize: timeIcon,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _LuckyBox extends StatelessWidget {
  final String iconAsset;
  final String category;
  final String value;
  final double iconSize;

  const _LuckyBox({
    required this.iconAsset,
    required this.category,
    required this.value,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: FortuneTheme.cardDecoration(), // ✅ each small box transparent
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT: text (value top, category below)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // ✅ centers vertically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 255, 255, 255),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 200, 200, 200),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // RIGHT: icon (vertically centered)
          Center(
            child: Image.asset(
              iconAsset,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
