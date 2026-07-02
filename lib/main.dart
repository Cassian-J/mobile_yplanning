import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'helper/token_storage.dart';
import 'pages/login_page.dart';
import 'pages/user_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌍 Load .env
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getStartPage() async {
    final token = await TokenStorage.getAccessToken();
    final userId = await TokenStorage.getUserId();

    // 👉 si pas connecté → login
    if (token == null || userId == null) {
      return const LoginPage();
    }

    // 👉 sinon → user page
    return UserPage(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      home: FutureBuilder<Widget>(
        future: _getStartPage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data!;
        },
      ),
    );
  }
}