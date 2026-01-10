import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ui/fortune_style.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: FortuneTheme.gradientGold,
                  shape: BoxShape.circle,
                  boxShadow: FortuneTheme.shadowGoldGlow,
                ),
                child: const Icon(Icons.wb_sunny, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Luck',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: FortuneTheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 14, color: FortuneTheme.mutedForeground),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 12, color: FortuneTheme.mutedForeground),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
