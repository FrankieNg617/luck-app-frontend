import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/google_api.dart';

class SetupBirthPlaceWidget extends StatefulWidget {
  const SetupBirthPlaceWidget({
    super.key,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.buttonFontSize,
    required this.buttonHeight,
    required this.initialValue,
    required this.onBack,
    required this.onPlaceChanged,
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
  }) onPlaceChanged;
  final VoidCallback onContinue;

  @override
  State<SetupBirthPlaceWidget> createState() => _SetupBirthPlaceWidgetState();
}

class _SetupBirthPlaceWidgetState extends State<SetupBirthPlaceWidget> {
  late String _selectedPlace;

  bool get _hasPlace => _selectedPlace.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _selectedPlace = widget.initialValue.trim();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParent();
    });
  }

  void _notifyParent() {
    widget.onPlaceChanged(
      value: _selectedPlace,
      isValid: _hasPlace,
    );
  }

  Future<void> _openPlaceSearchSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (_) {
        return _BirthPlaceSearchSheet();
      },
    );

    if (!mounted || selected == null) return;

    setState(() {
      _selectedPlace = selected;
    });

    _notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    final horizontalPadding = (w * 0.055).clamp(16.0, 28.0);
    final fieldHeight = (h * 0.050).clamp(40.0, 54.0);

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
                  'My birth location is',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.titleFontSize.clamp(28, 42),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  'Place of birth determines your rising sign and houses',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: widget.bodyFontSize.clamp(13, 17),
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: h * 0.06),
                GestureDetector(
                  onTap: _openPlaceSearchSheet,
                  child: Container(
                    width: double.infinity,
                    height: fieldHeight,
                    padding: EdgeInsets.symmetric(
                      horizontal: (w * 0.05).clamp(18.0, 24.0),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _hasPlace ? _selectedPlace : 'Place of birth',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _hasPlace
                            ? Colors.white.withValues(alpha: 0.95)
                            : Colors.white.withValues(alpha: 0.45),
                        fontSize: (w * 0.03).clamp(18.0, 21.0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: widget.buttonHeight.clamp(52, 64),
                  child: ElevatedButton(
                    onPressed: _hasPlace ? widget.onContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F36D8),
                      disabledBackgroundColor:
                          const Color(0xFF2F36D8).withValues(alpha: 0.45),
                      foregroundColor: Colors.white.withValues(alpha: 0.88),
                      disabledForegroundColor:
                          Colors.white.withValues(alpha: 0.65),
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

class _PlaceSuggestion {
  const _PlaceSuggestion({
    required this.title,
    required this.subtitle,
    required this.fullText,
  });

  final String title;
  final String subtitle;
  final String fullText;
}

class _BirthPlaceSearchSheet extends StatefulWidget {
  const _BirthPlaceSearchSheet({super.key});

  @override
  State<_BirthPlaceSearchSheet> createState() => _BirthPlaceSearchSheetState();
}

class _BirthPlaceSearchSheetState extends State<_BirthPlaceSearchSheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  Timer? _debounce;
  int _requestId = 0;
  bool _isSelecting = false;

  List<_PlaceSuggestion> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _controller.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
    });
  }

  void _onTextChanged() {
    if (_isSelecting) return;

    final query = _controller.text.trim();

    _debounce?.cancel();

    if (query.isEmpty) {
      _requestId++;
      setState(() {
        _suggestions = [];
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      _fetchSuggestions(query);
    });
  }

  Future<void> _fetchSuggestions(String input) async {
    final query = input.trim();
    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        _suggestions = [];
      });
      return;
    }

    final currentRequestId = ++_requestId;

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=${Uri.encodeQueryComponent(query)}"
        "&types=(cities)"
        "&language=en"
        "&key=$googlePlacesApiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (!mounted) return;
      if (currentRequestId != _requestId) return;
      if (_controller.text.trim() != query) return;

      if (response.statusCode != 200) {
        setState(() {
          _suggestions = [];
        });
        return;
      }

      final data = json.decode(response.body);
      final predictions = (data['predictions'] as List?) ?? [];

      final results = predictions.take(6).map<_PlaceSuggestion>((e) {
        final description = e['description'].toString();
        final parts = description.split(',').map((s) => s.trim()).toList();

        final title = parts.isNotEmpty ? parts.first : description;
        final subtitle = parts.length > 1 ? parts.sublist(1).join(', ') : '';

        return _PlaceSuggestion(
          title: title,
          subtitle: subtitle,
          fullText: description,
        );
      }).toList();

      if (!mounted) return;
      if (currentRequestId != _requestId) return;
      if (_controller.text.trim() != query) return;

      setState(() {
        _suggestions = results;
      });
    } catch (_) {
      if (!mounted) return;
      if (currentRequestId != _requestId) return;
      if (_controller.text.trim() != query) return;

      setState(() {
        _suggestions = [];
      });
    }
  }

  void _selectPlace(_PlaceSuggestion suggestion) {
    _debounce?.cancel();
    _requestId++;
    _isSelecting = true;

    FocusScope.of(context).unfocus();

    if (mounted) {
      Navigator.of(context).pop(suggestion.title);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _requestId++;
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;
    final bottomInset = media.viewInsets.bottom;

    final horizontalPadding = (w * 0.02).clamp(12.0, 20.0);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: h * 0.93,
        decoration: BoxDecoration(
          color: const Color(0xFF4B1367),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                SizedBox(height: h * 0.020),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: (h * 0.04).clamp(48.0, 56.0),
                        padding: EdgeInsets.symmetric(
                          horizontal: (w * 0.030).clamp(12.0, 18.0),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white.withValues(alpha: 0.60),
                              size: (w * 0.06).clamp(20.0, 24.0),
                            ),
                            SizedBox(width: (w * 0.025).clamp(8.0, 12.0)),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                cursorColor: Colors.white,
                                cursorHeight: h * 0.026,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (w * 0.045).clamp(15.0, 19.0),
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    fontSize: (w * 0.045).clamp(15.0, 19.0),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: (w * 0.010).clamp(4.0, 8.0)),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.92),
                        padding: EdgeInsets.symmetric(
                          horizontal: (w * 0.01).clamp(2.0, 6.0),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: (w * 0.04).clamp(15.0, 19.0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.018),
                Text(
                  'Powered by Google',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.90),
                    fontSize: (w * 0.033).clamp(12.0, 15.0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: h * 0.018),
                Expanded(
                  child: _suggestions.isEmpty
                      ? const SizedBox.shrink()
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = _suggestions[index];

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _selectPlace(suggestion),
                                splashColor: Colors.transparent,
                                highlightColor:
                                    Colors.white.withValues(alpha: 0.06),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    vertical: (h * 0.017).clamp(12.0, 16.0),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.10,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        suggestion.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              (w * 0.045).clamp(16.0, 18.0),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (suggestion.subtitle.isNotEmpty) ...[
                                        SizedBox(
                                          height:
                                              (h * 0.005).clamp(4.0, 6.0),
                                        ),
                                        Text(
                                          suggestion.subtitle,
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.55,
                                            ),
                                            fontSize: (w * 0.035)
                                                .clamp(13.0, 14.5),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}