import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../helper/token_storage.dart';
import 'user_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = AuthController();

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    setState(() => loading = true);

    try {
      // 🔥 1. register via controller
      await controller.register(
        email: emailController.text,
        username: usernameController.text,
        name: nameController.text,
        surname: surnameController.text,
        password: passwordController.text,
      );

      // 🔥 2. récupérer userId depuis secure storage
      final userId = await TokenStorage.getUserId();

      if (userId == null) {
        throw Exception("UserId introuvable après register");
      }

      if (!mounted) return;

      // 🔥 3. navigation vers user page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserPage(userId: userId),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur register: $e")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController),
            TextField(controller: usernameController),
            TextField(controller: nameController),
            TextField(controller: surnameController),
            TextField(controller: passwordController, obscureText: true),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : register,
              child: Text(loading ? "Loading..." : "Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}