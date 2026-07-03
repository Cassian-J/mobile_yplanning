import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import 'group_page.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';

class UserPage extends StatefulWidget {
  final int userId;
  const UserPage({super.key, required this.userId});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controller = UserController();
  final authController = AuthController();

  bool menuOpen = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    controller.loadUserData(widget.userId).then((_) {
      if (!mounted) return;
      setState(() => loading = false);
    }).catchError((e) {
      if (!mounted) return;
      setState(() => loading = false);
      debugPrint("ERROR loadUserData: $e");
    });
  }

  Future<void> _logout() async {
    await authController.logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ================= MAIN =================
          Column(
            children: [
              AppBar(
                title: const Text("Agenda"),
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => setState(() => menuOpen = true),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: _logout,
                  ),
                ],
              ),

              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.dates.isEmpty
                        ? const Center(child: Text("Aucune date"))
                        : ListView.builder(
                            itemCount: controller.dates.length,
                            itemBuilder: (context, index) {
                              final d = controller.dates[index];

                              final title = d.title; // ✅ Freezed
                              return ListTile(
                                title: Text(title),
                              );
                            },
                          ),
              ),
            ],
          ),

          /// ================= BURGER MENU =================
          if (menuOpen)
            Positioned.fill(
              child: Material(
                color: Colors.black54,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 300,
                    color: Colors.white,
                    child: Column(
                      children: [
                        AppBar(
                          title: const Text("Groupes"),
                          leading: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => menuOpen = false),
                          ),
                        ),

                        Expanded(
                          child: controller.groups.isEmpty
                              ? const Center(child: Text("Aucun groupe"))
                              : ListView.builder(
                                  itemCount: controller.groups.length,
                                  itemBuilder: (context, index) {
                                    final g = controller.groups[index];

                                    return ListTile(
                                      title: Text(g.name), // ✅ Freezed
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => GroupPage(
                                              groupId: g.id, // ✅ Freezed
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            onPressed: _openCreateGroupPopup,
                            child: const Text("Créer un groupe"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openCreateGroupPopup() {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Créer groupe"),
        content: Text("TODO form group"),
      ),
    );
  }
}