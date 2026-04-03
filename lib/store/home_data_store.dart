import 'package:flutter/foundation.dart';
import '../models/home_data.dart';

class HomeDataStore extends ChangeNotifier {
  HomeData? _data;
  bool _isLoading = false;
  String? _error;

  HomeData? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _data != null;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setData(HomeData value) {
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
}