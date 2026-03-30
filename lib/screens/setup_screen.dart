import 'package:flutter/material.dart';
import '../widgets/Setup/setup_intro_widgete.dart';
import '../widgets/Setup/setup_gender_widget.dart';
import '../widgets/Setup/setup_birthday_widget.dart';
import '../widgets/Setup/setup_birth_time_widget.dart';
import '../widgets/Setup/setup_birth_place_widget.dart';

enum SetupStep { intro, gender, birthday, birthTime, birthPlace }

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  SetupStep _currentStep = SetupStep.intro;
  String _selectedBirthday = '01 January 2000';
  String _selectedBirthTime = '12:00';
  String _selectedBirthPlace = '';

  void _goToGenderStep() {
    setState(() {
      _currentStep = SetupStep.gender;
    });
  }

  void _goBackFromGender() {
    setState(() {
      _currentStep = SetupStep.intro;
    });
  }

  void _goToBirthdayStep() {
    setState(() {
      _currentStep = SetupStep.birthday;
    });
  }

  void _goBackFromBirthday() {
    setState(() {
      _currentStep = SetupStep.gender;
    });
  }

  void _handleBirthdayChanged({required String value, required bool isValid}) {
    _selectedBirthday = value;
  }

  void _goToBirthTimeStep() {
    setState(() {
      _currentStep = SetupStep.birthTime;
    });
  }

  void _goBackFromBirthTime() {
    setState(() {
      _currentStep = SetupStep.birthday;
    });
  }

  void _goToBirthPlaceStep() {
    setState(() {
      _currentStep = SetupStep.birthPlace;
    });
  }

  void _goBackFromBirthPlace() {
    setState(() {
      _currentStep = SetupStep.birthTime;
    });
  }

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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: switch (_currentStep) {
                SetupStep.intro => Padding(
                  key: const ValueKey('intro'),
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: SetupIntroWidget(
                    titleFontSize: titleFontSize,
                    bodyFontSize: bodyFontSize,
                    linkFontSize: linkFontSize,
                    buttonFontSize: buttonFontSize,
                    buttonHeight: height * 0.055,
                    spacingLarge: spacingLarge,
                    spacingMedium: spacingMedium,
                    spacingSmall: spacingSmall,
                    onContinue: _goToGenderStep,
                  ),
                ),
                SetupStep.gender => SetupGenderWidget(
                  key: const ValueKey('gender'),
                  titleFontSize: titleFontSize,
                  bodyFontSize: bodyFontSize,
                  optionLabelFontSize: width * 0.05,
                  cardHeight: height * 0.105,
                  cardWidth: width * 0.25,
                  sectionSpacing: height * 0.025,
                  onBack: _goBackFromGender,
                  onSelectFemale: _goToBirthdayStep,
                  onSelectMale: _goToBirthdayStep,
                ),
                SetupStep.birthday => SetupBirthdayWidget(
                  key: const ValueKey('birthday'),
                  titleFontSize: titleFontSize,
                  bodyFontSize: bodyFontSize,
                  buttonFontSize: buttonFontSize,
                  buttonHeight: height * 0.06,
                  initialValue: _selectedBirthday,
                  onBack: _goBackFromBirthday,
                  onBirthdayChanged: _handleBirthdayChanged,
                  onContinue: _goToBirthTimeStep,
                ),
                SetupStep.birthTime => SetupBirthTimeWidget(
                  key: const ValueKey('birthTime'),
                  titleFontSize: titleFontSize,
                  bodyFontSize: bodyFontSize,
                  buttonFontSize: buttonFontSize,
                  buttonHeight: height * 0.06,
                  initialValue: _selectedBirthTime,
                  onBack: _goBackFromBirthTime,
                  onTimeChanged:
                      ({required String value, required bool isValid}) {
                        _selectedBirthTime = value;
                      },
                  onNotSure: () {
                    setState(() {
                      _selectedBirthTime = '12:00';
                    });
                    _goToBirthPlaceStep();
                  },
                  onContinue: _goToBirthPlaceStep,
                ),
                SetupStep.birthPlace => SetupBirthPlaceWidget(
                  key: const ValueKey('birthPlace'),
                  titleFontSize: titleFontSize,
                  bodyFontSize: bodyFontSize,
                  buttonFontSize: buttonFontSize,
                  buttonHeight: height * 0.06,
                  initialValue: _selectedBirthPlace,
                  onBack: _goBackFromBirthPlace,
                  onPlaceChanged:
                      ({required String value, required bool isValid}) {
                        _selectedBirthPlace = value;
                      },
                  onContinue: () => {},
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
