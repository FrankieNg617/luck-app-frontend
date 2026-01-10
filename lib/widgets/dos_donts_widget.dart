import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class DosDontsWidget extends StatelessWidget {
  final List<String> dos;
  final List<String> donts;

  const DosDontsWidget({super.key, required this.dos, required this.donts});

  @override
  Widget build(BuildContext context) {
    // ✅ IntrinsicHeight forces Row children to share the same height
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ stretch to tallest
        children: [
          Expanded(
            child: _DoDontCard(
              title: 'Suggest',
              icon: Icons.thumb_up_outlined,
              tint: FortuneTheme.sage,
              items: dos,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _DoDontCard(
              title: 'Avoid',
              icon: Icons.thumb_down_outlined,
              tint: FortuneTheme.coral,
              items: donts,
            ),
          ),
        ],
      ),
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
                  color: tint.withOpacity(0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: tint),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: FortuneTheme.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // list
          ...items.map((x) => Padding(
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
                        style: TextStyle(
                          fontSize: 13,
                          color: FortuneTheme.mutedForeground,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
