import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GroupPage extends StatefulWidget {
  final int groupId;

  const GroupPage({super.key, required this.groupId});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List users = [];

  @override
  void initState() {
    super.initState();
    loadGroupUsers();
  }

  Future<void> loadGroupUsers() async {
    final res =
        await ApiService.get('/groups/${widget.groupId}/users');

    setState(() {
      users = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Groupe")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final u = users[index];

          return ListTile(
            title: Text(u["username"]),
            subtitle: Text(u["email"]),
          );
        },
      ),
    );
  }
}