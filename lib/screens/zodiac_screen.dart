import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../background/zodiac_info_background.dart';
import '../background/zodiac_background.dart';
import '../widgets/zodiac_info_widget.dart';

class ZodiacScreen extends StatelessWidget {
  const ZodiacScreen({super.key});

  static const _signs = <String>[
    'Pisces',
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
  ];

  // IMPORTANT:
  // This is the rotation that aligns slice 0 (Aries) with your image.
  // Tweak this until taps match the correct segment.
  //
  // Angle convention here:
  // - 0° is to the RIGHT (3 o'clock)
  // - 90° is UP (12 o'clock)
  // - increases counter-clockwise
  static const double _ariesStartOffsetDeg = 60; // <-- adjust this

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ZodiacBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            // Responsive scale (390 is a common design baseline width)
            final scale = (math.min(w, h) / 390.0).clamp(0.85, 1.25);

            // Chart size
            final chartSize = math.min(w, h);

            // Responsive spacing + typography
            final gapAfterChart = 24.0 * scale;
            final gapAfterTitle = 12.0 * scale;

            final titleSize = 26.0 * scale;
            final bodySize = 15.0 * scale;

            final horizontalPadding = (32.0 * scale).clamp(18.0, 48.0);

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ================= CHART =================
                    SizedBox(
                      width: chartSize,
                      height: chartSize,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _TappableZodiacChart(
                          imageProvider: const AssetImage(
                            'assets/zodiac_chart/zodiac_chart2.png',
                          ),
                          onSignTap: (sign) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ZodiacInfoPage(sign: sign),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: gapAfterChart),

                    // ================= TITLE =================
                    Text(
                      'Zodiac Chart',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 1.2 * scale,
                        height: 1.1,
                      ),
                    ),

                    SizedBox(height: gapAfterTitle),

                    // ================= DESCRIPTION =================
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Text(
                        "Zodiac chart is a diagram based on 12 zodiac signs. "
                        "How sun, moon, and planets were located when you were born "
                        "provides insights into your character and life's potential. "
                        "Tap your zodiac to explore more.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: bodySize,
                          height: 1.6,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TappableZodiacChart extends StatelessWidget {
  const _TappableZodiacChart({
    required this.imageProvider,
    required this.onSignTap,
  });

  final ImageProvider imageProvider;
  final void Function(String sign) onSignTap;

  static const _signs = ZodiacScreen._signs;
  static const double _offset = ZodiacScreen._ariesStartOffsetDeg;

  int? _hitTestSignIndex(Offset localPos, Size widgetSize) {
    final center = Offset(widgetSize.width / 2, widgetSize.height / 2);
    final v = localPos - center;

    final r = v.distance;
    final outerR = widgetSize.width / 2;

    // Optional: ignore taps too close to the center (moon area)
    final innerDeadZone = outerR * 0.18;
    if (r < innerDeadZone || r > outerR) return null;

    // atan2 gives radians, where 0 rad is +x (to the right), CCW positive
    var deg = math.atan2(-v.dy, v.dx) * 180 / math.pi;
    // Convert to 0..360 where 0 is to the right, 90 is up
    if (deg < 0) deg += 360;

    // Apply your chart alignment offset so Aries slice matches the image
    final aligned = (deg - _offset) % 360;

    final index = (aligned / 30).floor(); // 12 slices, 360/12 = 30°
    if (index < 0 || index > 11) return null;
    return index;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;

        final local = box.globalToLocal(details.globalPosition);
        final idx = _hitTestSignIndex(local, box.size);
        if (idx == null) return;

        onSignTap(_signs[idx]);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: imageProvider, fit: BoxFit.cover),

          // Optional: show sector boundaries / debugging overlay
          // IgnorePointer(
          //   child: CustomPaint(painter: _DebugWedgesPainter()),
          // ),
        ],
      ),
    );
  }
}

class ZodiacInfoPage extends StatelessWidget {
  const ZodiacInfoPage({super.key, required this.sign});
  final String sign;

  String _signAssetPath(String sign) {
    // Convert "Capricorn" -> "capricorn" etc.
    final file = sign.trim().toLowerCase().replaceAll(' ', '_');
    //return 'assets/zodiac_signs/$file.png';
    return 'assets/zodiac_signs/zodiactest3.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: Text(sign, style: const TextStyle(color: Colors.white70)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white70),
      ),

      body: ZodiacInfoBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;

              final scale = (math.min(w, h) / 390.0).clamp(0.85, 1.25);

              // This controls the "fixed location" from top of screen
              final fixedTopOffset = (h * 0.06).clamp(12.0, 48.0);
              final between = (14.0 * scale).clamp(10.0, 20.0);
              final imageSize = (math.min(w, h) * 0.60 * scale).clamp(
                72.0,
                440.0,
              );
              final signTextSize = (22.0 * scale).clamp(18.0, 30.0);


              return SingleChildScrollView(
                // Scroll only when content is taller than screen
                child: ConstrainedBox(
                  // When content is short, still fill the viewport so the top offset stays stable
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Align(
                    // IMPORTANT: top anchored (not centered)
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: fixedTopOffset,
                        bottom: (24.0 * scale).clamp(16.0, 40.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ===== Sign Image =====
                          Image.asset(
                            _signAssetPath(sign),
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: between),

                          // ===== Sign Text =====
                          Text(
                            sign,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: signTextSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.6 * scale,
                              height: 1.1,
                            ),
                          ),

                          SizedBox(height: (18.0 * scale).clamp(12.0, 26.0)),

                          // ===== Info Card (grows downward) =====
                          ZodiacInfoWidget(sign: sign),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
