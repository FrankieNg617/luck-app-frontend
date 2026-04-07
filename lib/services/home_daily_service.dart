import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import '../models/home_data.dart';

class HomeDailyService {
  HomeDailyService({required this.baseUrl});

  final String baseUrl;

  static const String _cachedDailyDateKey = 'cached_daily_date';
  static const String _cachedDailyTzKey = 'cached_daily_tz';
  static const String _cachedDailyPayloadKey = 'cached_daily_payload';

  Future<HomeData> loadHomeData() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');
    if (userId == null || userId.isEmpty) {
      throw Exception('No saved user_id found.');
    }

    final tz = await _getEffectiveTimezone();

    final today = DateTime.now().toIso8601String().substring(0, 10);

    final cachedDate = prefs.getString(_cachedDailyDateKey);
    final cachedTz = prefs.getString(_cachedDailyTzKey);
    final cachedPayload = prefs.getString(_cachedDailyPayloadKey);

    if (cachedDate == today &&
        cachedTz == tz &&
        cachedPayload != null &&
        cachedPayload.isNotEmpty) {
      final cachedJson = jsonDecode(cachedPayload) as Map<String, dynamic>;
      return _mapCacheJsonToHomeData(cachedJson);
    }

    return fetchAndCacheToday();
  }

  Future<HomeData> fetchAndCacheToday() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');
    if (userId == null || userId.isEmpty) {
      throw Exception('No saved user_id found.');
    }

    final tz = await _getEffectiveTimezone();

    final today = DateTime.now().toIso8601String().substring(0, 10);

    final userResponse = await http.get(
      Uri.parse('$baseUrl/api/users/$userId'),
    );

    if (userResponse.statusCode != 200) {
      throw Exception('Failed to fetch user: ${userResponse.body}');
    }

    final dailyResponse = await http.get(
      Uri.parse(
        '$baseUrl/api/daily-personal'
        '?userId=$userId'
        '&tz=${Uri.encodeQueryComponent(tz)}'
        '&date=$today',
      ),
    );

    if (dailyResponse.statusCode != 200) {
      throw Exception('Failed to fetch daily data: ${dailyResponse.body}');
    }

    final userJson = jsonDecode(userResponse.body) as Map<String, dynamic>;
    final dailyJson = jsonDecode(dailyResponse.body) as Map<String, dynamic>;

    final homeData = _mapBackendToHomeData(
      userJson: userJson,
      dailyJson: dailyJson,
    );

    await prefs.setString(_cachedDailyDateKey, today);
    await prefs.setString(_cachedDailyTzKey, tz);
    await prefs.setString(
      _cachedDailyPayloadKey,
      jsonEncode(_toCacheJson(homeData)),
    );

    return homeData;
  }

  Future<String> _getEffectiveTimezone() async {
    final prefs = await SharedPreferences.getInstance();

    final savedCurrentTz = prefs.getString('current_tz');
    final savedBirthTz = prefs.getString('birth_tz');

    String deviceTz;
    try {
      deviceTz = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      deviceTz = savedCurrentTz ?? savedBirthTz ?? 'Asia/Tokyo';
    }

    if (savedCurrentTz != deviceTz) {
      await prefs.setString('current_tz', deviceTz);
    }

    return deviceTz;
  }

  Map<String, dynamic> _toCacheJson(HomeData data) {
    return {
      'username': data.username,
      'zodiac': data.zodiac,
      'overall': data.overall,
      'career': data.career,
      'study': data.study,
      'love': data.love,
      'social': data.social,
      'fortune': data.fortune,
      'advice': data.advice,
      'dos': data.dos,
      'donts': data.donts,
      'tasks': data.tasks,
      'food': data.food,
      'numbers': data.numbers,
      'colour': data.colour,
      'time': data.time,
    };
  }

  HomeData _mapCacheJsonToHomeData(Map<String, dynamic> json) {
    return HomeData(
      username: (json['username'] ?? '').toString(),
      zodiac: (json['zodiac'] ?? '').toString(),
      overall: _readInt(json['overall']),
      career: _readInt(json['career']),
      study: _readInt(json['study']),
      love: _readInt(json['love']),
      social: _readInt(json['social']),
      fortune: _readInt(json['fortune']),
      advice: (json['advice'] ?? '').toString(),
      dos: _readStringList(json['dos']),
      donts: _readStringList(json['donts']),
      tasks: _readStringList(json['tasks']),
      food: (json['food'] ?? '').toString(),
      numbers: _readIntList(json['numbers']),
      colour: (json['colour'] ?? '').toString(),
      time: (json['time'] ?? '').toString(),
    );
  }

  HomeData _mapBackendToHomeData({
    required Map<String, dynamic> userJson,
    required Map<String, dynamic> dailyJson,
  }) {
    final profile = (userJson['profile'] as Map<String, dynamic>?) ?? {};
    final natal = (userJson['natal'] as Map<String, dynamic>?) ?? {};
    final scores = (dailyJson['scores'] as Map<String, dynamic>?) ?? {};
    final dailyContent =
        (dailyJson['daily_content'] as Map<String, dynamic>?) ?? {};

    return HomeData(
      username: (profile['username'] ?? 'User').toString(),
      zodiac: (natal['sunSign'] ?? '').toString(),
      overall: _readInt(scores['overall'] ?? 0),
      career: _readInt(scores['career'] ?? 0),
      study: _readInt(scores['study'] ?? 0),
      love: _readInt(scores['love'] ?? 0),
      social: _readInt(scores['social'] ?? 0),
      fortune: _readInt(scores['fortune'] ?? 0),
      advice: (dailyContent['life_advice'] ?? '').toString(),
      dos: _readStringList(dailyContent['suggest_to_do']),
      donts: _readStringList(dailyContent['avoid_to_do']),
      tasks: _readStringList(dailyContent['daily_tasks']),
      food: (dailyContent['lucky_food'] ?? '').toString(),
      numbers: _readIntList(dailyContent['lucky_numbers']),
      colour: (dailyContent['lucky_color'] ?? '').toString(),
      time: (dailyContent['lucky_time'] ?? '').toString(),
    );
  }

  int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  List<String> _readStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  List<int> _readIntList(dynamic value) {
    if (value is List) {
      return value.map((e) {
        if (e is int) return e;
        if (e is double) return e.round();
        return int.tryParse(e.toString()) ?? 0;
      }).toList();
    }
    return const [];
  }
}
