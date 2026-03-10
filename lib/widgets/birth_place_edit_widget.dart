import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/google_api.dart';

class BirthPlaceEditWidget extends StatefulWidget {
  const BirthPlaceEditWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;

  final void Function({required String value, required bool isValid}) onChanged;

  @override
  State<BirthPlaceEditWidget> createState() => _BirthPlaceEditWidgetState();
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

class _BirthPlaceEditWidgetState extends State<BirthPlaceEditWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  bool _isCitySelected = false;
  int _requestId = 0;
  String? _selectedCity;

  List<_PlaceSuggestion> _suggestions = [];

  bool get _isEmpty => _controller.text.trim().isEmpty;

  bool get _isSame =>
      _controller.text.trim().toLowerCase() ==
      widget.initialValue.trim().toLowerCase();

  bool get _isValid => !_isEmpty && !_isSame;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _focusNode = FocusNode();

    _controller.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _focusNode.requestFocus();

      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );

      _notifyParent();
    });
  }

  void _onTextChanged() {
    if (_isCitySelected) return;

    final query = _controller.text.trim();

    if (_selectedCity != null && query == _selectedCity) {
      _notifyParent();
      return;
    }

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    if (query.isEmpty) {
      _requestId++;
      setState(() {
        _suggestions = [];
      });
      _selectedCity = null;
      _notifyParent();
      return;
    }

    _selectedCity = null;

    _debounce = Timer(const Duration(milliseconds: 350), () {
      _fetchSuggestions(query);
    });

    setState(() {});
    _notifyParent();
  }

  void _notifyParent() {
    widget.onChanged(value: _controller.text.trim(), isValid: _isValid);
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

      final results = predictions.take(5).map<_PlaceSuggestion>((e) {
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

  void _selectCity(String city) {
    _debounce?.cancel();
    _requestId++;
    _isCitySelected = true;
    _selectedCity = city;

    _controller.text = city;
    _controller.selection = TextSelection.collapsed(offset: city.length);

    FocusScope.of(context).unfocus();

    setState(() {
      _suggestions = [];
    });

    _notifyParent();

    _isCitySelected = false;
  }

  void _clear() {
    _debounce?.cancel();
    _requestId++;
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _debounce?.cancel();
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

    final horizontalPadding = (w * 0.02).clamp(14.0, 26.0);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: (w * 0.03).clamp(10.0, 22.0),
              vertical: (h * 0.006).clamp(5.0, 22.0),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: (w * 0.05).clamp(18.0, 22.0),
                  color: Colors.black.withValues(alpha: 0.6),
                ),

                SizedBox(width: (w * 0.02).clamp(8.0, 12.0)),

                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      fontSize: (w * 0.038).clamp(17.0, 21.0),
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: TextStyle(
                        color: Colors.black.withValues(alpha: 0.28),
                        fontSize: (w * 0.038).clamp(17.0, 21.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: (w * 0.02).clamp(6.0, 10.0)),

                GestureDetector(
                  onTap: _clear,
                  child: Container(
                    width: (w * 0.06).clamp(20.0, 24.0),
                    height: (w * 0.06).clamp(20.0, 24.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                    child: Icon(
                      Icons.close,
                      size: (w * 0.035).clamp(12.0, 14.0),
                      color: Colors.black.withValues(alpha: 0.65),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: (h * 0.012).clamp(10.0, 14.0)),

        if (_suggestions.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: List.generate(_suggestions.length, (index) {
                final suggestion = _suggestions[index];

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _selectCity(suggestion.title),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.grey.withValues(alpha: 0.08),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: (w * 0.01).clamp(2.0, 6.0),
                        vertical: (h * 0.014).clamp(10.0, 14.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black.withValues(alpha: 0.10),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion.title,
                            style: TextStyle(
                              fontSize: (w * 0.038).clamp(15.0, 17.0),
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          if (suggestion.subtitle.isNotEmpty) ...[
                            SizedBox(height: (h * 0.004).clamp(2.0, 6.0)),
                            Text(
                              suggestion.subtitle,
                              style: TextStyle(
                                fontSize: (w * 0.031).clamp(12.0, 13.5),
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withValues(alpha: 0.45),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
