import 'package:flutter/material.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final horizontalPadding = width * 0.07;
    final titleFontSize = width * 0.08;
    final bodyFontSize = width * 0.033;
    final linkFontSize = width * 0.035;
    final buttonFontSize = width * 0.045;
    final spacingLarge = height * 0.037;
    final spacingMedium = height * 0.028;
    final spacingSmall = height * 0.01;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/setup_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.04),
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.22),
                    Colors.black.withValues(alpha: 0.38),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.035),
                    child: _BottomContent(
                      titleFontSize: titleFontSize,
                      bodyFontSize: bodyFontSize,
                      linkFontSize: linkFontSize,
                      buttonFontSize: buttonFontSize,
                      buttonHeight: height * 0.06,
                      spacingLarge: spacingLarge,
                      spacingMedium: spacingMedium,
                      spacingSmall: spacingSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomContent extends StatelessWidget {
  const _BottomContent({
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.linkFontSize,
    required this.buttonFontSize,
    required this.buttonHeight,
    required this.spacingLarge,
    required this.spacingMedium,
    required this.spacingSmall,
  });

  final double titleFontSize;
  final double bodyFontSize;
  final double linkFontSize;
  final double buttonFontSize;
  final double buttonHeight;
  final double spacingLarge;
  final double spacingMedium;
  final double spacingSmall;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Discover your\ndaily luck\nwith Luckora',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize.clamp(24, 38),
            fontWeight: FontWeight.w800,
            height: 1.12,
          ),
        ),
        SizedBox(height: spacingLarge),
        SizedBox(
          width: double.infinity,
          height: buttonHeight.clamp(52, 64),
          child: ElevatedButton(
            onPressed: () {
              // TODO: continue action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F36D8),
              foregroundColor: Colors.white.withValues(alpha: 0.85),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(24),
                ),
                side: const BorderSide(
                  color: Color.fromARGB(255, 16, 21, 158), // 👈 border color
                  width: 1.3, // 👈 border thickness
                ),
              ),
            ),
            child: Text(
              'Continue',
              style: TextStyle(
                fontSize: buttonFontSize.clamp(18, 24),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: spacingMedium),
        Text(
          'By clicking Continue, I agree to',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: bodyFontSize.clamp(11, 14),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: spacingSmall),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 22,
          runSpacing: 8,
          children: [
            GestureDetector(
              onTap: () {
                // TODO: open Terms of Services
              },
              child: Text(
                'Terms of Services',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: linkFontSize.clamp(13, 17),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: open Privacy Policy
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: linkFontSize.clamp(13, 17),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
