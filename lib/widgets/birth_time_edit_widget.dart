import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BirthTimeEditWidget extends StatefulWidget {
  const BirthTimeEditWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final void Function({required String value, required bool isValid}) onChanged;

  @override
  State<BirthTimeEditWidget> createState() => _BirthTimeEditWidgetState();
}

class _BirthTimeEditWidgetState extends State<BirthTimeEditWidget> {
  late int _selectedHour;
  late int _selectedMinute;

  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;

  late final String _initialNormalizedValue;

  List<int> get _hours => List<int>.generate(24, (i) => i);
  List<int> get _minutes => List<int>.generate(60, (i) => i);

  String get _formattedValue {
    final hourStr = _selectedHour.toString().padLeft(2, '0');
    final minuteStr = _selectedMinute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  bool get _isValid => _formattedValue != _initialNormalizedValue;

  @override
  void initState() {
    super.initState();

    final parsed = _parseInitialTime(widget.initialValue);
    _selectedHour = parsed.$1;
    _selectedMinute = parsed.$2;

    _initialNormalizedValue =
        '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}';

    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinute,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParent();
    });
  }

  (int, int) _parseInitialTime(String raw) {
    final cleaned = raw.trim();

    final match = RegExp(r'^(\d{1,2}):(\d{1,2})$').firstMatch(cleaned);
    if (match != null) {
      final hour = int.tryParse(match.group(1)!) ?? 12;
      final minute = int.tryParse(match.group(2)!) ?? 0;

      final safeHour = hour.clamp(0, 23);
      final safeMinute = minute.clamp(0, 59);

      return (safeHour, safeMinute);
    }

    return (12, 0);
  }

  void _notifyParent() {
    widget.onChanged(value: _formattedValue, isValid: _isValid);
  }

  void _handleHourChanged(int index) {
    setState(() {
      _selectedHour = index;
    });
    _notifyParent();
  }

  void _handleMinuteChanged(int index) {
    setState(() {
      _selectedMinute = index;
    });
    _notifyParent();
  }

  Widget _buildPickerItem(String text, double fontSize) {
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
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    final pickerHeight = (h * 0.28).clamp(210.0, 280.0);
    final itemExtent = (h * 0.005).clamp(42.0, 54.0);
    final wheelFontSize = (w * 0.048).clamp(18.0, 24.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (w * 0.035).clamp(12.0, 30.0)),
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
                      color: const Color(0xFFE7E7E7),
                      borderRadius: BorderRadius.circular(
                        (w * 0.01).clamp(14.0, 18.0),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: (w * 0.22).clamp(80.0, 120.0),
                      child: CupertinoPicker(
                        scrollController: _hourController,
                        itemExtent: itemExtent,
                        onSelectedItemChanged: _handleHourChanged,
                        selectionOverlay: const SizedBox.shrink(),
                        children: _hours
                            .map(
                              (h) => _buildPickerItem(
                                h.toString().padLeft(2, '0'),
                                wheelFontSize,
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    SizedBox(width: (w * 0.02).clamp(6.0, 12.0)), // distance between columns

                    SizedBox(
                      width: (w * 0.22).clamp(80.0, 120.0),
                      child: CupertinoPicker(
                        scrollController: _minuteController,
                        itemExtent: itemExtent,
                        onSelectedItemChanged: _handleMinuteChanged,
                        selectionOverlay: const SizedBox.shrink(),
                        children: _minutes
                            .map(
                              (m) => _buildPickerItem(
                                m.toString().padLeft(2, '0'),
                                wheelFontSize,
                              ),
                            )
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
              'Time of birth determines your Moon & Rising sign.'
              '\n\n Noted: Please select 12:00 if your time of birth is unknown, which will have certain impact on the results.',
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
