import 'api_service.dart';

class GroupService {
  static Future<List> getUserGroups(int userId) async {
    final res = await ApiService.get('/users/$userId/groups');

    return (res as List)
        .map((e) => e["group"])
        .toList();
  }

  static Future<List> getGroupUsers(int groupId) async {
    return await ApiService.get('/groups/$groupId/users');
  }
  
  static Future<void> createGroup(Map<String, dynamic> body) async {
    await ApiService.post('/groups', body,authenticated: true);
  }
}