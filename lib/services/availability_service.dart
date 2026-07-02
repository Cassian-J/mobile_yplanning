import 'api_service.dart';

class AvailabilityService {
  static Future<List> getUserAvailability(int userId) async {
    return await ApiService.get('/users/$userId/availability');
  }

  static Future<void> createAvailability(Map<String, dynamic> body) async {
    await ApiService.post('/availability', body,authenticated: true);
  }

  static Future<void> updateAvailability(int id, Map<String, dynamic> body) async {
    await ApiService.put('/availability/$id', body,);
  }
}