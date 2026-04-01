import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/Setup/setup_intro_widgete.dart';
import '../widgets/Setup/setup_gender_widget.dart';
import '../widgets/Setup/setup_birthday_widget.dart';
import '../widgets/Setup/setup_birth_time_widget.dart';
import '../widgets/Setup/setup_birth_place_widget.dart';
import '../widgets/Setup/setup_username_widget.dart';

enum SetupStep { intro, gender, birthday, birthTime, birthPlace, username }

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  SetupStep _currentStep = SetupStep.intro;

  String _selectedGender = '';
  String _selectedBirthday = '01 January 2000';
  String _selectedBirthTime = '12:00';
  SetupPlaceSelection? _selectedBirthPlace;
  String _selectedUsername = '';

  bool _isSubmitting = false;

  static const String _baseUrl = 'http://10.0.2.2:3000';
  // emulator -> 10.0.2.2
  // real phone -> change to your computer LAN IP like http://192.168.1.5:3000

  void _goToNextStep() {
    setState(() {
      switch (_currentStep) {
        case SetupStep.intro:
          _currentStep = SetupStep.gender;
          break;
        case SetupStep.gender:
          _currentStep = SetupStep.birthday;
          break;
        case SetupStep.birthday:
          _currentStep = SetupStep.birthTime;
          break;
        case SetupStep.birthTime:
          _currentStep = SetupStep.birthPlace;
          break;
        case SetupStep.birthPlace:
          _currentStep = SetupStep.username;
          break;
        case SetupStep.username:
          break;
      }
    });
  }

  void _goBack() {
    setState(() {
      switch (_currentStep) {
        case SetupStep.intro:
          break;
        case SetupStep.gender:
          _currentStep = SetupStep.intro;
          break;
        case SetupStep.birthday:
          _currentStep = SetupStep.gender;
          break;
        case SetupStep.birthTime:
          _currentStep = SetupStep.birthday;
          break;
        case SetupStep.birthPlace:
          _currentStep = SetupStep.birthTime;
          break;
        case SetupStep.username:
          _currentStep = SetupStep.birthPlace;
          break;
      }
    });
  }

  Future<void> _submitSetup() async {
    if (_isSubmitting) return;
    if (_selectedGender.trim().isEmpty) return;
    if (_selectedUsername.trim().isEmpty) return;
    if (_selectedBirthPlace == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = {
        'username': _selectedUsername.trim(),
        'gender': _selectedGender.trim(),
        'birthDate': _formatBirthdayForBackend(_selectedBirthday),
        'birthTime': _selectedBirthTime,
        'birthPlace': _selectedBirthPlace!.cityName,
        'birthTz': _selectedBirthPlace!.timeZoneId,
        'lat': _selectedBirthPlace!.lat,
        'lon': _selectedBirthPlace!.lon,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(data['message'] ?? 'Failed to create user profile.');
      }

      final userId = (data['userId'] ?? '').toString();
      if (userId.isEmpty) {
        throw Exception('Backend did not return userId.');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      await prefs.setBool('setup_completed', true);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile created successfully')),
      );

      // TODO: replace this with your home screen navigation
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (_) => const HomeScreen()),
      // );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String _formatBirthdayForBackend(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length != 3) {
      throw Exception('Invalid birthday format: $value');
    }

    final day = int.parse(parts[0]);
    final month = _monthNumber(parts[1]);
    final year = int.parse(parts[2]);

    final yyyy = year.toString().padLeft(4, '0');
    final mm = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');

    return '$yyyy-$mm-$dd';
  }

  int _monthNumber(String monthName) {
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    final value = months[monthName];
    if (value == null) {
      throw Exception('Invalid month: $monthName');
    }
    return value;
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
                    onContinue: _goToNextStep,
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
                  onBack: _goBack,
                  initialValue: _selectedGender,
                  onSelectFemale: () {
                    _selectedGender = 'female';
                    _goToNextStep();
                  },
                  onSelectMale: () {
                    _selectedGender = 'male';
                    _goToNextStep();
                  },
                ),
                SetupStep.birthday => SetupBirthdayWidget(
                  key: const ValueKey('birthday'),
                  titleFontSize: titleFontSize,
                  bodyFontSize: bodyFontSize,
                  buttonFontSize: buttonFontSize,
                  buttonHeight: height * 0.06,
                  initialValue: _selectedBirthday,
                  onBack: _goBack,
                  onBirthdayChanged:
                      ({required String value, required bool isValid}) {
                        _selectedBirthday = value;
                      },
                  onContinue: _goToNextStep,
                ),
                SetupStep.birthTime => SetupBirthTimeWidget(
                  key: const ValueKey('birthTime'),
                  titleFontSize: titleFontSize,
                  bodyFontSize: bodyFontSize,
                  buttonFontSize: buttonFontSize,
                  buttonHeight: height * 0.06,
                  initialValue: _selectedBirthTime,
                  onBack: _goBack,
                  onTimeChanged:
                      ({required String value, required bool isValid}) {
                        _selectedBirthTime = value;
                      },
                  onNotSure: () {
                    setState(() {
                      _selectedBirthTime = '12:00';
                    });
                    _goToNextStep();
                  },
                  onContinue: _goToNextStep,
                ),
                SetupStep.birthPlace => SetupBirthPlaceWidget(
                  key: const ValueKey('birthPlace'),
                  titleFontSize: titleFontSize,
                  bodyFontSize: bodyFontSize,
                  buttonFontSize: buttonFontSize,
                  buttonHeight: height * 0.06,
                  initialValue: _selectedBirthPlace,
                  onBack: _goBack,
                  onPlaceChanged:
                      ({
                        required SetupPlaceSelection? place,
                        required bool isValid,
                      }) {
                        _selectedBirthPlace = place;
                      },
                  onContinue: _goToNextStep,
                ),
                SetupStep.username => SetupUsernameWidget(
                  key: const ValueKey('username'),
                  titleFontSize: titleFontSize,
                  bodyFontSize: bodyFontSize,
                  buttonFontSize: buttonFontSize,
                  buttonHeight: height * 0.06,
                  initialValue: _selectedUsername,
                  onBack: _goBack,
                  onNameChanged:
                      ({required String value, required bool isValid}) {
                        _selectedUsername = value;
                      },
                  onContinue: _isSubmitting ? () {} : _submitSetup,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
