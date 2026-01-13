import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class LifeAdviceWidget extends StatefulWidget {
  final String advice;
  const LifeAdviceWidget({super.key, required this.advice});

  @override
  State<LifeAdviceWidget> createState() => _LifeAdviceWidgetState();
}

class _LifeAdviceWidgetState extends State<LifeAdviceWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // 👈 animation speed
    );

    _curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic, // 👈 ease-out feel
    );

    // ✅ play once when widget is created
    _controller.forward(from: 0.0);
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
          offset: Offset(0, (1 - t) * 35), // 👈 slide up from bottom
          child: Opacity(
            opacity: t, // 👈 fade in
            child: Container(
              decoration: FortuneTheme.cardDecoration(),
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.format_quote,
                      size: 20,
                      color: FortuneTheme.gold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '"${widget.advice}"',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
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

