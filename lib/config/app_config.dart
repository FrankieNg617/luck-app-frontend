class AppConfig {
  // Change this ONLY when switching environment
  static const bool useEmulator = true;

  static const String emulatorBaseUrl = 'http://10.0.2.2:3000';
  static const String phoneBaseUrl = 'http://192.168.68.53:3000';

  static String get baseUrl =>
      useEmulator ? emulatorBaseUrl : phoneBaseUrl;
}