import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'menu.dart'; // ← ini penting, agar bisa pindah ke HomeScreen

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    // Fade-in animasi
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _visible = true);
    });

    // Pindah ke HomeScreen setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          child: SvgPicture.asset(
            'assets/iconfitur/bann.png',
            width: 200,
            height: 200,
            semanticsLabel: 'Logo OOTDY',
          ),
        ),
      ),
    );
  }
}
