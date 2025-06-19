import 'package:flutter/material.dart';
import 'new_password.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String email;

  const OTPVerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Image.asset(
                    'assets/iconfitur/bann.png',
                    width: 400,
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    "Enter the code you received via email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      hintText: "Enter code",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF26A4B)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Resend code logicnya di sini y
                      },
                      child: const Text(
                        "Re-send code",
                        style: TextStyle(
                          color: Color(0xFFF26A4B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF26A4B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        // Anggap kodenya valid langsung lanjut ke screen reset password
                        if (codeController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResetPasswordScreen(email: email),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
