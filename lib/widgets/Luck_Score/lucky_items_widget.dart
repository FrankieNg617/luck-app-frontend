import 'package:flutter/material.dart';
import '../../ui/fortune_style.dart';

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
      duration: const Duration(milliseconds: 700),
    );

    _curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant LuckyItemsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hasChanged =
        oldWidget.food != widget.food ||
        oldWidget.colour != widget.colour ||
        oldWidget.time != widget.time ||
        oldWidget.numbers.join(',') != widget.numbers.join(',');

    if (hasChanged) {
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
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, _) {
        final t = _curve.value;

        return Transform.translate(
          offset: Offset(0, (1 - t) * 35),
          child: Opacity(
            opacity: t,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const gap = 12.0;
                final half = (constraints.maxWidth - gap) / 2;

                final baseIcon = (half * 0.14).clamp(14.0, 26.0);

                final foodIcon = (baseIcon * 1.20).clamp(14.0, 28.0);
                final numberIcon = (baseIcon * 1.05).clamp(14.0, 26.0);
                final colourIcon = (baseIcon * 1.00).clamp(14.0, 26.0);
                final timeIcon = (baseIcon * 1.10).clamp(14.0, 28.0);

                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _LuckyBox(
                              icon: Icons.restaurant,
                              iconColor: FortuneTheme.coral,
                              category: 'Food',
                              value: widget.food,
                              iconSize: foodIcon,
                            ),
                          ),
                          const SizedBox(width: gap),
                          Expanded(
                            child: _LuckyBox(
                              icon: Icons.numbers,
                              iconColor: FortuneTheme.gold,
                              category: 'Numbers',
                              value: widget.numbers.join(', '),
                              iconSize: numberIcon,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: gap),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _LuckyBox(
                              icon: Icons.palette,
                              iconColor: FortuneTheme.sage,
                              category: 'Colour',
                              value: widget.colour,
                              iconSize: colourIcon,
                            ),
                          ),
                          const SizedBox(width: gap),
                          Expanded(
                            child: _LuckyBox(
                              icon: Icons.schedule,
                              iconColor: FortuneTheme.amber,
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
  final IconData icon;
  final Color iconColor;
  final String category;
  final String value;
  final double iconSize;

  const _LuckyBox({
    required this.icon,
    required this.iconColor,
    required this.category,
    required this.value,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: FortuneTheme.cardDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
          Center(
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }
}