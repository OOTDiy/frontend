import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'views/screen.dart'; // halaman utama setelah login
import 'featurs/accounts/signin.dart'; // halaman login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _handleAuthState(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _handleAuthState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Sudah login, langsung ke halaman utama
      return const Screen();
    } else {
      // Belum login, arahkan ke login screen
      return const SignInScreen();
    }
  }
}
