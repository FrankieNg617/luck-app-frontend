import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class LuckyItemsWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: FortuneTheme.cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Lucky",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: FortuneTheme.foreground,
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
                  SizedBox(width: half, child: _LuckyTile(icon: Icons.restaurant, label: 'Food', value: food)),
                  SizedBox(width: half, child: _LuckyTile(icon: Icons.tag, label: 'Numbers', value: numbers.join(', '))),
                  SizedBox(width: half, child: _LuckyTile(icon: Icons.palette_outlined, label: 'Colour', value: colour)),
                  SizedBox(width: half, child: _LuckyTile(icon: Icons.access_time, label: 'Time', value: time)),
                ],
              );
            },
          ),
        ],
      ),
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
            color: FortuneTheme.gold.withOpacity(0.18),
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
                style: TextStyle(
                  fontSize: 11,
                  color: FortuneTheme.mutedForeground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: FortuneTheme.foreground,
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
