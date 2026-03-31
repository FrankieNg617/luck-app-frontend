import 'package:flutter/material.dart';

class SetupUsernameWidget extends StatefulWidget {
  const SetupUsernameWidget({
    super.key,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.buttonFontSize,
    required this.buttonHeight,
    required this.initialValue,
    required this.onBack,
    required this.onNameChanged,
    required this.onContinue,
  });

  final double titleFontSize;
  final double bodyFontSize;
  final double buttonFontSize;
  final double buttonHeight;
  final String initialValue;
  final VoidCallback onBack;
  final void Function({required String value, required bool isValid})
  onNameChanged;
  final VoidCallback onContinue;

  @override
  State<SetupUsernameWidget> createState() => _SetupUsernameWidgetState();
}

class _SetupUsernameWidgetState extends State<SetupUsernameWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool get _isTooLong => _controller.text.length > 10;

  bool get _isValid => _controller.text.trim().isNotEmpty && !_isTooLong;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    _controller.addListener(_handleTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _notifyParent();
    });
  }

  void _handleTextChanged() {
    if (!mounted) return;
    setState(() {});
    _notifyParent();
  }

  void _notifyParent() {
    widget.onNameChanged(value: _controller.text.trim(), isValid: _isValid);
  }

  void _focusField() {
    _focusNode.requestFocus();

    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    final horizontalPadding = (w * 0.055).clamp(16.0, 28.0);
    final fieldHeight = (h * 0.050).clamp(40.0, 54.0);
    final fieldFontSize = (w * 0.03).clamp(18.0, 21.0);

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
                  'My Name is',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.titleFontSize.clamp(28, 42),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: h * 0.03),
                Column(
                  children: [
                    GestureDetector(
                      onTap: _focusField,
                      child: Container(
                        width: double.infinity,
                        height: fieldHeight,
                        padding: EdgeInsets.symmetric(
                          horizontal: (w * 0.05).clamp(18.0, 24.0),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                          border: _isTooLong
                              ? Border.all(color: Colors.red, width: 1.2)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: false,
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.sentences,
                          cursorColor: Colors.white,
                          cursorWidth: 2.2,
                          cursorHeight: fieldFontSize * 1.15,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: fieldFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'My Name',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: fieldFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),

                    // Warning text
                    SizedBox(height: (h * 0.012).clamp(8.0, 12.0)),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isTooLong ? 1 : 0,
                      child: Text(
                        'Name must be 10 characters or fewer',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: (w * 0.032).clamp(12.0, 14.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: widget.buttonHeight.clamp(52, 64),
                  child: ElevatedButton(
                    onPressed: _isValid ? widget.onContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F36D8),
                      disabledBackgroundColor: const Color(
                        0xFF2F36D8,
                      ).withValues(alpha: 0.45),
                      foregroundColor: Colors.white.withValues(alpha: 0.88),
                      disabledForegroundColor: Colors.white.withValues(
                        alpha: 0.65,
                      ),
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
