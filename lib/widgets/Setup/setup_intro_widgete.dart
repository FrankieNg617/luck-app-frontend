import 'package:flutter/material.dart';

class SetupIntroWidget extends StatelessWidget {
  const SetupIntroWidget({
    super.key,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.linkFontSize,
    required this.buttonFontSize,
    required this.buttonHeight,
    required this.spacingLarge,
    required this.spacingMedium,
    required this.spacingSmall,
    required this.onContinue,
  });

  final double titleFontSize;
  final double bodyFontSize;
  final double linkFontSize;
  final double buttonFontSize;
  final double buttonHeight;
  final double spacingLarge;
  final double spacingMedium;
  final double spacingSmall;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      children: [
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.035,
          ),
          child: Column(
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
                  onPressed: onContinue,
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
                        color: Color.fromARGB(255, 16, 21, 158),
                        width: 1.3,
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
                    onTap: () {},
                    child: Text(
                      'Terms of Service',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: linkFontSize.clamp(13, 17),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
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
          ),
        ),
      ],
    );
  }
}