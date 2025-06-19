import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/featurs/accounts/signin.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    // Animasi fade-in
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _visible = true);
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignInScreen()),
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
