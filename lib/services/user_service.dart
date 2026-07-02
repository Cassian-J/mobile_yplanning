import 'api_service.dart';

class UserService {
  /// Récupère :
  /// - groupes
  /// - dates
  /// - availability
  static Future<Map<String, dynamic>> loadUserDashboard(int userId) async {
    final groups = await ApiService.get('/users/$userId/groups');

    final dates = await ApiService.get('/users/$userId/dates');

    final availability =
        await ApiService.get('/users/$userId/availability');

    return {
      "groups": groups,
      "dates": dates,
      "availability": availability,
    };
  }
}