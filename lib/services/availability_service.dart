import 'api_service.dart';
import '../models/availability.dart';
import '../models/date.dart';

class AvailabilityService {
  static Future<List<Availability>> getUserAvailability(int userId) async {
    final res =await ApiService.get('/availability/user/$userId');
    if (res == null) return [];

    return (res as List)
        .map((e) => Availability.fromJson(e))
        .toList();
  }

  static Future<List<Date>> getUserDate(int userId) async {
    final res =await ApiService.get('/date/user/$userId');
    if (res == null) return [];

    return (res as List)
        .map((e) => Date.fromJson(e))
        .toList();
  }

  static Future<void> createAvailability(Map<String, dynamic> body) async {
    final res =await ApiService.post('/availability', body,authenticated: true);
  }

  static Future<void> updateAvailability(int id, Map<String, dynamic> body) async {
    final res =await ApiService.put('/availability/$id', body,);
  }
}