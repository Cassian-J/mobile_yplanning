import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _userIdKey = "user_id";
  static const _tokenTypeKey = "token_type";

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
  }

  static Future<String?> getAccessToken() async =>
      _storage.read(key: _accessKey);

  static Future<String?> getRefreshToken() async =>
      _storage.read(key: _refreshKey);

  static Future<String?> getTokenType() async =>
      _storage.read(key: _tokenTypeKey);

  static Future<int?> getUserId() async {
    final value = await _storage.read(key: _userIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}