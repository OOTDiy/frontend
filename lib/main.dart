import 'package:flutter/material.dart'; // ini halaman utama
import 'views/landing.dart';  // ini splash landing SVG

void main() {
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
      home: const LandingPage(), // ← Tampilkan LandingPage dulu
      debugShowCheckedModeBanner: false,
    );
  }
}
