import '../services/group_service.dart';

class GroupController {
  List users = [];
  bool loading = false;

  /// LOAD USERS IN GROUP
  Future<void> loadGroupUsers(int groupId) async {
    loading = true;

    try {
      final res = await GroupService.getGroupUsers(groupId);
      users = res;
    } catch (e) {
      throw Exception("Erreur loadGroupUsers: $e");
    }

    loading = false;
  }

  /// CREATE GROUP
  Future<void> createGroup({
    required String name,
    required int creatorId,
  }) async {
    await GroupService.createGroup({
      "name": name,
      "creator_id": creatorId,
    });
  }
}