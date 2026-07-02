import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_pages.dart';

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

  Future<void> register() async {
    try {
      await controller.register(
        email: emailController.text,
        username: usernameController.text,
        name: nameController.text,
        surname: surnameController.text,
        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur register: $e")),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Pseudo")),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: surnameController, decoration: const InputDecoration(labelText: "Prénom")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Mot de passe"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text("Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}