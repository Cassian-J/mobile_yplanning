import '../services/auth_services.dart';
import '../services/hash_helper.dart';

class AuthController {
  bool loading = false;

  /// LOGIN
  Future<void> login({
    required String loginInput, // email OU username
    required String password,
  }) async {
    loading = true;

    try {
      await AuthService.login(
        email: loginInput,
        username: loginInput,
        password: HashHelper.hashString(password),
      );
    } finally {
      loading = false;
    }
  }

  /// REGISTER
  Future<void> register({
    required String email,
    required String username,
    required String name,
    required String surname,
    required String password,
  }) async {
    loading = true;

    try {
      await AuthService.register(
        email: email,
        username: username,
        name: name,
        surname: surname,
        colorId: 0,
        password: HashHelper.hashString(password),
      );
    } finally {
      loading = false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await AuthService.logout();
  }
}