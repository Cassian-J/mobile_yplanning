import 'package:flutter/material.dart';
import '../services/group_service.dart';
import '../models/user.dart';

class GroupPage extends StatefulWidget {
  final int groupId;

  const GroupPage({super.key, required this.groupId});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<User> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadGroupUsers();
  }

  Future<void> loadGroupUsers() async {
    try {
      final res = await GroupService.getGroupUsers(widget.groupId);

      setState(() {
        users = res;
        loading = false;
      });
    } catch (e) {
      debugPrint("ERROR loadGroupUsers: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Groupe")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("Aucun utilisateur"))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index];

                    final username = u.username;
                    final email = u.email;

                    return ListTile(
                      title: Text(username),
                      subtitle: Text(email),
                    );
                  },
                ),
    );
  }
}