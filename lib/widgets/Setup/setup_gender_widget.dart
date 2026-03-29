import 'package:flutter/material.dart';

class SetupGenderWidget extends StatelessWidget {
  const SetupGenderWidget({
    super.key,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.optionLabelFontSize,
    required this.cardHeight,
    required this.cardWidth,
    required this.sectionSpacing,
    required this.onBack,
    required this.onSelectFemale,
    required this.onSelectMale,
  });

  final double titleFontSize;
  final double bodyFontSize;
  final double optionLabelFontSize;
  final double cardHeight;
  final double cardWidth;
  final double sectionSpacing;
  final VoidCallback onBack;
  final VoidCallback onSelectFemale;
  final VoidCallback onSelectMale;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Stack(
      children: [
        Positioned(
          top: height * 0.002,
          left: width * 0.008,
          child: IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: (width * 0.095).clamp(28, 38),
            ),
            padding: EdgeInsets.zero,
            splashRadius: (width * 0.06).clamp(20, 28),
            constraints: const BoxConstraints(),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: const Alignment(0, 0.52),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'I am',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize.clamp(28, 42),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: sectionSpacing * 0.10),
                  Text(
                    'Select your gender identity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: bodyFontSize.clamp(13, 18),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: sectionSpacing * 1.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _GenderOptionCard(
                        label: 'Female',
                        symbol: '♀',
                        width: cardWidth.clamp(120, 180),
                        height: cardHeight.clamp(110, 150),
                        onTap: onSelectFemale,
                        iconFontSize: optionLabelFontSize.clamp(34, 48),
                        labelFontSize: bodyFontSize.clamp(15, 20),
                      ),
                      SizedBox(width: width * 0.04),
                      _GenderOptionCard(
                        label: 'Male',
                        symbol: '♂',
                        width: cardWidth.clamp(120, 180),
                        height: cardHeight.clamp(110, 150),
                        onTap: onSelectMale,
                        iconFontSize: optionLabelFontSize.clamp(34, 48),
                        labelFontSize: bodyFontSize.clamp(15, 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderOptionCard extends StatelessWidget {
  const _GenderOptionCard({
    required this.label,
    required this.symbol,
    required this.width,
    required this.height,
    required this.onTap,
    required this.iconFontSize,
    required this.labelFontSize,
  });

  final String label;
  final String symbol;
  final double width;
  final double height;
  final VoidCallback onTap;
  final double iconFontSize;
  final double labelFontSize;

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              symbol,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: iconFontSize,
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
          ),
          SizedBox(height: widthScreen * 0.03),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: labelFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}