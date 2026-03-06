import 'package:flutter/material.dart';

class UsernameEditWidget extends StatefulWidget {
  const UsernameEditWidget({
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
  State<UsernameEditWidget> createState() => _UsernameEditWidgetState();
}

class _UsernameEditWidgetState extends State<UsernameEditWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  static const int maxLength = 10;

  bool get isEmpty => _controller.text.trim().isEmpty;
  bool get isTooLong => _controller.text.characters.length > maxLength;
  bool get isSameName => _controller.text.trim() == widget.initialValue.trim();

  bool get isValid => !isEmpty && !isTooLong && !isSameName;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    _controller.addListener(handleTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        notifyParent();
      }
    });
  }

  void handleTextChanged() {
    setState(() {});
    notifyParent();
  }

  void notifyParent() {
    widget.onChanged(
      value: _controller.text,
      isValid: isValid,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(handleTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Color borderColor() {
    if (isTooLong) return Colors.red;
    return Colors.black.withValues(alpha: 0.25);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (w * 0.02).clamp(14.0, 26.0),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: (w * 0.03).clamp(10.0, 22.0),
              vertical: (h * 0.006).clamp(5.0, 22.0),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor(),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: (w * 0.036).clamp(13.0, 15.0),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: (h * 0.002).clamp(2.0, 14.0)),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.black,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: (w * 0.038).clamp(17.0, 21.0),
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(
                      fontSize: (w * 0.038).clamp(17.0, 21.0),
                      color: Colors.black.withValues(alpha: 0.28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: (h * 0.01).clamp(8.0, 12.0)),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (w * 0.06).clamp(18.0, 28.0),
          ),
          child: Column(
            children: [
              if (isTooLong) ...[
                Text(
                  'Name must be 10 characters or fewer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (w * 0.032).clamp(12.0, 14.0),
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: (h * 0.004).clamp(4.0, 8.0)),
              ],
              Text(
                'Name should be up to 10 characters',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (w * 0.032).clamp(12.0, 14.0),
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 123, 122, 122),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}