import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'signin.dart';
import 'package:untitled1/views/profile/terms_conditions.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    bool agreeToTerms = false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 1),

                Image.asset(
                  'assets/iconfitur/bann.png',
                  width: 400,
                  height: 140,
                ),

                const SizedBox(height: 1),

                // Email
                _buildInputField('E-mail', 'Input e-mail', emailController),

                // Username
                _buildInputField('Username', 'Input username', usernameController),

                // Password
                _buildPasswordField('Password', 'Input password', passwordController),

                // Confirm Password
                _buildPasswordField('Confirm Password', 'Input password', confirmPasswordController),

                const SizedBox(height: 12),

                // Terms & conditions
                Row(
                  children: [
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Checkbox(
                          value: agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              agreeToTerms = value ?? false;
                            });
                          },
                        );
                      },
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: "I agree to OOTDIY's ",
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'terms & conditions',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const TermsConditionsScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Handle sign up logicnya di sini y
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7043), // Orange color
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Divider with OR
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or'),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),

                const SizedBox(height: 20),

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
                  label: const Text("Sign in with Google"),
                  onPressed: () {
                    // Google sign-in logic here
                  },
                ),
                const SizedBox(height: 32),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      String hint,
      TextEditingController controller,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordField(
      String label,
      String hint,
      TextEditingController controller,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        StatefulBuilder(
          builder: (context, setState) {
            bool _obscureText = true;
            return TextField(
              controller: controller,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: hint,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
