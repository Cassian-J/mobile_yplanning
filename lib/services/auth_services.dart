import 'api_services.dart';
import 'token_storage.dart';

class AuthService {
  /// LOGIN
  static Future<void> login({
    required String email,
    required String password,
    String? username,
  }) async {
    final res = await ApiService.post(
      '/auth/login',
      {
        "email": email,
        "password": password,
        "username": username ?? "",
      },
      authenticated: false,
    );

    await _saveAuth(res);
  }

  /// REGISTER
  static Future<void> register({
    required int colorId,
    required String email,
    required String name,
    required String password,
    required String surname,
    required String username,
  }) async {
    final res = await ApiService.post(
      '/auth/register',
      {
        "color_id": colorId,
        "email": email,
        "name": name,
        "password": password,
        "surname": surname,
        "username": username,
      },
      authenticated: false,
    );

    await _saveAuth(res);
  }

  /// REFRESH TOKEN
  static Future<void> refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();

    if (refreshToken == null) {
      throw Exception("Refresh token manquant");
    }

    final res = await ApiService.post(
      '/auth/refresh',
      {
        "refresh_token": refreshToken,
      },
      authenticated: false,
    );

    await _saveAuth(res);
  }

  /// LOGOUT
  static Future<void> logout() async {
    await TokenStorage.clear();
  }

  /// SAVE AUTH DATA
  static Future<void> _saveAuth(dynamic res) async {
    if (res is! Map) return;

    final accessToken = res["access_token"];
    final refreshToken = res["refresh_token"];
    final userId = res["id"];
    final tokenType = res["token_type"] ?? "Bearer";

    if (accessToken != null &&
        refreshToken != null &&
        userId != null) {
      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        tokenType: tokenType,
      );
    }
  }
}