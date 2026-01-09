import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/daily_response.dart';

class ApiService {
  // For Android emulator, localhost is 10.0.2.2
  // For real device, use your PC IP, e.g. http://192.168.1.23:3000
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<DailyResponse> fetchDailyPersonal({
    required String userId,
    required String tz,
    String? date, // YYYY-MM-DD
    bool refresh = false,
  }) async {
    final params = <String, String>{
      'userId': userId,
      'tz': tz,
    };
    if (date != null && date.isNotEmpty) params['date'] = date;
    if (refresh) params['refresh'] = '1';

    final uri = Uri.parse('$baseUrl/api/daily-personal').replace(queryParameters: params);
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('API error ${resp.statusCode}: ${resp.body}');
    }

    final jsonMap = json.decode(resp.body) as Map<String, dynamic>;
    return DailyResponse.fromJson(jsonMap);
  }
}
