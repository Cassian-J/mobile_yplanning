import 'token_storage.dart';
import '../services/auth_service.dart';

class AuthGuard {
  static const tokenLifetime = Duration(hours: 3);
  static const refreshThreshold = Duration(minutes: 30);

  /// retourne :
  /// - true = OK
  /// - false = logout requis
  static Future<bool> ensureValidToken() async {
    final loginTime = await TokenStorage.getLoginTime();

    if (loginTime == null) return false;

    final now = DateTime.now();
    final elapsed = now.difference(loginTime);
    final remaining = tokenLifetime - elapsed;

    // ❌ token mort
    if (remaining <= Duration.zero) {
      await TokenStorage.clear();
      return false;
    }

    // 🔄 refresh nécessaire
    if (remaining <= refreshThreshold) {
      try {
        await AuthService.refreshToken();
        return true;
      } catch (e) {
        await TokenStorage.clear();
        return false;
      }
    }

    return true;
  }
}