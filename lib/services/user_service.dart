import 'group_service.dart';
import 'availability_service.dart';

class UserService {
  /// Récupère :
  /// - groupes
  /// - dates
  /// - availability
  static Future<Map<String, dynamic>> loadUserDashboard(int userId) async {
    if (userId <= 0) {
      throw Exception("Invalid user ID");
    }

    final groups = await GroupService.getUserGroups(userId);

    final dates = await AvailabilityService.getUserDate(userId);

    final availability = await AvailabilityService.getUserAvailability(userId);

    return {
      "groups": groups,
      "dates": dates,
      "availability": availability,
    };
  }
}