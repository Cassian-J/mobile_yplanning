import 'api_service.dart';
import '../models/group.dart';
import '../models/user.dart';

class GroupService {
  static Future<List<Group>> getUserGroups(int userId) async {
    final res = await ApiService.get('/group-user/user/$userId');
    if (res == null) return [];
    return (res as List)
        .map((e) => Group.fromJson(e))
        .toList();
  }

  static Future<List<User>> getGroupUsers(int groupId) async {
    final res = await ApiService.get('/group-user/group/$groupId');
    if (res == null) return [];
    return (res as List)
        .map((e) => User.fromJson(e))
        .toList();
  }
  
  static Future<void> createGroup(Map<String, dynamic> body) async {
    await ApiService.post('/groups', body,authenticated: true);
  }
}