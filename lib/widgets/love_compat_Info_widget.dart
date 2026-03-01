import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoveCompatInfoWidget extends StatelessWidget {
  const LoveCompatInfoWidget({
    super.key, 
    required this.yourSign,
    required this.partnerSign,
  });

  final String yourSign;
  final String partnerSign;

  @override
   Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    final scale = (math.min(w, h) / 390.0).clamp(0.55, 2.25);

    final cardWidth = (w * 0.95).clamp(280.0, 580.0);
    final pad = (18.0 * scale).clamp(14.0, 26.0);

    final hPad = (16.0 * scale).clamp(12.0, 22.0);
    final vGapL = (16.0 * scale).clamp(10.0, 18.0);
    final vGapM = (12.0 * scale).clamp(8.0, 14.0);

    final headingSize = (18.0 * scale).clamp(16.0, 24.0);

    final dividerInset = (2.0 * scale);
    final dividerThickness = (1.0 * scale).clamp(1.0, 1.5);

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: cardWidth),
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 28, 38, 67),
          borderRadius: BorderRadius.circular(18.0 * scale),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Score Title =====
            Text(
              'Relationship',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.15,
              ),
            ),
            SizedBox(height: vGapM),

            // ===== Score row =====
            

            SizedBox(height: vGapL),
            _InsetDivider(inset: dividerInset, thickness: dividerThickness),
            SizedBox(height: vGapL),

            // ===== Score Detail Title =====
            Text(
              'Score Detail',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.15,
              ),
            ),
            SizedBox(height: vGapM),

            // ===== Score Detail =====
            
          ],
        ),
      ),
    );
  }
}

class _InsetDivider extends StatelessWidget {
  const _InsetDivider({required this.inset, required this.thickness});

  final double inset;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: inset),
      child: Container(
        height: thickness,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}