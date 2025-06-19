import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/views/menu.dart';
import 'signup.dart';
import 'forgot_password.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo Placeholder
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/iconfitur/bann.png',
                        width: 400,
                        height: 140,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 1),

                // Username field
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Username"),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Input username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Password"),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Input password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.visibility),
                  ),
                ),
                const SizedBox(height: 8),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Sign in Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Replace this with your actual sign in logic
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign in with Google
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.redAccent),
                  ),
                  icon: SvgPicture.asset(
                    'assets/iconfitur/google-button.svg',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(color: Colors.black),
                  ),

                  onPressed: () {
                    // Google sign-in logic here
                  },
                ),
                const SizedBox(height: 32),

                // Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline, // <-- garis bawah
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
