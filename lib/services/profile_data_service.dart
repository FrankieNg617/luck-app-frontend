import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../store/profile_data_store.dart';

class ProfileDataService {
  ProfileDataService({required this.baseUrl});

  final String baseUrl;

  Future<ProfileData> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      throw Exception('No saved user_id found.');
    }

    final url = '$baseUrl/api/users/$userId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch profile: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return _mapBackendToProfileData(json);
  }

  Future<ProfileData> updateProfile(ProfileData profileData) async {
    final url = '$baseUrl/api/users/${profileData.userId}';

    final payload = {
      'username': profileData.username,
      'gender': profileData.gender,
      'birthDate': profileData.birthDate,
      'birthTime': profileData.birthTime,
      'birthPlace': profileData.birthPlace,
      'birthTz': profileData.birthTz,
      'lat': profileData.lat,
      'lon': profileData.lon,
    };

    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final updated = _mapBackendToProfileData(json);

    return updated.copyWith(
      avatarPath: profileData.avatarPath,
    );
  }

  ProfileData _mapBackendToProfileData(Map<String, dynamic> json) {
    final profile = (json['profile'] as Map<String, dynamic>?) ?? {};
    final natal = (json['natal'] as Map<String, dynamic>?) ?? {};

    return ProfileData(
      userId: (json['userId'] ?? '').toString(),
      username: (profile['username'] ?? '').toString(),
      gender: (profile['gender'] ?? '').toString(),
      birthDate: (profile['birthDate'] ?? '').toString(),
      birthTime: (profile['birthTime'] ?? '').toString(),
      birthPlace: (profile['birthPlace'] ?? '').toString(),
      birthTz: (profile['birthTz'] ?? '').toString(),
      lat: _readDouble(profile['lat']),
      lon: _readDouble(profile['lon']),
      zodiac: (natal['sunSign'] ?? '').toString(),
      avatarPath: null,
    );
  }

  double _readDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}