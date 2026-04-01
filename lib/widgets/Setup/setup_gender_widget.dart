import 'dart:async';

import 'package:flutter/material.dart';

enum _SelectedGender { female, male }

class SetupGenderWidget extends StatefulWidget {
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
    required this.initialValue,
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
  final String initialValue;

  @override
  State<SetupGenderWidget> createState() => _SetupGenderWidgetState();
}

class _SetupGenderWidgetState extends State<SetupGenderWidget> {
  static const Duration _selectionAnimDuration = Duration(milliseconds: 350);

  _SelectedGender? _selectedGender;
  Timer? _navigateTimer;
  int _selectionVersion = 0;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue == 'female') {
      _selectedGender = _SelectedGender.female;
    } else if (widget.initialValue == 'male') {
      _selectedGender = _SelectedGender.male;
    }
  }

  void _handleSelect(_SelectedGender gender) {
    _navigateTimer?.cancel();
    final int version = ++_selectionVersion;

    setState(() {
      _selectedGender = gender;
    });

    _navigateTimer = Timer(_selectionAnimDuration, () {
      if (!mounted) return;
      if (version != _selectionVersion) return;
      if (_selectedGender != gender) return;

      switch (gender) {
        case _SelectedGender.female:
          widget.onSelectFemale();
          break;
        case _SelectedGender.male:
          widget.onSelectMale();
          break;
      }
    });
  }

  @override
  void dispose() {
    _navigateTimer?.cancel();
    super.dispose();
  }

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
            onPressed: widget.onBack,
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
                      fontSize: widget.titleFontSize.clamp(28, 42),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: widget.sectionSpacing * 0.10),
                  Text(
                    'Select your gender identity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: widget.bodyFontSize.clamp(13, 18),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: widget.sectionSpacing * 1.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _GenderOptionCard(
                        label: 'Female',
                        symbol: '♀',
                        width: widget.cardWidth.clamp(120, 180),
                        height: widget.cardHeight.clamp(110, 150),
                        onTap: () => _handleSelect(_SelectedGender.female),
                        iconFontSize: widget.optionLabelFontSize.clamp(34, 48),
                        labelFontSize: widget.bodyFontSize.clamp(15, 20),
                        isSelected: _selectedGender == _SelectedGender.female,
                        animationDuration: _selectionAnimDuration,
                      ),
                      SizedBox(width: width * 0.04),
                      _GenderOptionCard(
                        label: 'Male',
                        symbol: '♂',
                        width: widget.cardWidth.clamp(120, 180),
                        height: widget.cardHeight.clamp(110, 150),
                        onTap: () => _handleSelect(_SelectedGender.male),
                        iconFontSize: widget.optionLabelFontSize.clamp(34, 48),
                        labelFontSize: widget.bodyFontSize.clamp(15, 20),
                        isSelected: _selectedGender == _SelectedGender.male,
                        animationDuration: _selectionAnimDuration,
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
    required this.isSelected,
    required this.animationDuration,
  });

  final String label;
  final String symbol;
  final double width;
  final double height;
  final VoidCallback onTap;
  final double iconFontSize;
  final double labelFontSize;
  final bool isSelected;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          AnimatedContainer(
            duration: animationDuration,
            curve: Curves.easeOutCubic,
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2F36D8)
                  : Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
              border: isSelected
                  ? null 
                  : Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        blurRadius: 22,
                        spreadRadius: 1,
                        color: const Color(0xFF2F36D8).withValues(alpha: 0.32),
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: AnimatedDefaultTextStyle(
              duration: animationDuration,
              curve: Curves.easeInOut,
              style: TextStyle(
                color: Colors.white.withValues(alpha: isSelected ? 1 : 0.92),
                fontSize: iconFontSize,
                fontWeight: FontWeight.w400,
                height: 1,
              ),
              child: Text(symbol),
            ),
          ),
          SizedBox(height: widthScreen * 0.03),
          AnimatedDefaultTextStyle(
            duration: animationDuration,
            curve: Curves.easeInOut,
            style: TextStyle(
              color: Colors.white.withValues(alpha: isSelected ? 1 : 0.92),
              fontSize: labelFontSize,
              fontWeight: FontWeight.w700,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
