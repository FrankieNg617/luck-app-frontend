import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String username;
  final String zodiacSign; // "Scorpio"
  final String birthday;   // "03 Nov 2001"
  final String birthTime;  // "14:25"
  final String birthPlace; // "Hong Kong"
  final String gender;     // "Male" / "Female"
  final String avatarAsset;
  final String? avatarPath;

  const UserProfile({
    required this.username,
    required this.zodiacSign,
    required this.birthday,
    required this.birthTime,
    required this.birthPlace,
    required this.gender,
    required this.avatarAsset,
    this.avatarPath,
  });

  UserProfile copyWith({
    String? username,
    String? zodiacSign,
    String? birthday,
    String? birthTime,
    String? birthPlace,
    String? gender,
    String? avatarAsset,
    String? avatarPath,
    bool clearAvatarPath = false,
  }) {
    return UserProfile(
      username: username ?? this.username,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      birthday: birthday ?? this.birthday,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      gender: gender ?? this.gender,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      avatarPath: clearAvatarPath ? null : (avatarPath ?? this.avatarPath),
    );
  }

  static const dev = UserProfile(
    username: 'Frankie',
    zodiacSign: 'Scorpio',
    birthday: '03 November 2001',
    birthTime: '14:25',
    birthPlace: 'Hong Kong',
    gender: 'Male',
    avatarAsset: 'assets/avatars/boy.png',
  );
}

/// Temp in-memory store for dev (later you can swap to SharedPreferences/db).
class UserProfileStore extends ChangeNotifier {
  UserProfileStore([UserProfile? initial]) : _profile = initial ?? UserProfile.dev;

  UserProfile _profile;
  UserProfile get profile => _profile;

  Future<void> update(UserProfile next) async {
    _profile = next;
    notifyListeners();
  }

  // Convenience setters
  void setUsername(String v) => update(_profile.copyWith(username: v));
  void setZodiacSign(String v) => update(_profile.copyWith(zodiacSign: v));
  void setBirthday(String v) => update(_profile.copyWith(birthday: v));
  void setBirthTime(String v) => update(_profile.copyWith(birthTime: v));
  void setBirthPlace(String v) => update(_profile.copyWith(birthPlace: v));
  void setGender(String v) => update(_profile.copyWith(gender: v));
  void setAvatarAsset(String v) => update(_profile.copyWith(avatarAsset: v));
}