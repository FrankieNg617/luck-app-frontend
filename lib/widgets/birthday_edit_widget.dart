import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BirthdayEditWidget extends StatefulWidget {
  const BirthdayEditWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final void Function({
    required String value,
    required bool isValid,
  }) onChanged;

  @override
  State<BirthdayEditWidget> createState() => _BirthdayEditWidgetState();
}

class _BirthdayEditWidgetState extends State<BirthdayEditWidget> {
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

  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;

  late final FixedExtentScrollController _dayController;
  late final FixedExtentScrollController _monthController;
  late final FixedExtentScrollController _yearController;

  late final String _initialNormalizedValue;

  List<int> get _years {
    final now = DateTime.now().year;
    return List<int>.generate(now - 1900 + 1, (i) => 1900 + i);
  }

  int get _daysInSelectedMonth =>
      DateTime(_selectedYear, _selectedMonth + 1, 0).day;

  bool get _isValid => _formattedValue != _initialNormalizedValue;

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

    _initialNormalizedValue = '${parsed.day} ${_months[parsed.month - 1]} ${parsed.year}';

    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
    _monthController = FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _yearController = FixedExtentScrollController(
      initialItem: _years.indexOf(_selectedYear),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParent();
    });
  }

  DateTime _parseInitialBirthday(String raw) {
    final cleaned = raw.trim();

    final fullMatch = RegExp(r'^(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})$').firstMatch(cleaned);
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

    final slashMatch = RegExp(r'^(\d{1,2})\/(\d{1,2})\/(\d{4})$').firstMatch(cleaned);
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
    widget.onChanged(
      value: _formattedValue,
      isValid: _isValid,
    );
  }

  void _handleDayChanged(int index) {
    setState(() {
      _selectedDay = index + 1;
    });
    _notifyParent();
  }

  void _handleMonthChanged(int index) {
    setState(() {
      _selectedMonth = index + 1;

      final maxDay = _daysInSelectedMonth;
      if (_selectedDay > maxDay) {
        _selectedDay = maxDay;
      }
    });

    _dayController.jumpToItem(_selectedDay - 1);
    _notifyParent();
  }

  void _handleYearChanged(int index) {
    setState(() {
      _selectedYear = _years[index];

      final maxDay = _daysInSelectedMonth;
      if (_selectedDay > maxDay) {
        _selectedDay = maxDay;
      }
    });

    _dayController.jumpToItem(_selectedDay - 1);
    _notifyParent();
  }

  Widget _buildPickerItem(
    String text,
    double fontSize,
  ) {
    return Center(
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
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

    final pickerHeight = (h * 0.28).clamp(210.0, 280.0);
    final itemExtent = (h * 0.05).clamp(42.0, 54.0);
    final wheelFontSize = (w * 0.048).clamp(18.0, 24.0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (w * 0.065).clamp(12.0, 30.0),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: pickerHeight,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular((w * 0.05).clamp(18.0, 24.0)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    height: itemExtent + (h * 0.001),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(187, 231, 231, 231),
                      borderRadius: BorderRadius.circular(
                        (w * 0.01).clamp(14.0, 18.0),
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
                        diameterRatio: 1.25,
                        squeeze: 1.12,
                        useMagnifier: false,
                        magnification: 1.0,
                        selectionOverlay: const SizedBox.shrink(),
                        onSelectedItemChanged: _handleDayChanged,
                        children: List.generate(
                          _daysInSelectedMonth,
                          (index) => _buildPickerItem(
                            '${index + 1}',
                            wheelFontSize,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: CupertinoPicker(
                        scrollController: _monthController,
                        itemExtent: itemExtent,
                        diameterRatio: 1.25,
                        squeeze: 1.12,
                        useMagnifier: false,
                        magnification: 1.0,
                        selectionOverlay: const SizedBox.shrink(),
                        onSelectedItemChanged: _handleMonthChanged,
                        children: _months
                            .map((month) => _buildPickerItem(month, wheelFontSize))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: CupertinoPicker(
                        scrollController: _yearController,
                        itemExtent: itemExtent,
                        diameterRatio: 1.25,
                        squeeze: 1.12,
                        useMagnifier: false,
                        magnification: 1.0,
                        selectionOverlay: const SizedBox.shrink(),
                        onSelectedItemChanged: _handleYearChanged,
                        children: _years
                            .map((year) => _buildPickerItem('$year', wheelFontSize))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: (h * 0.018).clamp(12.0, 18.0)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (w * 0.04).clamp(10.0, 18.0),
            ),
            child: Text(
              'Date determines your zodiac sign and daily \nluck calculation',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (w * 0.033).clamp(12.0, 14.0),
                fontWeight: FontWeight.w500,
                color: Colors.black.withValues(alpha: 0.58),
              ),
            ),
          ),
        ],
      ),
    );
  }
}