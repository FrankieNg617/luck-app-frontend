import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetupBirthTimeWidget extends StatefulWidget {
  const SetupBirthTimeWidget({
    super.key,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.buttonFontSize,
    required this.buttonHeight,
    required this.initialValue,
    required this.onBack,
    required this.onTimeChanged,
    required this.onNotSure,
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
  }) onTimeChanged;
  final VoidCallback onNotSure;
  final VoidCallback onContinue;

  @override
  State<SetupBirthTimeWidget> createState() => _SetupBirthTimeWidgetState();
}

class _SetupBirthTimeWidgetState extends State<SetupBirthTimeWidget> {
  static const int _hourLoopBase = 24 * 400;
  static const int _minuteLoopBase = 60 * 200;
  static const int _hourCount = 24;
  static const int _minuteCount = 60;

  late int _selectedHour;
  late int _selectedMinute;

  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;

  String get _formattedValue {
    final hourStr = _selectedHour.toString().padLeft(2, '0');
    final minuteStr = _selectedMinute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  @override
  void initState() {
    super.initState();

    final parsed = _parseInitialTime(widget.initialValue);
    _selectedHour = parsed.$1;
    _selectedMinute = parsed.$2;

    _hourController = FixedExtentScrollController(
      initialItem: _hourLoopBase + _selectedHour,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _minuteLoopBase + _selectedMinute,
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
      return (hour.clamp(0, 23), minute.clamp(0, 59));
    }

    return (12, 0);
  }

  void _notifyParent() {
    widget.onTimeChanged(
      value: _formattedValue,
      isValid: true,
    );
  }

  void _handleHourChanged(int index) {
    setState(() {
      _selectedHour = index % _hourCount;
    });
    _notifyParent();
  }

  void _handleMinuteChanged(int index) {
    setState(() {
      _selectedMinute = index % _minuteCount;
    });
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

  Color _hourTextColor(int hour) {
    if (hour == _selectedHour) {
      return Colors.white;
    }
    return Colors.white.withValues(alpha: 0.35);
  }

  Color _minuteTextColor(int minute) {
    if (minute == _selectedMinute) {
      return Colors.white;
    }
    return Colors.white.withValues(alpha: 0.35);
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

    final pickerHeight = (h * 0.20).clamp(210.0, 290.0);
    final itemExtent = (h * 0.032).clamp(35.0, 48.0);
    final wheelFontSize = (w * 0.055).clamp(20.0, 28.0);
    final horizontalPadding = (w * 0.055).clamp(16.0, 28.0);
    final notSureButtonWidth = (w * 0.66).clamp(220.0, 320.0);
    final notSureButtonHeight = (h * 0.055).clamp(48.0, 60.0);
    final wheelBlockTop = h * 0.36;

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
                SizedBox(height: wheelBlockTop),
                Text(
                  'I was born at',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.titleFontSize.clamp(28, 42),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  'Time of birth determines your Moon & Rising sign',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: widget.bodyFontSize.clamp(13, 17),
                    fontWeight: FontWeight.w500,
                    height: 1.35,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: (w * 0.18).clamp(70.0, 110.0),
                            child: CupertinoPicker(
                              scrollController: _hourController,
                              itemExtent: itemExtent,
                              diameterRatio: 1.35,
                              squeeze: 1.08,
                              useMagnifier: false,
                              magnification: 1.0,
                              selectionOverlay: const SizedBox.shrink(),
                              changeReportingBehavior:
                                  ChangeReportingBehavior.onScrollEnd,
                              onSelectedItemChanged: _handleHourChanged,
                              children: List.generate(
                                _hourLoopBase * 2,
                                (index) {
                                  final hour = index % _hourCount;
                                  return _buildPickerItem(
                                    hour.toString().padLeft(2, '0'),
                                    wheelFontSize,
                                    _hourTextColor(hour),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: (w * 0.06).clamp(16.0, 28.0)),
                          SizedBox(
                            width: (w * 0.18).clamp(70.0, 110.0),
                            child: CupertinoPicker(
                              scrollController: _minuteController,
                              itemExtent: itemExtent,
                              diameterRatio: 1.35,
                              squeeze: 1.08,
                              useMagnifier: false,
                              magnification: 1.0,
                              selectionOverlay: const SizedBox.shrink(),
                              changeReportingBehavior:
                                  ChangeReportingBehavior.onScrollEnd,
                              onSelectedItemChanged: _handleMinuteChanged,
                              children: List.generate(
                                _minuteLoopBase * 2,
                                (index) {
                                  final minute = index % _minuteCount;
                                  return _buildPickerItem(
                                    minute.toString().padLeft(2, '0'),
                                    wheelFontSize,
                                    _minuteTextColor(minute),
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
                  width: notSureButtonWidth,
                  height: notSureButtonHeight,
                  child: ElevatedButton(
                    onPressed: widget.onNotSure,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      foregroundColor: Colors.white.withValues(alpha: 0.92),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                    ),
                    child: Text(
                      'I’m not sure',
                      style: TextStyle(
                        fontSize: widget.bodyFontSize.clamp(16, 22),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.02),
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