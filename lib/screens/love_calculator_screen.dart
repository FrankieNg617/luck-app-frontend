import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../background/love_calculator_background.dart';
import '../widgets/zodiac_selector.dart';
import '../background/zodiac_info_background.dart';
import '../widgets/love_compat_info_widget.dart';

class LoveCalculatorScreen extends StatefulWidget {
  const LoveCalculatorScreen({super.key});

  @override
  State<LoveCalculatorScreen> createState() => _LoveCalculatorScreenState();
}

class _LoveCalculatorScreenState extends State<LoveCalculatorScreen>
    with TickerProviderStateMixin {
  String? _yourSign;
  String? _partnerSign;

  late final AnimationController _heartCtrl;
  late final AnimationController _ctaBounceCtrl;
  late final Animation<double> _ctaScale;

  static const List<ZodiacSign> _zodiacSigns = [
    ZodiacSign(name: "Aries", symbol: "♈", dates: "Mar 21 - Apr 20"),
    ZodiacSign(name: "Taurus", symbol: "♉", dates: "Apr 21 - May 19"),
    ZodiacSign(name: "Gemini", symbol: "♊", dates: "May 20 - Jun 21"),
    ZodiacSign(name: "Cancer", symbol: "♋", dates: "Jun 22 - Jul 22"),
    ZodiacSign(name: "Leo", symbol: "♌", dates: "Jul 23 - Aug 22"),
    ZodiacSign(name: "Virgo", symbol: "♍", dates: "Aug 23 - Sep 22"),
    ZodiacSign(name: "Libra", symbol: "♎", dates: "Sep 23 - Oct 22"),
    ZodiacSign(name: "Scorpio", symbol: "♏", dates: "Oct 23 - Nov 21"),
    ZodiacSign(name: "Sagittarius", symbol: "♐", dates: "Nov 22 - Dec 21"),
    ZodiacSign(name: "Capricorn", symbol: "♑", dates: "Dec 22 - Jan 19"),
    ZodiacSign(name: "Aquarius", symbol: "♒", dates: "Jan 20 - Feb 18"),
    ZodiacSign(name: "Pisces", symbol: "♓", dates: "Feb 19 - Mar 20"),
  ];

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.92,
      upperBound: 1.08,
    )..repeat(reverse: true);

    _ctaBounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _ctaScale = Tween<double>(
      begin: 1.0,
      end: 1.035,
    ).animate(CurvedAnimation(parent: _ctaBounceCtrl, curve: Curves.easeInOut));

    _syncCtaBounce();
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    _ctaBounceCtrl.dispose();
    super.dispose();
  }

  bool get _canProceed =>
      (_yourSign != null && _yourSign!.isNotEmpty) &&
      (_partnerSign != null && _partnerSign!.isNotEmpty);

  void _handleCheckCompatibility() {
    if (!_canProceed) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoveCompatInfoPage(
          yourSign: _yourSign!,
          partnerSign: _partnerSign!,
        ),
      ),
    );
  }

  void _syncCtaBounce() {
    if (_canProceed) {
      if (!_ctaBounceCtrl.isAnimating) {
        _ctaBounceCtrl.repeat(reverse: true);
      }
    } else {
      if (_ctaBounceCtrl.isAnimating) {
        _ctaBounceCtrl.stop();
        _ctaBounceCtrl.value = 0.0; // reset to scale=1.0
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LoveCalculatorBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            final s = (w / 390.0).clamp(0.85, 1.20);

            double clamp(double v, double min, double max) =>
                v.clamp(min, max).toDouble();

            final padH = clamp(24.0 * s, 18, 32);
            final padV = clamp(28.0 * s, 18, 36);

            final labelTracking = clamp(4.8 * s, 3.5, 6.0);
            final titleSize = clamp(36.0 * s, 30, 44);
            final subtitleSize = clamp(14.0 * s, 12, 15);

            final gapLg = clamp(25.0 * s, 16, 38);
            final gapMd = clamp(18.0 * s, 14, 22);
            final gapSm = clamp(10.0 * s, 8, 14);

            final heartSize = clamp(15.0 * s, 10, 30);
            final buttonH = clamp(56.0 * s, 50, 60);

            // On very short screens, ensure scrolling rather than overflow
            final useScroll = h < 720;

            final content = Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: padH,
                    vertical: padV,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header
                      Column(
                        children: [
                          Text(
                            'Cosmic Connection'.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              letterSpacing: labelTracking,
                              fontWeight: FontWeight.w600,
                              fontSize: clamp(12.0 * s, 10, 13),
                              color: const Color(
                                0xFFF2D27C,
                              ).withValues(alpha: 0.90),
                            ),
                          ),
                          SizedBox(height: gapSm),
                          Text(
                            'Love\nCompatibility',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.05,
                              fontWeight: FontWeight.w800,
                              fontSize: titleSize,
                              color: Colors.white.withValues(alpha: 0.94),
                            ),
                          ),
                          SizedBox(height: gapSm),
                          Text(
                            'Discover how the stars align for you two',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subtitleSize,
                              color: Colors.white.withValues(alpha: 0.60),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: gapLg),

                      // Heart divider
                      ScaleTransition(
                        scale: _heartCtrl,
                        child: Text(
                          '♥',
                          style: TextStyle(
                            fontSize: heartSize,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFE4547B),
                          ),
                        ),
                      ),

                      SizedBox(height: gapLg),

                      // Selection area
                      ZodiacSelector(
                        label: 'Your Sign',
                        value: _yourSign,
                        onChanged: (v) {
                          setState(() => _yourSign = v);
                          _syncCtaBounce();
                        },
                        signs: _zodiacSigns,
                        placeholder: 'Choose your zodiac',
                        maxVisibleItems: 5,
                        expandDirection: DropdownExpandDirection.down,
                      ),

                      SizedBox(height: gapMd),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.32),
                            ),
                          ),
                          SizedBox(width: clamp(12.0 * s, 10, 16)),
                          Text(
                            '&',
                            style: TextStyle(
                              letterSpacing: clamp(3.0 * s, 2.2, 3.5),
                              fontWeight: FontWeight.w700,
                              fontSize: clamp(13.0 * s, 10, 20),
                              color: const Color(
                                0xFFF2D27C,
                              ).withValues(alpha: 0.90),
                            ),
                          ),
                          SizedBox(width: clamp(12.0 * s, 10, 16)),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.32),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: gapMd),

                      ZodiacSelector(
                        label: "Partner's Sign",
                        value: _partnerSign,
                        onChanged: (v) {
                          setState(() => _partnerSign = v);
                          _syncCtaBounce();
                        },
                        signs: _zodiacSigns,
                        placeholder: 'Choose their zodiac',
                        maxVisibleItems: 5,
                        expandDirection: DropdownExpandDirection.up,
                      ),

                      SizedBox(height: clamp(25.0 * s, 16, 38)),

                      // CTA Button
                      ScaleTransition(
                        scale: _ctaScale,
                        child: SizedBox(
                          width: double.infinity,
                          height: buttonH,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 180),
                            opacity: _canProceed ? 1.0 : 0.65,
                            child: ElevatedButton(
                              onPressed: _canProceed
                                  ? _handleCheckCompatibility
                                  : null,
                              style:
                                  ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: _canProceed
                                        ? const Color(0xFFE4547B)
                                        : Colors.white.withValues(alpha: 0.10),
                                    foregroundColor: _canProceed
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.55),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        clamp(18.0 * s, 14, 20),
                                      ),
                                    ),
                                  ).copyWith(
                                    shadowColor: WidgetStatePropertyAll(
                                      const Color(
                                        0xFFE4547B,
                                      ).withValues(alpha: 0.35),
                                    ),
                                  ),
                              child: Text(
                                'Check Compatibility ✨',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: clamp(16.0 * s, 14, 18),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            return SafeArea(
              child: useScroll
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: h),
                        child: content,
                      ),
                    )
                  : content,
            );
          },
        ),
      ),
    );
  }
}

class LoveCompatInfoPage extends StatelessWidget {
  const LoveCompatInfoPage({
    super.key,
    required this.yourSign,
    required this.partnerSign,
  });

  final String yourSign;
  final String partnerSign;

  String _signAssetPath(String sign) {
    final file = sign.trim().toLowerCase().replaceAll(' ', '_');
    return 'assets/zodiac_signs/$file.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Love Report',
          style: const TextStyle(color: Colors.white70),
        ),
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
              final between = (32.0 * scale).clamp(15.0, 40.0);

              final signImageSize = (math.min(w, h) * 0.42 * scale).clamp(
                56.0,
                250.0,
              );
              final plusSize = (25.0 * scale).clamp(14.0, 32.0);
              final plusGap = (9.0 * scale).clamp(1.0, 18.0);

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
                        //left: (18.0 * scale).clamp(14.0, 26.0),
                        //right: (18.0 * scale).clamp(14.0, 26.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ===== Two Sign Image Row =====
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ===== Images Row =====
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Your Sign
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        _signAssetPath(yourSign),
                                        width: signImageSize,
                                        height: signImageSize,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        height: (8.0 * scale).clamp(6.0, 12.0),
                                      ),
                                      Text(
                                        'You',
                                        style: TextStyle(
                                          fontSize: (16.0 * scale).clamp(
                                            12.0,
                                            18.0,
                                          ),
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(width: plusGap),

                                  // +
                                  Text(
                                    '+',
                                    style: TextStyle(
                                      fontSize: plusSize,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(
                                        alpha: 0.45,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: plusGap),

                                  // Partner Sign
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        _signAssetPath(partnerSign),
                                        width: signImageSize,
                                        height: signImageSize,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        height: (8.0 * scale).clamp(6.0, 12.0),
                                      ),
                                      Text(
                                        'Your Partner',
                                        style: TextStyle(
                                          fontSize: (16.0 * scale).clamp(
                                            12.0,
                                            18.0,
                                          ),
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: between),

                          // ===== Info Card (grows downward) =====
                          LoveCompatInfoWidget(
                            yourSign: yourSign,
                            partnerSign: partnerSign,
                          ),
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
