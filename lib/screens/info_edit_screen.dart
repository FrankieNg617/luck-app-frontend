import 'package:flutter/material.dart';
import '../widgets/username_edit_widget.dart';
import '../widgets/gender_edit_widget.dart';
import '../widgets/birthday_edit_widget.dart';

class InfoEditScreen extends StatefulWidget {
  const InfoEditScreen({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  State<InfoEditScreen> createState() => _InfoEditScreenState();
}

class _InfoEditScreenState extends State<InfoEditScreen> {
  late String _editedValue;
  bool _isDoneEnabled = false;

  @override
  void initState() {
    super.initState();
    _editedValue = widget.value;
  }

  void _onFieldChanged({
    required String value,
    required bool isValid,
  }) {
    setState(() {
      _editedValue = value;
      _isDoneEnabled = isValid;
    });
  }

  Widget _buildEditContent() {
    switch (widget.title.toLowerCase()) {
      case 'name':
        return UsernameEditWidget(
          initialValue: widget.value,
          onChanged: _onFieldChanged,
        );
      case 'gender':
        return GenderEditWidget(
          initialValue: widget.value,
          onChanged: _onFieldChanged,
        );
      case 'birthday':
        return BirthdayEditWidget(
          initialValue: widget.value,
          onChanged: _onFieldChanged,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    final activeColor = Colors.black;
    final disabledColor = Colors.grey;

    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: h * 0.95,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: (h * 0.006).clamp(4.0, 8.0)),
                SizedBox(
                  height: (w * 0.11).clamp(48.0, 56.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            foregroundColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.black.withValues(alpha: 0.45);
                              }
                              return Colors.black;
                            }),
                            textStyle: WidgetStateProperty.all(
                              TextStyle(
                                fontSize: (w * 0.042).clamp(15.0, 17.0),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Edit profile',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: (w * 0.042).clamp(15.0, 17.0),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            foregroundColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (!_isDoneEnabled) return disabledColor;
                              if (states.contains(WidgetState.pressed)) {
                                return activeColor.withValues(alpha: 0.45);
                              }
                              return activeColor;
                            }),
                            textStyle: WidgetStateProperty.all(
                              TextStyle(
                                fontSize: (w * 0.042).clamp(15.0, 17.0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onPressed: _isDoneEnabled
                              ? () => Navigator.of(context).pop(_editedValue.trim())
                              : null,
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),

                _buildEditContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}