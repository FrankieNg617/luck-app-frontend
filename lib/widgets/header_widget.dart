import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderWidget extends StatefulWidget {
  final String username;
  final String zodiac;

  const HeaderWidget({super.key, required this.username, required this.zodiac});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget>
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

    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    final iconSize = screenWidth * 0.15; // 13% of width
    final titleSize = screenWidth * 0.05;
    final dateSize = screenWidth * 0.032;

    final formattedDate = DateFormat('EEEE, MMM d').format(DateTime.now());

    return AnimatedBuilder(
      animation: _curve,
      builder: (context, _) {
        final t = _curve.value;

        return Transform.translate(
          offset: Offset(0, (1 - t) * -35),
          child: Opacity(
            opacity: t,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      _getZodiacAsset(widget.zodiac),
                      width: iconSize,
                      height: iconSize,
                    ),

                    SizedBox(height: screenWidth * 0.01),

                    Text(
                      "${widget.username} - ${widget.zodiac}",
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenWidth * 0.015),

                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: dateSize,
                        color: const Color.fromARGB(255, 194, 190, 187),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

String _getZodiacAsset(String zodiac) {
  return 'assets/zodiac_symbols/${zodiac.toLowerCase()}.png';
}
