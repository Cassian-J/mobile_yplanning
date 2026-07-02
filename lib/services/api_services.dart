import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static final String _baseUrl = dotenv.env['API_URL']!;

  static Uri _buildUri(String endpoint) {
    return Uri.parse('$_baseUrl$endpoint');
  }

  /// GET
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(_buildUri(endpoint));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'GET $endpoint failed (${response.statusCode}) : ${response.body}',
      );
    }

    return jsonDecode(response.body);
  }

  /// POST (Create / login / register / refresh token)
  static Future<dynamic> post(String endpoint,Map<String, dynamic> body, {required bool authenticated}) async {
    final response = await http.post(
      _buildUri(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'POST $endpoint failed (${response.statusCode}) : ${response.body}',
      );
    }

    if (response.body.isEmpty) return null;

    return jsonDecode(response.body);
  }

  /// PUT (Update)
  static Future<dynamic> put(String endpoint,Map<String, dynamic> body,) async {
    final response = await http.put(
      _buildUri(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'PUT $endpoint failed (${response.statusCode}) : ${response.body}',
      );
    }

    if (response.body.isEmpty) return null;

    return jsonDecode(response.body);
  }

  /// DELETE
  static Future<void> delete(String endpoint) async {
    final response = await http.delete(_buildUri(endpoint));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'DELETE $endpoint failed (${response.statusCode}) : ${response.body}',
      );
    }
  }
}