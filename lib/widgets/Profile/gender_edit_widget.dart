import 'dart:math' as math;
import 'package:flutter/material.dart';

class GenderEditWidget extends StatefulWidget {
  const GenderEditWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final void Function({required String value, required bool isValid}) onChanged;

  @override
  State<GenderEditWidget> createState() => _GenderEditWidgetState();
}

class _GenderEditWidgetState extends State<GenderEditWidget>
    with SingleTickerProviderStateMixin {
  late String _selectedGender;
  late final AnimationController _controller;

  bool get _isSameGender =>
      _selectedGender.toLowerCase() == widget.initialValue.trim().toLowerCase();

  bool get _isValid => !_isSameGender;

  @override
  void initState() {
    super.initState();

    final normalized = widget.initialValue.trim().toLowerCase();
    _selectedGender = normalized == 'male' ? 'Male' : 'Female';

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParent();
    });
  }

  void _notifyParent() {
    widget.onChanged(value: _selectedGender, isValid: _isValid);
  }

  void _selectGender(String gender) {
    if (_selectedGender == gender) return;

    setState(() {
      _selectedGender = gender;
    });

    _notifyParent();
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _boxColor() => const Color.fromARGB(177, 190, 180, 180);
  Color _innerColor() => const Color.fromARGB(255, 198, 189, 189);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final outerRadius = w * 0.185;
    final innerRadius = w * 0.185;
    final outerPadding = (w * 0.01).clamp(5.0, 8.0);

    final boxHeight = (w * 0.10).clamp(62.0, 98.0);
    final iconSize = (w * 0.066).clamp(24.0, 30.0);
    final textSize = (w * 0.033).clamp(13.0, 15.0);

    final femaleSelected = _selectedGender == 'Female';
    final maleSelected = _selectedGender == 'Male';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (w * 0.25).clamp(20.0, 88.0)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(outerPadding),
            decoration: BoxDecoration(
              color: _boxColor(),
              borderRadius: BorderRadius.circular(outerRadius),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final segmentWidth = (totalWidth - outerPadding * 2) / 2;
                final innerHeight = (boxHeight * 0.95);

                return SizedBox(
                  height: boxHeight,
                  child: Stack(
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final t = _controller.value;

                          // slight enlarge during travel
                          final scale = 1 + (0.12 * math.sin(math.pi * t));

                          // tiny landing bounce
                          final landingBounce = t > 0.78
                              ? -1 *
                                    math.sin((t - 0.78) / 0.22 * math.pi * 2) *
                                    (1 - (t - 0.78) / 0.22)
                              : 0.0;

                          return AnimatedAlign(
                            duration: const Duration(milliseconds: 560),
                            curve: Curves.easeOutBack,
                            alignment: femaleSelected
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Transform.translate(
                              offset: Offset(0, landingBounce),
                              child: Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: segmentWidth,
                                  height: innerHeight,
                                  decoration: BoxDecoration(
                                    color: _innerColor(),
                                    borderRadius: BorderRadius.circular(
                                      innerRadius,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _GenderOption(
                              label: 'Female',
                              icon: Icons.female_rounded,
                              selected: femaleSelected,
                              selectedColor: const Color(0xFFE96A9A),
                              iconSize: iconSize,
                              textSize: textSize,
                              onTap: () => _selectGender('Female'),
                            ),
                          ),
                          Expanded(
                            child: _GenderOption(
                              label: 'Male',
                              icon: Icons.male_rounded,
                              selected: maleSelected,
                              selectedColor: const Color(0xFF2D7DFF),
                              iconSize: iconSize,
                              textSize: textSize,
                              onTap: () => _selectGender('Male'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: (h * 0.018).clamp(8.0, 12.0)),

          Text(
            'Select your gender identity',
            style: TextStyle(
              fontSize: (w * 0.032).clamp(12.0, 14.0),
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 123, 122, 122),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.iconSize,
    required this.textSize,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color selectedColor;
  final double iconSize;
  final double textSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : Colors.black;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: iconSize, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
