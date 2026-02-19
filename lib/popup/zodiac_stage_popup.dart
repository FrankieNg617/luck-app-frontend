import 'dart:math' as math;
import 'package:flutter/material.dart';

class ZodiacStagePopup extends StatelessWidget {
  const ZodiacStagePopup({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ZodiacStagePopup(title: title, body: body),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;
    final scale = (math.min(w, h) / 390.0).clamp(0.85, 1.25);

    final dialogWidth = (w * 0.86).clamp(280.0, 560.0);
    final pad = (18.0 * scale).clamp(14.0, 26.0);

    final titleSize = (18.0 * scale).clamp(16.0, 24.0);
    final bodySize = (14.0 * scale).clamp(12.5, 18.0);
    final iconSize = (20.0 * scale).clamp(18.0, 26.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: (18.0 * scale).clamp(12.0, 28.0),
        vertical: (20.0 * scale).clamp(14.0, 32.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: dialogWidth),
        child: Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 40, 39, 67),
            borderRadius: BorderRadius.circular(18.0 * scale),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // ===== Content =====
              Padding(
                padding: EdgeInsets.only(
                  top: (6.0 * scale).clamp(4.0, 10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: (12.0 * scale).clamp(8.0, 18.0)),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: bodySize,
                        color: Colors.white.withValues(alpha: 0.82),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== Close X Icon =====
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.all((4.0 * scale).clamp(2.0, 8.0)),
                    child: Icon(
                      Icons.close,
                      size: iconSize,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
