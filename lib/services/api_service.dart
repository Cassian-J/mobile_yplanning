import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../helper/token_storage.dart';
import '../helper/auth_guard.dart';

class ApiService {
  ApiService._();

  static final String _baseUrl = dotenv.env['API_URL']!;

  static Uri _buildUri(String endpoint) =>
      Uri.parse('$_baseUrl$endpoint');

  // 🔐 HEADERS
  static Future<Map<String, String>> _headers({
    required bool authenticated,
  }) async {
    final headers = {
      "Content-Type": "application/json",
    };

    if (authenticated) {
      final token = await TokenStorage.getAccessToken();
      final type = await TokenStorage.getTokenType() ?? "Bearer";

      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  // 🔥 CHECK TOKEN BEFORE REQUEST
 static Future<bool> _checkAuth(bool authenticated) async {
  if (!authenticated) return true;

  try {
    return await AuthGuard.ensureValidToken();
  } catch (e) {
    return false;
  }
}

  /// GET
  static Future<dynamic> get(String endpoint) async {
    final ok = await _checkAuth(true);
    if (!ok) throw Exception("NOT_AUTH");

    final headers = await _headers(authenticated: true);

    final response = await http.get(
      _buildUri(endpoint),
      headers: headers,
    );

    return _handle(response, endpoint, "GET");
  }

  /// POST
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    required bool authenticated,
  }) async {
    http.Response response;
    if (authenticated) {
      final ok = await _checkAuth(true);
      if (!ok) throw Exception("NOT_AUTH");
      response = await http.post(
        _buildUri(endpoint),
        headers: await _headers(authenticated: true),
        body: jsonEncode(body),
      );
    } else {
      response = await http.post(
        _buildUri(endpoint),
        body: jsonEncode(body),
      );
    }
    return _handle(response, endpoint, "POST");
  }

  /// PUT
  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final ok = await _checkAuth(true);
    if (!ok) throw Exception("NOT_AUTH");

    final response = await http.put(
      _buildUri(endpoint),
      headers: await _headers(authenticated: true),
      body: jsonEncode(body),
    );

    return _handle(response, endpoint, "PUT");
  }

  /// DELETE
  static Future<dynamic> delete(String endpoint) async {
    final ok = await _checkAuth(true);
    if (!ok) throw Exception("NOT_AUTH");

    final response = await http.delete(
      _buildUri(endpoint),
      headers: await _headers(authenticated: true),
    );

    return _handle(response, endpoint, "DELETE");
  }

  static dynamic _handle(
    http.Response response,
    String endpoint,
    String method,
  ) {
    if (response.statusCode == 401) {
      TokenStorage.clear();
      throw Exception("you're not authorized (401)");
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        '$method $endpoint failed (${response.statusCode}) : ${response.body}',
      );
    }

    if (response.body.isEmpty) return null;

    return jsonDecode(response.body);
  }
}