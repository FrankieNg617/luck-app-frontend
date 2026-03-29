import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetupBirthdayWidget extends StatefulWidget {
  const SetupBirthdayWidget({
    super.key,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.buttonFontSize,
    required this.buttonHeight,
    required this.initialValue,
    required this.onBack,
    required this.onBirthdayChanged,
    required this.onContinue,
  });

  final double titleFontSize;
  final double bodyFontSize;
  final double buttonFontSize;
  final double buttonHeight;
  final String initialValue;
  final VoidCallback onBack;
  final void Function({
    required String value,
    required bool isValid,
  }) onBirthdayChanged;
  final VoidCallback onContinue;

  @override
  State<SetupBirthdayWidget> createState() => _SetupBirthdayWidgetState();
}

class _SetupBirthdayWidgetState extends State<SetupBirthdayWidget> {
  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const int _loopBase = 10000;
  static const int _dayLoopMiddle = 31 * 160;   // 4960
  static const int _monthLoopMiddle = 12 * 400; // 4800
  static const int _totalDays = 31;

  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;

  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  List<int> get _years {
    final now = DateTime.now().year;
    return List<int>.generate(now - 1900 + 1, (i) => 1900 + i);
  }

  int get _daysInSelectedMonth =>
      DateTime(_selectedYear, _selectedMonth + 1, 0).day;

  String get _formattedValue {
    final monthName = _months[_selectedMonth - 1];
    final dayStr = _selectedDay.toString().padLeft(2, '0');
    return '$dayStr $monthName $_selectedYear';
  }

  @override
  void initState() {
    super.initState();

    final parsed = _parseInitialBirthday(widget.initialValue);
    _selectedDay = parsed.day;
    _selectedMonth = parsed.month;
    _selectedYear = parsed.year;

    _dayController = FixedExtentScrollController(
      initialItem: _dayLoopMiddle + (_selectedDay - 1),
    );
    _monthController = FixedExtentScrollController(
      initialItem: _monthLoopMiddle + (_selectedMonth - 1),
    );
    _yearController = FixedExtentScrollController(
      initialItem: _years.indexOf(_selectedYear),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParent();
    });
  }

  DateTime _parseInitialBirthday(String raw) {
    final cleaned = raw.trim();

    final fullMatch =
        RegExp(r'^(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})$').firstMatch(cleaned);
    if (fullMatch != null) {
      final day = int.tryParse(fullMatch.group(1)!) ?? 1;
      final monthName = fullMatch.group(2)!;
      final year = int.tryParse(fullMatch.group(3)!) ?? 2000;

      final monthIndex = _months.indexWhere(
        (m) => m.toLowerCase() == monthName.toLowerCase(),
      );

      if (monthIndex != -1) {
        final safeDay = math.min(day, DateTime(year, monthIndex + 2, 0).day);
        return DateTime(year, monthIndex + 1, safeDay);
      }
    }

    final slashMatch =
        RegExp(r'^(\d{1,2})\/(\d{1,2})\/(\d{4})$').firstMatch(cleaned);
    if (slashMatch != null) {
      final day = int.tryParse(slashMatch.group(1)!) ?? 1;
      final month = int.tryParse(slashMatch.group(2)!) ?? 1;
      final year = int.tryParse(slashMatch.group(3)!) ?? 2000;

      final safeMonth = month.clamp(1, 12);
      final safeDay = math.min(day, DateTime(year, safeMonth + 1, 0).day);
      return DateTime(year, safeMonth, safeDay);
    }

    return DateTime(2000, 1, 1);
  }

  void _notifyParent() {
    widget.onBirthdayChanged(
      value: _formattedValue,
      isValid: true,
    );
  }

  int _nearestLoopIndex({
    required int currentIndex,
    required int targetValue,
    required int cycleLength,
  }) {
    final currentCycleBase = (currentIndex ~/ cycleLength) * cycleLength;
    final candidates = <int>[
      currentCycleBase + (targetValue - 1),
      currentCycleBase - cycleLength + (targetValue - 1),
      currentCycleBase + cycleLength + (targetValue - 1),
    ];

    candidates.sort(
      (a, b) => (a - currentIndex).abs().compareTo((b - currentIndex).abs()),
    );

    return candidates.first;
  }

  void _handleDayChanged(int index) {
    final day = (index % _totalDays) + 1;
    final maxValidDay = _daysInSelectedMonth;

    if (day > maxValidDay) {
      final targetIndex = _nearestLoopIndex(
        currentIndex: index,
        targetValue: maxValidDay,
        cycleLength: _totalDays,
      );

      setState(() {
        _selectedDay = maxValidDay;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _dayController.animateToItem(
          targetIndex,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      });

      _notifyParent();
      return;
    }

    setState(() {
      _selectedDay = day;
    });
    _notifyParent();
  }

  void _handleMonthChanged(int index) {
    setState(() {
      _selectedMonth = (index % 12) + 1;
    });

    final maxDay = _daysInSelectedMonth;
    if (_selectedDay > maxDay) {
      final currentIndex = _dayController.selectedItem;
      final targetIndex = _nearestLoopIndex(
        currentIndex: currentIndex,
        targetValue: maxDay,
        cycleLength: _totalDays,
      );

      setState(() {
        _selectedDay = maxDay;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _dayController.animateToItem(
          targetIndex,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      });
    }

    _notifyParent();
  }

  void _handleYearChanged(int index) {
    setState(() {
      _selectedYear = _years[index];
    });

    final maxDay = _daysInSelectedMonth;
    if (_selectedDay > maxDay) {
      final currentIndex = _dayController.selectedItem;
      final targetIndex = _nearestLoopIndex(
        currentIndex: currentIndex,
        targetValue: maxDay,
        cycleLength: _totalDays,
      );

      setState(() {
        _selectedDay = maxDay;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _dayController.animateToItem(
          targetIndex,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      });
    }

    _notifyParent();
  }

  Widget _buildPickerItem(
    String text,
    double fontSize,
    Color color,
  ) {
    return Center(
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Color _dayTextColor(int day) {
    final isValidDay = day <= _daysInSelectedMonth;
    final isSelectedDay = day == _selectedDay;

    if (!isValidDay) {
      return Colors.white.withValues(alpha: 0.16);
    }
    if (isSelectedDay) {
      return Colors.white;
    }
    return Colors.white.withValues(alpha: 0.35);
  }

  Color _monthTextColor(int monthNumber) {
    if (monthNumber == _selectedMonth) {
      return Colors.white;
    }
    return Colors.white.withValues(alpha: 0.35);
  }

  Color _yearTextColor(int year) {
    if (year == _selectedYear) {
      return Colors.white;
    }
    return Colors.white.withValues(alpha: 0.35);
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    final pickerHeight = (h * 0.20).clamp(220.0, 300.0);
    final itemExtent = (h * 0.032).clamp(35.0, 48.0);
    final wheelFontSize = (w * 0.05).clamp(18.0, 25.0);
    final horizontalPadding = (w * 0.055).clamp(16.0, 28.0);

    return Stack(
      children: [
        Positioned(
          top: h * 0.002,
          left: w * 0.008,
          child: IconButton(
            onPressed: widget.onBack,
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: (w * 0.095).clamp(28, 38),
            ),
            padding: EdgeInsets.zero,
            splashRadius: (w * 0.06).clamp(20, 28),
            constraints: const BoxConstraints(),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                SizedBox(height: h * 0.36),
                Text(
                  'I was born on',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.titleFontSize.clamp(28, 42),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  'Date determines your zodiac sign and compatibility',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: widget.bodyFontSize.clamp(13, 17),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: h * 0.04),
                SizedBox(
                  height: pickerHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Container(
                          height: itemExtent + 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(
                              (w * 0.045).clamp(16.0, 24.0),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CupertinoPicker(
                              scrollController: _dayController,
                              itemExtent: itemExtent,
                              diameterRatio: 1.35,
                              squeeze: 1.08,
                              useMagnifier: false,
                              magnification: 1.0,
                              selectionOverlay: const SizedBox.shrink(),
                              changeReportingBehavior:
                                  ChangeReportingBehavior.onScrollEnd,
                              onSelectedItemChanged: _handleDayChanged,
                              children: List.generate(
                                _loopBase,
                                (index) {
                                  final day = (index % _totalDays) + 1;
                                  return _buildPickerItem(
                                    '$day',
                                    wheelFontSize,
                                    _dayTextColor(day),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CupertinoPicker(
                              scrollController: _monthController,
                              itemExtent: itemExtent,
                              diameterRatio: 1.35,
                              squeeze: 1.08,
                              useMagnifier: false,
                              magnification: 1.0,
                              selectionOverlay: const SizedBox.shrink(),
                              changeReportingBehavior:
                                  ChangeReportingBehavior.onScrollEnd,
                              onSelectedItemChanged: _handleMonthChanged,
                              children: List.generate(
                                _loopBase,
                                (index) {
                                  final monthIndex = index % 12;
                                  final monthNumber = monthIndex + 1;
                                  return _buildPickerItem(
                                    _months[monthIndex],
                                    wheelFontSize,
                                    _monthTextColor(monthNumber),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CupertinoPicker(
                              scrollController: _yearController,
                              itemExtent: itemExtent,
                              diameterRatio: 1.35,
                              squeeze: 1.08,
                              useMagnifier: false,
                              magnification: 1.0,
                              selectionOverlay: const SizedBox.shrink(),
                              changeReportingBehavior:
                                  ChangeReportingBehavior.onScrollEnd,
                              onSelectedItemChanged: _handleYearChanged,
                              children: List.generate(
                                _years.length,
                                (index) {
                                  final year = _years[index];
                                  return _buildPickerItem(
                                    '$year',
                                    wheelFontSize,
                                    _yearTextColor(year),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: widget.buttonHeight.clamp(52, 64),
                  child: ElevatedButton(
                    onPressed: widget.onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F36D8),
                      foregroundColor: Colors.white.withValues(alpha: 0.88),
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
                        fontSize: widget.buttonFontSize.clamp(18, 24),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.03),
              ],
            ),
          ),
        ),
      ],
    );
  }
}