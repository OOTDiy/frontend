import 'package:flutter/material.dart';
import 'profile_header.dart';
import 'change_username.dart';
import 'change_email.dart';
import 'change_password.dart';
import 'faq.dart';
import 'terms_conditions.dart';
import 'privacy_policy.dart';
import 'about_us.dart';
import 'rating_us.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Kembali ke Styling/Wardrobe
        ),
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const ProfileHeader(),
            const SizedBox(height: 24),
            _buildSectionTitle("Account"),
            _buildTile(Icons.edit, "Change Username", () => _navigateTo(context, const ChangeUsernameScreen())),
            _buildTile(Icons.email, "Change E-mail", () => _navigateTo(context, const ChangeEmailScreen())),
            _buildTile(Icons.lock, "Change Password", () => _navigateTo(context, const ChangePasswordScreen())),
            const SizedBox(height: 24),
            _buildSectionTitle("Help"),
            _buildTile(Icons.help_outline, "FAQ", () => _navigateTo(context, const FaqScreen())),
            _buildTile(Icons.description_outlined, "Terms & Conditions", () => _navigateTo(context, const TermsConditionsScreen())),
            _buildTile(Icons.privacy_tip_outlined, "Privacy Policy", () => _navigateTo(context, const PrivacyPolicyScreen())),
            _buildTile(Icons.info_outline, "About Us", () => _navigateTo(context, const AboutUsScreen())),
            _buildTile(Icons.star_border, "Rating Us", () => _navigateTo(context, const RatingUsScreen())),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildTile(IconData icon, String text, VoidCallback onTap) => Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(text),
      onTap: onTap,
    ),
  );
}
