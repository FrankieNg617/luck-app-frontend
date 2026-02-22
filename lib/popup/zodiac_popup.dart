import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class ZodiacPopup extends StatelessWidget {
  const ZodiacPopup({super.key, required this.title, required this.body});

  final String title;
  final String body;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent, // important for blur
      transitionDuration: const Duration(milliseconds: 520),
      pageBuilder: (_, __, ___) {
        return ZodiacPopup(title: title, body: body);
      },
      transitionBuilder: (context, anim, _, child) {
        final isClosing = anim.status == AnimationStatus.reverse;

        final curved = CurvedAnimation(
          parent: anim,
          curve: const _SpringyCurve(),
          reverseCurve: Curves.easeOutCubic,
        );

        final fade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));

        // ----- Open scale -----
        final openScale = Tween<double>(
          begin: 0.86,
          end: 1.0,
        ).animate(curved).value;

        // ----- Close bounce -----
        final t = anim.value;
        double closeScale;

        if (t > 0.85) {
          final u = (1.0 - t) / 0.15;
          closeScale = 1.0 + 0.06 * u;
        } else {
          final u = (t / 0.85).clamp(0.0, 1.0);
          closeScale = 0.78 + (1.03 - 0.78) * math.pow(u, 1.6);
        }

        final popupScale = isClosing ? closeScale : openScale;

        return Stack(
          children: [
            // ===== Blur =====
            Positioned.fill(
              child: isClosing
                  ? const SizedBox.shrink() // blur gone immediately when closing starts
                  : GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: const ColoredBox(
                          color: Color(0x59000000), // ~35% black
                        ),
                      ),
                    ),
            ),

            // ===== Animated Popup Only =====
            FadeTransition(
              opacity: fade,
              child: Center(
                child: Transform.scale(scale: popupScale, child: child),
              ),
            ),
          ],
        );
      },
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
    final bodySize = (24.0 * scale).clamp(12.5, 18.0);
    final iconSize = (20.0 * scale).clamp(18.0, 26.0);

    final maxHeight = h * 0.60;

    return Dialog(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      insetPadding: EdgeInsets.symmetric(
        horizontal: (18.0 * scale).clamp(12.0, 28.0),
        vertical: (20.0 * scale).clamp(14.0, 32.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogWidth,
              maxHeight: maxHeight, // important
            ),
            child: Container(
              padding: EdgeInsets.all(pad),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  0,
                  0,
                  0,
                ).withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(18.0 * scale),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                  width: 1,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ===== Title Row with X =====
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title expands fully
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.75,
                            ),
                          ),
                        ),

                        SizedBox(width: (8.0 * scale).clamp(6.0, 12.0)),

                        // Close button
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: EdgeInsets.all(
                              (4.0 * scale).clamp(2.0, 8.0),
                            ),
                            child: Icon(
                              Icons.close,
                              size: iconSize,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: (12.0 * scale).clamp(8.0, 18.0)),

                    // ===== Body Text =====
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
            ),
          );
        },
      ),
    );
  }
}

class _SpringyCurve extends Curve {
  const _SpringyCurve();

  @override
  double transform(double t) {
    // A small "overshoot" curve that feels springy.
    // Values tuned to look iOS-like without being too bouncy.
    const double s = 1.35;
    t -= 1.0;
    return t * t * ((s + 1) * t + s) + 1.0;
  }
}
