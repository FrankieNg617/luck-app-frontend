import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/google_api.dart';

class BirthPlaceEditSelection {
  const BirthPlaceEditSelection({
    required this.cityName,
    required this.fullAddress,
    required this.lat,
    required this.lon,
    required this.timeZoneId,
  });

  final String cityName;
  final String fullAddress;
  final double lat;
  final double lon;
  final String timeZoneId;
}

class BirthPlaceEditWidget extends StatefulWidget {
  const BirthPlaceEditWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final BirthPlaceEditSelection? initialValue;

  final void Function({
    required BirthPlaceEditSelection? place,
    required bool isValid,
  }) onChanged;

  @override
  State<BirthPlaceEditWidget> createState() => _BirthPlaceEditWidgetState();
}

class _PlaceSuggestion {
  const _PlaceSuggestion({
    required this.placeId,
    required this.title,
    required this.subtitle,
    required this.fullText,
  });

  final String placeId;
  final String title;
  final String subtitle;
  final String fullText;
}

class _BirthPlaceEditWidgetState extends State<BirthPlaceEditWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  int _requestId = 0;
  bool _isSelecting = false;
  bool _showNoLocationMsg = false;
  String? _loadingPlaceId;

  BirthPlaceEditSelection? _selectedPlace;
  List<_PlaceSuggestion> _suggestions = [];

  bool get _isLoadingSelection => _loadingPlaceId != null;
  bool get _isValid => _selectedPlace != null;

  @override
  void initState() {
    super.initState();

    _selectedPlace = widget.initialValue;
    _controller = TextEditingController(
      text: widget.initialValue?.cityName ?? '',
    );
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

  void _notifyParent() {
    widget.onChanged(place: _selectedPlace, isValid: _isValid);
  }

  void _onTextChanged() {
    if (_isSelecting) return;

    final query = _controller.text.trim();

    _debounce?.cancel();

    if (_selectedPlace != null && query != _selectedPlace!.cityName) {
      _selectedPlace = null;
      _notifyParent();
    }

    if (query.isEmpty) {
      _requestId++;
      setState(() {
        _suggestions = [];
        _showNoLocationMsg = false;
        _loadingPlaceId = null;
      });
      _notifyParent();
      return;
    }

    setState(() {
      _showNoLocationMsg = false;
    });

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
        _showNoLocationMsg = false;
      });
      return;
    }

    final currentRequestId = ++_requestId;

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeQueryComponent(query)}'
        '&types=(cities)'
        '&language=en'
        '&key=$googlePlacesApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (!mounted) return;
      if (currentRequestId != _requestId) return;
      if (_controller.text.trim() != query) return;

      if (response.statusCode != 200) {
        setState(() {
          _suggestions = [];
          _showNoLocationMsg = true;
        });
        return;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final predictions = (data['predictions'] as List?) ?? [];

      final results = predictions.take(6).map<_PlaceSuggestion>((e) {
        final map = e as Map<String, dynamic>;
        final description = (map['description'] ?? '').toString();
        final parts = description.split(',').map((s) => s.trim()).toList();

        final title = parts.isNotEmpty ? parts.first : description;
        final subtitle = parts.length > 1 ? parts.sublist(1).join(', ') : '';

        return _PlaceSuggestion(
          placeId: (map['place_id'] ?? '').toString(),
          title: title,
          subtitle: subtitle,
          fullText: description,
        );
      }).where((e) => e.placeId.isNotEmpty).toList();

      if (!mounted) return;
      if (currentRequestId != _requestId) return;
      if (_controller.text.trim() != query) return;

      setState(() {
        _suggestions = results;
        _showNoLocationMsg = results.isEmpty;
      });
    } catch (_) {
      if (!mounted) return;
      if (currentRequestId != _requestId) return;
      if (_controller.text.trim() != query) return;

      setState(() {
        _suggestions = [];
        _showNoLocationMsg = true;
      });
    }
  }

  Future<BirthPlaceEditSelection> _fetchPlaceDetailsAndTimezone(
    _PlaceSuggestion suggestion,
  ) async {
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=${Uri.encodeQueryComponent(suggestion.placeId)}'
        '&fields=name,formatted_address,geometry'
        '&language=en'
        '&key=$googlePlacesApiKey';

    final detailsResponse = await http.get(Uri.parse(detailsUrl));

    if (detailsResponse.statusCode != 200) {
      throw Exception('Failed to fetch place details.');
    }

    final detailsData = json.decode(detailsResponse.body) as Map<String, dynamic>;
    final detailsStatus = (detailsData['status'] ?? '').toString();
    if (detailsStatus != 'OK') {
      throw Exception('Place details status: $detailsStatus');
    }

    final result = detailsData['result'] as Map<String, dynamic>?;
    final geometry = result?['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;

    final lat = (location?['lat'] as num?)?.toDouble();
    final lon = (location?['lng'] as num?)?.toDouble();

    if (lat == null || lon == null) {
      throw Exception('Missing place coordinates.');
    }

    final timestamp =
        DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;

    final timezoneUrl =
        'https://maps.googleapis.com/maps/api/timezone/json'
        '?location=$lat,$lon'
        '&timestamp=$timestamp'
        '&key=$googlePlacesApiKey';

    final timezoneResponse = await http.get(Uri.parse(timezoneUrl));

    if (timezoneResponse.statusCode != 200) {
      throw Exception('Failed to fetch timezone.');
    }

    final timezoneData = json.decode(timezoneResponse.body) as Map<String, dynamic>;
    final timezoneStatus = (timezoneData['status'] ?? '').toString();
    if (timezoneStatus != 'OK') {
      throw Exception('Timezone status: $timezoneStatus');
    }

    final timeZoneId = (timezoneData['timeZoneId'] ?? '').toString();
    if (timeZoneId.isEmpty) {
      throw Exception('Missing timezone.');
    }

    final formattedAddress =
        (result?['formatted_address'] ?? suggestion.fullText).toString();

    return BirthPlaceEditSelection(
      cityName: suggestion.title,
      fullAddress: formattedAddress,
      lat: lat,
      lon: lon,
      timeZoneId: timeZoneId,
    );
  }

  Future<void> _selectPlace(_PlaceSuggestion suggestion) async {
    if (_loadingPlaceId != null) return;

    _debounce?.cancel();
    _requestId++;
    _isSelecting = true;

    FocusScope.of(context).unfocus();

    setState(() {
      _loadingPlaceId = suggestion.placeId;
      _showNoLocationMsg = false;
    });

    try {
      final selection = await _fetchPlaceDetailsAndTimezone(suggestion);

      if (!mounted) return;

      _controller.text = selection.cityName;
      _controller.selection = TextSelection.collapsed(
        offset: selection.cityName.length,
      );

      setState(() {
        _selectedPlace = selection;
        _suggestions = [];
        _loadingPlaceId = null;
      });

      _notifyParent();
      _isSelecting = false;
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingPlaceId = null;
        _showNoLocationMsg = true;
      });

      _isSelecting = false;
    }
  }

  void _clear() {
    _debounce?.cancel();
    _requestId++;

    setState(() {
      _selectedPlace = null;
      _suggestions = [];
      _showNoLocationMsg = false;
      _loadingPlaceId = null;
    });

    _controller.clear();
    _focusNode.requestFocus();
    _notifyParent();
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

    return AbsorbPointer(
      absorbing: _isLoadingSelection,
      child: Column(
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
                        hintText: 'Search',
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
                  if (_isLoadingSelection)
                    SizedBox(
                      width: (w * 0.06).clamp(20.0, 24.0),
                      height: (w * 0.06).clamp(20.0, 24.0),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.2,
                      ),
                    )
                  else
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
                  final isLoading = _loadingPlaceId == suggestion.placeId;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isLoading ? null : () => _selectPlace(suggestion),
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
                        child: Row(
                          children: [
                            Expanded(
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
                                    SizedBox(
                                      height: (h * 0.004).clamp(2.0, 6.0),
                                    ),
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
                            if (isLoading)
                              SizedBox(
                                width: (w * 0.05).clamp(18.0, 22.0),
                                height: (w * 0.05).clamp(18.0, 22.0),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )
          else if (_showNoLocationMsg)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                'No such location. Please try again',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (w * 0.033).clamp(13.0, 15.0),
                  color: Colors.black.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}