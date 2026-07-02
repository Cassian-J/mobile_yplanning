import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _userIdKey = "user_id";
  static const _tokenTypeKey = "token_type";
  static const _loginTimeKey = "login_time";

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int userId,
    required String tokenType,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
    await _storage.write(key: _userIdKey, value: userId.toString());
    await _storage.write(key: _tokenTypeKey, value: tokenType);

    // ⏱ stocke heure login
    await _storage.write(
      key: _loginTimeKey,
      value: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  static Future<String?> getAccessToken() =>
      _storage.read(key: _accessKey);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshKey);

  static Future<String?> getTokenType() =>
      _storage.read(key: _tokenTypeKey);

  static Future<int?> getUserId() async {
    final v = await _storage.read(key: _userIdKey);
    return v != null ? int.tryParse(v) : null;
  }

  static Future<DateTime?> getLoginTime() async {
    final v = await _storage.read(key: _loginTimeKey);
    if (v == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(int.parse(v));
  }

  static Future<void> clear() => _storage.deleteAll();
}