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

  @override
  void initState() {
    super.initState();
    controller.loadUserData(widget.userId).then((_) {
      setState(() {});
    });
  }

  Future<void> _logout() async {
    await authController.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ===== MAIN CONTENT (AGENDA) =====
          Column(
            children: [
              AppBar(
                title: const Text("Agenda"),
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    setState(() => menuOpen = true);
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: _logout,
                  ),
                ],
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: controller.dates.length,
                  itemBuilder: (context, index) {
                    final d = controller.dates[index];

                    final color = d["color"]?["hex_code"] ?? "#000000";

                    return Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(int.parse(color.replaceFirst('#', '0xff'))),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(d["title"]),
                    );
                  },
                ),
              ),

              /// bouton ajouter date
              ElevatedButton(
                onPressed: () => _openAddDatePopup(),
                child: const Text("Ajouter une date"),
              ),
            ],
          ),

          /// ===== BURGER MENU =====
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
                            onPressed: () {
                              setState(() => menuOpen = false);
                            },
                          ),
                        ),

                        /// GROUP LIST
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.groups.length,
                            itemBuilder: (context, index) {
                              final g = controller.groups[index];

                              return ListTile(
                                title: Text(g["name"]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => GroupPage(
                                        groupId: g["id"],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        /// CREATE GROUP BUTTON
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            onPressed: () => _openCreateGroupPopup(),
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

  void _openAddDatePopup() {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Ajouter date"),
        content: Text("TODO form date"),
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