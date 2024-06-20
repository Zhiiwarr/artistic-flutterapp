import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marketplace_app/home_page.dart';

import 'package:marketplace_app/login_page.dart';
import 'package:marketplace_app/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Set the initial route to login
      routes: {
        '/': (context) => const HomePage(), // Add route for home page
        '/login': (context) => const LoginPage(), // Route for login page
        '/register': (context) =>
            const RegisterPage(), // Route for register page
      },
    );
  }
}
