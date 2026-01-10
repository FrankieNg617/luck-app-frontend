import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class LifeAdviceWidget extends StatelessWidget {
  final String advice;
  const LifeAdviceWidget({super.key, required this.advice});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: FortuneTheme.cardDecoration(),
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.format_quote, size: 20, color: FortuneTheme.gold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '"$advice"',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.35,
                color: FortuneTheme.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
