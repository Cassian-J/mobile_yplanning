import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'register_page.dart';
import '../helper/token_storage.dart';
import 'user_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = AuthController();

  final loginController = TextEditingController();
  final passwordController = TextEditingController();


Future<void> login() async {
  try {
    await controller.login(
      loginInput: loginController.text,
      password: passwordController.text,
    );

    if (!mounted) return;

    // 🔥 SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login réussi")),
    );

    // 🔥 petit délai pour laisser voir le SnackBar
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // 🔥 récupération userId
    final userId = await TokenStorage.getUserId();

    if (userId == null || userId <= 0) {
      throw Exception("UserId introuvable");
    }

    if (!mounted) return;
    // 🔥 navigation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => UserPage(userId: userId),
      ),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur login: $e")),
    );
  }

  if (mounted) {
    setState(() {});
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: loginController,
              decoration: const InputDecoration(
                labelText: "Email ou pseudo",
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterPage(),
                  ),
                );
              },
              child: const Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}