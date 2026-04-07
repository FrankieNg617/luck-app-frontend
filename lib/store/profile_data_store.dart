import 'package:flutter/foundation.dart';

class ProfileData {
  const ProfileData({
    required this.userId,
    required this.username,
    required this.gender,
    required this.birthDate,
    required this.birthTime,
    required this.birthPlace,
    required this.zodiac,
    this.avatarPath,
  });

  final String userId;
  final String username;
  final String gender;
  final String birthDate;
  final String birthTime;
  final String birthPlace;
  final String zodiac;
  final String? avatarPath;

  String get avatarAsset {
    return gender.trim().toLowerCase() == 'male'
        ? 'assets/avatars/boy.png'
        : 'assets/avatars/woman.png';
  }

  ProfileData copyWith({
    String? userId,
    String? username,
    String? gender,
    String? birthDate,
    String? birthTime,
    String? birthPlace,
    String? zodiac,
    String? avatarPath,
    bool clearAvatarPath = false,
  }) {
    return ProfileData(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      zodiac: zodiac ?? this.zodiac,
      avatarPath: clearAvatarPath ? null : (avatarPath ?? this.avatarPath),
    );
  }
}

class ProfileDataStore extends ChangeNotifier {
  ProfileData? _data;
  bool _isLoading = false;
  String? _error;

  ProfileData? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _data != null;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setData(ProfileData value) {
    _data = value;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  void setError(String value) {
    _error = value;
    _isLoading = false;
    notifyListeners();
  }

  void updateProfile(ProfileData value) {
    _data = value;
    _error = null;
    notifyListeners();
  }

  void updateAvatarPath(String? path) {
    final current = _data;
    if (current == null) return;

    _data = current.copyWith(
      avatarPath: path,
      clearAvatarPath: path == null || path.trim().isEmpty,
    );
    notifyListeners();
  }
}