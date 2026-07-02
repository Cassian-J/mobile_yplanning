import '../services/group_service.dart';
import '../services/availability_service.dart';
import '../services/api_service.dart';

class UserController {
  List groups = [];
  List dates = [];
  List availability = [];

  bool loading = false;

  /// LOAD DASHBOARD USER (3 API CALLS)
  Future<void> loadUserData(int userId) async {
    loading = true;

    try {
      groups = await GroupService.getUserGroups(userId);

      dates = await ApiService.get('/users/$userId/dates');

      availability =
          await AvailabilityService.getUserAvailability(userId);
    } catch (e) {
      throw Exception("Erreur loadUserData: $e");
    }

    loading = false;
  }

  /// CREATE OR UPDATE AVAILABILITY
  Future<void> saveAvailability({
    required int userId,
    required int begin,
    required int end,
  }) async {
    final existing =
        await AvailabilityService.getUserAvailability(userId);

    if (existing.isEmpty) {
      await AvailabilityService.createAvailability({
        "date_begin": begin,
        "date_end": end,
        "user_id": userId,
      });
    } else {
      await AvailabilityService.updateAvailability(
        existing[0]["id"],
        {
          "date_begin": begin,
          "date_end": end,
        },
      );
    }

    // refresh local state
    availability =
        await AvailabilityService.getUserAvailability(userId);
  }

  /// CREATE DATE (agenda event)
  Future<void> createDate(Map<String, dynamic> body) async {
    await ApiService.post('/dates', body, authenticated: true);
  }
}